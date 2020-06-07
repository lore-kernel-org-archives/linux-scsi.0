Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC3CC433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DCEB2074B
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:38:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EX310bzc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgFGUiS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:38:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgFGUiR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:38:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KYLHX137503;
        Sun, 7 Jun 2020 20:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=n8tKsegJVHzMwlJSyWtcV4KKJq000xk2NaH/m2BBKPQ=;
 b=EX310bzcDdoJg7KKC/gIEGTin7Mvm8ReT5zoBCftCYaiPtSAMPUu3WllDpxjGuGu45oN
 bFroGRL/UJ85l5qzezkjlLf8ZRD60bGlkXGn++7Rg9fcHLm4k9ZCkCyCeY/+k0Qv1/LC
 dHDG3Uy94hI+pidQleTtW8jWCUX1gqYhkYHSzdwiROxfi16yabY1H50bezQMPr2IaQcW
 Wlndbbob6ErBqaROxEdRxf2XsBaEHrq3K1qPLQC5GrU/RJ6jhdXNTlcJS5omPmHMmULU
 IAXARno4YOQm1R//sE7/2IAulaaX8IRcHxnFvEIYaERpz4dNf6qzKDbIy+GILFAmkHuv Hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31g3smkxh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:38:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KRjqN075772;
        Sun, 7 Jun 2020 20:36:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31gmqk8a5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:10 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057Ka9sg003531;
        Sun, 7 Jun 2020 20:36:09 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:09 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 01/17] target: check enforce_pr_isids during registration
Date:   Sun,  7 Jun 2020 15:35:48 -0500
Message-Id: <1591562164-9766-2-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006070161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the check for enforce_pr_isids to the registration code where we
can fail at the time an initiator tries to register a path without an
isid. In its current place in __core_scsi3_locate_pr_reg, it is too
late because it can be registered and be reported in PR in commands and
it is stuck in this state because we cannot unregister it.

Note.
I am including in this patchset, because the 9th patch is built on top.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/target/target_core_pr.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 5e93169..cd2d32f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1176,15 +1176,6 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 		 * ISID, then we have found a match.
 		 */
 		if (!pr_reg->isid_present_at_reg) {
-			/*
-			 * Determine if this SCSI device server requires that
-			 * SCSI Intiatior TransportID w/ ISIDs is enforced
-			 * for fabric modules (iSCSI) requiring them.
-			 */
-			if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
-				if (dev->dev_attrib.enforce_pr_isids)
-					continue;
-			}
 			atomic_inc_mb(&pr_reg->pr_res_holders);
 			spin_unlock(&pr_tmpl->registration_lock);
 			return pr_reg;
@@ -1591,10 +1582,25 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 				continue;
 			dest_rtpi = tmp_lun->lun_rtpi;
 
+			iport_ptr = NULL;
 			i_str = target_parse_pr_out_transport_id(tmp_tpg,
 					ptr, &tid_len, &iport_ptr);
 			if (!i_str)
 				continue;
+			/*
+			 * Determine if this SCSI device server requires that
+			 * SCSI Intiatior TransportID w/ ISIDs is enforced
+			 * for fabric modules (iSCSI) requiring them.
+			 */
+			if (tpg->se_tpg_tfo->sess_get_initiator_sid &&
+                            dev->dev_attrib.enforce_pr_isids &&
+			    !iport_ptr) {
+				pr_warn("SPC-PR: enforce_pr_isids is set but a isid has not been sent in the SPEC_I_PT data for %s.",
+					i_str);
+				ret = TCM_INVALID_PARAMETER_LIST;
+				spin_unlock(&dev->se_port_lock);
+				goto out_unmap;
+			}
 
 			atomic_inc_mb(&tmp_tpg->tpg_pr_ref_count);
 			spin_unlock(&dev->se_port_lock);
-- 
1.8.3.1

