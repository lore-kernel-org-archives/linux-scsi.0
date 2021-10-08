Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14ADCC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F17E7610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhJHU0j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:39 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:34398 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242650AbhJHU0i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:38 -0400
Received: by mail-pj1-f48.google.com with SMTP id q7-20020a17090a2e0700b001a01027dd88so6321086pjd.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yKgFQ4b5+xlIZpN+tyS/Y7wNncIIGGAO+CjlSX8yfv4=;
        b=6pVJ5iWRY6JZ91kM9awpVyDmsyrietxP+2hWLagwJuhI75zoymnT+Zuk5v94nmnSuU
         N8l5V5whVB71tenQ6scOYmvkCS7kHdiAR5ScM+jTgP8ZEradwPXoMjqwQlw6H/bQrUNJ
         RGKIzBSME/pMpnEYvLuPV3lUmkwwHbmG31RfemIdsUOwbR6IY8CK9/66BqHVsestd9s9
         U8HHHZHBEPGaOHOesMiDbwRMNfylm3nx/xZOI2Wc0yWKq7QZ4v8tmoc8BLj7EDfSXVK8
         vBjdBROfY93I+1++KpiqXVabqmbMCa5fiZhBMZbBnpOtroyjen8bWOiIw4B8whHTpza2
         BrqQ==
X-Gm-Message-State: AOAM5323/N463Pg75AsR2oAgSmAPtWOExpWLu/Nyy3ngIVtqJY2b7rFI
        JuiaxTFXKZsJv+bdTj72Tn8=
X-Google-Smtp-Source: ABdhPJzSUiJ4NeOF1sFeSfUrtioEcinSfLPW01WbARjRJPS1Oo8Gh4pADxA9LLBAOY80PmPFhWg5/g==
X-Received: by 2002:a17:902:9684:b0:13e:32cb:c95d with SMTP id n4-20020a170902968400b0013e32cbc95dmr11359179plp.31.1633724682743;
        Fri, 08 Oct 2021 13:24:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 19/46] scsi: fnic: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:26 -0700
Message-Id: <20211008202353.1448570-20-bvanassche@acm.org>
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
 
