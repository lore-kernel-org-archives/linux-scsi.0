From: Swen Schillig <swen.schillig@freenet.de>
Subject: [PATCH] zfcp: Stop system after memory corruption
Date: Mon, 7 May 2007 16:35:04 +0200
Message-ID: <200705071635.04585.swen.schillig@freenet.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout0.freenet.de ([194.97.50.131]:58857 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934007AbXEGOca (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 May 2007 10:32:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

For each request that is sent to the FCP adapter, zfcp allocates
memory. Status information and data that is being read from the
device is written to this memory by the hardware. After that,
the hardware signals this via the response queue and zfcp
continues processing.

Now, if zfcp detects that there is a signal for an incoming
response from the hardware, but there is no outstanding request
for that request id, then some memory that can be in use anywhere
in the system has just been overwritten. This should never happen,
but if it does, stop the system with a panic.


Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_qdio.c |   32 +++++---------------------------
 1 files changed, 5 insertions(+), 27 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_qdio.c linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.c
--- linux-2.6/drivers/s390/scsi/zfcp_qdio.c	2007-05-07 12:47:16.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.c	2007-05-07 12:47:26.000000000 +0200
@@ -285,8 +285,8 @@ zfcp_qdio_request_handler(struct ccw_dev
 /**
  * zfcp_qdio_reqid_check - checks for valid reqids or unsolicited status
  */
-static int zfcp_qdio_reqid_check(struct zfcp_adapter *adapter, 
-				 unsigned long req_id)
+static void zfcp_qdio_reqid_check(struct zfcp_adapter *adapter, 
+				  unsigned long req_id)
 {
 	struct zfcp_fsf_req *fsf_req;
 	unsigned long flags;
@@ -298,9 +298,7 @@ static int zfcp_qdio_reqid_check(struct 

 	if (!fsf_req) {
 		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
-		ZFCP_LOG_NORMAL("error: unknown request id (%ld).\n", req_id);
-		zfcp_erp_adapter_reopen(adapter, 0);
-		return -EINVAL;
+		panic("error: unknown request id (%ld).\n", req_id);
 	}

 	zfcp_reqlist_remove(adapter, req_id);
@@ -309,8 +307,6 @@ static int zfcp_qdio_reqid_check(struct 

 	/* finish the FSF request */
 	zfcp_fsf_req_complete(fsf_req);
-
-	return 0;
 }

 /*
@@ -374,27 +370,9 @@ zfcp_qdio_response_handler(struct ccw_de

 			/* look for QDIO request identifiers in SB */
 			buffere = &buffer->element[buffere_index];
-			retval = zfcp_qdio_reqid_check(adapter,
-					(unsigned long) buffere->addr);
+			zfcp_qdio_reqid_check(adapter,
+					      (unsigned long) buffere->addr);

-			if (retval) {
-				ZFCP_LOG_NORMAL("bug: unexpected inbound "
-						"packet on adapter %s "
-						"(reqid=0x%lx, "
-						"first_element=%d, "
-						"elements_processed=%d)\n",
-						zfcp_get_busid_by_adapter(adapter),
-						(unsigned long) buffere->addr,
-						first_element,
-						elements_processed);
-				ZFCP_LOG_NORMAL("hex dump of inbound buffer "
-						"at address %p "
-						"(buffer_index=%d, "
-						"buffere_index=%d)\n", buffer,
-						buffer_index, buffere_index);
-				ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
-					      (char *) buffer, SBAL_SIZE);
-			}
 			/*
 			 * A single used SBALE per inbound SBALE has been
 			 * implemented by QDIO so far. Hope they will


-------------------------------------------------------
