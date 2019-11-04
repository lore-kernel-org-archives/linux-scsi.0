Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D405CA9ED6
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DA3620656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfKDJC2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:57320 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728329AbfKDJCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 78FE3B4C1;
        Mon,  4 Nov 2019 09:02:11 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 37/52] scsi_debug: use scsi_build_sense()
Date:   Mon,  4 Nov 2019 10:01:36 +0100
Message-Id: <20191104090151.129140-38-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_build_sense() to format the sense code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_debug.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d323523f5f9d..72f10e631ff4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -779,7 +779,7 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
 	}
 	asc = c_d ? INVALID_FIELD_IN_CDB : INVALID_FIELD_IN_PARAM_LIST;
 	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
-	scsi_build_sense_buffer(sdebug_dsense, sbuff, ILLEGAL_REQUEST, asc, 0);
+	scsi_build_sense(scp, sdebug_dsense, ILLEGAL_REQUEST, asc, 0);
 	memset(sks, 0, sizeof(sks));
 	sks[0] = 0x80;
 	if (c_d)
@@ -805,17 +805,14 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
 
 static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
 {
-	unsigned char *sbuff;
-
-	sbuff = scp->sense_buffer;
-	if (!sbuff) {
+	if (!scp->sense_buffer) {
 		sdev_printk(KERN_ERR, scp->device,
 			    "%s: sense_buffer is NULL\n", __func__);
 		return;
 	}
-	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
+	memset(scp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
-	scsi_build_sense_buffer(sdebug_dsense, sbuff, key, asc, asq);
+	scsi_build_sense(scp, sdebug_dsense, key, asc, asq);
 
 	if (sdebug_verbose)
 		sdev_printk(KERN_INFO, scp->device,
-- 
2.16.4

