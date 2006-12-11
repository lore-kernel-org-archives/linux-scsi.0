From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] scsi_transport_spi: fix sense buffer size error
Date: Mon, 11 Dec 2006 09:47:06 -0600
Message-ID: <1165852026.2791.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50515 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936679AbWLKPrJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2006 10:47:09 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id kBBFl7x24999
	for <linux-scsi@vger.kernel.org>; Mon, 11 Dec 2006 10:47:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The code does this:

unsigned char sense[SCSI_SENSE_BUFFERSIZE];
...
scsi_normalize_sense(sense, sizeof(*sense), sshdr)

however the sizeof will return 1 not 96 which means the sense data will
have no valid ASC/ASCQ values.  Fix by putting the correct sense size.
The only affected case for this would have been the DV buffer sanity
check failure, which is fortunately quite rare.

James

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 3fded48..014d7fe 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -122,7 +122,7 @@ static int spi_execute(struct scsi_devic
 			if (!sshdr)
 				sshdr = &sshdr_tmp;
 
-			if (scsi_normalize_sense(sense, sizeof(*sense),
+			if (scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
 						 sshdr)
 			    && sshdr->sense_key == UNIT_ATTENTION)
 				continue;


