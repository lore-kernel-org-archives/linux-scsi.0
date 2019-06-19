From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Wed, 19 Jun 2019 11:42:44 +0200
Message-ID: <f1f98ab0-399a-6c12-073d-ee8ad47d5588@free.fr>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
 <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org>
 <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com>
 <alpine.LNX.2.21.1906181107240.287@nippy.intranet>
 <017cf3cf-ecd8-19c2-3bbd-7e7c28042c3c@free.fr>
 <f8339103-5b45-b72d-9f87-fd4dd7b3081e@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f8339103-5b45-b72d-9f87-fd4dd7b3081e@interlog.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 18/06/2019 17:31, Douglas Gilbert wrote:

> On 2019-06-18 3:29 a.m., Marc Gonzalez wrote:
> 
>> Please note that I am _in no way_ suggesting that we remove any code.
>>
>> I just think it might be time to stop forcing CONFIG_SCSI_PROC_FS into
>> every config, and instead require one to explicitly request the aging
>> feature (which makes CONFIG_SCSI_PROC_FS show up in a defconfig).
>>
>> Maybe we could add CONFIG_SCSI_PROC_FS to arch/x86/configs/foo ?
>> (For which foo? In a separate patch or squashed with this one?)
> 
> Since current sg driver usage seems to depend more on SCSI_PROC_FS
> being "y" than other parts of the SCSI subsystem then if
> SCSI_PROC_FS is to default to "n" in the future then a new
> CONFIG_SG_PROC_FS variable could be added.
> 
> If CONFIG_CHR_DEV_SG is "*" or "m" then default CONFIG_SG_PROC_FS
> to "y"; if CONFIG_SCSI_PROC_FS is "y" then default CONFIG_SG_PROC_FS
> to "y"; else default CONFIG_SG_PROC_FS to "n". Obviously the
> sg driver would need to be changed to use CONFIG_SG_PROC_FS instead
> of CONFIG_SCSI_PROC_FS .

I like your idea, and I think it might even be made slightly simpler.

I assume sg3_utils requires CHR_DEV_SG. Is it the case?

If so, we would just need to enable SCSI_PROC_FS when CHR_DEV_SG is enabled.

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 73bce9b6d037..642ca0e7d363 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -54,14 +54,12 @@ config SCSI_NETLINK
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
 	depends on SCSI && PROC_FS
-	default y
+	default CHR_DEV_SG
 	---help---
 	  This option enables support for the various files in
 	  /proc/scsi.  In Linux 2.6 this has been superseded by
 	  files in sysfs but many legacy applications rely on this.
 
-	  If unsure say Y.
-
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 

Would that work for you?
I checked that SCSI_PROC_FS=y whether CHR_DEV_SG=y or m
I can spin a v2, with a blurb about how sg3_utils relies on SCSI_PROC_FS.

> Does that defeat the whole purpose of your proposal or could it be
> seen as a partial step in that direction? What is the motivation
> for this proposal?

The rationale was just to look for "special-purpose" options that are
enabled by default, and change the default wherever possible, as a
matter of uniformity.

> BTW We still have the non-sg related 'cat /proc/scsi/scsi' usage
> and 'cat /proc/scsi/device_info'. And I believe the latter one is
> writable even though its permissions say otherwise.

Any relation between SG and BSG?

Regards.
