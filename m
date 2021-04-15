Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E94C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 20:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE7961139
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 20:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhDOUge (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 16:36:34 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39278 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234894AbhDOUgd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 16:36:33 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 61FDF4138D;
        Thu, 15 Apr 2021 20:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1618518967; x=
        1620333368; bh=c1eg21lqubOreR37W0K3pDIX2iHmsCML0kLSAeRAJpQ=; b=q
        mXEauFRc7D/nEpf/V8uVuvE7xd/w2We9Zci81xd/J7dqNs3fgQJ+qRR6dFofwFJ4
        NSoHW/6+TlqNLsUbljqCgoHvpzuZIWi4UR/FmjCAOxC8j6BYdKLB/fMZki+kraHt
        SBPGjvZGusCLizYQ/Kj9W3NKtVaWml508bm3BvFzik=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IkCbtrtiviRI; Thu, 15 Apr 2021 23:36:07 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BA28A41377;
        Thu, 15 Apr 2021 23:36:06 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.31) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 15
 Apr 2021 23:36:06 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        <target-devel@vger.kernel.org>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] scsi: qla2xx: wait for stop_phase1 at wwn removal
Date:   Thu, 15 Apr 2021 23:35:54 +0300
Message-ID: <20210415203554.27890-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.31]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Target de-configuration panics at high CPU load.
TPGT and WWPN can be removed on separate threads.
TPGT removal requests a reset HBA on a separate thread and waits for
reset complete (qlt_stop_phase1). Due to high CPU load that HBA reset
can be delayed for some time.
WWPN removal does qlt_stop_phase2 where it is thinked that phase1
has been already finished and zeroed tgt.tgt_ops that is used by
incoming traffic and causes several panics:

NIP qlt_reset+0x7c/0x220 [qla2xxx]
LR  qlt_reset+0x68/0x220 [qla2xxx]
Call Trace:
0xc000003ffff63a78 (unreliable)
qlt_handle_imm_notify+0x800/0x10c0 [qla2xxx]
qlt_24xx_atio_pkt+0x208/0x590 [qla2xxx]
qlt_24xx_process_atio_queue+0x33c/0x7a0 [qla2xxx]
qla83xx_msix_atio_q+0x54/0x90 [qla2xxx]

or

NIP qlt_24xx_handle_abts+0xd0/0x2a0 [qla2xxx]
LR  qlt_24xx_handle_abts+0xb4/0x2a0 [qla2xxx]
Call Trace:
qlt_24xx_handle_abts+0x90/0x2a0 [qla2xxx] (unreliable)
qlt_24xx_process_atio_queue+0x500/0x7a0 [qla2xxx]
qla83xx_msix_atio_q+0x54/0x90 [qla2xxx]

or

NIP qlt_create_sess+0x90/0x4e0 [qla2xxx]
LR  qla24xx_do_nack_work+0xa8/0x180 [qla2xxx]
Call Trace:
0xc0000000348fba30 (unreliable)
qla24xx_do_nack_work+0xa8/0x180 [qla2xxx]
qla2x00_do_work+0x674/0xbf0 [qla2xxx]
qla2x00_iocb_work_fn

The patch fixes the issue by serializing qlt_stop_phase1 and
qlt_stop_phase2 functions to make WWPN removal waits for phase1
completion.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
Patch is for scsi-fixes tree.
The issue is very old, but the patch is applicable for 4.20+ versions.

 drivers/scsi/qla2xxx/qla_target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 480e7d2dcf3e..745d6d98c02e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1558,10 +1558,12 @@ void qlt_stop_phase2(struct qla_tgt *tgt)
 		return;
 	}
 
+	mutex_lock(&tgt->ha->optrom_mutex);
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
 	tgt->tgt_stop = 0;
 	tgt->tgt_stopped = 1;
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
+	mutex_unlock(&tgt->ha->optrom_mutex);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00c, "Stop of tgt %p finished\n",
 	    tgt);
-- 
2.25.1

