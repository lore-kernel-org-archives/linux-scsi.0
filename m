Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5659BC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 01:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2386160FF0
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 01:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhDBBKD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 21:10:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231168AbhDBBKC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 21:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617325802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=yQLg+uZ2aewy/DP1qVbP7uqjrJ21gzhVskvb/9vTWOw=;
        b=Gui0oCRRzDnW+FtFw29trRiCKg/vpqG7wL6YiBsL4eGtWxf8uCkFRO+j1wNEjS7Yv5oGuX
        O7U67/EJZxgjQ4VwdQI5d0zEN6ggoqYvqMrqENoRvblZ2HlUAkOFBkd9s/Gl42um3iT8f0
        Xgpp9DZDZFuCuKtPzUgPFED9Ag4Jx24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-zDlbyIhpONyhzEvkVZn71g-1; Thu, 01 Apr 2021 21:09:59 -0400
X-MC-Unique: zDlbyIhpONyhzEvkVZn71g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11EF51005D4F;
        Fri,  2 Apr 2021 01:09:58 +0000 (UTC)
Received: from loberhel7laptop.redhat.com (ovpn-112-242.phx2.redhat.com [10.3.112.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA5BF19C46;
        Fri,  2 Apr 2021 01:09:56 +0000 (UTC)
From:   Laurence Oberman <loberman@redhat.com>
To:     linux-scsi@vger.kernel.org, hare@suse.de, emilne@redhat.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        loberman@redhat.com, jpittman@redhat.com, djeffery@redhat.com,
        dgilbert <dgilbert@interlog.com>, axboe@fb.com, hch@lst.de
Subject: [PATCH] scsi_mod: Add a new parameter to scsi_mod to control storage logging
Date:   Thu,  1 Apr 2021 21:09:43 -0400
Message-Id: <1617325783-20740-1-git-send-email-loberman@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

    This new parameter storage_quiet_discovery defaults to 0 and behavior is
    unchanged. If its set to 1 on the kernel line then sd_printk and
    sdev_printk are disabled for printing. The default logging can
    be re-enabled any time after boot using /etc/sysctl.conf by
    setting dev.scsi.storage_quiet_discovery = 0.
    systctl -w dev.scsi.storage_quiet_discovery=0 will also change it
    immediately back to logging.
    Users can leave it set to 1 on the kernel line and 0 in the conf
    file so it changes back to default after rc.sysinit.
    This solves the tough problem of systems with 1000's of storage LUNS
    consuming a system and preventing it from booting due to NMI's and
    timeouts.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 Documentation/scsi/scsi-parameters.rst | 16 ++++++++++++++++
 drivers/scsi/scsi.c                    |  6 ++++++
 drivers/scsi/scsi_sysctl.c             |  5 +++++
 drivers/scsi/sd.h                      | 11 ++++++++---
 include/scsi/scsi_device.h             |  8 ++++++--
 5 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/Documentation/scsi/scsi-parameters.rst b/Documentation/scsi/scsi-parameters.rst
index c42c55e1e25e..3c6284ef7fd5 100644
--- a/Documentation/scsi/scsi-parameters.rst
+++ b/Documentation/scsi/scsi-parameters.rst
@@ -93,6 +93,22 @@ parameters may be changed at runtime by the command
 			S390-tools package, available for download at
 			https://github.com/ibm-s390-linux/s390-tools/blob/master/scripts/scsi_logging_level
 
+	scsi_mod.storage_quiet_discovery=
+                       [SCSI] a parameter to control the printing from
+                        sdev_printk and sd_printk for systems with large
+                        amounts of LUNS.
+                        Defaults to 0 so unchanged behavior.
+                        If scsi_mod.storage_quiet_discovery=1 is added boot line
+                        then the messages are not printed and can be enabled
+                        after boot via
+                        echo 0 >
+                        /sys/module/scsi_mod/parameters/storage_quiet_discovery
+                        Another option is using
+                        sysctl -w dev.scsi.storage_quiet_discovery=0.
+                        Leaving this set to 0 in /etc/sysctl.conf and setting
+                        it to 1 on the kernel line will help for these large
+                        LUN count configurations and ensure its back on after boot.
+
 	scsi_mod.scan=	[SCSI] sync (default) scans SCSI busses as they are
 			discovered.  async scans them in kernel threads,
 			allowing boot to proceed.  none ignores them, expecting
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 24619c3bebd5..b6b1b9ecc30e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -86,6 +86,9 @@ unsigned int scsi_logging_level;
 EXPORT_SYMBOL(scsi_logging_level);
 #endif
 
+int storage_quiet_discovery = 0;
+EXPORT_SYMBOL(storage_quiet_discovery);
+
 /*
  * Domain for asynchronous system resume operations.  It is marked 'exclusive'
  * to avoid being included in the async_synchronize_full() that is invoked by
@@ -749,6 +752,9 @@ MODULE_LICENSE("GPL");
 
 module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
+module_param(storage_quiet_discovery, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(storage_quiet_discovery, "If set to 1 will silence SCSI and \
+		ALUA discovery logging on boot");
 
 static int __init init_scsi(void)
 {
diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index 7259704a7f52..db9e4520ad4e 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -18,6 +18,11 @@ static struct ctl_table scsi_table[] = {
 	  .maxlen	= sizeof(scsi_logging_level),
 	  .mode		= 0644,
 	  .proc_handler	= proc_dointvec },
+	{ .procname	= "storage_quiet_discovery",
+	  .data		= &storage_quiet_discovery,
+	  .maxlen	= sizeof(storage_quiet_discovery),
+	  .mode		= 0644,
+	  .proc_handler	= proc_dointvec },
 	{ }
 };
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index b59136c4125b..ede4d53a232a 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -133,11 +133,16 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 	return container_of(disk->private_data, struct scsi_disk, driver);
 }
 
+extern int storage_quiet_discovery;
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
-        (sdsk)->disk ?							\
-	      sdev_prefix_printk(prefix, (sdsk)->device,		\
+	do {								\
+		if (!storage_quiet_discovery)				\
+		 (sdsk)->disk ?						\
+			sdev_prefix_printk(prefix, (sdsk)->device,	\
 				 (sdsk)->disk->disk_name, fmt, ##a) :	\
-	      sdev_printk(prefix, (sdsk)->device, fmt, ##a)
+			sdev_printk(prefix, (sdsk)->device, fmt, ##a);	\
+	} while (0)
 
 #define sd_first_printk(prefix, sdsk, fmt, a...)			\
 	do {								\
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1a5c9a3df6d6..ca71aa784d1e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -258,8 +258,12 @@ __printf(4, 5) void
 sdev_prefix_printk(const char *, const struct scsi_device *, const char *,
 		const char *, ...);
 
-#define sdev_printk(l, sdev, fmt, a...)				\
-	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
+extern int storage_quiet_discovery;
+
+#define sdev_printk(l, sdev, fmt, a...) ({			\
+	if (!storage_quiet_discovery)				\
+		sdev_prefix_printk(l, sdev, NULL, fmt, ##a);	\
+	})
 
 __printf(3, 4) void
 scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
-- 
2.27.0

