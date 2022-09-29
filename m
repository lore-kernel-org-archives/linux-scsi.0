Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A361C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiI2WqL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiI2Wpg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:45:36 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83DBD8C
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:38 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id b75so2682650pfb.7
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=GuaxyPekQwOEv+1YHUUtxyW6Rq419NNxCuDWec4VbOA=;
        b=054aFehUbXjphBX/3mP6DNCU0HWSJsx2j20q5jPMweEyKGzWagOb7B3SEkueqmu/CC
         mS4D6kXus5rJWBjHjx2H1WfFjMULg59zANmOrC0ydrh1D+GyaS0FysBihyMCEiMO1Vze
         uURjngzv9gOlZpsYIR9M6wqtbiYaN4uXWux2SELs/f0TLjo0SwQR186/Jetu6MmjqYly
         pSIFDoDdkSqCrwYwmVOD/S7CXVRnh4lW+x1YUYM+vZgKlnpy+0dOS4O8DHBd8Wz5rpnx
         Ypmt1PoewQxYyuwYIe6z6IVRoKhSQisQVJ/gRa1/BwU5nIIfNbehT9rXl//y+mjlq5SG
         xRhQ==
X-Gm-Message-State: ACrzQf2+R52zQ3ssAz8FAwDKZZAGc+dXEG/MT46vZxfzKU95e16k8yuH
        qt/gqIquLzEXtQLdjfBrvu0=
X-Google-Smtp-Source: AMsMyM4eYmdWUI/9D7JnW5z2QfC6bU22sdOUMBIGV8ixa4nqX5gkd8faks1o8oaNqFZxM4PjyWv9tA==
X-Received: by 2002:a65:6e0f:0:b0:43a:1cd4:4ae6 with SMTP id bd15-20020a656e0f000000b0043a1cd44ae6mr4772174pgb.289.1664491477685;
        Thu, 29 Sep 2022 15:44:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b0016d1b70872asm404508plk.134.2022.09.29.15.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:44:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v6 2/8] scsi: esas2r: Introduce scsi_template_proc_dir()
Date:   Thu, 29 Sep 2022 15:44:15 -0700
Message-Id: <20220929224421.587465-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929224421.587465-1-bvanassche@acm.org>
References: <20220929224421.587465-1-bvanassche@acm.org>
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
index aa7b7496c93a..c2b8427e0305 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -752,6 +752,12 @@ extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
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
