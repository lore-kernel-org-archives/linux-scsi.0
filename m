Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD80C33C99
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D1920872
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="ldmS6EvB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfKTW1o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:27:44 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51276 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbfKTW1n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 17:27:43 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 26E7A43E03;
        Wed, 20 Nov 2019 22:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574288861; x=1576103262; bh=hRumHpSG5+clEN/Z+HJCUlpkwIoz6mPtowh
        upPpAb4s=; b=ldmS6EvBtVHhBdiV5COHN+bBdOfKgXF/BeMjjolo3LqFe4LBwmn
        F1jZsg//h2fZhzeowoIAfeFos2wU0Ti4JjgeYz3tIOeioph7CNj5FuxeXjvftFgh
        wxIu9X0XGFRkTvM1f+QfQpgrE7v7bXU/RgrcOEKjhvfQmqS2oEPChdoM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EVRsVwlOmfqa; Thu, 21 Nov 2019 01:27:41 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A2FB643E04;
        Thu, 21 Nov 2019 01:27:38 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Nov 2019 01:27:38 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 14/15] scsi: qla2xxx: Add debug dump of LOGO payload and ELS IOCB
Date:   Thu, 21 Nov 2019 01:27:22 +0300
Message-ID: <20191120222723.27779-15-r.bolshakov@yadro.com>
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

The change adds a way to debug LOGO ELS, likewise PLOGI.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 12b37b711ae8..cd2e0f89e9b5 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2627,6 +2627,10 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	memcpy(elsio->u.els_logo.els_logo_pyld, &logo_pyld,
 	    sizeof(struct els_logo_payload));
+	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x3075, "LOGO buffer:");
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x010a,
+		       elsio->u.els_logo.els_logo_pyld,
+		       sizeof(*elsio->u.els_logo.els_logo_pyld));
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
@@ -2704,6 +2708,11 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 		els_iocb->rx_byte_count = 0;
 		els_iocb->rx_address = 0;
 		els_iocb->rx_len = 0;
+		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3076,
+		       "LOGO ELS IOCB:");
+		ql_dump_buffer(ql_log_info, vha, 0x010b,
+			       els_iocb,
+			       sizeof(*els_iocb));
 	}
 
 	sp->vha->qla_stats.control_requests++;
-- 
2.24.0

