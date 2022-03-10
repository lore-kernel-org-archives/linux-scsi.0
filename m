Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B992EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 15:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbiCJPt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 10:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiCJPt5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 10:49:57 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5008B6E8
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 07:48:55 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 27so5030495pgk.10
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 07:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cm4wBXToEvGXjaxhvDIHdnc7MfJWwSshLhyu0S5r4v0=;
        b=dUMRb3pGqbgYYzHGbCqGu4LjPM0v8bvc0a//M+DccBBUXzXC3hU3Sf3O5djnqwNjr+
         MfWY1aIFpdRa3pydMGImFll75up4OiltO5Ukqiw8TqINVl61yQI1fYSrIfXj6mEYcnI8
         Zd6ipbC0RQjoErAfBwlEc3CHiwO7B8TFnHqJHti91lzihNveOb6EK5G9hgdsOIq9ANEP
         BkoQOtmuCqp26FLPJigkl1aKy27RnuBjCwpHQwFNtyvIDd7/DQDbCv/4nm6cIL2TOEh6
         cAXgSsTOvAC5yMKp4YmJf8ZGIkdE6DlvbmrYrudiRcUD86hF8iIK0HiCySwnvRrYvVn0
         S1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cm4wBXToEvGXjaxhvDIHdnc7MfJWwSshLhyu0S5r4v0=;
        b=JGEX6LfoH1ezsSYM/06pseJ1L8LRwX0pOFWpGXcpzg46klBl3pIjScm5lxzdCE/uLE
         MxBLMPINvUXYXICHMynsbVwFwtaqHsOguGDFAgelLslYOnbshF5l8FGl4RL2V6mWnBQF
         gEH+CIBSJwIFGzndUE5VYF+TmarKYZ/TYmwNmP2KPq6o/qXtaeklnwxMmy3ceg/qFK75
         QSzaGZGVUAl9rrpOsbXLgfZRsdVdxMsFk9N+z1agFxZcWB6GmSu+6+c5bCMvPNLNn5bR
         mQM37PE24oIWtSGQxJHK5R6RLX8SSL7syDogHQ5aBORFiKhpds8+P+EE9Zu9TK15ACkb
         XZXA==
X-Gm-Message-State: AOAM531MGBmMd5yTJsVLzSfaRD6FtIi9sBDtLOPcD0KkDTNEsx4vOyV8
        tQ2O/Vz8Cd3R0ZhS01uR1uIDcBy2FBw=
X-Google-Smtp-Source: ABdhPJxLX65iPvxP0Voe6DWaTMeenZu1VQWP9QrHJTUByVRej9ZdH4YG60GYpcLEGRme8USNFBgi0w==
X-Received: by 2002:a63:2004:0:b0:375:ed63:ab4c with SMTP id g4-20020a632004000000b00375ed63ab4cmr4637624pgg.255.1646927334975;
        Thu, 10 Mar 2022 07:48:54 -0800 (PST)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id q13-20020a056a00088d00b004e1bea9c582sm7619867pfj.43.2022.03.10.07.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 07:48:54 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] lpfc: Remove failing soft_wwn support
Date:   Thu, 10 Mar 2022 07:48:45 -0800
Message-Id: <20220310154845.11125-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The soft_wwpn/soft_wwn functionality, which allows the driver to modify
service parameters in an attempt to override the adapter-assigned WWN,
was originally attempted to be removed roughly 6 yrs ago as new fabric
features were being introduced that clashed with the implementation.
In the end, the feature was left in with the user being responsible if
things went south.

We've reached a point where soft_wwn is no longer functional and is
failing in almost all production use cases. Use of Fabric features such
as Fabric Assigned WWPN and Automatic DPORT is now prevalent and the
features require coordination between the adapter and driver that can't
be solved by the simplistic update of the service parameters. As it is
no longer functional, the feature is to be removed.

