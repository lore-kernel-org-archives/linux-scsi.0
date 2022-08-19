Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A233C28B2B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Aug 2022 01:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243302AbiHSBSY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Aug 2022 21:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbiHSBSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2022 21:18:18 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E237261D
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:15 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id g21so2417873qka.5
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=vTKLKMoIQxBhDSlVkWaCdDUcIaYTqsXFlEAUHtX/IXY=;
        b=cviK6sQM+55jzRQtp5/buh5+064DKQPfkEBNR7kx4MXNFyvyDF/gGyKTs9VRfMf1KA
         7bYQGGSb0nDgmD1JFBU2yqYLnJyr0dVrKIvz8qFtBQf9Pxtvl4+b29wiRG+rH5Aa3ETA
         iJYVZLsW6kDGvPzdc2nDtrOblQqukyTWnssuBf8Wo4qH6YvZ9Dblmnp54TvMPNKwH1hN
         +KPt42FbVZWnhL/HtPuGaA+FqZRkMuLv1LGtICIDAKDkza28Wks3el5/7HMxKuK4RnHz
         LGXW2L5P0yddppDnODojoqvOGGZGmNawIEyLX4u3fqU8ksP5tD55KdYkPNZZCPE40BBU
         wGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=vTKLKMoIQxBhDSlVkWaCdDUcIaYTqsXFlEAUHtX/IXY=;
        b=61yFm/qQfBhOitSJ5lc0BAtU5HwX/k7HOsM8+5U6xDlfu+KKM6Tiis1ciQvoRyETMb
         kawv/1NW0+7GwQe8kciUkyxExdfMFq5ZlkN6xRBhs7uyc8Z64JX8wgLwbyJo1JZjon7O
         y2ah9LbIx+Vwvq+784ika/5CGgu9sP2p/ZyLuk14KRhKVhQe0NFGNnc9tel1ygHDEQ9Q
         lCGOBUE3Tg9CjC8mvhbMxW4QZ7sYLkRMF+mWHsgbb84xUigVl74YWLxeH3Ysc4Dw28lJ
         XtP4eQg6jSyZBIfKw+V9dJjddpFhPYD9I/33r4NxVuYmURRPEDEHPPsGynVnH72Ly6Q8
         0d+g==
X-Gm-Message-State: ACgBeo1L3H3KTcdB6Q/M/3NiuFRmZs3T0oQojcgSqTCKx3Il0FSrVnU6
        1L7tFUpJHujsHuQxoaINew2ErZVFKao=
X-Google-Smtp-Source: AA6agR4OPvB76iOKfxCtxzKTiWbWCXqYTDyqUri+Wtk/t+8YlgpnoGXuOCOCSkMIv5TQGmtUGnZVqA==
X-Received: by 2002:a37:27c2:0:b0:6ba:ed29:9f3b with SMTP id n185-20020a3727c2000000b006baed299f3bmr4038131qkn.635.1660871894599;
        Thu, 18 Aug 2022 18:18:14 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id u5-20020a05620a0c4500b006b5e296452csm2612502qki.54.2022.08.18.18.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 18:18:14 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 5/7] lpfc: Remove SANDiags related code
Date:   Thu, 18 Aug 2022 18:17:34 -0700
Message-Id: <20220819011736.14141-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220819011736.14141-1-jsmart2021@gmail.com>
References: <20220819011736.14141-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SANDiags feature is unused, and related code is removed.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  11 -
 drivers/scsi/lpfc/lpfc_attr.c    | 344 +------------------------------
 drivers/scsi/lpfc/lpfc_disc.h    |   1 -
 drivers/scsi/lpfc/lpfc_hbadisc.c |  17 --
 drivers/scsi/lpfc/lpfc_scsi.c    |  59 ------
 drivers/scsi/lpfc/lpfc_scsi.h    |   4 -
 drivers/scsi/lpfc/lpfc_vport.c   |  71 -------
 drivers/scsi/lpfc/lpfc_vport.h   |   4 -
 8 files changed, 4 insertions(+), 507 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 71e6dae5eae8..5d07418fa4ea 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -68,8 +68,6 @@ struct lpfc_sli2_slim;
 #define LPFC_MIN_TGT_QDEPTH	10
 #define LPFC_MAX_TGT_QDEPTH	0xFFFF
 
