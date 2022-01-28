Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2635C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344189AbiA1WWD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:03 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:40812 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351429AbiA1WVd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:33 -0500
Received: by mail-pg1-f173.google.com with SMTP id t32so6443412pgm.7
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PC/g886owEQrP/MmJIaZ8y5vQuFCp5aIGEAPrxWJxSw=;
        b=I04GlJd1auqr7zQ+nRRbLwrWSVVVaBY2KMVwxmHdSsn0YKUgY3BxbxT+qIeoGRtoDo
         dTPQRKCFQ6XYfz3az1QarAJm/xgFM/mKxWhwYe0lW+6zu8FuwVqTLz+IR6SuRAFFVQbQ
         fcZISdemRpPlxMtYazYskghijAH2oFAvH8Qi8rS1yrTvbzzIgNQfQQq88w7jcJJnZzxU
         N5uIk64d9FaIeeCAdzhQBqw5P1FdjiaK6OOYnTbFZ2uYAEq7/Y/K8utKvI6qAOFIEomE
         U/+HQXKW1GqBQK4v1VlgayzsdOBPPAjra/TuSAWrMICGRs5NzfIuTejWYT1vBxlP2KKB
         rP3g==
X-Gm-Message-State: AOAM530sx8yz+519xfQ0asNT1JKfHJxuFeWqZhS8RXCzfMQN5LAKMWaD
        NncPif/O/mr3D6AedNQvLNI=
X-Google-Smtp-Source: ABdhPJyOQ7QPtC1A9ZpvTpDKXBV/qd3fpW9ywdfXtCELombNKk7zDaPkBVm9HTvuX+hEmNaaAT0AbQ==
X-Received: by 2002:a05:6a00:14c9:: with SMTP id w9mr10084291pfu.69.1643408493101;
        Fri, 28 Jan 2022 14:21:33 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:32 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 29/44] mesh: Move the SCSI pointer to private command data
Date:   Fri, 28 Jan 2022 14:18:54 -0800
Message-Id: <20220128221909.8141-30-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mesh.c | 20 +++++++++++++-------
 drivers/scsi/mesh.h | 11 +++++++++++
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index ca133e0a140a..de9ae36def42 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -586,10 +586,12 @@ static void mesh_done(struct mesh_state *ms, int start_next)
 	ms->current_req = NULL;
 	tp->current_req = NULL;
 	if (cmd) {
+		struct scsi_pointer *scsi_pointer = mesh_scsi_pointer(cmd);
+
 		set_host_byte(cmd, ms->stat);
-		set_status_byte(cmd, cmd->SCp.Status);
+		set_status_byte(cmd, scsi_pointer->Status);
 		if (ms->stat == DID_OK)
-			scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
+			scsi_msg_to_host_byte(cmd, scsi_pointer->Message);
 		if (DEBUG_TARGET(cmd)) {
 			printk(KERN_DEBUG "mesh_done: result = %x, data_ptr=%d, buflen=%d\n",
 			       cmd->result, ms->data_ptr, scsi_bufflen(cmd));
@@ -603,7 +605,7 @@ static void mesh_done(struct mesh_state *ms, int start_next)
 			}
 #endif
 		}
-		cmd->SCp.this_residual -= ms->data_ptr;
+		scsi_pointer->this_residual -= ms->data_ptr;
 		scsi_done(cmd);
 	}
 	if (start_next) {
@@ -1171,7 +1173,7 @@ static void handle_msgin(struct mesh_state *ms)
 	if (ms->n_msgin < msgin_length(ms))
 		goto reject;
 	if (cmd)
-		cmd->SCp.Message = code;
+		mesh_scsi_pointer(cmd)->Message = code;
 	switch (code) {
 	case COMMAND_COMPLETE:
 		break;
@@ -1262,7 +1264,7 @@ static void set_dma_cmds(struct mesh_state *ms, struct scsi_cmnd *cmd)
 	if (cmd) {
 		int nseg;
 
-		cmd->SCp.this_residual = scsi_bufflen(cmd);
+		mesh_scsi_pointer(cmd)->this_residual = scsi_bufflen(cmd);
 
 		nseg = scsi_dma_map(cmd);
 		BUG_ON(nseg < 0);
@@ -1592,10 +1594,13 @@ static void cmd_complete(struct mesh_state *ms)
 			break;
 		case statusing:
 			if (cmd) {
-				cmd->SCp.Status = mr->fifo;
+				struct scsi_pointer *scsi_pointer =
+					mesh_scsi_pointer(cmd);
+
+				scsi_pointer->Status = mr->fifo;
 				if (DEBUG_TARGET(cmd))
 					printk(KERN_DEBUG "mesh: status is %x\n",
-					       cmd->SCp.Status);
+					       scsi_pointer->Status);
 			}
 			ms->msgphase = msg_in;
 			break;
@@ -1837,6 +1842,7 @@ static struct scsi_host_template mesh_template = {
 	.sg_tablesize			= SG_ALL,
 	.cmd_per_lun			= 2,
 	.max_segment_size		= 65535,
+	.cmd_size			= sizeof(struct mesh_cmd_priv),
 };
 
 static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
diff --git a/drivers/scsi/mesh.h b/drivers/scsi/mesh.h
index ee53c05ace95..1afa8b37295b 100644
--- a/drivers/scsi/mesh.h
+++ b/drivers/scsi/mesh.h
@@ -8,6 +8,17 @@
 #ifndef _MESH_H
 #define _MESH_H
 
+struct mesh_cmd_priv {
+	struct scsi_pointer scsi_pointer;
+};
+
+static inline struct scsi_pointer *mesh_scsi_pointer(struct scsi_cmnd *cmd)
+{
+	struct mesh_cmd_priv *mcmd = scsi_cmd_priv(cmd);
+
+	return &mcmd->scsi_pointer;
+}
+
 /*
  * Registers in the MESH controller.
  */
