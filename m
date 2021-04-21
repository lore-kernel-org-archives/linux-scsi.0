Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A188C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA4761409
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244946AbhDURtQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:49:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:52320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245019AbhDURs7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:48:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 79675B15C;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/42] xen-scsifront: compability status handling
Date:   Wed, 21 Apr 2021 19:47:18 +0200
Message-Id: <20210421174749.11221-12-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
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
 drivers/scsi/xen-scsifront.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 259fc248d06c..fcf4dd70ebc7 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -251,6 +251,7 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
 	struct scsi_cmnd *sc;
 	uint32_t id;
 	uint8_t sense_len;
+	int result;
 
 	id = ring_rsp->rqid;
 	shadow = info->shadow[id];
@@ -261,7 +262,13 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
 	scsifront_gnttab_done(info, shadow);
 	scsifront_put_rqid(info, id);
 
-	sc->result = ring_rsp->rslt;
+	result = ring_rsp->rslt;
+	sc->result = 0;
+	if ((result >> 24) & 0xff)
+		set_host_byte(sc, DID_ERROR);
+	else if (host_byte(result))
+		set_host_byte(sc, host_byte(result));
+	set_status_byte(sc, status_byte(result));
 	scsi_set_resid(sc, ring_rsp->residual_len);
 
 	sense_len = min_t(uint8_t, VSCSIIF_SENSE_BUFFERSIZE,
-- 
2.29.2

