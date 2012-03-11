From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v2 13/18] libsas: continue revalidation
Date: Sat, 10 Mar 2012 23:28:51 -0800
Message-ID: <20120311072851.6320.80231.stgit@dwillia2-linux.jf.intel.com>
References: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Continue running revalidation until no more broadcast devices are
discovered.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 05acd9e..dc35128 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2077,9 +2077,7 @@ int sas_ex_revalidate_domain(struct domain_device *port_dev)
 	struct domain_device *dev = NULL;
 
 	res = sas_find_bcast_dev(port_dev, &dev);
-	if (res)
-		goto out;
-	if (dev) {
+	while (res == 0 && dev) {
 		struct expander_device *ex = &dev->ex_dev;
 		int i = 0, phy_id;
 
@@ -2091,8 +2089,10 @@ int sas_ex_revalidate_domain(struct domain_device *port_dev)
 			res = sas_rediscover(dev, phy_id);
 			i = phy_id + 1;
 		} while (i < ex->num_phys);
+
+		dev = NULL;
+		res = sas_find_bcast_dev(port_dev, &dev);
 	}
-out:
 	return res;
 }
 

