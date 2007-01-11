From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 02/21] libsas: Clean up rphys/port dev list after a discovery error on an expander
Date: Thu, 11 Jan 2007 14:14:52 -0800
Message-ID: <20070111221452.3543.43308.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38702 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbXAKWOd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:33 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMEW58014859
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:32 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMEWO8296934
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:32 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMEVEq016582
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:32 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


sas_get_port_device assigns a rphy to a domain device in anticipation
of finding a disk.  When a discovery error occurs in
sas_discover_{sata,sas,expander}*, however, we need to clean up that
rphy and the port device list so that we don't GPF.  In addition, we
need to check the result of the second sas_notify_lldd_dev_found.
This patch seems ok on a x260, x366 and x206m.

This patch fixes up sas_expander.c separately because jejb has some
cleanup patches of his own that are a prerequisite.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_expander.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index d31e6fa..0dfd97e 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -668,7 +668,6 @@ static struct domain_device *sas_ex_disc
 
  out_list_del:
 	list_del(&child->dev_list_node);
-	sas_rphy_free(rphy);
  out_free:
 	sas_port_delete(phy->port);
  out_err:
@@ -1431,14 +1430,27 @@ int sas_discover_root_expander(struct do
 	int res;
 	struct sas_expander_device *ex = rphy_to_expander_device(dev->rphy);
 
-	sas_rphy_add(dev->rphy);
+	res = sas_rphy_add(dev->rphy);
+	if (res)
+		goto out_err;
 
 	ex->level = dev->port->disc.max_level; /* 0 */
 	res = sas_discover_expander(dev);
-	if (!res)
-		sas_ex_bfs_disc(dev->port);
+	if (res)
+		goto out_err2;
+
+	sas_ex_bfs_disc(dev->port);
 
 	return res;
+
+out_err2:
+	sas_rphy_delete(dev->rphy);
+	dev->rphy = NULL;
+	return res;
+out_err:
+	sas_rphy_free(dev->rphy);
+	dev->rphy = NULL;
+	return res;
 }
 
 /* ---------- Domain revalidation ---------- */
