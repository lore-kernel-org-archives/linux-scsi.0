Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7986C433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1621207F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OPxGddzl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgGBBnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:43:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51526 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgGBBna (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:43:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621cE1I153722;
        Thu, 2 Jul 2020 01:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=DWAIxulAH+tb9paAnCtFhRyJYCxj9IZByO0kan0Qh5c=;
 b=OPxGddzleqanBu12q7nSsP3Tzyo/hy1hUrbbngGvCdMU+b29UPMF6c6GqF+aCCIogEFI
 lmfJ9RTAy1JgLhzNBClatJXGPUtkKwoA2zaXzkYuNV9pjPC19UFT0c+PGz3eWeWaYHDY
 4wooiRNKYo8VS17obzY8X5TMhk7SOcXk93ZfSPeVk667ddt2ZjfWbbqYMtqxQmqfCVy4
 iEFrAS/ehTttsZb3jBSFVIHIO3tkO+b+iCafEwvz6b5RUetF46rMIuN8+XtTNCyWZONc
 UJpyhp4hxvBn9vtXuieVl8PoJBiNXpAmbdQBjqKQP93S0ZKRUMiDPZBgTFcec/q08e5F DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrndng5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 01:43:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621bvvP181672;
        Thu, 2 Jul 2020 01:43:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31xg204ty2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 01:43:26 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0621hQTJ030548;
        Thu, 2 Jul 2020 01:43:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 01:43:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, bstroesser@ts.fujitsu.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 6/7] target: fix iscsi transport id buf len calculation
Date:   Wed,  1 Jul 2020 20:43:22 -0500
Message-Id: <1593654203-12442-7-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020009
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

The isid returned to the initiator is in string format which is 12
bytes. We also only add 1 terminating NULL and not one after the
initiator name and another one after the isid.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_fabric_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 428e5a1..1d2762a 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -234,7 +234,7 @@ static int iscsi_get_pr_transport_id_len(
 	 */
 	if (pr_reg->isid_present_at_reg) {
 		len += 5; /* For ",i,0x" ASCII separator */
-		len += 7; /* For iSCSI Initiator Session ID + Null terminator */
+		len += 12; /* For iSCSI Initiator Session ID */
 		*format_code = 1;
 	} else
 		*format_code = 0;
-- 
1.8.3.1

