Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5434BC432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A78120872
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="FR+oUiNf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKTW1k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:27:40 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51266 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbfKTW1j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 17:27:39 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 23E4942F10;
        Wed, 20 Nov 2019 22:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574288857; x=1576103258; bh=Sq70+y2s2skbF9xcugbCIin3cT80GZmW4Cl
        HUd8/nUw=; b=FR+oUiNfvRy337nS9DdraG1yBe1nnoamMhHY7Zkrv92Vc2T6AqE
        aNF+p72NiKjIwfQzno2HAM2ch/kPvd3SCqGef6+lS4CzG6NrQFREdr07DSofWrGF
        r1hr8KK+RfLmdOWzYwvcGHhmE4pn2+P4JSLe4zwqNGbN7X9FOyh7UAdQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K9Lp-AMPaDlQ; Thu, 21 Nov 2019 01:27:37 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8FD95438D1;
        Thu, 21 Nov 2019 01:27:34 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Nov 2019 01:27:34 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 06/15] scsi: qla2xxx: Don't call qlt_async_event twice
Date:   Thu, 21 Nov 2019 01:27:14 +0300
Message-ID: <20191120222723.27779-7-r.bolshakov@yadro.com>
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

MBA_PORT_UPDATE generates duplicate log lines in target mode because
qlt_async_event is called twice. Drop the calls within the case as
the function will be called right after the switch statement.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1b8f297449cf..c6274178b0b0 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1061,8 +1061,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			ql_dbg(ql_dbg_async, vha, 0x5011,
 			    "Asynchronous PORT UPDATE ignored %04x/%04x/%04x.\n",
 			    mb[1], mb[2], mb[3]);
-
-			qlt_async_event(mb[0], vha, mb);
 			break;
 		}
 
@@ -1079,8 +1077,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(VP_CONFIG_OK, &vha->vp_flags);
-
-		qlt_async_event(mb[0], vha, mb);
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
-- 
2.24.0

