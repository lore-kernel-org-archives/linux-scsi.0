Return-Path: <SRS0=Nn94=DV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B76C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Oct 2020 07:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B76920878
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Oct 2020 07:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgJNHa4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Oct 2020 03:30:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:49336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgJNHaz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Oct 2020 03:30:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EB916AD6B;
        Wed, 14 Oct 2020 07:30:53 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     Nilesh Javali <njavali@marvell.com>, Arun Easi <aeasi@marvell.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v4] qla2xxx: Return EBUSY on fcport deletion
Date:   Wed, 14 Oct 2020 09:30:48 +0200
Message-Id: <20201014073048.36219-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the fcport is about to be deleted we should return EBUSY instead
of ENODEV. Only for EBUSY the request will be requeued in a multipath
setup.

Also when the firmware has not yet started return EBUSY to avoid
dropping the request.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Arun Easi <aeasi@marvell.com>
---

v4: updated commit message as suggested by Finn
v3: simplify and changed test logic as suggested by Arun
v2: rebased on mkp/staging

 drivers/scsi/qla2xxx/qla_nvme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 2cd9bd288910..1fa457a5736e 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -555,10 +555,12 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 
 	fcport = qla_rport->fcport;
 
-	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
-	    (fcport && fcport->deleted))
+	if (!qpair || !fcport)
 		return -ENODEV;
 
+	if (!qpair->fw_started || fcport->deleted)
+		return -EBUSY;
+
 	vha = fcport->vha;
 
 	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
-- 
2.16.4

