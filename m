Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE04C74A5B
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Mar 2023 01:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjCSB4q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Mar 2023 21:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCSB4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Mar 2023 21:56:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E54223114;
        Sat, 18 Mar 2023 18:56:36 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32IMNonB030348;
        Sun, 19 Mar 2023 01:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=1Jwyqw/NnrJyiljQssCnAl9/TwXkefH7z/8hrT6NHLc=;
 b=ST2cxYc0tFGTzqL6JQAtlNXTabebtUr5O8oOiD6WiwjuMv2f/EbN/FVIYzeOXupuHG3a
 BgUg41Wd23aSCxllYerRM4JcKdzZJqYOj1yaK+t+MylQ0MRR0LEGHe5Z2LLFCuyulWL8
 Fx7YKAutzz8+STEevJA7wy8BkddHtGLNRzqUWRNlqoO4EKTdwEgaXIVGSurdyRRLBaMd
 xc+bqaX67n1spcwnM6cksG9oxCowB/1rqCeUX8gGf2PDZltWhj27ZgNqIDZHS3YeZgxb
 uAXN99YIC52qAB1uH6k3r8oSlK2YzZSir0q5L8TBIXOehkN9IvtO9k9+poWyw06lfxYQ qQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd5uu911n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32INoVYR030404;
        Sun, 19 Mar 2023 01:56:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3raaudq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32J1uO5O014254;
        Sun, 19 Mar 2023 01:56:32 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-118-173.vpn.oracle.com [10.154.118.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pd3raauaw-6;
        Sun, 19 Mar 2023 01:56:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 5/9] scsi: target: iscsit: stop/wait on cmds during conn close
Date:   Sat, 18 Mar 2023 20:56:16 -0500
Message-Id: <20230319015620.96006-6-michael.christie@oracle.com>
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
X-Proofpoint-GUID: 27_k6FiNiAuzLHz-AUuDNWdaUAF4f5R-
X-Proofpoint-ORIG-GUID: 27_k6FiNiAuzLHz-AUuDNWdaUAF4f5R-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug added in:

commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
race")

If we have multiple sessions to the same se_device we can hit a race where
a LUN_RESET on one session cleans up the se_cmds from under another
session which is being closed. This results in the closing session freeing
its conn/session structs while they are still in use.

The bug is:

1. Session1 has IO se_cmd1.
2. Session2 can also have se_cmds for IO and optionally TMRs for ABORTS
but then gets a LUN_RESET.
3. The LUN_RESET on session2 sees the se_cmds on session1 and during
the drain stages marks them all with CMD_T_ABORTED.
4. session1 is now closed so iscsit_release_commands_from_conn only sees
se_cmds with the CMD_T_ABORTED bit set and returns immediately even
though we have outstanding commands.
5. session1's connection and session are freed.
6. The backend request for se_cmd1 completes and it accesses the freed
connection/session.

This hooks the iscsit layer into the cmd counter code, so we can wait for
all outstanding se_cmds before freeing the connection.

Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 11115c207844..83b007141229 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4245,6 +4245,16 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		iscsit_free_cmd(cmd, true);
 
 	}
+
+	/*
+	 * Wait on commands that were cleaned up via the aborted_task path.
+	 * LLDs that implement iscsit_wait_conn will already have waited for
+	 * commands.
+	 */
+	if (!conn->conn_transport->iscsit_wait_conn) {
+		target_stop_cmd_counter(conn->cmd_cnt);
+		target_wait_for_cmds(conn->cmd_cnt);
+	}
 }
 
 static void iscsit_stop_timers_for_cmds(
-- 
2.25.1

