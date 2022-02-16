Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9FDC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbiBPVFG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:05:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiBPVEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:08 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3522AFE9E
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:55 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id u16so3149894pfg.12
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8KYU+BdU6PlksD78VB0yUTvt/EaDu45QnauSkwKpQfw=;
        b=EPFYKPnYfmGvALrbsr+iU8KMSbfyOXXWp9LwMwtBcVufGD+3tQ7W8jGb+QlrY9iENf
         k6rEGTUk3E41X70LNl00ioXYEkh5nnAL/MkfmUH5wPtWYtlOsS3xgWMsgf4pW7Zl33ux
         uu5YqplzAKhGphXBjUZPS9F4bSm5XAqlhc7dJgQqlh2ba7Aw8+sf+t7tDU4+gJUP/ROk
         0wlGor/XuE2n+TLPwR2Zd3a+X6IcumwSpSZLlIPDO8gxMRW/QLT1QYjrz8+XBuxSio4w
         cLJc3XjLsODuMpoMdi/Hk0NQJmc/WiL40g3jtUvGLgSx3y4zBsRxQ3xdTLhqeHqwtk+3
         ytGw==
X-Gm-Message-State: AOAM532eNOepDtn2+i738X744l2hwFiCFDTqjvjeegaxJBSphduEWbfw
        bEcWPz6sqQJDbyyYhR4TFWQ=
X-Google-Smtp-Source: ABdhPJyS4pBgWkbAAbtNWWAKNhlgmD3fxxBcZqo4n7QjXWDR9Lzh9++h+aqK+JgemjCLMhIxy69H+w==
X-Received: by 2002:a63:64c5:0:b0:34d:3d6c:31d2 with SMTP id y188-20020a6364c5000000b0034d3d6c31d2mr3711803pgb.499.1645045435336;
        Wed, 16 Feb 2022 13:03:55 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 35/50] scsi: mesh: Move the SCSI pointer to private command data
Date:   Wed, 16 Feb 2022 13:02:18 -0800
Message-Id: <20220216210233.28774-36-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
