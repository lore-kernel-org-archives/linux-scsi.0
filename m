Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5135EC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 09:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08E1E233A1
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 09:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbhAMJHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 04:07:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:54900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbhAMJHM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Jan 2021 04:07:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3FE98B8F0;
        Wed, 13 Jan 2021 09:05:04 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 31/35] ips: use correct command completion on error
Date:   Wed, 13 Jan 2021 10:04:56 +0100
Message-Id: <20210113090500.129644-32-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113090500.129644-1-hare@suse.de>
References: <20210113090500.129644-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A non-zero queuecommand() return code means 'busy', ie the command
hasn't been submitted. So any command which should be failed need
to be completed via the ->scsi_done() callback with the appropriate
result code set.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ips.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 2e6077c502fc..1a3c534826ba 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1045,10 +1045,10 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 	ha = (ips_ha_t *) SC->device->host->hostdata;
 
 	if (!ha)
-		return (1);
+		goto out_error;
 
 	if (!ha->active)
-		return (DID_ERROR);
+		goto out_error;
 
 	if (ips_is_passthru(SC)) {
 		if (ha->copp_waitlist.count == IPS_MAX_IOCTL_QUEUE) {
@@ -1123,6 +1123,11 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 
 	ips_next(ha, IPS_INTR_IORL);
 
+	return (0);
+out_error:
+	SC->result = DID_ERROR << 16;
+	done(SC);
+
 	return (0);
 }
 
-- 
2.29.2

