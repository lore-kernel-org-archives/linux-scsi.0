From: Mike Christie <mikenc@us.ibm.com>
Subject: [PATCH] fix leftover bytes calculation
Date: Thu, 11 Mar 2004 15:54:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4050FC4D.4060002@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040000050600070907030603"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:1009 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261844AbUCKXy4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 18:54:56 -0500
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e1.ny.us.ibm.com (8.12.10/NS PXFA) with ESMTP id i2BNstjs447954
	for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2004 18:54:55 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i2BNsrfp119874
	for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2004 18:54:54 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040000050600070907030603
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

If there are leftovers __end_that_request_first will call
blk_recalc_rq_sector to set req->hard_nr_sectors correctly.
For failfast, by subtracting bytes from the updated
req->hard_nr_sectors and then calling end_that_request_chunk
and end_that_request_last, you can end up with a bio that
never gets completed.

The attached patch built against 2.6.4 does not subtract
bytes for non-blk_pc_requests.


On a related note I was wondering if the following is a
bug or feature. At the bottom of scsi_io_completion, it calls
scsi_end_request on the bytes for the current buffer.
The comments indicate this is to handle improperly reported
medium errors, but commands scsi_decide_disposition
determined should not be retried end up getting
requeued minus the current buffer.

Thanks

Mike Christie

--------------040000050600070907030603
Content-Type: text/plain;
 name="calc-leftover.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="calc-leftover.patch"

--- linux-2.6.4-work/drivers/scsi/scsi_lib.c	2004-03-10 18:55:27.000000000 -0800
+++ linux-2.6.4-scsi/drivers/scsi/scsi_lib.c	2004-03-11 15:25:11.722261524 -0800
@@ -504,7 +504,7 @@ static struct scsi_cmnd *scsi_end_reques
 	 * to queue the remainder of them.
 	 */
 	if (end_that_request_chunk(req, uptodate, bytes)) {
-		int leftover = (req->hard_nr_sectors << 9) - bytes;
+		int leftover = req->hard_nr_sectors << 9;
 
 		if (blk_pc_request(req))
 			leftover = req->data_len - bytes;

--------------040000050600070907030603--

