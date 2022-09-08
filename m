Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A3AC54EE9
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 23:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiIHXhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 19:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiIHXh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 19:37:27 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617FF959F
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 16:36:10 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id l65so16072pfl.8
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 16:36:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=IkETgIBtRzuJcpIfDKeauGWIABtpA9uXDod2IMciAA8=;
        b=S/UW2IAqteAeKkpAV79ttLJNlUAed1Bj1oUmk3cupbM0i0BxXAets1xupYKbRGKgse
         y+VAZ39nlcFVVPb8eGDzLSJeFw1SfCNZ+/+9twpYTZeib2gj0BqtaQCRiAdZFCCOCJE7
         /LgyG6s0xlNG2yaW8Wt4xRCKW+s3DqveQJk6geoFPDi1ni0bYzhe5MghY8ap5NUQ+Bii
         HK1XAZ3Hztxb/qKxru6IvZSrZxGdM4GFoPTD1w/KG5/CUUGDifPs4Ba9rJ5BbkaF3VWY
         oVjWJ48Nbqaq5i+SZ2Zz+R7bb2n4TduY800lgzUDO0uCzuEr/rMT34e2bVEtUGe6wUz/
         CDrg==
X-Gm-Message-State: ACgBeo2uUGPxq/ri0+yhwGyJ0kRh0D8apZP8V63QO1o2cEZZ69kq4s6/
        KMkrWD5oBL60Csx6RM/A1AI=
X-Google-Smtp-Source: AA6agR4YiUMZ7UmCnoO79/tY0nd9UWmE3VJQb6MTHz7rqPSiZZfmZef+givJP3AQJgGjGWMwod5UPg==
X-Received: by 2002:a63:8043:0:b0:434:fe8f:6cd0 with SMTP id j64-20020a638043000000b00434fe8f6cd0mr7860040pgd.115.1662680169609;
        Thu, 08 Sep 2022 16:36:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c18a:7410:112c:aa7c])
        by smtp.gmail.com with ESMTPSA id w16-20020a170902e89000b0016c574aa0fdsm84259plg.76.2022.09.08.16.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 16:36:08 -0700 (PDT)
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
Subject: [PATCH v3 1/3] scsi: esas2r: Introduce scsi_template_proc_dir()
Date:   Thu,  8 Sep 2022 16:35:58 -0700
Message-Id: <20220908233600.3043271-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220908233600.3043271-1-bvanassche@acm.org>
References: <20220908233600.3043271-1-bvanassche@acm.org>
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
 drivers/scsi/esas2r/esas2r_main.c | 18 +++++++++++-------
 drivers/scsi/scsi_proc.c          | 11 +++++++++++
 include/scsi/scsi_host.h          |  6 ++++++
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7a4eadad23d7..fbf7fdb3b52a 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -248,7 +248,6 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize			= SG_CHUNK_SIZE,
 	.cmd_per_lun			=
 		ESAS2R_DEFAULT_CMD_PER_LUN,
-	.present			= 0,
 	.emulated			= 0,
 	.proc_name			= ESAS2R_DRVR_NAME,
 	.change_queue_depth		= scsi_change_queue_depth,
@@ -637,10 +636,13 @@ static void __exit esas2r_exit(void)
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
@@ -730,11 +732,13 @@ const char *esas2r_info(struct Scsi_Host *sh)
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
index 95aee1ad1383..eeb9261c93f7 100644
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
+EXPORT_SYMBOL(scsi_template_proc_dir);
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
