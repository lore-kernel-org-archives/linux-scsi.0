From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] remove Scsi_Pointer typedef
Date: Mon, 31 Oct 2005 18:31:56 +0100
Message-ID: <20051031173156.GC14182@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:26014 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964807AbVJaRcA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 12:32:00 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Index: scsi-misc-2.6/drivers/scsi/arm/acornscsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/acornscsi.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/acornscsi.c	2005-10-29 19:25:07.000000000 +0200
@@ -896,7 +896,7 @@
  * Notes    : this will only be one SG entry or less
  */
 static
-void acornscsi_data_updateptr(AS_Host *host, Scsi_Pointer *SCp, unsigned int length)
+void acornscsi_data_updateptr(AS_Host *host, struct scsi_pointer *SCp, unsigned int length)
 {
     SCp->ptr += length;
     SCp->this_residual -= length;
Index: scsi-misc-2.6/drivers/scsi/arm/acornscsi.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/acornscsi.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/acornscsi.h	2005-10-29 19:25:07.000000000 +0200
@@ -292,7 +292,7 @@
 	    unsigned char	tag;		/* reconnected tag			*/
 	} reconnected;
 
-	Scsi_Pointer	SCp;			/* current commands data pointer	*/
+	struct scsi_pointer	SCp;			/* current commands data pointer	*/
 
 	MsgQueue_t	msgs;
 
Index: scsi-misc-2.6/drivers/scsi/arm/arxescsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/arxescsi.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/arxescsi.c	2005-10-29 19:25:07.000000000 +0200
@@ -65,7 +65,7 @@
  * Returns : 0 if we should not set CMD_WITHDMA for transfer info command
  */
 static fasdmatype_t
