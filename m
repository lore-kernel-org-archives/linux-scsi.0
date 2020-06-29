Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6EEC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A77C020672
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389029AbgF2Uev (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:34:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:59454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732198AbgF2TVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 15:21:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 58D87B0BA;
        Mon, 29 Jun 2020 07:20:56 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/22] snic: check for started requests in snic_hba_reset_cmpl_handler()
Date:   Mon, 29 Jun 2020 09:20:13 +0200
Message-Id: <20200629072021.9864-15-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200629072021.9864-1-hare@suse.de>
References: <20200629072021.9864-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

snic_hba_reset_cmpl_handler() is using scsi_host_find_tag() to
map id to a scsi command. However, as per discussion on the mailinglist
scsi_host_find_tag() might return a non-started request, so we need
to check the returned command with blk_mq_request_started() to avoid
the function tripping over a non-initialized command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/snic/snic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 9f9a497beb5c..b000a926e194 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -1020,7 +1020,7 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	}
 
 	sc = scsi_host_find_tag(snic->shost, cmnd_id);
-	if (!sc) {
+	if (!sc || !blk_mq_request_started(sc->request)) {
 		atomic64_inc(&snic->s_stats.io.sc_null);
 		SNIC_HOST_ERR(snic->shost,
 			      "reset_cmpl: sc is NULL - Hdr Stat %s Tag 0x%x\n",
-- 
2.16.4

