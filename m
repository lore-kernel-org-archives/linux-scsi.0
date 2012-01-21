From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v6 5/7] libsas: delete device on sas address changed
Date: Fri, 20 Jan 2012 17:51:05 -0800
Message-ID: <20120121015105.24930.38118.stgit@localhost6.localdomain6>
References: <20120121014910.24930.54011.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120121014910.24930.54011.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If the phy is attached to a new sas address unregister the first address
before processing the new attachment.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index dc6bba5..3d6ba30 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1997,6 +1997,15 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 		return res;
 	}
 
+	/* delete the old link */
+	if (SAS_ADDR(phy->attached_sas_addr) &&
+	    SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
+		SAS_DPRINTK("ex %016llx phy 0x%x replace %016llx\n",
+			    SAS_ADDR(dev->sas_addr), phy_id,
+			    SAS_ADDR(phy->attached_sas_addr));
+		sas_unregister_devs_sas_addr(dev, phy_id, last);
+	}
+
 	return sas_discover_new(dev, phy_id);
 }
 

