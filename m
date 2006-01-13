From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fusion: kzalloc / kcalloc conversion
Date: Fri, 13 Jan 2006 18:27:50 +0100
Message-ID: <20060113172750.GB2736@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:18652 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1161546AbWAMR15 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 12:27:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, Eric.Moore@lsil.com
Cc: linux-scsi@vger.kernel.org

Convert kmalloc + memset to kzalloc or kcalloc in fusion.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptbase.c	2006-01-13 17:55:56.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptbase.c	2006-01-13 18:24:03.000000000 +0100
@@ -1232,12 +1232,11 @@
 		dprintk((KERN_INFO MYNAM
 			": Not using 64 bit consistent mask\n"));
 
-	ioc = kmalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
+	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 		return -ENOMEM;
 	}
-	memset(ioc, 0, sizeof(MPT_ADAPTER));
 	ioc->alloc_total = sizeof(MPT_ADAPTER);
 	ioc->req_sz = MPT_DEFAULT_FRAME_SIZE;		/* avoid div by zero! */
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
Index: scsi-misc-2.6/drivers/message/fusion/mptfc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptfc.c	2006-01-13 17:55:56.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptfc.c	2006-01-13 18:24:48.000000000 +0100
@@ -148,11 +148,10 @@
 	MPT_SCSI_HOST		*hd;
 	MPT_ADAPTER 		*ioc;
 	unsigned long		 flags;
-	int			 sz, ii;
+	int			 ii;
 	int			 numSGE = 0;
 	int			 scale;
 	int			 ioc_cap;
-	u8			*mem;
 	int			error=0;
 	int			r;
 		
@@ -268,36 +267,27 @@
 	/* SCSI needs scsi_cmnd lookup table!
 	 * (with size equal to req_depth*PtrSz!)
 	 */
-	sz = ioc->req_depth * sizeof(void *);
-	mem = kmalloc(sz, GFP_ATOMIC);
-	if (mem == NULL) {
+	hd->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
+	if (!hd->ScsiLookup) {
 		error = -ENOMEM;
 		goto out_mptfc_probe;
 	}
 
-	memset(mem, 0, sz);
-	hd->ScsiLookup = (struct scsi_cmnd **) mem;
-
-	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=%d\n",
-		 ioc->name, hd->ScsiLookup, sz));
+	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p\n",
+		 ioc->name, hd->ScsiLookup));
 
 	/* Allocate memory for the device structures.
 	 * A non-Null pointer at an offset
 	 * indicates a device exists.
 	 * max_id = 1 + maximum id (hosts.h)
 	 */
