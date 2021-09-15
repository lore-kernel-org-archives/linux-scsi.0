Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18CCC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 15:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D083C60F6D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 15:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbhIOPeM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 11:34:12 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:58952 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234384AbhIOPeK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Sep 2021 11:34:10 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 97F5442C8E;
        Wed, 15 Sep 2021 15:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1631719969; x=
        1633534370; bh=FanKdqwfnOYLXj6dyJoSBa87nCY7yxaAXNoVnmVqsU0=; b=V
        putEZeKsMfhS8TFQKsISjprmAAFnMD81vSud/wHj5X03SoYq7gAd9JxOXHvNLdzw
        mRVASz9lVmbbrw0CbKxrizLNuDc4Piz7WMdJ1ka8JGWLZVGwOHphfOu8e3OscLI3
        /eCAjwh0HpzinmAlX7wKk6Kb+unHkMZXTb4RQoNJzg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EDeqFjUW0Ju7; Wed, 15 Sep 2021 18:32:49 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8FD6E42C4A;
        Wed, 15 Sep 2021 18:32:46 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.185) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 15 Sep 2021 18:32:45 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH] scsi: qla2xxx: restore initiator in dual mode
Date:   Wed, 15 Sep 2021 18:32:39 +0300
Message-ID: <20210915153239.8035-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.185]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In dual mode in case of disabling the target, the whole port goes offline
and Initiator is turned off too.

This patch fixes restoring Initiator mode after disabling Target in dual mode.

Fixes: 0645cb8350cd ("scsi: qla2xxx: Add mode control for each physical port")
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
This patchset is intended for scsi-fix.
---
 drivers/scsi/qla2xxx/qla_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1e4e3e83b5c7..5fc7697f0af4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7169,7 +7169,8 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 				return 0;
 			break;
 		case QLA2XXX_INI_MODE_DUAL:
-			if (!qla_dual_mode_enabled(vha))
+			if (!qla_dual_mode_enabled(vha) &&
+			    !qla_ini_mode_enabled(vha))
 				return 0;
 			break;
 		case QLA2XXX_INI_MODE_ENABLED:
-- 
2.25.1

