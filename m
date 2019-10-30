Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012D6CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 16:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0E532190F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572451283;
	bh=da0pw4Wq56u4APoQcdxadqZVOt5YS5u/iJanKGGGwrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gXtvs5Vsn3ivqQ41HlIvsrd6itHctmZc36Dt+YaOwViiCKiysnYbgHEJGrzlNDmU3
	 E2v+T+1h8nvbHgR6FY5EPWnjSqacizTzA9itmezMEV8V7j5SXX1acuwTSM+rLBUR5d
	 5cM+N1vgCHfOQqS6At5D9rY++yFPBP649QbgKiR0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfJ3QBJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 12:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbfJ3Pyq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Oct 2019 11:54:46 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1327C208C0;
        Wed, 30 Oct 2019 15:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450885;
        bh=da0pw4Wq56u4APoQcdxadqZVOt5YS5u/iJanKGGGwrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpaqD8xxpHbnPuInLeHRPXRDSS4ZCmi+fnbTi/QkYgTkuX+OaiYCGkzB6wy3qBr/9
         CdrSrkucrYvkJBHIjUaEaEaB1OW05f4a+e0rY23rBRbYg6gq0O8nuKB6aDudqI63hL
         B6wo6R1VlmgjszZf9MtjR1ns0JwtU0529jx/NsKQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.com>,
        Laurence Oberman <loberman@redhat.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/38] scsi: scsi_dh_alua: handle RTPG sense code correctly during state transitions
Date:   Wed, 30 Oct 2019 11:53:43 -0400
Message-Id: <20191030155406.10109-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

[ Upstream commit b6ce6fb121a655aefe41dccc077141c102145a37 ]

Some arrays are not capable of returning RTPG data during state
transitioning, but rather return an 'LUN not accessible, asymmetric access
state transition' sense code. In these cases we can set the state to
'transitioning' directly and don't need to evaluate the RTPG data (which we
won't have anyway).

Link: https://lore.kernel.org/r/20191007135701.32389-1-hare@suse.de
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 9c21938ed67ed..c95c782b93a53 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -526,6 +526,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 	unsigned long flags;
+	bool transitioning_sense = false;
 
 	if (!pg->expiry) {
 		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
@@ -586,13 +587,19 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			goto retry;
 		}
 		/*
-		 * Retry on ALUA state transition or if any
-		 * UNIT ATTENTION occurred.
+		 * If the array returns with 'ALUA state transition'
+		 * sense code here it cannot return RTPG data during
+		 * transition. So set the state to 'transitioning' directly.
 		 */
 		if (sense_hdr.sense_key == NOT_READY &&
-		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
-			err = SCSI_DH_RETRY;
-		else if (sense_hdr.sense_key == UNIT_ATTENTION)
+		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
+			transitioning_sense = true;
+			goto skip_rtpg;
+		}
+		/*
+		 * Retry on any other UNIT ATTENTION occurred.
+		 */
+		if (sense_hdr.sense_key == UNIT_ATTENTION)
 			err = SCSI_DH_RETRY;
 		if (err == SCSI_DH_RETRY &&
 		    pg->expiry != 0 && time_before(jiffies, pg->expiry)) {
@@ -680,7 +687,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		off = 8 + (desc[7] * 4);
 	}
 
+ skip_rtpg:
 	spin_lock_irqsave(&pg->lock, flags);
+	if (transitioning_sense)
+		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
+
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
 		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
-- 
2.20.1

