From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/4 v2] libsas: Don't BUG when connecting two expanders via
 wide port
Date: Tue, 30 Jan 2007 12:07:27 -0800
Message-ID: <45BFA57F.5020408@us.ibm.com>
References: <20070130074810.7612.31980.stgit@elm3a70.beaverton.ibm.com> <20070130074816.7612.6444.stgit@elm3a70.beaverton.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:45815 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXA3UH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2007 15:07:29 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0UK7Sru019167
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 15:07:28 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0UK7SBD235912
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 13:07:28 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0UK7SNt018211
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 13:07:28 -0700
In-Reply-To: <20070130074816.7612.6444.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, alexisb@us.ibm.com

libsas: Don't BUG when connecting two expanders via wide port

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

This second version of the patch fixes a small regression in the case where
all the phys show up at once and we accidentally try to attach to a port
that hasn't been created yet.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_expander.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 114e26c..2f3b8e1 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -736,6 +736,29 @@ static struct domain_device *sas_ex_disc
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
+			    SAS_ADDR_SIZE) && ephy->port) {
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
@@ -868,6 +891,13 @@ static int sas_ex_discover_dev(struct do
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

