Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37D9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D63CE60ED4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbhJLXim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:42 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:44639 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbhJLXil (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:41 -0400
Received: by mail-pj1-f45.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so838585pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6xpdXRUZrHa2dh7OhsosMe9PUV3PZXzVX6aPTtYLzwQ=;
        b=A/Z7YPbetwke0zTbYAv8+B6LrCMxPVBuwIGV2vpDtdxJztx3Ro8vvyFxg0vMCB9bhP
         Gdnxf/MjuZjKMQF7DzjiDxx00rmjqX9DT3L1CyS9hZI87bJgmf63SZiLZInPOMdoTgg4
         Ezwv3vDWo6kY/kPPw6SAv92HvevP+AGexQDmrbahRZlTVXq/C1g3bqVSk8z+cXh25UsV
         B6HfbwiCAHOnel/NBnU2SPOiFpdmDCA3gjvGjf3D5JXZWDl/Kc3PF5D+k1ZntRCXQPWH
         un1Jjs/1oNXlxZk9nWQFOhNrTnV5PWDjhd4pvAA2zmJ6TOvkrtkV2ZondzaoD6CSWd7C
         duXw==
X-Gm-Message-State: AOAM5320H6jDbItm5+GkIDlBXjV4G3FJsyl+kVUInU0GHPYVnnjy6nnq
        vKU+LFu+WHJ8mnlAmo163BQ=
X-Google-Smtp-Source: ABdhPJyNGEP2oQQKo35rMUMETe1wQML1BvylWijIRVVfJPYzdj9E3RrTXpjiEv8yIyuXuyo4hrpXsw==
X-Received: by 2002:a17:90a:3e0c:: with SMTP id j12mr9502206pjc.23.1634081798460;
        Tue, 12 Oct 2021 16:36:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 16/46] scsi: bnx2i: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:28 -0700
Message-Id: <20211012233558.4066756-17-bvanassche@acm.org>
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
 drivers/scsi/bnx2i/bnx2i.h       |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c | 15 ++++++++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 663a63d4dae4..df7d04afce05 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -795,7 +795,7 @@ extern struct cnic_ulp_ops bnx2i_cnic_cb;
 extern unsigned int sq_size;
 extern unsigned int rq_size;
 
-extern struct device_attribute *bnx2i_dev_attributes[];
+extern const struct attribute_group *bnx2i_dev_groups[];
 
 
 
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1b5f3e143f07..e21b053b4f3e 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2266,7 +2266,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.cmd_per_lun		= 128,
 	.this_id		= -1,
 	.sg_tablesize		= ISCSI_MAX_BDS_PER_CMD,
-	.shost_attrs		= bnx2i_dev_attributes,
+	.shost_groups		= bnx2i_dev_groups,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index bea00073cb7c..d6b0bbb5176b 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -142,8 +142,17 @@ static DEVICE_ATTR(sq_size, S_IRUGO | S_IWUSR,
 static DEVICE_ATTR(num_ccell, S_IRUGO | S_IWUSR,
 		   bnx2i_show_ccell_info, bnx2i_set_ccell_info);
 
-struct device_attribute *bnx2i_dev_attributes[] = {
-	&dev_attr_sq_size,
-	&dev_attr_num_ccell,
+static struct attribute *bnx2i_dev_attributes[] = {
+	&dev_attr_sq_size.attr,
+	&dev_attr_num_ccell.attr,
+	NULL
+};
+
+static const struct attribute_group bnx2i_dev_attr_group = {
+	.attrs = bnx2i_dev_attributes
+};
+
+const struct attribute_group *bnx2i_dev_groups[] = {
+	&bnx2i_dev_attr_group,
 	NULL
 };
