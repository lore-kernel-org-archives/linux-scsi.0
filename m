From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 1/2] aic7xxx: fix MMIO for PPC 44x platforms
Date: Fri, 18 Apr 2008 23:30:45 +0400
Message-ID: <200804182330.45435.sshtylyov@ru.mvista.com>
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
Reworked to address James' comments.
This is the same issue as the one that has been recently addressed by commits
3c34ac36ac1084e571ef9b6fb1d6a5b10ccc1fd0 (e1000: Fix for 32 bits platforms with
64 bits resources) and c976816b6e901341ec3c4653147316c15549a1c4 (siimage: fix
kernel oops on PPC 44x).  The patch has only been compile tested though...

 drivers/scsi/aic7xxx/aic7xxx_osm.h     |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -365,7 +365,7 @@ struct ahc_platform_data {
 #define AHC_LINUX_NOIRQ	((uint32_t)~0)
 	uint32_t		 irq;		/* IRQ for this adapter */
 	uint32_t		 bios_address;
-	uint32_t		 mem_busaddr;	/* Mem Base Addr */
+	resource_size_t 	 mem_busaddr;	/* Mem Base Addr */
 };
 
 /************************** OS Utility Wrappers *******************************/
Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -293,7 +293,7 @@ ahc_linux_pci_exit(void)
 }
 
 static int
-ahc_linux_pci_reserve_io_region(struct ahc_softc *ahc, u_long *base)
+ahc_linux_pci_reserve_io_region(struct ahc_softc *ahc, resource_size_t *base)
 {
 	if (aic7xxx_allow_memio == 0)
 		return (ENOMEM);
@@ -308,10 +308,10 @@ ahc_linux_pci_reserve_io_region(struct a
 
 static int
 ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
-				 u_long *bus_addr,
+				 resource_size_t *bus_addr,
 				 uint8_t __iomem **maddr)
 {
-	u_long	start;
+	resource_size_t	start;
 	int	error;
 
 	error = 0;
@@ -336,7 +336,7 @@ int
 ahc_pci_map_registers(struct ahc_softc *ahc)
 {
 	uint32_t command;
-	u_long	 base;
+	resource_size_t	base;
 	uint8_t	__iomem *maddr;
 	int	 error;
 
@@ -374,12 +374,12 @@ ahc_pci_map_registers(struct ahc_softc *
 		} else
 			command |= PCIM_CMD_MEMEN;
 	} else {
-		printf("aic7xxx: PCI%d:%d:%d MEM region 0x%lx "
+		printf("aic7xxx: PCI%d:%d:%d MEM region 0x%llx "
 		       "unavailable. Cannot memory map device.\n",
 		       ahc_get_pci_bus(ahc->dev_softc),
 		       ahc_get_pci_slot(ahc->dev_softc),
 		       ahc_get_pci_function(ahc->dev_softc),
-		       base);
+		       (unsigned long long)base);
 	}
 
 	/*
@@ -390,15 +390,15 @@ ahc_pci_map_registers(struct ahc_softc *
 		error = ahc_linux_pci_reserve_io_region(ahc, &base);
 		if (error == 0) {
 			ahc->tag = BUS_SPACE_PIO;
-			ahc->bsh.ioport = base;
+			ahc->bsh.ioport = (u_long)base;
 			command |= PCIM_CMD_PORTEN;
 		} else {
-			printf("aic7xxx: PCI%d:%d:%d IO region 0x%lx[0..255] "
+			printf("aic7xxx: PCI%d:%d:%d IO region 0x%llx[0..255] "
 			       "unavailable. Cannot map device.\n",
 			       ahc_get_pci_bus(ahc->dev_softc),
 			       ahc_get_pci_slot(ahc->dev_softc),
 			       ahc_get_pci_function(ahc->dev_softc),
-			       base);
+			       (unsigned long long)base);
 		}
 	}
 	ahc_pci_write_config(ahc->dev_softc, PCIR_COMMAND, command, 4);
