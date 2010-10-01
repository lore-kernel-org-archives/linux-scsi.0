From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH 19/19]: tgt: Removal
Date: Sat, 02 Oct 2010 02:05:09 +0400
Message-ID: <4CA65B15.20600@vlnb.net>
References: <4CA653F0.1010008@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CA653F0.1010008@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Because of the conversion of the ibmvstgt driver from tgt to SCST, and because
the ibmvstgt driver was the only user of scsi_tgt, the scsi_tgt kernel module,
the CONFIG_SCSI_TGT, CONFIG_SCSI_SRP_TGT_ATTRS and CONFIG_SCSI_FC_TGT_ATTRS
kbuild variable, the scsi_host_template member variables transfer_response,
supportedmode and active_mode and the constants MODE_UNKNOWN, MODE_INITIATOR
and MODE_TARGET are no longer needed.

Note: this patch applies cleanly on a 2.6.35 kernel tree. The patch tool
however complains about the defconfig changes when trying to apply this patch
on a 2.6.36 kernel tree.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 arch/arm/configs/at572d940hfek_defconfig         |    1 
 arch/arm/configs/cam60_defconfig                 |    1 
 arch/arm/configs/s3c2410_defconfig               |    1 
 arch/m68k/configs/amiga_defconfig                |    2 
 arch/m68k/configs/apollo_defconfig               |    2 
 arch/m68k/configs/atari_defconfig                |    2 
 arch/m68k/configs/bvme6000_defconfig             |    2 
 arch/m68k/configs/hp300_defconfig                |    2 
 arch/m68k/configs/mac_defconfig                  |    2 
 arch/m68k/configs/multi_defconfig                |    2 
 arch/m68k/configs/mvme147_defconfig              |    2 
 arch/m68k/configs/mvme16x_defconfig              |    2 
 arch/m68k/configs/q40_defconfig                  |    2 
 arch/m68k/configs/sun3_defconfig                 |    2 
 arch/m68k/configs/sun3x_defconfig                |    2 
 arch/mips/configs/bcm47xx_defconfig              |    1 
 arch/mips/configs/decstation_defconfig           |    1 
 arch/mips/configs/ip22_defconfig                 |    1 
 arch/mips/configs/ip27_defconfig                 |    1 
 arch/mips/configs/ip32_defconfig                 |    1 
 arch/mips/configs/jazz_defconfig                 |    1 
 arch/mips/configs/malta_defconfig                |    1 
 arch/mips/configs/markeins_defconfig             |    1 
 arch/mips/configs/pnx8550-jbs_defconfig          |    1 
 arch/mips/configs/pnx8550-stb810_defconfig       |    1 
 arch/mips/configs/rm200_defconfig                |    1 
 arch/mips/configs/tb0226_defconfig               |    1 
 arch/mips/configs/tb0287_defconfig               |    1 
 arch/powerpc/configs/52xx/motionpro_defconfig    |    1 
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig |    1 
 arch/powerpc/configs/mpc5200_defconfig           |    1 
 drivers/scsi/Makefile                            |    3 
 drivers/scsi/hosts.c                             |    6 
 drivers/scsi/scsi_sysfs.c                        |   32 -
 drivers/scsi/scsi_tgt_if.c                       |  399 -------------
 drivers/scsi/scsi_tgt_lib.c                      |  661 -----------------------
 drivers/scsi/scsi_tgt_priv.h                     |   32 -
 drivers/scsi/scsi_transport_fc.c                 |   12 
 drivers/scsi/scsi_transport_fc_internal.h        |   26 
 drivers/scsi/scsi_transport_srp.c                |   18 
 drivers/scsi/scsi_transport_srp_internal.h       |   25 
 include/scsi/scsi_host.h                         |   31 -
 include/scsi/scsi_tgt.h                          |   21 
 include/scsi/scsi_tgt_if.h                       |  108 ---
 44 files changed, 2 insertions(+), 1415 deletions(-)

--- orig/linux-2.6.35/arch/arm/configs/at572d940hfek_defconfig 14:43:13.033585149 +0400
+++ linux-2.6.35/arch/arm/configs/at572d940hfek_defconfig 14:43:16.209585626 +0400
@@ -107,7 +107,6 @@ CONFIG_SENSORS_TSL2550=m
 CONFIG_DS1682=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=m
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
--- orig/linux-2.6.35/arch/arm/configs/cam60_defconfig 14:43:13.009586086 +0400
+++ linux-2.6.35/arch/arm/configs/cam60_defconfig 14:43:16.181586006 +0400
@@ -55,7 +55,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 # CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=y
--- orig/linux-2.6.35/arch/arm/configs/s3c2410_defconfig 14:43:13.017586533 +0400
+++ linux-2.6.35/arch/arm/configs/s3c2410_defconfig 14:43:16.189586873 +0400
@@ -229,7 +229,6 @@ CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_IDETAPE=m
 CONFIG_BLK_DEV_PLATFORM=y
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
--- orig/linux-2.6.35/arch/m68k/configs/amiga_defconfig 14:43:13.013586335 +0400
+++ linux-2.6.35/arch/m68k/configs/amiga_defconfig 14:43:16.181586006 +0400
@@ -506,7 +506,6 @@ CONFIG_BLK_DEV_BUDDHA=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -541,7 +540,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_SCSI_AHA152X is not set
--- orig/linux-2.6.35/arch/m68k/configs/apollo_defconfig 14:43:12.993587185 +0400
+++ linux-2.6.35/arch/m68k/configs/apollo_defconfig 14:43:16.166085929 +0400
@@ -469,7 +469,6 @@ CONFIG_HAVE_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -504,7 +503,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_LIBFC is not set
--- orig/linux-2.6.35/arch/m68k/configs/atari_defconfig 14:43:13.054085875 +0400
+++ linux-2.6.35/arch/m68k/configs/atari_defconfig 14:43:16.221586248 +0400
@@ -497,7 +497,6 @@ CONFIG_BLK_DEV_FALCON_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -532,7 +531,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_LIBFC is not set
--- orig/linux-2.6.35/arch/m68k/configs/bvme6000_defconfig 14:43:13.033585149 +0400
+++ linux-2.6.35/arch/m68k/configs/bvme6000_defconfig 14:43:16.205586184 +0400
@@ -471,7 +471,6 @@ CONFIG_HAVE_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -506,7 +505,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_LIBFC is not set
--- orig/linux-2.6.35/arch/m68k/configs/hp300_defconfig 14:43:13.065586532 +0400
+++ linux-2.6.35/arch/m68k/configs/hp300_defconfig 14:43:16.233586430 +0400
@@ -470,7 +470,6 @@ CONFIG_HAVE_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -505,7 +504,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_LIBFC is not set
--- orig/linux-2.6.35/arch/m68k/configs/mac_defconfig 14:43:13.054085875 +0400
+++ linux-2.6.35/arch/m68k/configs/mac_defconfig 14:43:16.221586248 +0400
@@ -493,7 +493,6 @@ CONFIG_BLK_DEV_MAC_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -528,7 +527,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_LIBFC is not set
--- orig/linux-2.6.35/arch/m68k/configs/multi_defconfig 14:43:13.054085875 +0400
+++ linux-2.6.35/arch/m68k/configs/multi_defconfig 14:43:16.221586248 +0400
@@ -523,7 +523,6 @@ CONFIG_BLK_DEV_Q40IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -558,7 +557,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_SCSI_AHA152X is not set
--- orig/linux-2.6.35/arch/m68k/configs/mvme147_defconfig 14:43:13.009586086 +0400
+++ linux-2.6.35/arch/m68k/configs/mvme147_defconfig 14:43:16.181586006 +0400
@@ -471,7 +471,6 @@ CONFIG_HAVE_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -506,7 +505,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_LIBFC is not set
--- orig/linux-2.6.35/arch/m68k/configs/mvme16x_defconfig 14:43:13.029586280 +0400
+++ linux-2.6.35/arch/m68k/configs/mvme16x_defconfig 14:43:16.197586106 +0400
@@ -471,7 +471,6 @@ CONFIG_HAVE_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -506,7 +505,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_LIBFC is not set
--- orig/linux-2.6.35/arch/m68k/configs/q40_defconfig 14:43:13.058085429 +0400
+++ linux-2.6.35/arch/m68k/configs/q40_defconfig 14:43:16.225586829 +0400
@@ -490,7 +490,6 @@ CONFIG_BLK_DEV_Q40IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -525,7 +524,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_SCSI_AHA152X is not set
--- orig/linux-2.6.35/arch/m68k/configs/sun3_defconfig 14:43:13.065586532 +0400
+++ linux-2.6.35/arch/m68k/configs/sun3_defconfig 14:43:16.233586430 +0400
@@ -466,7 +466,6 @@ CONFIG_HAVE_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 # CONFIG_SCSI_DMA is not set
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -501,7 +500,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_LIBFC is not set
--- orig/linux-2.6.35/arch/m68k/configs/sun3x_defconfig 14:43:13.033585149 +0400
+++ linux-2.6.35/arch/m68k/configs/sun3x_defconfig 14:43:16.201587395 +0400
@@ -468,7 +468,6 @@ CONFIG_HAVE_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
@@ -503,7 +502,6 @@ CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SAS_HOST_SMP=y
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
 # CONFIG_LIBFC is not set
