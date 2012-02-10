From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v8 05/13] libsas: fixup target_port_protocols for expanders
 that don't report sata
Date: Fri, 10 Feb 2012 00:45:05 -0800
Message-ID: <20120210084505.25701.43811.stgit@dwillia2-linux.jf.intel.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If discovery returns 0 for target_port_protocols but shows an attached
sata device, just report SAS_PROTOCOL_SATA in the identify data so
userspace can reliably search for sata devices in the domain.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 14e3244..05acd9e 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -251,6 +251,8 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	phy->phy->identify.device_type = dr->attached_dev_type;
 	phy->phy->identify.initiator_port_protocols = phy->attached_iproto;
 	phy->phy->identify.target_port_protocols = phy->attached_tproto;
+	if (!phy->attached_tproto && dr->attached_sata_dev)
+		phy->phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
 	phy->phy->identify.phy_identifier = phy_id;
 	phy->phy->minimum_linkrate_hw = dr->hmin_linkrate;
 	phy->phy->maximum_linkrate_hw = dr->hmax_linkrate;

