Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF99C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 09:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49B7611F0
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 09:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbhDKJWA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 05:22:00 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:59519 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbhDKJWA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 05:22:00 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d20 with ME
        id rMMh2400e3g7mfN03MMhju; Sun, 11 Apr 2021 11:21:43 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 11 Apr 2021 11:21:43 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: qla2xxx: Re-use existing error handling path
Date:   Sun, 11 Apr 2021 11:21:40 +0200
Message-Id: <6973844a1532ec2dc8e86f3533362e79d78ed774.1618132821.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need to duplicate some code, use the existing error handling
path to free some resources.
This is more future-proof.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The code above this hunk looks spurious to me.

It looks like an error handling path (i.e.
"if (response_len > bsg_job->reply_payload.payload_len)")
but returns 0, which is the initial value of 'ret'.

Shouldn't we have ret = -<something> here?
---
 drivers/scsi/qla2xxx/qla_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index aef2f7cc89d3..d42b2ad84049 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2585,8 +2585,8 @@ qla2x00_get_host_stats(struct bsg_job *bsg_job)
 
 	data = kzalloc(response_len, GFP_KERNEL);
 	if (!data) {
-		kfree(req_data);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto host_stat_out;
 	}
 
 	ret = qla2xxx_get_ini_stats(fc_bsg_to_shost(bsg_job), req_data->stat_type,
-- 
2.27.0