--- orig/linux-2.6.35/arch/mips/configs/bcm47xx_defconfig 14:43:13.065586532 +0400
+++ linux-2.6.35/arch/mips/configs/bcm47xx_defconfig 14:43:16.233586430 +0400
@@ -931,7 +931,6 @@ CONFIG_SCSI_MOD=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/decstation_defconfig 14:43:13.046086036 +0400
+++ linux-2.6.35/arch/mips/configs/decstation_defconfig 14:43:16.213585862 +0400
@@ -413,7 +413,6 @@ CONFIG_BLK_DEV_LOOP=m
 #
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/ip22_defconfig 14:43:13.001586197 +0400
+++ linux-2.6.35/arch/mips/configs/ip22_defconfig 14:43:16.170085979 +0400
@@ -644,7 +644,6 @@ CONFIG_HAVE_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/ip27_defconfig 14:43:13.021586545 +0400
+++ linux-2.6.35/arch/mips/configs/ip27_defconfig 14:43:16.193586687 +0400
@@ -585,7 +585,6 @@ CONFIG_HAVE_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 CONFIG_SCSI_NETLINK=y
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/ip32_defconfig 14:43:13.029586280 +0400
+++ linux-2.6.35/arch/mips/configs/ip32_defconfig 14:43:16.201587395 +0400
@@ -439,7 +439,6 @@ CONFIG_HAVE_IDE=y
 CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=y
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/jazz_defconfig 14:43:13.050085967 +0400
+++ linux-2.6.35/arch/mips/configs/jazz_defconfig 14:43:16.217586134 +0400
@@ -696,7 +696,6 @@ CONFIG_ATA_OVER_ETH=m
 #
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_SCSI_NETLINK=y
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/malta_defconfig 14:43:13.009586086 +0400
+++ linux-2.6.35/arch/mips/configs/malta_defconfig 14:43:16.181586006 +0400
@@ -883,7 +883,6 @@ CONFIG_BLK_DEV_IDEDMA=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=m
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 CONFIG_SCSI_NETLINK=y
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/markeins_defconfig 14:43:13.038085920 +0400
+++ linux-2.6.35/arch/mips/configs/markeins_defconfig 14:43:16.209585626 +0400
@@ -646,7 +646,6 @@ CONFIG_SGI_IOC4=m
 #
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=m
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 # CONFIG_SCSI_PROC_FS is not set
 
--- orig/linux-2.6.35/arch/mips/configs/pnx8550-jbs_defconfig 14:43:13.058085429 +0400
+++ linux-2.6.35/arch/mips/configs/pnx8550-jbs_defconfig 14:43:16.221586248 +0400
@@ -470,7 +470,6 @@ CONFIG_BLK_DEV_IDEDMA=y
 #
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_SCSI_NETLINK=y
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/pnx8550-stb810_defconfig 14:43:12.993587185 +0400
+++ linux-2.6.35/arch/mips/configs/pnx8550-stb810_defconfig 14:43:16.170085979 +0400
@@ -467,7 +467,6 @@ CONFIG_BLK_DEV_IDEDMA=y
 #
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/rm200_defconfig 14:43:12.993587185 +0400
+++ linux-2.6.35/arch/mips/configs/rm200_defconfig 14:43:16.170085979 +0400
@@ -719,7 +719,6 @@ CONFIG_SGI_IOC4=m
 #
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_SCSI_NETLINK=y
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/tb0226_defconfig 14:43:13.062085069 +0400
+++ linux-2.6.35/arch/mips/configs/tb0226_defconfig 14:43:16.229587170 +0400
@@ -393,7 +393,6 @@ CONFIG_HAVE_IDE=y
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/mips/configs/tb0287_defconfig 14:43:13.025585564 +0400
+++ linux-2.6.35/arch/mips/configs/tb0287_defconfig 14:43:16.197586106 +0400
@@ -410,7 +410,6 @@ CONFIG_HAVE_IDE=y
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/powerpc/configs/52xx/motionpro_defconfig 14:43:13.025585564 +0400
+++ linux-2.6.35/arch/powerpc/configs/52xx/motionpro_defconfig 14:43:16.197586106 +0400
@@ -559,7 +559,6 @@ CONFIG_HAVE_IDE=y
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=y
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig 14:43:13.025585564 +0400
+++ linux-2.6.35/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig 14:43:16.197586106 +0400
@@ -671,7 +671,6 @@ CONFIG_SCSI_MOD=y
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=y
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/arch/powerpc/configs/mpc5200_defconfig 14:43:13.025585564 +0400
+++ linux-2.6.35/arch/powerpc/configs/mpc5200_defconfig 14:43:16.197586106 +0400
@@ -624,7 +624,6 @@ CONFIG_HAVE_IDE=y
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
-CONFIG_SCSI_TGT=y
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
--- orig/linux-2.6.35/drivers/scsi/Makefile 00:33:17.745901144 +0400
+++ linux-2.6.35/drivers/scsi/Makefile 14:30:45.817271498 +0400
@@ -20,7 +20,6 @@ CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__
 obj-$(CONFIG_PCMCIA)		+= pcmcia/
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
-obj-$(CONFIG_SCSI_TGT)		+= scsi_tgt.o
 
 obj-$(CONFIG_RAID_ATTRS)	+= raid_class.o
 
@@ -164,8 +163,6 @@ scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-y			+= scsi_trace.o
 
-scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
-
 sd_mod-objs	:= sd.o
 sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
 
--- orig/linux-2.6.35/drivers/scsi/hosts.c 17:35:38.837586708 +0400
+++ linux-2.6.35/drivers/scsi/hosts.c 17:35:38.853585850 +0400
@@ -376,12 +376,6 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
 
-	if (sht->supported_mode == MODE_UNKNOWN)
-		/* means we didn't set it ... default to INITIATOR */
-		shost->active_mode = MODE_INITIATOR;
-	else
-		shost->active_mode = sht->supported_mode;
-
 	if (sht->max_host_blocked)
 		shost->max_host_blocked = sht->max_host_blocked;
 	else
--- orig/linux-2.6.35/drivers/scsi/scsi_sysfs.c 00:33:17.745901144 +0400
+++ linux-2.6.35/drivers/scsi/scsi_sysfs.c 22:00:10.726089770 +0400
@@ -200,33 +200,10 @@ struct device_attribute dev_attr_hstate 
 	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
 static ssize_t
-show_shost_mode(unsigned int mode, char *buf)
-{
-	ssize_t len = 0;
-
-	if (mode & MODE_INITIATOR)
-		len = sprintf(buf, "%s", "Initiator");
-
-	if (mode & MODE_TARGET)
-		len += sprintf(buf + len, "%s%s", len ? ", " : "", "Target");
-
-	len += sprintf(buf + len, "\n");
-
-	return len;
-}
-
-static ssize_t
 show_shost_supported_mode(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	struct Scsi_Host *shost = class_to_shost(dev);
-	unsigned int supported_mode = shost->hostt->supported_mode;
-
-	if (supported_mode == MODE_UNKNOWN)
-		/* by default this should be initiator */
-		supported_mode = MODE_INITIATOR;
-
-	return show_shost_mode(supported_mode, buf);
+	return sprintf(buf, "Initiator\n");
 }
 
 static DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);
