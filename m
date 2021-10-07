Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBF8C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81198610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbhJGVVs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:48 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:36787 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbhJGVVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:47 -0400
Received: by mail-pl1-f177.google.com with SMTP id y5so4786261pll.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5qV7psAg7CTtX/SZ4vw1EGgW2BEbq+WxYdQAxMFF7QA=;
        b=bGVpZQDlmuEinVp1hLmpkMaYlRIePtkJ33qwoY/9kf8ZAFnxWh3XOnKyEunHgXR2zj
         Fmoo8KIRJrjZyL8VZbBtjoElNe5zQP6+skLRhduom3w3Q+vYhZMzzVtSKgg5la3dvogl
         zQxC31s6dLxTX5cOruFTYp8rd6nUawxAg9eBozSg92VkwJV1/RTSIeyr1/iFovYORYg+
         8oTzoBupJe/gNNYiTSvY5XDYKzKSCdOr6kg3jEnnw7XDyXa1pxylW2brR3o94WAdS6mj
         MtiIRC4pttGtQWJnx5YXDbzMXN68sOBBM8Aj+BtNJl76vqYElG+fZAWN2TmCdN+MVGw/
         tD6w==
X-Gm-Message-State: AOAM53393V2sjNjKU8ev8pvdBdlkGkHKlVPkbUw55Edet1GslQss+vBN
        A2BYRwhf0+I4P1swOp/X/+g=
X-Google-Smtp-Source: ABdhPJx2O+0csuZWcvVzkGOE+0DVRO6Q//wOCuhAGtLhlPSff6r15/kbniveMqUAviDLGwBjja0djQ==
X-Received: by 2002:a17:90a:9289:: with SMTP id n9mr7980324pjo.27.1633641592721;
        Thu, 07 Oct 2021 14:19:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 19/46] scsi: fnic: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:25 -0700
Message-Id: <20211007211852.256007-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007211852.256007-1-bvanassche@acm.org>
References: <20211007211852.256007-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic.h       |  2 +-
 drivers/scsi/fnic/fnic_attrs.c | 17 +++++++++++++----
 drivers/scsi/fnic/fnic_main.c  |  2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 69f373b53132..d617c1d3dcf0 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -322,7 +322,7 @@ static inline struct fnic *fnic_from_ctlr(struct fcoe_ctlr *fip)
 
 extern struct workqueue_struct *fnic_event_queue;
 extern struct workqueue_struct *fnic_fip_queue;
-extern struct device_attribute *fnic_attrs[];
+extern const struct attribute_group *fnic_attr_groups[];
 
 void fnic_clear_intr_mode(struct fnic *fnic);
 int fnic_set_intr_mode(struct fnic *fnic);
diff --git a/drivers/scsi/fnic/fnic_attrs.c b/drivers/scsi/fnic/fnic_attrs.c
index aea0c3becfd4..afc4566629c6 100644
--- a/drivers/scsi/fnic/fnic_attrs.c
+++ b/drivers/scsi/fnic/fnic_attrs.c
@@ -48,9 +48,18 @@ static DEVICE_ATTR(fnic_state, S_IRUGO, fnic_show_state, NULL);
 static DEVICE_ATTR(drv_version, S_IRUGO, fnic_show_drv_version, NULL);
 static DEVICE_ATTR(link_state, S_IRUGO, fnic_show_link_state, NULL);
 
-struct device_attribute *fnic_attrs[] = {
-	&dev_attr_fnic_state,
-	&dev_attr_drv_version,
-	&dev_attr_link_state,
+static struct attribute *fnic_attrs[] = {
+	&dev_attr_fnic_state.attr,
+	&dev_attr_drv_version.attr,
+	&dev_attr_link_state.attr,
 	NULL,
 };
+
+static const struct attribute_group fnic_attr_group = {
+	.attrs = fnic_attrs
+};
+
+const struct attribute_group *fnic_attr_groups[] = {
+	&fnic_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 786f9d2704b6..5ce44eacaf20 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -122,7 +122,7 @@ static struct scsi_host_template fnic_host_template = {
 	.can_queue = FNIC_DFLT_IO_REQ,
 	.sg_tablesize = FNIC_MAX_SG_DESC_CNT,
 	.max_sectors = 0xffff,
-	.shost_attrs = fnic_attrs,
+	.shost_groups = fnic_attr_groups,
 	.track_queue_depth = 1,
 };
 
