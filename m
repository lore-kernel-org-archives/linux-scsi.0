Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B945CA9ED1
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D0D72086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfJaLFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 07:05:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:37440 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727550AbfJaLFd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Oct 2019 07:05:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2C11FB38D;
        Thu, 31 Oct 2019 11:05:28 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/24] xen-scsiback: stop using DRIVER_ERROR
Date:   Thu, 31 Oct 2019 12:04:49 +0100
Message-Id: <20191031110452.73463-22-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191031110452.73463-1-hare@suse.de>
References: <20191031110452.73463-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return DID_ERROR instead of DRIVER_ERROR for internal failures.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/xen/xen-scsiback.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index e130b4426c62..6a12c3627098 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -260,10 +260,10 @@ static void scsiback_print_status(char *sense_buffer, int errors,
 {
 	struct scsiback_tpg *tpg = pending_req->v2p->tpg;
 
-	pr_err("[%s:%d] cmnd[0]=%02x -> st=%02x msg=%02x host=%02x drv=%02x\n",
+	pr_err("[%s:%d] cmnd[0]=%02x -> st=%02x msg=%02x host=%02x drv=0\n",
 	       tpg->tport->tport_name, pending_req->v2p->lun,
 	       pending_req->cmnd[0], status_byte(errors), msg_byte(errors),
-	       host_byte(errors), driver_byte(errors));
+	       host_byte(errors));
 }
 
 static void scsiback_fast_flush_area(struct vscsibk_pend *req)
@@ -757,7 +757,7 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 				result = DID_NO_CONNECT;
 				break;
 			default:
-				result = DRIVER_ERROR;
+				result = DID_ERROR;
 				break;
 			}
 			scsiback_send_response(info, NULL, result << 24, 0,
@@ -770,7 +770,7 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 			if (scsiback_gnttab_data_map(&ring_req, pending_req)) {
 				scsiback_fast_flush_area(pending_req);
 				scsiback_do_resp_with_sense(NULL,
-						DRIVER_ERROR << 24, 0, pending_req);
+						DID_ERROR << 16, 0, pending_req);
 				transport_generic_free_cmd(&pending_req->se_cmd, 0);
 			} else {
 				scsiback_cmd_exec(pending_req);
@@ -785,7 +785,7 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 			break;
 		default:
 			pr_err_ratelimited("invalid request\n");
-			scsiback_do_resp_with_sense(NULL, DRIVER_ERROR << 24, 0,
+			scsiback_do_resp_with_sense(NULL, DID_ERROR << 16, 0,
 						    pending_req);
 			transport_generic_free_cmd(&pending_req->se_cmd, 0);
 			break;
-- 
2.16.4

