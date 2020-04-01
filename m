Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D88C43331
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 09:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C46D82077D
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 09:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbgDAJBg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Apr 2020 05:01:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:33312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgDAJBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Apr 2020 05:01:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 985CDAB64;
        Wed,  1 Apr 2020 09:01:33 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>, Hannes Reinecke <hare@suse.com>,
        Saurav Kashyap <skashyap@marvell.com>
Subject: [PATCH] scsi: qedf: Simplify mutex_unlock() usage
Date:   Wed,  1 Apr 2020 11:01:20 +0200
Message-Id: <20200401090120.24958-1-dwagner@suse.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The commit 6d1368e8f987 ("scsi: qedf: fixup locking in
qedf_restart_rport()") introduced the lock. Though the lock protects
only the fc_rport_create() call. Thus, we can move the mutex unlock up
before the if statement.

Cc: Hannes Reinecke <hare@suse.com>
Cc: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qedf/qedf_els.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index 87e169dcebdb..c60eede92145 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -388,12 +388,11 @@ void qedf_restart_rport(struct qedf_rport *fcport)
 		mutex_lock(&lport->disc.disc_mutex);
 		/* Recreate the rport and log back in */
 		rdata = fc_rport_create(lport, port_id);
+		mutex_unlock(&lport->disc.disc_mutex);
 		if (rdata) {
-			mutex_unlock(&lport->disc.disc_mutex);
 			fc_rport_login(rdata);
 			fcport->rdata = rdata;
 		} else {
-			mutex_unlock(&lport->disc.disc_mutex);
 			fcport->rdata = NULL;
 		}
 	}
-- 
2.26.0