-#define  LPFC_MAX_BUCKET_COUNT 20	/* Maximum no. of buckets for stat data
-					   collection. */
 /*
  * Following time intervals are used of adjusting SCSI device
  * queue depths when there are driver resource error or Firmware
@@ -732,8 +730,6 @@ struct lpfc_vport {
 	struct lpfc_debugfs_trc *disc_trc;
 	atomic_t disc_trc_cnt;
 #endif
-	uint8_t stat_data_enabled;
-	uint8_t stat_data_blocked;
 	struct list_head rcv_buffer_list;
 	unsigned long rcv_buffer_time_stamp;
 	uint32_t vport_flag;
@@ -1436,13 +1432,6 @@ struct lpfc_hba {
 	 */
 #define QUE_BUFTAG_BIT  (1<<31)
 	uint32_t buffer_tag_count;
-	/* data structure used for latency data collection */
-#define LPFC_NO_BUCKET	   0
-#define LPFC_LINEAR_BUCKET 1
-#define LPFC_POWER2_BUCKET 2
-	uint8_t  bucket_type;
-	uint32_t bucket_base;
-	uint32_t bucket_step;
 
 /* Maximum number of events that can be outstanding at any time*/
 #define LPFC_MAX_EVT_COUNT 512
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 09cf2cd0ae60..ef1481326fd7 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4093,333 +4093,6 @@ lpfc_static_vport_show(struct device *dev, struct device_attribute *attr,
  */
 static DEVICE_ATTR_RO(lpfc_static_vport);
 
-/**
- * lpfc_stat_data_ctrl_store - write call back for lpfc_stat_data_ctrl sysfs file
- * @dev: Pointer to class device.
- * @attr: Unused.
- * @buf: Data buffer.
- * @count: Size of the data buffer.
- *
- * This function get called when a user write to the lpfc_stat_data_ctrl
- * sysfs file. This function parse the command written to the sysfs file
- * and take appropriate action. These commands are used for controlling
- * driver statistical data collection.
- * Following are the command this function handles.
- *
- *    setbucket <bucket_type> <base> <step>
- *			       = Set the latency buckets.
- *    destroybucket            = destroy all the buckets.
- *    start                    = start data collection
- *    stop                     = stop data collection
- *    reset                    = reset the collected data
- **/
-static ssize_t
-lpfc_stat_data_ctrl_store(struct device *dev, struct device_attribute *attr,
-			  const char *buf, size_t count)
-{
-	struct Scsi_Host  *shost = class_to_shost(dev);
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
-#define LPFC_MAX_DATA_CTRL_LEN 1024
-	static char bucket_data[LPFC_MAX_DATA_CTRL_LEN];
-	unsigned long i;
-	char *str_ptr, *token;
-	struct lpfc_vport **vports;
-	struct Scsi_Host *v_shost;
-	char *bucket_type_str, *base_str, *step_str;
-	unsigned long base, step, bucket_type;
-
-	if (!strncmp(buf, "setbucket", strlen("setbucket"))) {
-		if (strlen(buf) > (LPFC_MAX_DATA_CTRL_LEN - 1))
-			return -EINVAL;
-
-		strncpy(bucket_data, buf, LPFC_MAX_DATA_CTRL_LEN);
-		str_ptr = &bucket_data[0];
-		/* Ignore this token - this is command token */
-		token = strsep(&str_ptr, "\t ");
-		if (!token)
-			return -EINVAL;
-
-		bucket_type_str = strsep(&str_ptr, "\t ");
-		if (!bucket_type_str)
-			return -EINVAL;
-
-		if (!strncmp(bucket_type_str, "linear", strlen("linear")))
-			bucket_type = LPFC_LINEAR_BUCKET;
-		else if (!strncmp(bucket_type_str, "power2", strlen("power2")))
-			bucket_type = LPFC_POWER2_BUCKET;
-		else
-			return -EINVAL;
-
-		base_str = strsep(&str_ptr, "\t ");
-		if (!base_str)
-			return -EINVAL;
-		base = simple_strtoul(base_str, NULL, 0);
-
-		step_str = strsep(&str_ptr, "\t ");
-		if (!step_str)
-			return -EINVAL;
-		step = simple_strtoul(step_str, NULL, 0);
-		if (!step)
-			return -EINVAL;
-
-		/* Block the data collection for every vport */
-		vports = lpfc_create_vport_work_array(phba);
-		if (vports == NULL)
-			return -ENOMEM;
-
-		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
-			v_shost = lpfc_shost_from_vport(vports[i]);
-			spin_lock_irq(v_shost->host_lock);
-			/* Block and reset data collection */
-			vports[i]->stat_data_blocked = 1;
-			if (vports[i]->stat_data_enabled)
-				lpfc_vport_reset_stat_data(vports[i]);
-			spin_unlock_irq(v_shost->host_lock);
-		}
-
-		/* Set the bucket attributes */
-		phba->bucket_type = bucket_type;
-		phba->bucket_base = base;
-		phba->bucket_step = step;
-
-		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
-			v_shost = lpfc_shost_from_vport(vports[i]);
-
-			/* Unblock data collection */
-			spin_lock_irq(v_shost->host_lock);
-			vports[i]->stat_data_blocked = 0;
-			spin_unlock_irq(v_shost->host_lock);
-		}
-		lpfc_destroy_vport_work_array(phba, vports);
-		return strlen(buf);
-	}
-
-	if (!strncmp(buf, "destroybucket", strlen("destroybucket"))) {
-		vports = lpfc_create_vport_work_array(phba);
-		if (vports == NULL)
-			return -ENOMEM;
-
-		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
-			v_shost = lpfc_shost_from_vport(vports[i]);
-			spin_lock_irq(shost->host_lock);
-			vports[i]->stat_data_blocked = 1;
-			lpfc_free_bucket(vport);
-			vport->stat_data_enabled = 0;
-			vports[i]->stat_data_blocked = 0;
-			spin_unlock_irq(shost->host_lock);
-		}
-		lpfc_destroy_vport_work_array(phba, vports);
-		phba->bucket_type = LPFC_NO_BUCKET;
-		phba->bucket_base = 0;
-		phba->bucket_step = 0;
-		return strlen(buf);
-	}
-
-	if (!strncmp(buf, "start", strlen("start"))) {
-		/* If no buckets configured return error */
-		if (phba->bucket_type == LPFC_NO_BUCKET)
-			return -EINVAL;
-		spin_lock_irq(shost->host_lock);
-		if (vport->stat_data_enabled) {
-			spin_unlock_irq(shost->host_lock);
-			return strlen(buf);
-		}
-		lpfc_alloc_bucket(vport);
-		vport->stat_data_enabled = 1;
-		spin_unlock_irq(shost->host_lock);
-		return strlen(buf);
-	}
-
-	if (!strncmp(buf, "stop", strlen("stop"))) {
-		spin_lock_irq(shost->host_lock);
-		if (vport->stat_data_enabled == 0) {
-			spin_unlock_irq(shost->host_lock);
-			return strlen(buf);
-		}
-		lpfc_free_bucket(vport);
-		vport->stat_data_enabled = 0;
-		spin_unlock_irq(shost->host_lock);
-		return strlen(buf);
-	}
-
-	if (!strncmp(buf, "reset", strlen("reset"))) {
-		if ((phba->bucket_type == LPFC_NO_BUCKET)
-			|| !vport->stat_data_enabled)
-			return strlen(buf);
-		spin_lock_irq(shost->host_lock);
-		vport->stat_data_blocked = 1;
-		lpfc_vport_reset_stat_data(vport);
-		vport->stat_data_blocked = 0;
-		spin_unlock_irq(shost->host_lock);
-		return strlen(buf);
-	}
-	return -EINVAL;
-}
-
-
-/**
- * lpfc_stat_data_ctrl_show - Read function for lpfc_stat_data_ctrl sysfs file
- * @dev: Pointer to class device.
- * @attr: Unused.
- * @buf: Data buffer.
- *
- * This function is the read call back function for
- * lpfc_stat_data_ctrl sysfs file. This function report the
- * current statistical data collection state.
- **/
-static ssize_t
-lpfc_stat_data_ctrl_show(struct device *dev, struct device_attribute *attr,
-			 char *buf)
-{
-	struct Scsi_Host  *shost = class_to_shost(dev);
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
-	int index = 0;
-	int i;
-	char *bucket_type;
-	unsigned long bucket_value;
-
-	switch (phba->bucket_type) {
-	case LPFC_LINEAR_BUCKET:
-		bucket_type = "linear";
-		break;
-	case LPFC_POWER2_BUCKET:
-		bucket_type = "power2";
-		break;
-	default:
-		bucket_type = "No Bucket";
-		break;
-	}
-
-	sprintf(&buf[index], "Statistical Data enabled :%d, "
-		"blocked :%d, Bucket type :%s, Bucket base :%d,"
-		" Bucket step :%d\nLatency Ranges :",
-		vport->stat_data_enabled, vport->stat_data_blocked,
-		bucket_type, phba->bucket_base, phba->bucket_step);
-	index = strlen(buf);
-	if (phba->bucket_type != LPFC_NO_BUCKET) {
-		for (i = 0; i < LPFC_MAX_BUCKET_COUNT; i++) {
-			if (phba->bucket_type == LPFC_LINEAR_BUCKET)
-				bucket_value = phba->bucket_base +
-					phba->bucket_step * i;
-			else
-				bucket_value = phba->bucket_base +
-				(1 << i) * phba->bucket_step;
-
-			if (index + 10 > PAGE_SIZE)
-				break;
-			sprintf(&buf[index], "%08ld ", bucket_value);
-			index = strlen(buf);
-		}
-	}
-	sprintf(&buf[index], "\n");
-	return strlen(buf);
-}
-
-/*
- * Sysfs attribute to control the statistical data collection.
- */
-static DEVICE_ATTR_RW(lpfc_stat_data_ctrl);
-
-/*
- * lpfc_drvr_stat_data: sysfs attr to get driver statistical data.
- */
-
-/*
- * Each Bucket takes 11 characters and 1 new line + 17 bytes WWN
- * for each target.
- */
-#define STAT_DATA_SIZE_PER_TARGET(NUM_BUCKETS) ((NUM_BUCKETS) * 11 + 18)
-#define MAX_STAT_DATA_SIZE_PER_TARGET \
-	STAT_DATA_SIZE_PER_TARGET(LPFC_MAX_BUCKET_COUNT)
-
-
-/**
- * sysfs_drvr_stat_data_read - Read function for lpfc_drvr_stat_data attribute
- * @filp: sysfs file
- * @kobj: Pointer to the kernel object
- * @bin_attr: Attribute object
- * @buf: Buffer pointer
- * @off: File offset
- * @count: Buffer size
- *
- * This function is the read call back function for lpfc_drvr_stat_data
- * sysfs file. This function export the statistical data to user
- * applications.
- **/
-static ssize_t
-sysfs_drvr_stat_data_read(struct file *filp, struct kobject *kobj,
-		struct bin_attribute *bin_attr,
-		char *buf, loff_t off, size_t count)
-{
-	struct device *dev = container_of(kobj, struct device,
-		kobj);
-	struct Scsi_Host  *shost = class_to_shost(dev);
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
-	int i = 0, index = 0;
-	unsigned long nport_index;
-	struct lpfc_nodelist *ndlp = NULL;
-	nport_index = (unsigned long)off /
-		MAX_STAT_DATA_SIZE_PER_TARGET;
-
-	if (!vport->stat_data_enabled || vport->stat_data_blocked
-		|| (phba->bucket_type == LPFC_NO_BUCKET))
-		return 0;
-
-	spin_lock_irq(shost->host_lock);
-	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!ndlp->lat_data)
-			continue;
-
-		if (nport_index > 0) {
-			nport_index--;
-			continue;
-		}
-
-		if ((index + MAX_STAT_DATA_SIZE_PER_TARGET)
-			> count)
-			break;
-
-		if (!ndlp->lat_data)
-			continue;
-
-		/* Print the WWN */
-		sprintf(&buf[index], "%02x%02x%02x%02x%02x%02x%02x%02x:",
-			ndlp->nlp_portname.u.wwn[0],
-			ndlp->nlp_portname.u.wwn[1],
-			ndlp->nlp_portname.u.wwn[2],
-			ndlp->nlp_portname.u.wwn[3],
-			ndlp->nlp_portname.u.wwn[4],
-			ndlp->nlp_portname.u.wwn[5],
-			ndlp->nlp_portname.u.wwn[6],
-			ndlp->nlp_portname.u.wwn[7]);
-
-		index = strlen(buf);
-
-		for (i = 0; i < LPFC_MAX_BUCKET_COUNT; i++) {
-			sprintf(&buf[index], "%010u,",
-				ndlp->lat_data[i].cmd_count);
-			index = strlen(buf);
-		}
-		sprintf(&buf[index], "\n");
-		index = strlen(buf);
-	}
-	spin_unlock_irq(shost->host_lock);
-	return index;
-}
-
-static struct bin_attribute sysfs_drvr_stat_data_attr = {
-	.attr = {
-		.name = "lpfc_drvr_stat_data",
-		.mode = S_IRUSR,
-	},
-	.size = LPFC_MAX_TARGET * MAX_STAT_DATA_SIZE_PER_TARGET,
-	.read = sysfs_drvr_stat_data_read,
-	.write = NULL,
-};
-
 /*
 # lpfc_link_speed: Link speed selection for initializing the Fibre Channel
 # connection.
@@ -6273,7 +5946,6 @@ static struct attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_xlane_priority.attr,
 	&dev_attr_lpfc_sg_seg_cnt.attr,
 	&dev_attr_lpfc_max_scsicmpl_time.attr,
-	&dev_attr_lpfc_stat_data_ctrl.attr,
 	&dev_attr_lpfc_aer_support.attr,
 	&dev_attr_lpfc_aer_state_cleanup.attr,
 	&dev_attr_lpfc_sriov_nr_virtfn.attr,
@@ -6332,7 +6004,6 @@ static struct attribute *lpfc_vport_attrs[] = {
 	&dev_attr_npiv_info.attr,
 	&dev_attr_lpfc_enable_da_id.attr,
 	&dev_attr_lpfc_max_scsicmpl_time.attr,
-	&dev_attr_lpfc_stat_data_ctrl.attr,
 	&dev_attr_lpfc_static_vport.attr,
 	&dev_attr_cmf_info.attr,
 	NULL,
@@ -6545,17 +6216,14 @@ lpfc_alloc_sysfs_attr(struct lpfc_vport *vport)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	int error;
 
-	error = sysfs_create_bin_file(&shost->shost_dev.kobj,
-				      &sysfs_drvr_stat_data_attr);
-
 	/* Virtual ports do not need ctrl_reg and mbox */