There are still ways to override the adapter-assigned WWN but they
require the admin to invoke bios/efi level menus.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |   3 -
 drivers/scsi/lpfc/lpfc_attr.c | 228 ----------------------------------
 drivers/scsi/lpfc/lpfc_init.c |  12 +-
 3 files changed, 1 insertion(+), 242 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8197ba8d401d..86653aa9b389 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1153,8 +1153,6 @@ struct lpfc_hba {
 	uint32_t cfg_nvme_seg_cnt;
 	uint32_t cfg_scsi_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
-	uint64_t cfg_soft_wwnn;
-	uint64_t cfg_soft_wwpn;
 	uint32_t cfg_hba_queue_depth;
 	uint32_t cfg_enable_hba_reset;
 	uint32_t cfg_enable_hba_heartbeat;
@@ -1286,7 +1284,6 @@ struct lpfc_hba {
 #define VPD_PORT            0x8         /* valid vpd port data */
 #define VPD_MASK            0xf         /* mask for any vpd data */
 
-	uint8_t soft_wwn_enable;
 
 	struct timer_list fcp_poll_timer;
 	struct timer_list eratt_poll;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index bac78fbce8d6..ff99f7cdbefa 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2835,7 +2835,6 @@ static DEVICE_ATTR(lpfc_xlane_supported, S_IRUGO, lpfc_oas_supported_show,
 		   NULL);
 static DEVICE_ATTR(cmf_info, 0444, lpfc_cmf_info_show, NULL);
 
-static char *lpfc_soft_wwn_key = "C99G71SL8032A";
 #define WWN_SZ 8
 /**
  * lpfc_wwn_set - Convert string to the 8 byte WWN value.
@@ -2879,229 +2878,7 @@ lpfc_wwn_set(const char *buf, size_t cnt, char wwn[])
 	}
 	return 0;
 }
-/**
- * lpfc_soft_wwn_enable_store - Allows setting of the wwn if the key is valid
- * @dev: class device that is converted into a Scsi_host.
- * @attr: device attribute, not used.
- * @buf: containing the string lpfc_soft_wwn_key.
- * @count: must be size of lpfc_soft_wwn_key.
- *
- * Returns:
- * -EINVAL if the buffer does not contain lpfc_soft_wwn_key
- * length of buf indicates success
- **/
-static ssize_t
-lpfc_soft_wwn_enable_store(struct device *dev, struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	struct Scsi_Host  *shost = class_to_shost(dev);
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
-	unsigned int cnt = count;
-	uint8_t vvvl = vport->fc_sparam.cmn.valid_vendor_ver_level;
-	u32 *fawwpn_key = (uint32_t *)&vport->fc_sparam.un.vendorVersion[0];
-
-	/*
-	 * We're doing a simple sanity check for soft_wwpn setting.
-	 * We require that the user write a specific key to enable
-	 * the soft_wwpn attribute to be settable. Once the attribute
-	 * is written, the enable key resets. If further updates are
-	 * desired, the key must be written again to re-enable the
-	 * attribute.
-	 *
-	 * The "key" is not secret - it is a hardcoded string shown
-	 * here. The intent is to protect against the random user or
-	 * application that is just writing attributes.
-	 */
-	if (vvvl == 1 && cpu_to_be32(*fawwpn_key) == FAPWWN_KEY_VENDOR) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0051 lpfc soft wwpn can not be enabled: "
-				"fawwpn is enabled\n");
-		return -EINVAL;
-	}
-
-	/* count may include a LF at end of string */
-	if (buf[cnt-1] == '\n')
-		cnt--;
-
-	if ((cnt != strlen(lpfc_soft_wwn_key)) ||
-	    (strncmp(buf, lpfc_soft_wwn_key, strlen(lpfc_soft_wwn_key)) != 0))
-		return -EINVAL;
-
-	phba->soft_wwn_enable = 1;
-
-	dev_printk(KERN_WARNING, &phba->pcidev->dev,
-		   "lpfc%d: soft_wwpn assignment has been enabled.\n",
-		   phba->brd_no);
-	dev_printk(KERN_WARNING, &phba->pcidev->dev,
-		   "  The soft_wwpn feature is not supported by Broadcom.");
-
-	return count;
-}
-static DEVICE_ATTR_WO(lpfc_soft_wwn_enable);
-
-/**
- * lpfc_soft_wwpn_show - Return the cfg soft ww port name of the adapter
- * @dev: class device that is converted into a Scsi_host.
- * @attr: device attribute, not used.
- * @buf: on return contains the wwpn in hexadecimal.
- *
- * Returns: size of formatted string.
- **/
-static ssize_t
-lpfc_soft_wwpn_show(struct device *dev, struct device_attribute *attr,
-		    char *buf)
-{
-	struct Scsi_Host  *shost = class_to_shost(dev);
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
-
-	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
-			(unsigned long long)phba->cfg_soft_wwpn);
-}
-
-/**
- * lpfc_soft_wwpn_store - Set the ww port name of the adapter
- * @dev: class device that is converted into a Scsi_host.
- * @attr: device attribute, not used.
- * @buf: contains the wwpn in hexadecimal.
- * @count: number of wwpn bytes in buf
- *
- * Returns:
- * -EACCES hba reset not enabled, adapter over temp
- * -EINVAL soft wwn not enabled, count is invalid, invalid wwpn byte invalid
- * -EIO error taking adapter offline or online
- * value of count on success
- **/
-static ssize_t
-lpfc_soft_wwpn_store(struct device *dev, struct device_attribute *attr,
-		     const char *buf, size_t count)
-{
-	struct Scsi_Host  *shost = class_to_shost(dev);
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
-	struct completion online_compl;
-	int stat1 = 0, stat2 = 0;
-	unsigned int cnt = count;
-	u8 wwpn[WWN_SZ];
-	int rc;
-
-	if (!phba->cfg_enable_hba_reset)
-		return -EACCES;
-	spin_lock_irq(&phba->hbalock);
-	if (phba->over_temp_state == HBA_OVER_TEMP) {
-		spin_unlock_irq(&phba->hbalock);
-		return -EACCES;
-	}
-	spin_unlock_irq(&phba->hbalock);
-	/* count may include a LF at end of string */
-	if (buf[cnt-1] == '\n')
-		cnt--;
-
-	if (!phba->soft_wwn_enable)
-		return -EINVAL;
-
-	/* lock setting wwpn, wwnn down */
-	phba->soft_wwn_enable = 0;
-
-	rc = lpfc_wwn_set(buf, cnt, wwpn);
-	if (rc) {
-		/* not able to set wwpn, unlock it */
-		phba->soft_wwn_enable = 1;
-		return rc;
-	}
-
-	phba->cfg_soft_wwpn = wwn_to_u64(wwpn);
-	fc_host_port_name(shost) = phba->cfg_soft_wwpn;
-	if (phba->cfg_soft_wwnn)
-		fc_host_node_name(shost) = phba->cfg_soft_wwnn;
-
-	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
-		   "lpfc%d: Reinitializing to use soft_wwpn\n", phba->brd_no);
-
-	stat1 = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
-	if (stat1)
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0463 lpfc_soft_wwpn attribute set failed to "
-				"reinit adapter - %d\n", stat1);
-	init_completion(&online_compl);
-	rc = lpfc_workq_post_event(phba, &stat2, &online_compl,
-				   LPFC_EVT_ONLINE);
-	if (rc == 0)
-		return -ENOMEM;
 
