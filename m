Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6D2C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjCVTz3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCVTz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:55:27 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B9054C8D
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:55:26 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id kc4so5678601plb.10
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGZZNfXoyPkNTywBK1wXL/TXSFbB7zwD2eO1FuTaAKQ=;
        b=vsw9DNfBoYM4pQ+p6WgDt7YLUwAa4XLVMWEiwXd/iKxVQFeoI4RJe/JyBmH4zIy8Cd
         0wda0x9JlvUY6IeNFOa5bIZrpK0S2MUf+AlY5GsRk1CHO8MQdOe//6ZrDnzLFCo93TYU
         hX1lilJGdwbWhE+94ylZJbnrEvepCgGhaM+VnJbLRZL3VsP4cEhoeOwwFC82yP3bhW9k
         ucxhb1k9VCnoz14xLD/7JviI6wEJrdyHG0zL2PZLCsfpP7G+EUODRQCbUgbKSGBfqMH7
         qDnozH+fFY1ZtS9FKhZfQY0qf4AiGx4pYQTMmeoSFvo1+iUZbFrp4waY367WZVSex7g9
         BypA==
X-Gm-Message-State: AO0yUKUH3uvGbuIZui/wX/t95TgC5+gRrisLR4OydbCRlg3RcHOnzCe1
        uMJ4H7p3IIT6OOsHhkp7m3c=
X-Google-Smtp-Source: AK7set9khTRr1ThpxZEupudCNCnfl1Nj0/IgJH+2pccsfYcwB9KeiDNqFgAS+8muLAs2CgME1BBvrA==
X-Received: by 2002:a17:90b:3e8c:b0:233:fb7d:845a with SMTP id rj12-20020a17090b3e8c00b00233fb7d845amr5536070pjb.4.1679514926086;
        Wed, 22 Mar 2023 12:55:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:55:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        John Garry <john.g.garry@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 02/80] scsi: core: Declare most SCSI host template pointers const
Date:   Wed, 22 Mar 2023 12:53:57 -0700
Message-Id: <20230322195515.1267197-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for constifying most SCSI host template pointers by constifying
the SCSI host template pointer arguments and variables in the SCSI core.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 16 ++++++++--------
 drivers/scsi/scsi_sysfs.c |  6 +++---
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2aa2c2aee6e7..3ec8bfd4090f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -58,7 +58,7 @@
 #define HOST_RESET_SETTLE_TIME  (10)
 
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
-static enum scsi_disposition scsi_try_to_abort_cmd(struct scsi_host_template *,
+static enum scsi_disposition scsi_try_to_abort_cmd(const struct scsi_host_template *,
 						   struct scsi_cmnd *);
 
 void scsi_eh_wakeup(struct Scsi_Host *shost)
@@ -699,7 +699,7 @@ EXPORT_SYMBOL_GPL(scsi_check_sense);
 
 static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 {
-	struct scsi_host_template *sht = sdev->host->hostt;
+	const struct scsi_host_template *sht = sdev->host->hostt;
 	struct scsi_device *tmp_sdev;
 
 	if (!sht->track_queue_depth ||
@@ -731,7 +731,7 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 
 static void scsi_handle_queue_full(struct scsi_device *sdev)
 {
-	struct scsi_host_template *sht = sdev->host->hostt;
+	const struct scsi_host_template *sht = sdev->host->hostt;
 	struct scsi_device *tmp_sdev;
 
 	if (!sht->track_queue_depth)
@@ -840,7 +840,7 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
 	unsigned long flags;
 	enum scsi_disposition rtn;
 	struct Scsi_Host *host = scmd->device->host;
-	struct scsi_host_template *hostt = host->hostt;
+	const struct scsi_host_template *hostt = host->hostt;
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		shost_printk(KERN_INFO, host, "Snd Host RST\n"));
@@ -870,7 +870,7 @@ static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	unsigned long flags;
 	enum scsi_disposition rtn;
 	struct Scsi_Host *host = scmd->device->host;
-	struct scsi_host_template *hostt = host->hostt;
+	const struct scsi_host_template *hostt = host->hostt;
 
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
 		"%s: Snd Bus RST\n", __func__));
@@ -912,7 +912,7 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 	unsigned long flags;
 	enum scsi_disposition rtn;
 	struct Scsi_Host *host = scmd->device->host;
-	struct scsi_host_template *hostt = host->hostt;
+	const struct scsi_host_template *hostt = host->hostt;
 
 	if (!hostt->eh_target_reset_handler)
 		return FAILED;
@@ -941,7 +941,7 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
 	enum scsi_disposition rtn;
-	struct scsi_host_template *hostt = scmd->device->host->hostt;
+	const struct scsi_host_template *hostt = scmd->device->host->hostt;
 
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
@@ -970,7 +970,7 @@ static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
  *    link down on FibreChannel)
  */
 static enum scsi_disposition
-scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
+scsi_try_to_abort_cmd(const struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
 {
 	if (!hostt->eh_abort_handler)
 		return FAILED;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ee28f73af4d4..603e8fcfcb8a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -296,7 +296,7 @@ store_host_reset(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
-	struct scsi_host_template *sht = shost->hostt;
+	const struct scsi_host_template *sht = shost->hostt;
 	int ret = -EINVAL;
 	int type;
 
@@ -1025,7 +1025,7 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 {
 	int depth, retval;
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct scsi_host_template *sht = sdev->host->hostt;
+	const struct scsi_host_template *sht = sdev->host->hostt;
 
 	if (!sht->change_queue_depth)
 		return -EINVAL;
@@ -1606,7 +1606,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
 	unsigned long flags;
 	struct Scsi_Host *shost = sdev->host;
-	struct scsi_host_template *hostt = shost->hostt;
+	const struct scsi_host_template *hostt = shost->hostt;
 	struct scsi_target  *starget = sdev->sdev_target;
 
 	device_initialize(&sdev->sdev_gendev);
