Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6218BC33C9E
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 16:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36DAD20740
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 16:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="Kw72wyGA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbfKYQ50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 11:57:26 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:39704 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbfKYQ5Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Nov 2019 11:57:25 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 50F3C43E08;
        Mon, 25 Nov 2019 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574701043; x=1576515444; bh=OpFQvH0z5SrjIFfkQCkdH1dB9eSwdVXe5+C
        Elg/E/JY=; b=Kw72wyGAraT6NDUtEl9s+nLDCmppp4y6N5WrSvo0ovBVkq7I9ML
        urI5FkcRz+IIqoTAeuWHSOUROwyxYfv33Cg6Z1RW67s8FnOdDWydmWbKJU0N6Bqx
        nxNomiFxiM5+iZwTTcng5KfattbtegSURgr4MGzWrI9VQaWU5Jvru4UM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZxozEJzafxGB; Mon, 25 Nov 2019 19:57:23 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 748CB43E0E;
        Mon, 25 Nov 2019 19:57:19 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 25
 Nov 2019 19:57:19 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 13/13] scsi: qla2xxx: Add debug dump of LOGO payload and ELS IOCB
Date:   Mon, 25 Nov 2019 19:57:02 +0300
Message-ID: <20191125165702.1013-14-r.bolshakov@yadro.com>
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

The change adds a way to debug LOGO ELS, likewise PLOGI.

Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Acked-by: Quinn Tran <qutran@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 53ccbd6b71ed..8b050f0b4333 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2625,6 +2625,10 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	memcpy(elsio->u.els_logo.els_logo_pyld, &logo_pyld,
 	    sizeof(struct els_logo_payload));
+	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x3075, "LOGO buffer:");
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x010a,
+		       elsio->u.els_logo.els_logo_pyld,
+		       sizeof(*elsio->u.els_logo.els_logo_pyld));
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
@@ -2697,6 +2701,11 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
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

