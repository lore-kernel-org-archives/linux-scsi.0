From: Brian King <brking@us.ibm.com>
Subject: [PATCH] Make retries obey host_self_blocked flag #2
Date: Thu, 05 Feb 2004 16:49:48 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4022C88C.3000804@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060707030408060502000607"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:50077 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S267040AbUBEWtw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2004 17:49:52 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id i15MnnwX273308
	for <linux-scsi@vger.kernel.org>; Thu, 5 Feb 2004 17:49:49 -0500
Received: from us.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i15MnmLU124828
	for <linux-scsi@vger.kernel.org>; Thu, 5 Feb 2004 15:49:49 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060707030408060502000607
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Lets try this again, this time with the patch attached....

The following patch against 2.6.2 will prevent the midlayer from
issuing retries if host_self_blocked is set. This was raised as an
issue here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=107357742430401&w=2

I'm trying to improve and extend scsi_block_requests, and this is
the first, and hopefully least controversial, step.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------060707030408060502000607
Content-Type: text/plain;
 name="patch-2.6.2-scsi_retries"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-2.6.2-scsi_retries"

diff -Naur linux-2.6.2/drivers/scsi/scsi.c linux-2.6.2-block_req/drivers/scsi/scsi.c
--- linux-2.6.2/drivers/scsi/scsi.c	Wed Feb  4 14:20:59 2004
+++ linux-2.6.2-block_req/drivers/scsi/scsi.c	Thu Feb  5 14:21:19 2004
@@ -784,7 +784,7 @@
          */
 	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
 
-	return scsi_dispatch_cmd(cmd);
+	return scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
 }
 
 /*

--------------060707030408060502000607--

