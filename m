Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07200C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 20:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbiGMUnI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 16:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiGMUnH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 16:43:07 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6303122E;
        Wed, 13 Jul 2022 13:43:06 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1ECD5412D2;
        Wed, 13 Jul 2022 20:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1657744984; x=
        1659559385; bh=A0KX4HnG0cWEY+wYlrm4+1H0bVSpVL+X+oShvjbc8cM=; b=J
        9x3R41HtDSWPE/r0MY359wvfYPbAVq8Q8rD5V2KkqAWUhPHn967AgCX+edQVXn4Y
        UlpdQ/ef/9R4rcXrv/6bB1YVBShJgXUpQRnwFiNPd7LFyNGhEAg4aW4fcKLdTYZW
        ZMRHrayRx9qqNfe1tcMcnHWL48BBF7PP28SMY6LYrM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2zdtEl7nazkd; Wed, 13 Jul 2022 23:43:04 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C44ED412C5;
        Wed, 13 Jul 2022 23:43:03 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 13 Jul 2022 23:43:03 +0300
Received: from NB-591.corp.yadro.com (10.178.114.42) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 13 Jul 2022 23:43:02 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Nick Couchman <nick.e.couchman@gmail.com>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH] target: iscsi: handle abort for WRITE_PENDING cmds
Date:   Wed, 13 Jul 2022 23:42:12 +0300
Message-ID: <20220713204212.7850-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
---
 drivers/target/iscsi/iscsi_target.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e368f038ff5c..27eca5e72f52 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -26,6 +26,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 
+#include <target/target_core_backend.h>
 #include <target/iscsi/iscsi_target_core.h>
 #include "iscsi_target_parameters.h"
 #include "iscsi_target_seq_pdu_list.h"
@@ -4171,7 +4172,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 
 		if (se_cmd->se_tfo != NULL) {
 			spin_lock_irq(&se_cmd->t_state_lock);
-			if (se_cmd->transport_state & CMD_T_ABORTED) {
+			if (se_cmd->t_state != TRANSPORT_WRITE_PENDING &&
+			    se_cmd->transport_state & CMD_T_ABORTED) {
 				/*
 				 * LIO's abort path owns the cleanup for this,
 				 * so put it back on the list and let
@@ -4191,8 +4193,13 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		list_del_init(&cmd->i_conn_node);
 
 		iscsit_increment_maxcmdsn(cmd, sess);
-		iscsit_free_cmd(cmd, true);
-
+		if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING &&
+		    cmd->se_cmd.transport_state & CMD_T_ABORTED) {
+			/* handle an abort in TCM */
+			target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
+		} else {
+			iscsit_free_cmd(cmd, true);
+		}
 	}
 }
 
-- 
2.25.1

