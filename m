Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E97ECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 22:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiINW47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiINW4x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 18:56:53 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B3683059
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 15:56:52 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id 9so5195935pfz.12
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 15:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LyWeacTwFK6UBYW2Wo6wy8WwfqX6JKz5f/CDUDhhqE4=;
        b=mpYFy5muO+5AuZ2X1sF6UxBVkn5bVGWN/qsCQOOyJ0AnlWErWHD2iYhSs9ckBk2wHI
         Lsl31/pr2daNaNQFhx4pQCIA/w4TmsQ06sxMRh7KBXPWaCJ6DMhrOGZESRYojxRX54Gy
         RJLwCKOSyntWiv//5x+OoD3My9hwR1TiHg0jwRvN2pbkSV37pT5tAuPrYhaHwOOclIGx
         7XbNPqrdgGTptzCjmvELfY4m56MsaTE6ocLYrNc4OKjsOPrnFvEAadPwHRxhJHBByXc6
         oiIfo4FOxlNj3i/9kKue5L554f0/u0XDTunbX2t2TLkkiQqh25cJn/cjK/DqkwjpVCLu
         8uxA==
X-Gm-Message-State: ACgBeo124j446148DHTRsrw+kIHmJCbyb8zWBtars6cekpjKvKjU67BI
        OBIaRIR6c41UpxYCL+EAtJc=
X-Google-Smtp-Source: AA6agR7yb0LrbxJW82PixX7+gXexyitSoC4vsRIJjnJpG/DvdFseCpUdSo/jflRPM77dYo+DaUNiKA==
X-Received: by 2002:a05:6a00:a90:b0:530:2f3c:da43 with SMTP id b16-20020a056a000a9000b005302f3cda43mr39626071pfl.50.1663196212348;
        Wed, 14 Sep 2022 15:56:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9147:e0c1:9227:cf53])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902d70900b0016d1b70872asm2606926ply.134.2022.09.14.15.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 15:56:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 3/7] scsi: core: Fail host creation if creating the proc directory fails
Date:   Wed, 14 Sep 2022 15:56:17 -0700
Message-Id: <20220914225621.415631-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220914225621.415631-1-bvanassche@acm.org>
References: <20220914225621.415631-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Users expect that the contents of /proc/scsi is in sync with the contents
of /sys/class/scsi_host. Hence fail host creation if creating the proc
directory fails.

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
index 9857dba09c95..12346e2297fd 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -519,7 +519,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
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
index f385b3f04d6e..8c2e32121db1 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -100,14 +100,14 @@ extern void scsi_evt_thread(struct work_struct *work);
 
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
