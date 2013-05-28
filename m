From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 0/6] scsi_debug: bug fixes and cleanups for data integrity
 support
Date: Tue, 28 May 2013 15:29:03 -0400
Message-ID: <51A5057F.9030703@interlog.com>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51606 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab3E1T3S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 May 2013 15:29:18 -0400
In-Reply-To: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Perhaps I'm missing something but I can never get
DIF stuff to do what I want in scsi_debug. It was
like this before your patches as well.

Assume this set up:
# lsscsi -gp
[1:0:0:0]    disk    ATA      ST3320620AS      3.AA  /dev/sda   /dev/sg0   - 
       -
[6:0:9:0]    disk    SEAGATE  ST33000650SS     0002  /dev/sdb   /dev/sg2 
DIF/Type1  -
[7:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdc   /dev/sg3 
DIF/Type1  -

So 6:0:9:0 is a real disk formatted with protection type 1
and 7:0:0:0 is simulating the same thing (with scsi_debug).
Now I try to read the first block with RDPROTECT=1 so in
the data-out buffer I expect the LB plus the protection
info. That as 512+8 bytes. So now I use ddpt to read the
first block plus PI from the Seagate disk:

# ddpt if=/dev/sg2 bs=512 verbose=3 protect=1 count=1
   ....
Output file not specified so no copy, just reading input
     READ cdb: 28 20 00 00 00 00 00 00 01 00
1+0 records in
0+0 records out
time to read data: 0.000574 secs at 892.0 KB/sec

Good, asked for 520 bytes and got them. But when I try
that with scsi_debug disk:

# ddpt if=/dev/sg3 bs=512 verbose=3 protect=1 count=1
...
Output file not specified so no copy, just reading input
     READ cdb: 28 20 00 00 00 00 00 00 01 00
     READ: pass-through requested 520 bytes but got 512 bytes
1+0 records in
0+0 records out
 >> Non-zero sum of residual counts=8
time to read data: 0.000833 secs at 614.6 KB/sec

No PI, why not? This was tested on lk 3.9.4 with your patches
applied.

Doug Gilbert


On 13-05-26 04:01 AM, Akinobu Mita wrote:
> This patch set includes bug fixes which I hit when I was tried testing
> the data integrity support in scsi_debug on x86_32.
>
> And it also includes cleanups which helps increasing readability and
> further bug fixing in data integrity support.
>
> * Changes from v2
> - Add new bug fix patch for UNMAP command support
> - Change the way to fix for the patch "fix invalid address passed to
>    kunmap_atomic()"
> - Reduce more lines of code for the patch "reduce duplication between
>    prot_verify_read and prot_verify_writ"
>
> * Changes from v1
> - Split the patch "fix data integrity support on highmem machine" into
>    two separate patches.
> - Add new cleanup patch "reduce duplication between prot_verify_read and
>    prot_verify_write".
>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
>
> Akinobu Mita (6):
>    scsi_debug: fix invalid address passed to kunmap_atomic()
>    scsi_debug: fix incorrectly nested kmap_atomic()
>    scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
>    scsi_debug: invalidate protection info for unmapped region
>    scsi_debug: simplify offset calculation for dif_storep
>    scsi_debug: reduce duplication between prot_verify_read and
>      prot_verify_write
>
>   drivers/scsi/scsi_debug.c | 176 +++++++++++++++++++---------------------------
>   1 file changed, 72 insertions(+), 104 deletions(-)
>

