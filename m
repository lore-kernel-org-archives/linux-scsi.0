From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/9] lpfc 8.1.11 :  Add soft_wwnn sysfs attribute, rename
	soft_wwn_enable
Date: Sat, 02 Dec 2006 13:35:30 -0500
Message-ID: <1165084531.27443.28.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57303 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1759471AbWLBQHI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 11:07:08 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id kB2G71ap009324
	for <linux-scsi@vger.kernel.org>; Sat, 2 Dec 2006 08:07:07 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add soft_wwnn sysfs attribute, rename soft_wwn_enable
  The driver now allows both wwpn and wwnn to be set.


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-12-02 12:13:17.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-12-02 12:29:22.000000000 -0500
@@ -552,10 +552,10 @@ static CLASS_DEVICE_ATTR(board_mode, S_I
 static CLASS_DEVICE_ATTR(issue_reset, S_IWUSR, NULL, lpfc_issue_reset);
 

-static char *lpfc_soft_wwpn_key = "C99G71SL8032A";
+static char *lpfc_soft_wwn_key = "C99G71SL8032A";
 
 static ssize_t
-lpfc_soft_wwpn_enable_store(struct class_device *cdev, const char *buf,
+lpfc_soft_wwn_enable_store(struct class_device *cdev, const char *buf,
 				size_t count)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -579,15 +579,15 @@ lpfc_soft_wwpn_enable_store(struct class
 	if (buf[cnt-1] == '\n')
 		cnt--;
 
-	if ((cnt != strlen(lpfc_soft_wwpn_key)) ||
-	    (strncmp(buf, lpfc_soft_wwpn_key, strlen(lpfc_soft_wwpn_key)) != 0))
+	if ((cnt != strlen(lpfc_soft_wwn_key)) ||
+	    (strncmp(buf, lpfc_soft_wwn_key, strlen(lpfc_soft_wwn_key)) != 0))
 		return -EINVAL;
 
-	phba->soft_wwpn_enable = 1;
+	phba->soft_wwn_enable = 1;
 	return count;
 }
-static CLASS_DEVICE_ATTR(lpfc_soft_wwpn_enable, S_IWUSR, NULL,
-				lpfc_soft_wwpn_enable_store);
+static CLASS_DEVICE_ATTR(lpfc_soft_wwn_enable, S_IWUSR, NULL,
+				lpfc_soft_wwn_enable_store);
 
 static ssize_t
 lpfc_soft_wwpn_show(struct class_device *cdev, char *buf)
@@ -613,12 +613,12 @@ lpfc_soft_wwpn_store(struct class_device
 	if (buf[cnt-1] == '\n')
 		cnt--;
 
-	if (!phba->soft_wwpn_enable || (cnt < 16) || (cnt > 18) ||
+	if (!phba->soft_wwn_enable || (cnt < 16) || (cnt > 18) ||
 	    ((cnt == 17) && (*buf++ != 'x')) ||
 	    ((cnt == 18) && ((*buf++ != '0') || (*buf++ != 'x'))))
 		return -EINVAL;
 
-	phba->soft_wwpn_enable = 0;
+	phba->soft_wwn_enable = 0;
 
 	memset(wwpn, 0, sizeof(wwpn));
 
@@ -639,6 +639,8 @@ lpfc_soft_wwpn_store(struct class_device
 	}
 	phba->cfg_soft_wwpn = wwn_to_u64(wwpn);
 	fc_host_port_name(host) = phba->cfg_soft_wwpn;
+	if (phba->cfg_soft_wwnn)
+		fc_host_node_name(host) = phba->cfg_soft_wwnn;
 
 	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
 		   "lpfc%d: Reinitializing to use soft_wwpn\n", phba->brd_no);
@@ -664,6 +666,66 @@ lpfc_soft_wwpn_store(struct class_device
 static CLASS_DEVICE_ATTR(lpfc_soft_wwpn, S_IRUGO | S_IWUSR,\
 			 lpfc_soft_wwpn_show, lpfc_soft_wwpn_store);
 
+static ssize_t
+lpfc_soft_wwnn_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+			(unsigned long long)phba->cfg_soft_wwnn);
+}
+
+
+static ssize_t
+lpfc_soft_wwnn_store(struct class_device *cdev, const char *buf, size_t count)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+	unsigned int i, j, cnt=count;
+	u8 wwnn[8];
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	if (!phba->soft_wwn_enable || (cnt < 16) || (cnt > 18) ||
+	    ((cnt == 17) && (*buf++ != 'x')) ||
+	    ((cnt == 18) && ((*buf++ != '0') || (*buf++ != 'x'))))
+		return -EINVAL;
+
+	/*
+	 * Allow wwnn to be set many times, as long as the enable is set.
+	 * However, once the wwpn is set, everything locks.
+	 */
+
+	memset(wwnn, 0, sizeof(wwnn));
+
+	/* Validate and store the new name */
+	for (i=0, j=0; i < 16; i++) {
+		if ((*buf >= 'a') && (*buf <= 'f'))
+			j = ((j << 4) | ((*buf++ -'a') + 10));
+		else if ((*buf >= 'A') && (*buf <= 'F'))
+			j = ((j << 4) | ((*buf++ -'A') + 10));
+		else if ((*buf >= '0') && (*buf <= '9'))
+			j = ((j << 4) | (*buf++ -'0'));
+		else
+			return -EINVAL;
+		if (i % 2) {
+			wwnn[i/2] = j & 0xff;
+			j = 0;
+		}
+	}
+	phba->cfg_soft_wwnn = wwn_to_u64(wwnn);
+
+	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
+		   "lpfc%d: soft_wwnn set. Value will take effect upon "
+		   "setting of the soft_wwpn\n", phba->brd_no);
+
+	return count;
+}
+static CLASS_DEVICE_ATTR(lpfc_soft_wwnn, S_IRUGO | S_IWUSR,\
+			 lpfc_soft_wwnn_show, lpfc_soft_wwnn_store);
+
 
 static int lpfc_poll = 0;
 module_param(lpfc_poll, int, 0);
