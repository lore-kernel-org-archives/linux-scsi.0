From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/3] iscsi-target: Expose per endpoint dynamic_sessions attribute
Date: Sat,  7 Mar 2015 05:27:08 +0000
Message-ID: <1425706029-2436-2-git-send-email-nab@daterainc.com>
References: <1425706029-2436-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41748 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbCGF1R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2015 00:27:17 -0500
Received: by obcva8 with SMTP id va8so13477177obc.8
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2015 21:27:16 -0800 (PST)
In-Reply-To: <1425706029-2436-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch exposes a new ../iscsi/$IQN/$TPGT/dynamic_sessions attribute
to dump the currently active sessions by iSCSI InitiatorName that have
been created with dynamically generated se_node_acls.

This information is useful so that user-space can optionally perform
dynamic -> explicit NodeACL conversion based on $INITIATOR_WWPN.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 48384b6..95a67f6 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1410,8 +1410,18 @@ out:
 
 TF_TPG_BASE_ATTR(lio_target, enable, S_IRUGO | S_IWUSR);
 
+static ssize_t lio_target_tpg_show_dynamic_sessions(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	return target_show_dynamic_sessions(se_tpg, page);
+}
+
+TF_TPG_BASE_ATTR_RO(lio_target, dynamic_sessions);
+
 static struct configfs_attribute *lio_target_tpg_attrs[] = {
 	&lio_target_tpg_enable.attr,
+	&lio_target_tpg_dynamic_sessions.attr,
 	NULL,
 };
 
-- 
1.9.1

