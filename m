From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/22] libata-sff: make BMDMA optional
Date: Tue, 21 Oct 2008 18:18:00 +0900
Message-ID: <1224580680-13698-23-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Make BMDMA optional depending on new config variable CONFIG_ATA_BMDMA.
In Kconfig, drivers are grouped into four groups - non-SFF native, SFF
w/ custom DMA interface, SFF w/ BMDMA, and PIO-only SFF ones.

ata_ioports.bmdma_add and ata_port.bmdma_prd[_dma] are put into
CONFIG_ATA_BMDMA, as are all bmdma related ops, variables and
functions.

This increase the binary size slightly when BMDMA is enabled but on
both native-only and PIO-only configurations the size is slightly
reduced.  Either way, the size difference is insignificant.  This
chnage is more meaningful to signify the separation between SFF and
BMDMA and as a tool to verify the separation (at least to certain
extent).

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/Kconfig      |  348 ++++++++++++++++++++++++----------------------
 drivers/ata/Makefile     |   47 ++++---
 drivers/ata/libata-sff.c |   13 ++
 include/linux/libata.h   |   22 ++-
 4 files changed, 242 insertions(+), 188 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 7cf243e..e4695eb 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -47,6 +47,8 @@ config SATA_PMP
 	  This option adds support for SATA Port Multipliers
 	  (the SATA version of an ethernet hub, or SAS expander).
 
+comment "Controllers with non-SFF native interface"
+
 config SATA_AHCI
 	tristate "AHCI SATA support"
 	depends on PCI
@@ -98,24 +100,7 @@ config ATA_SFF
 
 if ATA_SFF
 
-config SATA_SVW
-	tristate "ServerWorks Frodo / Apple K2 SATA support"
-	depends on PCI
-	help
-	  This option enables support for Broadcom/Serverworks/Apple K2
-	  SATA support.
-
-	  If unsure, say N.
-
-config ATA_PIIX
-	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
-	depends on PCI
-	help
-	  This option enables support for ICH5/6/7/8 Serial ATA
-	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
-	  host controllers.
-
-	  If unsure, say N.
+comment "SFF controllers with custom DMA interface"
 
 config SATA_MV
 	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
@@ -126,11 +111,11 @@ config SATA_MV
 
 	  If unsure, say N.
 
-config SATA_NV
-	tristate "NVIDIA SATA support"
+config SATA_QSTOR
+	tristate "Pacific Digital SATA QStor support"
 	depends on PCI
 	help
-	  This option enables support for NVIDIA Serial ATA.
+	  This option enables support for Pacific Digital Serial ATA QStor.
 
 	  If unsure, say N.
 
@@ -142,11 +127,44 @@ config PDC_ADMA
 
 	  If unsure, say N.
 
-config SATA_QSTOR
-	tristate "Pacific Digital SATA QStor support"
+comment "SFF controllers with BMDMA"
+
+config ATA_BMDMA
+	bool "ATA BMDMA support"
+	default y
+	help
+	  This option adds support for SFF ATA controllers with BMDMA
+	  capability.  BMDMA stands for bus-master DMA and the
+	  de-facto DMA interface for SFF controllers.
+
+	  If unuser, say Y.
+
+if ATA_BMDMA
+
+config SATA_SVW
+	tristate "ServerWorks Frodo / Apple K2 SATA support"
 	depends on PCI
 	help
-	  This option enables support for Pacific Digital Serial ATA QStor.
+	  This option enables support for Broadcom/Serverworks/Apple K2
+	  SATA support.
+
+	  If unsure, say N.
+
+config ATA_PIIX
+	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
+	depends on PCI
+	help
+	  This option enables support for ICH5/6/7/8 Serial ATA
+	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
+	  host controllers.
+
+	  If unsure, say N.
+
+config SATA_NV
+	tristate "NVIDIA SATA support"
+	depends on PCI
+	help
+	  This option enables support for NVIDIA Serial ATA.
 
 	  If unsure, say N.
 
@@ -244,15 +262,6 @@ config PATA_ARTOP
 
 	  If unsure, say N.
 
-config PATA_AT32
-	tristate "Atmel AVR32 PATA support (Experimental)"
-	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
-	help
-	  This option enables support for the IDE devices on the
-	  Atmel AT32AP platform.
-
-	  If unsure, say N.
-
 config PATA_ATIIXP
 	tristate "ATI PATA support"
 	depends on PCI
