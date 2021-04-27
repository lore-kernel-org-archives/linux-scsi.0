Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB55C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD84E60234
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhD0IcD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:32:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:49442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235140AbhD0Ibv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:31:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4E4A0B024;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/40] xen-scsifront: compability status handling
Date:   Tue, 27 Apr 2021 10:30:19 +0200
Message-Id: <20210427083046.31620-14-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427083046.31620-1-hare@suse.de>
References: <20210427083046.31620-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The Xen guest might run against arbitrary backends, so the driver
might receive a status with driver_byte set. Map these errors
to DID_ERROR to be consistent with recent changes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/xen-scsifront.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 259fc248d06c..ec9d399fbbd8 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -251,6 +251,7 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
 	struct scsi_cmnd *sc;
 	uint32_t id;
 	uint8_t sense_len;
+	int result;
 
 	id = ring_rsp->rqid;
 	shadow = info->shadow[id];
@@ -261,7 +262,12 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
 	scsifront_gnttab_done(info, shadow);
 	scsifront_put_rqid(info, id);
 
-	sc->result = ring_rsp->rslt;
+	result = ring_rsp->rslt;
+	if (result >> 24)
+		set_host_byte(sc, DID_ERROR);
+	else
+		set_host_byte(sc, host_byte(result));
+	set_status_byte(sc, result & 0xff);
 	scsi_set_resid(sc, ring_rsp->residual_len);
 
 	sense_len = min_t(uint8_t, VSCSIIF_SENSE_BUFFERSIZE,
-- 
2.29.2