-	if (error || vport->port_type == LPFC_NPIV_PORT)
-		goto out;
+	if (vport->port_type == LPFC_NPIV_PORT)
+		return 0;
 
 	error = sysfs_create_bin_file(&shost->shost_dev.kobj,
 				      &sysfs_ctlreg_attr);
 	if (error)
-		goto out_remove_stat_attr;
+		goto out;
 
 	error = sysfs_create_bin_file(&shost->shost_dev.kobj,
 				      &sysfs_mbox_attr);
@@ -6565,9 +6233,6 @@ lpfc_alloc_sysfs_attr(struct lpfc_vport *vport)
 	return 0;
 out_remove_ctlreg_attr:
 	sysfs_remove_bin_file(&shost->shost_dev.kobj, &sysfs_ctlreg_attr);
-out_remove_stat_attr:
-	sysfs_remove_bin_file(&shost->shost_dev.kobj,
-			&sysfs_drvr_stat_data_attr);
 out:
 	return error;
 }
@@ -6580,8 +6245,7 @@ void
 lpfc_free_sysfs_attr(struct lpfc_vport *vport)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-	sysfs_remove_bin_file(&shost->shost_dev.kobj,
-		&sysfs_drvr_stat_data_attr);
+
 	/* Virtual ports do not need ctrl_reg and mbox */
 	if (vport->port_type == LPFC_NPIV_PORT)
 		return;
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 37a4b79010bf..5b34838ece16 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -149,7 +149,6 @@ struct lpfc_nodelist {
 	uint32_t cmd_qdepth;
 	unsigned long last_change_time;
 	unsigned long *active_rrqs_xri_bitmap;
-	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
 	uint32_t fc4_prli_sent;
 
 	/* flags to keep ndlp alive until special conditions are met */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 36090e21bb10..83d2b29ee2a6 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4787,22 +4787,6 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	    new_state == NLP_STE_UNMAPPED_NODE)
 		lpfc_nlp_reg_node(vport, ndlp);
 
