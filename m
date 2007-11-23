From: Hannes Reinecke <hare@suse.de>
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
Date: Fri, 23 Nov 2007 12:38:05 +0100
Message-ID: <4746BB9D.2030508@suse.de>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	<4744A6F2.4030302@free.fr> <20071121144116.c932727b.akpm@linux-foundation.org> <4746814F.80502@free.fr> <4746866B.5070207@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090908090105070907070609"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4746866B.5070207@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Laurent Riffard <laurent.riffard@free.fr>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090908090105070907070609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hannes Reinecke wrote:
> Laurent Riffard wrote:
>> Le 21.11.2007 23:41, Andrew Morton a écrit :
>>> On Wed, 21 Nov 2007 22:45:22 +0100
>>> Laurent Riffard <laurent.riffard@free.fr> wrote:
>>>
>>>> Le 21.11.2007 05:45, Andrew Morton a écrit :
>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/
>>>> Hello, 
>>>>
>>>> My system hangs shortly after I logged in Gnome desktop. SysRq-W shows
>>>> that a bunch of task are blocked in "D" state, they seem to wait for
>>>> some I/O completion. I can try to hand-copy some data if requested.
>>>>
>>>> I found these messages in dmesg:
>>>>
>>>> ~$ grep -C2 end_request dmesg-2.6.24-rc3-mm1 
>>>> EXT3-fs: mounted filesystem with ordered data mode.
>>>> sd 0:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>>>> end_request: I/O error, dev sda, sector 16460
>>>> ReiserFS: sda7: found reiserfs format "3.6" with standard journal
>>>> ReiserFS: sda7: using ordered data mode
>>>> --
>>>> ReiserFS: sda7: Using r5 hash to sort names
>>>> sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>>>> end_request: I/O error, dev sdb, sector 19632
>>>> sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>>>> end_request: I/O error, dev sdb, sector 40037363
>>>> Adding 1048568k swap on /dev/mapper/vglinux1-lvswap.  Priority:-1 extents:1 across:1048568k
>>>> lp0: using parport0 (interrupt-driven).
>>>>
>>>> These errors occur *only* with 2.6.24-rc3-mm1, they are 100% reproducible.
>>>> 2.6.24-rc3 and 2.6.24-rc2-mm1 are fine.
>>>>
>>>> Maybe something is broken in pata_via driver ?
>>>>
>>> Could be - libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
>>> and pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
>>> touch pata_via.c.
>> None of the above...
>>
>> I did a bisection, it spotted git-scsi-misc.patch. 
>> I just run 2.6.24-rc3-mm1 + revert-git-scsi-misc.patch, and it works fine.
>>
>> I guess commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0 "[SCSI] Do not 
>> requeue requests if REQ_FAILFAST is set" is the real culprit. The other 
>> commits are touching documentation or drivers I don't use. I'll try 
>> to revert only this one this evening.
>>
> Hmm. Weird. I'll have a look into it. Apparently I'll be returning an error where
> I shouldn't. Checking ...
> 
Ok, found it. We are blocking even special commands (ie requests with PREEMPT not set)
when FAILFAST is set. Which is clearly wrong. The attached patch fixes this.

James, please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------090908090105070907070609
Content-Type: text/plain;
 name="scsi-misc-fix-spi-validation"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-misc-fix-spi-validation"

Fix SPI Domain validation

This fixes a thinko of the FAILFAST handling: when we get
a request with FAILFAST set, we still have to evaluate the
PREEMPT flag to decide if this request should be passed through.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 13e7e09..9ec1566 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1284,13 +1284,15 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			/*
 			 * If the devices is blocked we defer normal commands.
 			 */
-			if (!(req->cmd_flags & REQ_PREEMPT))
-				ret = BLKPREP_DEFER;
-			/*
-			 * Return failfast requests immediately
-			 */
-			if (req->cmd_flags & REQ_FAILFAST)
-				ret = BLKPREP_KILL;
+			if (!(req->cmd_flags & REQ_PREEMPT)) {
+				/*
+				 * Return failfast requests immediately
+				 */
+				if (req->cmd_flags & REQ_FAILFAST)
+					ret = BLKPREP_KILL;
+				else
+					ret = BLKPREP_DEFER;
+			}
 			break;
 		default:
 			/*

--------------090908090105070907070609--
