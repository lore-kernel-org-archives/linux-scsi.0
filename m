From: Dan Williams <dan.j.williams@intel.com>
Subject: [set3 PATCH 1/6] libsas: sas_rediscover_dev did not look at the SMP
 exec status.
Date: Thu, 21 Jun 2012 23:36:10 -0700
Message-ID: <20120622063609.21332.17560.stgit@dwillia2-linux.jf.intel.com>
References: <20120622063604.21332.39275.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42792 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761222Ab2FVGTf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:19:35 -0400
In-Reply-To: <20120622063604.21332.39275.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

The discovery function "sas_rediscover_dev" had two bugs: 1) it did
not pay attention to the return status from the SMP task execution;
2) the stack variable used for the returned SAS address was compared
against 0 without being initialized.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
[djbw: todo sanitize smp_execute_task return values (see: residue)]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index caa0525..af659cc 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2005,6 +2005,7 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 	u8 sas_addr[8];
 	int res;
 
+	memset(sas_addr, 0, 8);
 	res = sas_get_phy_attached_dev(dev, phy_id, sas_addr, &type);
 	switch (res) {
 	case SMP_RESP_NO_PHY:
@@ -2017,9 +2018,13 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 		return res;
 	case SMP_RESP_FUNC_ACC:
 		break;
+	case -ECOMM:
+		break;
+	default:
+		return res;
 	}
 
-	if (SAS_ADDR(sas_addr) == 0) {
+	if ((SAS_ADDR(sas_addr) == 0) || (res == -ECOMM)) {
 		phy->phy_state = PHY_EMPTY;
 		sas_unregister_devs_sas_addr(dev, phy_id, last);
 		return res;