@@ -235,12 +212,7 @@ static ssize_t
 show_shost_active_mode(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
-	struct Scsi_Host *shost = class_to_shost(dev);
-
-	if (shost->active_mode == MODE_UNKNOWN)
-		return snprintf(buf, 20, "unknown\n");
-	else
-		return show_shost_mode(shost->active_mode, buf);
+	return sprintf(buf, "Initiator\n");
 }
 
 static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
--- orig/linux-2.6.35/drivers/scsi/scsi_tgt_if.c 21:27:39.757901065 +0400
+++ linux-2.6.35/drivers/scsi/scsi_tgt_if.c 00:33:18.173901783 +0400
@@ -1,399 +0,0 @@
-/*
- * SCSI target kernel/user interface functions
- *
- * Copyright (C) 2005 FUJITA Tomonori <tomof@acm.org>
- * Copyright (C) 2005 Mike Christie <michaelc@cs.wisc.edu>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-#include <linux/miscdevice.h>
-#include <linux/gfp.h>
-#include <linux/file.h>
-#include <linux/smp_lock.h>
-#include <net/tcp.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_tgt.h>
-#include <scsi/scsi_tgt_if.h>
-
-#include <asm/cacheflush.h>
-
-#include "scsi_tgt_priv.h"
-
-#if TGT_RING_SIZE < PAGE_SIZE
-#  define TGT_RING_SIZE PAGE_SIZE
-#endif
-
-#define TGT_RING_PAGES (TGT_RING_SIZE >> PAGE_SHIFT)
-#define TGT_EVENT_PER_PAGE (PAGE_SIZE / sizeof(struct tgt_event))
-#define TGT_MAX_EVENTS (TGT_EVENT_PER_PAGE * TGT_RING_PAGES)
-
-struct tgt_ring {
-	u32 tr_idx;
-	unsigned long tr_pages[TGT_RING_PAGES];
-	spinlock_t tr_lock;
-};
-
-/* tx_ring : kernel->user, rx_ring : user->kernel */
-static struct tgt_ring tx_ring, rx_ring;
-static DECLARE_WAIT_QUEUE_HEAD(tgt_poll_wait);
-
-static inline void tgt_ring_idx_inc(struct tgt_ring *ring)
-{
-	if (ring->tr_idx == TGT_MAX_EVENTS - 1)
-		ring->tr_idx = 0;
-	else
-		ring->tr_idx++;
-}
-
-static struct tgt_event *tgt_head_event(struct tgt_ring *ring, u32 idx)
-{
-	u32 pidx, off;
-
-	pidx = idx / TGT_EVENT_PER_PAGE;
-	off = idx % TGT_EVENT_PER_PAGE;
-
-	return (struct tgt_event *)
-		(ring->tr_pages[pidx] + sizeof(struct tgt_event) * off);
-}
-
-static int tgt_uspace_send_event(u32 type, struct tgt_event *p)
-{
-	struct tgt_event *ev;
-	struct tgt_ring *ring = &tx_ring;
-	unsigned long flags;
-	int err = 0;
-
-	spin_lock_irqsave(&ring->tr_lock, flags);
-
-	ev = tgt_head_event(ring, ring->tr_idx);
-	if (!ev->hdr.status)
-		tgt_ring_idx_inc(ring);
-	else
-		err = -BUSY;
-
-	spin_unlock_irqrestore(&ring->tr_lock, flags);
-
-	if (err)
-		return err;
-
-	memcpy(ev, p, sizeof(*ev));
-	ev->hdr.type = type;
-	mb();
-	ev->hdr.status = 1;
-
-	flush_dcache_page(virt_to_page(ev));
-
-	wake_up_interruptible(&tgt_poll_wait);
-
-	return 0;
-}
-
-int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, u64 itn_id,
-			     struct scsi_lun *lun, u64 tag)
-{
-	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
-	struct tgt_event ev;
-	int err;
-
-	memset(&ev, 0, sizeof(ev));
-	ev.p.cmd_req.host_no = shost->host_no;
-	ev.p.cmd_req.itn_id = itn_id;
-	ev.p.cmd_req.data_len = scsi_bufflen(cmd);
-	memcpy(ev.p.cmd_req.scb, cmd->cmnd, sizeof(ev.p.cmd_req.scb));
-	memcpy(ev.p.cmd_req.lun, lun, sizeof(ev.p.cmd_req.lun));
-	ev.p.cmd_req.attribute = cmd->tag;
-	ev.p.cmd_req.tag = tag;
-
-	dprintk("%p %d %u %x %llx\n", cmd, shost->host_no,
-		ev.p.cmd_req.data_len, cmd->tag,
-		(unsigned long long) ev.p.cmd_req.tag);
-
-	err = tgt_uspace_send_event(TGT_KEVENT_CMD_REQ, &ev);
-	if (err)
-		eprintk("tx buf is full, could not send\n");
-
-	return err;
-}
-
-int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 itn_id, u64 tag)
-{
-	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
-	struct tgt_event ev;
-	int err;
-
-	memset(&ev, 0, sizeof(ev));
-	ev.p.cmd_done.host_no = shost->host_no;
-	ev.p.cmd_done.itn_id = itn_id;
-	ev.p.cmd_done.tag = tag;
-	ev.p.cmd_done.result = cmd->result;
-
-	dprintk("%p %d %llu %u %x\n", cmd, shost->host_no,
-		(unsigned long long) ev.p.cmd_req.tag,
-		ev.p.cmd_req.data_len, cmd->tag);
-
-	err = tgt_uspace_send_event(TGT_KEVENT_CMD_DONE, &ev);
-	if (err)
-		eprintk("tx buf is full, could not send\n");
-
-	return err;
-}
-
-int scsi_tgt_uspace_send_tsk_mgmt(int host_no, u64 itn_id, int function,
-				  u64 tag, struct scsi_lun *scsilun, void *data)
-{
-	struct tgt_event ev;
-	int err;
-
-	memset(&ev, 0, sizeof(ev));
-	ev.p.tsk_mgmt_req.host_no = host_no;
-	ev.p.tsk_mgmt_req.itn_id = itn_id;
-	ev.p.tsk_mgmt_req.function = function;
-	ev.p.tsk_mgmt_req.tag = tag;
-	memcpy(ev.p.tsk_mgmt_req.lun, scsilun, sizeof(ev.p.tsk_mgmt_req.lun));
-	ev.p.tsk_mgmt_req.mid = (u64) (unsigned long) data;
-
-	dprintk("%d %x %llx %llx\n", host_no, function, (unsigned long long) tag,
-		(unsigned long long) ev.p.tsk_mgmt_req.mid);
-
-	err = tgt_uspace_send_event(TGT_KEVENT_TSK_MGMT_REQ, &ev);
-	if (err)
-		eprintk("tx buf is full, could not send\n");
-
-	return err;
-}
-
-int scsi_tgt_uspace_send_it_nexus_request(int host_no, u64 itn_id,
-					  int function, char *initiator_id)
-{
-	struct tgt_event ev;
-	int err;
-
-	memset(&ev, 0, sizeof(ev));
-	ev.p.it_nexus_req.host_no = host_no;
-	ev.p.it_nexus_req.function = function;
-	ev.p.it_nexus_req.itn_id = itn_id;
-	if (initiator_id)
-		strncpy(ev.p.it_nexus_req.initiator_id, initiator_id,
-			sizeof(ev.p.it_nexus_req.initiator_id));
-
-	dprintk("%d %x %llx\n", host_no, function, (unsigned long long)itn_id);
-
-	err = tgt_uspace_send_event(TGT_KEVENT_IT_NEXUS_REQ, &ev);
-	if (err)
-		eprintk("tx buf is full, could not send\n");
-
-	return err;
-}
-
-static int event_recv_msg(struct tgt_event *ev)
-{
-	int err = 0;
-
-	switch (ev->hdr.type) {
-	case TGT_UEVENT_CMD_RSP:
-		err = scsi_tgt_kspace_exec(ev->p.cmd_rsp.host_no,
-					   ev->p.cmd_rsp.itn_id,
-					   ev->p.cmd_rsp.result,
-					   ev->p.cmd_rsp.tag,
-					   ev->p.cmd_rsp.uaddr,
-					   ev->p.cmd_rsp.len,
-					   ev->p.cmd_rsp.sense_uaddr,
-					   ev->p.cmd_rsp.sense_len,
-					   ev->p.cmd_rsp.rw);
-		break;
-	case TGT_UEVENT_TSK_MGMT_RSP:
-		err = scsi_tgt_kspace_tsk_mgmt(ev->p.tsk_mgmt_rsp.host_no,
-					       ev->p.tsk_mgmt_rsp.itn_id,
-					       ev->p.tsk_mgmt_rsp.mid,
-					       ev->p.tsk_mgmt_rsp.result);
-		break;
-	case TGT_UEVENT_IT_NEXUS_RSP:
-		err = scsi_tgt_kspace_it_nexus_rsp(ev->p.it_nexus_rsp.host_no,
-						   ev->p.it_nexus_rsp.itn_id,
-						   ev->p.it_nexus_rsp.result);
-		break;
-	default:
-		eprintk("unknown type %d\n", ev->hdr.type);
-		err = -EINVAL;
-	}
-
-	return err;
-}
-
-static ssize_t tgt_write(struct file *file, const char __user * buffer,
-			 size_t count, loff_t * ppos)
-{
-	struct tgt_event *ev;
-	struct tgt_ring *ring = &rx_ring;
-
-	while (1) {
-		ev = tgt_head_event(ring, ring->tr_idx);
-		/* do we need this? */
-		flush_dcache_page(virt_to_page(ev));
-
-		if (!ev->hdr.status)
-			break;
-
-		tgt_ring_idx_inc(ring);
-		event_recv_msg(ev);
-		ev->hdr.status = 0;
-	};
-
-	return count;
-}
-
-static unsigned int tgt_poll(struct file * file, struct poll_table_struct *wait)
-{
-	struct tgt_event *ev;
-	struct tgt_ring *ring = &tx_ring;
-	unsigned long flags;
-	unsigned int mask = 0;
-	u32 idx;
-
-	poll_wait(file, &tgt_poll_wait, wait);
-
-	spin_lock_irqsave(&ring->tr_lock, flags);
-
-	idx = ring->tr_idx ? ring->tr_idx - 1 : TGT_MAX_EVENTS - 1;
-	ev = tgt_head_event(ring, idx);
-	if (ev->hdr.status)
-		mask |= POLLIN | POLLRDNORM;
-
-	spin_unlock_irqrestore(&ring->tr_lock, flags);
-
-	return mask;
-}
-
-static int uspace_ring_map(struct vm_area_struct *vma, unsigned long addr,
-			   struct tgt_ring *ring)
-{
-	int i, err;
-
-	for (i = 0; i < TGT_RING_PAGES; i++) {
-		struct page *page = virt_to_page(ring->tr_pages[i]);
-		err = vm_insert_page(vma, addr, page);
-		if (err)
-			return err;
-		addr += PAGE_SIZE;
-	}
-
-	return 0;
-}
-
-static int tgt_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	unsigned long addr;
-	int err;
-
-	if (vma->vm_pgoff)
-		return -EINVAL;
-
-	if (vma->vm_end - vma->vm_start != TGT_RING_SIZE * 2) {
-		eprintk("mmap size must be %lu, not %lu \n",
-			TGT_RING_SIZE * 2, vma->vm_end - vma->vm_start);
-		return -EINVAL;
-	}
-
-	addr = vma->vm_start;
-	err = uspace_ring_map(vma, addr, &tx_ring);
-	if (err)
-		return err;
-	err = uspace_ring_map(vma, addr + TGT_RING_SIZE, &rx_ring);
-
-	return err;
-}
-
-static int tgt_open(struct inode *inode, struct file *file)
-{
-	tx_ring.tr_idx = rx_ring.tr_idx = 0;
-
-	cycle_kernel_lock();
-	return 0;
-}
-
-static const struct file_operations tgt_fops = {
-	.owner		= THIS_MODULE,
-	.open		= tgt_open,
-	.poll		= tgt_poll,
-	.write		= tgt_write,
-	.mmap		= tgt_mmap,
-};
-
-static struct miscdevice tgt_miscdev = {
-	.minor = MISC_DYNAMIC_MINOR,
-	.name = "tgt",
-	.fops = &tgt_fops,
-};
-
-static void tgt_ring_exit(struct tgt_ring *ring)
-{
-	int i;
-
-	for (i = 0; i < TGT_RING_PAGES; i++)
-		free_page(ring->tr_pages[i]);
-}
-
-static int tgt_ring_init(struct tgt_ring *ring)
-{
-	int i;
-
-	spin_lock_init(&ring->tr_lock);
-
-	for (i = 0; i < TGT_RING_PAGES; i++) {
-		ring->tr_pages[i] = get_zeroed_page(GFP_KERNEL);
-		if (!ring->tr_pages[i]) {
-			eprintk("out of memory\n");
-			return -ENOMEM;
-		}
-	}
-
-	return 0;
-}
-
-void scsi_tgt_if_exit(void)
-{
-	tgt_ring_exit(&tx_ring);
-	tgt_ring_exit(&rx_ring);
-	misc_deregister(&tgt_miscdev);
-}
-
-int scsi_tgt_if_init(void)
-{
-	int err;
-
-	err = tgt_ring_init(&tx_ring);
-	if (err)
-		return err;
-
-	err = tgt_ring_init(&rx_ring);
-	if (err)
-		goto free_tx_ring;
-
-	err = misc_register(&tgt_miscdev);
-	if (err)
-		goto free_rx_ring;
-
-	return 0;
-free_rx_ring:
-	tgt_ring_exit(&rx_ring);
-free_tx_ring:
-	tgt_ring_exit(&tx_ring);
-
-	return err;
-}
--- orig/linux-2.6.35/drivers/scsi/scsi_tgt_lib.c 21:27:39.757901065 +0400
+++ linux-2.6.35/drivers/scsi/scsi_tgt_lib.c 00:33:18.173901783 +0400
@@ -1,661 +0,0 @@
-/*
- * SCSI target lib functions
- *
- * Copyright (C) 2005 Mike Christie <michaelc@cs.wisc.edu>
- * Copyright (C) 2005 FUJITA Tomonori <tomof@acm.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-#include <linux/blkdev.h>
-#include <linux/hash.h>
-#include <linux/module.h>
-#include <linux/pagemap.h>
-#include <linux/slab.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_tgt.h>
-
-#include "scsi_tgt_priv.h"
-
-static struct workqueue_struct *scsi_tgtd;
-static struct kmem_cache *scsi_tgt_cmd_cache;
-
-/*
- * TODO: this struct will be killed when the block layer supports large bios
- * and James's work struct code is in
- */
-struct scsi_tgt_cmd {
-	/* TODO replace work with James b's code */
-	struct work_struct work;
-	/* TODO fix limits of some drivers */
-	struct bio *bio;
-
-	struct list_head hash_list;
-	struct request *rq;
-	u64 itn_id;
-	u64 tag;
-};
-
-#define TGT_HASH_ORDER	4
-#define cmd_hashfn(tag)	hash_long((unsigned long) (tag), TGT_HASH_ORDER)
-
-struct scsi_tgt_queuedata {
-	struct Scsi_Host *shost;
-	struct list_head cmd_hash[1 << TGT_HASH_ORDER];
-	spinlock_t cmd_hash_lock;
-};
-
-/*
- * Function:	scsi_host_get_command()
- *
- * Purpose:	Allocate and setup a scsi command block and blk request
- *
- * Arguments:	shost	- scsi host
- *		data_dir - dma data dir
- *		gfp_mask- allocator flags
- *
- * Returns:	The allocated scsi command structure.
- *
- * This should be called by target LLDs to get a command.
- */
-struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *shost,
-					enum dma_data_direction data_dir,
-					gfp_t gfp_mask)
-{
-	int write = (data_dir == DMA_TO_DEVICE);
-	struct request *rq;
-	struct scsi_cmnd *cmd;
-	struct scsi_tgt_cmd *tcmd;
-
-	/* Bail if we can't get a reference to the device */
-	if (!get_device(&shost->shost_gendev))
-		return NULL;
-
-	tcmd = kmem_cache_alloc(scsi_tgt_cmd_cache, GFP_ATOMIC);
-	if (!tcmd)
-		goto put_dev;
-
-	/*
-	 * The blk helpers are used to the READ/WRITE requests
-	 * transfering data from a initiator point of view. Since
-	 * we are in target mode we want the opposite.
-	 */
-	rq = blk_get_request(shost->uspace_req_q, !write, gfp_mask);
-	if (!rq)
-		goto free_tcmd;
-
-	cmd = __scsi_get_command(shost, gfp_mask);
-	if (!cmd)
-		goto release_rq;
-
-	cmd->sc_data_direction = data_dir;
-	cmd->jiffies_at_alloc = jiffies;
-	cmd->request = rq;
-
-	cmd->cmnd = rq->cmd;
-
-	rq->special = cmd;
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_flags |= REQ_TYPE_BLOCK_PC;
-	rq->end_io_data = tcmd;
-
-	tcmd->rq = rq;
-
-	return cmd;
-
-release_rq:
-	blk_put_request(rq);
-free_tcmd:
-	kmem_cache_free(scsi_tgt_cmd_cache, tcmd);
-put_dev:
-	put_device(&shost->shost_gendev);
-	return NULL;
-
-}
-EXPORT_SYMBOL_GPL(scsi_host_get_command);
-
-/*
- * Function:	scsi_host_put_command()
- *
- * Purpose:	Free a scsi command block
- *
- * Arguments:	shost	- scsi host
- * 		cmd	- command block to free
- *
- * Returns:	Nothing.
- *
- * Notes:	The command must not belong to any lists.
- */
-void scsi_host_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
-{
-	struct request_queue *q = shost->uspace_req_q;
-	struct request *rq = cmd->request;
-	struct scsi_tgt_cmd *tcmd = rq->end_io_data;
-	unsigned long flags;
-
-	kmem_cache_free(scsi_tgt_cmd_cache, tcmd);
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	__blk_put_request(q, rq);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	__scsi_put_command(shost, cmd, &shost->shost_gendev);
-}
-EXPORT_SYMBOL_GPL(scsi_host_put_command);
-
-static void cmd_hashlist_del(struct scsi_cmnd *cmd)
-{
-	struct request_queue *q = cmd->request->q;
-	struct scsi_tgt_queuedata *qdata = q->queuedata;
-	unsigned long flags;
-	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
-
-	spin_lock_irqsave(&qdata->cmd_hash_lock, flags);
-	list_del(&tcmd->hash_list);
-	spin_unlock_irqrestore(&qdata->cmd_hash_lock, flags);
-}
-
-static void scsi_unmap_user_pages(struct scsi_tgt_cmd *tcmd)
-{
-	blk_rq_unmap_user(tcmd->bio);
-}
-
-static void scsi_tgt_cmd_destroy(struct work_struct *work)
-{
-	struct scsi_tgt_cmd *tcmd =
-		container_of(work, struct scsi_tgt_cmd, work);
-	struct scsi_cmnd *cmd = tcmd->rq->special;
-
-	dprintk("cmd %p %d %u\n", cmd, cmd->sc_data_direction,
-		rq_data_dir(cmd->request));
-	scsi_unmap_user_pages(tcmd);
-	scsi_host_put_command(scsi_tgt_cmd_to_host(cmd), cmd);
-}
-
-static void init_scsi_tgt_cmd(struct request *rq, struct scsi_tgt_cmd *tcmd,
-			      u64 itn_id, u64 tag)
-{
-	struct scsi_tgt_queuedata *qdata = rq->q->queuedata;
-	unsigned long flags;
-	struct list_head *head;
-
-	tcmd->itn_id = itn_id;
-	tcmd->tag = tag;
-	tcmd->bio = NULL;
-	INIT_WORK(&tcmd->work, scsi_tgt_cmd_destroy);
-	spin_lock_irqsave(&qdata->cmd_hash_lock, flags);
-	head = &qdata->cmd_hash[cmd_hashfn(tag)];
-	list_add(&tcmd->hash_list, head);
-	spin_unlock_irqrestore(&qdata->cmd_hash_lock, flags);
-}
-
-/*
- * scsi_tgt_alloc_queue - setup queue used for message passing
- * shost: scsi host
- *
- * This should be called by the LLD after host allocation.
- * And will be released when the host is released.
- */
-int scsi_tgt_alloc_queue(struct Scsi_Host *shost)
-{
-	struct scsi_tgt_queuedata *queuedata;
-	struct request_queue *q;
-	int err, i;
-
-	/*
-	 * Do we need to send a netlink event or should uspace
-	 * just respond to the hotplug event?
-	 */
-	q = __scsi_alloc_queue(shost, NULL);
-	if (!q)
-		return -ENOMEM;
-
-	queuedata = kzalloc(sizeof(*queuedata), GFP_KERNEL);
-	if (!queuedata) {
-		err = -ENOMEM;
-		goto cleanup_queue;
-	}
-	queuedata->shost = shost;
-	q->queuedata = queuedata;
-
-	/*
-	 * this is a silly hack. We should probably just queue as many
-	 * command as is recvd to userspace. uspace can then make
-	 * sure we do not overload the HBA
-	 */
-	q->nr_requests = shost->can_queue;
-	/*
-	 * We currently only support software LLDs so this does
-	 * not matter for now. Do we need this for the cards we support?
-	 * If so we should make it a host template value.
-	 */
-	blk_queue_dma_alignment(q, 0);
-	shost->uspace_req_q = q;
-
-	for (i = 0; i < ARRAY_SIZE(queuedata->cmd_hash); i++)
-		INIT_LIST_HEAD(&queuedata->cmd_hash[i]);
-	spin_lock_init(&queuedata->cmd_hash_lock);
-
-	return 0;
-
-cleanup_queue:
-	blk_cleanup_queue(q);
-	return err;
-}
-EXPORT_SYMBOL_GPL(scsi_tgt_alloc_queue);
-
-void scsi_tgt_free_queue(struct Scsi_Host *shost)
-{
-	int i;
-	unsigned long flags;
-	struct request_queue *q = shost->uspace_req_q;
-	struct scsi_cmnd *cmd;
-	struct scsi_tgt_queuedata *qdata = q->queuedata;
-	struct scsi_tgt_cmd *tcmd, *n;
-	LIST_HEAD(cmds);
-
-	spin_lock_irqsave(&qdata->cmd_hash_lock, flags);
-
-	for (i = 0; i < ARRAY_SIZE(qdata->cmd_hash); i++) {
-		list_for_each_entry_safe(tcmd, n, &qdata->cmd_hash[i],
-					 hash_list) {
-			list_del(&tcmd->hash_list);
-			list_add(&tcmd->hash_list, &cmds);
-		}
-	}
-
-	spin_unlock_irqrestore(&qdata->cmd_hash_lock, flags);
-
-	while (!list_empty(&cmds)) {
-		tcmd = list_entry(cmds.next, struct scsi_tgt_cmd, hash_list);
-		list_del(&tcmd->hash_list);
-		cmd = tcmd->rq->special;
-
-		shost->hostt->eh_abort_handler(cmd);
-		scsi_tgt_cmd_destroy(&tcmd->work);
-	}
-}
-EXPORT_SYMBOL_GPL(scsi_tgt_free_queue);
-
-struct Scsi_Host *scsi_tgt_cmd_to_host(struct scsi_cmnd *cmd)
-{
-	struct scsi_tgt_queuedata *queue = cmd->request->q->queuedata;
-	return queue->shost;
-}
-EXPORT_SYMBOL_GPL(scsi_tgt_cmd_to_host);
-
-/*
- * scsi_tgt_queue_command - queue command for userspace processing
- * @cmd:	scsi command
- * @scsilun:	scsi lun
- * @tag:	unique value to identify this command for tmf
- */
-int scsi_tgt_queue_command(struct scsi_cmnd *cmd, u64 itn_id,
-			   struct scsi_lun *scsilun, u64 tag)
-{
-	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
-	int err;
-
-	init_scsi_tgt_cmd(cmd->request, tcmd, itn_id, tag);
-	err = scsi_tgt_uspace_send_cmd(cmd, itn_id, scsilun, tag);
-	if (err)
-		cmd_hashlist_del(cmd);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(scsi_tgt_queue_command);
-
-/*
- * This is run from a interrupt handler normally and the unmap
- * needs process context so we must queue
- */
-static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
-{
-	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
-
-	dprintk("cmd %p %u\n", cmd, rq_data_dir(cmd->request));
-
-	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
-
-	scsi_release_buffers(cmd);
-
-	queue_work(scsi_tgtd, &tcmd->work);
-}
-
-static int scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
-{
-	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
-	int err;
-
-	dprintk("cmd %p %u\n", cmd, rq_data_dir(cmd->request));
-
-	err = shost->hostt->transfer_response(cmd, scsi_tgt_cmd_done);
-	switch (err) {
-	case SCSI_MLQUEUE_HOST_BUSY:
-	case SCSI_MLQUEUE_DEVICE_BUSY:
-		return -EAGAIN;
-	}
-	return 0;
-}
-
-/* TODO: test this crap and replace bio_map_user with new interface maybe */
-static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
-			       unsigned long uaddr, unsigned int len, int rw)
-{
-	struct request_queue *q = cmd->request->q;
-	struct request *rq = cmd->request;
-	int err;
-
-	dprintk("%lx %u\n", uaddr, len);
-	err = blk_rq_map_user(q, rq, NULL, (void *)uaddr, len, GFP_KERNEL);
-	if (err) {
-		/*
-		 * TODO: need to fixup sg_tablesize, max_segment_size,
-		 * max_sectors, etc for modern HW and software drivers
-		 * where this value is bogus.
-		 *
-		 * TODO2: we can alloc a reserve buffer of max size
-		 * we can handle and do the slow copy path for really large
-		 * IO.
-		 */
-		eprintk("Could not handle request of size %u.\n", len);
-		return err;
-	}
-
-	tcmd->bio = rq->bio;
-	err = scsi_init_io(cmd, GFP_KERNEL);
-	if (err) {
-		scsi_release_buffers(cmd);
-		goto unmap_rq;
-	}
-	/*
-	 * we use REQ_TYPE_BLOCK_PC so scsi_init_io doesn't set the
-	 * length for us.
-	 */
-	cmd->sdb.length = blk_rq_bytes(rq);
-
-	return 0;
-
-unmap_rq:
-	scsi_unmap_user_pages(tcmd);
-	return err;
-}
-
-static int scsi_tgt_copy_sense(struct scsi_cmnd *cmd, unsigned long uaddr,
-				unsigned len)
-{
-	char __user *p = (char __user *) uaddr;
-
-	if (copy_from_user(cmd->sense_buffer, p,
-			   min_t(unsigned, SCSI_SENSE_BUFFERSIZE, len))) {
-		printk(KERN_ERR "Could not copy the sense buffer\n");
-		return -EIO;
-	}
-	return 0;
-}
-
-static int scsi_tgt_abort_cmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
-{
-	struct scsi_tgt_cmd *tcmd;
-	int err;
-
-	err = shost->hostt->eh_abort_handler(cmd);
-	if (err)
-		eprintk("fail to abort %p\n", cmd);
-
-	tcmd = cmd->request->end_io_data;
-	scsi_tgt_cmd_destroy(&tcmd->work);
-	return err;
-}
-
-static struct request *tgt_cmd_hash_lookup(struct request_queue *q, u64 tag)
-{
-	struct scsi_tgt_queuedata *qdata = q->queuedata;
-	struct request *rq = NULL;
-	struct list_head *head;
-	struct scsi_tgt_cmd *tcmd;
-	unsigned long flags;
-
-	head = &qdata->cmd_hash[cmd_hashfn(tag)];
-	spin_lock_irqsave(&qdata->cmd_hash_lock, flags);
-	list_for_each_entry(tcmd, head, hash_list) {
-		if (tcmd->tag == tag) {
-			rq = tcmd->rq;
-			list_del(&tcmd->hash_list);
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&qdata->cmd_hash_lock, flags);
-
-	return rq;
-}
-
-int scsi_tgt_kspace_exec(int host_no, u64 itn_id, int result, u64 tag,
-			 unsigned long uaddr, u32 len, unsigned long sense_uaddr,
-			 u32 sense_len, u8 rw)
-{
-	struct Scsi_Host *shost;
-	struct scsi_cmnd *cmd;
-	struct request *rq;
-	struct scsi_tgt_cmd *tcmd;
-	int err = 0;
-
-	dprintk("%d %llu %d %u %lx %u\n", host_no, (unsigned long long) tag,
-		result, len, uaddr, rw);
-
-	/* TODO: replace with a O(1) alg */
-	shost = scsi_host_lookup(host_no);
-	if (!shost) {
-		printk(KERN_ERR "Could not find host no %d\n", host_no);
-		return -EINVAL;
-	}
-
-	if (!shost->uspace_req_q) {
-		printk(KERN_ERR "Not target scsi host %d\n", host_no);
-		goto done;
-	}
-
-	rq = tgt_cmd_hash_lookup(shost->uspace_req_q, tag);
-	if (!rq) {
-		printk(KERN_ERR "Could not find tag %llu\n",
-		       (unsigned long long) tag);
-		err = -EINVAL;
-		goto done;
-	}
-	cmd = rq->special;
-
-	dprintk("cmd %p scb %x result %d len %d bufflen %u %u %x\n",
-		cmd, cmd->cmnd[0], result, len, scsi_bufflen(cmd),
-		rq_data_dir(rq), cmd->cmnd[0]);
-
-	if (result == TASK_ABORTED) {
-		scsi_tgt_abort_cmd(shost, cmd);
-		goto done;
-	}
-	/*
-	 * store the userspace values here, the working values are
-	 * in the request_* values
-	 */
-	tcmd = cmd->request->end_io_data;
-	cmd->result = result;
-
-	if (cmd->result == SAM_STAT_CHECK_CONDITION)
-		scsi_tgt_copy_sense(cmd, sense_uaddr, sense_len);
-
-	if (len) {
-		err = scsi_map_user_pages(rq->end_io_data, cmd, uaddr, len, rw);
-		if (err) {
-			/*
-			 * user-space daemon bugs or OOM
-			 * TODO: we can do better for OOM.
-			 */
-			struct scsi_tgt_queuedata *qdata;
-			struct list_head *head;
-			unsigned long flags;
-
-			eprintk("cmd %p ret %d uaddr %lx len %d rw %d\n",
-				cmd, err, uaddr, len, rw);
-
-			qdata = shost->uspace_req_q->queuedata;
-			head = &qdata->cmd_hash[cmd_hashfn(tcmd->tag)];
-
-			spin_lock_irqsave(&qdata->cmd_hash_lock, flags);
-			list_add(&tcmd->hash_list, head);
-			spin_unlock_irqrestore(&qdata->cmd_hash_lock, flags);
-
-			goto done;
-		}
-	}
-	err = scsi_tgt_transfer_response(cmd);
-done:
-	scsi_host_put(shost);
-	return err;
-}
-
-int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *shost, u64 itn_id,
-			      int function, u64 tag, struct scsi_lun *scsilun,
-			      void *data)
-{
-	int err;
-
-	/* TODO: need to retry if this fails. */
-	err = scsi_tgt_uspace_send_tsk_mgmt(shost->host_no, itn_id,
-					    function, tag, scsilun, data);
-	if (err < 0)
-		eprintk("The task management request lost!\n");
-	return err;
-}
-EXPORT_SYMBOL_GPL(scsi_tgt_tsk_mgmt_request);
-
-int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 itn_id, u64 mid, int result)
-{
-	struct Scsi_Host *shost;
-	int err = -EINVAL;
-
-	dprintk("%d %d %llx\n", host_no, result, (unsigned long long) mid);
-
-	shost = scsi_host_lookup(host_no);
-	if (!shost) {
-		printk(KERN_ERR "Could not find host no %d\n", host_no);
-		return err;
-	}
-
-	if (!shost->uspace_req_q) {
-		printk(KERN_ERR "Not target scsi host %d\n", host_no);
-		goto done;
-	}
-
-	err = shost->transportt->tsk_mgmt_response(shost, itn_id, mid, result);
-done:
-	scsi_host_put(shost);
-	return err;
-}
-
-int scsi_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
-			     char *initiator)
-{
-	int err;
-
-	/* TODO: need to retry if this fails. */
-	err = scsi_tgt_uspace_send_it_nexus_request(shost->host_no, itn_id, 0,
-						    initiator);
-	if (err < 0)
-		eprintk("The i_t_neuxs request lost, %d %llx!\n",
-			shost->host_no, (unsigned long long)itn_id);
-	return err;
-}
-EXPORT_SYMBOL_GPL(scsi_tgt_it_nexus_create);
-
-int scsi_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
-{
-	int err;
-
-	/* TODO: need to retry if this fails. */
-	err = scsi_tgt_uspace_send_it_nexus_request(shost->host_no,
-						    itn_id, 1, NULL);
-	if (err < 0)
-		eprintk("The i_t_neuxs request lost, %d %llx!\n",
-			shost->host_no, (unsigned long long)itn_id);
-	return err;
-}
-EXPORT_SYMBOL_GPL(scsi_tgt_it_nexus_destroy);
-
-int scsi_tgt_kspace_it_nexus_rsp(int host_no, u64 itn_id, int result)
-{
-	struct Scsi_Host *shost;
-	int err = -EINVAL;
-
-	dprintk("%d %d%llx\n", host_no, result, (unsigned long long)itn_id);
-
-	shost = scsi_host_lookup(host_no);
-	if (!shost) {
-		printk(KERN_ERR "Could not find host no %d\n", host_no);
-		return err;
-	}
-
-	if (!shost->uspace_req_q) {
-		printk(KERN_ERR "Not target scsi host %d\n", host_no);
-		goto done;
-	}
-
-	err = shost->transportt->it_nexus_response(shost, itn_id, result);
-done:
-	scsi_host_put(shost);
-	return err;
-}
-
-static int __init scsi_tgt_init(void)
-{
-	int err;
-
-	scsi_tgt_cmd_cache =  KMEM_CACHE(scsi_tgt_cmd, 0);
-	if (!scsi_tgt_cmd_cache)
-		return -ENOMEM;
-
-	scsi_tgtd = create_workqueue("scsi_tgtd");
-	if (!scsi_tgtd) {
-		err = -ENOMEM;
-		goto free_kmemcache;
-	}
-
-	err = scsi_tgt_if_init();
-	if (err)
-		goto destroy_wq;
-
-	return 0;
-
-destroy_wq:
-	destroy_workqueue(scsi_tgtd);
-free_kmemcache:
-	kmem_cache_destroy(scsi_tgt_cmd_cache);
-	return err;
-}
-
-static void __exit scsi_tgt_exit(void)
-{
-	destroy_workqueue(scsi_tgtd);
-	scsi_tgt_if_exit();
-	kmem_cache_destroy(scsi_tgt_cmd_cache);
-}
-
-module_init(scsi_tgt_init);
-module_exit(scsi_tgt_exit);
-
-MODULE_DESCRIPTION("SCSI target core");
-MODULE_LICENSE("GPL");
--- orig/linux-2.6.35/drivers/scsi/scsi_tgt_priv.h 21:27:39.757901065 +0400
+++ linux-2.6.35/drivers/scsi/scsi_tgt_priv.h 00:33:18.173901783 +0400
@@ -1,32 +0,0 @@
-struct scsi_cmnd;
-struct scsi_lun;
-struct Scsi_Host;
-struct task_struct;
-
-/* tmp - will replace with SCSI logging stuff */
-#define eprintk(fmt, args...)					\
-do {								\
-	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
-} while (0)
-
-#define dprintk(fmt, args...)
-/* #define dprintk eprintk */
-
-extern void scsi_tgt_if_exit(void);
-extern int scsi_tgt_if_init(void);
-
-extern int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, u64 it_nexus_id,
-				    struct scsi_lun *lun, u64 tag);
-extern int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 it_nexus_id,
-				       u64 tag);
-extern int scsi_tgt_kspace_exec(int host_no, u64 it_nexus_id, int result, u64 tag,
-				unsigned long uaddr, u32 len,
-				unsigned long sense_uaddr, u32 sense_len, u8 rw);
-extern int scsi_tgt_uspace_send_tsk_mgmt(int host_no, u64 it_nexus_id,
-					 int function, u64 tag,
-					 struct scsi_lun *scsilun, void *data);
-extern int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 it_nexus_id,
-				    u64 mid, int result);
-extern int scsi_tgt_uspace_send_it_nexus_request(int host_no, u64 it_nexus_id,
-						 int function, char *initiator);
-extern int scsi_tgt_kspace_it_nexus_rsp(int host_no, u64 it_nexus_id, int result);
--- orig/linux-2.6.35/drivers/scsi/scsi_transport_fc.c 00:33:17.745901144 +0400
+++ linux-2.6.35/drivers/scsi/scsi_transport_fc.c 14:43:16.170085979 +0400
@@ -39,7 +39,6 @@
 #include <scsi/scsi_netlink_fc.h>
 #include <scsi/scsi_bsg_fc.h>
 #include "scsi_priv.h"
