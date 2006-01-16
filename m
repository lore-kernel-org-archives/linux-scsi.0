From: Jes Sorensen <jes@sgi.com>
Subject: [patch] SCSI core kmalloc2kzalloc
Date: 16 Jan 2006 10:31:18 -0500
Message-ID: <yq0ek38tcjd.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:30909 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S1750778AbWAPPbX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 10:31:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

A bit of house keeping - switching the core SCSI code to use kzalloc
when possible. Saves about 300 bytes of .text segment for me ;-)

Cheers,
Jes

Change the core SCSI code to use kzalloc rather than kmalloc+memset
where possible.

Signed-off-by: Jes Sorensen <jes@sgi.com>

----

 drivers/scsi/hosts.c                |    3 +--
 drivers/scsi/scsi.c                 |    3 +--
 drivers/scsi/scsi_debug.c           |    9 +++------
 drivers/scsi/scsi_ioctl.c           |    3 +--
 drivers/scsi/scsi_lib.c             |    5 ++---
 drivers/scsi/scsi_scan.c            |    6 ++----
 drivers/scsi/scsi_transport_fc.c    |    9 +++------
 drivers/scsi/scsi_transport_iscsi.c |    3 +--
 drivers/scsi/scsi_transport_sas.c   |    9 +++------
 drivers/scsi/scsi_transport_spi.c   |   12 ++++--------
 drivers/scsi/sd.c                   |    3 +--
 drivers/scsi/sg.c                   |    6 ++----
 drivers/scsi/sr.c                   |    3 +--
 drivers/scsi/sr_ioctl.c             |    6 ++----
 drivers/scsi/st.c                   |    9 +++------
 15 files changed, 30 insertions(+), 59 deletions(-)

Index: linux-2.6/drivers/scsi/hosts.c
===================================================================
--- linux-2.6.orig/drivers/scsi/hosts.c
+++ linux-2.6/drivers/scsi/hosts.c
@@ -306,10 +306,9 @@
 		dump_stack();
         }
 
-	shost = kmalloc(sizeof(struct Scsi_Host) + privsize, gfp_mask);
+	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, gfp_mask);
 	if (!shost)
 		return NULL;
-	memset(shost, 0, sizeof(struct Scsi_Host) + privsize);
 
 	spin_lock_init(&shost->default_lock);
 	scsi_assign_lock(shost, &shost->default_lock);
Index: linux-2.6/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi.c
+++ linux-2.6/drivers/scsi/scsi.c
@@ -136,9 +136,8 @@
 	const int size = offset + sizeof(struct request);
 	struct scsi_request *sreq;
   
