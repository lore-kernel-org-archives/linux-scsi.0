Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FC5C74A5B
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Mar 2023 01:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCSB5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Mar 2023 21:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjCSB4x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Mar 2023 21:56:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D93A23136;
        Sat, 18 Mar 2023 18:56:47 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32J18Q7v002689;
        Sun, 19 Mar 2023 01:56:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=ISUq+MN63A7B6PSmlAC3g/PRg+2OJeKDRhGTqTC8+qo=;
 b=SUIC0WfHgZUmX0zggyzCEmrZqA2N/zIee3Xdjat7WcQkkvMlE8GGdedMScewtfc8I3bH
 fLwvaYS1SJ/J04B4n2/BN2TSa1ow8s8wStkvbi7LCoU1JJMAzvM2PwF9TZ/1IO8hAc9Q
 yWOyEoAuC4Tm2de851SVssuZkF72UdQ3ljfLEMZMqpQf9dOryWfgf0Gf5juPSg1/iAZP
 UjWLfrObyc9oiPcUuBkIe7WQh9UGShxop5nbJE2y25gbgG2neHCLRsYFOPlV1olsAjSb
 Ad9ufNJFwjNucucdcnrNPop2Imth+Ko1TS52TcAfZObPCm35qUa7OD101PHugcG4MPMt kw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd56as27b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32IN3uhx031062;
        Sun, 19 Mar 2023 01:56:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3raaued-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32J1uO5Q014254;
        Sun, 19 Mar 2023 01:56:34 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-118-173.vpn.oracle.com [10.154.118.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pd3raauaw-7;
        Sun, 19 Mar 2023 01:56:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Forza <forza@tnonline.net>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 6/9] scsi: target: iscsit: free cmds before session free
Date:   Sat, 18 Mar 2023 20:56:17 -0500
Message-Id: <20230319015620.96006-7-michael.christie@oracle.com>
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
X-Proofpoint-ORIG-GUID: vMX9Aygi-PADMV5VgBL3LdyR0cd3ppbB
X-Proofpoint-GUID: vMX9Aygi-PADMV5VgBL3LdyR0cd3ppbB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

Commands from recovery entries are freed after its session has been
closed. That leads to use-after-free at command free or NPE with such
call trace:

Time2Retain timer expired for SID: 1, cleaning up iSCSI session.
BUG: kernel NULL pointer dereference, address: 0000000000000140
RIP: 0010:sbitmap_queue_clear+0x3a/0xa0
Call Trace:
 target_release_cmd_kref+0xd1/0x1f0 [target_core_mod]
 transport_generic_free_cmd+0xd1/0x180 [target_core_mod]
 iscsit_free_cmd+0x53/0xd0 [iscsi_target_mod]
 iscsit_free_connection_recovery_entries+0x29d/0x320 [iscsi_target_mod]
 iscsit_close_session+0x13a/0x140 [iscsi_target_mod]
 iscsit_check_post_dataout+0x440/0x440 [iscsi_target_mod]
 call_timer_fn+0x24/0x140

Move cleanup of recovery enrties to before session freeing.

Reported-by: Forza <forza@tnonline.net>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 83b007141229..26634dbea9b8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4529,6 +4529,9 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	iscsit_stop_time2retain_timer(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
 
+	if (sess->sess_ops->ErrorRecoveryLevel == 2)
+		iscsit_free_connection_recovery_entries(sess);
+
 	/*
 	 * transport_deregister_session_configfs() will clear the
 	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process context
@@ -4552,9 +4555,6 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 
 	transport_deregister_session(sess->se_sess);
 
-	if (sess->sess_ops->ErrorRecoveryLevel == 2)
-		iscsit_free_connection_recovery_entries(sess);
-
 	iscsit_free_all_ooo_cmdsns(sess);
 
 	spin_lock_bh(&se_tpg->session_lock);
-- 
2.25.1

