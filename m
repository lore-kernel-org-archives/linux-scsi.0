Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B47C2D0A7
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 19:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FDC21D81
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 19:50:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ikuJDct3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIJTuR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 15:50:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726847AbgIJTta (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 15:49:30 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AJUs5L122237;
        Thu, 10 Sep 2020 15:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=i7JBPvdd60neM6rxo1EKqoMekpXsXBVik7L2XppxG1Q=;
 b=ikuJDct3ysKrb2mciuEJ//WpQuEpAo3o9o5yQTM5OvoelLzgdok9bS8MfIMlP32fFGTY
 seq2XZB+0fqKDKbgDTjrXPcssBLvVXpxE9soKUHinSBCEBF9t+JTvPctRzlpDcw/cmXB
 GYIy1p90Od0AbmGszGC9onu/QZe89I6r/v+Mye2g2iLKtdPYEokfKH4V5W5G3p87q9IA
 U/3utru3zVKMzlnW5bodPk0Gn19D6T2bKrFBuhkNjQDTA4hgiNkPmOCjRf59XrzkyU2V
 bnRrar9AmlyhNEuSkckyOPhMwtuGJomV6IZStxjWJ/KUn+uBqO8k1pi0jpTxCmfS1kHr NA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33fqts5mbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 15:49:23 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AJm3Um007401;
        Thu, 10 Sep 2020 19:49:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a86df4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 19:49:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AJnIfo30736648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 19:49:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A29B6A4064;
        Thu, 10 Sep 2020 19:49:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DF38A4054;
        Thu, 10 Sep 2020 19:49:18 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.32.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Sep 2020 19:49:18 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kGSZJ-00AFA2-Hz; Thu, 10 Sep 2020 21:49:17 +0200
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
Subject: [PATCH 2/2] zfcp: clarify access to erp_action in zfcp_fsf_req_complete()
Date:   Thu, 10 Sep 2020 21:49:16 +0200
Message-Id: <c500eac301fcbba5af942bbd200f2d6b14e46994.1599765652.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1599765652.git.bblock@linux.ibm.com>
References: <cover.1599765652.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_08:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxlogscore=999 suspectscore=2 clxscore=1015 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100173
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

While reviewing
commit 936e6b85da04 ("scsi: zfcp: Fix panic on ERP timeout for previously
dismissed ERP action"),
I stumbled over zfcp_fsf_req_complete() and wondered whether it has
similar issues wrt concurrent modification of req->erp_action
by zfcp_erp_strategy_check_fsfreq().

But a closer look shows that both its two callers
[zfcp_fsf_reqid_check(), zfcp_fsf_req_dismiss_all()] remove the request
from the adapter's req_list under the req_list's lock.
Hence we can trust that if zfcp_erp_strategy_check_fsfreq() concurrently
looks up the corresponding req_id, it won't find this request and is thus
unable to modify it while it's being processed by zfcp_fsf_req_complete().

Add a code comment that hopefully makes this easier for future readers,
and condense the two accesses to ->erp_action that made me trip over
this code path in the first place.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index c795f22249d8..d9de26157da2 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -426,9 +426,14 @@ static void zfcp_fsf_protstatus_eval(struct zfcp_fsf_req *req)
  * or it has been dismissed due to a queue shutdown, this function
  * is called to process the completion status and trigger further
  * events related to the FSF request.
+ * Caller must ensure that the request has been removed from
+ * adapter->req_list, to protect against concurrent modification
+ * by zfcp_erp_strategy_check_fsfreq().
  */
 static void zfcp_fsf_req_complete(struct zfcp_fsf_req *req)
 {
+	struct zfcp_erp_action *erp_action;
+
 	if (unlikely(zfcp_fsf_req_is_status_read_buffer(req))) {
 		zfcp_fsf_status_read_handler(req);
 		return;
@@ -439,8 +444,9 @@ static void zfcp_fsf_req_complete(struct zfcp_fsf_req *req)
 	zfcp_fsf_fsfstatus_eval(req);
 	req->handler(req);
 
-	if (req->erp_action)
-		zfcp_erp_notify(req->erp_action, 0);
+	erp_action = req->erp_action;
+	if (erp_action)
+		zfcp_erp_notify(erp_action, 0);
 
 	if (likely(req->status & ZFCP_STATUS_FSFREQ_CLEANUP))
 		zfcp_fsf_req_free(req);
-- 
2.26.2