@@ -1009,8 +1071,9 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_lpfc_poll,
 	&class_device_attr_lpfc_poll_tmo,
 	&class_device_attr_lpfc_use_msi,
+	&class_device_attr_lpfc_soft_wwnn,
 	&class_device_attr_lpfc_soft_wwpn,
-	&class_device_attr_lpfc_soft_wwpn_enable,
+	&class_device_attr_lpfc_soft_wwn_enable,
 	NULL,
 };
 
@@ -1815,6 +1878,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_devloss_tmo_init(phba, lpfc_devloss_tmo);
 	lpfc_nodev_tmo_init(phba, lpfc_nodev_tmo);
 	phba->cfg_poll = lpfc_poll;
+	phba->cfg_soft_wwnn = 0L;
 	phba->cfg_soft_wwpn = 0L;
 
 	/*
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2006-12-02 12:13:17.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2006-12-02 12:29:22.000000000 -0500
@@ -306,6 +306,7 @@ struct lpfc_hba {
 	uint32_t cfg_use_msi;
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
+	uint64_t cfg_soft_wwnn;
 	uint64_t cfg_soft_wwpn;
 
 	uint32_t dev_loss_tmo_changed;
@@ -358,7 +359,7 @@ struct lpfc_hba {
 #define VPD_PORT            0x8         /* valid vpd port data */
 #define VPD_MASK            0xf         /* mask for any vpd data */
 
-	uint8_t soft_wwpn_enable;
+	uint8_t soft_wwn_enable;
 
 	struct timer_list fcp_poll_timer;
 	struct timer_list els_tmofunc;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-12-02 12:02:00.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-12-02 12:29:22.000000000 -0500
@@ -672,6 +672,8 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hb
 
 	memcpy((uint8_t *) & phba->fc_sparam, (uint8_t *) mp->virt,
 	       sizeof (struct serv_parm));
+	if (phba->cfg_soft_wwnn)
+		u64_to_wwn(phba->cfg_soft_wwnn, phba->fc_sparam.nodeName.u.wwn);
 	if (phba->cfg_soft_wwpn)
 		u64_to_wwn(phba->cfg_soft_wwpn, phba->fc_sparam.portName.u.wwn);
 	memcpy((uint8_t *) & phba->fc_nodename,
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 12:24:39.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 12:29:22.000000000 -0500
@@ -268,6 +268,8 @@ lpfc_config_port_post(struct lpfc_hba * 
 	kfree(mp);
 	pmb->context1 = NULL;
 
+	if (phba->cfg_soft_wwnn)
+		u64_to_wwn(phba->cfg_soft_wwnn, phba->fc_sparam.nodeName.u.wwn);
 	if (phba->cfg_soft_wwpn)
 		u64_to_wwn(phba->cfg_soft_wwpn, phba->fc_sparam.portName.u.wwn);
 	memcpy(&phba->fc_nodename, &phba->fc_sparam.nodeName,


