Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F35C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0D5B2082F
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D8GaqqeU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgGBBnk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:43:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33912 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgGBBna (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:43:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621cwbn155834;
        Thu, 2 Jul 2020 01:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=fK14tJ8EapNLd8Lo5gCESUlnZUEqFu1GK84uDjIBzWU=;
 b=D8GaqqeUQLYO1GfS/Ow25clYWVzgneGlXlDNoIweVSyCGwZsb2r8vS0ON5XPsQRdwsml
 XGH2Mw22iRMLTDSEAlI1xQjyARofW+XvNV32Vhdp7E6wZUYGXGVS3Mz/Rh16v+vUwblA
 UE/cW7h4/cAQ7Z6/MKR2IEQS12MPoLsjzf+r6d1ZyvAkqXWr6ZhYOlrsMZjjHvl1vLgQ
 cK/bXEr8iENAC0uMgGMv3kbuXRKB4Yzm9B/Q0tvhPAUDv/Qyw5vfEpVq9KUTnXGj79Ao
 TgjooIYqsTX6gOD/suAV99FIpouq5W1A9fVFEAyxwsLASfEQzdOZrHh98G9s0Kz3LlPd TQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31xx1e2hur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 01:43:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621bqLd181516;
        Thu, 2 Jul 2020 01:43:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg204ty9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 01:43:27 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0621hQpD017167;
        Thu, 2 Jul 2020 01:43:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 01:43:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, bstroesser@ts.fujitsu.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 7/7] target: handle short iSIDs
Date:   Wed,  1 Jul 2020 20:43:23 -0500
Message-Id: <1593654203-12442-8-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SPC4 has:

The first ISCSI INITIATOR SESSION ID field byte containing an ASCII
null character terminates the ISCSI INITIATOR SESSION ID field without
regard for the specified length of the iSCSI TransportID or the contents
of the ADDITIONAL LENGTH field.
----------------------------------------

which sounds like we can get an iSID shorter than 12 chars. SPC and
the iSCSI RFC do not say how to handle that case other than just
cutting off the iSID. This patch just makes sure that if we get an
iSID like that, we only copy/send that string.

There is no OS that does this right now, so there was no test case.
I did test with sg utils to check it works as expected and nothing
breaks.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_fabric_lib.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 1d2762a..6600ae4 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -132,6 +132,7 @@ static int iscsi_get_pr_transport_id(
 	unsigned char *buf)
 {
 	u32 off = 4, padding = 0;
+	int isid_len;
 	u16 len = 0;
 
 	spin_lock_irq(&se_nacl->nacl_sess_lock);
@@ -184,11 +185,11 @@ static int iscsi_get_pr_transport_id(
 		buf[off++] = 0x2c; /* ASCII Character: "," */
 		buf[off++] = 0x30; /* ASCII Character: "0" */
 		buf[off++] = 0x78; /* ASCII Character: "x" */
+		len += 5;
 
-		memcpy(buf + off, pr_reg->pr_reg_isid, 12);
-		off += 12;
-
-		len += 17;
+		isid_len = sprintf(buf + off, "%s", pr_reg->pr_reg_isid);
+		off += isid_len;
+		len += isid_len;
 	}
 	buf[off] = '\0';
 	len += 1;
@@ -234,7 +235,7 @@ static int iscsi_get_pr_transport_id_len(
 	 */
 	if (pr_reg->isid_present_at_reg) {
 		len += 5; /* For ",i,0x" ASCII separator */
-		len += 12; /* For iSCSI Initiator Session ID */
+		len += strlen(pr_reg->pr_reg_isid);
 		*format_code = 1;
 	} else
 		*format_code = 0;
@@ -318,6 +319,16 @@ static char *iscsi_parse_pr_out_transport_id(
 		 * iscsi_target.c:lio_sess_get_initiator_sid()
 		 */
 		for (i = 0; i < 12; i++) {
+			/*
+			 * The first ISCSI INITIATOR SESSION ID field byte
+			 * containing an ASCII null character terminates the
+			 * ISCSI INITIATOR SESSION ID field without regard for
+			 * the specified length of the iSCSI TransportID or the
+			 * contents of the ADDITIONAL LENGTH field.
+			 */
+			if (*p == '\0')
+				break;
+
 			if (isdigit(*p)) {
 				p++;
 				continue;
-- 
1.8.3.1

