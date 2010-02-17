From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/11] zfcp: Remove two FIXME comments
Date: Wed, 17 Feb 2010 11:18:51 +0100
Message-ID: <20100217102018.282212000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.17.167]:57272 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0BQKUV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:21 -0500
Content-Disposition: inline; filename=702-zfcp-fixme.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

On a link down, the adapter reopen is not strictly necessary, but it
helps flushing pending requests as quickly as possible. Add a comment
mentioning this.

qdio returning a problem on the response queue is an unlikely event.
The recovery mentioned in the comment might resolve it, so implement
it. This also has the advantage that it creates an entry in the
recovery trace to see if and when this is occurring.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c  |    2 +-
 drivers/s390/scsi/zfcp_qdio.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:29.000000000 +0100
@@ -394,7 +394,7 @@ static void zfcp_fsf_protstatus_eval(str
 	case FSF_PROT_LINK_DOWN:
 		zfcp_fsf_link_down_info_eval(req, "fspse_5",
 					     &psq->link_down_info);
-		/* FIXME: reopening adapter now? better wait for link up */
+		/* go through reopen to flush pending requests */
 		zfcp_erp_adapter_reopen(adapter, 0, "fspse_6", req);
 		break;
 	case FSF_PROT_REEST_QUEUE:
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_qdio.c linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.c
--- linux-2.6/drivers/s390/scsi/zfcp_qdio.c	2010-02-16 09:43:26.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.c	2010-02-16 09:43:29.000000000 +0100
@@ -106,7 +106,7 @@ static void zfcp_qdio_resp_put_back(stru
 
 	if (unlikely(retval)) {
 		atomic_set(&queue->count, count);
-		/* FIXME: Recover this with an adapter reopen? */
+		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdrpb_1", NULL);
 	} else {
 		queue->first += count;
 		queue->first %= QDIO_MAX_BUFFERS_PER_Q;

