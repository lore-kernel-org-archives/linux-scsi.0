From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH v2] scsi: fix upper bounds check of sense key in scsi_sense_key_string()
Date: Fri, 12 Aug 2016 17:20:07 -0500
Message-ID: <1471040407-5325-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56038 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbcHLWUQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2016 18:20:16 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7CM9pAu061013
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2016 18:20:16 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24skd0ys74-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2016 18:20:16 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Fri, 12 Aug 2016 16:20:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

Commit 655ee63cf371 added a "Completed" sense string with key 0xF to
snstext[], but failed to updated the upper bounds check of the sense key in
scsi_sense_key_string().

Fixes: 655ee63cf371 ("[SCSI] scsi constants: command, sense key + additional sense strings")
Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---

Changes since v1:
 - Addressed Bart's comments
 - Moved opening function brace to match kernel style guidelines
 - Changed upperbounds check to use ARRAY_SIZE instead of fixed value

 drivers/scsi/constants.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 83458f7..6dc96c8 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -361,8 +361,9 @@ static const char * const snstext[] = {
 
 /* Get sense key string or NULL if not available */
 const char *
-scsi_sense_key_string(unsigned char key) {
-	if (key <= 0xE)
+scsi_sense_key_string(unsigned char key)
+{
+	if (key < ARRAY_SIZE(snstext))
 		return snstext[key];
 	return NULL;
 }
-- 
2.7.4

