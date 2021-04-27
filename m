Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D9EC43470
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06361600EF
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhD0IcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:32:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:49422 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235182AbhD0IcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:32:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7DCBFB123;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/40] scsi: add scsi_msg_to_host_byte()
Date:   Tue, 27 Apr 2021 10:30:23 +0200
Message-Id: <20210427083046.31620-18-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427083046.31620-1-hare@suse.de>
References: <20210427083046.31620-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helper to convert message byte into a host byte code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 2c7b4102aa14..69055c2044ff 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -336,6 +336,32 @@ static inline u8 get_host_byte(struct scsi_cmnd *cmd)
 	return (cmd->result >> 16) & 0xff;
 }
 
+/**
+ * scsi_msg_to_host_byte() - translate message byte
+ *
+ * Translate the SCSI parallel message byte to a matching
+ * host byte setting. A message of COMMAND_COMPLETE indicates
+ * a successful command execution, any other message indicate
+ * an error. As the messages themselves only have a meaning
+ * for the SCSI parallel protocol this function translates
+ * them into a matching host byte value for SCSI EH.
+ */
+static inline void scsi_msg_to_host_byte(struct scsi_cmnd *cmd, u8 msg)
+{
+	switch (msg) {
+	case COMMAND_COMPLETE:
+		break;
+	case ABORT_TASK_SET:
+		set_host_byte(cmd, DID_ABORT);
+		break;
+	case TARGET_RESET:
+		set_host_byte(cmd, DID_RESET);
+		break;
+	default:
+		set_host_byte(cmd, DID_ERROR);
+		break;
+	}
+}
 
 static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 {
-- 
2.29.2

