Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727BDC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354146AbiBKWeZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354075AbiBKWeW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:22 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEC9D5D
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:14 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id c3so5785563pls.5
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/qBRBLM1r2yTY4VduEFKfWhYTThTW41WBM80pT8DTc=;
        b=alQgAup4NSL0n7eBJWV/5ExxBdVYSMMWnVrrg9hSC1ckxzcftI1os8Wf9rOTWzxfG/
         E2uBOuJ+7ymwsmsLZLn8M16b19ORgCeKuHYHAqfGFXBa6IHRnmOUJjGSibNlqlRQ9VrW
         lH8QVkBbTR0TCEi17V1SAkrfXgkNh+4wIDe+MW3ruePeIEYLHv3QL21q6CdWqJNk/pyl
         n5N348fHf8/DnsQse7FunFgfujqa78cdC38MZXHcicb4C/yRjgFk/KiE3foPe50gzR73
         lO3IUtX/yaDGP4r/ogGiaKytac18dHToxtXboVKHOF90tbCNyijjUG4dP/uNKNqONZ/W
         9TLQ==
X-Gm-Message-State: AOAM530DxJ0TWw/oUxhkzGb4nDIALcxEKrR612pdhWgIsBky7gIxJjgn
        t+0h51sIyhPk6SLaeF02mes=
X-Google-Smtp-Source: ABdhPJx9Mv5yPEcO0G8UCTxla5zG5H7QBUQdWQZLvUM20i/MTEwHGl25r5tH3zuUFIdESzCtzr8e5Q==
X-Received: by 2002:a17:902:bb97:: with SMTP id m23mr3426256pls.151.1644618854023;
        Fri, 11 Feb 2022 14:34:14 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:13 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 32/48] scsi: megasas: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:31 -0800
Message-Id: <20220211223247.14369-33-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 12 ++++++++++++
 drivers/scsi/megaraid/megaraid_sas_base.c   |  8 ++++----
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 15 ++++++++-------
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 2c9d1b796475..611871ef15b5 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -18,6 +18,8 @@
 #ifndef LSI_MEGARAID_SAS_H
 #define LSI_MEGARAID_SAS_H
 
+#include <scsi/scsi_cmnd.h>
+
 /*
  * MegaRAID SAS Driver meta data
  */
@@ -2594,6 +2596,16 @@ struct megasas_cmd {
 	};
 };
 
+struct megasas_cmd_priv {
+	void	*cmd_priv;
+	u8	status;
+};
+
+static inline struct megasas_cmd_priv *megasas_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 #define MAX_MGMT_ADAPTERS		1024
 #define MAX_IOCTL_SGE			16
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 82e1e24257bc..8bf72dbc33b7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1760,7 +1760,7 @@ megasas_build_and_issue_cmd(struct megasas_instance *instance,
 		goto out_return_cmd;
 
 	cmd->scmd = scmd;
-	scmd->SCp.ptr = (char *)cmd;
+	megasas_priv(scmd)->cmd_priv = cmd;
 
 	/*
 	 * Issue the command to the FW
@@ -2992,11 +2992,10 @@ megasas_dump_reg_set(void __iomem *reg_set)
 void
 megasas_dump_fusion_io(struct scsi_cmnd *scmd)
 {
-	struct megasas_cmd_fusion *cmd;
+	struct megasas_cmd_fusion *cmd = megasas_priv(scmd)->cmd_priv;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
 	struct megasas_instance *instance;
 
-	cmd = (struct megasas_cmd_fusion *)scmd->SCp.ptr;
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
 	scmd_printk(KERN_INFO, scmd,
@@ -3518,6 +3517,7 @@ static struct scsi_host_template megasas_template = {
 	.mq_poll = megasas_blk_mq_poll,
 	.change_queue_depth = scsi_change_queue_depth,
 	.max_segment_size = 0xffffffff,
+	.cmd_size = sizeof(struct megasas_cmd_priv),
 };
 
 /**
@@ -3601,7 +3601,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	cmd->retry_for_fw_reset = 0;
 
 	if (cmd->scmd)
-		cmd->scmd->SCp.ptr = NULL;
+		megasas_priv(cmd->scmd)->cmd_priv = NULL;
 
 	switch (hdr->cmd) {
 	case MFI_CMD_INVALID:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index fc90a0a687b5..c72364864bf4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2915,7 +2915,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 				get_updated_dev_handle(instance,
 					&fusion->load_balance_info[device_id],
 					&io_info, local_map_ptr);
-			scp->SCp.Status |= MEGASAS_LOAD_BALANCE_FLAG;
+			megasas_priv(scp)->status |= MEGASAS_LOAD_BALANCE_FLAG;
 			cmd->pd_r1_lb = io_info.pd_after_lb;
 			if (instance->adapter_type >= VENTURA_SERIES)
 				rctx_g35->span_arm = io_info.span_arm;
@@ -2923,7 +2923,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 				rctx->span_arm = io_info.span_arm;
 
 		} else
-			scp->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
+			megasas_priv(scp)->status &= ~MEGASAS_LOAD_BALANCE_FLAG;
 
 		if (instance->adapter_type >= VENTURA_SERIES)
 			cmd->r1_alt_dev_handle = io_info.r1_alt_dev_handle;
@@ -3293,7 +3293,7 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 	io_request->SenseBufferLength = SCSI_SENSE_BUFFERSIZE;
 
 	cmd->scmd = scp;
-	scp->SCp.ptr = (char *)cmd;
+	megasas_priv(scp)->cmd_priv = cmd;
 
 	return 0;
 }
@@ -3489,7 +3489,7 @@ megasas_complete_r1_command(struct megasas_instance *instance,
 		if (instance->ldio_threshold &&
 		    megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
 			atomic_dec(&instance->ldio_outstanding);
-		scmd_local->SCp.ptr = NULL;
+		megasas_priv(scmd_local)->cmd_priv = NULL;
 		megasas_return_cmd_fusion(instance, cmd);
 		scsi_dma_unmap(scmd_local);
 		megasas_sdev_busy_dec(instance, scmd_local);
@@ -3613,12 +3613,13 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
 			/* Update load balancing info */
 			if (fusion->load_balance_info &&
-			    (cmd_fusion->scmd->SCp.Status &
+			    (megasas_priv(cmd_fusion->scmd)->status &
 			    MEGASAS_LOAD_BALANCE_FLAG)) {
 				device_id = MEGASAS_DEV_INDEX(scmd_local);
 				lbinfo = &fusion->load_balance_info[device_id];
 				atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
-				cmd_fusion->scmd->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
+				megasas_priv(cmd_fusion->scmd)->status &=
+					~MEGASAS_LOAD_BALANCE_FLAG;
 			}
 			fallthrough;	/* and complete IO */
 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
@@ -3630,7 +3631,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 				if (instance->ldio_threshold &&
 				    (megasas_cmd_type(scmd_local) == READ_WRITE_LDIO))
 					atomic_dec(&instance->ldio_outstanding);
-				scmd_local->SCp.ptr = NULL;
+				megasas_priv(scmd_local)->cmd_priv = NULL;
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
 				megasas_sdev_busy_dec(instance, scmd_local);
