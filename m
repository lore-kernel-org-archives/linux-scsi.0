Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B37CA9EDC
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A361820656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfKDJCe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:57250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbfKDJCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F521B499;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 31/52] mpt3sas: use scsi_build_sense()
Date:   Mon,  4 Nov 2019 10:01:30 +0100
Message-Id: <20191104090151.129140-32-hare@suse.de>
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a038be8a0e90..6477fb84ac60 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4619,10 +4619,8 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 		ascq = 0x00;
 		break;
 	}
-	scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST, 0x10,
-	    ascq);
-	scmd->result = DRIVER_SENSE << 24 | (DID_ABORT << 16) |
-	    SAM_STAT_CHECK_CONDITION;
+	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x10, ascq);
+	set_host_byte(scmd, DID_ABORT);
 }
 
 /**
-- 
2.16.4

