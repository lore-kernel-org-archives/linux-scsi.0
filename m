From: Dan Williams <dan.j.williams@intel.com>
Subject: [set3 PATCH 3/6] libsas: fix sas_discover_devices return code
 handling
Date: Thu, 21 Jun 2012 23:36:20 -0700
Message-ID: <20120622063620.21332.68813.stgit@dwillia2-linux.jf.intel.com>
References: <20120622063604.21332.39275.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55287 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761222Ab2FVGTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:19:43 -0400
In-Reply-To: <20120622063604.21332.39275.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Melnic <dan.melnic@amd.com>, stable@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Lindar Liu <lindar_liu@usish.com>, Kevin Ao <aoqingyun@usish.com>, Tom Peng <tom_peng@usish.com>

commit 198439e4 [SCSI] libsas: do not set res = 0 in sas_ex_discover_dev()
commit 19252de6 [SCSI] libsas: fix wide port hotplug issues

The above commits seem to have confused the return value of
sas_ex_discover_dev which is non-zero on failure and
sas_ex_join_wide_port which just indicates short circuiting discovery on
already established ports.  The result is random discovery failures
depending on configuration.

Calls to sas_ex_join_wide_port are the source of the trouble as its
return value is errantly assigned to 'res'.  Convert it to bool and stop
returning its result up the stack.

Cc: Tom Peng <tom_peng@usish.com>
Cc: Jack Wang <jack_wang@usish.com>
Cc: Lindar Liu <lindar_liu@usish.com>
Cc: Kevin Ao <aoqingyun@usish.com>
Cc: <stable@vger.kernel.org>
Tested-by: Dan Melnic <dan.melnic@amd.com>
Reported-by: Dan Melnic <dan.melnic@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |   39 +++++++++++-------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 63c5742..879dbbe 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -868,7 +868,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 }
 
 /* See if this phy is part of a wide port */
-static int sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
+static bool sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
 {
 	struct ex_phy *phy = &parent->ex_dev.ex_phy[phy_id];
 	int i;
@@ -884,11 +884,11 @@ static int sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
 			sas_port_add_phy(ephy->port, phy->phy);
 			phy->port = ephy->port;
 			phy->phy_state = PHY_DEVICE_DISCOVERED;
-			return 0;
+			return true;
 		}
 	}
 
-	return -ENODEV;
+	return false;
 }
 
 static struct domain_device *sas_ex_discover_expander(
@@ -1030,8 +1030,7 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 		return res;
 	}
 
-	res = sas_ex_join_wide_port(dev, phy_id);
-	if (!res) {
+	if (sas_ex_join_wide_port(dev, phy_id)) {
 		SAS_DPRINTK("Attaching ex phy%d to wide port %016llx\n",
 			    phy_id, SAS_ADDR(ex_phy->attached_sas_addr));
 		return res;
@@ -1077,8 +1076,7 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 			if (SAS_ADDR(ex->ex_phy[i].attached_sas_addr) ==
 			    SAS_ADDR(child->sas_addr)) {
 				ex->ex_phy[i].phy_state= PHY_DEVICE_DISCOVERED;
-				res = sas_ex_join_wide_port(dev, i);
-				if (!res)
+				if (sas_ex_join_wide_port(dev, i))
 					SAS_DPRINTK("Attaching ex phy%d to wide port %016llx\n",
 						    i, SAS_ADDR(ex->ex_phy[i].attached_sas_addr));
 
@@ -1943,32 +1941,20 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy_id];
 	struct domain_device *child;
-	bool found = false;
-	int res, i;
+	int res;
 
 	SAS_DPRINTK("ex %016llx phy%d new device attached\n",
 		    SAS_ADDR(dev->sas_addr), phy_id);
 	res = sas_ex_phy_discover(dev, phy_id);
 	if (res)
-		goto out;
-	/* to support the wide port inserted */
-	for (i = 0; i < dev->ex_dev.num_phys; i++) {
-		struct ex_phy *ex_phy_temp = &dev->ex_dev.ex_phy[i];
-		if (i == phy_id)
-			continue;
-		if (SAS_ADDR(ex_phy_temp->attached_sas_addr) ==
-		    SAS_ADDR(ex_phy->attached_sas_addr)) {
-			found = true;
-			break;
-		}
-	}
-	if (found) {
-		sas_ex_join_wide_port(dev, phy_id);
+		return res;
+
+	if (sas_ex_join_wide_port(dev, phy_id))
 		return 0;
-	}
+
 	res = sas_ex_discover_devices(dev, phy_id);
-	if (!res)
-		goto out;
+	if (res)
+		return res;
 	list_for_each_entry(child, &dev->ex_dev.children, siblings) {
 		if (SAS_ADDR(child->sas_addr) ==
 		    SAS_ADDR(ex_phy->attached_sas_addr)) {
@@ -1978,7 +1964,6 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 			break;
 		}
 	}
-out:
 	return res;
 }
 

