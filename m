Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCB3C54E94
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 08:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbjAYIdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 03:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbjAYIdl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 03:33:41 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C7F518F3;
        Wed, 25 Jan 2023 00:33:29 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 1F6B6341A4A;
        Wed, 25 Jan 2023 11:33:28 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=afEvbwvh6JxUPswUcw
        1YekAU8WYg0FIevaIl+Oezdlo=; b=tnzVUaxEKMGrkvcy7pkysUvUA7bsRVzYcy
        Ovh5wGeWRej31xqhCo21eTvPjHexRSHoMxejz97AUIEkjqYvQAVD3RDQeXoavXbc
        yv5jRTHzHyq3mC06rYQGXVlqcJ02UscGZHx5a7rDSOjFge75e8HdN6FxTzdSRyKB
        BE1JxFZJ8=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 12569341A0E;
        Wed, 25 Jan 2023 11:33:28 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 25 Jan 2023 11:33:26 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Forza <forza@tnonline.net>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 1/2] target: iscs: reject cmd in closed session
Date:   Wed, 25 Jan 2023 11:33:08 +0300
Message-ID: <20230125083309.24678-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230125083309.24678-1-d.bogdanov@yadro.com>
References: <20230125083309.24678-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not handle incoming commands if the session is already closed.

That patch fixes the following stacktrace:

 Decremented iSCSI connection count to 0 from node: iqn.1996-04.com.local:3
 TARGET_CORE[iSCSI]: Deregistered fabric_sess
 Moving to TARG_SESS_STATE_FREE.
 Released iSCSI session from node: iqn.1996-04.com.local:3
 Decremented number of active iSCSI Sessions on iSCSI TPG: 0 to 1
 rx_loop: 48, total_rx: 48, data: 48
 Got SCSI Command, ITT: 0x2000005d, CmdSN: 0x4a020000, ExpXferLen: 0, Length: 0, CID: 0
BUG: Kernel NULL pointer dereference on read at 0x00000000
  Faulting instruction address: 0xc008000000a9b574
  Oops: Kernel access of bad area, sig: 11 [#1]
  NIP [c008000000a9b574] transport_lookup_cmd_lun+0x37c/0x470 [target_core_mod]
  LR [c008000001017318] iscsit_setup_scsi_cmd+0x520/0x780 [iscsi_target_mod]
Call Trace:
 [c000000059e4fae0] [c000000059e4fb70] 0xc000000059e4fb70 (unreliable)
 [c000000059e4fb70] [c008000001017318] iscsit_setup_scsi_cmd+0x520/0x780 [iscsi_target_mod]
 [c000000059e4fc30] [c00800000101c448] iscsit_get_rx_pdu+0x720/0x11d0 [iscsi_target_mod]
 [c000000059e4fd60] [c00800000101ebc8] iscsi_target_rx_thread+0xb0/0x190 [iscsi_target_mod]
 [c000000059e4fdb0] [c00000000018c50c] kthread+0x19c/0x1b0

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c | 8 ++++++--
 include/scsi/iscsi_proto.h          | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index baf4da7bb3b4..f6008675dd3f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1199,7 +1199,9 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
 		conn->cid);
 
-	target_get_sess_cmd(&cmd->se_cmd, true);
+	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
+		return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
 
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
 	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, cdb,
@@ -2057,7 +2059,9 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
 			  scsilun_to_int(&hdr->lun));
 
-	target_get_sess_cmd(&cmd->se_cmd, true);
+	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
+		return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
 
 	/*
 	 * TASK_REASSIGN for ERL=2 / connection stays inside of
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 7b192d88f186..e3c016b013de 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -627,6 +627,7 @@ struct iscsi_reject {
 #define ISCSI_REASON_BOOKMARK_INVALID	9
 #define ISCSI_REASON_BOOKMARK_NO_RESOURCES	10
 #define ISCSI_REASON_NEGOTIATION_RESET	11
+#define ISCSI_REASON_WAITING_FOR_LOGOUT	12
 
 /* Max. number of Key=Value pairs in a text message */
 #define MAX_KEY_VALUE_PAIRS	8192
-- 
2.25.1


