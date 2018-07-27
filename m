From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] message: fusion: Replace GFP_ATOMIC with GFP_KERNEL
Date: Fri, 27 Jul 2018 11:47:39 +0800
Message-ID: <20180727034739.4513-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

mpt_attach() and mptfc_probe() are never called in atomic context.
They call kzalloc() and kcalloc() with GFP_ATOMIC, which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/message/fusion/mptbase.c | 2 +-
 drivers/message/fusion/mptfc.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 51eb1b027963..64aee8c96641 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1779,7 +1779,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct proc_dir_entry *dent;
 #endif
 
-	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
+	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_KERNEL);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 		return -ENOMEM;
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 6d461ca97150..1febf4dfa944 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1292,7 +1292,7 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* SCSI needs scsi_cmnd lookup table!
 	 * (with size equal to req_depth*PtrSz!)
 	 */
-	ioc->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
+	ioc->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_KERNEL);
 	if (!ioc->ScsiLookup) {
 		error = -ENOMEM;
 		goto out_mptfc_probe;
-- 
2.17.0
