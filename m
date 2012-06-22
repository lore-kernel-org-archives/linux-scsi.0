From: Dan Williams <dan.j.williams@intel.com>
Subject: [set3 PATCH 2/6] libsas: continue revalidation
Date: Thu, 21 Jun 2012 23:36:15 -0700
Message-ID: <20120622063615.21332.11075.stgit@dwillia2-linux.jf.intel.com>
References: <20120622063604.21332.39275.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43057 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761222Ab2FVGTg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:19:36 -0400
In-Reply-To: <20120622063604.21332.39275.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org

Continue running revalidation until no more broadcast devices are
discovered.  Fixes cases where re-discovery completes too early in a
domain with multiple expanders with pending re-discovery events.
Servicing BCNs can get backed up behind error recovery.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index af659cc..63c5742 100644
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
 

