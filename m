Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB701C3F2CE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0D212073B
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgCBDad (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Mar 2020 22:30:33 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38790 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgCBDad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Mar 2020 22:30:33 -0500
Received: by mail-pg1-f193.google.com with SMTP id d6so4701746pgn.5
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2020 19:30:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RnYEvbMd/rUNmlgcJgE7XpYcX8qKwuBh08UfrerjdkI=;
        b=lZjY5kvCAvx8+OzrmNdNF+I45vhQrPkz8zEnpGwQwz0d0SQiVBQahbbYWy64+l/kC/
         3DXYCPmoxrv0H63yRRRJg1EAs6uSgsM89nMDlox5CaM3dbMKKfweAjz/UkE9E8zjSLzu
         LVQ5AhD0EkJjjR7+aCXm4GsE1f9n+hqEC51qKd2czWMeuHs9f/QsBfblyhbuS5cmY94I
         jjJdpYAwfYe9dXzCpj8zek6kqjmGPxiZn1ionDe2Bc4LsXO5/FCPknTOR2l7JBdNkJl7
         SwV3XLd/jEVy3dXHWZyvVS0Rs9JURyoKbbA6U/TjnIpxJvFl4RaUSKp637R7AadhKRn9
         /FEg==
X-Gm-Message-State: ANhLgQ1mHEPuaw/xZXQmvlEA0W8xkyX1XmVupbQH7+5z/7DUJen6IlAk
        u75EqZLJ7iVMbp8XsvshF88=
X-Google-Smtp-Source: ADFU+vtzlyHOqUxFoSDwGdyFYhag8bxDyQ3rz82qaWHa4G9VZNQQ59HgRDnn3lE2jdAWdHDONiJ/3g==
X-Received: by 2002:a62:7587:: with SMTP id q129mr4660467pfc.53.1583119831971;
        Sun, 01 Mar 2020 19:30:31 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7869:cc6e:b1f7:9f7d])
        by smtp.gmail.com with ESMTPSA id z3sm18782254pfz.155.2020.03.01.19.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 19:30:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 1/4] qla2xxx: Use raw_smp_processor_id() where appropriate
Date:   Sun,  1 Mar 2020 19:30:20 -0800
Message-Id: <20200302033023.27718-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302033023.27718-1-bvanassche@acm.org>
References: <20200302033023.27718-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes e.g. the following kernel complaint:

BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/844
caller is qla2xxx_create_qpair+0x698/0xab0 [qla2xxx]
CPU: 7 PID: 844 Comm: modprobe Not tainted 5.5.0-rc2-dbg+ #6
Call Trace:
 dump_stack+0xa5/0xe6
 debug_smp_processor_id.cold+0x59/0x5e
 qla2xxx_create_qpair+0x698/0xab0 [qla2xxx]
 qla2x00_probe_one+0x1a67/0x4820 [qla2xxx]
 local_pci_probe+0x7c/0xc0
 pci_device_probe+0x25d/0x390
 really_probe+0x170/0x510
 driver_probe_device+0x127/0x190
 device_driver_attach+0x98/0xa0
 __driver_attach+0xb6/0x1a0
 bus_for_each_dev+0x100/0x150
 driver_attach+0x31/0x40
 bus_add_driver+0x246/0x300
 driver_register+0xe0/0x170
 __pci_register_driver+0xd2/0xe0
 qla2x00_module_init+0x1db/0x247 [qla2xxx]
 do_one_initcall+0xda/0x480
 do_init_module+0x10a/0x3b0
 load_module+0x4318/0x47c0
 __do_sys_finit_module+0x134/0x1d0
 __x64_sys_finit_module+0x47/0x50
 do_syscall_64+0x6f/0x2f0
entry_SYSCALL_64_after_hwframe+0x49/0xbe

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c    | 2 +-
 drivers/scsi/qla2xxx/qla_isr.c     | 4 ++--
 drivers/scsi/qla2xxx/qla_target.c  | 2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5b2deaa730bf..582fc5dcc98c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8992,7 +8992,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 		qpair->rsp->req = qpair->req;
 		qpair->rsp->qpair = qpair;
 		/* init qpair to this cpu. Will adjust at run time. */
-		qla_cpu_update(qpair, smp_processor_id());
+		qla_cpu_update(qpair, raw_smp_processor_id());
 
 		if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
 			if (ha->fw_attributes & BIT_4)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8d7a905f6247..a5aae276fbb2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3217,8 +3217,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	if (!ha->flags.fw_started)
 		return;
 
-	if (rsp->qpair->cpuid != smp_processor_id())
-		qla_cpu_update(rsp->qpair, smp_processor_id());
+	if (rsp->qpair->cpuid != raw_smp_processor_id())
+		qla_cpu_update(rsp->qpair, raw_smp_processor_id());
 
 	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 622e7337affc..c4c6a8e1b46d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4368,7 +4368,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 		queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq, &cmd->work);
 	} else if (ha->msix_count) {
 		if (cmd->atio.u.isp24.fcp_cmnd.rddata)
-			queue_work_on(smp_processor_id(), qla_tgt_wq,
+			queue_work_on(raw_smp_processor_id(), qla_tgt_wq,
 			    &cmd->work);
 		else
 			queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 1f0a185b2a95..9f7a79aff1ee 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -305,7 +305,7 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
 	cmd->trc_flags |= TRC_CMD_DONE;
 
 	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
-	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
+	queue_work_on(raw_smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
 }
 
 /*
@@ -543,7 +543,7 @@ static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 	cmd->trc_flags |= TRC_DATA_IN;
 	cmd->cmd_in_wq = 1;
 	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
-	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
+	queue_work_on(raw_smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
 }
 
 static int tcm_qla2xxx_chk_dif_tags(uint32_t tag)
