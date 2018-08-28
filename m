From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: [PATCH 2/2] scsi: aic7xxx: Fix build using bare-metal toolchain
Date: Tue, 28 Aug 2018 17:24:21 +0300
Message-ID: <20180828142421.15335-3-semen.protsenko@linaro.org>
References: <20180828142421.15335-1-semen.protsenko@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180828142421.15335-1-semen.protsenko@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Praneeth Bajjuri <praneeth@ti.com>, Paul Sokolovsky <paul.sokolovsky@linaro.org>, Miklos Szeredi <mszeredi@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, Ruslan Bilovol <ruslan.bilovol@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Bare-metal toolchains don't define __linux__, so aic7xxx build with
bare-metal toolchain is broken. Let's check __KERNEL__ definition
instead of __linux__ (as this code won't be build for user-space anyway)
in order to fix that.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
---
 drivers/scsi/aic7xxx/aic7770.c                  |  2 +-
 drivers/scsi/aic7xxx/aic79xx.h                  |  4 ++--
 drivers/scsi/aic7xxx/aic79xx_core.c             | 12 ++++++------
 drivers/scsi/aic7xxx/aic79xx_pci.c              |  2 +-
 drivers/scsi/aic7xxx/aic7xxx.h                  |  4 ++--
 drivers/scsi/aic7xxx/aic7xxx_93cx6.c            |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c             | 12 ++++++------
 drivers/scsi/aic7xxx/aic7xxx_pci.c              |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm.h            |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y       |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l       |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c     |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h     |  2 +-
 15 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7770.c b/drivers/scsi/aic7xxx/aic7770.c
index 5000bd69c13f..b117992f8c04 100644
--- a/drivers/scsi/aic7xxx/aic7770.c
+++ b/drivers/scsi/aic7xxx/aic7770.c
@@ -42,7 +42,7 @@
  * $FreeBSD$
  */
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "aic7xxx_osm.h"
 #include "aic7xxx_inline.h"
 #include "aic7xxx_93cx6.h"
diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index 31f2bb9d7146..6226276770eb 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -607,7 +607,7 @@ struct scb {
 	ahd_io_ctx_t		  io_ctx;
 	struct ahd_softc	 *ahd_softc;
 	scb_flag		  flags;
-#ifndef __linux__
+#ifndef __KERNEL__
 	bus_dmamap_t		  dmamap;
 #endif
 	struct scb_platform_data *platform_data;
@@ -1056,7 +1056,7 @@ struct ahd_completion
 struct ahd_softc {
 	bus_space_tag_t           tags[2];
 	bus_space_handle_t        bshs[2];
-#ifndef __linux__
+#ifndef __KERNEL__
 	bus_dma_tag_t		  buffer_dmat;   /* dmat for buffer I/O */
 #endif
 	struct scb_data		  scb_data;
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 2d82ec85753e..8580cec85902 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -40,7 +40,7 @@
  * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#250 $
  */
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "aic79xx_osm.h"
 #include "aic79xx_inline.h"
 #include "aicasm/aicasm_insformat.h"
@@ -6172,7 +6172,7 @@ ahd_free(struct ahd_softc *ahd)
 	case 2:
 		ahd_dma_tag_destroy(ahd, ahd->shared_data_dmat);
 	case 1:
-#ifndef __linux__
+#ifndef __KERNEL__
 		ahd_dma_tag_destroy(ahd, ahd->buffer_dmat);
 #endif
 		break;
@@ -6180,7 +6180,7 @@ ahd_free(struct ahd_softc *ahd)
 		break;
 	}
 
-#ifndef __linux__
+#ifndef __KERNEL__
 	ahd_dma_tag_destroy(ahd, ahd->parent_dmat);
 #endif
 	ahd_platform_free(ahd);
@@ -6934,7 +6934,7 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 	for (i = 0; i < newcount; i++) {
 		struct scb_platform_data *pdata;
 		u_int col_tag;
-#ifndef __linux__
+#ifndef __KERNEL__
 		int error;
 #endif
 
@@ -6970,7 +6970,7 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 			next_scb->sg_list_busaddr += sizeof(struct ahd_dma_seg);
 		next_scb->ahd_softc = ahd;
 		next_scb->flags = SCB_FLAG_NONE;
-#ifndef __linux__
+#ifndef __KERNEL__
 		error = ahd_dmamap_create(ahd, ahd->buffer_dmat, /*flags*/0,
 					  &next_scb->dmamap);
 		if (error != 0) {
@@ -7091,7 +7091,7 @@ ahd_init(struct ahd_softc *ahd)
 	if ((AHD_TMODE_ENABLE & (0x1 << ahd->unit)) == 0)
 		ahd->features &= ~AHD_TARGETMODE;
 
-#ifndef __linux__
+#ifndef __KERNEL__
 	/* DMA tag for mapping buffers into device visible space. */
 	if (ahd_dma_tag_create(ahd, ahd->parent_dmat, /*alignment*/1,
 			       /*boundary*/BUS_SPACE_MAXADDR_32BIT + 1,
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index cc9bd26f5d1a..573a9aae51da 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -41,7 +41,7 @@
  * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#92 $
  */
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "aic79xx_osm.h"
 #include "aic79xx_inline.h"
 #else
diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index 4ce4e903a759..aa42f3ef79e5 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -568,7 +568,7 @@ struct scb {
 	ahc_io_ctx_t		  io_ctx;
 	struct ahc_softc	 *ahc_softc;
 	scb_flag		  flags;
-#ifndef __linux__
+#ifndef __KERNEL__
 	bus_dmamap_t		  dmamap;
 #endif
 	struct scb_platform_data *platform_data;
@@ -906,7 +906,7 @@ typedef void ahc_callback_t (void *);
 struct ahc_softc {
 	bus_space_tag_t           tag;
 	bus_space_handle_t        bsh;
-#ifndef __linux__
+#ifndef __KERNEL__
 	bus_dma_tag_t		  buffer_dmat;   /* dmat for buffer I/O */
 #endif
 	struct scb_data		 *scb_data;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_93cx6.c b/drivers/scsi/aic7xxx/aic7xxx_93cx6.c
index 9e85a7ef9c8e..434a4bfc6309 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_93cx6.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_93cx6.c
@@ -64,7 +64,7 @@
  *   bit to be sent from the chip.
  */
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "aic7xxx_osm.h"
 #include "aic7xxx_inline.h"
 #include "aic7xxx_93cx6.h"
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 915a34f141e4..67aa18982c7e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -40,7 +40,7 @@
  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#155 $
  */
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "aic7xxx_osm.h"
 #include "aic7xxx_inline.h"
 #include "aicasm/aicasm_insformat.h"
@@ -4509,7 +4509,7 @@ ahc_free(struct ahc_softc *ahc)
 	case 2:
 		ahc_dma_tag_destroy(ahc, ahc->shared_data_dmat);
 	case 1:
-#ifndef __linux__
+#ifndef __KERNEL__
 		ahc_dma_tag_destroy(ahc, ahc->buffer_dmat);
 #endif
 		break;
@@ -4517,7 +4517,7 @@ ahc_free(struct ahc_softc *ahc)
 		break;
 	}
 
-#ifndef __linux__
+#ifndef __KERNEL__
 	ahc_dma_tag_destroy(ahc, ahc->parent_dmat);
 #endif
 	ahc_platform_free(ahc);
@@ -5005,7 +5005,7 @@ ahc_alloc_scbs(struct ahc_softc *ahc)
 	newcount = min(newcount, (AHC_SCB_MAX_ALLOC - scb_data->numscbs));
 	for (i = 0; i < newcount; i++) {
 		struct scb_platform_data *pdata;
-#ifndef __linux__
+#ifndef __KERNEL__
 		int error;
 #endif
 		pdata = kmalloc(sizeof(*pdata), GFP_ATOMIC);
@@ -5021,7 +5021,7 @@ ahc_alloc_scbs(struct ahc_softc *ahc)
 		next_scb->sg_list_phys = physaddr + sizeof(struct ahc_dma_seg);
 		next_scb->ahc_softc = ahc;
 		next_scb->flags = SCB_FREE;
-#ifndef __linux__
+#ifndef __KERNEL__
 		error = ahc_dmamap_create(ahc, ahc->buffer_dmat, /*flags*/0,
 					  &next_scb->dmamap);
 		if (error != 0)
@@ -5325,7 +5325,7 @@ ahc_init(struct ahc_softc *ahc)
 	if ((AHC_TMODE_ENABLE & (0x1 << ahc->unit)) == 0)
 		ahc->features &= ~AHC_TARGETMODE;
 
-#ifndef __linux__
+#ifndef __KERNEL__
 	/* DMA tag for mapping buffers into device visible space. */
 	if (ahc_dma_tag_create(ahc, ahc->parent_dmat, /*alignment*/1,
 			       /*boundary*/BUS_SPACE_MAXADDR_32BIT + 1,
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index 673e826d7adb..83b72efbb6a6 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -42,7 +42,7 @@
  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#79 $
  */
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "aic7xxx_osm.h"
 #include "aic7xxx_inline.h"
 #include "aic7xxx_93cx6.h"
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm.h b/drivers/scsi/aic7xxx/aicasm/aicasm.h
index 51678dd46ff7..3465603e41ca 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm.h
@@ -42,7 +42,7 @@
  * $FreeBSD$
  */
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "../queue.h"
 #else
 #include <sys/queue.h>
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
index f1586a437906..403bc9c5d739 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -52,7 +52,7 @@
 #include <string.h>
 #include <sysexits.h>
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "../queue.h"
 #else
 #include <sys/queue.h>
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
index 708326df0766..695f45e0a995 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
@@ -52,7 +52,7 @@
 #include <string.h>
 #include <sysexits.h>
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "../queue.h"
 #else
 #include <sys/queue.h>
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
index c0457b8c3b77..cfff11d80378 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
@@ -51,7 +51,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <sysexits.h>
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "../queue.h"
 #else
 #include <sys/queue.h>
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
index 93c8667cd704..e9f6005431b1 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -51,7 +51,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <sysexits.h>
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "../queue.h"
 #else
 #include <sys/queue.h>
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
index 232aff1fe784..dad083fa3adb 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
@@ -44,7 +44,7 @@
 
 #include <sys/types.h>
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "aicdb.h"
 #else
 #include <db.h>
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
index 34bbcad7f83f..530fb56d1c47 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
@@ -42,7 +42,7 @@
  * $FreeBSD$
  */
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include "../queue.h"
 #else
 #include <sys/queue.h>
-- 
2.18.0
