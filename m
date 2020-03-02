Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFD1C3F2CD
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 14:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D76D2166E
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 14:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgCBOjm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 09:39:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727113AbgCBOjm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2020 09:39:42 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022EOWAm121755;
        Mon, 2 Mar 2020 09:39:35 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfmq9vv6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Mar 2020 09:39:35 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 022EcW9S003989;
        Mon, 2 Mar 2020 14:39:34 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 2yffk62vfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Mar 2020 14:39:34 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 022EdX4Z19661308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Mar 2020 14:39:33 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B0737805F;
        Mon,  2 Mar 2020 14:39:33 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAB2C7805E;
        Mon,  2 Mar 2020 14:39:32 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.160.4.131])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  2 Mar 2020 14:39:32 +0000 (GMT)
From:   Brian King <brking@linux.vnet.ibm.com>
To:     tyreld@linux.vnet.ibm.com
Cc:     brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, sfr@canb.auug.org.au
Subject: [PATCH] ibmvfc: Fix NULL return compiler warning
Date:   Mon,  2 Mar 2020 08:39:21 -0600
Message-Id: <1583159961-15903-1-git-send-email-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_04:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=1 bulkscore=0
 mlxlogscore=770 phishscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020105
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix up a compiler warning introduced via 54b04c99d02e

Fixes: 54b04c99d02e ("scsi: ibmvfc: Avoid loss of all paths during SVC node reboot")
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 84dd8c5..7da9e06 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3641,7 +3641,7 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
 	struct ibmvfc_event *evt;
 
 	if (vhost->discovery_threads >= disc_threads)
-		return NULL;
+		return;
 
 	vhost->discovery_threads++;
 	evt = __ibmvfc_tgt_get_implicit_logout_evt(tgt,
-- 
1.8.3.1

