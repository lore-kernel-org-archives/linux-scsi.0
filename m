Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD44AC43215
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 16:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9551C2068E
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 16:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="KSahFrQe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfKYQ5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 11:57:25 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:39630 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728853AbfKYQ5T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Nov 2019 11:57:19 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5503E43E1B;
        Mon, 25 Nov 2019 16:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574701036; x=1576515437; bh=RGl9Y1wcxFdhzHYOksJaiTWGnbIV50A9rlN
        hMV+th24=; b=KSahFrQerY1fLAUwxHVW3DkHnbHo3tyST5u0FHkRi8fx58rUOBg
        E49v1XOtiv7ZCwWTprE9wOZqIyl4oFHtnKm/WJPH6P7WZhi4zYeu2+jei6VuvTHJ
        GSdYwzGKpXjZZA4QdJQ04BO4oONf+EDRls0+JMuUCzCZ2r0WPkHHhBKg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WRO3z6D13aev; Mon, 25 Nov 2019 19:57:16 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 6DB5443E04;
        Mon, 25 Nov 2019 19:57:15 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 25
 Nov 2019 19:57:15 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v3 06/13] scsi: qla2xxx: Allow PLOGI in target mode
Date:   Mon, 25 Nov 2019 19:56:55 +0300
Message-ID: <20191125165702.1013-7-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191125165702.1013-1-r.bolshakov@yadro.com>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
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

According to FC-LS-3 (Fibre Channel Link Services) 6.3.2.4
"N_Port Login - No Fabric present", if both parties in the point-to-point
connection know N_Port_Names of each other, Nx_Port with the highest
N_Port_name shall transmit PLOGI. The specification sets no restrictions
on the port role that should send PLOGI.

However, FCP-4 (Fibre Channel Protocol for SCSI, Fourth Version) 6.2
"Overview of Process Login and Process Logout", instructs that in
point-to-point topology, initiator shall send explicit PRLI ELS.

The change fixes stuck P2P login, when target WWPN is higher than
initiator WWPN.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index fcb309be50d9..b4283a3126d0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1527,8 +1527,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		}
 	}
 
-	/* for pure Target Mode. Login will not be initiated */
-	if (vha->host->active_mode == MODE_TARGET)
+	/* Target won't initiate port login if fabric is present */
+	if (vha->host->active_mode == MODE_TARGET && !N2N_TOPO(vha->hw))
 		return 0;
 
 	if (fcport->flags & FCF_ASYNC_SENT) {
@@ -1720,6 +1720,10 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 void qla_handle_els_plogi_done(scsi_qla_host_t *vha,
 				      struct event_arg *ea)
 {
+	/* for pure Target Mode, PRLI will not be initiated */
+	if (vha->host->active_mode == MODE_TARGET)
+		return;
+
 	ql_dbg(ql_dbg_disc, vha, 0x2118,
 	    "%s %d %8phC post PRLI\n",
 	    __func__, __LINE__, ea->fcport->port_name);
-- 
2.24.0

