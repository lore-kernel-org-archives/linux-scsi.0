From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/4] libsas: Don't BUG when connecting two expanders via wide port
Date: Mon, 29 Jan 2007 23:48:16 -0800
Message-ID: <20070130074816.7612.6444.stgit@elm3a70.beaverton.ibm.com>
References: <20070130074810.7612.31980.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51317 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965428AbXA3Hpp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 02:45:45 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U7jhMN007259
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:43 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U7jigG240098
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:44 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U7jhKm008842
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:43 -0500
In-Reply-To: <20070130074810.7612.31980.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


When a device is connected to an expander, the discovery process goes through
sas_ex_discover_dev to figure out what's attached to the phy.  If it is the
case that the phy being discovered happens to be the second phy of a wide link
to an expander, that discover_dev function will incorrectly call
sas_ex_discover_expander, which creates another sas_port and tries to attach the
other sas_phys to the new port, thus triggering a BUG.  The correct thing to do is
to check the other ex_phys of the expander to see if there's a sas_port for this
sas_phy, and attach the sas_phy to the existing sas_port.

This is easily triggered if one enables the phys of a wide port between
expanders one by one.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_expander.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index d9b9a00..3eeb3fb 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -678,6 +678,29 @@ static struct domain_device *sas_ex_disc
 	return NULL;
 }
 
+/* See if this phy is part of a wide port */
+static int sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
+{
+	struct ex_phy *phy = &parent->ex_dev.ex_phy[phy_id];
+	int i;
+
+	for (i = 0; i < parent->ex_dev.num_phys; i++) {
+		struct ex_phy *ephy = &parent->ex_dev.ex_phy[i];
+
+		if (ephy == phy)
+			continue;
+
+		if (!memcmp(phy->attached_sas_addr, ephy->attached_sas_addr,
+			    SAS_ADDR_SIZE)) {
+			sas_port_add_phy(ephy->port, phy->phy);
+			phy->phy_state = PHY_DEVICE_DISCOVERED;
+			return 0;
+		}
+	}
+
+	return -ENODEV;
+}
+
 static struct domain_device *sas_ex_discover_expander(
 	struct domain_device *parent, int phy_id)
 {
@@ -810,6 +833,13 @@ static int sas_ex_discover_dev(struct do
 		return res;
 	}
 
+	res = sas_ex_join_wide_port(dev, phy_id);
+	if (!res) {
+		SAS_DPRINTK("Attaching ex phy%d to wide port %016llx\n",
+			    phy_id, SAS_ADDR(ex_phy->attached_sas_addr));
+		return res;
+	}
+
 	switch (ex_phy->attached_dev_type) {
 	case SAS_END_DEV:
 		child = sas_ex_discover_end_dev(dev, phy_id);