-arxescsi_dma_setup(struct Scsi_Host *host, Scsi_Pointer *SCp,
+arxescsi_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 		       fasdmadir_t direction, fasdmatype_t min_type)
 {
 	/*
@@ -111,7 +111,7 @@
  *	     transfer  - minimum number of bytes we expect to transfer
  */
 static void
-arxescsi_dma_pseudo(struct Scsi_Host *host, Scsi_Pointer *SCp,
+arxescsi_dma_pseudo(struct Scsi_Host *host, struct scsi_pointer *SCp,
 		    fasdmadir_t direction, int transfer)
 {
 	struct arxescsi_info *info = (struct arxescsi_info *)host->hostdata;
@@ -197,7 +197,7 @@
  * Params  : host  - host
  *	     SCpnt - command
  */
-static void arxescsi_dma_stop(struct Scsi_Host *host, Scsi_Pointer *SCp)
+static void arxescsi_dma_stop(struct Scsi_Host *host, struct scsi_pointer *SCp)
 {
 	/*
 	 * no DMA to stop
Index: scsi-misc-2.6/drivers/scsi/arm/cumana_2.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/cumana_2.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/cumana_2.c	2005-10-29 19:25:07.000000000 +0200
@@ -157,7 +157,7 @@
  * Returns  : type of transfer to be performed
  */
 static fasdmatype_t
-cumanascsi_2_dma_setup(struct Scsi_Host *host, Scsi_Pointer *SCp,
+cumanascsi_2_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 		       fasdmadir_t direction, fasdmatype_t min_type)
 {
 	struct cumanascsi2_info *info = (struct cumanascsi2_info *)host->hostdata;
@@ -209,7 +209,7 @@
  *	      transfer  - minimum number of bytes we expect to transfer
  */
 static void
-cumanascsi_2_dma_pseudo(struct Scsi_Host *host, Scsi_Pointer *SCp,
+cumanascsi_2_dma_pseudo(struct Scsi_Host *host, struct scsi_pointer *SCp,
 			fasdmadir_t direction, int transfer)
 {
 	struct cumanascsi2_info *info = (struct cumanascsi2_info *)host->hostdata;
@@ -283,7 +283,7 @@
  *	      SCpnt - command
  */
 static void
-cumanascsi_2_dma_stop(struct Scsi_Host *host, Scsi_Pointer *SCp)
+cumanascsi_2_dma_stop(struct Scsi_Host *host, struct scsi_pointer *SCp)
 {
 	struct cumanascsi2_info *info = (struct cumanascsi2_info *)host->hostdata;
 	if (info->info.scsi.dma != NO_DMA) {
Index: scsi-misc-2.6/drivers/scsi/arm/eesox.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/eesox.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/eesox.c	2005-10-29 19:25:07.000000000 +0200
@@ -158,7 +158,7 @@
  * Returns  : type of transfer to be performed
  */
 static fasdmatype_t
-eesoxscsi_dma_setup(struct Scsi_Host *host, Scsi_Pointer *SCp,
+eesoxscsi_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 		       fasdmadir_t direction, fasdmatype_t min_type)
 {
 	struct eesoxscsi_info *info = (struct eesoxscsi_info *)host->hostdata;
@@ -353,7 +353,7 @@
 }
 
 static void
-eesoxscsi_dma_pseudo(struct Scsi_Host *host, Scsi_Pointer *SCp,
+eesoxscsi_dma_pseudo(struct Scsi_Host *host, struct scsi_pointer *SCp,
 		     fasdmadir_t dir, int transfer_size)
 {
 	struct eesoxscsi_info *info = (struct eesoxscsi_info *)host->hostdata;
@@ -370,7 +370,7 @@
  *	      SCpnt - command
  */
 static void
-eesoxscsi_dma_stop(struct Scsi_Host *host, Scsi_Pointer *SCp)
+eesoxscsi_dma_stop(struct Scsi_Host *host, struct scsi_pointer *SCp)
 {
 	struct eesoxscsi_info *info = (struct eesoxscsi_info *)host->hostdata;
 	if (info->info.scsi.dma != NO_DMA)
Index: scsi-misc-2.6/drivers/scsi/arm/fas216.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/fas216.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/fas216.c	2005-10-29 19:25:07.000000000 +0200
@@ -173,7 +173,7 @@
 		fas216_readb(info, REG_CTCH));
 }
 
-static void print_SCp(Scsi_Pointer *SCp, const char *prefix, const char *suffix)
+static void print_SCp(struct scsi_pointer *SCp, const char *prefix, const char *suffix)
 {
 	printk("%sptr %p this_residual 0x%x buffer %p buffers_residual 0x%x%s",
 		prefix, SCp->ptr, SCp->this_residual, SCp->buffer,
@@ -628,7 +628,7 @@
  */
 static void fas216_updateptrs(FAS216_Info *info, int bytes_transferred)
 {
-	Scsi_Pointer *SCp = &info->scsi.SCp;
+	struct scsi_pointer *SCp = &info->scsi.SCp;
 
 	fas216_checkmagic(info);
 
@@ -668,7 +668,7 @@
  */
 static void fas216_pio(FAS216_Info *info, fasdmadir_t direction)
 {
-	Scsi_Pointer *SCp = &info->scsi.SCp;
+	struct scsi_pointer *SCp = &info->scsi.SCp;
 
 	fas216_checkmagic(info);
 
Index: scsi-misc-2.6/drivers/scsi/arm/fas216.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/fas216.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/fas216.h	2005-10-29 19:25:07.000000000 +0200
@@ -243,7 +243,7 @@
 		unsigned int	irq;			/* interrupt				*/
 		int		dma;			/* dma channel				*/
 
-		Scsi_Pointer	SCp;			/* current commands data pointer	*/
+		struct scsi_pointer	SCp;			/* current commands data pointer	*/
 
 		MsgQueue_t	msgs;			/* message queue for connected device	*/
 
@@ -304,9 +304,9 @@
 	/* dma */
 	struct {
 		fasdmatype_t	transfer_type;		/* current type of DMA transfer		*/
-		fasdmatype_t	(*setup) (struct Scsi_Host *host, Scsi_Pointer *SCp, fasdmadir_t direction, fasdmatype_t min_dma);
-		void		(*pseudo)(struct Scsi_Host *host, Scsi_Pointer *SCp, fasdmadir_t direction, int transfer);
-		void		(*stop)  (struct Scsi_Host *host, Scsi_Pointer *SCp);
+		fasdmatype_t	(*setup) (struct Scsi_Host *host, struct scsi_pointer *SCp, fasdmadir_t direction, fasdmatype_t min_dma);
+		void		(*pseudo)(struct Scsi_Host *host, struct scsi_pointer *SCp, fasdmadir_t direction, int transfer);
+		void		(*stop)  (struct Scsi_Host *host, struct scsi_pointer *SCp);
 	} dma;
 
 	/* miscellaneous */
Index: scsi-misc-2.6/drivers/scsi/arm/powertec.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/powertec.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/powertec.c	2005-10-29 19:25:07.000000000 +0200
@@ -132,7 +132,7 @@
  * Returns  : type of transfer to be performed
  */
 static fasdmatype_t
-powertecscsi_dma_setup(struct Scsi_Host *host, Scsi_Pointer *SCp,
+powertecscsi_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 		       fasdmadir_t direction, fasdmatype_t min_type)
 {
 	struct powertec_info *info = (struct powertec_info *)host->hostdata;
@@ -174,7 +174,7 @@
  *	      SCpnt - command
  */
 static void
-powertecscsi_dma_stop(struct Scsi_Host *host, Scsi_Pointer *SCp)
+powertecscsi_dma_stop(struct Scsi_Host *host, struct scsi_pointer *SCp)
 {
 	struct powertec_info *info = (struct powertec_info *)host->hostdata;
 	if (info->info.scsi.dma != NO_DMA)
Index: scsi-misc-2.6/drivers/scsi/arm/scsi.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/scsi.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/scsi.h	2005-10-29 19:25:07.000000000 +0200
@@ -16,7 +16,7 @@
  * The scatter-gather list handling.  This contains all
  * the yucky stuff that needs to be fixed properly.
  */
-static inline int copy_SCp_to_sg(struct scatterlist *sg, Scsi_Pointer *SCp, int max)
+static inline int copy_SCp_to_sg(struct scatterlist *sg, struct scsi_pointer *SCp, int max)
 {
 	int bufs = SCp->buffers_residual;
 
@@ -32,7 +32,7 @@
 	return bufs + 1;
 }
 
-static inline int next_SCp(Scsi_Pointer *SCp)
+static inline int next_SCp(struct scsi_pointer *SCp)
 {
 	int ret = SCp->buffers_residual;
 	if (ret) {
@@ -49,7 +49,7 @@
 	return ret;
 }
 
-static inline unsigned char get_next_SCp_byte(Scsi_Pointer *SCp)
+static inline unsigned char get_next_SCp_byte(struct scsi_pointer *SCp)
 {
 	char c = *SCp->ptr;
 
@@ -59,7 +59,7 @@
 	return c;
 }
 
-static inline void put_next_SCp_byte(Scsi_Pointer *SCp, unsigned char c)
+static inline void put_next_SCp_byte(struct scsi_pointer *SCp, unsigned char c)
 {
 	*SCp->ptr = c;
 	SCp->ptr += 1;
Index: scsi-misc-2.6/drivers/scsi/megaraid.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/megaraid.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/megaraid.c	2005-10-29 19:25:07.000000000 +0200
@@ -1683,7 +1683,7 @@
 
 	list_for_each(pos, &adapter->completed_list) {
 
-		Scsi_Pointer* spos = (Scsi_Pointer *)pos;
+		struct scsi_pointer* spos = (struct scsi_pointer *)pos;
 
 		cmd = list_entry(spos, Scsi_Cmnd, SCp);
 		cmd->scsi_done(cmd);
Index: scsi-misc-2.6/drivers/scsi/scsi_typedefs.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_typedefs.h	2005-10-29 19:24:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_typedefs.h	2005-10-29 19:25:07.000000000 +0200
@@ -2,4 +2,3 @@
 typedef struct scsi_device Scsi_Device;
 typedef struct scsi_cmnd Scsi_Cmnd;
 typedef struct scsi_request Scsi_Request;
-typedef struct scsi_pointer Scsi_Pointer;
