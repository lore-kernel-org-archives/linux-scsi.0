From: michaelc@cs.wisc.edu
Subject: [PATCH 2/6] cxgb3i: check for setup netdev
Date: Wed, 10 Feb 2010 16:51:44 -0600
Message-ID: <1265842308-2051-3-git-send-email-michaelc@cs.wisc.edu>
References: <1265842308-2051-1-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0BJWuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 17:50:05 -0500
In-Reply-To: <1265842308-2051-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the netdev has not been setup when the host is, we
    will oops when the iscsi layer calls into the driver
    and a it tries to reference the netdev in hba->ndev.

    This can happen if the iscsi driver is loaded before
    ifup is done. This patch just adds a check, so we
    can gracefully fail the operation.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index 1fd89b2..412853c 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -708,6 +708,12 @@ static int cxgb3i_host_set_param(struct Scsi_Host *shost,
 {
 	struct cxgb3i_hba *hba = iscsi_host_priv(shost);
 
+	if (!hba->ndev) {
+		shost_printk(KERN_ERR, shost, "Could not set host param. "
+			     "Netdev for host not set.\n");
+		return -ENODEV;
+	}
+
 	cxgb3i_api_debug("param %d, buf %s.\n", param, buf);
 
 	switch (param) {
@@ -738,6 +744,12 @@ static int cxgb3i_host_get_param(struct Scsi_Host *shost,
 	struct cxgb3i_hba *hba = iscsi_host_priv(shost);
 	int len = 0;
 
+	if (!hba->ndev) {
+		shost_printk(KERN_ERR, shost, "Could not set host param. "
+			     "Netdev for host not set.\n");
+		return -ENODEV;
+	}
+
 	cxgb3i_api_debug("hba %s, param %d.\n", hba->ndev->name, param);
 
 	switch (param) {
-- 
1.6.6

