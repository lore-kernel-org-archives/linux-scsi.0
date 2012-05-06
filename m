From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 13/18] libsas: continue revalidation
Date: Sun, 06 May 2012 11:19:03 -0700
Message-ID: <20120506181903.17912.41246.stgit@dwillia2-linux.jf.intel.com>
References: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Continue running revalidation until no more broadcast devices are
discovered.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 63d3e59..a4b15c1 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2114,9 +2114,7 @@ int sas_ex_revalidate_domain(struct domain_device *port_dev)
 	struct domain_device *dev = NULL;
 
 	res = sas_find_bcast_dev(port_dev, &dev);
-	if (res)
-		goto out;
-	if (dev) {
+	while (res == 0 && dev) {
 		struct expander_device *ex = &dev->ex_dev;
 		int i = 0, phy_id;
 
@@ -2128,8 +2126,10 @@ int sas_ex_revalidate_domain(struct domain_device *port_dev)
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
 