-#include "scsi_transport_fc_internal.h"
 
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
 static void fc_vport_sched_delete(struct work_struct *work);
@@ -2908,10 +2907,6 @@ fc_remote_port_delete(struct fc_rport  *
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (rport->roles & FC_PORT_ROLE_FCP_INITIATOR &&
-	    shost->active_mode & MODE_TARGET)
-		fc_tgt_it_nexus_destroy(shost, (unsigned long)rport);
-
 	scsi_target_block(&rport->dev);
 
 	/* see if we need to kill io faster than waiting for device loss */
@@ -2952,7 +2947,6 @@ fc_remote_port_rolechg(struct fc_rport  
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	unsigned long flags;
 	int create = 0;
-	int ret;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (roles & FC_PORT_ROLE_FCP_TARGET) {
@@ -2961,12 +2955,6 @@ fc_remote_port_rolechg(struct fc_rport  
 			create = 1;
 		} else if (!(rport->roles & FC_PORT_ROLE_FCP_TARGET))
 			create = 1;
-	} else if (shost->active_mode & MODE_TARGET) {
-		ret = fc_tgt_it_nexus_create(shost, (unsigned long)rport,
-					     (char *)&rport->node_name);
-		if (ret)
-			printk(KERN_ERR "FC Remore Port tgt nexus failed %d\n",
-			       ret);
 	}
 
 	rport->roles = roles;
--- orig/linux-2.6.35/drivers/scsi/scsi_transport_fc_internal.h 21:27:39.757901065 +0400
+++ linux-2.6.35/drivers/scsi/scsi_transport_fc_internal.h 00:33:18.173901783 +0400
@@ -1,26 +0,0 @@
-#include <scsi/scsi_tgt.h>
-
-#ifdef CONFIG_SCSI_FC_TGT_ATTRS
-static inline int fc_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
-					 char *initiator)
-{
-	return scsi_tgt_it_nexus_create(shost, itn_id, initiator);
-}
-
-static inline int fc_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
-{
-	return scsi_tgt_it_nexus_destroy(shost, itn_id);
-}
-#else
-static inline int fc_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
-					 char *initiator)
-{
-	return 0;
-}
-
-static inline int fc_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
-{
-	return 0;
-}
-
-#endif
--- orig/linux-2.6.35/drivers/scsi/scsi_transport_srp.c 00:33:17.745901144 +0400
+++ linux-2.6.35/drivers/scsi/scsi_transport_srp.c 14:43:16.201587395 +0400
@@ -30,7 +30,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_srp.h>
-#include "scsi_transport_srp_internal.h"
 
 struct srp_host_attrs {
 	atomic_t next_port_id;
@@ -223,18 +222,6 @@ struct srp_rport *srp_rport_add(struct S
 		return ERR_PTR(ret);
 	}
 
-	if (shost->active_mode & MODE_TARGET &&
-	    ids->roles == SRP_RPORT_ROLE_INITIATOR) {
-		ret = srp_tgt_it_nexus_create(shost, (unsigned long)rport,
-					      rport->port_id);
-		if (ret) {
-			device_del(&rport->dev);
-			transport_destroy_device(&rport->dev);
-			put_device(&rport->dev);
-			return ERR_PTR(ret);
-		}
-	}
-
 	transport_add_device(&rport->dev);
 	transport_configure_device(&rport->dev);
 
@@ -251,11 +238,6 @@ EXPORT_SYMBOL_GPL(srp_rport_add);
 void srp_rport_del(struct srp_rport *rport)
 {
 	struct device *dev = &rport->dev;
-	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-
-	if (shost->active_mode & MODE_TARGET &&
-	    rport->roles == SRP_RPORT_ROLE_INITIATOR)
-		srp_tgt_it_nexus_destroy(shost, (unsigned long)rport);
 
 	transport_remove_device(dev);
 	device_del(dev);
--- orig/linux-2.6.35/drivers/scsi/scsi_transport_srp_internal.h 21:27:39.753900649 +0400
+++ linux-2.6.35/drivers/scsi/scsi_transport_srp_internal.h 00:33:18.169901710 +0400
@@ -1,25 +0,0 @@
-#include <scsi/scsi_tgt.h>
-
-#ifdef CONFIG_SCSI_SRP_TGT_ATTRS
-static inline int srp_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
-					  char *initiator)
-{
-	return scsi_tgt_it_nexus_create(shost, itn_id, initiator);
-}
-
-static inline int srp_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
-{
-	return scsi_tgt_it_nexus_destroy(shost, itn_id);
-}
-
-#else
-static inline int srp_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
-					  char *initiator)
-{
-	return 0;
-}
-static inline int srp_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
-{
-	return 0;
-}
-#endif
--- orig/linux-2.6.35/include/scsi/scsi_host.h 21:27:39.753900649 +0400
+++ linux-2.6.35/include/scsi/scsi_host.h 22:00:10.726089770 +0400
@@ -36,10 +36,6 @@ struct blk_queue_tags;
 #define SG_NONE 0
 #define SG_ALL	SCSI_MAX_SG_SEGMENTS
 