@@ -262,16 +271,6 @@ config PATA_ATIIXP
 
 	  If unsure, say N.
 
-config PATA_CMD640_PCI
-	tristate "CMD640 PCI PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
-	help
-	  This option enables support for the CMD640 PCI IDE
-	  interface chip. Only the primary channel is currently
-	  supported.
-
-	  If unsure, say N.
-
 config PATA_CMD64X
 	tristate "CMD64x PATA support"
 	depends on PCI
@@ -388,15 +387,6 @@ config PATA_HPT3X3_DMA
 	  controllers. Enable with care as there are still some
 	  problems with DMA on this chipset.
 
-config PATA_ISAPNP
-	tristate "ISA Plug and Play PATA support (Experimental)"
-	depends on EXPERIMENTAL && ISAPNP
-	help
-	  This option enables support for ISA plug & play ATA
-	  controllers such as those found on old soundcards.
-
-	  If unsure, say N.
-
 config PATA_IT821X
 	tristate "IT8211/2 PATA support"
 	depends on PCI
@@ -425,15 +415,6 @@ config PATA_JMICRON
 
 	  If unsure, say N.
 
-config PATA_LEGACY
-	tristate "Legacy ISA PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
-	help
-	  This option enables support for ISA/VLB bus legacy PATA
-	  ports and allows them to be accessed via the new ATA layer.
-
-	  If unsure, say N.
-
 config PATA_TRIFLEX
 	tristate "Compaq Triflex PATA support"
 	depends on PCI
@@ -454,23 +435,6 @@ config PATA_MARVELL
 
 	  If unsure, say N.
 
-config PATA_MPC52xx
-	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on PPC_MPC52xx
-	help
-	  This option enables support for integrated IDE controller
-	  of the Freescale MPC52xx SoC.
-
-	  If unsure, say N.
-
-config PATA_MPIIX
-	tristate "Intel PATA MPIIX support"
-	depends on PCI
-	help
-	  This option enables support for MPIIX PATA support.
-
-	  If unsure, say N.
-
 config PATA_OLDPIIX
 	tristate "Intel PATA old PIIX support"
 	depends on PCI
@@ -497,15 +461,6 @@ config PATA_NINJA32
 
 	  If unsure, say N.
 
-config PATA_NS87410
-	tristate "Nat Semi NS87410 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
-	help
-	  This option enables support for the National Semiconductor
-	  NS87410 PCI-IDE controller.
-
-	  If unsure, say N.
-
 config PATA_NS87415
 	tristate "Nat Semi NS87415 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -515,15 +470,6 @@ config PATA_NS87415
 
 	  If unsure, say N.
 
-config PATA_OPTI
-	tristate "OPTI621/6215 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
-	help
-	  This option enables full PIO support for the early Opti ATA
-	  controllers found on some old motherboards.
-
-	  If unsure, say N.
-
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -534,15 +480,6 @@ config PATA_OPTIDMA
 
 	  If unsure, say N.
 
