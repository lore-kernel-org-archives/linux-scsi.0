Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E70EC25B0F
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 20:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbiHLUqV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 16:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiHLUqS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 16:46:18 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B880498D13
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 13:46:17 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d20so1898803pfq.5
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 13:46:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=O3QA7e8XNlpsd9EMETieDwfnvxKCRBc29LOhN8oYA50=;
        b=5MrS3KQ45Mf2po7MvfXbslJH6tCNRroMKR04hKIde6YDnHGVbq8SrB7uQ1f5COeuCX
         yBqUjv9hZ3NJP5mL0LbfqU9tQ4cr/QEjBcyXgGYD/Hq0WAguFsPI1FyFqe8/nmckOE+r
         Xr4aAspczsvmwlekH+Rph/ZClQWxBpgksPd+tJ0uI4pcTHDe2CgqrPpCNc+6qrcRe6RG
         1hZUmrQBbHCPwpq02rJ0vMhM2zm5S/TWdot1Bf8iBBbo5tWRZiW6UVBxuQ7BKaPrK7nb
         uuIijfQkigsEcbf5rK69vXGuHEjGdAMFuTX7h9kloUwOCukK7LGb3J0IfGICQx4X39Qe
         1Qmg==
X-Gm-Message-State: ACgBeo3qQ4EBcB1nUP7yHzhY8ActDykBtjryZ53X6emBoSwie+pEiJZR
        e/HgnVtZ+EnOfdbCNYkBySM=
X-Google-Smtp-Source: AA6agR4+qPVbN2muDfsdX64mSMwTHHVrw3W/3KqYE9XWX0MMtk3Gtapam2Aneqe4HoeO4JZUhNrsmw==
X-Received: by 2002:a63:17:0:b0:41d:7ab5:c9e6 with SMTP id 23-20020a630017000000b0041d7ab5c9e6mr4493587pga.493.1660337176998;
        Fri, 12 Aug 2022 13:46:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2414:9f13:41de:d21d])
        by smtp.gmail.com with ESMTPSA id o8-20020a17090a4e8800b001ef7c7564fdsm243189pjh.21.2022.08.12.13.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 13:46:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 2/4] scsi: esas2r: Remove procfs support
Date:   Fri, 12 Aug 2022 13:45:51 -0700
Message-Id: <20220812204553.2202539-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220812204553.2202539-1-bvanassche@acm.org>
References: <20220812204553.2202539-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removing procfs support from the SCSI core by removing
procfs support from the esas2r driver. I think it is safe to remove
/proc/scsi/esas2r/ATTOnode because I have not found any public source
code that uses this endpoint and also because the most recent change
from @attotech.com for the esas2r driver happened nine years ago
(October 2013).

Cc: Bradley Grove <linuxdrivers@attotech.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/esas2r/esas2r_main.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index ed6b66594ee6..e347b843a6a2 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -609,20 +609,12 @@ static int __init esas2r_init(void)
 	return pci_register_driver(&esas2r_pci_driver);
 }
 
-/* Handle ioctl calls to "/proc/scsi/esas2r/ATTOnode" */
+/* Handle ioctl calls to "/dev/esas2r" */
 static const struct file_operations esas2r_fops = {
 	.compat_ioctl	= compat_ptr_ioctl,
 	.unlocked_ioctl = esas2r_host_ioctl,
 };
 
-static const struct proc_ops esas2r_proc_ops = {
-	.proc_lseek		= default_llseek,
-	.proc_ioctl		= esas2r_host_ioctl,
-#ifdef CONFIG_COMPAT
-	.proc_compat_ioctl	= compat_ptr_ioctl,
-#endif
-};
-
 static struct Scsi_Host *esas2r_scsi_host;
 static int esas2r_proc_major;
 
@@ -639,8 +631,6 @@ static void __exit esas2r_exit(void)
 	if (esas2r_proc_major > 0) {
 		esas2r_log(ESAS2R_LOG_INFO, "unregister proc");
 
-		remove_proc_entry(ATTONODE_NAME,
-				  esas2r_scsi_host->hostt->proc_dir);
 		unregister_chrdev(esas2r_proc_major, ESAS2R_DRVR_NAME);
 
 		esas2r_proc_major = 0;
@@ -728,21 +718,6 @@ const char *esas2r_info(struct Scsi_Host *sh)
 		esas2r_log_dev(ESAS2R_LOG_DEBG, &(sh->shost_gendev),
 			       "register_chrdev (major %d)",
 			       esas2r_proc_major);
-
-		if (esas2r_proc_major > 0) {
-			struct proc_dir_entry *pde;
-
-			pde = proc_create(ATTONODE_NAME, 0,
-					  sh->hostt->proc_dir,
-					  &esas2r_proc_ops);
-
-			if (!pde) {
-				esas2r_log_dev(ESAS2R_LOG_WARN,
-					       &(sh->shost_gendev),
-					       "failed to create_proc_entry");
-				esas2r_proc_major = -1;
-			}
-		}
 	}
 
 	sprintf(esas2r_info_str,
