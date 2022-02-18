Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A607DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbiBRTxm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238544AbiBRTxZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:25 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310CD291FAB
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:06 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id p8so3128284pfh.8
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nBwtGryv3+hjFI6gPofqHnRhTZ05RYrc/eDIGaEQe1I=;
        b=vc3Qi/mJm6vYpPEVHpGe0xyUE55yUo8WSpMcjg3/JH0Tc4AQWWLEDxH6T02vRMJPu6
         NLb5FqqZRjQVD04c71mL5peQzDdivDeXMwTq+Ru0bbzyATnTxG8CiawoWYsPcqHENR8Q
         BZLEpC+SWsO/SLjbEq4IUsE+f/wPoaXUrRM98L1kEfsMqfC/JZeHzIROIwyUDlt1DSTk
         4p98EZjsPYh40vhHKSvlPw1BMCBwDiJfgMuoMUVOYjHFJ+ADXJCA7+K8bINPutw8W6WF
         SSkEtdP9Imxd+zfcWDr1TDU0KX6x0J9md6gTCje0UsA6epTk/PFFpHybOsVfYE9hrjW9
         OTMA==
X-Gm-Message-State: AOAM5320ElyhEQVClwhGCKb1WA+1Y0wgWeViZYZSwmWnx71kqj2kQTon
        4nh4wUpa3JC/0+5FR8vqZBw=
X-Google-Smtp-Source: ABdhPJzIFyH55+oVhln3+rRy/ExpDUSw/GIqrPpNFVYVhXax4q0rZ3gRDztW7BtG0Qf01Nt88IzsCA==
X-Received: by 2002:a05:6a00:1787:b0:4c8:aca8:52cd with SMTP id s7-20020a056a00178700b004c8aca852cdmr8961227pfg.10.1645213985583;
        Fri, 18 Feb 2022 11:53:05 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:53:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 42/49] scsi: qla2xxx: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:51:10 -0800
Message-Id: <20220218195117.25689-43-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of using the SCp.ptr field to track whether or not a command is
in flight, use the sp->type field to track this information. sp->type
must be set for proper operation of the qla2xxx driver. See e.g. the
switch (sp->type) statement in qla2x00_ct_entry().

This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  2 --
 drivers/scsi/qla2xxx/qla_os.c  | 13 +++++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 47d7fa1c7ae8..174e80fbbdae 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5201,8 +5201,6 @@ struct secure_flash_update_block_pk {
 
 #define	QLA_DSDS_PER_IOCB	37
 
-#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
-
 #define QLA_SG_ALL	1024
 
 enum nexus_wait_type {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a4546346c18b..58c83525f006 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -739,7 +739,7 @@ void qla2x00_sp_compl(srb_t *sp, int res)
 	/* kref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	cmd->result = res;
-	CMD_SP(cmd) = NULL;
+	sp->type = 0;
 	scsi_done(cmd);
 	if (comp)
 		complete(comp);
@@ -831,7 +831,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	cmd->result = res;
-	CMD_SP(cmd) = NULL;
+	sp->type = 0;
 	scsi_done(cmd);
 	if (comp)
 		complete(comp);
@@ -934,8 +934,6 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
-
-	CMD_SP(cmd) = (void *)sp;
 	sp->free = qla2x00_sp_free_dma;
 	sp->done = qla2x00_sp_compl;
 
@@ -1025,7 +1023,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
-	CMD_SP(cmd) = (void *)sp;
 	sp->free = qla2xxx_qpair_sp_free_dma;
 	sp->done = qla2xxx_qpair_sp_compl;
 
@@ -1071,6 +1068,7 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 	unsigned long wait_iter = ABORT_WAIT_ITER;
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp = scsi_cmd_priv(cmd);
 	int ret = QLA_SUCCESS;
 
 	if (unlikely(pci_channel_offline(ha->pdev)) || ha->flags.eeh_busy) {
@@ -1079,10 +1077,9 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 		return ret;
 	}
 
-	while (CMD_SP(cmd) && wait_iter--) {
+	while (sp->type && wait_iter--)
 		msleep(ABORT_POLLING_PERIOD);
-	}
-	if (CMD_SP(cmd))
+	if (sp->type)
 		ret = QLA_FUNCTION_FAILED;
 
 	return ret;
