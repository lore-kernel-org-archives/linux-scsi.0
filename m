From: Dan Williams <dan.j.williams@intel.com>
Subject: [libsas PATCH v12 08/11] libsas: fix ata_eh clobbering ex_phys via
 smp_ata_check_ready
Date: Wed, 21 Mar 2012 23:32:35 -0700
Message-ID: <20120322063235.22036.79665.stgit@dwillia2-linux.jf.intel.com>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, Maciej Patelczyk <maciej.patelczyk@intel.com>, Bartek Nowakowski <bartek.nowakowski@intel.com>, Jack Wang <jack_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

The check_ready implementation in the expander-attached ata device case
polls on sas_ex_phy_discover().  The effect is that the ex_phy fields
(critically ->attached_sas_addr) can change.  When ata_eh ends and
libsas comes along to revalidate the domain
sas_unregister_devs_sas_addr() can fail to lookup devices to remove, or
fail to re-add an ata device that ata_eh marked as disabled.  So change
the code to skip the sas_address and change count updates when ata_eh is
active.

Cc: Jack Wang <jack_wang@usish.com>
Tested-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Tested-by: Bartek Nowakowski <bartek.nowakowski@intel.com>
Tested-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 48d7ce9..b5fbfaa 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -202,6 +202,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	u8 sas_addr[SAS_ADDR_SIZE];
 	struct smp_resp *resp = rsp;
 	struct discover_resp *dr = &resp->disc;
+	struct sas_ha_struct *ha = dev->port->ha;
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
 	struct sas_rphy *rphy = dev->rphy;
@@ -209,6 +210,8 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	char *type;
 
 	if (new_phy) {
+		if (WARN_ON_ONCE(test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)))
+			return;
 		phy->phy = sas_phy_alloc(&rphy->dev, phy_id);
 
 		/* FIXME: error_handling */
@@ -233,6 +236,8 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	memcpy(sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
 
 	phy->attached_dev_type = to_dev_type(dr);
+	if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state))
+		goto out;
 	phy->phy_id = phy_id;
 	phy->linkrate = dr->linkrate;
 	phy->attached_sata_host = dr->attached_sata_host;
@@ -273,6 +278,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 			return;
 		}
 
+ out:
 	switch (phy->attached_dev_type) {
 	case SATA_PENDING:
 		type = "stp pending";
@@ -311,7 +317,15 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	else
 		return;
 
-	SAS_DPRINTK("ex %016llx phy%02d:%c:%X attached: %016llx (%s)\n",
+	/* if the attached device type changed and ata_eh is active,
+	 * make sure we run revalidation when eh completes (see:
+	 * sas_enable_revalidation)
+	 */
+	if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state))
+		set_bit(DISCE_REVALIDATE_DOMAIN, &dev->port->disc.pending);
+
+	SAS_DPRINTK("%sex %016llx phy%02d:%c:%X attached: %016llx (%s)\n",
+		    test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state) ? "ata: " : "",
 		    SAS_ADDR(dev->sas_addr), phy->phy_id,
 		    sas_route_char(dev, phy), phy->linkrate,
 		    SAS_ADDR(phy->attached_sas_addr), type);

