From: Dan Williams <dan.j.williams@intel.com>
Subject: [libsas PATCH v11 2/2] libsas: fix sas_get_port_device regression
Date: Tue, 13 Mar 2012 23:30:23 -0700
Message-ID: <20120314063023.6772.67780.stgit@dwillia2-linux.jf.intel.com>
References: <20120314062643.6772.79462.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120314062643.6772.79462.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tom Jackson <thomas.p.jackson@intel.com>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit 899fcf4 "[SCSI] libsas: set attached device type and target
protocols for local phys" setup 'phy' to be dereferenced after
list_for_each_entry(phy, &port->phy_list, port_phy_el) (i.e. phy ==
&port->phy_list) resulting in reports like:

  BUG: unable to handle kernel NULL pointer dereference at 00000000000002b0
  IP: [<ffffffffa00ce948>] sas_discover_domain+0x29e/0x4fb [libsas]

...fix by deferring sas_phy_set_target() to the end of
sas_get_port_device().

Reported-by: Tom Jackson <thomas.p.jackson@intel.com>
Tested-by: Tom Jackson <thomas.p.jackson@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_discover.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index c140355..8ab1de6 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -135,10 +135,6 @@ static int sas_get_port_device(struct asd_sas_port *port)
 		return -ENODEV;
 	}
 
-	spin_lock_irq(&port->phy_list_lock);
-	list_for_each_entry(phy, &port->phy_list, port_phy_el)
-		sas_phy_set_target(phy, dev);
-	spin_unlock_irq(&port->phy_list_lock);
 	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
 	memcpy(dev->sas_addr, port->attached_sas_addr, SAS_ADDR_SIZE);
 	sas_fill_in_rphy(dev, rphy);
@@ -165,6 +161,11 @@ static int sas_get_port_device(struct asd_sas_port *port)
 		spin_unlock_irq(&port->dev_list_lock);
 	}
 
+	spin_lock_irq(&port->phy_list_lock);
+	list_for_each_entry(phy, &port->phy_list, port_phy_el)
+		sas_phy_set_target(phy, dev);
+	spin_unlock_irq(&port->phy_list_lock);
+
 	return 0;
 }
 

