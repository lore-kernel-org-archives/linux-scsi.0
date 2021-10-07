Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE79C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED44F610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241180AbhJGVWi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:38 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:54070 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238287AbhJGVWf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:35 -0400
Received: by mail-pj1-f48.google.com with SMTP id ls18so5903762pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IIxwxB+qtMA1O6WI2xi9YdeEorUR8OazdCyqzLBW5Ac=;
        b=OD6bdByK5qyglYPh4t+BguzCrxdGhS0ax5H4Cmh6JGmeRrpR0JREdRCmyvW3XvPS0B
         AlpQKvbiQI56DhczL26PyTQaFSW7KThUvKz76u1keFrMUyTWR9iQ7qtKl1guLekVQ1Bn
         72yFtHSJ0uKgajQdd4hDpR+jdfj2tm0cZaEUfxQtC8X8TgT0eitDZ9XNihPOowSMdLAC
         Bv4NyfutgZJEJSjVqS/WdeiqIxcP7W2PFGNBH5SFkssLXI4g7e49O0MQ/jk+pQQhiWiZ
         aVUFzRBqduza1Ekmchg+CwehmKVlhmKRbYY9AsviJoj8xYBmRY0nBhZjwphCEvRiCG3d
         30gw==
X-Gm-Message-State: AOAM533Yyde7umB3XTyDtZpB8DxnTgQjg9dmdE+SKhSNb5/IRQV3cv2s
        6qPevbaqBHwc4NjI/YrMS3c=
X-Google-Smtp-Source: ABdhPJwpmUJ30XnNw4nVMvKuAdmZjoHv/npiRpINGOq5oWebPOAnzAkD4qTXm2zR2+YWTJreRruAAw==
X-Received: by 2002:a17:90b:4a45:: with SMTP id lb5mr7932357pjb.94.1633641640673;
        Thu, 07 Oct 2021 14:20:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 43/46] scsi: snic: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:49 -0700
Message-Id: <20211007211852.256007-44-bvanassche@acm.org>
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
 drivers/scsi/snic/snic.h       |  2 +-
 drivers/scsi/snic/snic_attrs.c | 19 ++++++++++++++-----
 drivers/scsi/snic/snic_main.c  |  2 +-
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index f4c666285bba..13f04ae7c5bb 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -374,7 +374,7 @@ int snic_glob_init(void);
 void snic_glob_cleanup(void);
 
 extern struct workqueue_struct *snic_event_queue;
-extern struct device_attribute *snic_attrs[];
+extern const struct attribute_group *snic_attr_groups[];
 
 int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
diff --git a/drivers/scsi/snic/snic_attrs.c b/drivers/scsi/snic/snic_attrs.c
index 32d5d556b6f8..70c2304aca6e 100644
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
+static struct attribute *snic_attrs[] = {
+	&dev_attr_snic_sym_name.attr,
+	&dev_attr_snic_state.attr,
+	&dev_attr_drv_version.attr,
+	&dev_attr_link_state.attr,
 	NULL,
 };
+
+static const struct attribute_group snic_attr_group = {
+	.attrs = snic_attrs
+};
+
+const struct attribute_group *snic_attr_groups[] = {
+	&snic_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 14f4ce665e58..d54b5e76e9cb 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -129,7 +129,7 @@ static struct scsi_host_template snic_host_template = {
 	.can_queue = SNIC_MAX_IO_REQ,
 	.sg_tablesize = SNIC_MAX_SG_DESC_CNT,
 	.max_sectors = 0x800,
-	.shost_attrs = snic_attrs,
+	.shost_groups = snic_attr_groups,
 	.track_queue_depth = 1,
 	.cmd_size = sizeof(struct snic_internal_io_state),
 	.proc_name = "snic_scsi",
