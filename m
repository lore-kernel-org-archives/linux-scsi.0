From: Bernd Schubert <bs@q-leap.de>
Subject: [ PATCH 1/3 ] rename diagPending to ioc_reset_in_progress.
Date: Fri, 6 Feb 2009 14:18:34 +0100
Message-ID: <200902061418.36140.bs@q-leap.de>
References: <200902061408.46652.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:59593 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbZBFNSj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 08:18:39 -0500
In-Reply-To: <200902061408.46652.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, Andrew Morton <akpm@linux-foundation.org>

Replace diagPending by ioc_reset_in_progress. Similarily to the fusion-4.17 
driver.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

---
 drivers/message/fusion/mptbase.c  |   16 +++++++++-------
 drivers/message/fusion/mptbase.h  |    2 +-
 drivers/message/fusion/mptscsih.c |    3 ++-
 3 files changed, 12 insertions(+), 9 deletions(-)

Index: linus-git/drivers/message/fusion/mptbase.c
===================================================================
--- linus-git.orig/drivers/message/fusion/mptbase.c
+++ linus-git/drivers/message/fusion/mptbase.c
@@ -290,7 +290,7 @@ mpt_fault_reset_work(struct work_struct 
 	int		 rc;
 	unsigned long	 flags;
 
-	if (ioc->diagPending || !ioc->active)
+	if (ioc->ioc_reset_in_progress || !ioc->active)
 		goto out;
 
 	ioc_raw_state = mpt_GetIocState(ioc, 0);
@@ -1655,7 +1655,7 @@ mpt_attach(struct pci_dev *pdev, const s
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
 
 	ioc->pcidev = pdev;
-	ioc->diagPending = 0;
+	ioc->ioc_reset_in_progress = 0;
 	spin_lock_init(&ioc->diagLock);
 	spin_lock_init(&ioc->initializing_hba_lock);
 
@@ -6411,12 +6411,14 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 	 * mpt_do_ioc_recovery at any instant in time.
 	 */
 	spin_lock_irqsave(&ioc->diagLock, flags);
-	if ((ioc->diagPending) || (ioc->alt_ioc && ioc->alt_ioc->diagPending)){
+	if ((ioc->ioc_reset_in_progress)
+	|| (ioc->alt_ioc && ioc->alt_ioc->ioc_reset_in_progress)) {
 		spin_unlock_irqrestore(&ioc->diagLock, flags);
 		return 0;
-	} else {
-		ioc->diagPending = 1;
 	}
+	ioc->ioc_reset_in_progress = 1;
+	if (ioc->alt_ioc)
+		ioc->alt_ioc->ioc_reset_in_progress = 1;
 	spin_unlock_irqrestore(&ioc->diagLock, flags);
 
 	/* FIXME: If do_ioc_recovery fails, repeat....
@@ -6453,9 +6455,9 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 		ioc->alt_ioc->reload_fw = 0;
 
 	spin_lock_irqsave(&ioc->diagLock, flags);
-	ioc->diagPending = 0;
+	ioc->ioc_reset_in_progress = 0;
 	if (ioc->alt_ioc)
-		ioc->alt_ioc->diagPending = 0;
+		ioc->alt_ioc->ioc_reset_in_progress = 0;
 	spin_unlock_irqrestore(&ioc->diagLock, flags);
 
 	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler rc = %d!\n", ioc->name, rc));
Index: linus-git/drivers/message/fusion/mptbase.h
===================================================================
--- linus-git.orig/drivers/message/fusion/mptbase.h
+++ linus-git/drivers/message/fusion/mptbase.h
@@ -644,7 +644,7 @@ typedef struct _MPT_ADAPTER
 	struct proc_dir_entry	*ioc_dentry;
 	struct _MPT_ADAPTER	*alt_ioc;	/* ptr to 929 bound adapter port */
 	spinlock_t		 diagLock;	/* diagnostic reset lock */
-	int			 diagPending;
+	u8			 ioc_reset_in_progress;
 	u32			 biosVersion;	/* BIOS version from IO Unit Page 2 */
 	int			 eventTypes;	/* Event logging parameters */
 	int			 eventContext;	/* Next event context */
Index: linus-git/drivers/message/fusion/mptscsih.c
===================================================================
--- linus-git.orig/drivers/message/fusion/mptscsih.c
+++ linus-git/drivers/message/fusion/mptscsih.c
@@ -1561,7 +1561,8 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 	// SJR - CHECKME - Can we avoid this here?
 	// (mpt_HardResetHandler has this check...)
 	spin_lock_irqsave(&ioc->diagLock, flags);
-	if ((ioc->diagPending) || (ioc->alt_ioc && ioc->alt_ioc->diagPending)) {
+	if ((ioc->ioc_reset_in_progress)
+	|| (ioc->alt_ioc && ioc->alt_ioc->ioc_reset_in_progress)) {
 		spin_unlock_irqrestore(&ioc->diagLock, flags);
 		return FAILED;
 	}



-- 
Bernd Schubert
Q-Leap Networks GmbH
