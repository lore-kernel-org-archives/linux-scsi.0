From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set but not used
Date: Tue, 15 Jun 2010 22:33:53 -0700
Message-ID: <1276666434-11227-5-git-send-email-justinmattock@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The below patch fixes a warning message when using gcc 4.6.0
  CC      drivers/pci/setup-bus.o
drivers/pci/setup-bus.c: In function 'pci_assign_unassigned_bridge_resources':
drivers/pci/setup-bus.c:868:6: warning: variable 'retval' set but not used
 
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/pci/setup-bus.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 19b1113..215590b 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -865,7 +865,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 	struct pci_bus *parent = bridge->subordinate;
 	int tried_times = 0;
 	struct resource_list_x head, *list;
-	int retval;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
@@ -874,7 +873,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 again:
 	pci_bus_size_bridges(parent);
 	__pci_bridge_assign_resources(bridge, &head);
-	retval = pci_reenable_device(bridge);
 	pci_set_master(bridge);
 	pci_enable_bridges(parent);
 
-- 
1.7.1.rc1.21.gf3bd6
