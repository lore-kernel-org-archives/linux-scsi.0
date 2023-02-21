Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93368C64ED6
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 17:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjBUR47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 12:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbjBUR4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 12:56:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F322FCF7;
        Tue, 21 Feb 2023 09:56:25 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LHmOov027932;
        Tue, 21 Feb 2023 17:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=RbLY453aM2g6rW0ssZDbSPfoD1+ul3gCLu4i7KKVNgs=;
 b=i7hKvHbLjZ0ZZbAT4mFSniKh/eJO05kSpTo0GB+NKgwdsIcLGuz+Flx7BugxZcO0LqgD
 V/dJrEMczgea3DT7sIc7jGYgZJ4Opg1PD1K8sA59pLv2rsCxt96Xwj70JiEIy+kkBO2v
 9oCPyJ7FSlkidobaRqeh7OzkaqZypcdJRmjxWcV2n2l1QxnEjTBxDOsF/VQcef9YrvYU
 7Wmzgao3axgPHfkw7DAnQjPScEH0ArFVIzg9gL83ylU82AW/LT7XMXSn8s3tlfXTwhWH
 xzkjPYLURleWqQHhHrp+QRf4bANuH9r6Kf8HZhP/zoDfgMm/E+QadEdRx/4GI4Gr5cQ7 PA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw29f0q5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:56:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31LD1m5g001635;
        Tue, 21 Feb 2023 17:56:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ntpa6394a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:56:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31LHu18625887436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 17:56:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8FCC2004B;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A40FC20043;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.246])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pUWrx-003al1-0J;
        Tue, 21 Feb 2023 18:56:01 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Steffen Maier" <maier@linux.ibm.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        "Fedor Loshakov" <loshakov@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 1/3] zfcp: make the type for accessing request hashtable buckets size_t
Date:   Tue, 21 Feb 2023 18:55:58 +0100
Message-Id: <64afe93f6263c6b07815937826cd7d5fc4f1a674.1677000450.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1677000450.git.bblock@linux.ibm.com>
References: <cover.1677000450.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung David Faller, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294, https://www.ibm.com/privacy
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wPd6E5qT756267t-5uhJLkz31W_RU_U6
X-Proofpoint-ORIG-GUID: wPd6E5qT756267t-5uhJLkz31W_RU_U6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_10,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 clxscore=1011 adultscore=0 mlxlogscore=916
 impostorscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The appropriate type for array indices is size_t and the current
implementation in `zfcp_reqlist.h` mixes `int` and `unsigned int` in
different places to access the hashtable buckets of our internal request
hash table.

To prevent any confusion changed all places to `size_t`.

Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_reqlist.h | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_reqlist.h b/drivers/s390/scsi/zfcp_reqlist.h
index 9b8ff249e31c..f4bac61dfbd0 100644
--- a/drivers/s390/scsi/zfcp_reqlist.h
+++ b/drivers/s390/scsi/zfcp_reqlist.h
@@ -5,14 +5,16 @@
  * Data structure and helper functions for tracking pending FSF
  * requests.
  *
- * Copyright IBM Corp. 2009, 2016
+ * Copyright IBM Corp. 2009, 2023
  */
 
 #ifndef ZFCP_REQLIST_H
 #define ZFCP_REQLIST_H
 
+#include <linux/types.h>
+
 /* number of hash buckets */
-#define ZFCP_REQ_LIST_BUCKETS 128
+#define ZFCP_REQ_LIST_BUCKETS 128u
 
 /**
  * struct zfcp_reqlist - Container for request list (reqlist)
@@ -24,7 +26,7 @@ struct zfcp_reqlist {
 	struct list_head buckets[ZFCP_REQ_LIST_BUCKETS];
 };
 
-static inline int zfcp_reqlist_hash(unsigned long req_id)
+static inline size_t zfcp_reqlist_hash(unsigned long req_id)
 {
 	return req_id % ZFCP_REQ_LIST_BUCKETS;
 }
@@ -37,7 +39,7 @@ static inline int zfcp_reqlist_hash(unsigned long req_id)
  */
 static inline struct zfcp_reqlist *zfcp_reqlist_alloc(void)
 {
-	unsigned int i;
+	size_t i;
 	struct zfcp_reqlist *rl;
 
 	rl = kzalloc(sizeof(struct zfcp_reqlist), GFP_KERNEL);
@@ -60,7 +62,7 @@ static inline struct zfcp_reqlist *zfcp_reqlist_alloc(void)
  */
 static inline int zfcp_reqlist_isempty(struct zfcp_reqlist *rl)
 {
-	unsigned int i;
+	size_t i;
 
 	for (i = 0; i < ZFCP_REQ_LIST_BUCKETS; i++)
 		if (!list_empty(&rl->buckets[i]))
@@ -84,7 +86,7 @@ static inline struct zfcp_fsf_req *
 _zfcp_reqlist_find(struct zfcp_reqlist *rl, unsigned long req_id)
 {
 	struct zfcp_fsf_req *req;
-	unsigned int i;
+	size_t i;
 
 	i = zfcp_reqlist_hash(req_id);
 	list_for_each_entry(req, &rl->buckets[i], list)
@@ -154,7 +156,7 @@ zfcp_reqlist_find_rm(struct zfcp_reqlist *rl, unsigned long req_id)
 static inline void zfcp_reqlist_add(struct zfcp_reqlist *rl,
 				    struct zfcp_fsf_req *req)
 {
-	unsigned int i;
+	size_t i;
 	unsigned long flags;
 
 	i = zfcp_reqlist_hash(req->req_id);
@@ -172,7 +174,7 @@ static inline void zfcp_reqlist_add(struct zfcp_reqlist *rl,
 static inline void zfcp_reqlist_move(struct zfcp_reqlist *rl,
 				     struct list_head *list)
 {
-	unsigned int i;
+	size_t i;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rl->lock, flags);
@@ -200,7 +202,7 @@ zfcp_reqlist_apply_for_all(struct zfcp_reqlist *rl,
 {
 	struct zfcp_fsf_req *req;
 	unsigned long flags;
-	unsigned int i;
+	size_t i;
 
 	spin_lock_irqsave(&rl->lock, flags);
 	for (i = 0; i < ZFCP_REQ_LIST_BUCKETS; i++)
-- 
2.39.2

