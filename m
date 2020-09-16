Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1320C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 23:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE5E2065D
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 23:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0XyIgSai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgIPXyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:54:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgIPXyl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2020 19:54:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GNdCI5043285;
        Wed, 16 Sep 2020 23:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=faphjq4V6qIdb6BswXLcrA4nmRlyKCEQZO7jAdMlnvo=;
 b=0XyIgSaiFSBIMb6k+onifLcP364Lk3ScvdZxhjiGZQ5SmBGmiaD7cOmm7v8mAE7Eccgu
 4UdlwvNQPOmChBioSU/e/NRgf7pXSPTUVId5T+QTvE75/4d7OhpE9FGCxoWb984twhif
 ky7Z0+8GoFTNCb3Mao+9e268o+N6eyqdk4/jLrXDCsL8t7yOfXXgWk26xUcchJNRA//r
 0/IbBDFG2uTejk0qSzw3OJWM0PiLT0S2X/mQN0F+luXzya5eZ0tu4Y1bhMfoZeBOsQ5P
 9n+nY9dwKEdfz5r/OWNL2DfLUcJJqCIePnk5PkGErfT0f7wggt3pRK4g0TMKoZM0iNuw UA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9me074-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 23:54:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GNe1IQ192413;
        Wed, 16 Sep 2020 23:54:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33khpm6v7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 23:54:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08GNscb8027289;
        Wed, 16 Sep 2020 23:54:38 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 23:54:38 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     ssudhakarp@gmail.com
Subject: [PATCH] scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case.
Date:   Wed, 16 Sep 2020 23:54:31 +0000
Message-Id: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160176
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

transport_lookup_tmr_lun() uses "orig_fe_lun" member of struct se_cmd
for the lookup. Hence, update this field directly for the
TARGET_SCF_LOOKUP_LUN_FROM_TAG case.

Fixes: a36840d80027 ("target: Initialize LUN in transport_init_se_cmd()")
Reported-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/target_core_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9fb0be0aa620..8dd289214dd8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1840,7 +1840,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * out unpacked_lun for the original se_cmd.
 	 */
 	if (tm_type == TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
-		if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_lun))
+		if (!target_lookup_lun_from_tag(se_sess, tag,
+						&se_cmd->orig_fe_lun))
 			goto failure;
 	}
 
-- 
1.8.3.1

