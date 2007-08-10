From: akpm@linux-foundation.org
Subject: [patch 07/30] Incorrect SCSI transfer length computation from odd sized scsi_execute_async() transfers.
Date: Fri, 10 Aug 2007 14:50:36 -0700
Message-ID: <200708102150.l7ALoaLm011335@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbXHJVv1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:51:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jli@greshamstorage.com

From: Jeremy Linton <jli@greshamstorage.com>

Any function which use scsi_execute_async() and transfers "odd" sized data
that doesn't align correctly with the segment sizes may have its transfer
length padded out to the closest segment size.

For writes, this results in unnecessary data being transfered to the SCSI
target.  For reads, it affects the residual data length being returned to
the application since the residual length will be based on the padded
transfer size rather than the actual request size.

The easiest way to see this is by trying to read using the SG_IO ioctl a
large (>32k) buffer size from a tape device that only has a few bytes of
data stored for the current block.  The resulting resid will generally be
incorrect.

I've fixed this simply by changing scsi_req_map_sg() so that it places the
requested transfer length in rq->data_len rather than the sum of all the sg
segments.

Signed-off-by: Jeremy Linton <jli@greshamstorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~incorrect-scsi-transfer-length-computation-from-odd drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~incorrect-scsi-transfer-length-computation-from-odd
+++ a/drivers/scsi/scsi_lib.c
@@ -355,7 +355,7 @@ static int scsi_req_map_sg(struct reques
 	}
 
 	rq->buffer = rq->data = NULL;
-	rq->data_len = data_len;
+	rq->data_len = bufflen;
 	return 0;
 
 free_bios:
_
