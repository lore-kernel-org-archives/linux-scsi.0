From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 02/35] qla2xxx: ISP27xx optimize fwdump entry table lookup.
Date: Wed, 24 Sep 2014 03:08:05 -0400
Message-ID: <1411542518-2477-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:16210 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbaIXHnr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:43:47 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Since the entry call array is sorted in order of entry type opcode,
the search can be terminated as soon as the search key is exceeded.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 252de5d..29271cc 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -726,7 +726,7 @@ qla27xx_fwdt_entry_other(struct scsi_qla_host *vha,
 }
 
 struct qla27xx_fwdt_entry_call {
-	int type;
+	uint type;
 	int (*call)(
 	    struct scsi_qla_host *,
 	    struct qla27xx_fwdt_entry *,
@@ -759,15 +759,17 @@ static struct qla27xx_fwdt_entry_call ql27xx_fwdt_entry_call_list[] = {
 	{ -1				, qla27xx_fwdt_entry_other }
 };
 
-static inline int (*qla27xx_find_entry(int type))
+static inline int (*qla27xx_find_entry(uint type))
 	(struct scsi_qla_host *, struct qla27xx_fwdt_entry *, void *, ulong *)
 {
 	struct qla27xx_fwdt_entry_call *list = ql27xx_fwdt_entry_call_list;
 
-	while (list->type != -1 && list->type != type)
+	while (list->type < type)
 		list++;
 
-	return list->call;
+	if (list->type == type)
+		return list->call;
+	return qla27xx_fwdt_entry_other;
 }
 
 static inline void *
-- 
1.7.7

