From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] fix BUG when sum(scatterlist) > bufflen
Date: Tue, 05 Feb 2008 10:36:10 -0500
Message-ID: <47A8826A.4040401@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([70.169.137.4]:2420 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYBEPgM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 10:36:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dougg@torque.net>

When sending a SCSI command to a tape drive via the SCSI Generic (sg)
driver, if the command has a data transfer length more than
scatter_elem_sz (32 KB default) and not a multiple of 512, then I either
hit BUG_ON(!valid_dma_direction(direction)) in dma_unmap_sg() or else
the command never completes (depending on the LLDD).

When constructing scatterlists, the sg driver rounds up the scatterlist
element sizes to be a multiple of 512.  This can result in
sum(scatterlist lengths) > bufflen.  In this case, scsi_req_map_sg()
incorrectly sets bio->bi_size to sum(scatterlist lengths) rather than to
bufflen.  When the command completes, req_bio_endio() detects that
bio->bi_size != 0, and so it doesn't call bio_endio().  This causes the
command to be resubmitted, resulting in BUG_ON or the command never
completing.

This patch makes scsi_req_map_sg() set bio->bi_size to bufflen rather
than to sum(scatterlist lengths), which fixes the problem.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.24-git14/drivers/scsi/scsi_lib.c.orig	2008-02-05 09:33:05.000000000 -0500
+++ linux-2.6.24-git14/drivers/scsi/scsi_lib.c	2008-02-05 09:33:10.000000000 -0500
@@ -301,7 +301,6 @@ static int scsi_req_map_sg(struct reques
 		page = sg_page(sg);
 		off = sg->offset;
 		len = sg->length;
- 		data_len += len;
 
 		while (len > 0 && data_len > 0) {
 			/*


