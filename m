Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6603AC6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Sep 2022 19:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiIMT52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Sep 2022 15:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIMT50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2022 15:57:26 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26C772EF6
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 12:57:25 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id q9-20020a17090a178900b0020265d92ae3so16654246pja.5
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 12:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=r4b7G+FR0CDZJL2WSp766pAJi2QZl8cA4HixhP8Yg4Y=;
        b=JmSdbcpQ170i4Lbnis+Xdd8Q3Ktpnp+vmrOFPKdrVn9yZSBBdfH4elkQ8Ozq2hcWoj
         jS03v+GlKBGLqgVHkR8zYWlzRCT76rtW5BME3H0Ar11h7XjWjt1Z0xaCwicLwJn98vqh
         EuPiVuWYgo0Dw07qVFSd3l8A7bZ1hPQiuQ5TAXnhGh0hy2foQg+YicUnlD83DSb4Enar
         sjA2SLJtin5oR1Zu2SsR+/8e22YRNgDaH8q0uhfhNLQzhSGqtMXp/j54Vn99GA1pPZNq
         xzVpOkoB0D8yLgyIE4paUBBgG81a/Qe58J5ZDNR7IldJMroenEIu2I1eA0V1GrO3zym3
         ILYQ==
X-Gm-Message-State: ACgBeo0w5U3dvQ8MHaed/0lxl3/WQqn6jAu5nn01TLAkPcAdrcGKfnfJ
        rNVq2z6JKEx8QH/SiWqNLhk=
X-Google-Smtp-Source: AA6agR5xtK+D0C0J7OIVpe0H2wBGFVhtS00FPqN5mIp3jD45nv4Oopzjcc/XJqfsQrWhTS36Lbke1A==
X-Received: by 2002:a17:902:c1cd:b0:177:e483:51b0 with SMTP id c13-20020a170902c1cd00b00177e48351b0mr31373581plc.41.1663099045258;
        Tue, 13 Sep 2022 12:57:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:515b:d33a:21be:45a])
        by smtp.gmail.com with ESMTPSA id p15-20020a1709027ecf00b0017825ab5320sm6739987plb.251.2022.09.13.12.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 12:57:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 2/4] scsi: esas2r: Introduce scsi_template_proc_dir()
Date:   Tue, 13 Sep 2022 12:57:14 -0700
Message-Id: <20220913195716.3966875-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220913195716.3966875-1-bvanassche@acm.org>
References: <20220913195716.3966875-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removing the 'proc_dir' and 'present' members from the SCSI
host template. This patch does not change any functionality.

Cc: Bradley Grove <linuxdrivers@attotech.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
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
index 9b0a028bf053..030faca947d2 100644
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
