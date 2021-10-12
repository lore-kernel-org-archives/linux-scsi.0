Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B769C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E707860F92
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbhJLXiu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:50 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:36752 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbhJLXis (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:48 -0400
Received: by mail-pf1-f171.google.com with SMTP id m26so856461pff.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yKgFQ4b5+xlIZpN+tyS/Y7wNncIIGGAO+CjlSX8yfv4=;
        b=p7c/8v1xt3D5oEXXreaW4P4ikASFZQurSEaOuBLHR64iLJDHpludND9OwUKjwiMrCu
         LO3vZNGL844Xpm+CXOGEYyh9I5u6s8WAwhSWXYUNz40ZU3jD+7B9Muce1XWj4eKy1xSp
         V10xPAYXHG58vmR5O34F2sDxIHLILJwuMFWTCrkqQSb9f+CjfuVaiLeGxW8ElDAVilai
         p2phP9wsKUqf7GTO6aSDGmCEzw6fdnc8TD/mmU8Zma5kjiF1rsHBOvXrm0KeYjSB+T5u
         oGD7WM7EzyLJxlSJHU9NCvqoKSmSHRrzazBQbplgBYJN3y2Jvs2BBT3PY7+ttJ4mAbbl
         k9Bg==
X-Gm-Message-State: AOAM533Ocb5UzD/HmI8LtN2xYXv6pKG1b7ZvdLxnGCB1XqG8rzuj0WEL
        iI7A0iUXNQkNfSu9s4xOSMs=
X-Google-Smtp-Source: ABdhPJzWPoY+1X7kNegc4Ra/2w7UyJI45XUVg6S3/QHzv9KrKe1IHzqC9KqYzGGf76HqwVPIS7Pfmg==
X-Received: by 2002:aa7:8010:0:b0:44c:9d9:ecc with SMTP id j16-20020aa78010000000b0044c09d90eccmr34189844pfi.39.1634081805661;
        Tue, 12 Oct 2021 16:36:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 19/46] scsi: fnic: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:31 -0700
Message-Id: <20211012233558.4066756-20-bvanassche@acm.org>
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
 drivers/scsi/fnic/fnic.h       |  2 +-
 drivers/scsi/fnic/fnic_attrs.c | 17 +++++++++++++----
 drivers/scsi/fnic/fnic_main.c  |  2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 69f373b53132..b95d0063dedb 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -322,7 +322,7 @@ static inline struct fnic *fnic_from_ctlr(struct fcoe_ctlr *fip)
 
 extern struct workqueue_struct *fnic_event_queue;
 extern struct workqueue_struct *fnic_fip_queue;
-extern struct device_attribute *fnic_attrs[];
+extern const struct attribute_group *fnic_host_groups[];
 
 void fnic_clear_intr_mode(struct fnic *fnic);
 int fnic_set_intr_mode(struct fnic *fnic);
diff --git a/drivers/scsi/fnic/fnic_attrs.c b/drivers/scsi/fnic/fnic_attrs.c
index aea0c3becfd4..bbe2ca4971b2 100644
--- a/drivers/scsi/fnic/fnic_attrs.c
+++ b/drivers/scsi/fnic/fnic_attrs.c
@@ -48,9 +48,18 @@ static DEVICE_ATTR(fnic_state, S_IRUGO, fnic_show_state, NULL);
 static DEVICE_ATTR(drv_version, S_IRUGO, fnic_show_drv_version, NULL);
 static DEVICE_ATTR(link_state, S_IRUGO, fnic_show_link_state, NULL);
 
-struct device_attribute *fnic_attrs[] = {
-	&dev_attr_fnic_state,
-	&dev_attr_drv_version,
-	&dev_attr_link_state,
+static struct attribute *fnic_host_attrs[] = {
+	&dev_attr_fnic_state.attr,
+	&dev_attr_drv_version.attr,
+	&dev_attr_link_state.attr,
 	NULL,
 };
+
+static const struct attribute_group fnic_host_attr_group = {
+	.attrs = fnic_host_attrs
+};
+
+const struct attribute_group *fnic_host_groups[] = {
+	&fnic_host_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 786f9d2704b6..44dbaa662d94 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -122,7 +122,7 @@ static struct scsi_host_template fnic_host_template = {
 	.can_queue = FNIC_DFLT_IO_REQ,
 	.sg_tablesize = FNIC_MAX_SG_DESC_CNT,
 	.max_sectors = 0xffff,
-	.shost_attrs = fnic_attrs,
+	.shost_groups = fnic_host_groups,
 	.track_queue_depth = 1,
 };
 
