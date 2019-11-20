Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02777C33C99
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAC0820857
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="oH7dRNOm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKTW1t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:27:49 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51280 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726554AbfKTW1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 17:27:40 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1F88643B0D;
        Wed, 20 Nov 2019 22:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574288858; x=1576103259; bh=AoW3kTas39MbUxlrFQ89zzmfOPycLEZixrm
        itxLfY7k=; b=oH7dRNOmXmzHODTgBxoD9id1MfSuQAs03iNjKGlYKG35VvUEzCi
        rEp74BGDgdrYEymtO9/p/tD2VYdaEfWCtbzh4UYToCRgsKdYOc1a07SXCPOENTqk
        VDWfqi8CAW3KNc1cAGYvALaZRZ5SWz4UMOrZEf9IWjfZ8Bym7GG7tt5o=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5DvocU4BwFvS; Thu, 21 Nov 2019 01:27:38 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9CD9842F12;
        Thu, 21 Nov 2019 01:27:35 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Nov 2019 01:27:35 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 08/15] scsi: qla2xxx: Configure local loop for N2N target
Date:   Thu, 21 Nov 2019 01:27:16 +0300
Message-ID: <20191120222723.27779-9-r.bolshakov@yadro.com>
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

qla2x00_configure_local_loop initializes PLOGI payload for PLOGI ELS
using Get Parameters mailbox command.

In the case when the driver is running in target mode, the topology is
N2N and the target port has higher WWPN, LOCAL_LOOP_UPDATE bit is
cleared too early and PLOGI payload is not initialized by the Get
Parameters command. That causes a failure of ELS IOCB carrying the
PLOGI with 0x15 aka Data Underrun error.

LOCAL_LOOP_UPDATE has to be set to initialize PLOGI payload.

Fixes: 48acad099074 ("scsi: qla2xxx: Fix N2N link re-connect")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 12391815be06..096f41fe17d2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4932,14 +4932,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 		set_bit(RSCN_UPDATE, &flags);
 		clear_bit(LOCAL_LOOP_UPDATE, &flags);
 
-	} else if (ha->current_topology == ISP_CFG_N) {
-		clear_bit(RSCN_UPDATE, &flags);
-		if (qla_tgt_mode_enabled(vha)) {
-			/* allow the other side to start the login */
-			clear_bit(LOCAL_LOOP_UPDATE, &flags);
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		}
-	} else if (ha->current_topology == ISP_CFG_NL) {
+	} else if (ha->current_topology == ISP_CFG_NL ||
+		   ha->current_topology == ISP_CFG_N) {
 		clear_bit(RSCN_UPDATE, &flags);
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	} else if (!vha->flags.online ||
-- 
2.24.0

