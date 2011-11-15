From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH] mpt2sas: Fix for data corruption issue in the routine
 sd_prep_fn
Date: Tue, 15 Nov 2011 14:11:35 +0530
Message-ID: <201111151447.pAFElZhR029655@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:58409 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755843Ab1KOOrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2011 09:47:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Fix for data corruption issue in the routine sd_prep_fn which can
occur for 4kb sector support.

The issue is that, the routine sd_prep_fn is sharing the same parameter called
this_count for setting the LBA count and the underflow. When this routine
converts this_count so the LBA count is in 4kb units, it is not converted back 
to 512 bytes units when setting the underflow. Thus underflow is off by a 
multiple of 8.   

This patch will set the underflow to the data transfer size in bytes.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Cc: stable@kernel.org
---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c 
index fa3a591..3c4ad14 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -895,7 +895,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	 * this many bytes between each connect / disconnect.
 	 */
 	SCpnt->transfersize = sdp->sector_size;
-	SCpnt->underflow = this_count << 9;
+	SCpnt->underflow = blk_rq_bytes(rq);
 	SCpnt->allowed = SD_MAX_RETRIES;
 
 	/*

