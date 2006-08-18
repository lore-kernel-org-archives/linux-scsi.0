From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/5] lpfc 8.1.10 : Add support for new lpfc soft_wwpn
	attribute
Date: Fri, 18 Aug 2006 17:47:18 -0400
Message-ID: <1155937638.12933.31.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43462 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751498AbWHRVrO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 17:47:14 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7ILlDCb024303
	for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2006 14:47:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add support for a new lpfc soft_wwpn sysfs attribute

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -303,6 +303,7 @@ #define FC_BYPASSED_MODE        0x20000	
 	uint32_t cfg_poll_tmo;
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
+	uint64_t cfg_soft_wwpn;
 
 	uint32_t dev_loss_tmo_changed;
 
@@ -354,6 +355,8 @@ #define VPD_PROGRAM_TYPE    0x4         
 #define VPD_PORT            0x8         /* valid vpd port data */
 #define VPD_MASK            0xf         /* mask for any vpd data */
 
+	uint8_t soft_wwpn_enable;
+
 	struct timer_list fcp_poll_timer;
 	struct timer_list els_tmofunc;
 
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -551,6 +551,119 @@ static CLASS_DEVICE_ATTR(board_mode, S_I
 			 lpfc_board_mode_show, lpfc_board_mode_store);
 static CLASS_DEVICE_ATTR(issue_reset, S_IWUSR, NULL, lpfc_issue_reset);
 
+
+static char *lpfc_soft_wwpn_key = "C99G71SL8032A";
+
+static ssize_t
+lpfc_soft_wwpn_enable_store(struct class_device *cdev, const char *buf,
+				size_t count)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
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
+	if ((cnt != strlen(lpfc_soft_wwpn_key)) ||
+	    (strncmp(buf, lpfc_soft_wwpn_key, strlen(lpfc_soft_wwpn_key)) != 0))
+		return -EINVAL;
+
+	phba->soft_wwpn_enable = 1;
+	return count;
+}
+static CLASS_DEVICE_ATTR(lpfc_soft_wwpn_enable, S_IWUSR, NULL,
+				lpfc_soft_wwpn_enable_store);
+
+static ssize_t
+lpfc_soft_wwpn_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", phba->cfg_soft_wwpn);
+}
+
+
+static ssize_t
+lpfc_soft_wwpn_store(struct class_device *cdev, const char *buf, size_t count)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+	struct completion online_compl;
+	int stat1=0, stat2=0;
+	unsigned int i, j, cnt=count;
+	u8 wwpn[8];
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	if (!phba->soft_wwpn_enable || (cnt < 16) || (cnt > 18) ||
+	    ((cnt == 17) && (*buf++ != 'x')) ||
+	    ((cnt == 18) && ((*buf++ != '0') || (*buf++ != 'x'))))
+		return -EINVAL;
+
+	phba->soft_wwpn_enable = 0;
+
+	memset(wwpn, 0, sizeof(wwpn));
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
+			wwpn[i/2] = j & 0xff;
+			j = 0;
+		}
+	}
+	phba->cfg_soft_wwpn = wwn_to_u64(wwpn);
+	fc_host_port_name(host) = phba->cfg_soft_wwpn;
+
+	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
+		   "lpfc%d: Reinitializing to use soft_wwpn\n", phba->brd_no);
+
+	init_completion(&online_compl);
+	lpfc_workq_post_event(phba, &stat1, &online_compl, LPFC_EVT_OFFLINE);
+	wait_for_completion(&online_compl);
+	if (stat1)
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"%d:0463 lpfc_soft_wwpn attribute set failed to reinit "
+			"adapter - %d\n", phba->brd_no, stat1);
+
+	init_completion(&online_compl);
+	lpfc_workq_post_event(phba, &stat2, &online_compl, LPFC_EVT_ONLINE);
+	wait_for_completion(&online_compl);
+	if (stat2)
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"%d:0464 lpfc_soft_wwpn attribute set failed to reinit "
+			"adapter - %d\n", phba->brd_no, stat2);
+
+	return (stat1 || stat2) ? -EIO : count;
+}
+static CLASS_DEVICE_ATTR(lpfc_soft_wwpn, S_IRUGO | S_IWUSR,\
+			 lpfc_soft_wwpn_show, lpfc_soft_wwpn_store);
+
+
 static int lpfc_poll = 0;
 module_param(lpfc_poll, int, 0);
 MODULE_PARM_DESC(lpfc_poll, "FCP ring polling mode control:"
@@ -832,6 +945,7 @@ # Value range is [1,255], default value 
 LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
 	     "Milliseconds driver will wait between polling FCP ring");
 
+
 struct class_device_attribute *lpfc_host_attrs[] = {
 	&class_device_attr_info,
 	&class_device_attr_serialnum,
@@ -867,6 +981,8 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_issue_reset,
 	&class_device_attr_lpfc_poll,
 	&class_device_attr_lpfc_poll_tmo,
+	&class_device_attr_lpfc_soft_wwpn,
+	&class_device_attr_lpfc_soft_wwpn_enable,
 	NULL,
 };
 
@@ -1668,6 +1784,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_devloss_tmo_init(phba, lpfc_devloss_tmo);
 	lpfc_nodev_tmo_init(phba, lpfc_nodev_tmo);
 	phba->cfg_poll = lpfc_poll;
+	phba->cfg_soft_wwpn = 0L;
 
 	/*
 	 * The total number of segments is the configuration value plus 2
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -672,6 +672,8 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hb
 
 	memcpy((uint8_t *) & phba->fc_sparam, (uint8_t *) mp->virt,
 	       sizeof (struct serv_parm));
+	if (phba->cfg_soft_wwpn)
+		u64_to_wwn(phba->cfg_soft_wwpn, phba->fc_sparam.portName.u.wwn);
 	memcpy((uint8_t *) & phba->fc_nodename,
 	       (uint8_t *) & phba->fc_sparam.nodeName,
 	       sizeof (struct lpfc_name));
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -268,6 +268,8 @@ lpfc_config_port_post(struct lpfc_hba * 
 	kfree(mp);
 	pmb->context1 = NULL;
 
+	if (phba->cfg_soft_wwpn)
+		u64_to_wwn(phba->cfg_soft_wwpn, phba->fc_sparam.portName.u.wwn);
 	memcpy(&phba->fc_nodename, &phba->fc_sparam.nodeName,
 	       sizeof (struct lpfc_name));
 	memcpy(&phba->fc_portname, &phba->fc_sparam.portName,


