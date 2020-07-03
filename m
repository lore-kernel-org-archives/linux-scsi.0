Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740D4C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 13:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B95720936
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 13:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgGCNVH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:21:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgGCNVE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 09:21:04 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063D2dwb104131;
        Fri, 3 Jul 2020 09:21:02 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 320wfhhp5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 09:21:02 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063DL00S018190;
        Fri, 3 Jul 2020 13:21:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 31wwr83eu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 13:21:00 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063DKvpp59048072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 13:20:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20F1FA404D;
        Fri,  3 Jul 2020 13:20:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B655A4040;
        Fri,  3 Jul 2020 13:20:57 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.150.95])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 Jul 2020 13:20:57 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jrLcd-005ouL-Vm; Fri, 03 Jul 2020 15:20:55 +0200
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
Subject: [PATCH 5/7] zfcp: clean up zfcp_erp_action_ready()
Date:   Fri,  3 Jul 2020 15:20:01 +0200
Message-Id: <d1bb04322f240dee32f4c4a551bc93bc736f4b01.1593780621.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593780621.git.bblock@linux.ibm.com>
References: <cover.1593780621.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_06:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 mlxlogscore=999 cotscore=-2147483648
 adultscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030087
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

We already maintain a pointer to act->adapter. Use it consistently to
avoid any confusion about whose ->erp_ready_head and ->erp_ready_wq
we are accessing.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 79f6e8fb03ca..59e662df5774 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -68,7 +68,7 @@ static void zfcp_erp_action_ready(struct zfcp_erp_action *act)
 {
 	struct zfcp_adapter *adapter = act->adapter;
 
-	list_move(&act->list, &act->adapter->erp_ready_head);
+	list_move(&act->list, &adapter->erp_ready_head);
 	zfcp_dbf_rec_run("erardy1", act);
 	wake_up(&adapter->erp_ready_wq);
 	zfcp_dbf_rec_run("erardy2", act);
-- 
2.26.2

