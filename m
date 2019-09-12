Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939F8ECDE2A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 00:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F5B020863
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 00:39:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="Vj916aYB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfILAjw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 20:39:52 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:56128 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfILAjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Sep 2019 20:39:52 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C9256412D6;
        Thu, 12 Sep 2019 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1568248789; x=1570063190; bh=j+SNoWf1MLIEmkNaueRpzzYkDBLURdWLyAA
        FbXQYTvs=; b=Vj916aYB9JxDYnztNpXK9f6zrkajZgnpSisVdkbLI227qKqdRru
        //iHLWiY5uxxGaNY0AGc50ZeLgM36fH2lQTHq5Y1BIfirHm7w4nmm+h0xdJh43q6
        2/fohjoRitQlln0DJV0WAoydLz6NveVYQDycFHzZs7zycVrsAzT3au/I=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M0JaIBRoqUAV; Thu, 12 Sep 2019 03:39:49 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3E928435D9;
        Thu, 12 Sep 2019 03:39:49 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 12
 Sep 2019 03:39:48 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qtran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 3/4] scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
Date:   Thu, 12 Sep 2019 03:39:18 +0300
Message-ID: <20190912003919.8488-4-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190912003919.8488-1-r.bolshakov@yadro.com>
References: <20190912003919.8488-1-r.bolshakov@yadro.com>
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
Cc: Quinn Tran <qtran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index bd1d30524de5..13fd617d6b96 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1264,7 +1264,6 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	    "Scheduling sess %p for deletion %8phC\n",
 	    sess, sess->port_name);
 
-	INIT_WORK(&sess->del_work, qla24xx_delete_sess_fn);
 	WARN_ON(!queue_work(sess->vha->hw->wq, &sess->del_work));
 }
 
-- 
2.22.0

