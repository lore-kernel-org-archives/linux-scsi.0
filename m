From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] git scsi misc include fix
Date: Mon, 15 Oct 2007 21:07:17 -0400
Message-ID: <1192496837.14524.26.camel@localhost.localdomain>
References: <20071014053508.30836.69658.sendpatchset@jackhammer.engr.sgi.com>
	 <1192491330.14524.16.camel@localhost.localdomain>
	 <20071015170842.9cfe4846.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38782 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753701AbXJPBH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 21:07:26 -0400
In-Reply-To: <20071015170842.9cfe4846.pj@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Jackson <pj@sgi.com>
Cc: akpm@linux-foundation.org, willy@linux.intel.com, linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>

On Mon, 2007-10-15 at 17:08 -0700, Paul Jackson wrote:
> James wrote:
> > The requirement for struct scatterlist is the same
> > before and after the gid scsi-misc patch. 
> 
> Not so.  The git-scsi-misc.patch in 2.6.23-mm1 clearly adds the line:
> 
>     struct scatterlist sense_sgl;
> 
> as part of the added struct scsi_eh_save in scsi/scsi_eh.h.
> 
> This bit me while I was doing a bisection on 2.6.23-mm1, for another
> problem, in git-sched, which is discussed in the lkml thread:
> 
>     git-sched patch won't boot on SN arch, 2.6.23-mm1
> 
> This is using sn2_defconfig.  The full 2.6.23-mm1 patch set builds ok,
> because another patch, git-block.patch as I recall, includes
> scatterlist.h some other way, but for the following range of patches in
> 2.6.23-mm1, on the configuration sn2_defconfig, the build is broken,
> due to 'struct scatterlist' being an incomplete type:
> 
>     git-scsi-misc.patch
>     git-scsi-misc-include-fix.patch
>     git-scsi-misc-fixup.patch
>     qla2xxx-printk-fixes.patch
>     pci-error-recovery-symbios-scsi-base-support.patch
>     pci-error-recovery-symbios-scsi-first-failure.patch
>     nsp32_restart_autoscsi-remove-error-check.patch
>     scsi-send-media-state-change-modification-events.patch
>     scsi-early-detection-of-medium-not-present-updated.patch
>     mptbase-reset-ioc-initiator-during-pci-resume.patch
>     scsi-use-notifier-chain-for-asynchronous-event.patch
>     initio-fix-conflict-when-loading-driver.patch
>     git-block.patch
> 
> > it should also fail with vanilla 2.6.23
> 
> I don't know about the vanilla 2.6.23 case.

Ah, right, sorry ... on the ball now.  I thought you were saying that
the scsi_error.c compilation was failing.  In that case, the correct fix
is actually to move the scatterlist include from scsi_error.c (where the
scatterlist was originally used locally) into scsi_eh.h, like this.

James

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d29f846..ebaca4c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -24,7 +24,6 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
-#include <linux/scatterlist.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 44224ba..d21b891 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -1,6 +1,8 @@
 #ifndef _SCSI_SCSI_EH_H
 #define _SCSI_SCSI_EH_H
 
+#include <linux/scatterlist.h>
+
 #include <scsi/scsi_cmnd.h>
 struct scsi_device;
 struct Scsi_Host;


