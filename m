Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D60C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CC006113D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbhD0IcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:32:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:49410 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235166AbhD0Ib5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:31:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 60DACB0D0;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/40] scsi: add get_{status,host}_byte() accessor function
Date:   Tue, 27 Apr 2021 10:30:22 +0200
Message-Id: <20210427083046.31620-17-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427083046.31620-1-hare@suse.de>
References: <20210427083046.31620-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add accessor functions for the host and status byte.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/scsi/scsi_cmnd.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a1eb7732aa1b..2c7b4102aa14 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -316,6 +316,11 @@ static inline void set_status_byte(struct scsi_cmnd *cmd, char status)
 	cmd->result = (cmd->result & 0xffffff00) | status;
 }
 
+static inline u8 get_status_byte(struct scsi_cmnd *cmd)
+{
+	return cmd->result & 0xff;
+}
+
 static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
 {
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
@@ -326,6 +331,11 @@ static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
 	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
 }
 
+static inline u8 get_host_byte(struct scsi_cmnd *cmd)
+{
+	return (cmd->result >> 16) & 0xff;
+}
+
 
 static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 {
-- 
2.29.2

