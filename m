From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] libsas: SMP request handler shouldn't crash when rphy is NULL
Date: Tue, 24 Jul 2007 09:33:49 -0700
Message-ID: <20070724163349.GE19586@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60578 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbXGXQdF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 12:33:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org

sas_smp_handler crashes when smp utils are used with an aic94xx host
because certain devices (the sas_host itself, specifically) lack rphy
structures.  No rphy means no SMP target support, but we shouldn't crash
here.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_expander.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index b500f0c..8603ae6 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1879,7 +1879,7 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		    struct request *req)
 {
 	struct domain_device *dev;
-	int ret, type = rphy->identify.device_type;
+	int ret, type;
 	struct request *rsp = req->next_rq;
 
 	if (!rsp) {
@@ -1888,12 +1888,13 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		return -EINVAL;
 	}
 
-	/* seems aic94xx doesn't support */
+	/* no rphy means no smp target support (ie aic94xx host) */
 	if (!rphy) {
 		printk("%s: can we send a smp request to a host?\n",
 		       __FUNCTION__);
 		return -EINVAL;
 	}
+	type = rphy->identify.device_type;
 
 	if (type != SAS_EDGE_EXPANDER_DEVICE &&
 	    type != SAS_FANOUT_EXPANDER_DEVICE) {
