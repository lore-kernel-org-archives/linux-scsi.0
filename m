Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E27C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Oct 2022 00:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJOAYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 20:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiJOAYd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 20:24:33 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36481A3AB0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:33 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id n7so6169378plp.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vE65TSc6wxjQbrwNjWse98ak3WMgmY7yzNFoKZNQrfo=;
        b=LlVJEGgKNFuyNqzag4zUitvz0HMOKvuIYllbYD1UoFKBbsz5Z1c58EdAGSNZVMwvqO
         6RGLiK1Z+wX8Gj0T2ZX/E7NlJTjER62XAhr+BsRyW9BI9/D61GMIkrjmTwTUkyLQpApl
         KPjrIOWzCZWJPFVCb8Yd5iYZvsbF/kiJE5nYd/RdcVVSNn7ybdnuBsGp4kCIf8o7LuB0
         WNKv1glBJh2uEPYYxJpPhsaunSlIbWyYPMnk1prJUOrhJFxS5yFNe/fnM6FWNp7m+GO4
         SINFUko3cEc6DCUHwLBZg0KbIa5dKK7qxnFcszdkpWOVyQFlOl+HwSyx22QmMSsWANA/
         z57Q==
X-Gm-Message-State: ACrzQf0qUB6npq+R/8eCSz1fF1cC92mZxiI6lW5OAXBtkhsBUXV27cZh
        dwLZj8CFwrfEaahXTIhKjOc=
X-Google-Smtp-Source: AMsMyM4zBIom4spmNwSbsPYYxwU17zwD93D2/Bo7bPFenGQWRCmv748p35Q3P3WutMNkn6M3CowWkw==
X-Received: by 2002:a17:902:e84a:b0:183:ee5e:fad0 with SMTP id t10-20020a170902e84a00b00183ee5efad0mr267749plg.66.1665793472639;
        Fri, 14 Oct 2022 17:24:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y17-20020a634951000000b0046a1c832e9fsm1937953pgk.34.2022.10.14.17.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:24:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v7 2/8] scsi: esas2r: Introduce scsi_template_proc_dir()
Date:   Fri, 14 Oct 2022 17:24:12 -0700
Message-Id: <20221015002418.30955-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221015002418.30955-1-bvanassche@acm.org>
References: <20221015002418.30955-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removing the 'proc_dir' and 'present' members from the SCSI
host template. This patch does not change any functionality.

Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Bradley Grove <linuxdrivers@attotech.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/esas2r/esas2r_main.c | 17 +++++++++++------
 drivers/scsi/scsi_proc.c          | 11 +++++++++++
 include/scsi/scsi_host.h          |  6 ++++++
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 27f6e7ccded8..d7a2c49ff5ee 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -635,10 +635,13 @@ static void __exit esas2r_exit(void)
 	esas2r_log(ESAS2R_LOG_INFO, "%s called", __func__);
 
 	if (esas2r_proc_major > 0) {
+		struct proc_dir_entry *proc_dir;
+
 		esas2r_log(ESAS2R_LOG_INFO, "unregister proc");
 
-		remove_proc_entry(ATTONODE_NAME,
-				  esas2r_proc_host->hostt->proc_dir);
+		proc_dir = scsi_template_proc_dir(esas2r_proc_host->hostt);
+		if (proc_dir)
+			remove_proc_entry(ATTONODE_NAME, proc_dir);
 		unregister_chrdev(esas2r_proc_major, ESAS2R_DRVR_NAME);
 
 		esas2r_proc_major = 0;
@@ -728,11 +731,13 @@ const char *esas2r_info(struct Scsi_Host *sh)
 			       esas2r_proc_major);
 
 		if (esas2r_proc_major > 0) {
-			struct proc_dir_entry *pde;
+			struct proc_dir_entry *proc_dir;
+			struct proc_dir_entry *pde = NULL;
 
-			pde = proc_create(ATTONODE_NAME, 0,
-					  sh->hostt->proc_dir,
-					  &esas2r_proc_ops);
+			proc_dir = scsi_template_proc_dir(sh->hostt);
+			if (proc_dir)
+				pde = proc_create(ATTONODE_NAME, 0, proc_dir,
+						  &esas2r_proc_ops);
 
 			if (!pde) {
 				esas2r_log_dev(ESAS2R_LOG_WARN,
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 95aee1ad1383..456b43097288 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -83,6 +83,17 @@ static int proc_scsi_host_open(struct inode *inode, struct file *file)
 				4 * PAGE_SIZE);
 }
 
+/**
+ * scsi_template_proc_dir() - returns the procfs dir for a SCSI host template
+ * @sht: SCSI host template pointer.
+ */
+struct proc_dir_entry *
+scsi_template_proc_dir(const struct scsi_host_template *sht)
+{
+	return sht->proc_dir;
+}
+EXPORT_SYMBOL_GPL(scsi_template_proc_dir);
+
 static const struct proc_ops proc_scsi_ops = {
 	.proc_open	= proc_scsi_host_open,
 	.proc_release	= single_release,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index fcf25f1642a3..3854ffcb0b3e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -751,6 +751,12 @@ extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int __must_check scsi_add_host_with_dma(struct Scsi_Host *,
 					       struct device *,
 					       struct device *);
+#if defined(CONFIG_SCSI_PROC_FS)
+struct proc_dir_entry *
+scsi_template_proc_dir(const struct scsi_host_template *sht);
+#else
+#define scsi_template_proc_dir(sht) NULL
+#endif
 extern void scsi_scan_host(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
 extern void scsi_remove_host(struct Scsi_Host *);
