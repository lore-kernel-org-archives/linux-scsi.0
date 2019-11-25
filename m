Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF14BC43141
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 16:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8814820740
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 16:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="MtQjJn3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfKYQ5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 11:57:24 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:39672 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728933AbfKYQ5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Nov 2019 11:57:22 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id EC11243E0C;
        Mon, 25 Nov 2019 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574701039; x=1576515440; bh=i1WYTdMFlQbDxvSzgYJdQpMtFEygbtI3iQw
        rxGX27Og=; b=MtQjJn3m+eCaasHWOCDXyly1dpqzHKG7gm13g9V6MeHAcIxico5
        9zmH3SVylmI/8L5S6nlbesH67Wp+MqKEETtC3R6xQfFC/dJXvLuIxCJbje/ihFcW
        /8mGL4NUpZjGPRlsYXmJOfphOalXYCYaORA03lqhK5G3Oh3B5pZH9ajQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UkUFAKFVyoBB; Mon, 25 Nov 2019 19:57:19 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 30C16411FF;
        Mon, 25 Nov 2019 19:57:18 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 25
 Nov 2019 19:57:17 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 11/13] scsi: qla2xxx: Don't defer relogin unconditonally
Date:   Mon, 25 Nov 2019 19:57:00 +0300
Message-ID: <20191125165702.1013-12-r.bolshakov@yadro.com>
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

qla2x00_configure_local_loop sets RELOGIN_NEEDED bit and calls
qla24xx_fcport_handle_login to perform the login. This bit triggers
a wake up of DPC later after a successful login.

The deferred call is not needed if login succeeds, and it's set in
qla24xx_fcport_handle_login in case of errors, hence it should be safe
to drop.

Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Acked-by: Quinn Tran <qutran@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bc3695dc9b9e..31551e8ac5df 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5054,7 +5054,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 				memcpy(&ha->plogi_els_payld.data,
 				    (void *)ha->init_cb,
 				    sizeof(ha->plogi_els_payld.data));
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			} else {
 				ql_dbg(ql_dbg_init, vha, 0x00d1,
 				    "PLOGI ELS param read fail.\n");
-- 
2.24.0

