Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F9DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7FE961100
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242910AbhJHU1a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:30 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:45933 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242700AbhJHU1T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:19 -0400
Received: by mail-pf1-f180.google.com with SMTP id i65so6153032pfe.12
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jCg2eGQ4g3QgDwVGpIZogGbCNCN5Pmyt9wpBQepzDsI=;
        b=GX+xLH9igKsvK605c3LoqUjxBa4i1OJdqc1xuDLxu8o2gTNWuhIrWOjTciksgdD2b/
         BGkzuSF2gQxOh9UvWUQHM4PBfZ39mh8ZFtmpqRZmo6JJg/XqVkgKlQYgMmlKsTKANrkH
         WsNZLCl/psku6UlawmmaUZKFzRd06uQURjnr3dPqCn3+Uyv7HVZ4NSQfLxdyBtzNx+SK
         Ifx1wha6OI6njO8id7WdjjJ6B3yqNHAYiRNjUEyX/qout2JFNGbIe4eOQahUWmHCqYBy
         3W2ERgZ3yUrC47MdS7v8IYsz2p3r40Pse4d/RWe2j5lKX573UNHrk9QaKc+hcr9F7JmI
         uRSg==
X-Gm-Message-State: AOAM53204T5IRSlDbEA6+4BtDVcLfM+BYVmUcrMeFwglFfXt4oy0KbJv
        RQ+gv632u2B1HGq3C49eFJIo4oxvfCPTLw==
X-Google-Smtp-Source: ABdhPJzY+mAbHbBUvrADIm+wgHXGFt7B5zverKzk04dthse8XnVHhRRAZfi11puMlk9v4rgtrR7MFg==
X-Received: by 2002:a63:e002:: with SMTP id e2mr6280156pgh.386.1633724723509;
        Fri, 08 Oct 2021 13:25:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 43/46] scsi: snic: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:50 -0700
Message-Id: <20211008202353.1448570-44-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211008202353.1448570-1-bvanassche@acm.org>
References: <20211008202353.1448570-1-bvanassche@acm.org>
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
