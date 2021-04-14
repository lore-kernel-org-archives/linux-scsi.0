Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22F2C43600
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF16461179
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbhDNRIl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 13:08:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22142 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233372AbhDNRIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 13:08:35 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EH3Iv8083874;
        Wed, 14 Apr 2021 13:08:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=i/QIP7yyFHHUzrePqrib6tTBtcTgfmW8lt62xE3x3CM=;
 b=IAlR0GQXNboRhmMGzVILSpLH3OpUKzPwk/GpdpBGfgjPrvN6W3cDoYesklKl6WwcrQPW
 ymr4DMbmDDapQP/4F/+g2dB8KWSrF0AKWbZ6AMymZ9Yy5qS78u9D1WLgZWIH1oB3mhVA
 FvXBP0pEbiXW9Rns341H/+Xor847iDFpWNH8Jz27pLlaZ9v9SdpDw7eNjN6nkCLDmNti
 2q8WHK5EejYZAppZiwMfOr8XWNbBBTTvXfkGWH8vmAi7N5hwus//JYzasxKMHyxhaLtG
 AfyHl5az/cfm112tvCC6mDJbnR6Fbh3+OnjUUU+QMGdMXerZPlfzsSQXcL+XH6uWTnrr QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x46wghnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 13:08:10 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13EH3lDQ085380;
        Wed, 14 Apr 2021 13:08:10 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x46wghm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 13:08:10 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13EH4o5n023768;
        Wed, 14 Apr 2021 17:08:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 37u3n89ty7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 17:08:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13EH857H39125452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 17:08:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D702BA51E8;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB426A51DE;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.18.252])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lWizk-002b2r-Ad; Wed, 14 Apr 2021 19:08:04 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Yevhen Viktorov <yevhen.viktorov@virginmedia.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Sumangala Bannur Subraya <bsuma@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 2/6] zfcp: fix indentation coding style issue
Date:   Wed, 14 Apr 2021 19:08:00 +0200
Message-Id: <e8a15a2f3d64e2e76a214647cfd4fe23d370b165.1618417667.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618417667.git.bblock@linux.ibm.com>
References: <cover.1618417667.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: edBQlGmlLgqOF5OsCdkf3-jPiPm6njzS
X-Proofpoint-ORIG-GUID: pKg6yxe6w-PMdzbtogXLCmVqcbB5SKs6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_10:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yevhen Viktorov <yevhen.viktorov@virginmedia.com>

code indent should use tabs where possible

Signed-off-by: Yevhen Viktorov <yevhen.viktorov@virginmedia.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 26c89c232ef2..94de55304a02 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -156,7 +156,7 @@ struct zfcp_adapter {
 	u32			fsf_lic_version;
 	u32			adapter_features;  /* FCP channel features */
 	u32			connection_features; /* host connection features */
-        u32			hardware_version;  /* of FCP channel */
+	u32			hardware_version;  /* of FCP channel */
 	u32			fc_security_algorithms; /* of FCP channel */
 	u32			fc_security_algorithms_old; /* of FCP channel */
 	u16			timer_ticks;       /* time int for a tick */
@@ -180,7 +180,7 @@ struct zfcp_adapter {
 	rwlock_t		erp_lock;
 	wait_queue_head_t	erp_done_wqh;
 	struct zfcp_erp_action	erp_action;	   /* pending error recovery */
-        atomic_t                erp_counter;
+	atomic_t		erp_counter;
 	u32			erp_total_count;   /* total nr of enqueued erp
 						      actions */
 	u32			erp_low_mem_count; /* nr of erp actions waiting
@@ -217,7 +217,7 @@ struct zfcp_port {
 	u32		       d_id;	       /* D_ID */
 	u32		       handle;	       /* handle assigned by FSF */
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
-        atomic_t               erp_counter;
+	atomic_t	       erp_counter;
 	u32                    maxframe_size;
 	u32                    supported_classes;
 	u32                    connection_info;
-- 
2.30.2

