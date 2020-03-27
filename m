Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D653C2D0ED
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17AC420857
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgC0Qry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 12:47:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:41800 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbgC0Qry (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 12:47:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3CF96AFCF;
        Fri, 27 Mar 2020 16:47:52 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 5/5] scsi: qla2xxx: only send certain mailbox commands to stopped firmware
Date:   Fri, 27 Mar 2020 17:47:11 +0100
Message-Id: <20200327164711.5358-6-mwilck@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200327164711.5358-1-mwilck@suse.com>
References: <20200327164711.5358-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Since commit 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting
down chip"), it is possible that FC commands are scheduled after the
adapter firmware has been shut down. IO sent to the firmware in this
situation may hang. Only certain mailbox commands should be sent in
this situation.

This patch identifies the mailbox commands sent during adapter
initialization (before QLA_FW_STARTED() is called) and allows only
these to be sent to the firmware in stopped state.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 46 ++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9fd83d1..4a9a583 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -77,6 +77,45 @@ static int is_rom_cmd(uint16_t cmd)
 	return 0;
 }
 
+/*
+ * Mailbox commands that must (and can) be sent to the Firmware
+ * even if it isn't running. IOW, commands that are sent before
+ * QLA_FW_STARTED() is called.
+ */
+static uint16_t fw_stopped_cmds[] = {
+	MBC_EXECUTE_FIRMWARE,
+	MBC_READ_RAM_WORD,
+	MBC_MAILBOX_REGISTER_TEST,
+	MBC_VERIFY_CHECKSUM,
+	MBC_GET_FIRMWARE_VERSION,
+	MBC_LOAD_RISC_RAM,
+	MBC_LOAD_RISC_RAM_EXTENDED,
+	MBC_WRITE_RAM_WORD_EXTENDED,
+	MBC_READ_RAM_EXTENDED,
+	MBC_GET_ADAPTER_LOOP_ID,
+	MBC_GET_SET_ZIO_THRESHOLD,
+	MBC_GET_FIRMWARE_OPTION,
+	MBC_GET_MEM_OFFLOAD_CNTRL_STAT,
+	MBC_SET_FIRMWARE_OPTION,
+	MBC_GET_RESOURCE_COUNTS,
+	MBC_INITIALIZE_FIRMWARE,
+	MBC_TRACE_CONTROL,
+	MBC_READ_SFP,
+	MBC_MID_INITIALIZE_FIRMWARE,
+	MBC_FLASH_ACCESS_CTRL,
+};
+
+static bool must_send_if_fw_stopped(uint16_t cmd)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(fw_stopped_cmds); i++) {
+		if (fw_stopped_cmds[i] == cmd)
+			return true;
+	}
+	return false;
+}
+
 /*
  * qla2x00_mailbox_command
  *	Issue mailbox command and waits for completion.
@@ -169,6 +208,13 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
+	if (!ha->flags.fw_started && !must_send_if_fw_stopped(mcp->mb[0])) {
+		ql_log(ql_log_info, vha, 0x1006,
+		       "Cmd 0x%x skipped with timeout since FW is stopped\n",
+		       mcp->mb[0]);
+		return QLA_FUNCTION_TIMEOUT;
+	}
+
 	atomic_inc(&ha->num_pend_mbx_stage1);
 	/*
 	 * Wait for active mailbox commands to finish by waiting at most tov
-- 
2.25.1

