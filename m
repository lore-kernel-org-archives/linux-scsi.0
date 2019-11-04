Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B4BCA9EDA
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B27C420656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfKDJCh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:57198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728012AbfKDJCO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99CD7B498;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/52] zfcp: use scsi_build_sense()
Date:   Mon,  4 Nov 2019 10:01:26 +0100
Message-Id: <20191104090151.129140-28-hare@suse.de>
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
 drivers/s390/scsi/zfcp_scsi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 3910d529c15a..120787dfcdca 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -834,10 +834,7 @@ void zfcp_scsi_set_prot(struct zfcp_adapter *adapter)
  */
 void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
 {
-	scsi_build_sense_buffer(1, scmd->sense_buffer,
-				ILLEGAL_REQUEST, 0x10, ascq);
-	set_driver_byte(scmd, DRIVER_SENSE);
-	scmd->result |= SAM_STAT_CHECK_CONDITION;
+	scsi_build_sense(scmd, 1, ILLEGAL_REQUEST, 0x10, ascq);
 	set_host_byte(scmd, DID_SOFT_ERROR);
 }
 
-- 
2.16.4

