Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25445C77B60
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Mar 2023 01:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjCSB4u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Mar 2023 21:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjCSB4p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Mar 2023 21:56:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE3F23136;
        Sat, 18 Mar 2023 18:56:43 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32IN53he031401;
        Sun, 19 Mar 2023 01:56:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=bQj9D5/Blk0oa9b/s1jwxU4dcx2AJDPRw4owWknMFGw=;
 b=hFH+gBe1rxJMfMXionoBcj9xl8y7wt1L1+O3ACFrT5SPXyKmHweFTcRr6vfGpMwf1P7y
 IXRtsYN1V6kvBDlFD0WrI5U0++XWs/iAtD3OTIFNGGOfurTqZthCJWgVdwcAAFKf3zUY
 DBmW9X53p/CShr20wylW3Yy2oUFISPUFNixcjqr5MVEpo6atOJEg4WR+6ZMJvyR6jWRE
 rN/DtgQV6qI3y2kpGw7zKyoQgMHsalaoxP2hPkcpo4as6+yVJ20LGWAuF5MQ7hw9/IjF
 0NlWFiE7DloCJR3YsGN+yO1XWxQ21pXa8N3qv+YtB07uBfWuhduSq4zC60EltO5aJ1bv NA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd47th5ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32INUPOg030373;
        Sun, 19 Mar 2023 01:56:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3raaufh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:39 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32J1uO5W014254;
        Sun, 19 Mar 2023 01:56:39 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-118-173.vpn.oracle.com [10.154.118.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pd3raauaw-10;
        Sun, 19 Mar 2023 01:56:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 9/9] scsi: target: iscsi: handle abort for WRITE_PENDING cmds
Date:   Sat, 18 Mar 2023 20:56:20 -0500
Message-Id: <20230319015620.96006-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319015620.96006-1-michael.christie@oracle.com>
References: <20230319015620.96006-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-18_16,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303190014
X-Proofpoint-GUID: cwH0ZqNDDnPr3b2jz5__Ru1DQ73vfTsv
X-Proofpoint-ORIG-GUID: cwH0ZqNDDnPr3b2jz5__Ru1DQ73vfTsv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

Sometimes an initiator does not send data for WRITE commands and tries
to abort it. The abort hangs waiting for frontend driver completion.
iSCSI driver waits for for data and that timeout eventually initiates
connection reinstatment. The connection closing releases the commands in
the connection, but those aborted commands still did not handle the
abort and did not decrease a command ref counter. Because of that the
connection reinstatement hangs indefinitely and prevents re-login for
that initiator.

This patch adds a handling in TCM of the abort for the WRITE_PENDING
commands at connection closing moment to make it possible to release
them.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
[Rebase and expand comment]
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 07e196b44b91..834cce50f9b0 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -26,6 +26,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 
+#include <target/target_core_backend.h>
 #include <target/iscsi/iscsi_target_core.h>
 #include "iscsi_target_parameters.h"
 #include "iscsi_target_seq_pdu_list.h"
@@ -4236,6 +4237,16 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		} else {
 			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 		}
+
+		if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING) {
+			/*
+			 * We never submitted the cmd to LIO core, so we have
+			 * to tell LIO to perform the completion process.
+			 */
+			spin_unlock_irq(&se_cmd->t_state_lock);
+			target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
+			continue;
+		}
 		spin_unlock_irq(&se_cmd->t_state_lock);
 	}
 	spin_unlock_bh(&conn->cmd_lock);
-- 
2.25.1

