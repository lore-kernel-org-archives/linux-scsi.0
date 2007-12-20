From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/6] zfcp: Hold queue lock when checking port handle for ELS command
Date: Thu, 20 Dec 2007 12:30:25 +0100
Message-ID: <20071220113234.234801000@de.ibm.com>
References: <20071220113021.955597000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:27156 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbXLTLcg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 06:32:36 -0500
Content-Disposition: inline; filename=810-zfcp-lock2.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

We need to hold the queue-lock when checking whether we still have a valid port
handle for the ELS command, i.e whether we can issue this request for this
port. If the error recovery is about to close this port, then it competes for
the queue-lock. If the close request issued by the error recovery wins, then it
is guaranteed that this port has been blocked for other requests.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    2 +-
 drivers/s390/scsi/zfcp_fsf.c |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_erp.c	2007-12-20 11:17:46.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2007-12-20 11:18:42.000000000 +0100
@@ -456,7 +456,7 @@ zfcp_test_link(struct zfcp_port *port)
 
 	zfcp_port_get(port);
 	retval = zfcp_erp_adisc(port);
-	if (retval != 0) {
+	if (retval != 0 && retval != -EBUSY) {
 		zfcp_port_put(port);
 		ZFCP_LOG_NORMAL("reopen needed for port 0x%016Lx "
 				"on adapter %s\n ", port->wwpn,
--- a/drivers/s390/scsi/zfcp_fsf.c	2007-12-20 11:18:23.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2007-12-20 11:18:42.000000000 +0100
@@ -1668,6 +1668,12 @@ zfcp_fsf_send_els(struct zfcp_send_els *
                 goto failed_req;
 	}
 
+	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
+			&els->port->status))) {
+		ret = -EBUSY;
+		goto port_blocked;
+	}
+
 	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
         if (zfcp_use_one_sbal(els->req, els->req_count,
                               els->resp, els->resp_count)){
@@ -1749,6 +1755,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 		       "0x%06x)\n", zfcp_get_busid_by_adapter(adapter), d_id);
 	goto out;
 
+ port_blocked:
  failed_send:
 	zfcp_fsf_req_free(fsf_req);
 

-- 
