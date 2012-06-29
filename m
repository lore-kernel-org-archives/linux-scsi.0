From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH] BNX2I: Removed the reference to the netdev->base_addr
Date: Fri, 29 Jun 2012 16:37:35 -0700
Message-ID: <1341013055-16339-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1191 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab2F2XiG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jun 2012 19:38:06 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The netdev->base_addr parameter has been deprecated in the L2 bnx2
driver.  This is used by bnx2i for the BARn iomapping.

This patch will directly reference the pci_resource_start instead
of using the deprecated netdev->base_addr.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h       |    1 +
 drivers/scsi/bnx2i/bnx2i_hwi.c   |    3 +--
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 0c53c28..7e77cf6 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -350,6 +350,7 @@ struct bnx2i_hba {
 	struct pci_dev *pcidev;
 	struct net_device *netdev;
 	void __iomem *regview;
+	resource_size_t reg_base;
 
 	u32 age;
 	unsigned long cnic_dev_type;
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index ece47e5..86a12b4 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -2724,7 +2724,6 @@ int bnx2i_map_ep_dbell_regs(struct bnx2i_endpoint *ep)
 		goto arm_cq;
 	}
 
-	reg_base = ep->hba->netdev->base_addr;
 	if ((test_bit(BNX2I_NX2_DEV_5709, &ep->hba->cnic_dev_type)) &&
 	    (ep->hba->mail_queue_access == BNX2I_MQ_BIN_MODE)) {
 		config2 = REG_RD(ep->hba, BNX2_MQ_CONFIG2);
@@ -2740,7 +2739,7 @@ int bnx2i_map_ep_dbell_regs(struct bnx2i_endpoint *ep)
 		/* 5709 device in normal node and 5706/5708 devices */
 		reg_off = CTX_OFFSET + (MB_KERNEL_CTX_SIZE * cid_num);
 
-	ep->qp.ctx_base = ioremap_nocache(reg_base + reg_off,
+	ep->qp.ctx_base = ioremap_nocache(ep->hba->reg_base + reg_off,
 					  MB_KERNEL_CTX_SIZE);
 	if (!ep->qp.ctx_base)
 		return -ENOMEM;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f8d516b..621538b 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -811,13 +811,13 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 	bnx2i_identify_device(hba);
 	bnx2i_setup_host_queue_size(hba, shost);
 
+	hba->reg_base = pci_resource_start(hba->pcidev, 0);
 	if (test_bit(BNX2I_NX2_DEV_5709, &hba->cnic_dev_type)) {
-		hba->regview = ioremap_nocache(hba->netdev->base_addr,
-					       BNX2_MQ_CONFIG2);
+		hba->regview = pci_iomap(hba->pcidev, 0, BNX2_MQ_CONFIG2);
 		if (!hba->regview)
 			goto ioreg_map_err;
 	} else if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type)) {
-		hba->regview = ioremap_nocache(hba->netdev->base_addr, 4096);
+		hba->regview = pci_iomap(hba->pcidev, 0, 4096);
 		if (!hba->regview)
 			goto ioreg_map_err;
 	}
@@ -884,7 +884,7 @@ cid_que_err:
 	bnx2i_free_mp_bdt(hba);
 mp_bdt_mem_err:
 	if (hba->regview) {
-		iounmap(hba->regview);
+		pci_iounmap(hba->pcidev, hba->regview);
 		hba->regview = NULL;
 	}
 ioreg_map_err:
@@ -910,7 +910,7 @@ void bnx2i_free_hba(struct bnx2i_hba *hba)
 	pci_dev_put(hba->pcidev);
 
 	if (hba->regview) {
-		iounmap(hba->regview);
+		pci_iounmap(hba->pcidev, hba->regview);
 		hba->regview = NULL;
 	}
 	bnx2i_free_mp_bdt(hba);
-- 
1.7.7.4