-#define MODE_UNKNOWN 0x00
-#define MODE_INITIATOR 0x01
-#define MODE_TARGET 0x02
-
 #define DISABLE_CLUSTERING 0
 #define ENABLE_CLUSTERING 1
 
@@ -131,27 +127,6 @@ struct scsi_host_template {
 			     void (*done)(struct scsi_cmnd *));
 
 	/*
-	 * The transfer functions are used to queue a scsi command to
-	 * the LLD. When the driver is finished processing the command
-	 * the done callback is invoked.
-	 *
-	 * This is called to inform the LLD to transfer
-	 * scsi_bufflen(cmd) bytes. scsi_sg_count(cmd) speciefies the
-	 * number of scatterlist entried in the command and
-	 * scsi_sglist(cmd) returns the scatterlist.
-	 *
-	 * return values: see queuecommand
-	 *
-	 * If the LLD accepts the cmd, it should set the result to an
-	 * appropriate value when completed before calling the done function.
-	 *
-	 * STATUS: REQUIRED FOR TARGET DRIVERS
-	 */
-	/* TODO: rename */
-	int (* transfer_response)(struct scsi_cmnd *,
-				  void (*done)(struct scsi_cmnd *));
-
-	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
 	 * routine that is present that should work in most cases.  For those
@@ -426,11 +401,6 @@ struct scsi_host_template {
 	unsigned char present;
 
 	/*
-	 * This specifies the mode that a LLD supports.
-	 */
-	unsigned supported_mode:2;
-
-	/*
 	 * True if this host adapter uses unchecked DMA onto an ISA bus.
 	 */
 	unsigned unchecked_isa_dma:1;
@@ -607,7 +577,6 @@ struct Scsi_Host {
 	 */
 	unsigned long cmd_serial_number;
 	
-	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
 	unsigned use_blk_tcq:1;
--- orig/linux-2.6.35/include/scsi/scsi_tgt.h 21:27:39.753900649 +0400
+++ linux-2.6.35/include/scsi/scsi_tgt.h 00:33:18.173901783 +0400
@@ -1,21 +0,0 @@
-/*
- * SCSI target definitions
- */
-
-#include <linux/dma-mapping.h>
-
-struct Scsi_Host;
-struct scsi_cmnd;
-struct scsi_lun;
-
-extern struct Scsi_Host *scsi_tgt_cmd_to_host(struct scsi_cmnd *);
-extern int scsi_tgt_alloc_queue(struct Scsi_Host *);
-extern void scsi_tgt_free_queue(struct Scsi_Host *);
-extern int scsi_tgt_queue_command(struct scsi_cmnd *, u64, struct scsi_lun *, u64);
-extern int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *, u64, int, u64,
-				     struct scsi_lun *, void *);
-extern struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *,
-					       enum dma_data_direction,	gfp_t);
-extern void scsi_host_put_command(struct Scsi_Host *, struct scsi_cmnd *);
-extern int scsi_tgt_it_nexus_create(struct Scsi_Host *, u64, char *);
-extern int scsi_tgt_it_nexus_destroy(struct Scsi_Host *, u64);
--- orig/linux-2.6.35/include/scsi/scsi_tgt_if.h 21:27:39.741900784 +0400
+++ linux-2.6.35/include/scsi/scsi_tgt_if.h 00:33:18.169901710 +0400
@@ -1,108 +0,0 @@
-/*
- * SCSI target kernel/user interface
- *
- * Copyright (C) 2005 FUJITA Tomonori <tomof@acm.org>
- * Copyright (C) 2005 Mike Christie <michaelc@cs.wisc.edu>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-#ifndef __SCSI_TARGET_IF_H
-#define __SCSI_TARGET_IF_H
-
-/* user -> kernel */
-#define	TGT_UEVENT_CMD_RSP		0x0001
-#define	TGT_UEVENT_IT_NEXUS_RSP		0x0002
-#define	TGT_UEVENT_TSK_MGMT_RSP		0x0003
-
-/* kernel -> user */
-#define	TGT_KEVENT_CMD_REQ		0x1001
-#define	TGT_KEVENT_CMD_DONE		0x1002
-#define	TGT_KEVENT_IT_NEXUS_REQ		0x1003
-#define	TGT_KEVENT_TSK_MGMT_REQ		0x1004
-
-struct tgt_event_hdr {
-	uint16_t version;
-	uint16_t status;
-	uint16_t type;
-	uint16_t len;
-} __attribute__ ((aligned (sizeof(uint64_t))));
-
-struct tgt_event {
-	struct tgt_event_hdr hdr;
-
-	union {
-		/* user-> kernel */
-		struct {
-			int host_no;
-			int result;
-			aligned_u64 itn_id;
-			aligned_u64 tag;
-			aligned_u64 uaddr;
-			aligned_u64 sense_uaddr;
-			uint32_t len;
-			uint32_t sense_len;
-			uint8_t rw;
-		} cmd_rsp;
-		struct {
-			int host_no;
-			int result;
-			aligned_u64 itn_id;
-			aligned_u64 mid;
-		} tsk_mgmt_rsp;
-		struct {
-			__s32 host_no;
-			__s32 result;
-			aligned_u64 itn_id;
-			__u32 function;
-		} it_nexus_rsp;
-
-		/* kernel -> user */
-		struct {
-			int host_no;
-			uint32_t data_len;
-			aligned_u64 itn_id;
-			uint8_t scb[16];
-			uint8_t lun[8];
-			int attribute;
-			aligned_u64 tag;
-		} cmd_req;
-		struct {
-			int host_no;
-			int result;
-			aligned_u64 itn_id;
-			aligned_u64 tag;
-		} cmd_done;
-		struct {
-			int host_no;
-			int function;
-			aligned_u64 itn_id;
-			aligned_u64 tag;
-			uint8_t lun[8];
-			aligned_u64 mid;
-		} tsk_mgmt_req;
-		struct {
-			__s32 host_no;
-			__u32 function;
-			aligned_u64 itn_id;
-			__u32 max_cmds;
-			__u8 initiator_id[16];
-		} it_nexus_req;
-	} p;
-} __attribute__ ((aligned (sizeof(uint64_t))));
-
-#define TGT_RING_SIZE (1UL << 16)
-
-#endif
