From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v6 3/7] libsas: fix sas port naming
Date: Fri, 20 Jan 2012 17:50:54 -0800
Message-ID: <20120121015054.24930.46192.stgit@localhost6.localdomain6>
References: <20120121014910.24930.54011.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120121014910.24930.54011.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Patrick Thomson <patrick.s.thomson@intel.com>
List-Id: linux-scsi@vger.kernel.org

Make sas-port naming consistent with the expander-attached case whereby
the phy-id is the last digit in the port name.  Otherwise we get the
random behavior of the allocation order.

Reported-by: Patrick Thomson <patrick.s.thomson@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_port.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 59ee8a0..29f8fd3 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -122,7 +122,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 
 	if (!port->port) {
-		port->port = sas_port_alloc(phy->phy->dev.parent, port->id);
+		port->port = sas_port_alloc(phy->phy->dev.parent, phy->id);
 		BUG_ON(!port->port);
 		sas_port_add(port->port);
 	}

