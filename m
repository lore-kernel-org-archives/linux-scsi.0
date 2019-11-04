Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E32CA9ED5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3124420656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfKDJCV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:57258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728275AbfKDJCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 79AB1B4C2;
        Mon,  4 Nov 2019 09:02:11 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 49/52] xen-scsiback: stop using DRIVER_ERROR
Date:   Mon,  4 Nov 2019 10:01:48 +0100
Message-Id: <20191104090151.129140-50-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Always return SCSI host byte errors and drop the usage of DRIVER_ERROR
status.
This also fixes an issue where we would return a host byte value
interpreted as a driver byte.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/xen/xen-scsiback.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index e130b4426c62..8e93b7113b26 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -260,10 +260,10 @@ static void scsiback_print_status(char *sense_buffer, int errors,
 {
 	struct scsiback_tpg *tpg = pending_req->v2p->tpg;
 
-	pr_err("[%s:%d] cmnd[0]=%02x -> st=%02x msg=%02x host=%02x drv=%02x\n",
+	pr_err("[%s:%d] cmnd[0]=%02x -> st=%02x msg=%02x host=%02x drv=00\n",
 	       tpg->tport->tport_name, pending_req->v2p->lun,
 	       pending_req->cmnd[0], status_byte(errors), msg_byte(errors),
-	       host_byte(errors), driver_byte(errors));
+	       host_byte(errors));
 }
 
 static void scsiback_fast_flush_area(struct vscsibk_pend *req)
@@ -757,10 +757,10 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 				result = DID_NO_CONNECT;
 				break;
 			default:
-				result = DRIVER_ERROR;
+				result = DID_ERROR;
 				break;
 			}
-			scsiback_send_response(info, NULL, result << 24, 0,
+			scsiback_send_response(info, NULL, result << 16, 0,
 					       ring_req.rqid);
 			return 1;
 		}
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

