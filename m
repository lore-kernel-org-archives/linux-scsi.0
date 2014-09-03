From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/20] scsi: introduce sdev_prefix_printk()
Date: Wed,  3 Sep 2014 12:05:59 +0200
Message-ID: <1409738775-80876-5-git-send-email-hare@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbaICKGZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:25 -0400
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Like scmd_printk(), but the device name is passed in as
a string. Can be used by eg ULDs which do not have access
to the scsi_cmnd structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/scsi/scsi_device.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1a0d184..4e091c8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -243,6 +243,15 @@ struct scsi_dh_data {
 #define sdev_dbg(sdev, fmt, a...) \
 	dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
 
+/*
+ * like scmd_printk, but the device name is passed in
+ * as a string pointer
+ */
+#define sdev_prefix_printk(l, sdev, p, fmt, a...)			\
+	(p) ?								\
+	sdev_printk(l, sdev, "[%s] " fmt, p, ##a) :			\
+	sdev_printk(l, sdev, fmt, ##a)
+
 #define scmd_printk(prefix, scmd, fmt, a...)				\
         (scmd)->request->rq_disk ?					\
 	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
-- 
1.8.5.2

