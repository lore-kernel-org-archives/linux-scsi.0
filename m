Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDB6C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF53120878
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="k5y/XGk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKTW1p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:27:45 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51262 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbfKTW1p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 17:27:45 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4C80943D79;
        Wed, 20 Nov 2019 22:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574288862; x=1576103263; bh=eaUqDliENYFOZMUWYYPEKBMKd5OpCyqmsnp
        TQQ+LTpQ=; b=k5y/XGk2uE+B5dMVKZRAMzISIp8T2WQX7LgVFnuV6FZZczVsuRq
        PgZKjenREYpTO6ac1RyPnFUVvwIWgywHnVJPDaH/rKpiWuq1wEU4DMV8gE90j9YL
        dFUvmWJImc6mx5yVoY5KqzaOblb35KaiWU2uPfHI8N85wWgylC/I1vro=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aggEqA3O9LeL; Thu, 21 Nov 2019 01:27:42 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 313DA42F12;
        Thu, 21 Nov 2019 01:27:39 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Nov 2019 01:27:38 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 15/15] scsi: qla2xxx: Handle ABTS according to FCP spec for logged out ports
Date:   Thu, 21 Nov 2019 01:27:23 +0300
Message-ID: <20191120222723.27779-16-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120222723.27779-1-r.bolshakov@yadro.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fibre Channel Protocol for SCSI, Fourth Version (FCP-4) 12.3.3, "Target
FCP_Port response to Exchange termination" states:

  When an ABTS-LS is received at the target FCP_Port, it shall abort the
  designated Exchange and return one of the following responses:

    a) the target FCP_Port shall discard the ABTS-LS and transmit a LOGO ELS if
       the Nx_Port issuing the ABTS-LS is not currently logged in (i.e., no
       N_Port Login exists);

However, current implementation tries to send a real BA_RJT in response to ABTS
from logged-out ports. The oparation fails because N_Port handle was freed
shortly after logout and ABTS Recieved IOCB contains 0xFFFF N_Port handle.
Existing implementation doesn't send LOGO at all.

The correct way to discard ABTS-LS frame when N_Port handle wasn't found is to
set Terminate ABTS Exchange bit in control flags of ABTS Response IOCB.
LOGO is sent after that.

To avoid a deadlock in qla2x00_start_sp(), hardware_lock should be released.
The unlocking should be safe because ABTS Recieved IOCB is not needed after
s_id is saved on the stack and qlt_24xx_send_abts_resp() is invoked.

Fixes: 2d70c103fd2a ("[SCSI] qla2xxx: Add LLD target-mode infrastructure for >= 24xx series")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0f2bc4cd562f..331e7adf4b15 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1800,7 +1800,7 @@ static int qlt_build_abts_resp_iocb(struct qla_tgt_mgmt_cmd *mcmd)
  */
 static void qlt_24xx_send_abts_resp(struct qla_qpair *qpair,
 	struct abts_recv_from_24xx *abts, uint32_t status,
-	bool ids_reversed)
+	bool ids_reversed, bool term_exchange)
 {
 	struct scsi_qla_host *vha = qpair->vha;
 	struct qla_hw_data *ha = vha->hw;
@@ -1825,6 +1825,10 @@ static void qlt_24xx_send_abts_resp(struct qla_qpair *qpair,
 	resp->handle = QLA_TGT_SKIP_HANDLE;
 	resp->entry_count = 1;
 	resp->nport_handle = abts->nport_handle;
+	if (term_exchange)
+		resp->control_flags = cpu_to_le16(ABTS_CONTR_FLG_TERM_EXCHG);
+	else
+		resp->control_flags = 0;
 	resp->vp_index = vha->vp_idx;
 	resp->sof_type = abts->sof_type;
 	resp->exchange_address = abts->exchange_address;
@@ -1940,7 +1944,7 @@ static void qlt_24xx_retry_term_exchange(struct scsi_qla_host *vha,
 		qlt_build_abts_resp_iocb(mcmd);
 	else
 		qlt_24xx_send_abts_resp(qpair,
-		    (struct abts_recv_from_24xx *)entry, FCP_TMF_CMPL, true);
+		    (struct abts_recv_from_24xx *)entry, FCP_TMF_CMPL, true, false);
 
 }
 
@@ -2134,7 +2138,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 		    "qla_target(%d): ABTS: Abort Sequence not "
 		    "supported\n", vha->vp_idx);
 		qlt_24xx_send_abts_resp(ha->base_qpair, abts, FCP_TMF_REJECTED,
-		    false);
+		    false, false);
 		return;
 	}
 
@@ -2143,7 +2147,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 		    "qla_target(%d): ABTS: Unknown Exchange "
 		    "Address received\n", vha->vp_idx);
 		qlt_24xx_send_abts_resp(ha->base_qpair, abts, FCP_TMF_REJECTED,
-		    false);
+		    false, false);
 		return;
 	}
 
@@ -2163,8 +2167,16 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 		    vha->vp_idx);
 		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
+		/*
+		 * According to FCP-4 12.3.3,
+		 * ABTS-LS frame shall be discarded
+		 */
 		qlt_24xx_send_abts_resp(ha->base_qpair, abts, FCP_TMF_REJECTED,
-			    false);
+			    false, true);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		/* and LOGO ELS transmitted */
+		qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, be_to_port_id(s_id), false);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 		return;
 	}
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
@@ -2172,7 +2184,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 
 	if (sess->deleted) {
 		qlt_24xx_send_abts_resp(ha->base_qpair, abts, FCP_TMF_REJECTED,
-		    false);
+		    false, false);
 		return;
 	}
 
@@ -2182,7 +2194,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 		    "qla_target(%d): __qlt_24xx_handle_abts() failed: %d\n",
 		    vha->vp_idx, rc);
 		qlt_24xx_send_abts_resp(ha->base_qpair, abts, FCP_TMF_REJECTED,
-		    false);
+		    false, false);
 		return;
 	}
 }
@@ -6213,7 +6225,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 out_term:
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_24xx_send_abts_resp(ha->base_qpair, &prm->abts,
-	    FCP_TMF_REJECTED, false);
+	    FCP_TMF_REJECTED, false, false);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
-- 
2.24.0

