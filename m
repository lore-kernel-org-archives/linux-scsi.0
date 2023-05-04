Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E7FC7EE21
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 20:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjEDUEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 16:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjEDUDt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 16:03:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12D714356;
        Thu,  4 May 2023 12:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C76816386D;
        Thu,  4 May 2023 19:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CB0C4339B;
        Thu,  4 May 2023 19:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683229865;
        bh=tVDLBzTuNR80jjWkLEa9uMaYZxaGyJ0owWcfXgWWNCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCQINibpkZaPrgRX2eGa/2HLe7kaXcwJ/jh2CqeZnK6fY+2ugUjbxlAS54E+F7ntR
         Dr2myEkXJ78t8XoeEI20Kmr3wGeVzSFKzwuIM1TXc5EUeinsXW6A7bOsweIru5Og1l
         0U0xypEDEGkQCh1P4TQBemxHFSIlW8S9aKrnZG2TNFYyIj5RraTZXUPW8SdYw6IJAS
         gI6felCM5JcynXoMCA+cSKWkTtTzuA4VAYDY7BRFt5BU/BxxjxbLP5vre6Cx8jr4yk
         TPQ7qCBjQ1YB5oWLcABR5EFzBKSCDFFXs6D7rune87VUMX/J4r+XwPx/6SfxlCz28f
         T4jlebjVyCmpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bogdanov <d.bogdanov@yadro.com>, Forza <forza@tnonline.net>,
        Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, mgurtovoy@nvidia.com,
        justinstitt@google.com, mingzhe.zou@easystack.cn,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/18] scsi: target: iscsit: Free cmds before session free
Date:   Thu,  4 May 2023 15:50:29 -0400
Message-Id: <20230504195042.3808716-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504195042.3808716-1-sashal@kernel.org>
References: <20230504195042.3808716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit d8990b5a4d065f38f35d69bcd627ec5a7f8330ca ]

Commands from recovery entries are freed after session has been closed.
That leads to use-after-free at command free or NPE with such call trace:

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
Link: https://lore.kernel.org/r/20230319015620.96006-7-michael.christie@oracle.com
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 3403667a9592f..5543555071c93 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4383,6 +4383,9 @@ int iscsit_close_session(struct iscsi_session *sess)
 	iscsit_stop_time2retain_timer(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
 
+	if (sess->sess_ops->ErrorRecoveryLevel == 2)
+		iscsit_free_connection_recovery_entries(sess);
+
 	/*
 	 * transport_deregister_session_configfs() will clear the
 	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process context
@@ -4411,9 +4414,6 @@ int iscsit_close_session(struct iscsi_session *sess)
 
 	transport_deregister_session(sess->se_sess);
 
-	if (sess->sess_ops->ErrorRecoveryLevel == 2)
-		iscsit_free_connection_recovery_entries(sess);
-
 	iscsit_free_all_ooo_cmdsns(sess);
 
 	spin_lock_bh(&se_tpg->session_lock);
-- 
2.39.2

