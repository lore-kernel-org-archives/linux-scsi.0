Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05C7C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCIT0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjCIT00 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:26:26 -0500
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900E8E841C
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:26:25 -0800 (PST)
Received: by mail-pg1-f179.google.com with SMTP id q23so1711052pgt.7
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678389985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGZZNfXoyPkNTywBK1wXL/TXSFbB7zwD2eO1FuTaAKQ=;
        b=RUgr8GwWF+sWXifVd9X9hE63UqOc5K2LMiEX19YZ+zYpt6dHEXAc29+pt6x6Qmo1tP
         WeB8mv7cOmssR3D4igU19deuWgk4BFhITWQo76tYhWuD4h8aVp6XadTfOzinkb72RWCG
         Xbb7xLZN0MnXUWT5U0jzoGWlfpM9cGB2o6bImrxnqIUHPUnDLcNuyW+ITLnj5lN89mYa
         qVuuQ+k5YDaVGz4dgttEy2qZe+Z8kImqOzSQ8dxwv+ubPw/2A2p0uLvZpS57dhX/3Ney
         NtJtBfnyM3vjs8RLKRzGmlI9ukGUdnj5GPwDR+Bc5U96SxBE4IAdFfFyctR3q3bc/THM
         ViLg==
X-Gm-Message-State: AO0yUKVYVKBueVutXncOiZWsVMAXW3v/zir8zVCCqo3RACA3N5dbt1hb
        vzHIuD9FEO26cPev9Ku1Ke0=
X-Google-Smtp-Source: AK7set9RLS6oMGy1Q14ysvbtMeoyGtlLUG3dv83ygRQPxE8bgCf9s1eczp+9IMURongm1+YYL8H5Dg==
X-Received: by 2002:a62:7b03:0:b0:5a8:c699:3eaa with SMTP id w3-20020a627b03000000b005a8c6993eaamr22938714pfc.9.1678389984955;
        Thu, 09 Mar 2023 11:26:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:26:24 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        John Garry <john.g.garry@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 02/82] scsi: core: Declare most SCSI host template pointers const
Date:   Thu,  9 Mar 2023 11:24:54 -0800
Message-Id: <20230309192614.2240602-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
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