-	sz = sh->max_id * sizeof(void *);
-	mem = kmalloc(sz, GFP_ATOMIC);
-	if (mem == NULL) {
+	hd->Targets = kcalloc(sh->max_id, sizeof(void *), GFP_ATOMIC);
+	if (!hd->Targets) {
 		error = -ENOMEM;
 		goto out_mptfc_probe;
 	}
 
-	memset(mem, 0, sz);
-	hd->Targets = (VirtTarget **) mem;
-
-	dprintk((KERN_INFO
-	  "  vdev @ %p, sz=%d\n", hd->Targets, sz));
+	dprintk((KERN_INFO "  vdev @ %p\n", hd->Targets));
 
 	/* Clear the TM flags
 	 */
Index: scsi-misc-2.6/drivers/message/fusion/mptlan.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptlan.c	2006-01-13 17:55:56.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptlan.c	2006-01-13 18:13:33.000000000 +0100
@@ -411,14 +411,12 @@
 		goto out;
 	priv->mpt_txfidx_tail = -1;
 
-	priv->SendCtl = kmalloc(priv->tx_max_out * sizeof(struct BufferControl),
+	priv->SendCtl = kcalloc(priv->tx_max_out, sizeof(struct BufferControl),
 				GFP_KERNEL);
 	if (priv->SendCtl == NULL)
 		goto out_mpt_txfidx;
-	for (i = 0; i < priv->tx_max_out; i++) {
-		memset(&priv->SendCtl[i], 0, sizeof(struct BufferControl));
+	for (i = 0; i < priv->tx_max_out; i++)
 		priv->mpt_txfidx[++priv->mpt_txfidx_tail] = i;
-	}
 
 	dlprintk((KERN_INFO MYNAM "@lo: Finished initializing SendCtl\n"));
 
@@ -428,15 +426,13 @@
 		goto out_SendCtl;
 	priv->mpt_rxfidx_tail = -1;
 
-	priv->RcvCtl = kmalloc(priv->max_buckets_out *
-						sizeof(struct BufferControl),
+	priv->RcvCtl = kcalloc(priv->max_buckets_out,
+			       sizeof(struct BufferControl),
 			       GFP_KERNEL);
 	if (priv->RcvCtl == NULL)
 		goto out_mpt_rxfidx;
-	for (i = 0; i < priv->max_buckets_out; i++) {
-		memset(&priv->RcvCtl[i], 0, sizeof(struct BufferControl));
+	for (i = 0; i < priv->max_buckets_out; i++)
 		priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = i;
-	}
 
 /**/	dlprintk((KERN_INFO MYNAM "/lo: txfidx contains - "));
 /**/	for (i = 0; i < priv->tx_max_out; i++)
Index: scsi-misc-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptsas.c	2006-01-13 18:08:22.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptsas.c	2006-01-13 18:25:06.000000000 +0100
@@ -258,13 +258,12 @@
 	struct scsi_target 	*starget;
 	int i;
 
-	vdev = kmalloc(sizeof(VirtDevice), GFP_KERNEL);
+	vdev = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdev) {
 		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
 				hd->ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
-	memset(vdev, 0, sizeof(VirtDevice));
 	vdev->ioc_id = hd->ioc->id;
 	sdev->hostdata = vdev;
 	starget = scsi_target(sdev);
@@ -1044,10 +1043,9 @@
 	u32 handle = 0xFFFF;
 	int error = -ENOMEM, i;
 
-	port_info = kmalloc(sizeof(*port_info), GFP_KERNEL);
+	port_info = kzalloc(sizeof(*port_info), GFP_KERNEL);
 	if (!port_info)
 		goto out;
-	memset(port_info, 0, sizeof(*port_info));
 
 	error = mptsas_sas_io_unit_pg0(ioc, port_info);
 	if (error)
@@ -1096,10 +1094,9 @@
 	struct mptsas_portinfo *port_info, *p;
 	int error = -ENOMEM, i, j;
 
-	port_info = kmalloc(sizeof(*port_info), GFP_KERNEL);
+	port_info = kzalloc(sizeof(*port_info), GFP_KERNEL);
 	if (!port_info)
 		goto out;
-	memset(port_info, 0, sizeof(*port_info));
 
 	error = mptsas_sas_expander_pg0(ioc, port_info,
 		(MPI_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE <<
@@ -1390,11 +1387,10 @@
 	MPT_SCSI_HOST		*hd;
 	MPT_ADAPTER 		*ioc;
 	unsigned long		 flags;
-	int			 sz, ii;
+	int			 ii;
 	int			 numSGE = 0;
 	int			 scale;
 	int			 ioc_cap;
-	u8			*mem;
 	int			error=0;
 	int			r;
 
@@ -1518,36 +1514,27 @@
 	/* SCSI needs scsi_cmnd lookup table!
 	 * (with size equal to req_depth*PtrSz!)
 	 */
-	sz = ioc->req_depth * sizeof(void *);
-	mem = kmalloc(sz, GFP_ATOMIC);
-	if (mem == NULL) {
+	hd->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
+	if (!hd->ScsiLookup) {
 		error = -ENOMEM;
 		goto out_mptsas_probe;
 	}
 
-	memset(mem, 0, sz);
-	hd->ScsiLookup = (struct scsi_cmnd **) mem;
-
-	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=%d\n",
-		 ioc->name, hd->ScsiLookup, sz));
+	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p\n",
+		 ioc->name, hd->ScsiLookup));
 
 	/* Allocate memory for the device structures.
 	 * A non-Null pointer at an offset
 	 * indicates a device exists.
 	 * max_id = 1 + maximum id (hosts.h)
 	 */
-	sz = sh->max_id * sizeof(void *);
-	mem = kmalloc(sz, GFP_ATOMIC);
-	if (mem == NULL) {
+	hd->Targets = kcalloc(sh->max_id, sizeof(void *), GFP_ATOMIC);
+	if (!hd->Targets) {
 		error = -ENOMEM;
 		goto out_mptsas_probe;
 	}
 
-	memset(mem, 0, sz);
-	hd->Targets = (VirtTarget **) mem;
-
-	dprintk((KERN_INFO
-	  "  vtarget @ %p, sz=%d\n", hd->Targets, sz));
+	dprintk((KERN_INFO "  vtarget @ %p\n", hd->Targets));
 
 	/* Clear the TM flags
 	 */
Index: scsi-misc-2.6/drivers/message/fusion/mptscsih.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptscsih.c	2006-01-13 17:55:56.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptscsih.c	2006-01-13 18:12:15.000000000 +0100
@@ -2162,10 +2162,9 @@
 {
 	VirtTarget		*vtarget;
 
-	vtarget = kmalloc(sizeof(VirtTarget), GFP_KERNEL);
+	vtarget = kzalloc(sizeof(VirtTarget), GFP_KERNEL);
 	if (!vtarget)
 		return -ENOMEM;
-	memset(vtarget, 0, sizeof(VirtTarget));
 	starget->hostdata = vtarget;
 	return 0;
 }
@@ -2185,14 +2184,13 @@
 	VirtDevice		*vdev;
 	struct scsi_target 	*starget;
 
-	vdev = kmalloc(sizeof(VirtDevice), GFP_KERNEL);
+	vdev = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdev) {
 		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
 				hd->ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
 
-	memset(vdev, 0, sizeof(VirtDevice));
 	vdev->ioc_id = hd->ioc->id;
 	vdev->target_id = sdev->id;
 	vdev->bus_id = sdev->channel;
Index: scsi-misc-2.6/drivers/message/fusion/mptspi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptspi.c	2006-01-13 17:55:56.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptspi.c	2006-01-13 18:18:09.000000000 +0100
@@ -158,11 +158,10 @@
 	MPT_SCSI_HOST		*hd;
 	MPT_ADAPTER 		*ioc;
 	unsigned long		 flags;
-	int			 sz, ii;
+	int			 ii;
 	int			 numSGE = 0;
 	int			 scale;
 	int			 ioc_cap;
-	u8			*mem;
 	int			error=0;
 	int			r;
 
@@ -288,36 +287,27 @@
 	/* SCSI needs scsi_cmnd lookup table!
 	 * (with size equal to req_depth*PtrSz!)
 	 */
-	sz = ioc->req_depth * sizeof(void *);
-	mem = kmalloc(sz, GFP_ATOMIC);
-	if (mem == NULL) {
+	hd->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
+	if (!hd->ScsiLookup) {
 		error = -ENOMEM;
 		goto out_mptspi_probe;
 	}
 
-	memset(mem, 0, sz);
-	hd->ScsiLookup = (struct scsi_cmnd **) mem;
-
-	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=%d\n",
-		 ioc->name, hd->ScsiLookup, sz));
+	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p\n",
+		 ioc->name, hd->ScsiLookup));
 
 	/* Allocate memory for the device structures.
 	 * A non-Null pointer at an offset
 	 * indicates a device exists.
 	 * max_id = 1 + maximum id (hosts.h)
 	 */
-	sz = sh->max_id * sizeof(void *);
-	mem = kmalloc(sz, GFP_ATOMIC);
-	if (mem == NULL) {
+	hd->Targets = kcalloc(sh->max_id, sizeof(void *), GFP_ATOMIC);
+	if (!hd->Targets) {
 		error = -ENOMEM;
 		goto out_mptspi_probe;
 	}
 
-	memset(mem, 0, sz);
-	hd->Targets = (VirtTarget **) mem;
-
-	dprintk((KERN_INFO
-	  "  vdev @ %p, sz=%d\n", hd->Targets, sz));
+	dprintk((KERN_INFO "  vdev @ %p\n", hd->Targets));
 
 	/* Clear the TM flags
 	 */
