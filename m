Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B7CC33C99
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B253B20857
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="FqePgKZq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfKTW1i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:27:38 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51244 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfKTW1h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 17:27:37 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2EAC243C28;
        Wed, 20 Nov 2019 22:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574288855; x=1576103256; bh=5xqnCLbcYErwmr1sSEDE0GD4w2qgfE9byGK
        cCcbpPJM=; b=FqePgKZq4bBFd1fX7iRRtEu8LbmA6yl/ATljgHA10VAkK5VvImA
        SPxzeSd0a7RS7NUN3nr5HxAjSKQNPZLpe2TJyB/CKiJTtPY1olPweA6Hg/Vkxnh8
        OHEj1v0uM8uQdMMIIOfN5lnMoVjCpjx/ZLXIwJFXlNPk5ShaxDC61WFk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8ZJce0FGBAOv; Thu, 21 Nov 2019 01:27:35 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0414F42F13;
        Thu, 21 Nov 2019 01:27:33 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Nov 2019 01:27:32 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Hannes Reinecke <hare@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 03/15] scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
Date:   Thu, 21 Nov 2019 01:27:11 +0300
Message-ID: <20191120222723.27779-4-r.bolshakov@yadro.com>
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

del_work is already initialized inside qla2x00_alloc_fcport, there's no
need to overwrite it. Indeed, it might prevent complete traversal of
workqueue list.

Fixes: a01c77d2cbc45 ("scsi: qla2xxx: Move session delete to driver work queue")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 7f470a314b1a..ab62fcba8ab3 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1264,7 +1264,6 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	    "Scheduling sess %p for deletion %8phC\n",
 	    sess, sess->port_name);
 
-	INIT_WORK(&sess->del_work, qla24xx_delete_sess_fn);
 	WARN_ON(!queue_work(sess->vha->hw->wq, &sess->del_work));
 }
 
-- 
2.24.0

