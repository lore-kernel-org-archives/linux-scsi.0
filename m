Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E358ECAAD4
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Aug 2022 21:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiH3VF0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Aug 2022 17:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiH3VFW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Aug 2022 17:05:22 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116DD32D88
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2022 14:05:19 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id c66so2281816pfc.10
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2022 14:05:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=LZ4G3nqwil0eqCGjqCXbU/qxUJVzYhO0Kw2RojMdGkM=;
        b=K6hVY8wpIBD/FzhdB1xxnFka1sX+9YoPJLm+4nZWdS6wT+NULkIhK/pt3/vB9oF9u3
         dKxcnw/rzCK6YmmN8bPBZG18/QoyOys+PWy3AuBC2QChTqtyNbDPGGEMwkLhS1KaEzJF
         F+o+a/gn6AFvR9juPQjOE/14VOD3fDinyRznN7Nh6b3s6dYUgpDzMc0GVFIYrIivb2hb
         xLBo0Um1kOQs8GQfhvAGSQdhwESiywclWYOYPcSHTfPYgmWcjSQihxziM/UKbpWiVrnj
         C514gSrFKLOWp4MWUudBNPQ9IFw2dwty3jWJrEJiAO3afUamyu56Sk7vZ6HkAUufuBT1
         GiPQ==
X-Gm-Message-State: ACgBeo3s9izKUaqEzecApC7cSIoW5yBD9Avj1moQrfd4US7isDzbyg7R
        RZvabY/r/EoJI57sfBeJp+g=
X-Google-Smtp-Source: AA6agR4G3FeOJCOFVvgQYm4MlPozWZNAyoJ4gXyGVzxCgbzmr+gQqiF6Er5AUX2wBB2VtggwAQLkUw==
X-Received: by 2002:a63:89c3:0:b0:42b:9f8c:e903 with SMTP id v186-20020a6389c3000000b0042b9f8ce903mr14489537pgd.619.1661893518636;
        Tue, 30 Aug 2022 14:05:18 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([12.219.165.6])
        by smtp.gmail.com with ESMTPSA id z5-20020a170903018500b00174da27b8e3sm4612841plg.8.2022.08.30.14.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 14:05:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 1/2] scsi: esas2r: Introduce scsi_template_proc_dir()
Date:   Tue, 30 Aug 2022 14:05:08 -0700
Message-Id: <20220830210509.1919493-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
In-Reply-To: <20220830210509.1919493-1-bvanassche@acm.org>
References: <20220830210509.1919493-1-bvanassche@acm.org>
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
