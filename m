From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH scsi-misc-2.6] scsi_debug testing patch, return LUN 0 with PQ 3
Date: Tue, 30 Aug 2005 15:45:49 -0700
Message-ID: <20050830224549.GA11242@us.ibm.com>
References: <20050830224316.GA11210@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:60635 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S932204AbVH3Wpw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 18:45:52 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7UMjpot212868
	for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 18:45:51 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7UMjp2L440858
	for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 16:45:51 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7UMjogY008234
	for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 16:45:50 -0600
Content-Disposition: inline
In-Reply-To: <20050830224316.GA11210@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Just a patch for scanning with PQ == 3 for LUN 0, only for use in testing
previous patch, don't apply.

diff -uprN -X /home/patman/dontdiff scsi-misc-2.6/drivers/scsi/scsi_debug.c lun0-replun-scsi-misc-2.6/drivers/scsi/scsi_debug.c
--- scsi-misc-2.6/drivers/scsi/scsi_debug.c	2005-07-26 11:08:51.000000000 -0700
+++ lun0-replun-scsi-misc-2.6/drivers/scsi/scsi_debug.c	2005-07-27 18:24:05.000000000 -0700
@@ -619,7 +619,10 @@ static int resp_inquiry(struct scsi_cmnd
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
 	memset(arr, 0, SDEBUG_MAX_INQ_ARR_SZ);
-	pq_pdt = (scsi_debug_ptype & 0x1f);
+	if (devip->lun == 0)
+		pq_pdt = 0x7f;
+	else
+		pq_pdt = (scsi_debug_ptype & 0x1f);
 	arr[0] = pq_pdt;
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
