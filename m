From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 3/3] tcm_qla2xxx: Expose per endpoint dynamic_sessions attribute
Date: Sat,  7 Mar 2015 05:27:09 +0000
Message-ID: <1425706029-2436-3-git-send-email-nab@daterainc.com>
References: <1425706029-2436-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37536 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbbCGF1S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2015 00:27:18 -0500
Received: by obcwp4 with SMTP id wp4so17753842obc.4
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2015 21:27:17 -0800 (PST)
In-Reply-To: <1425706029-2436-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch exposes a new ../qla2xxx*/$WWPN/$TPGT/dynamic_sessions
attribute to dump the currently active sessions by FC initiator WWPN
that have been created with dynamically generated se_node_acls.

This information is useful so that user-space can optionally perform
dynamic -> explicit NodeACL conversion based on $INITIATOR_WWPN.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 99f43b7..c4f66f5 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1082,8 +1082,18 @@ static ssize_t tcm_qla2xxx_tpg_store_enable(
 
 TF_TPG_BASE_ATTR(tcm_qla2xxx, enable, S_IRUGO | S_IWUSR);
 
+static ssize_t tcm_qla2xxx_tpg_show_dynamic_sessions(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	return target_show_dynamic_sessions(se_tpg, page);
+}
+
+TF_TPG_BASE_ATTR_RO(tcm_qla2xxx, dynamic_sessions);
+
 static struct configfs_attribute *tcm_qla2xxx_tpg_attrs[] = {
 	&tcm_qla2xxx_tpg_enable.attr,
+	&tcm_qla2xxx_tpg_dynamic_sessions.attr,
 	NULL,
 };
 
-- 
1.9.1

