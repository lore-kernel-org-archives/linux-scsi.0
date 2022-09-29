Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BA3C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiI2WqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiI2Wpg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:45:36 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CA32AC2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:40 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id u12so2657284pjj.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Dga2FoWMsPDIzm7bQA4fn6a11AQGBoCeCg/M4Arbqr4=;
        b=fiGv+iUpNCQTtHjxC0jmVsUTb1XCS0+jl7FtTPtkvK9Heahrh7bkr6cy9CvGYbVdPd
         CH7zD/N4EhPl7cY0zTJqKhBwswFfuho503Cz5jyfslzaFiryv5zT1xZzzpyvyz+NIvXc
         5MRsB2y/HMVUUuJtqSV/sibBO5HhtrHaDj3lPNuCIsfJ0T9eA+hzxZInF1WEmiWYdzwY
         ZM8ZI5n3fA3udwFelQPLdVHu57/eoc0vEyill8E2rf3GrdyokQt93wE/B4TmgVz7o96h
         m+XSdrIMq/KlG8zy+cB/4ehVTVabDyRRhvnIN2MZqSWFFTvIoH/uyxivWnlnHKiTbWm6
         +Pvg==
X-Gm-Message-State: ACrzQf1KOwY1v5oRhv5iPt/W46okmb0Ix8hmhcFcPtIaHuL4J+n4x9C0
        MBjaBFK1w54WfCccNSB2wSo=
X-Google-Smtp-Source: AMsMyM4aKh25aHSnVa7Kms7m5PMVYwzcUQNb4c+YST6HxXHRcMP+AaIKYsuB+nSqHBi4iddYIF+cKg==
X-Received: by 2002:a17:90b:4f8d:b0:202:dd39:c03a with SMTP id qe13-20020a17090b4f8d00b00202dd39c03amr19154704pjb.71.1664491479490;
        Thu, 29 Sep 2022 15:44:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b0016d1b70872asm404508plk.134.2022.09.29.15.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:44:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v6 3/8] scsi: core: Fail host creation if creating the proc directory fails
Date:   Thu, 29 Sep 2022 15:44:16 -0700
Message-Id: <20220929224421.587465-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929224421.587465-1-bvanassche@acm.org>
References: <20220929224421.587465-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Users expect that the contents of /proc/scsi is in sync with the contents
of /sys/class/scsi_host. Hence fail host creation if creating the proc
directory fails.

Suggested-by: John Garry <john.garry@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     |  3 ++-
 drivers/scsi/scsi_priv.h |  4 ++--
 drivers/scsi/scsi_proc.c | 13 +++++++++----
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 0738238ed6cc..098d1970c451 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -517,7 +517,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 			     "failed to create tmf workq\n");
 		goto fail;
 	}
-	scsi_proc_hostdir_add(shost->hostt);
+	if (scsi_proc_hostdir_add(shost->hostt) < 0)
+		goto fail;
 	return shost;
  fail:
 	/*
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 2b9e0559ddcb..a7da51bc22da 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -111,14 +111,14 @@ extern void scsi_evt_thread(struct work_struct *work);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
-extern void scsi_proc_hostdir_add(struct scsi_host_template *);
+extern int scsi_proc_hostdir_add(struct scsi_host_template *);
 extern void scsi_proc_hostdir_rm(struct scsi_host_template *);
 extern void scsi_proc_host_add(struct Scsi_Host *);
 extern void scsi_proc_host_rm(struct Scsi_Host *);
 extern int scsi_init_procfs(void);
 extern void scsi_exit_procfs(void);
 #else
-# define scsi_proc_hostdir_add(sht)	do { } while (0)
+# define scsi_proc_hostdir_add(sht)	0
 # define scsi_proc_hostdir_rm(sht)	do { } while (0)
 # define scsi_proc_host_add(shost)	do { } while (0)
 # define scsi_proc_host_rm(shost)	do { } while (0)
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 456b43097288..8c84f1a74773 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -108,20 +108,25 @@ static const struct proc_ops proc_scsi_ops = {
  *
  * Sets sht->proc_dir to the new directory.
  */
-
-void scsi_proc_hostdir_add(struct scsi_host_template *sht)
+int scsi_proc_hostdir_add(struct scsi_host_template *sht)
 {
+	int ret = 0;
+
 	if (!sht->show_info)
-		return;
+		return 0;
 
 	mutex_lock(&global_host_template_mutex);
 	if (!sht->present++) {
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
-        	if (!sht->proc_dir)
+        	if (!sht->proc_dir) {
 			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
 			       __func__, sht->proc_name);
+			ret = -ENOMEM;
+		}
 	}
 	mutex_unlock(&global_host_template_mutex);
+
+	return ret;
 }
 
 /**
