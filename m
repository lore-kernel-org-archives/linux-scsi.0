Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A2DC47420
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 08:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00DCB2076E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 08:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgI3IDD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 04:03:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:60978 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbgI3IDC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 04:03:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 72F19AFB0;
        Wed, 30 Sep 2020 08:03:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] scsi_dh_alua: set 'transitioning' state on unit attention
Date:   Wed, 30 Sep 2020 10:02:55 +0200
Message-Id: <20200930080256.90964-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200930080256.90964-1-hare@suse.de>
References: <20200930080256.90964-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We should be setting the 'transitioning' ALUA state once we get
a unit attention indicating the array is in transitioning.
There are arrays which cannot respond to an rtpg while in transitioning,
and others have issues correctly reporting the state.
So better to set the state during unit attention handling and wait
for TUR / RTPG to run its course.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a68222e324e9..ea436a14087f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -408,12 +408,20 @@ static char print_alua_state(unsigned char state)
 static int alua_check_sense(struct scsi_device *sdev,
 			    struct scsi_sense_hdr *sense_hdr)
 {
+	struct alua_dh_data *h = sdev->handler_data;
+	struct alua_port_group *pg;
+
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
 			/*
 			 * LUN Not Accessible - ALUA state transition
 			 */
+			rcu_read_lock();
+			pg = rcu_dereference(h->pg);
+			if (pg)
+				pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
+			rcu_read_unlock();
 			alua_check(sdev, false);
 			return NEEDS_RETRY;
 		}
-- 
2.16.4

