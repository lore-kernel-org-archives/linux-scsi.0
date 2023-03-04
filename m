Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BAEC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCDAbQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCDAbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:31:15 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4946513D
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:14 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id i5so4555418pla.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21XYzlNxLuePMqcRB2aFbRdCr1XgIAEA24rCE01elBo=;
        b=asoJdNbsHX7awj1dFjDK+93ag5g8gi2DOD/ufQDPIwr/QPWVuq/cEmpQ7LlviIH+zN
         quEK1CWTPtjsq1d2NowVbA6/y8vNipaoHLizvj3M2lyBF51EKYsLLnmJkBPEywkpj8/8
         +oZL+00cdzT+oZZkP+KfdS9KwWZryGA85LNtk/0Gr2EzBoKBmIe9sJVUJrIIIfl5Ros3
         N6KStA8SH4sECUH5cDzRL8HNGx9186JqhzKAQGTg5ZycN/dIjgAdg7hPiQovJfK5eoCR
         STx1UnXqRXXah0xpeYFviDOyCRhJ13fSPPlo0tM8l/kl1XFFS2vGtG9OMazcRe5qHxSU
         J7QA==
X-Gm-Message-State: AO0yUKU5Piadetr6k6mRnD6XP2H/40mwBt2Qwc643/VUYOqMPssj36mj
        Y4piyR12i2FtuQ8l81f1Ugc=
X-Google-Smtp-Source: AK7set8RPJtYDRhd1I2h3SmEtI0pC1JP8bIctr8P6ydmH23i+o6kW4UngXhgFT4XLkN4S40/AvLP2w==
X-Received: by 2002:a17:902:d586:b0:19e:3caa:804e with SMTP id k6-20020a170902d58600b0019e3caa804emr3382652plh.6.1677889873761;
        Fri, 03 Mar 2023 16:31:13 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 02/81] scsi: core: Declare most SCSI host template pointers const
Date:   Fri,  3 Mar 2023 16:29:44 -0800
Message-Id: <20230304003103.2572793-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for constifying most SCSI host template pointers by constifying
the SCSI host template pointer arguments and variables in the SCSI core.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
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
