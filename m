Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1E7C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbiBRTxd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238654AbiBRTxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:16 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDA429413E
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:47 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id l9so8015498plg.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8KYU+BdU6PlksD78VB0yUTvt/EaDu45QnauSkwKpQfw=;
        b=2zppJ+rxUpIURCz1SmHTl7y5oocPHm3aSdM5k8Rm+viyjXkzSoAgXvV8901LwGFJmT
         ceYmM/Had0lhbG9P+kqT+a1IMJVIj4m3MU5/SAe8QjO96rNYas/iNur3vBdEhZOQ6qeY
         Ma1+BJT6w5pDWAocH0fy2TnjTqcUBnhsUXiuuWzIwklM71orLoB+ZdftqVPfzoTKz/Qd
         shTprOw8wk1Q9GXT6KP0A+/OrRK1Y3uIlz2HusCMDcmp4ZU+p99zr1V2TgT/HbkNxuiP
         eqiiBlt+WZSMsi2KZuxfGnmU8j8fVl78iB4u03ppFlDE4fmtTpEy+7u6IBy/zldPrzx5
         EAew==
X-Gm-Message-State: AOAM533MLtUa9WH9FSBMBCWU4iiZD5J3STuAEBUrdiLSsKf6ecn3QgNY
        2vmWwoUbekPlmsYnqVh/BqI=
X-Google-Smtp-Source: ABdhPJzycICzx7/OCfMiARNbqlmeGhI1/58xhvjA4ujmIhzvL/dKoOi4MBpEw8IYZGu1q566CoD8xg==
X-Received: by 2002:a17:902:d683:b0:14c:c0a9:34f3 with SMTP id v3-20020a170902d68300b0014cc0a934f3mr8711462ply.109.1645213966500;
        Fri, 18 Feb 2022 11:52:46 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:45 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 34/49] scsi: mesh: Move the SCSI pointer to private command data
Date:   Fri, 18 Feb 2022 11:51:02 -0800
Message-Id: <20220218195117.25689-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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
