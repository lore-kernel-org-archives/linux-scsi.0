From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 9/9] [SCSI] mvsas: Add support for interrupt tasklet
Date: Tue, 26 Jul 2011 11:53:00 +0400
Message-ID: <1311666780.17353.8.camel@mulgrave>
References: <1309444056-29277-1-git-send-email-yxlraid@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1309444056-29277-1-git-send-email-yxlraid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yxlraid@gmail.com
Cc: James.Bottomley@suse.de, jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-06-30 at 22:27 +0800, yxlraid@gmail.com wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
> 
> -- Add support for interrupt tasklet, which will improve performance.
> -- Correct spelling of "20011"
> 
> Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
> ---
>  drivers/scsi/mvsas/Kconfig   |    9 ++++++++-
>  drivers/scsi/mvsas/Makefile  |    1 +
>  drivers/scsi/mvsas/mv_64xx.c |    6 ++----
>  drivers/scsi/mvsas/mv_94xx.c |    5 +----
>  drivers/scsi/mvsas/mv_init.c |   32 ++++++++++++++++++++------------
>  drivers/scsi/mvsas/mv_sas.h  |    1 +
>  6 files changed, 33 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
> index c82b012..78f7e20 100644
> --- a/drivers/scsi/mvsas/Kconfig
> +++ b/drivers/scsi/mvsas/Kconfig
> @@ -3,7 +3,7 @@
>  #
>  # Copyright 2007 Red Hat, Inc.
>  # Copyright 2008 Marvell. <kewei@marvell.com>
> -# Copyright 2009-20011 Marvell. <yuxiangl@marvell.com>
> +# Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
>  #
>  # This file is licensed under GPLv2.
>  #
> @@ -41,3 +41,10 @@ config SCSI_MVSAS_DEBUG
>  	help
>  		Compiles the 88SE64XX/88SE94XX driver in debug mode.  In debug mode,
>  		the driver prints some messages to the console.
> +config SCSI_MVSAS_TASKLET
> +	bool "Support for interrupt tasklet"
> +	default n
> +	depends on SCSI_MVSAS
> +	help
> +		Compiles the 88SE64xx/88SE94xx driver in interrupt tasklet mode.In this mode,
> +		the interrupt will schedule a tasklet.
> diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
> index 87b231a..40aae8a 100644
> --- a/drivers/scsi/mvsas/Makefile
> +++ b/drivers/scsi/mvsas/Makefile
> @@ -23,6 +23,7 @@
>  # USA
>  
>  ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) := -DMV_DEBUG
> +ccflags-$(CONFIG_SCSI_MVSAS_TASKLET) := -DMVS_USE_TASKLET

There's no need for this #define indirection: just use the config
variable (I fixed this up, see below).

I also fixed an unused variable with one of the branches of the ifdef,
see below.

In general, this sort of nastiness makes it more optimal to use C to do
the ifdef instead of preprocessor, something like

#ifdef CONFIG_SCSI_MVSAS_TASKLET
static const int mvs_use_tasklet = 1
#else
static const int mvs_use_tasklet = 0
#endif

and then all the ifdefs become

if (mvs_use_tasklet)
	...

We can't get unused variable warnings and the compiler, since it should
know statically the value, should optimise out the unused legs of the
ifs.

James

---
diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
index 40aae8a..87b231a 100644
--- a/drivers/scsi/mvsas/Makefile
+++ b/drivers/scsi/mvsas/Makefile
@@ -23,7 +23,6 @@
 # USA
 
 ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) := -DMV_DEBUG
-ccflags-$(CONFIG_SCSI_MVSAS_TASKLET) := -DMVS_USE_TASKLET
 
 obj-$(CONFIG_SCSI_MVSAS) += mvsas.o
 mvsas-y +=  mv_init.o  \
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 77dea68..4e9af66 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -170,7 +170,7 @@ static void mvs_free(struct mvs_info *mvi)
 	kfree(mvi);
 }
 
-#ifdef MVS_USE_TASKLET
+#ifdef CONFIG_SCSI_MVSAS_TASKLET
 static void mvs_tasklet(unsigned long opaque)
 {
 	u32 stat;
@@ -201,29 +201,32 @@ out:
 
 static irqreturn_t mvs_interrupt(int irq, void *opaque)
 {
-	u32 core_nr, i = 0;
+	u32 core_nr;
 	u32 stat;
 	struct mvs_info *mvi;
 	struct sas_ha_struct *sha = opaque;
+#ifndef CONFIG_SCSI_MVSAS_TASKLET
+	u32 i;
+#endif
 
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
 
 	if (unlikely(!mvi))
 		return IRQ_NONE;
-#ifdef MVS_USE_TASKLET
+#ifdef CONFIG_SCSI_MVSAS_TASKLET
 	MVS_CHIP_DISP->interrupt_disable(mvi);
 #endif
 
 	stat = MVS_CHIP_DISP->isr_status(mvi, irq);
 	if (!stat) {
-	#ifdef MVS_USE_TASKLET
+	#ifdef CONFIG_SCSI_MVSAS_TASKLET
 		MVS_CHIP_DISP->interrupt_enable(mvi);
 	#endif
 		return IRQ_NONE;
 	}
 
-#ifdef MVS_USE_TASKLET
+#ifdef CONFIG_SCSI_MVSAS_TASKLET
 	tasklet_schedule(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #else
 	for (i = 0; i < core_nr; i++) {
@@ -607,7 +610,7 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 		nhost++;
 	} while (nhost < chip->n_host);
 	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
-#ifdef MVS_USE_TASKLET
+#ifdef CONFIG_SCSI_MVSAS_TASKLET
 	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
 		     (unsigned long)SHOST_TO_SAS_HA(shost));
 #endif
@@ -653,7 +656,7 @@ static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
 
-#ifdef MVS_USE_TASKLET
+#ifdef CONFIG_SCSI_MVSAS_TASKLET
 	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #endif
 
