From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 05/12] libsas: fix sas_get_port_device regression
Date: Fri, 13 Apr 2012 16:37:17 -0700
Message-ID: <20120413233717.8025.99422.stgit@dwillia2-linux.jf.intel.com>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: Tom Jackson <thomas.p.jackson@intel.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
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
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index b82949c..4da5ea8 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -134,10 +134,6 @@ static int sas_get_port_device(struct asd_sas_port *port)
 		return -ENODEV;
 	}
 
-	spin_lock_irq(&port->phy_list_lock);
-	list_for_each_entry(phy, &port->phy_list, port_phy_el)
-		sas_phy_set_target(phy, dev);
-	spin_unlock_irq(&port->phy_list_lock);
 	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
 	memcpy(dev->sas_addr, port->attached_sas_addr, SAS_ADDR_SIZE);
 	sas_fill_in_rphy(dev, rphy);
@@ -164,6 +160,11 @@ static int sas_get_port_device(struct asd_sas_port *port)
 		spin_unlock_irq(&port->dev_list_lock);
 	}
 
+	spin_lock_irq(&port->phy_list_lock);
+	list_for_each_entry(phy, &port->phy_list, port_phy_el)
+		sas_phy_set_target(phy, dev);
+	spin_unlock_irq(&port->phy_list_lock);
+
 	return 0;
 }
 

