From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 6/7] fnic: hook scsi eh into fc_block_scsi_eh
Date: Thu, 23 Sep 2010 00:17:24 -0500
Message-ID: <1285219045-14645-7-git-send-email-michaelc@cs.wisc.edu>
References: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab0IWFLl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 01:11:41 -0400
In-Reply-To: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

fnic is calling fc_block_scsi_eh, but it is not passing
up TRANSPORT_FAILED if returned.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/fnic/fnic_scsi.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 198cbab..4cedb37 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1234,13 +1234,16 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	struct fc_rport *rport;
 	spinlock_t *io_lock;
 	unsigned long flags;
-	int ret = SUCCESS;
+	int ret;
 	u32 task_req;
 	struct scsi_lun fc_lun;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
+	ret = fc_block_scsi_eh(sc);
+	if (ret)
+		return ret;
+	ret = SUCCESS;
 
 	/* Get local-port, check ready and link up */
 	lp = shost_priv(sc->device->host);
@@ -1512,13 +1515,16 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	struct fnic_io_req *io_req;
 	struct fc_rport *rport;
 	int status;
-	int ret = FAILED;
+	int ret;
 	spinlock_t *io_lock;
 	unsigned long flags;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
+	ret = fc_block_scsi_eh(sc);
+	if (ret)
+		return ret;
+	ret = FAILED;
 
 	/* Get local-port, check ready and link up */
 	lp = shost_priv(sc->device->host);
@@ -1699,6 +1705,10 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 	struct Scsi_Host *shost = sc->device->host;
 	struct fc_lport *lp = shost_priv(shost);
 
+	/* Wait for rport to unblock */
+	ret = fc_block_scsi_eh(sc);
+	if (ret)
+		return ret;
 	/*
 	 * If fnic_reset is successful, wait for fabric login to complete
 	 * scsi-ml tries to send a TUR to every device if host reset is
-- 
1.7.2.2

