From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/9] lpfc 8.2.3 : Temperature handling fix
Date: Sat, 27 Oct 2007 13:38:11 -0400
Message-ID: <1193506691.8770.28.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46378 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbXJ0RiG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 13:38:06 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9RHc4ra021400
	for <linux-scsi@vger.kernel.org>; Sat, 27 Oct 2007 10:38:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Temperature handling fix - return proper error code indicator for applications

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-10-27 13:11:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-10-27 13:15:46.000000000 -0400
@@ -979,6 +979,12 @@ lpfc_soft_wwpn_store(struct class_device
 	unsigned int i, j, cnt=count;
 	u8 wwpn[8];
 
+	spin_lock_irq(&phba->hbalock);
+	if (phba->over_temp_state == HBA_OVER_TEMP) {
+		spin_unlock_irq(&phba->hbalock);
+		return -EPERM;
+	}
+	spin_unlock_irq(&phba->hbalock);
 	/* count may include a LF at end of string */
 	if (buf[cnt-1] == '\n')
 		cnt--;
@@ -1750,6 +1756,12 @@ sysfs_mbox_read(struct kobject *kobj, st
 
 	spin_lock_irq(&phba->hbalock);
 
+	if (phba->over_temp_state == HBA_OVER_TEMP) {
+		sysfs_mbox_idle(phba);
+		spin_unlock_irq(&phba->hbalock);
+		return  -EPERM;
+	}
+
 	if (off == 0 &&
 	    phba->sysfs_mbox.state  == SMBOX_WRITING &&
 	    phba->sysfs_mbox.offset >= 2 * sizeof(uint32_t)) {
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-10-27 13:12:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-10-27 13:15:46.000000000 -0400
@@ -386,6 +386,11 @@ struct hbq_s {
 #define LPFC_ELS_HBQ	0
 #define LPFC_EXTRA_HBQ	1
 
+enum hba_temp_state {
+	HBA_NORMAL_TEMP,
+	HBA_OVER_TEMP
+};
+
 struct lpfc_hba {
 	struct lpfc_sli sli;
 	uint32_t sli_rev;		/* SLI2 or SLI3 */
@@ -589,6 +594,7 @@ struct lpfc_hba {
 	 */
 #define QUE_BUFTAG_BIT  (1<<31)
 	uint32_t buffer_tag_count;
+	enum hba_temp_state over_temp_state;
 };
 
 static inline struct Scsi_Host *
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 13:11:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 13:15:46.000000000 -0400
@@ -246,6 +246,15 @@ lpfc_config_port_post(struct lpfc_hba *p
 	int i, j;
 	int rc;
 
+	spin_lock_irq(&phba->hbalock);
+	/*
+	 * If the Config port completed correctly the HBA is not
+	 * over heated any more.
+	 */
+	if (phba->over_temp_state == HBA_OVER_TEMP)
+		phba->over_temp_state = HBA_NORMAL_TEMP;
+	spin_unlock_irq(&phba->hbalock);
+
 	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmb) {
 		phba->link_state = LPFC_HBA_ERROR;
@@ -703,7 +712,10 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 					  SCSI_NL_VID_TYPE_PCI
 					  | PCI_VENDOR_ID_EMULEX);
 
+		spin_lock_irq(&phba->hbalock);
 		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+		phba->over_temp_state = HBA_OVER_TEMP;
+		spin_unlock_irq(&phba->hbalock);
 		lpfc_offline_prep(phba);
 		lpfc_offline(phba);
 		lpfc_unblock_mgmt_io(phba);


