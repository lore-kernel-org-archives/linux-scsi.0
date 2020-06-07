Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FD5C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CB7E2074B
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BwehrBtk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgFGUiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:38:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgFGUiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:38:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KcImt139768;
        Sun, 7 Jun 2020 20:38:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=XfWhIYFwEimVuj47/9jv8D1/OxnCuX9y0dJxP64x0b4=;
 b=BwehrBtkJdrP2Sq0aFlP8UWD/0oK+amM23PrVlUtD6lfaRrZgZGkEDgq37jLsq1eaQ1U
 +VJd1n+cMKV0EmMP13/h6xDCPVukaWRet4B7ghthT/LPbasYxYm4Bj1toHqAC4PsjoRU
 OFPhiuMJrlNiMPP8ISNpY0l+QGmaEqF+9d8XCmPC3BmA4r9XWGCu1SNCK+Q87PjmoDjx
 6dcWIGwcfqIVIV4/gfSAbTGvtF/q69iGUo0rr99iSmLICmJMz+kTOQk3Y/D4/OsJtvSd
 zjQ2CCOCp5+qd9W5mHQm0n+TyzXviJIJjoVnIrfFKICqr2HtrTT0HHdXVTvrln1Oex91 iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31g3smkxhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:38:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KSHFN020325;
        Sun, 7 Jun 2020 20:36:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31gn205ncn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:15 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057KaEBI003652;
        Sun, 7 Jun 2020 20:36:14 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:14 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 09/17] target: drop sess_get_initiator_sid from PR code
Date:   Sun,  7 Jun 2020 15:35:56 -0500
Message-Id: <1591562164-9766-10-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006070163
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the transport id session id in the PR related code.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_pr.c        | 23 ++++-------------------
 drivers/target/target_core_transport.c | 11 ++++-------
 2 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index cd2d32f..fbe3638 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1204,17 +1204,7 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(
 	struct se_node_acl *nacl,
 	struct se_session *sess)
 {
-	struct se_portal_group *tpg = nacl->se_tpg;
-	unsigned char buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
-
-	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
-		memset(&buf[0], 0, PR_REG_ISID_LEN);
-		tpg->se_tpg_tfo->sess_get_initiator_sid(sess, &buf[0],
-					PR_REG_ISID_LEN);
-		isid_ptr = &buf[0];
-	}
-
-	return __core_scsi3_locate_pr_reg(dev, nacl, isid_ptr);
+	return __core_scsi3_locate_pr_reg(dev, nacl, sess->tpt_id->session_id);
 }
 
 static void core_scsi3_put_pr_reg(struct t10_pr_registration *pr_reg)
@@ -1592,7 +1582,7 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 			 * SCSI Intiatior TransportID w/ ISIDs is enforced
 			 * for fabric modules (iSCSI) requiring them.
 			 */
-			if (tpg->se_tpg_tfo->sess_get_initiator_sid &&
+			if (se_sess->tpt_id->session_id &&
                             dev->dev_attrib.enforce_pr_isids &&
 			    !iport_ptr) {
 				pr_warn("SPC-PR: enforce_pr_isids is set but a isid has not been sent in the SPEC_I_PT data for %s.",
@@ -2057,7 +2047,7 @@ static sense_reason_t core_scsi3_update_and_write_aptpl(struct se_device *dev, b
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_p, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
+	unsigned char *isid_ptr = NULL;
 	sense_reason_t ret = TCM_NO_SENSE;
 	int pr_holder = 0, type;
 
@@ -2067,12 +2057,7 @@ static sense_reason_t core_scsi3_update_and_write_aptpl(struct se_device *dev, b
 	}
 	se_tpg = se_sess->se_tpg;
 
-	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
-		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
-		se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, &isid_buf[0],
-				PR_REG_ISID_LEN);
-		isid_ptr = &isid_buf[0];
-	}
+	isid_ptr = se_sess->tpt_id->session_id;
 	/*
 	 * Follow logic from spc4r17 Section 5.7.7, Register Behaviors Table 47
 	 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c1b0d15..5d6d736 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -343,7 +343,7 @@ void __transport_register_session(
 	void *fabric_sess_ptr)
 {
 	const struct target_core_fabric_ops *tfo = se_tpg->se_tpg_tfo;
-	unsigned char buf[PR_REG_ISID_LEN];
+	unsigned char *sid;
 	unsigned long flags;
 
 	se_sess->se_tpg = se_tpg;
@@ -374,12 +374,9 @@ void __transport_register_session(
 		 * If the fabric module supports an ISID based TransportID,
 		 * save this value in binary from the fabric I_T Nexus now.
 		 */
-		if (se_tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
-			memset(&buf[0], 0, PR_REG_ISID_LEN);
-			se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess,
-					&buf[0], PR_REG_ISID_LEN);
-			se_sess->sess_bin_isid = get_unaligned_be64(&buf[0]);
-		}
+		sid = se_sess->tpt_id->session_id;
+		if (sid)
+			se_sess->sess_bin_isid = get_unaligned_be64(sid);
 
 		spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
 		/*
-- 
1.8.3.1