-config PATA_PCMCIA
-	tristate "PCMCIA PATA support"
-	depends on PCMCIA
-	help
-	  This option enables support for PCMCIA ATA interfaces, including
-	  compact flash card adapters via the new ATA layer.
-
-	  If unsure, say N.
-
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support (Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -552,12 +489,6 @@ config PATA_PDC_OLD
 
 	  If unsure, say N.
 
-config PATA_QDI
-	tristate "QDI VLB PATA support"
-	depends on ISA
-	help
-	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
-
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -567,24 +498,6 @@ config PATA_RADISYS
 
 	  If unsure, say N.
 
-config PATA_RB532
-	tristate "RouterBoard 532 PATA CompactFlash support"
-	depends on MIKROTIK_RB532
-	help
-	  This option enables support for the RouterBoard 532
-	  PATA CompactFlash controller.
-
-	  If unsure, say N.
-
-config PATA_RZ1000
-	tristate "PC Tech RZ1000 PATA support"
-	depends on PCI
-	help
-	  This option enables basic support for the PC Tech RZ1000/1
-	  PATA controllers via the new ATA layer
-
-	  If unsure, say N.
-
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -645,40 +558,6 @@ config PATA_WINBOND
 
 	  If unsure, say N.
 
-config PATA_WINBOND_VLB
-	tristate "Winbond W83759A VLB PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
-	help
-	  Support for the Winbond W83759A controller on Vesa Local Bus
-	  systems.
-
-config HAVE_PATA_PLATFORM
-	bool
-	help
-	  This is an internal configuration node for any machine that
-	  uses pata-platform driver to enable the relevant driver in the
-	  configuration structure without having to submit endless patches
-	  to update the PATA_PLATFORM entry.
-
-config PATA_PLATFORM
-	tristate "Generic platform device PATA support"
-	depends on EMBEDDED || PPC || HAVE_PATA_PLATFORM
-	help
-	  This option enables support for generic directly connected ATA
-	  devices commonly found on embedded systems.
-
-	  If unsure, say N.
-
-config PATA_OF_PLATFORM
-	tristate "OpenFirmware platform device PATA support"
-	depends on PATA_PLATFORM && PPC_OF
-	help
-	  This option enables support for generic directly connected ATA
-	  devices commonly found on embedded systems with OpenFirmware
-	  bindings.
-
-	  If unsure, say N.
-
 config PATA_ICSIDE
 	tristate "Acorn ICS PATA support"
 	depends on ARM && ARCH_ACORN
@@ -724,5 +603,148 @@ config PATA_BF54X
 
 	  If unsure, say N.
 
+endif # ATA_BMDMA
+
+comment "PIO-only SFF controllers"
+
+config PATA_AT32
+	tristate "Atmel AVR32 PATA support (Experimental)"
+	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
+	help
+	  This option enables support for the IDE devices on the
+	  Atmel AT32AP platform.
+
+	  If unsure, say N.
+
+config PATA_CMD640_PCI
+	tristate "CMD640 PCI PATA support (Very Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This option enables support for the CMD640 PCI IDE
+	  interface chip. Only the primary channel is currently
+	  supported.
+
+	  If unsure, say N.
+
+config PATA_ISAPNP
+	tristate "ISA Plug and Play PATA support (Experimental)"
+	depends on EXPERIMENTAL && ISAPNP
+	help
+	  This option enables support for ISA plug & play ATA
+	  controllers such as those found on old soundcards.
+
+	  If unsure, say N.
+
+config PATA_LEGACY
+	tristate "Legacy ISA PATA support (Experimental)"
+	depends on ISA && EXPERIMENTAL
+	help
+	  This option enables support for ISA/VLB bus legacy PATA
+	  ports and allows them to be accessed via the new ATA layer.
+
+	  If unsure, say N.
+
+config PATA_MPC52xx
+	tristate "Freescale MPC52xx SoC internal IDE"
+	depends on PPC_MPC52xx
+	help
+	  This option enables support for integrated IDE controller
+	  of the Freescale MPC52xx SoC.
+
+	  If unsure, say N.
+
+config PATA_MPIIX
+	tristate "Intel PATA MPIIX support"
+	depends on PCI
+	help
+	  This option enables support for MPIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_NS87410
+	tristate "Nat Semi NS87410 PATA support (Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This option enables support for the National Semiconductor
+	  NS87410 PCI-IDE controller.
+
+	  If unsure, say N.
+
+config PATA_OPTI
+	tristate "OPTI621/6215 PATA support (Very Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This option enables full PIO support for the early Opti ATA
+	  controllers found on some old motherboards.
+
+	  If unsure, say N.
+
+config PATA_PCMCIA
+	tristate "PCMCIA PATA support"
+	depends on PCMCIA
+	help
+	  This option enables support for PCMCIA ATA interfaces, including
+	  compact flash card adapters via the new ATA layer.
+
+	  If unsure, say N.
+
+config HAVE_PATA_PLATFORM
+	bool
+	help
+	  This is an internal configuration node for any machine that
+	  uses pata-platform driver to enable the relevant driver in the
+	  configuration structure without having to submit endless patches
+	  to update the PATA_PLATFORM entry.
+
+config PATA_PLATFORM
+	tristate "Generic platform device PATA support"
+	depends on EMBEDDED || PPC || HAVE_PATA_PLATFORM
+	help
+	  This option enables support for generic directly connected ATA
+	  devices commonly found on embedded systems.
+
+	  If unsure, say N.
+
+config PATA_OF_PLATFORM
+	tristate "OpenFirmware platform device PATA support"
+	depends on PATA_PLATFORM && PPC_OF
+	help
+	  This option enables support for generic directly connected ATA
+	  devices commonly found on embedded systems with OpenFirmware
+	  bindings.
+
+	  If unsure, say N.
+
+config PATA_QDI
+	tristate "QDI VLB PATA support"
+	depends on ISA
+	help
+	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
+
+config PATA_RB532
+	tristate "RouterBoard 532 PATA CompactFlash support"
+	depends on MIKROTIK_RB532
+	help
+	  This option enables support for the RouterBoard 532
+	  PATA CompactFlash controller.
+
+	  If unsure, say N.
+
+config PATA_RZ1000
+	tristate "PC Tech RZ1000 PATA support"
+	depends on PCI
+	help
+	  This option enables basic support for the PC Tech RZ1000/1
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
+config PATA_WINBOND_VLB
+	tristate "Winbond W83759A VLB PATA support (Experimental)"
+	depends on ISA && EXPERIMENTAL
+	help
+	  Support for the Winbond W83759A controller on Vesa Local Bus
+	  systems.
+
 endif # ATA_SFF
 endif # ATA
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 674965f..4fad2cf 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,30 +1,34 @@
 
 obj-$(CONFIG_ATA)		+= libata.o
 
+# non-SFF interface
 obj-$(CONFIG_SATA_AHCI)		+= ahci.o
+obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
+obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
+obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
+
+# SFF w/ custom DMA
+obj-$(CONFIG_SATA_MV)		+= sata_mv.o
+obj-$(CONFIG_SATA_QSTOR)	+= sata_qstor.o
+obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
+
+# SFF SATA w/ BMDMA
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
-obj-$(CONFIG_SATA_QSTOR)	+= sata_qstor.o
 obj-$(CONFIG_SATA_SIL)		+= sata_sil.o
-obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
 obj-$(CONFIG_SATA_VIA)		+= sata_via.o
 obj-$(CONFIG_SATA_VITESSE)	+= sata_vsc.o
 obj-$(CONFIG_SATA_SIS)		+= sata_sis.o
 obj-$(CONFIG_SATA_SX4)		+= sata_sx4.o
 obj-$(CONFIG_SATA_NV)		+= sata_nv.o
 obj-$(CONFIG_SATA_ULI)		+= sata_uli.o
-obj-$(CONFIG_SATA_MV)		+= sata_mv.o
-obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
-obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
-obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
 
+# SFF PATA w/ BMDMA
 obj-$(CONFIG_PATA_ALI)		+= pata_ali.o
 obj-$(CONFIG_PATA_AMD)		+= pata_amd.o
 obj-$(CONFIG_PATA_ARTOP)	+= pata_artop.o
-obj-$(CONFIG_PATA_AT32)		+= pata_at32.o
 obj-$(CONFIG_PATA_ATIIXP)	+= pata_atiixp.o
-obj-$(CONFIG_PATA_CMD640_PCI)	+= pata_cmd640.o
 obj-$(CONFIG_PATA_CMD64X)	+= pata_cmd64x.o
 obj-$(CONFIG_PATA_CS5520)	+= pata_cs5520.o
 obj-$(CONFIG_PATA_CS5530)	+= pata_cs5530.o
@@ -36,42 +40,47 @@ obj-$(CONFIG_PATA_HPT366)	+= pata_hpt366.o
 obj-$(CONFIG_PATA_HPT37X)	+= pata_hpt37x.o
 obj-$(CONFIG_PATA_HPT3X2N)	+= pata_hpt3x2n.o
 obj-$(CONFIG_PATA_HPT3X3)	+= pata_hpt3x3.o
-obj-$(CONFIG_PATA_ISAPNP)	+= pata_isapnp.o
 obj-$(CONFIG_PATA_IT821X)	+= pata_it821x.o
 obj-$(CONFIG_PATA_IT8213)	+= pata_it8213.o
 obj-$(CONFIG_PATA_JMICRON)	+= pata_jmicron.o
 obj-$(CONFIG_PATA_NETCELL)	+= pata_netcell.o
 obj-$(CONFIG_PATA_NINJA32)	+= pata_ninja32.o
-obj-$(CONFIG_PATA_NS87410)	+= pata_ns87410.o
 obj-$(CONFIG_PATA_NS87415)	+= pata_ns87415.o
-obj-$(CONFIG_PATA_OPTI)		+= pata_opti.o
 obj-$(CONFIG_PATA_OPTIDMA)	+= pata_optidma.o
-obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52xx.o
 obj-$(CONFIG_PATA_MARVELL)	+= pata_marvell.o
-obj-$(CONFIG_PATA_MPIIX)	+= pata_mpiix.o
 obj-$(CONFIG_PATA_OLDPIIX)	+= pata_oldpiix.o
-obj-$(CONFIG_PATA_PCMCIA)	+= pata_pcmcia.o
 obj-$(CONFIG_PATA_PDC2027X)	+= pata_pdc2027x.o
 obj-$(CONFIG_PATA_PDC_OLD)	+= pata_pdc202xx_old.o
-obj-$(CONFIG_PATA_QDI)		+= pata_qdi.o
 obj-$(CONFIG_PATA_RADISYS)	+= pata_radisys.o
-obj-$(CONFIG_PATA_RB532)	+= pata_rb532_cf.o
-obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
 obj-$(CONFIG_PATA_SC1200)	+= pata_sc1200.o
 obj-$(CONFIG_PATA_SERVERWORKS)	+= pata_serverworks.o
 obj-$(CONFIG_PATA_SIL680)	+= pata_sil680.o
 obj-$(CONFIG_PATA_VIA)		+= pata_via.o
 obj-$(CONFIG_PATA_WINBOND)	+= pata_sl82c105.o
-obj-$(CONFIG_PATA_WINBOND_VLB)	+= pata_winbond.o
 obj-$(CONFIG_PATA_SIS)		+= pata_sis.o
 obj-$(CONFIG_PATA_TRIFLEX)	+= pata_triflex.o
 obj-$(CONFIG_PATA_IXP4XX_CF)	+= pata_ixp4xx_cf.o
 obj-$(CONFIG_PATA_SCC)		+= pata_scc.o
 obj-$(CONFIG_PATA_SCH)		+= pata_sch.o
 obj-$(CONFIG_PATA_BF54X)	+= pata_bf54x.o
+obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
+
+# SFF PIO only
+obj-$(CONFIG_PATA_AT32)		+= pata_at32.o
+obj-$(CONFIG_PATA_CMD640_PCI)	+= pata_cmd640.o
+obj-$(CONFIG_PATA_ISAPNP)	+= pata_isapnp.o
+obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52xx.o
+obj-$(CONFIG_PATA_MPIIX)	+= pata_mpiix.o
+obj-$(CONFIG_PATA_NS87410)	+= pata_ns87410.o
+obj-$(CONFIG_PATA_OPTI)		+= pata_opti.o
+obj-$(CONFIG_PATA_PCMCIA)	+= pata_pcmcia.o
 obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
 obj-$(CONFIG_PATA_OF_PLATFORM)	+= pata_of_platform.o
-obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
+obj-$(CONFIG_PATA_QDI)		+= pata_qdi.o
+obj-$(CONFIG_PATA_RB532)	+= pata_rb532_cf.o
+obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
+obj-$(CONFIG_PATA_WINBOND_VLB)	+= pata_winbond.o
+
 # Should be last but two libata driver
 obj-$(CONFIG_PATA_ACPI)		+= pata_acpi.o
 # Should be last but one libata driver
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 2a4e62d..f8d2527 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -686,11 +686,15 @@ static void atapi_send_cdb(struct ata_port *ap, struct ata_queued_cmd *qc)
 	case ATAPI_PROT_NODATA:
 		ap->hsm_task_state = HSM_ST_LAST;
 		break;
+#ifdef CONFIG_ATA_BMDMA
 	case ATAPI_PROT_DMA:
 		ap->hsm_task_state = HSM_ST_LAST;
 		/* initiate bmdma */
 		ap->ops->bmdma_start(qc);
 		break;
+#endif /* CONFIG_ATA_BMDMA */
+	default:
+		BUG();
 	}
 }
 
