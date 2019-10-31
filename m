Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BA1CA9ECB
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E77A62086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfJaLFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 07:05:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:37440 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727499AbfJaLFa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Oct 2019 07:05:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 05A69B371;
        Thu, 31 Oct 2019 11:05:28 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/24] st: return error code in st_scsi_execute()
Date:   Thu, 31 Oct 2019 12:04:46 +0100
Message-Id: <20191031110452.73463-19-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191031110452.73463-1-hare@suse.de>
References: <20191031110452.73463-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The callers to st_scsi_execute already checks for negative
return values, so we can drop the use of DRIVER_ERROR and
return the actual error code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/st.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e3266a64a477..5f38369cc62f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -549,7 +549,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 			data_direction == DMA_TO_DEVICE ?
 			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
 	if (IS_ERR(req))
-		return DRIVER_ERROR << 24;
+		return PTR_ERR(req);
 	rq = scsi_req(req);
 	req->rq_flags |= RQF_QUIET;
 
@@ -560,7 +560,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 				      GFP_KERNEL);
 		if (err) {
 			blk_put_request(req);
-			return DRIVER_ERROR << 24;
+			return err;
 		}
 	}
 
-- 
2.16.4

