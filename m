From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: Reinstate lpfc_soft_wwn parameter
Date: Fri, 30 Dec 2016 06:57:47 -0800
Message-ID: <586675eb.72esfyQ8KCA7mcNa%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:35195 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753902AbcL3O5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Dec 2016 09:57:52 -0500
Received: by mail-wj0-f195.google.com with SMTP id hb5so27837532wjc.2
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2016 06:57:52 -0800 (PST)
Received: from flash ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id y4sm73914205wjp.0.2016.12.30.06.57.49
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Dec 2016 06:57:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The lpfc 11.2.0.4 patch set deprecated, by removing, the lpfc_soft_wwn
parameter support.

This patch reinstates support, but adds a warning in the enablement of
the feature that indicates Broadcom (Emulex) does not support the feature.

-- james

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |   4 +
 drivers/scsi/lpfc/lpfc_attr.c | 223 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c |  16 ++-
 3 files changed, 240 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index c2e6ffd..6593b07 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -728,6 +728,8 @@ struct lpfc_hba {
 	uint32_t cfg_total_seg_cnt;
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
+	uint64_t cfg_soft_wwnn;
+	uint64_t cfg_soft_wwpn;
 	uint32_t cfg_hba_queue_depth;
 	uint32_t cfg_enable_hba_reset;
 	uint32_t cfg_enable_hba_heartbeat;
@@ -832,6 +834,8 @@ struct lpfc_hba {
 #define VPD_PORT            0x8         /* valid vpd port data */
 #define VPD_MASK            0xf         /* mask for any vpd data */
 
+	uint8_t soft_wwn_enable;
+
 	struct timer_list fcp_poll_timer;
 	struct timer_list eratt_poll;
 	uint32_t eratt_poll_interval;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 8301c08..6c104d7 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1987,6 +1987,7 @@ static DEVICE_ATTR(protocol, S_IRUGO, lpfc_sli4_protocol_show, NULL);
 static DEVICE_ATTR(lpfc_xlane_supported, S_IRUGO, lpfc_oas_supported_show,
 		   NULL);
 
+static char *lpfc_soft_wwn_key = "C99G71SL8032A";
 #define WWN_SZ 8
 /**
  * lpfc_wwn_set - Convert string to the 8 byte WWN value.
@@ -2030,6 +2031,223 @@ lpfc_wwn_set(const char *buf, size_t cnt, char wwn[])
 	}
 	return 0;
 }
+/**
+ * lpfc_soft_wwn_enable_store - Allows setting of the wwn if the key is valid
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: containing the string lpfc_soft_wwn_key.
+ * @count: must be size of lpfc_soft_wwn_key.
+ *
+ * Returns:
+ * -EINVAL if the buffer does not contain lpfc_soft_wwn_key
+ * length of buf indicates success
+ **/
+static ssize_t
+lpfc_soft_wwn_enable_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	unsigned int cnt = count;
+
+	/*
+	 * We're doing a simple sanity check for soft_wwpn setting.
+	 * We require that the user write a specific key to enable
+	 * the soft_wwpn attribute to be settable. Once the attribute
+	 * is written, the enable key resets. If further updates are
+	 * desired, the key must be written again to re-enable the
+	 * attribute.
+	 *
+	 * The "key" is not secret - it is a hardcoded string shown
+	 * here. The intent is to protect against the random user or
+	 * application that is just writing attributes.
+	 */
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	if ((cnt != strlen(lpfc_soft_wwn_key)) ||
+	    (strncmp(buf, lpfc_soft_wwn_key, strlen(lpfc_soft_wwn_key)) != 0))
+		return -EINVAL;
+
+	phba->soft_wwn_enable = 1;
+
+	dev_printk(KERN_WARNING, &phba->pcidev->dev,
+		   "lpfc%d: soft_wwpn assignment has been enabled.\n",
+		   phba->brd_no);
+	dev_printk(KERN_WARNING, &phba->pcidev->dev,
+		   "  The soft_wwpn feature is not supported by Broadcom.");
+
+	return count;
+}
+static DEVICE_ATTR(lpfc_soft_wwn_enable, S_IWUSR, NULL,
+		   lpfc_soft_wwn_enable_store);
+
+/**
+ * lpfc_soft_wwpn_show - Return the cfg soft ww port name of the adapter
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the wwpn in hexadecimal.
+ *
+ * Returns: size of formatted string.
+ **/
+static ssize_t
+lpfc_soft_wwpn_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+			(unsigned long long)phba->cfg_soft_wwpn);
+}
+
+/**
+ * lpfc_soft_wwpn_store - Set the ww port name of the adapter
+ * @dev class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: contains the wwpn in hexadecimal.
+ * @count: number of wwpn bytes in buf
+ *
+ * Returns:
+ * -EACCES hba reset not enabled, adapter over temp
+ * -EINVAL soft wwn not enabled, count is invalid, invalid wwpn byte invalid
+ * -EIO error taking adapter offline or online
+ * value of count on success
+ **/
+static ssize_t
+lpfc_soft_wwpn_store(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	struct completion online_compl;
+	int stat1 = 0, stat2 = 0;
+	unsigned int cnt = count;
+	u8 wwpn[WWN_SZ];
+	int rc;
+
+	if (!phba->cfg_enable_hba_reset)
+		return -EACCES;
+	spin_lock_irq(&phba->hbalock);
+	if (phba->over_temp_state == HBA_OVER_TEMP) {
+		spin_unlock_irq(&phba->hbalock);
+		return -EACCES;
+	}
+	spin_unlock_irq(&phba->hbalock);
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	if (!phba->soft_wwn_enable)
+		return -EINVAL;
+
+	/* lock setting wwpn, wwnn down */
+	phba->soft_wwn_enable = 0;
+
+	rc = lpfc_wwn_set(buf, cnt, wwpn);
+	if (!rc) {
+		/* not able to set wwpn, unlock it */
+		phba->soft_wwn_enable = 1;
+		return rc;
+	}
+
+	phba->cfg_soft_wwpn = wwn_to_u64(wwpn);
+	fc_host_port_name(shost) = phba->cfg_soft_wwpn;
+	if (phba->cfg_soft_wwnn)
+		fc_host_node_name(shost) = phba->cfg_soft_wwnn;
+
+	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
+		   "lpfc%d: Reinitializing to use soft_wwpn\n", phba->brd_no);
+
+	stat1 = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
+	if (stat1)
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0463 lpfc_soft_wwpn attribute set failed to "
+				"reinit adapter - %d\n", stat1);
+	init_completion(&online_compl);
+	rc = lpfc_workq_post_event(phba, &stat2, &online_compl,
+				   LPFC_EVT_ONLINE);
+	if (rc == 0)
+		return -ENOMEM;
+
+	wait_for_completion(&online_compl);
+	if (stat2)
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0464 lpfc_soft_wwpn attribute set failed to "
+				"reinit adapter - %d\n", stat2);
+	return (stat1 || stat2) ? -EIO : count;
+}
+static DEVICE_ATTR(lpfc_soft_wwpn, S_IRUGO | S_IWUSR,
+		   lpfc_soft_wwpn_show, lpfc_soft_wwpn_store);
+
+/**
+ * lpfc_soft_wwnn_show - Return the cfg soft ww node name for the adapter
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the wwnn in hexadecimal.
+ *
+ * Returns: size of formatted string.
+ **/
+static ssize_t
+lpfc_soft_wwnn_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+			(unsigned long long)phba->cfg_soft_wwnn);
+}
+
+/**
+ * lpfc_soft_wwnn_store - sets the ww node name of the adapter
+ * @cdev: class device that is converted into a Scsi_host.
+ * @buf: contains the ww node name in hexadecimal.
+ * @count: number of wwnn bytes in buf.
+ *
+ * Returns:
+ * -EINVAL soft wwn not enabled, count is invalid, invalid wwnn byte invalid
+ * value of count on success
+ **/
+static ssize_t
+lpfc_soft_wwnn_store(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	unsigned int cnt = count;
+	u8 wwnn[WWN_SZ];
+	int rc;
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	if (!phba->soft_wwn_enable)
+		return -EINVAL;
+
+	rc = lpfc_wwn_set(buf, cnt, wwnn);
+	if (!rc) {
+		/* Allow wwnn to be set many times, as long as the enable
+		 * is set. However, once the wwpn is set, everything locks.
+		 */
+		return rc;
+	}
+
+	phba->cfg_soft_wwnn = wwn_to_u64(wwnn);
+
+	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
+		   "lpfc%d: soft_wwnn set. Value will take effect upon "
+		   "setting of the soft_wwpn\n", phba->brd_no);
+
+	return count;
+}
+static DEVICE_ATTR(lpfc_soft_wwnn, S_IRUGO | S_IWUSR,
+		   lpfc_soft_wwnn_show, lpfc_soft_wwnn_store);
 
 /**
  * lpfc_oas_tgt_show - Return wwpn of target whose luns maybe enabled for
@@ -4538,6 +4756,9 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_fcp_cpu_map,
 	&dev_attr_lpfc_fcp_io_channel,
 	&dev_attr_lpfc_enable_bg,
+	&dev_attr_lpfc_soft_wwnn,
+	&dev_attr_lpfc_soft_wwpn,
+	&dev_attr_lpfc_soft_wwn_enable,
 	&dev_attr_lpfc_enable_hba_reset,
 	&dev_attr_lpfc_enable_hba_heartbeat,
 	&dev_attr_lpfc_EnableXLane,
@@ -5566,6 +5787,8 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	else
 		phba->cfg_poll = lpfc_poll;
 
+	phba->cfg_soft_wwnn = 0L;
+	phba->cfg_soft_wwpn = 0L;
 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
 	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 43d2b06..4776fd8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -319,26 +319,36 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 
 /**
  * lpfc_update_vport_wwn - Updates the fc_nodename, fc_portname,
+ *	cfg_soft_wwnn, cfg_soft_wwpn
  * @vport: pointer to lpfc vport data structure.
  *
+ *
  * Return codes
  *   None.
  **/
 void
 lpfc_update_vport_wwn(struct lpfc_vport *vport)
 {
+	/* If the soft name exists then update it using the service params */
+	if (vport->phba->cfg_soft_wwnn)
+		u64_to_wwn(vport->phba->cfg_soft_wwnn,
+			   vport->fc_sparam.nodeName.u.wwn);
+	if (vport->phba->cfg_soft_wwpn)
+		u64_to_wwn(vport->phba->cfg_soft_wwpn,
+			   vport->fc_sparam.portName.u.wwn);
+
 	/*
-	 * If the name is empty
+	 * If the name is empty or there exists a soft name
 	 * then copy the service params name, otherwise use the fc name
 	 */
-	if (vport->fc_nodename.u.wwn[0] == 0)
+	if (vport->fc_nodename.u.wwn[0] == 0 || vport->phba->cfg_soft_wwnn)
 		memcpy(&vport->fc_nodename, &vport->fc_sparam.nodeName,
 			sizeof(struct lpfc_name));
 	else
 		memcpy(&vport->fc_sparam.nodeName, &vport->fc_nodename,
 			sizeof(struct lpfc_name));
 
-	if (vport->fc_portname.u.wwn[0] == 0)
+	if (vport->fc_portname.u.wwn[0] == 0 || vport->phba->cfg_soft_wwpn)
 		memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
 			sizeof(struct lpfc_name));
 	else
-- 
2.5.0