@@ -2279,6 +2283,12 @@ err_out:
 	DPRINTK("EXIT\n");
 }
 
+/*
+ *	BMDMA support
+ */
+
+#ifdef CONFIG_ATA_BMDMA
+
 const struct ata_port_operations ata_bmdma_port_ops = {
 	.inherits		= &ata_sff_port_ops,
 
@@ -3000,6 +3010,7 @@ int ata_pci_bmdma_init_one(struct pci_dev *pdev,
 }
 
 #endif /* CONFIG_PCI */
+#endif /* CONFIG_ATA_BMDMA */
 
 /**
  *	ata_sff_check_reset - Check whether standard reset methods are valid
@@ -3091,6 +3102,7 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
 EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 #endif /* CONFIG_PCI */
 EXPORT_SYMBOL_GPL(ata_bus_reset);
+#ifdef CONFIG_ATA_BMDMA
 EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
 EXPORT_SYMBOL_GPL(ata_bmdma_qc_prep);
 EXPORT_SYMBOL_GPL(ata_bmdma_qc_issue);
@@ -3111,3 +3123,4 @@ EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_prepare_host);
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_init_one);
 #endif /* CONFIG_PCI */
+#endif /* CONFIG_ATA_BMDMA */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d500200..d2b0807 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -480,7 +480,9 @@ struct ata_ioports {
 	void __iomem		*command_addr;
 	void __iomem		*altstatus_addr;
 	void __iomem		*ctl_addr;
