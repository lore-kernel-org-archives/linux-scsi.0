Return-Path: <SRS0=rQSi=EH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38526C4741F
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 18:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E12A422254
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 18:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hlkPYgMI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgKAS7w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Nov 2020 13:59:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46384 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbgKAS7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2020 13:59:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1Iukvs153273;
        Sun, 1 Nov 2020 18:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=3KFFaojRxbva9FVrBREDvHn2V4tGAy/+wiJTiiU+t38=;
 b=hlkPYgMIUbQk3yORW8FPSXjv/TgV0JQECEGp6H9R5ADYbY+T5Cyvmu4ZK7oLRAiJA97N
 tJndQtWKvSIoUKNLde5ft4FjjFvllV+357E7bAEO4yu0tuLxHOz8FOTGJEIydoQYl8lC
 LxXZLuqRFQK64BlV+O/iIk47lmGrz9T4PRhwf2EExVz9VGgE4AAP5RcygD2zKxWPLFRi
 0KT6Ur5FxlNazk3F5HmAbcu/sKatNtbsjFIGVSG/4EKbzZfIqibDfJEu59OMH4S5gjnC
 /fcpc+tX3wXBJI0ryjH6+5/qsG3FMfx/jfsPddz+MqTz9OoIXe/CDHgQVWVK53P1df70 fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34hhvc1arh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 01 Nov 2020 18:59:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1IsiYk125932;
        Sun, 1 Nov 2020 18:59:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34hvrmef5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Nov 2020 18:59:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A1Ixjaf009061;
        Sun, 1 Nov 2020 18:59:45 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Nov 2020 10:59:44 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, njavali@marvell.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 4/8] target: remove TARGET_SCF_LOOKUP_LUN_FROM_TAG
Date:   Sun,  1 Nov 2020 12:59:30 -0600
Message-Id: <1604257174-4524-5-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011010154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011010154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TARGET_SCF_LOOKUP_LUN_FROM_TAG is no longer used so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/target/target_core_transport.c | 33 ---------------------------------
 include/target/target_core_base.h      |  1 -
 2 files changed, 34 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d47619a..465b6583 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1772,29 +1772,6 @@ static void target_complete_tmr_failure(struct work_struct *work)
 	transport_cmd_check_stop_to_fabric(se_cmd);
 }
 
-static bool target_lookup_lun_from_tag(struct se_session *se_sess, u64 tag,
-				       u64 *unpacked_lun)
-{
-	struct se_cmd *se_cmd;
-	unsigned long flags;
-	bool ret = false;
-
-	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
-		if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-			continue;
-
-		if (se_cmd->tag == tag) {
-			*unpacked_lun = se_cmd->orig_fe_lun;
-			ret = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-
-	return ret;
-}
-
 /**
  * target_submit_tmr - lookup unpacked lun and submit uninitialized se_cmd
  *                     for TMR CDBs
@@ -1842,16 +1819,6 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		core_tmr_release_req(se_cmd->se_tmr_req);
 		return ret;
 	}
-	/*
-	 * If this is ABORT_TASK with no explicit fabric provided LUN,
-	 * go ahead and search active session tags for a match to figure
-	 * out unpacked_lun for the original se_cmd.
-	 */
-	if (tm_type == TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
-		if (!target_lookup_lun_from_tag(se_sess, tag,
-						&se_cmd->orig_fe_lun))
-			goto failure;
-	}
 
 	ret = transport_lookup_tmr_lun(se_cmd);
 	if (ret)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 549947d..b3c9946 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -195,7 +195,6 @@ enum target_sc_flags_table {
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
 	TARGET_SCF_USE_CPUID		= 0x08,
-	TARGET_SCF_LOOKUP_LUN_FROM_TAG	= 0x10,
 };
 
 /* fabric independent task management function values */
-- 
1.8.3.1

