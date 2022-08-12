Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3D7C00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 20:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiHLUqV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 16:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiHLUqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 16:46:16 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A043E98D1D
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 13:46:15 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so1931444pjl.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 13:46:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=l49BhrLm6Gdir5kHGW90zXegAtyiZuy+B1HvmvD99aI=;
        b=4JY4tRjpbLbTk3QqetIBrDZD93leAuL4nSvpgO519CkxGzB/Fw0IS5rwsjETthmrs6
         NzO6pT2+eH7cZyJXSJs07mKznNAbw2tXWQ8aS/qQfeIaDrD2em+kOsslgyWckp87in/r
         HDu4yRSv73euA095XS91rE1Rf+OJbvcKRHsmpVA4ok/Miy0/FrnSrJFR+Gg1jStxiL0l
         7EN99IhIb3+udFytn3yyZMenTm802+dyfJuR9ojtI35GqwEoh/4AnChM5ZJDtp+mOaNZ
         OrmrHOz0vH+PYiPR5V/0xbRp+ab7ozW+b4CUX3I5S6Jsi9stKh2000kNt0vxu1unfccU
         sw0g==
X-Gm-Message-State: ACgBeo3Evecdk2oRKBakEiKSSZexq176aNYgC05FTBsWR3HoGSmJ0or0
        7WhBUzTLszlq9gdy8L/KJsNGXvJLACQ=
X-Google-Smtp-Source: AA6agR5naipvMv56fRZF8Sjqr8vsXh/lGRHmNUZY/35NjJmlp1lQvZUC3MCiJKoeZRn4QVQV/PwnkA==
X-Received: by 2002:a17:90b:390c:b0:1f5:8859:ac76 with SMTP id ob12-20020a17090b390c00b001f58859ac76mr5799384pjb.137.1660337174780;
        Fri, 12 Aug 2022 13:46:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2414:9f13:41de:d21d])
        by smtp.gmail.com with ESMTPSA id o8-20020a17090a4e8800b001ef7c7564fdsm243189pjh.21.2022.08.12.13.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 13:46:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 1/4] scsi: esas2r: Rename two functions and two variables
Date:   Fri, 12 Aug 2022 13:45:50 -0700
Message-Id: <20220812204553.2202539-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220812204553.2202539-1-bvanassche@acm.org>
References: <20220812204553.2202539-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Perform the following renames to make the names better reflect the purpose
of these functions and variables:
* esas2r_ioctl() -> esas2r_sdev_ioctl().
* esas2r_proc_ioctl() -> esas2r_host_ioctl().
* esas2r_proc_fops -> esas2r_fops.
* esas2r_proc_host -> esas2r_scsi_host.

This patch does not change any functionality.

Cc: Bradley Grove <linuxdrivers@attotech.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/esas2r/esas2r.h       |  4 ++--
 drivers/scsi/esas2r/esas2r_ioctl.c |  2 +-
 drivers/scsi/esas2r/esas2r_main.c  | 20 ++++++++++----------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index ed63f7a9ea54..890e8cd60069 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -966,12 +966,12 @@ const char *esas2r_info(struct Scsi_Host *);
 int esas2r_write_params(struct esas2r_adapter *a, struct esas2r_request *rq,
 			struct esas2r_sas_nvram *data);
 int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg);
-int esas2r_ioctl(struct scsi_device *dev, unsigned int cmd, void __user *arg);
+int esas2r_sdev_ioctl(struct scsi_device *dev, unsigned int cmd, void __user *arg);
 u8 handle_hba_ioctl(struct esas2r_adapter *a,
 		    struct atto_ioctl *ioctl_hba);
 int esas2r_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd);
 int esas2r_show_info(struct seq_file *m, struct Scsi_Host *sh);
-long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
+long esas2r_host_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 
 /* SCSI error handler (eh) functions */
 int esas2r_eh_abort(struct scsi_cmnd *cmd);
diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 08f4e43c7d9e..5a76fc1ae038 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1525,7 +1525,7 @@ int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg)
 	return 0;
 }
 
-int esas2r_ioctl(struct scsi_device *sd, unsigned int cmd, void __user *arg)
+int esas2r_sdev_ioctl(struct scsi_device *sd, unsigned int cmd, void __user *arg)
 {
 	return esas2r_ioctl_handler(sd->host->hostdata, cmd, arg);
 }
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7a4eadad23d7..ed6b66594ee6 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -236,7 +236,7 @@ static struct scsi_host_template driver_template = {
 	.show_info			= esas2r_show_info,
 	.name				= ESAS2R_LONGNAME,
 	.info				= esas2r_info,
-	.ioctl				= esas2r_ioctl,
+	.ioctl				= esas2r_sdev_ioctl,
 	.queuecommand			= esas2r_queuecommand,
 	.eh_abort_handler		= esas2r_eh_abort,
 	.eh_device_reset_handler	= esas2r_device_reset,
@@ -610,25 +610,25 @@ static int __init esas2r_init(void)
 }
 
 /* Handle ioctl calls to "/proc/scsi/esas2r/ATTOnode" */
-static const struct file_operations esas2r_proc_fops = {
+static const struct file_operations esas2r_fops = {
 	.compat_ioctl	= compat_ptr_ioctl,
-	.unlocked_ioctl = esas2r_proc_ioctl,
+	.unlocked_ioctl = esas2r_host_ioctl,
 };
 
 static const struct proc_ops esas2r_proc_ops = {
 	.proc_lseek		= default_llseek,
-	.proc_ioctl		= esas2r_proc_ioctl,
+	.proc_ioctl		= esas2r_host_ioctl,
 #ifdef CONFIG_COMPAT
 	.proc_compat_ioctl	= compat_ptr_ioctl,
 #endif
 };
 
-static struct Scsi_Host *esas2r_proc_host;
+static struct Scsi_Host *esas2r_scsi_host;
 static int esas2r_proc_major;
 
-long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
+long esas2r_host_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
-	return esas2r_ioctl_handler(esas2r_proc_host->hostdata,
+	return esas2r_ioctl_handler(esas2r_scsi_host->hostdata,
 				    cmd, (void __user *)arg);
 }
 
@@ -640,7 +640,7 @@ static void __exit esas2r_exit(void)
 		esas2r_log(ESAS2R_LOG_INFO, "unregister proc");
 
 		remove_proc_entry(ATTONODE_NAME,
-				  esas2r_proc_host->hostt->proc_dir);
+				  esas2r_scsi_host->hostt->proc_dir);
 		unregister_chrdev(esas2r_proc_major, ESAS2R_DRVR_NAME);
 
 		esas2r_proc_major = 0;
@@ -720,10 +720,10 @@ const char *esas2r_info(struct Scsi_Host *sh)
 	 */
 
 	if (esas2r_proc_major <= 0) {
-		esas2r_proc_host = sh;
+		esas2r_scsi_host = sh;
 
 		esas2r_proc_major = register_chrdev(0, ESAS2R_DRVR_NAME,
-						    &esas2r_proc_fops);
+						    &esas2r_fops);
 
 		esas2r_log_dev(ESAS2R_LOG_DEBG, &(sh->shost_gendev),
 			       "register_chrdev (major %d)",
