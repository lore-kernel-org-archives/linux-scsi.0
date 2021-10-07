Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2287C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC89D61130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhJGVVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:33 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:46966 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhJGVVc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:32 -0400
Received: by mail-pf1-f182.google.com with SMTP id u7so6376956pfg.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1txEUM4H4idv3DopyS9GPuuUIeCZSz9pvwjh9863dW4=;
        b=ey6HwYDRIYv7kmvOSGJ38OLFnzIT2QMLiAgISMpvhXwG5FMuuy4q0cr2ybgdIddGKr
         LY9PtA7O4tPBhQyokG6mT2hfVsxvxFSpzq7TsSSjQ3CqJQ1Huw6BrsbB4J26o0GERF2P
         7TSD8Pn7RAOgqMOVRYlh+zp79zuTWhF1UAWuO0ald56PnLyCJhgSbBQ4ANH8t6rKLoaY
         p7kjuR3OMxzLfdln+Hv1ryEBk2pyX3odSvoL1bXPx9XwUqnjjsU+2XKq+OeAOhVcuTsG
         nEY2PEfwLRJhZcSs7Ki8Dnh+ZKAcCG4z/uzCmwpaQPwgxXB7dWM2WcM94wq+VsYWB/xP
         cZWQ==
X-Gm-Message-State: AOAM530HfpxC+2diVR3J/Aj84pRe+DLESmwMeZxLNjXEpoR7QboIWB5D
        qoyTQ1KGKfrG2ZIDh/3MQsg=
X-Google-Smtp-Source: ABdhPJzT/8idpKDgTmsnMMap6B8r1s5ZEFKYd7/GTladnl5qfLLupRMjbC6MkASYf9IuSddAP6WIcA==
X-Received: by 2002:aa7:9d0b:0:b0:44c:62a6:8679 with SMTP id k11-20020aa79d0b000000b0044c62a68679mr6732041pfp.0.1633641578084;
        Thu, 07 Oct 2021 14:19:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 13/46] scsi: be2iscsi: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:19 -0700
Message-Id: <20211007211852.256007-14-bvanassche@acm.org>
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
 drivers/scsi/be2iscsi/be_main.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e70f69f791db..725aa0b30106 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -163,14 +163,24 @@ DEVICE_ATTR(beiscsi_active_session_count, S_IRUGO,
 	     beiscsi_active_session_disp, NULL);
 DEVICE_ATTR(beiscsi_free_session_count, S_IRUGO,
 	     beiscsi_free_session_disp, NULL);
-static struct device_attribute *beiscsi_attrs[] = {
-	&dev_attr_beiscsi_log_enable,
-	&dev_attr_beiscsi_drvr_ver,
-	&dev_attr_beiscsi_adapter_family,
-	&dev_attr_beiscsi_fw_ver,
-	&dev_attr_beiscsi_active_session_count,
-	&dev_attr_beiscsi_free_session_count,
-	&dev_attr_beiscsi_phys_port,
+
+static struct attribute *beiscsi_attrs[] = {
+	&dev_attr_beiscsi_log_enable.attr,
+	&dev_attr_beiscsi_drvr_ver.attr,
+	&dev_attr_beiscsi_adapter_family.attr,
+	&dev_attr_beiscsi_fw_ver.attr,
+	&dev_attr_beiscsi_active_session_count.attr,
+	&dev_attr_beiscsi_free_session_count.attr,
+	&dev_attr_beiscsi_phys_port.attr,
+	NULL,
+};
+
+static const struct attribute_group beiscsi_attr_group = {
+	.attrs = beiscsi_attrs,
+};
+
+static const struct attribute_group *beiscsi_attr_groups[] = {
+	&beiscsi_attr_group,
 	NULL,
 };
 
@@ -391,7 +401,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.eh_abort_handler = beiscsi_eh_abort,
 	.eh_device_reset_handler = beiscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_session_reset,
-	.shost_attrs = beiscsi_attrs,
+	.shost_groups = beiscsi_attr_groups,
 	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
 	.can_queue = BE2_IO_DEPTH,
 	.this_id = -1,
