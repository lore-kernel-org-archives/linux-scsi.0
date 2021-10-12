Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04F8C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88E6160EBB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbhJLXjd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:33 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:40739 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbhJLXj3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:29 -0400
Received: by mail-pj1-f48.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so3032619pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jCg2eGQ4g3QgDwVGpIZogGbCNCN5Pmyt9wpBQepzDsI=;
        b=oYEMunX8p9u5aUwMCzXo6SvrhVs0UBKah3oNMgepaB7etyNGFkrTNOub5arGViNzmi
         liv4pBZlM1ESjQRECtvPXG+07LwKlaDP/GZnYMlvafKGwjH6okOjRWEdaGApU4vNgQpg
         8mMmSMPGOWcdLQs67Qy8X7f4ZM0DB3thC3HEB48ORyXQ6FBQ6LSr/7bL/ON2uz3WtBsm
         fFaPjf+Ydmyj1yq6SFuAWWfLOR5I0yhwO9fYpFAy+tTlH5h9tIuufUlcnWlpJuOjixof
         pjCqfWIrd40zsLOndrjzW8A09R/xXqjU8UaZ6kbUTucxRxo/+f0f4NS+D/LbS3Y8G6qi
         TdVg==
X-Gm-Message-State: AOAM532Vx9cKFBn1PXPpJaPJK9Up0tXE9CNlbNruu+4uLIkB46IgJJJQ
        ZMaxl6NiLaRNakru+10e8Ls=
X-Google-Smtp-Source: ABdhPJyjxjZNui5GokBWiajsbEChicTZz/c0AV7Rnvk1bmOToyH1bho27KsyP/T/4TsAqz2148Wu4A==
X-Received: by 2002:a17:90a:7d11:: with SMTP id g17mr9424016pjl.19.1634081846652;
        Tue, 12 Oct 2021 16:37:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 43/46] scsi: snic: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:55 -0700
Message-Id: <20211012233558.4066756-44-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/snic/snic.h       |  2 +-
 drivers/scsi/snic/snic_attrs.c | 19 ++++++++++++++-----
 drivers/scsi/snic/snic_main.c  |  2 +-
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index f4c666285bba..4ec7e30678e1 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -374,7 +374,7 @@ int snic_glob_init(void);
 void snic_glob_cleanup(void);
 
 extern struct workqueue_struct *snic_event_queue;
-extern struct device_attribute *snic_attrs[];
+extern const struct attribute_group *snic_host_groups[];
 
 int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
diff --git a/drivers/scsi/snic/snic_attrs.c b/drivers/scsi/snic/snic_attrs.c
index 32d5d556b6f8..dc03ce1ec909 100644
--- a/drivers/scsi/snic/snic_attrs.c
+++ b/drivers/scsi/snic/snic_attrs.c
@@ -68,10 +68,19 @@ static DEVICE_ATTR(snic_state, S_IRUGO, snic_show_state, NULL);
 static DEVICE_ATTR(drv_version, S_IRUGO, snic_show_drv_version, NULL);
 static DEVICE_ATTR(link_state, S_IRUGO, snic_show_link_state, NULL);
 
-struct device_attribute *snic_attrs[] = {
-	&dev_attr_snic_sym_name,
-	&dev_attr_snic_state,
-	&dev_attr_drv_version,
-	&dev_attr_link_state,
+static struct attribute *snic_host_attrs[] = {
+	&dev_attr_snic_sym_name.attr,
+	&dev_attr_snic_state.attr,
+	&dev_attr_drv_version.attr,
+	&dev_attr_link_state.attr,
 	NULL,
 };
+
+static const struct attribute_group snic_host_attr_group = {
+	.attrs = snic_host_attrs
+};
+
+const struct attribute_group *snic_host_groups[] = {
+	&snic_host_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 14f4ce665e58..29d56396058c 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -129,7 +129,7 @@ static struct scsi_host_template snic_host_template = {
 	.can_queue = SNIC_MAX_IO_REQ,
 	.sg_tablesize = SNIC_MAX_SG_DESC_CNT,
 	.max_sectors = 0x800,
-	.shost_attrs = snic_attrs,
+	.shost_groups = snic_host_groups,
 	.track_queue_depth = 1,
 	.cmd_size = sizeof(struct snic_internal_io_state),
 	.proc_name = "snic_scsi",
