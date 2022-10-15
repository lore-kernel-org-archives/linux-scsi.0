Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D65C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Oct 2022 00:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJOAYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 20:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJOAYj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 20:24:39 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A181A3ABE
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:35 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id y191so6328605pfb.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQbuK20x0N7JV3KiyJ7uwhhcY3DUtyDNeAj6eT/NnHk=;
        b=QleTo68g/+eac99TGkamPddeKchePmo7XrOFdL+HXRUK5hPIeccZ5ucaysh6SjXrCQ
         9DKc8An8/dRyPaSG0ac18HuyNUH/40GyKRI7G9nQ6L0++wgp72/bohSUXhKIMlqxXbTH
         DoRUYez6wh2ncm87eVYJrAnkWDGhkGQOToxOuaetgSqSXcB+DeugkoxbQ5T6JkyQXE3C
         olRTmNqdZRsx3j9hV1GacuGFM3CfK0uPsbM0aSTdQ2zPDSc6/PpbEYxxhd0L8GTLBwyI
         /aBoDZkCkc9BheMhlui4roD2zdgonOp1rNMz5361VNB+b+XakzjYD68UKPBf1YDTM6ba
         lhRQ==
X-Gm-Message-State: ACrzQf0NK7cTbg/LX2+L6HPWzaslUVtNuLqQ2VB1aMloWMcL4cCnnd9F
        w3Vq0AWV+6nxsHcPbYN+wEU=
X-Google-Smtp-Source: AMsMyM5oKQHxs1OfJu1rdgPO2+vG/PCZczpo+zo4wtfNUqE7D6PdR2h5yqvwisIGyxJIHjaIwgvVSA==
X-Received: by 2002:a05:6a00:1707:b0:562:e790:dfc3 with SMTP id h7-20020a056a00170700b00562e790dfc3mr485338pfc.59.1665793474338;
        Fri, 14 Oct 2022 17:24:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y17-20020a634951000000b0046a1c832e9fsm1937953pgk.34.2022.10.14.17.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:24:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v7 3/8] scsi: core: Fail host creation if creating the proc directory fails
Date:   Fri, 14 Oct 2022 17:24:13 -0700
Message-Id: <20221015002418.30955-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221015002418.30955-1-bvanassche@acm.org>
References: <20221015002418.30955-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Users expect that the contents of /proc/scsi is in sync with the contents
of /sys/class/scsi_host. Hence fail host creation if creating the proc
directory fails.

Suggested-by: John Garry <john.garry@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
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
index c52de9a973e4..494f48e03e90 100644
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
