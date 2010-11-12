From: Dan Carpenter <error27@gmail.com>
Subject: [patch] scsi/osd: checking NULL instead of ERR_PTR()
Date: Fri, 12 Nov 2010 07:31:46 +0300
Message-ID: <20101112043146.GC3533@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62355 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0KLEcB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 23:32:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

bio_map_kern() returns ERR_PTRs on failure and never returns NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 0433ea6..b798919 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -951,8 +951,8 @@ static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
 	/* create a bio for continuation segment */
 	bio = bio_map_kern(req_q, or->cdb_cont.buff, or->cdb_cont.total_bytes,
 			   GFP_KERNEL);
-	if (unlikely(!bio))
-		return -ENOMEM;
+	if (unlikely(IS_ERR(bio)))
+		return PTR_ERR(bio);
 
 	bio->bi_rw |= REQ_WRITE;
 
