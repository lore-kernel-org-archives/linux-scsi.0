From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 2/3] PCI: Use device_match_always()
Date: Mon,  6 Jun 2016 09:32:37 +0200
Message-ID: <20160606073238.1073-2-thierry.reding@gmail.com>
References: <20160606073238.1073-1-thierry.reding@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160606073238.1073-1-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

There is now a common implementation for a match function that will
always match, so the PCI-specific implementation can be removed.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/pci/probe.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8e3ef720997d..3db06d8d6497 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -62,11 +62,6 @@ static struct resource *get_pci_domain_busn_res(int domain_nr)
 	return &r->res;
 }
 
-static int find_anything(struct device *dev, void *data)
-{
-	return 1;
-}
-
 /*
  * Some device drivers need know if pci is initiated.
  * Basically, we think pci is not initiated when there
@@ -77,7 +72,7 @@ int no_pci_devices(void)
 	struct device *dev;
 	int no_devices;
 
-	dev = bus_find_device(&pci_bus_type, NULL, NULL, find_anything);
+	dev = bus_find_device(&pci_bus_type, NULL, NULL, device_match_always);
 	no_devices = (dev == NULL);
 	put_device(dev);
 	return no_devices;
-- 
2.8.3
