From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 10/18] libsas: sas_rediscover_dev did not look at the SMP
 exec status.
Date: Sun, 06 May 2012 11:18:48 -0700
Message-ID: <20120506181848.17912.90848.stgit@dwillia2-linux.jf.intel.com>
References: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>
List-Id: linux-scsi@vger.kernel.org

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
index f1e8e0a..63d3e59 100644
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