-	wait_for_completion(&online_compl);
-	if (stat2)
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0464 lpfc_soft_wwpn attribute set failed to "
-				"reinit adapter - %d\n", stat2);
-	return (stat1 || stat2) ? -EIO : count;
-}
-static DEVICE_ATTR_RW(lpfc_soft_wwpn);
-
-/**
- * lpfc_soft_wwnn_show - Return the cfg soft ww node name for the adapter
- * @dev: class device that is converted into a Scsi_host.
- * @attr: device attribute, not used.
- * @buf: on return contains the wwnn in hexadecimal.
- *
- * Returns: size of formatted string.
- **/
-static ssize_t
-lpfc_soft_wwnn_show(struct device *dev, struct device_attribute *attr,
-		    char *buf)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
-	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
-			(unsigned long long)phba->cfg_soft_wwnn);
-}
-
-/**
- * lpfc_soft_wwnn_store - sets the ww node name of the adapter
- * @dev: class device that is converted into a Scsi_host.
- * @attr: device attribute, not used.
- * @buf: contains the ww node name in hexadecimal.
- * @count: number of wwnn bytes in buf.
- *
- * Returns:
- * -EINVAL soft wwn not enabled, count is invalid, invalid wwnn byte invalid
- * value of count on success
- **/
-static ssize_t
-lpfc_soft_wwnn_store(struct device *dev, struct device_attribute *attr,
-		     const char *buf, size_t count)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
-	unsigned int cnt = count;
-	u8 wwnn[WWN_SZ];
-	int rc;
-
-	/* count may include a LF at end of string */
-	if (buf[cnt-1] == '\n')
-		cnt--;
-
-	if (!phba->soft_wwn_enable)
-		return -EINVAL;
-
-	rc = lpfc_wwn_set(buf, cnt, wwnn);
-	if (rc) {
-		/* Allow wwnn to be set many times, as long as the enable
-		 * is set. However, once the wwpn is set, everything locks.
-		 */
-		return rc;
-	}
-
-	phba->cfg_soft_wwnn = wwn_to_u64(wwnn);
-
-	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
-		   "lpfc%d: soft_wwnn set. Value will take effect upon "
-		   "setting of the soft_wwpn\n", phba->brd_no);
-
-	return count;
-}
-static DEVICE_ATTR_RW(lpfc_soft_wwnn);
 
 /**
  * lpfc_oas_tgt_show - Return wwpn of target whose luns maybe enabled for
@@ -6495,9 +6272,6 @@ static struct attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_nvme_enable_fb.attr,
 	&dev_attr_lpfc_nvmet_fb_size.attr,
 	&dev_attr_lpfc_enable_bg.attr,
-	&dev_attr_lpfc_soft_wwnn.attr,
-	&dev_attr_lpfc_soft_wwpn.attr,
-	&dev_attr_lpfc_soft_wwn_enable.attr,
 	&dev_attr_lpfc_enable_hba_reset.attr,
 	&dev_attr_lpfc_enable_hba_heartbeat.attr,
 	&dev_attr_lpfc_EnableXLane.attr,
@@ -7727,8 +7501,6 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	    phba->sli_rev == LPFC_SLI_REV4)
 		phba->cfg_irq_chann = phba->cfg_hdw_queue;
 
-	phba->cfg_soft_wwnn = 0L;
-	phba->cfg_soft_wwpn = 0L;
 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
 	lpfc_aer_support_init(phba, lpfc_aer_support);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6e247b6be7de..eed6464bd880 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -340,7 +340,6 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 
 /**
  * lpfc_update_vport_wwn - Updates the fc_nodename, fc_portname,
- *	cfg_soft_wwnn, cfg_soft_wwpn
  * @vport: pointer to lpfc vport data structure.
  *
  *
@@ -353,19 +352,11 @@ lpfc_update_vport_wwn(struct lpfc_vport *vport)
 	uint8_t vvvl = vport->fc_sparam.cmn.valid_vendor_ver_level;
 	u32 *fawwpn_key = (u32 *)&vport->fc_sparam.un.vendorVersion[0];
 
-	/* If the soft name exists then update it using the service params */
-	if (vport->phba->cfg_soft_wwnn)
-		u64_to_wwn(vport->phba->cfg_soft_wwnn,
-			   vport->fc_sparam.nodeName.u.wwn);
-	if (vport->phba->cfg_soft_wwpn)
-		u64_to_wwn(vport->phba->cfg_soft_wwpn,
-			   vport->fc_sparam.portName.u.wwn);
-
 	/*
 	 * If the name is empty or there exists a soft name
 	 * then copy the service params name, otherwise use the fc name
 	 */
-	if (vport->fc_nodename.u.wwn[0] == 0 || vport->phba->cfg_soft_wwnn)
+	if (vport->fc_nodename.u.wwn[0] == 0)
 		memcpy(&vport->fc_nodename, &vport->fc_sparam.nodeName,
 			sizeof(struct lpfc_name));
 	else
@@ -382,7 +373,6 @@ lpfc_update_vport_wwn(struct lpfc_vport *vport)
 		vport->vport_flag |= FAWWPN_PARAM_CHG;
 
 	if (vport->fc_portname.u.wwn[0] == 0 ||
-	    vport->phba->cfg_soft_wwpn ||
 	    (vvvl == 1 && cpu_to_be32(*fawwpn_key) == FAPWWN_KEY_VENDOR) ||
 	    vport->vport_flag & FAWWPN_SET) {
 		memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
-- 
2.26.2

