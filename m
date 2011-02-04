From: Vasiliy Kulikov <segoon@openwall.com>
Subject: [PATCH 19/20] scsi: iscsi: world-writable sysfs priv_sess file
Date: Fri,  4 Feb 2011 15:24:14 +0300
Message-ID: <1ca8a99eaadde79e662573d89e4f17a20457fba0.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1BDMYT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2011 07:24:19 -0500
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <James.Bottomley@suse.de>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

Don't allow everybody to change iSCSI settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f905ecb..01543d2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1847,7 +1847,7 @@ store_priv_session_##field(struct device *dev,				\
 #define iscsi_priv_session_rw_attr(field, format)			\
 	iscsi_priv_session_attr_show(field, format)			\
 	iscsi_priv_session_attr_store(field)				\
-static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUGO,		\
+static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUSR,		\
 			show_priv_session_##field,			\
 			store_priv_session_##field)
 iscsi_priv_session_rw_attr(recovery_tmo, "%d");
-- 
1.7.0.4