+#ifdef CONFIG_ATA_BMDMA
 	void __iomem		*bmdma_addr;
+#endif /* CONFIG_ATA_BMDMA */
 	void __iomem		*scr_addr;
 };
 #endif /* CONFIG_ATA_SFF */
@@ -682,8 +684,10 @@ struct ata_port {
 	u8			ctl;	/* cache of ATA control register */
 	u8			last_ctl;	/* Cache last written value */
 	struct delayed_work	sff_pio_task;
+#ifdef CONFIG_ATA_BMDMA
 	struct ata_bmdma_prd	*bmdma_prd;	/* BMDMA SG list */
 	dma_addr_t		bmdma_prd_dma;	/* and its DMA mapping */
+#endif /* CONFIG_ATA_BMDMA */
 #endif /* CONFIG_ATA_SFF */
 
 	unsigned int		pio_mask;
@@ -812,10 +816,12 @@ struct ata_port_operations {
 	u8   (*sff_irq_on)(struct ata_port *);
 	void (*sff_irq_clear)(struct ata_port *);
 
+#ifdef CONFIG_ATA_BMDMA
 	void (*bmdma_setup)(struct ata_queued_cmd *qc);
 	void (*bmdma_start)(struct ata_queued_cmd *qc);
 	void (*bmdma_stop)(struct ata_queued_cmd *qc);
 	u8   (*bmdma_status)(struct ata_port *ap);
+#endif /*CONFIG_ATA_BMDMA*/
 #endif /* CONFIG_ATA_SFF */
 
 	ssize_t (*em_show)(struct ata_port *ap, char *buf);
@@ -1472,7 +1478,6 @@ extern void sata_pmp_error_handler(struct ata_port *ap);
 #ifdef CONFIG_ATA_SFF
 
 extern const struct ata_port_operations ata_sff_port_ops;
-extern const struct ata_port_operations ata_bmdma_port_ops;
 
 /* PIO only, sg_tablesize and dma_boundary limits can be removed */
 #define ATA_PIO_SHT(drv_name)					\
@@ -1480,11 +1485,6 @@ extern const struct ata_port_operations ata_bmdma_port_ops;
 	.sg_tablesize		= LIBATA_MAX_PRD,		\
 	.dma_boundary		= ATA_DMA_BOUNDARY
 
-#define ATA_BMDMA_SHT(drv_name)					\
-	ATA_BASE_SHT(drv_name),					\
-	.sg_tablesize		= LIBATA_MAX_PRD,		\
-	.dma_boundary		= ATA_DMA_BOUNDARY
-
 extern void ata_sff_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_sff_check_status(struct ata_port *ap);
 extern void ata_sff_pause(struct ata_port *ap);
@@ -1536,6 +1536,15 @@ extern int ata_pci_sff_init_one(struct pci_dev *pdev,
 
 extern void ata_bus_reset(struct ata_port *ap);		/* deprecated */
 
+#ifdef CONFIG_ATA_BMDMA
+
+extern const struct ata_port_operations ata_bmdma_port_ops;
+
+#define ATA_BMDMA_SHT(drv_name)					\
+	ATA_BASE_SHT(drv_name),					\
+	.sg_tablesize		= LIBATA_MAX_PRD,		\
+	.dma_boundary		= ATA_DMA_BOUNDARY
+
 extern void ata_bmdma_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc);
 extern void ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc);
@@ -1562,6 +1571,7 @@ extern int ata_pci_bmdma_init_one(struct pci_dev *pdev,
 				  struct scsi_host_template *sht,
 				  void *host_priv);
 #endif /* CONFIG_PCI */
+#endif /* CONFIG_ATA_BMDMA */
 
 /**
  *	ata_sff_busy_wait - Wait for a port status register
-- 
1.5.4.5

