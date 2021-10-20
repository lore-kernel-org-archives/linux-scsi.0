Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD6CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 782406137C
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhJTVn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:43:27 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:37725 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhJTVnY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:43:24 -0400
Received: by mail-pg1-f181.google.com with SMTP id s136so20467179pgs.4
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:41:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0KK/t0SDH1tpcT2qf8SLAI98Ct3/Vl2GyI4zZkw/Rrs=;
        b=LVZbuhP7XYgFx96sqXRndXAqmbPAaR56bm0FE2NmCffsSTOubAp2zyaPXE2VG6TdRG
         oJLGYWjRlOF7J3+ptK8piHSpzsl4+h3/CsMXC5MsY+RXMXdWcMS6cV1K5aKkL4QJ4QL9
         dzE+OsgExSmVEjpMeKsQQ085NAlz+78PC4jjoU+9pCwcfusf8fhjXXiMYZFazqBPsqF0
         mGWCfzqAjdKeSeS6VTGaAteY1iDebSaVqhbYKDKpx4ziyTad6KuG2aD7wT7PXGM+l68r
         33z5vDQXBi4Yn4zxDciKXD7eZaQkyAfFS9NMDMvnIwHzcECZf+J4LbijrAVT//aLzqYR
         gNhg==
X-Gm-Message-State: AOAM530KTMqSrXZdncUJhnbWMh4bhJ4snzahAQuIiTBxYuOiMg3IvbwV
        eUW9RvIZxQUviVdHthxcm9Q=
X-Google-Smtp-Source: ABdhPJzuLS05QDizE9YVA3Kop1i/pF5hHBC26srvv6ms0pIw+JNvaQGzJUvLqxhy4vFy94hLGGhNHQ==
X-Received: by 2002:a62:7656:0:b0:44c:591b:5a42 with SMTP id r83-20020a627656000000b0044c591b5a42mr1379671pfc.57.1634766069317;
        Wed, 20 Oct 2021 14:41:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:41:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 06/10] scsi: ufs: Make it easier to add new debugfs attributes
Date:   Wed, 20 Oct 2021 14:40:20 -0700
Message-Id: <20211020214024.2007615-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
References: <20211020214024.2007615-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce an array for debugfs attributes to make it easier to add new
debugfs attributes. Change the value of the inode.i_private pointer for
debugfs attributes from a pointer to the HBA data structure to a pointer
to the attribute description for the stats attribute. Store the HBA
pointer in the private data of the parent inode instead.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-debugfs.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-debugfs.c
index 4e1ff209b933..1d4e5aa4b762 100644
--- a/drivers/scsi/ufs/ufs-debugfs.c
+++ b/drivers/scsi/ufs/ufs-debugfs.c
@@ -8,6 +8,18 @@
 
 static struct dentry *ufs_debugfs_root;
 
+struct ufs_debugfs_attr {
+	const char			*name;
+	mode_t				mode;
+	const struct file_operations	*fops;
+};
+
+/* @file corresponds to a debugfs attribute in directory hba->debugfs_root. */
+static inline struct ufs_hba *hba_from_file(const struct file *file)
+{
+	return d_inode(file->f_path.dentry->d_parent)->i_private;
+}
+
 void __init ufs_debugfs_init(void)
 {
 	ufs_debugfs_root = debugfs_create_dir("ufshcd", NULL);
@@ -20,7 +32,7 @@ void ufs_debugfs_exit(void)
 
 static int ufs_debugfs_stats_show(struct seq_file *s, void *data)
 {
-	struct ufs_hba *hba = s->private;
+	struct ufs_hba *hba = hba_from_file(s->file);
 	struct ufs_event_hist *e = hba->ufs_stats.event;
 
 #define PRT(fmt, typ) \
@@ -126,13 +138,28 @@ static void ufs_debugfs_restart_ee(struct work_struct *work)
 	ufs_debugfs_put_user_access(hba);
 }
 
+static const struct ufs_debugfs_attr ufs_attrs[] = {
+	{ "stats", 0400, &ufs_debugfs_stats_fops },
+	{ }
+};
+
 void ufs_debugfs_hba_init(struct ufs_hba *hba)
 {
+	const struct ufs_debugfs_attr *attr;
+	struct dentry *root;
+
 	/* Set default exception event rate limit period to 20ms */
 	hba->debugfs_ee_rate_limit_ms = 20;
 	INIT_DELAYED_WORK(&hba->debugfs_ee_work, ufs_debugfs_restart_ee);
-	hba->debugfs_root = debugfs_create_dir(dev_name(hba->dev), ufs_debugfs_root);
-	debugfs_create_file("stats", 0400, hba->debugfs_root, hba, &ufs_debugfs_stats_fops);
+
+	root = debugfs_create_dir(dev_name(hba->dev), ufs_debugfs_root);
+	if (IS_ERR_OR_NULL(root))
+		return;
+	hba->debugfs_root = root;
+	d_inode(root)->i_private = hba;
+	for (attr = ufs_attrs; attr->name; attr++)
+		debugfs_create_file(attr->name, attr->mode, root, (void *)attr,
+				    attr->fops);
 	debugfs_create_file("exception_event_mask", 0600, hba->debugfs_root,
 			    hba, &ee_usr_mask_fops);
 	debugfs_create_u32("exception_event_rate_limit_ms", 0600, hba->debugfs_root,
