From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH] scsi: fix upper bounds check of sense key in scsi_sense_key_string()
Date: Thu,  4 Aug 2016 16:32:17 -0500
Message-ID: <1470346337-20034-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39038 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965798AbcHDVdC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2016 17:33:02 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u74LTkdD022548
	for <linux-scsi@vger.kernel.org>; Thu, 4 Aug 2016 17:32:28 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24kkam8db3-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2016 17:32:27 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Thu, 4 Aug 2016 17:32:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

Commit 655ee63cf371 added a "Completed" sense string with key 0xF to
snstext[], but failed to updated the upper bounds check of the sense key in
scsi_sense_key_string().

Fixes: 655ee63cf371 ("[SCSI] scsi constants: command, sense key + additional sense strings")
Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/constants.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 83458f7..70d8dc4 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -362,7 +362,7 @@ static const char * const snstext[] = {
 /* Get sense key string or NULL if not available */
 const char *
 scsi_sense_key_string(unsigned char key) {
-	if (key <= 0xE)
+	if (key <= 0xF)
 		return snstext[key];
 	return NULL;
 }
-- 
2.7.4

