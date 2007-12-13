From: michaelc@cs.wisc.edu
Subject: [PATCH 15/24] Drop host lock in queuecommand
Date: Thu, 13 Dec 2007 12:43:34 -0600
Message-ID: <11975714441250-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
 <11975714303190-git-send-email-michaelc@cs.wisc.edu>
 <11975714323427-git-send-email-michaelc@cs.wisc.edu>
 <11975714333916-git-send-email-michaelc@cs.wisc.edu>
 <11975714342353-git-send-email-michaelc@cs.wisc.edu>
 <1197571435692-git-send-email-michaelc@cs.wisc.edu>
 <119757143673-git-send-email-michaelc@cs.wisc.edu>
 <11975714363904-git-send-email-michaelc@cs.wisc.edu>
 <11975714372848-git-send-email-michaelc@cs.wisc.edu>
 <11975714382641-git-send-email-michaelc@cs.wisc.edu>
 <11975714404116-git-send-email-michaelc@cs.wisc.edu>
 <11975714413336-git-send-email-michaelc@cs.wisc.edu>
 <1197571442630-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759461AbXLMSoI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:08 -0500
In-Reply-To: <1197571442630-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The driver does not need the host lock in queuecommand so drop it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4461317..b0bc8c3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1010,8 +1010,9 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	sc->SCp.ptr = NULL;
 
 	host = sc->device->host;
-	session = iscsi_hostdata(host->hostdata);
+	spin_unlock(host->host_lock);
 
+	session = iscsi_hostdata(host->hostdata);
 	spin_lock(&session->lock);
 
 	/*
@@ -1077,11 +1078,13 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	spin_unlock(&session->lock);
 
 	scsi_queue_work(host, &conn->xmitwork);
+	spin_lock(host->host_lock);
 	return 0;
 
 reject:
 	spin_unlock(&session->lock);
 	debug_scsi("cmd 0x%x rejected (%d)\n", sc->cmnd[0], reason);
+	spin_lock(host->host_lock);
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 fault:
@@ -1091,6 +1094,7 @@ fault:
 	sc->result = (DID_NO_CONNECT << 16);
 	scsi_set_resid(sc, scsi_bufflen(sc));
 	sc->scsi_done(sc);
+	spin_lock(host->host_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
-- 
1.5.1.2