-	if ((new_state ==  NLP_STE_MAPPED_NODE) &&
-		(vport->stat_data_enabled)) {
-		/*
-		 * A new target is discovered, if there is no buffer for
-		 * statistical data collection allocate buffer.
-		 */
-		ndlp->lat_data = kcalloc(LPFC_MAX_BUCKET_COUNT,
-					 sizeof(struct lpfc_scsicmd_bkt),
-					 GFP_KERNEL);
-
-		if (!ndlp->lat_data)
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				"0286 lpfc_nlp_state_cleanup failed to "
-				"allocate statistical data buffer DID "
-				"0x%x\n", ndlp->nlp_DID);
-	}
 	/*
 	 * If the node just added to Mapped list was an FCP target,
 	 * but the remote port registration failed or assigned a target
@@ -6647,7 +6631,6 @@ lpfc_nlp_release(struct kref *kref)
 	ndlp->fc4_xpt_flags = 0;
 
 	/* free ndlp memory for final ndlp release */
-	kfree(ndlp->lat_data);
 	if (ndlp->phba->sli_rev == LPFC_SLI_REV4)
 		mempool_free(ndlp->active_rrqs_xri_bitmap,
 				ndlp->phba->active_rrq_pool);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 084c0f9fdc3a..c2f53f04e1f7 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -111,62 +111,6 @@ lpfc_sli4_set_rsp_sgl_last(struct lpfc_hba *phba,
 
 #define LPFC_INVALID_REFTAG ((u32)-1)
 
-/**
- * lpfc_update_stats - Update statistical data for the command completion
- * @vport: The virtual port on which this call is executing.
- * @lpfc_cmd: lpfc scsi command object pointer.
- *
- * This function is called when there is a command completion and this
- * function updates the statistical data for the command completion.
- **/
-static void
-lpfc_update_stats(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
-{
-	struct lpfc_hba *phba = vport->phba;
-	struct lpfc_rport_data *rdata;
-	struct lpfc_nodelist *pnode;
-	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
-	unsigned long flags;
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-	unsigned long latency;
-	int i;
-
-	if (!vport->stat_data_enabled ||
-	    vport->stat_data_blocked ||
-	    (cmd->result))
-		return;
-
-	latency = jiffies_to_msecs((long)jiffies - (long)lpfc_cmd->start_time);
-	rdata = lpfc_cmd->rdata;
-	pnode = rdata->pnode;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (!pnode ||
-	    !pnode->lat_data ||
-	    (phba->bucket_type == LPFC_NO_BUCKET)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		return;
-	}
-
-	if (phba->bucket_type == LPFC_LINEAR_BUCKET) {
-		i = (latency + phba->bucket_step - 1 - phba->bucket_base)/
-			phba->bucket_step;
-		/* check array subscript bounds */
-		if (i < 0)
-			i = 0;
-		else if (i >= LPFC_MAX_BUCKET_COUNT)
-			i = LPFC_MAX_BUCKET_COUNT - 1;
-	} else {
-		for (i = 0; i < LPFC_MAX_BUCKET_COUNT-1; i++)
-			if (latency <= (phba->bucket_base +
-				((1<<i)*phba->bucket_step)))
-				break;
-	}
-
-	pnode->lat_data[i].cmd_count++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-}
-
 /**
  * lpfc_rampdown_queue_depth - Post RAMP_DOWN_QUEUE event to worker thread
  * @phba: The Hba for which this call is being executed.
@@ -4335,8 +4279,6 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 				 cmd->retries, scsi_get_resid(cmd));
 	}
 
-	lpfc_update_stats(vport, lpfc_cmd);
-
 	if (vport->cfg_max_scsicmpl_time &&
 	    time_after(jiffies, lpfc_cmd->start_time +
 	    msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
@@ -4617,7 +4559,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 				 scsi_get_resid(cmd));
 	}
 
-	lpfc_update_stats(vport, lpfc_cmd);
 	if (vport->cfg_max_scsicmpl_time &&
 	   time_after(jiffies, lpfc_cmd->start_time +
 		msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 3836d7f6a575..27696b08af0b 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -126,10 +126,6 @@ struct fcp_cmnd {
 
 };
 
-struct lpfc_scsicmd_bkt {
-	uint32_t cmd_count;
-};
-
 #define LPFC_SCSI_DMA_EXT_SIZE	264
 #define LPFC_BPL_SIZE		1024
 #define MDAC_DIRECT_CMD		0x22
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index e7efb025ed50..4d171f5c213f 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -809,74 +809,3 @@ lpfc_destroy_vport_work_array(struct lpfc_hba *phba, struct lpfc_vport **vports)
 	kfree(vports);
 }
 
-
-/**
- * lpfc_vport_reset_stat_data - Reset the statistical data for the vport
- * @vport: Pointer to vport object.
- *
- * This function resets the statistical data for the vport. This function
- * is called with the host_lock held
- **/
-void
-lpfc_vport_reset_stat_data(struct lpfc_vport *vport)
-{
-	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
-
-	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (ndlp->lat_data)
-			memset(ndlp->lat_data, 0, LPFC_MAX_BUCKET_COUNT *
-				sizeof(struct lpfc_scsicmd_bkt));
-	}
-}
-
-
-/**
- * lpfc_alloc_bucket - Allocate data buffer required for statistical data
- * @vport: Pointer to vport object.
- *
- * This function allocates data buffer required for all the FC
- * nodes of the vport to collect statistical data.
- **/
-void
-lpfc_alloc_bucket(struct lpfc_vport *vport)
-{
-	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
-
-	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-
-		kfree(ndlp->lat_data);
-		ndlp->lat_data = NULL;
-
-		if (ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
-			ndlp->lat_data = kcalloc(LPFC_MAX_BUCKET_COUNT,
-					 sizeof(struct lpfc_scsicmd_bkt),
-					 GFP_ATOMIC);
-
-			if (!ndlp->lat_data)
-				lpfc_printf_vlog(vport, KERN_ERR,
-					LOG_TRACE_EVENT,
-					"0287 lpfc_alloc_bucket failed to "
-					"allocate statistical data buffer DID "
-					"0x%x\n", ndlp->nlp_DID);
-		}
-	}
-}
-
-/**
- * lpfc_free_bucket - Free data buffer required for statistical data
- * @vport: Pointer to vport object.
- *
- * Th function frees statistical data buffer of all the FC
- * nodes of the vport.
- **/
-void
-lpfc_free_bucket(struct lpfc_vport *vport)
-{
-	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
-
-	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-
-		kfree(ndlp->lat_data);
-		ndlp->lat_data = NULL;
-	}
-}
diff --git a/drivers/scsi/lpfc/lpfc_vport.h b/drivers/scsi/lpfc/lpfc_vport.h
index f4b8528dd2e7..1c4bbda027b6 100644
--- a/drivers/scsi/lpfc/lpfc_vport.h
+++ b/drivers/scsi/lpfc/lpfc_vport.h
@@ -115,8 +115,4 @@ struct vport_cmd_tag {
 void lpfc_vport_set_state(struct lpfc_vport *vport,
 			  enum fc_vport_state new_state);
 
-void lpfc_vport_reset_stat_data(struct lpfc_vport *);
-void lpfc_alloc_bucket(struct lpfc_vport *);
-void lpfc_free_bucket(struct lpfc_vport *);
-
 #endif /* H_LPFC_VPORT */
-- 
2.26.2

