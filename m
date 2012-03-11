From: Dan Williams <dan.j.williams@intel.com>
Subject: [libsas PATCH v10 8/9] libsas: fix sas_find_bcast_phy() in the
 presence of 'vacant' phys
Date: Sat, 10 Mar 2012 20:39:37 -0800
Message-ID: <20120311043937.27797.51913.stgit@dwillia2-linux.jf.intel.com>
References: <20120311043722.27797.97791.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120311043722.27797.97791.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Thomas Jackson <thomas.p.jackson@intel.com>, linux-ide@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Thomas Jackson <thomas.p.jackson@intel.com>

If an expander reports 'PHY VACANT' for a phy index prior to the one
that generated a BCN libsas fails rediscovery.  Since a vacant phy is
defined as a valid phy index that will never have an attached device
just continue the search.

Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Jackson <thomas.p.jackson@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 0ab3796..cacf3fe 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1718,9 +1718,17 @@ static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
 		int phy_change_count = 0;
 
 		res = sas_get_phy_change_count(dev, i, &phy_change_count);
-		if (res)
-			goto out;
-		else if (phy_change_count != ex->ex_phy[i].phy_change_count) {
+		switch (res) {
+		case SMP_RESP_PHY_VACANT:
+		case SMP_RESP_NO_PHY:
+			continue;
+		case SMP_RESP_FUNC_ACC:
+			break;
+		default:
+			return res;
+		}
+
+		if (phy_change_count != ex->ex_phy[i].phy_change_count) {
 			if (update)
 				ex->ex_phy[i].phy_change_count =
 					phy_change_count;
@@ -1728,8 +1736,7 @@ static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
 			return 0;
 		}
 	}
-out:
-	return res;
+	return 0;
 }
 
 static int sas_get_ex_change_count(struct domain_device *dev, int *ecc)

