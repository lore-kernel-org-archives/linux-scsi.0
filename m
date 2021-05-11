Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF4AC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 18:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2D96186A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 18:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhEKSOT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 14:14:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232064AbhEKSON (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 May 2021 14:14:13 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BI4FPR139277;
        Tue, 11 May 2021 14:12:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=UUpR+flHR1NiwyDEVdMngnR0L0eKBMrnWMzL259/hEQ=;
 b=ASezXFzbtJq+DeJ3ogOHLK437ENcuZfMl3wyGUS+0zsMe5dfqXSAijvIIcBI9XewiEgq
 chzQf4HV6ON6kosRGeB6eZ6OrFyQBRiLSc62DWhIDLW98OOq8NisWvrQEvWI3Kv4APGX
 mLXep0exdBq01smCrwRnux4zz/7KljhBViovnlCy9Zp+qg66ic6J/u0gw7TfOj4yRzrC
 9aEQkzdt8cmIjTgyJO7sqfeMDhkz0xdvyVHL1j78VvOsDWvqyxoYt2cMvr2i7yrAAzsF
 KS7gAPj3e2uJKKiFDB4lz3EHpA0iBLFsy8vvXCPnYZs/GQfKjfGAOK5nXQ40objLUQjb 3A== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38fxud091v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 14:12:51 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BI883A018534;
        Tue, 11 May 2021 18:12:50 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 38dj99nmt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 18:12:50 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BICnPR24576262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 18:12:50 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA95012407F;
        Tue, 11 May 2021 18:12:47 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19F56124069;
        Tue, 11 May 2021 18:12:47 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.211.88.15])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 18:12:46 +0000 (GMT)
From:   Brian King <brking@linux.vnet.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        tyreld@linux.ibm.com, Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ibmvfc: Handle move login failure
Date:   Tue, 11 May 2021 13:12:18 -0500
Message-Id: <1620756740-7045-2-git-send-email-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620756740-7045-1-git-send-email-brking@linux.vnet.ibm.com>
References: <1620756740-7045-1-git-send-email-brking@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9CK9Ny6CJq_H97tIWBXWCCfXqBMJlmMC
X-Proofpoint-ORIG-GUID: 9CK9Ny6CJq_H97tIWBXWCCfXqBMJlmMC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When service is being performed on an SVC with NPIV enabled, the WWPN of
the canister / node being serviced fails over to the another canister /
node. This looks to the ibmvfc driver as a WWPN moving from one SCSI ID
to another. The driver will first attempt to do an implicit logout of
the old SCSI ID. If this works, we simply delete the rport at the old
location and add an rport at the new location and the FC transport class
handles everything. However, if there is I/O outstanding, this implicit
logout will fail, in which case we will send a "move login" request to
the VIOS. This will cancel any outstanding I/O to that port, logout the
port, and PLOGI the new port. Recently we've encountered a scenario
where the move login fails. This was resulting in an attempted plogi
to the new scsi id, without the old scsi id getting logged out, which
is a VIOS protocol violation. To solve this, we want to keep tracking
the old scsi id as the current scsi id. That way, once
terminate_rport_io cancels the outstanding i/o, it will send us back
through to do an implicit logout of the old scsi id, rather than the
new scsi id, and then we can plogi the new scsi id.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 16 ++++++++--------
 drivers/scsi/ibmvscsi/ibmvfc.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 6540d48..4ac5bff 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4299,9 +4299,10 @@ static void ibmvfc_tgt_move_login_done(struct ibmvfc_event *evt)
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 	switch (status) {
 	case IBMVFC_MAD_SUCCESS:
-		tgt_dbg(tgt, "Move Login succeeded for old scsi_id: %llX\n", tgt->old_scsi_id);
+		tgt_dbg(tgt, "Move Login succeeded for new scsi_id: %llX\n", tgt->new_scsi_id);
 		tgt->ids.node_name = wwn_to_u64(rsp->service_parms.node_name);
 		tgt->ids.port_name = wwn_to_u64(rsp->service_parms.port_name);
+		tgt->scsi_id = tgt->new_scsi_id;
 		tgt->ids.port_id = tgt->scsi_id;
 		memcpy(&tgt->service_parms, &rsp->service_parms,
 		       sizeof(tgt->service_parms));
@@ -4319,8 +4320,8 @@ static void ibmvfc_tgt_move_login_done(struct ibmvfc_event *evt)
 		level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_move_login);
 
 		tgt_log(tgt, level,
-			"Move Login failed: old scsi_id: %llX, flags:%x, vios_flags:%x, rc=0x%02X\n",
-			tgt->old_scsi_id, be32_to_cpu(rsp->flags), be16_to_cpu(rsp->vios_flags),
+			"Move Login failed: new scsi_id: %llX, flags:%x, vios_flags:%x, rc=0x%02X\n",
+			tgt->new_scsi_id, be32_to_cpu(rsp->flags), be16_to_cpu(rsp->vios_flags),
 			status);
 		break;
 	}
@@ -4357,8 +4358,8 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *tgt)
 	move->common.opcode = cpu_to_be32(IBMVFC_MOVE_LOGIN);
 	move->common.length = cpu_to_be16(sizeof(*move));
 
-	move->old_scsi_id = cpu_to_be64(tgt->old_scsi_id);
-	move->new_scsi_id = cpu_to_be64(tgt->scsi_id);
+	move->old_scsi_id = cpu_to_be64(tgt->scsi_id);
+	move->new_scsi_id = cpu_to_be64(tgt->new_scsi_id);
 	move->wwpn = cpu_to_be64(tgt->wwpn);
 	move->node_name = cpu_to_be64(tgt->ids.node_name);
 
@@ -4367,7 +4368,7 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *tgt)
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
 	} else
-		tgt_dbg(tgt, "Sent Move Login for old scsi_id: %llX\n", tgt->old_scsi_id);
+		tgt_dbg(tgt, "Sent Move Login for new scsi_id: %llX\n", tgt->new_scsi_id);
 }
 
 /**
@@ -4737,8 +4738,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 			 * normal ibmvfc_set_tgt_action to set this, as we
 			 * don't normally want to allow this state change.
 			 */
-			wtgt->old_scsi_id = wtgt->scsi_id;
-			wtgt->scsi_id = scsi_id;
+			wtgt->new_scsi_id = scsi_id;
 			wtgt->action = IBMVFC_TGT_ACTION_INIT;
 			ibmvfc_init_tgt(wtgt, ibmvfc_tgt_move_login);
 			goto unlock_out;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 19dcec3..4601bd2 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -718,7 +718,7 @@ struct ibmvfc_target {
 	struct ibmvfc_host *vhost;
 	u64 scsi_id;
 	u64 wwpn;
-	u64 old_scsi_id;
+	u64 new_scsi_id;
 	struct fc_rport *rport;
 	int target_id;
 	enum ibmvfc_target_action action;
-- 
1.8.3.1

