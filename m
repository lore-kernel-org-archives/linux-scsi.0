Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4505CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16EAD207D4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qnb7mlRB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgGBBnc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:43:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51518 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbgGBBna (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:43:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621cMHd153751;
        Thu, 2 Jul 2020 01:43:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=f3kfZHXzfTx2LxdfncZVcUA3z5V5f5QIMVGhDWfe+Hs=;
 b=Qnb7mlRBW/TMZS6wVDQQ3B0V0/AlwTvaGPf5xZZkeLduHN0TVXAauVjzKv+Q6Rq1rgFm
 6M4kzJrXCpEGsNTJ70SeCzx9HcTaDxGiR5eHeQ7hglU5O0vxDPXPa12D8s1dvLrC851W
 qHEkc34dxWkwjlsJJ+m1TbpENBpI+Y1b8Ayd0JYPTVrwaG4cdMxGqTWnCDtgoFOMuPlo
 jbfl8iuEZFH6T0rEUdNXpWE2Nf9uRQ51+xve+tj/Y+nRwSHau+DLx/iG7ORcx0cJpJmk
 KoXn9Tt4gurS62pypsrO4zxywlPZVl+6FD6leNAPNqYrfdVwxi0f7WtbtgU73BfGftEA KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrndng3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 01:43:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621glFh050725;
        Thu, 2 Jul 2020 01:43:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31xg17stfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 01:43:25 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0621hPVZ022102;
        Thu, 2 Jul 2020 01:43:25 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 01:43:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, bstroesser@ts.fujitsu.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 4/7] target: fix iscsi transport id parsing
Date:   Wed,  1 Jul 2020 20:43:20 -0500
Message-Id: <1593654203-12442-5-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The length passed in the ADDITIONAL LENGTH field includes padding and
the terminating NULL for the last field (name or isid depending on the
format), so we should not also try to calculate that and then double add
that to the returned length.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_fabric_lib.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 1e031d8..81bc8ec 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -265,9 +265,7 @@ static char *iscsi_parse_pr_out_transport_id(
 	char **port_nexus_ptr)
 {
 	char *p;
-	u32 tid_len, padding;
 	int i;
-	u16 add_len;
 	u8 format_code = (buf[0] & 0xc0);
 	/*
 	 * Check for FORMAT CODE 00b or 01b from spc4r17, section 7.5.4.6:
@@ -293,23 +291,11 @@ static char *iscsi_parse_pr_out_transport_id(
 	 */
 	if (out_tid_len) {
 		/* The shift works thanks to integer promotion rules */
-		add_len = get_unaligned_be16(&buf[2]);
-
-		tid_len = strlen(&buf[4]);
-		tid_len += 4; /* Add four bytes for iSCSI Transport ID header */
-		tid_len += 1; /* Add one byte for NULL terminator */
-		padding = ((-tid_len) & 3);
-		if (padding != 0)
-			tid_len += padding;
-
-		if ((add_len + 4) != tid_len) {
-			pr_debug("LIO-Target Extracted add_len: %hu "
-				"does not match calculated tid_len: %u,"
-				" using tid_len instead\n", add_len+4, tid_len);
-			*out_tid_len = tid_len;
-		} else
-			*out_tid_len = (add_len + 4);
+		*out_tid_len = get_unaligned_be16(&buf[2]);
+		/* Add four bytes for iSCSI Transport ID header */
+		*out_tid_len += 4;
 	}
+
 	/*
 	 * Check for ',i,0x' separator between iSCSI Name and iSCSI Initiator
 	 * Session ID as defined in Table 390 - iSCSI initiator port TransportID
-- 
1.8.3.1

