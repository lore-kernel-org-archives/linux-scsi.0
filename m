Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19C1C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 19:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 851C7221E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 19:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WQv2kH61"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgIJTuT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 15:50:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726760AbgIJTta (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 15:49:30 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AJUibe002714;
        Thu, 10 Sep 2020 15:49:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=2d010pYJBFiT9ncMmOMK+RtKaeSGGAVRGdxZl9MMv2A=;
 b=WQv2kH61Z+Mfc/FLijymod/7hI2nQJLTEeN7HZNWCfo5NjoyvDYXDmBlyqfErJsp/2z9
 LChG0MyfIQ0igvoYWsO8bKPa6hRhhz4aCuEcVURHSZnN2UVyBFg7HbNCJ2nDXDlhpbS+
 rhdXYOWmPTAM6EJWkaY9Q4Yscl1/2FgdAswG4Z0h22A61HU6pwxoZHrmRWNJdceVOKrU
 F27yrMNvKBuvWRKa1VP55QLGuEhRntIcmATEa8rdksNgGG7T8T/aIMANjns0VpaacX7N
 P+sqdJd/bpkHOT9WSu0AgO9Zeq2sK2LyHXNSnhzUvrhKPE//pmzF3FBjUz6zwpe0BMQQ 2w== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33frwhb8x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 15:49:25 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AJn2lL003388;
        Thu, 10 Sep 2020 19:49:23 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 33f3yrgrem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 19:49:22 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AJnJHT15663384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 19:49:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C65774C040;
        Thu, 10 Sep 2020 19:49:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2C364C044;
        Thu, 10 Sep 2020 19:49:19 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.32.17])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Sep 2020 19:49:19 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kGSZJ-00AFA0-8s; Thu, 10 Sep 2020 21:49:17 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 1/2] zfcp: use list_first_entry_or_null() in zfcp_erp_thread()
Date:   Thu, 10 Sep 2020 21:49:15 +0200
Message-Id: <ed669555c73aab95b29444c10066f492c0c43391.1599765652.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1599765652.git.bblock@linux.ibm.com>
References: <cover.1599765652.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_08:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 mlxlogscore=991
 mlxscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100173
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

Use the right helper to avoid poking around in the list's internals.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 59e662df5774..78d52a4c55f5 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -1607,7 +1607,6 @@ static enum zfcp_erp_act_result zfcp_erp_strategy(
 static int zfcp_erp_thread(void *data)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
-	struct list_head *next;
 	struct zfcp_erp_action *act;
 	unsigned long flags;
 
@@ -1620,12 +1619,11 @@ static int zfcp_erp_thread(void *data)
 			break;
 
 		write_lock_irqsave(&adapter->erp_lock, flags);
-		next = adapter->erp_ready_head.next;
+		act = list_first_entry_or_null(&adapter->erp_ready_head,
+					       struct zfcp_erp_action, list);
 		write_unlock_irqrestore(&adapter->erp_lock, flags);
 
-		if (next != &adapter->erp_ready_head) {
-			act = list_entry(next, struct zfcp_erp_action, list);
-
+		if (act) {
 			/* there is more to come after dismission, no notify */
 			if (zfcp_erp_strategy(act) != ZFCP_ERP_DISMISSED)
 				zfcp_erp_wakeup(adapter);
-- 
2.26.2

