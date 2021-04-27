Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB05C4360C
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D45613FF
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239321AbhD0WAm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:42 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39145 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239503AbhD0WAW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 085492042AA;
        Tue, 27 Apr 2021 23:59:38 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4Nxt+0EKwj8t; Tue, 27 Apr 2021 23:59:36 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 6B445204278;
        Tue, 27 Apr 2021 23:59:32 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 76/83] sg: add no_attach_msg parameter
Date:   Tue, 27 Apr 2021 17:57:26 -0400
Message-Id: <20210427215733.417746-78-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When testing and with big storage arrays having a log messaage
for each sg device attached becomes a little annoying. Still keep
that as the default but when no_attach_msg=1 is given at driver
or module load time, then any sg device nodes attached will not
be reported to the log.

Re-order the other three driver/module load time parameters so
they appear in alphabetical order when viewed with modinfo.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index a159af1e3ee6..a76ab2c59553 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -184,6 +184,7 @@ static int def_reserved_size = -1;	/* picks up init parameter */
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;	/* ignored by code */
 
 static int scatter_elem_sz = SG_SCATTER_SZ;
+static bool no_attach_msg;
 
 #define SG_DEF_SECTOR_SZ 512
 
@@ -5929,8 +5930,9 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 
 	sdp->create_ns = ktime_get_boottime_ns();
 	sg_calc_sgat_param(sdp);
-	sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d type %d\n", sdp->index,
-		    scsidp->type);
+	if (!no_attach_msg)
+		sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d type %d\n",
+			    sdp->index, scsidp->type);
 
 	dev_set_drvdata(cl_dev, sdp);
 	return 0;
@@ -8190,9 +8192,10 @@ static void sg_dfs_exit(void) {}
 
 #endif		/* CONFIG_DEBUG_FS */
 
-module_param_named(scatter_elem_sz, scatter_elem_sz, int, 0644);
-module_param_named(def_reserved_size, def_reserved_size, int, 0644);
 module_param_named(allow_dio, sg_allow_dio, int, 0644);
+module_param_named(def_reserved_size, def_reserved_size, int, 0644);
+module_param_named(no_attach_msg, no_attach_msg, bool, 0644);
+module_param_named(scatter_elem_sz, scatter_elem_sz, int, 0644);
 
 MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
@@ -8200,8 +8203,9 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(SG_VERSION_STR);
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_GENERIC_MAJOR);
 
-MODULE_PARM_DESC(scatter_elem_sz, "scatter gather element size (default: max(SG_SCATTER_SZ, PAGE_SIZE))");
-MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow)); now ignored");
+MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
+MODULE_PARM_DESC(no_attach_msg, "don't log sg device attach message when 1 (def:0)");
+MODULE_PARM_DESC(scatter_elem_sz, "scatter gather element size (only powers of 2 >= PAGE_SIZE)");
 module_init(init_sg);
 module_exit(exit_sg);
-- 
2.25.1

