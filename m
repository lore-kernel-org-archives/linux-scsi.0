From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 10/37] target: don't opencode transport_release_cmd in transport_release_fe_cmd
Date: Fri, 14 Oct 2011 00:41:42 +0000
Message-ID: <1318552929-13341-11-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33398 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1JNAnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 20:43:50 -0400
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f0f21bb..0c1d004 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3794,8 +3794,7 @@ static void transport_release_fe_cmd(struct se_cmd *cmd)
 	transport_release_tasks(cmd);
 free_pages:
 	transport_free_pages(cmd);
-	transport_free_se_cmd(cmd);
-	cmd->se_tfo->release_cmd(cmd);
+	transport_release_cmd(cmd);
 }
 
 static int
-- 
1.5.6.5

