From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: mpt fusion driver performance issue in 2.6.14-rc2
Date: Tue, 11 Oct 2005 18:10:46 -0700
Message-ID: <200510120111.j9C1B9g14181@unix-os.sc.intel.com>
References: <001a01c5c650$25719050$1b1015ac@ericmoore>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr23.intel.com ([143.183.121.15]:28610 "EHLO
	scsfmr003.sc.intel.com") by vger.kernel.org with ESMTP
	id S932382AbVJLBLU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Oct 2005 21:11:20 -0400
In-Reply-To: <001a01c5c650$25719050$1b1015ac@ericmoore>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Moore, Eric Moore'" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>

On Friday, September 30, 2005 6:27 PM, Chen, Kenneth W wrote:
> Chen, Kenneth W  wrote on Thursday, September 29, 2005 11:59 AM
>> Something happened in between kernel 2.6.12 and 2.6.14-rc2, where
>> disk performance went 20X slower on the latest release kernel. I
>> suspect it has something to do with the fusion driver. This showed
>> up in the boot log: "mptscsih: ioc0: DV: Release failed." is it
>> significant?
>
> I think the bug is for real, and it is in the mpt fusion driver.  I'm
> not an expert of LSI53C1030 host controller, and I won't pretend to be
> one. Though I have data to show what is going on:
>
> There are two threads during driver initialization.  One does domain
> validation (mptscsih_domainValidation) and one does host controller
> initialization (mptspi_probe).  During 2nd host controller bringup,
> i.e., bringing up ioc1, it temporary disables first channel (ioc0).
> However, DV is in progress on ioc0 in another thread (and possibly
> running on another CPU).  The effect of disabling ioc0 during in-
> progress-domain-validation is that it causes all subsequent DV
> commands to fail and resulting lowest possible performance setting
> for almost all disks pending DV.
>
> Here is a fix that I propose: for the period that ioc0 need to be
> disabled for bringing up ioc1, ioc->active is marked with a special
> flag and have DV thread busy wait on that flag.  This avoid mptspi_probe
> thread clash into the DV thread causing brain-damage to DV.
>
> With the patch, all disks are up to the performance expectation and it
> also fixed the "mptscsih: ioc0: DV: Release failed" error message.
>

Moore, Eric Moore wrote on Friday, September 30, 2005 11:20 PM
> Thanks for you findings into this.
> 
> I'm moving across town, and will not be in the office, nor have
> internet access for the next couple days.  I will look into this when
> I return.

Any time frame when this is going to be looked into and have the bug
fixed?  If no objection, please apply.

Simple "hdparm -t" shows:

vanilla 2.6.14-rc3:
 Timing buffered disk reads:    8 MB in  3.16 seconds =   2.53 MB/sec

2.6.14-rc3 + patch:
 Timing buffered disk reads:  174 MB in  3.02 seconds =  57.55 MB/sec


---

Fix race between domain validation and host controller initialization
for mpt fusion driver.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>

--- ./drivers/message/fusion/mptbase.c.orig	2005-09-30 17:16:16.051906000 -0700
+++ ./drivers/message/fusion/mptbase.c	2005-09-30 17:18:50.811670000 -0700
@@ -740,8 +740,12 @@ mpt_get_msg_frame(int handle, MPT_ADAPTE
 #endif
 
 	/* If interrupts are not attached, do not return a request frame */
-	if (!ioc->active)
-		return NULL;
+	if (ioc->active <= 0) {
+		while (ioc->active == -1)
+			schedule_timeout_uninterruptible(1);
+		if (!ioc->active)
+			return NULL;
+	}
 
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 	if (!list_empty(&ioc->FreeQ)) {
@@ -1495,7 +1499,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 
 		/* Disable alt-IOC's reply interrupts (and FreeQ) for a bit ... */
 		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, 0xFFFFFFFF);
-		ioc->alt_ioc->active = 0;
+		ioc->alt_ioc->active = -1;
 	}
 
 	hard = 1;

