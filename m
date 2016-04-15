From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] qla2xxx: rewrite code to avoid hitting gcc bug 70646
Date: Fri, 15 Apr 2016 12:36:23 +0200
Message-ID: <1460716583-15673-1-git-send-email-dvlasenk@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbcDOKgd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 06:36:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, qla2xxx-upstream@qlogic.com, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

More info here:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Himanshu Madhani <himanshu.madhani@qlogic.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: qla2xxx-upstream@qlogic.com
CC: Josh Poimboeuf <jpoimboe@redhat.com>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/qla2xxx/qla_attr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 4dc06a13..2dd9c72 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2003,9 +2003,14 @@ static void
 qla2x00_get_host_fabric_name(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *vha = shost_priv(shost);
+	/*
+	 * This can trigger gcc 4.9/5.3 bug.
+	 * See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646
 	uint8_t node_name[WWN_SIZE] = { 0xFF, 0xFF, 0xFF, 0xFF, \
 		0xFF, 0xFF, 0xFF, 0xFF};
 	u64 fabric_name = wwn_to_u64(node_name);
+	 */
+	u64 fabric_name = (u64)(s64)-1; /* the same as above */
 
 	if (vha->device_flags & SWITCH_FOUND)
 		fabric_name = wwn_to_u64(vha->fabric_node_name);
-- 
1.8.1.4