-	sreq = kmalloc(size, gfp_mask);
+	sreq = kzalloc(size, gfp_mask);
 	if (likely(sreq != NULL)) {
-		memset(sreq, 0, size);
 		sreq->sr_request = (struct request *)(((char *)sreq) + offset);
 		sreq->sr_device = sdev;
 		sreq->sr_host = sdev->host;
Index: linux-2.6/drivers/scsi/scsi_debug.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_debug.c
+++ linux-2.6/drivers/scsi/scsi_debug.c
@@ -1061,13 +1061,12 @@
 		}
 	}
 	if (NULL == open_devip) { /* try and make a new one */
-		open_devip = kmalloc(sizeof(*open_devip),GFP_KERNEL);
+		open_devip = kzalloc(sizeof(*open_devip),GFP_KERNEL);
 		if (NULL == open_devip) {
 			printk(KERN_ERR "%s: out of memory at line %d\n",
 				__FUNCTION__, __LINE__);
 			return NULL;
 		}
-		memset(open_devip, 0, sizeof(*open_devip));
 		open_devip->sdbg_host = sdbg_host;
 		list_add_tail(&open_devip->dev_list,
 		&sdbg_host->dev_info_list);
@@ -1814,7 +1813,7 @@
         struct sdebug_dev_info *sdbg_devinfo;
         struct list_head *lh, *lh_sf;
 
-        sdbg_host = kmalloc(sizeof(*sdbg_host),GFP_KERNEL);
+        sdbg_host = kzalloc(sizeof(*sdbg_host), GFP_KERNEL);
 
         if (NULL == sdbg_host) {
                 printk(KERN_ERR "%s: out of memory at line %d\n",
@@ -1822,19 +1821,17 @@
                 return -ENOMEM;
         }
 
-        memset(sdbg_host, 0, sizeof(*sdbg_host));
         INIT_LIST_HEAD(&sdbg_host->dev_info_list);
 
 	devs_per_host = scsi_debug_num_tgts * scsi_debug_max_luns;
         for (k = 0; k < devs_per_host; k++) {
-                sdbg_devinfo = kmalloc(sizeof(*sdbg_devinfo),GFP_KERNEL);
+                sdbg_devinfo = kzalloc(sizeof(*sdbg_devinfo), GFP_KERNEL);
                 if (NULL == sdbg_devinfo) {
                         printk(KERN_ERR "%s: out of memory at line %d\n",
                                __FUNCTION__, __LINE__);
                         error = -ENOMEM;
 			goto clean;
                 }
-                memset(sdbg_devinfo, 0, sizeof(*sdbg_devinfo));
                 sdbg_devinfo->sdbg_host = sdbg_host;
                 list_add_tail(&sdbg_devinfo->dev_list,
                               &sdbg_host->dev_info_list);
Index: linux-2.6/drivers/scsi/scsi_ioctl.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_ioctl.c
+++ linux-2.6/drivers/scsi/scsi_ioctl.c
@@ -241,10 +241,9 @@
 		buf_needed = (buf_needed + 511) & ~511;
 		if (buf_needed > MAX_BUF)
 			buf_needed = MAX_BUF;
-		buf = kmalloc(buf_needed, gfp_mask);
+		buf = kzalloc(buf_needed, gfp_mask);
 		if (!buf)
 			return -ENOMEM;
-		memset(buf, 0, buf_needed);
 		if (inlen == 0) {
 			data_direction = DMA_FROM_DEVICE;
 		} else if (outlen == 0 ) {
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -285,13 +285,12 @@
 	int result;
 	
 	if (sshdr) {
-		sense = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
+		sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
 		if (!sense)
 			return DRIVER_ERROR << 24;
-		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
 	}
 	result = scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
-				  sense, timeout, retries, 0);
+			      sense, timeout, retries, 0);
 	if (sshdr)
 		scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, sshdr);
 
Index: linux-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6/drivers/scsi/scsi_scan.c
@@ -205,12 +205,11 @@
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
-	sdev = kmalloc(sizeof(*sdev) + shost->transportt->device_size,
+	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
 	if (!sdev)
 		goto out;
 
-	memset(sdev, 0, sizeof(*sdev));
 	sdev->vendor = scsi_null_device_strs;
 	sdev->model = scsi_null_device_strs;
 	sdev->rev = scsi_null_device_strs;
@@ -334,12 +333,11 @@
 	struct scsi_target *starget;
 	struct scsi_target *found_target;
 
-	starget = kmalloc(size, GFP_KERNEL);
+	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
 		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
 		return NULL;
 	}
-	memset(starget, 0, size);
 	dev = &starget->dev;
 	device_initialize(dev);
 	starget->reap_ref = 1;
Index: linux-2.6/drivers/scsi/scsi_transport_fc.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_fc.c
+++ linux-2.6/drivers/scsi/scsi_transport_fc.c
@@ -1115,15 +1115,13 @@
 struct scsi_transport_template *
 fc_attach_transport(struct fc_function_template *ft)
 {
-	struct fc_internal *i = kmalloc(sizeof(struct fc_internal),
-					GFP_KERNEL);
 	int count;
+	struct fc_internal *i = kzalloc(sizeof(struct fc_internal),
+					GFP_KERNEL);
 
 	if (unlikely(!i))
 		return NULL;
 
-	memset(i, 0, sizeof(struct fc_internal));
-
 	i->t.target_attrs.ac.attrs = &i->starget_attrs[0];
 	i->t.target_attrs.ac.class = &fc_transport_class.class;
 	i->t.target_attrs.ac.match = fc_target_match;
@@ -1305,12 +1303,11 @@
 	size_t size;
 
 	size = (sizeof(struct fc_rport) + fci->f->dd_fcrport_size);
-	rport = kmalloc(size, GFP_KERNEL);
+	rport = kzalloc(size, GFP_KERNEL);
 	if (unlikely(!rport)) {
 		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
 		return NULL;
 	}
-	memset(rport, 0, size);
 
 	rport->maxframe_size = -1;
 	rport->supported_classes = FC_COS_UNSPECIFIED;
Index: linux-2.6/drivers/scsi/scsi_transport_iscsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_iscsi.c
+++ linux-2.6/drivers/scsi/scsi_transport_iscsi.c
@@ -1116,10 +1116,9 @@
 	if (priv)
 		return NULL;
 
-	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return NULL;
-	memset(priv, 0, sizeof(*priv));
 	INIT_LIST_HEAD(&priv->list);
 	INIT_LIST_HEAD(&priv->sessions);
 	priv->iscsi_transport = tt;
Index: linux-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_sas.c
+++ linux-2.6/drivers/scsi/scsi_transport_sas.c
@@ -391,10 +391,9 @@
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct sas_phy *phy;
 
-	phy = kmalloc(sizeof(*phy), GFP_KERNEL);
+	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
 	if (!phy)
 		return NULL;
-	memset(phy, 0, sizeof(*phy));
 
 	get_device(parent);
 
@@ -585,12 +584,11 @@
 	struct Scsi_Host *shost = dev_to_shost(&parent->dev);
 	struct sas_rphy *rphy;
 
-	rphy = kmalloc(sizeof(*rphy), GFP_KERNEL);
+	rphy = kzalloc(sizeof(*rphy), GFP_KERNEL);
 	if (!rphy) {
 		put_device(&parent->dev);
 		return NULL;
 	}
-	memset(rphy, 0, sizeof(*rphy));
 
 	device_initialize(&rphy->dev);
 	rphy->dev.parent = get_device(&parent->dev);
@@ -793,10 +791,9 @@
 	struct sas_internal *i;
 	int count;
 
-	i = kmalloc(sizeof(struct sas_internal), GFP_KERNEL);
+	i = kzalloc(sizeof(struct sas_internal), GFP_KERNEL);
 	if (!i)
 		return NULL;
-	memset(i, 0, sizeof(struct sas_internal));
 
 	i->t.user_scan = sas_user_scan;
 
Index: linux-2.6/drivers/scsi/scsi_transport_spi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_spi.c
+++ linux-2.6/drivers/scsi/scsi_transport_spi.c
@@ -900,13 +900,11 @@
 	if (unlikely(scsi_device_get(sdev)))
 		return;
 
-	buffer = kmalloc(len, GFP_KERNEL);
+	buffer = kzalloc(len, GFP_KERNEL);
 
 	if (unlikely(!buffer))
 		goto out_put;
 
-	memset(buffer, 0, len);
-
 	/* We need to verify that the actual device will quiesce; the
 	 * later target quiesce is just a nice to have */
 	if (unlikely(scsi_device_quiesce(sdev)))
@@ -1265,15 +1263,13 @@
 struct scsi_transport_template *
 spi_attach_transport(struct spi_function_template *ft)
 {
-	struct spi_internal *i = kmalloc(sizeof(struct spi_internal),
-					 GFP_KERNEL);
 	int count = 0;
+	struct spi_internal *i = kzalloc(sizeof(struct spi_internal),
+					 GFP_KERNEL);
+
 	if (unlikely(!i))
 		return NULL;
 
-	memset(i, 0, sizeof(struct spi_internal));
-
-
 	i->t.target_attrs.ac.class = &spi_transport_class.class;
 	i->t.target_attrs.ac.attrs = &i->attrs[0];
 	i->t.target_attrs.ac.match = spi_target_match;
Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c
+++ linux-2.6/drivers/scsi/sd.c
@@ -1503,11 +1503,10 @@
 					"sd_attach\n"));
 
 	error = -ENOMEM;
-	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
+	sdkp = kzalloc(sizeof(*sdkp), GFP_KERNEL);
 	if (!sdkp)
 		goto out;
 
-	memset (sdkp, 0, sizeof(*sdkp));
 	kref_init(&sdkp->kref);
 
 	gd = alloc_disk(16);
Index: linux-2.6/drivers/scsi/sg.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sg.c
+++ linux-2.6/drivers/scsi/sg.c
@@ -1361,7 +1361,7 @@
 	void *old_sg_dev_arr = NULL;
 	int k, error;
 
-	sdp = kmalloc(sizeof(Sg_device), GFP_KERNEL);
+	sdp = kzalloc(sizeof(Sg_device), GFP_KERNEL);
 	if (!sdp) {
 		printk(KERN_WARNING "kmalloc Sg_device failure\n");
 		return -ENOMEM;
@@ -1373,12 +1373,11 @@
 		int tmp_dev_max = sg_nr_dev + SG_DEV_ARR_LUMP;
 		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 
-		tmp_da = kmalloc(tmp_dev_max * sizeof(Sg_device *), GFP_KERNEL);
+		tmp_da = kzalloc(tmp_dev_max * sizeof(Sg_device *), GFP_KERNEL);
 		if (unlikely(!tmp_da))
 			goto expand_failed;
 
 		write_lock_irqsave(&sg_dev_arr_lock, iflags);
-		memset(tmp_da, 0, tmp_dev_max * sizeof(Sg_device *));
 		memcpy(tmp_da, sg_dev_arr, sg_dev_max * sizeof(Sg_device *));
 		old_sg_dev_arr = sg_dev_arr;
 		sg_dev_arr = tmp_da;
@@ -1391,7 +1390,6 @@
 	if (unlikely(k >= SG_MAX_DEVS))
 		goto overflow;
 
-	memset(sdp, 0, sizeof(*sdp));
 	SCSI_LOG_TIMEOUT(3, printk("sg_alloc: dev=%d \n", k));
 	sprintf(disk->disk_name, "sg%d", k);
 	disk->first_minor = k;
Index: linux-2.6/drivers/scsi/sr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sr.c
+++ linux-2.6/drivers/scsi/sr.c
@@ -525,10 +525,9 @@
 		goto fail;
 
 	error = -ENOMEM;
-	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
+	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
 	if (!cd)
 		goto fail;
-	memset(cd, 0, sizeof(*cd));
 
 	kref_init(&cd->kref);
 
Index: linux-2.6/drivers/scsi/sr_ioctl.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sr_ioctl.c
+++ linux-2.6/drivers/scsi/sr_ioctl.c
@@ -44,11 +44,10 @@
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	buffer = kzalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
 	if (!buffer)
 		return -ENOMEM;
 
-	memset(&cgc, 0, sizeof(struct packet_command));
 	cgc.timeout = IOCTL_TIMEOUT;
 	cgc.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
 	cgc.cmd[8] = 12;		/* LSB of length */
@@ -74,11 +73,10 @@
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	buffer = kzalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
 	if (!buffer)
 		return -ENOMEM;
 
-	memset(&cgc, 0, sizeof(struct packet_command));
 	cgc.timeout = IOCTL_TIMEOUT;
 	cgc.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
 	cgc.cmd[1] |= (tocentry->cdte_format == CDROM_MSF) ? 0x02 : 0;
Index: linux-2.6/drivers/scsi/st.c
===================================================================
--- linux-2.6.orig/drivers/scsi/st.c
+++ linux-2.6/drivers/scsi/st.c
@@ -3590,12 +3590,11 @@
 
 	i = sizeof(struct st_buffer) + (max_sg - 1) * sizeof(struct scatterlist) +
 		max_sg * sizeof(struct st_buf_fragment);
-	tb = kmalloc(i, priority);
+	tb = kzalloc(i, priority);
 	if (!tb) {
 		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
 		return NULL;
 	}
-	memset(tb, 0, i);
 	tb->frp_segs = tb->orig_frp_segs = 0;
 	tb->use_sg = max_sg;
 	tb->frp = (struct st_buf_fragment *)(&(tb->sg[0]) + max_sg);
@@ -3924,14 +3923,13 @@
 			goto out_put_disk;
 		}
 
-		tmp_da = kmalloc(tmp_dev_max * sizeof(struct scsi_tape *), GFP_ATOMIC);
+		tmp_da = kzalloc(tmp_dev_max * sizeof(struct scsi_tape *), GFP_ATOMIC);
 		if (tmp_da == NULL) {
 			write_unlock(&st_dev_arr_lock);
 			printk(KERN_ERR "st: Can't extend device array.\n");
 			goto out_put_disk;
 		}
 
-		memset(tmp_da, 0, tmp_dev_max * sizeof(struct scsi_tape *));
 		if (scsi_tapes != NULL) {
 			memcpy(tmp_da, scsi_tapes,
 			       st_dev_max * sizeof(struct scsi_tape *));
@@ -3948,13 +3946,12 @@
 	if (i >= st_dev_max)
 		panic("scsi_devices corrupt (st)");
 
-	tpnt = kmalloc(sizeof(struct scsi_tape), GFP_ATOMIC);
+	tpnt = kzalloc(sizeof(struct scsi_tape), GFP_ATOMIC);
 	if (tpnt == NULL) {
 		write_unlock(&st_dev_arr_lock);
 		printk(KERN_ERR "st: Can't allocate device descriptor.\n");
 		goto out_put_disk;
 	}
-	memset(tpnt, 0, sizeof(struct scsi_tape));
 	kref_init(&tpnt->kref);
 	tpnt->disk = disk;
 	sprintf(disk->disk_name, "st%d", i);
