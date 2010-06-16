From: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5]pci:bus.c Fix variable 'retval' set but not used
Date: Tue, 15 Jun 2010 22:33:52 -0700
Message-ID: <1276666434-11227-4-git-send-email-justinmattock@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1276666434-11227-1-git-send-email-justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The patch below fixes the warning message I am seeing with gcc 4.6.0
  CC      drivers/pci/bus.o
drivers/pci/bus.c: In function 'pci_enable_bridges':
drivers/pci/bus.c:237:6: warning: variable 'retval' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 drivers/pci/bus.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 628ea20..84bdb48 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -234,12 +234,10 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 void pci_enable_bridges(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
-	int retval;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		if (dev->subordinate) {
 			if (!pci_is_enabled(dev)) {
-				retval = pci_enable_device(dev);
 				pci_set_master(dev);
 			}
 			pci_enable_bridges(dev->subordinate);
-- 
1.7.1.rc1.21.gf3bd6

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
