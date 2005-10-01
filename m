From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: mpt fusion driver performance issue in 2.6.14-rc2
Date: Fri, 30 Sep 2005 17:27:43 -0700
Message-ID: <200510010027.j910Rhg30932@unix-os.sc.intel.com>
References: <B05667366EE6204181EABE9C1B1C0EB50484F7D4@scsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr24.intel.com ([143.183.121.16]:23451 "EHLO
	scsfmr004.sc.intel.com") by vger.kernel.org with ESMTP
	id S1750702AbVJAA1x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 20:27:53 -0400
In-Reply-To: <B05667366EE6204181EABE9C1B1C0EB50484F7D4@scsmsx401.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "'Moore, Eric Dean'" <Eric.Moore@lsil.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>

Chen, Kenneth W  wrote on Thursday, September 29, 2005 11:59 AM
> Something happened in between kernel 2.6.12 and 2.6.14-rc2, where
> disk performance went 20X slower on the latest release kernel. I
> suspect it has something to do with the fusion driver. This showed
> up in the boot log: "mptscsih: ioc0: DV: Release failed." is it
> significant?

I think the bug is for real, and it is in the mpt fusion driver.  I'm
not an expert of LSI53C1030 host controller, and I won't pretend to be
one. Though I have data to show what is going on:

There are two threads during driver initialization.  One does domain
validation (mptscsih_domainValidation) and one does host controller
initialization (mptspi_probe).  During 2nd host controller bringup,
i.e., bringing up ioc1, it temporary disables first channel (ioc0).
However, DV is in progress on ioc0 in another thread (and possibly
running on another CPU).  The effect of disabling ioc0 during in-
progress-domain-validation is that it causes all subsequent DV
commands to fail and resulting lowest possible performance setting
for almost all disks pending DV.

Here is a fix that I propose: for the period that ioc0 need to be
disabled for bringing up ioc1, ioc->active is marked with a special
flag and have DV thread busy wait on that flag.  This avoid mptspi_probe
thread clash into the DV thread causing brain-damage to DV.

With the patch, all disks are up to the performance expectation and it
also fixed the "mptscsih: ioc0: DV: Release failed" error message.

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

