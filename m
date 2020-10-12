Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66DACC43457
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 09:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A8F5208D5
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 09:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgJLJLE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 05:11:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:37740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgJLJLE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Oct 2020 05:11:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0156DB0B7;
        Mon, 12 Oct 2020 09:11:03 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     Nilesh Javali <njavali@marvell.com>, Arun Easi <aeasi@marvell.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] qla2xxx: Return EBUSY on fcport deletion
Date:   Mon, 12 Oct 2020 11:11:00 +0200
Message-Id: <20201012091100.55305-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the fcport is about to be deleted we should return EBUSY instead
of ENODEV. Only for EBUSY the request will be requeued in a multipath
setup.

Also in case we have a valid qpair but the firmware has not yet
started return EBUSY to avoid dropping the request.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Hi,

During port bounce and fail tests we observed that requests get
dropped on a failing path because the driver returned ENODEV and thus
the multipath code didn't requeue the request.

The tests were done with only the 'fcport && fcport->deleted' condition
but Hannes suggested we might as well do the same for 'qpair &&
!qpair->fw_started'.

Thanks,
Daniel

 drivers/scsi/qla2xxx/qla_nvme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 5cc1bbb1ed74..db8b802b147c 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -555,8 +555,11 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 
 	fcport = qla_rport->fcport;
 
-	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
+	if ((qpair && !qpair->fw_started) ||
 	    (fcport && fcport->deleted))
+		return -EBUSY;
+
+	if (!qpair || !fcport)
 		return rval;
 
 	vha = fcport->vha;
-- 
2.16.4

