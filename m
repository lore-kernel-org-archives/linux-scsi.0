From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 2/2] aic79xx: fix MMIO for PPC 44x platforms
Date: Fri, 18 Apr 2008 23:39:03 +0400
Message-ID: <200804182339.03891.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
Content-Disposition: inline
List-Unsubscribe: <https://ozlabs.org/mailman/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: James.Bottomley@HansenPartnership.com, hare@suse.de
Cc: linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The driver stores the PCI resource address into 'u_long' variable before
calling ioremap_nocache() on it. This warrants kernel oops when the registers
are accessed on PPC 44x platforms which (being 32-bit) have PCI memory space
mapped beyond 4 GB.

The arch/ppc/ kernel has a fixup in ioremap() that helps create an illusion
that the PCI memory resources are mapped below 4 GB, but arch/powerpc/ code
got rid of this trick, having instead CONFIG_RESOURCES_64BIT enabled.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
Changed ahd_linux_pci_reserve_io_region() prototype "for consistency", although
'u_long' was good for the I/O space addresses.

This is the same issue as the one that has been recently addressed by commits
3c34ac36ac1084e571ef9b6fb1d6a5b10ccc1fd0 (e1000: Fix for 32 bits platforms with
64 bits resources) and c976816b6e901341ec3c4653147316c15549a1c4 (siimage: fix
kernel oops on PPC 44x).  The patch has only been compile tested though...

 drivers/scsi/aic7xxx/aic79xx_osm.h     |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |   29 +++++++++++++++--------------
 2 files changed, 16 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -376,7 +376,7 @@ struct ahd_platform_data {
 #define AHD_LINUX_NOIRQ	((uint32_t)~0)
 	uint32_t		 irq;		/* IRQ for this adapter */
 	uint32_t		 bios_address;
-	uint32_t		 mem_busaddr;	/* Mem Base Addr */
+	resource_size_t		 mem_busaddr;	/* Mem Base Addr */
 };
 
 /************************** OS Utility Wrappers *******************************/
Index: linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -249,8 +249,8 @@ ahd_linux_pci_exit(void)
 }
 
 static int
-ahd_linux_pci_reserve_io_regions(struct ahd_softc *ahd, u_long *base,
-				 u_long *base2)
+ahd_linux_pci_reserve_io_regions(struct ahd_softc *ahd, resource_size_t *base,
+				 resource_size_t *base2)
 {
 	*base = pci_resource_start(ahd->dev_softc, 0);
 	/*
@@ -272,11 +272,11 @@ ahd_linux_pci_reserve_io_regions(struct 
 
 static int
 ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
-				 u_long *bus_addr,
+				 resource_size_t *bus_addr,
 				 uint8_t __iomem **maddr)
 {
-	u_long	start;
-	u_long	base_page;
+	resource_size_t	start;
+	resource_size_t	base_page;
 	u_long	base_offset;
 	int	error = 0;
 
@@ -310,7 +310,7 @@ int
 ahd_pci_map_registers(struct ahd_softc *ahd)
 {
 	uint32_t command;
-	u_long	 base;
+	resource_size_t base;
 	uint8_t	__iomem *maddr;
 	int	 error;
 
@@ -346,31 +346,32 @@ ahd_pci_map_registers(struct ahd_softc *
 		} else
 			command |= PCIM_CMD_MEMEN;
 	} else if (bootverbose) {
-		printf("aic79xx: PCI%d:%d:%d MEM region 0x%lx "
+		printf("aic79xx: PCI%d:%d:%d MEM region 0x%llx "
 		       "unavailable. Cannot memory map device.\n",
 		       ahd_get_pci_bus(ahd->dev_softc),
 		       ahd_get_pci_slot(ahd->dev_softc),
 		       ahd_get_pci_function(ahd->dev_softc),
-		       base);
+		       (unsigned long long)base);
 	}
 
 	if (maddr == NULL) {
-		u_long	 base2;
+		resource_size_t base2;
 
 		error = ahd_linux_pci_reserve_io_regions(ahd, &base, &base2);
 		if (error == 0) {
 			ahd->tags[0] = BUS_SPACE_PIO;
 			ahd->tags[1] = BUS_SPACE_PIO;
-			ahd->bshs[0].ioport = base;
-			ahd->bshs[1].ioport = base2;
+			ahd->bshs[0].ioport = (u_long)base;
+			ahd->bshs[1].ioport = (u_long)base2;
 			command |= PCIM_CMD_PORTEN;
 		} else {
-			printf("aic79xx: PCI%d:%d:%d IO regions 0x%lx and 0x%lx"
-			       "unavailable. Cannot map device.\n",
+			printf("aic79xx: PCI%d:%d:%d IO regions 0x%llx and "
+			       "0x%llx unavailable. Cannot map device.\n",
 			       ahd_get_pci_bus(ahd->dev_softc),
 			       ahd_get_pci_slot(ahd->dev_softc),
 			       ahd_get_pci_function(ahd->dev_softc),
-			       base, base2);
+			       (unsigned long long)base,
+			       (unsigned long long)base2);
 		}
 	}
 	ahd_pci_write_config(ahd->dev_softc, PCIR_COMMAND, command, 4);
