From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/22] scsi: introduce sdev_prefix_printk()
Date: Thu, 28 Aug 2014 19:33:18 +0200
Message-ID: <1409247216-76074-5-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaH1Rdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:41 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/scsi/scsi_device.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1a0d184..91ac2e6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -243,6 +243,11 @@ struct scsi_dh_data {
 #define sdev_dbg(sdev, fmt, a...) \
 	dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
 
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

