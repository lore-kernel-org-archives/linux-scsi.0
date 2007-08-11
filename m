From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: [patch 20/30] drivers/scsi/gdth.c: kmalloc + memset conversion to kzalloc
Date: Sat, 11 Aug 2007 10:13:24 +0200
Message-ID: <200708111013.25548.m.kozlowski@tuxland.pl>
References: <200708102150.l7ALokrZ011378@imap1.linux-foundation.org> <1186794055.6334.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1149 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbXHKINa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Aug 2007 04:13:30 -0400
In-Reply-To: <1186794055.6334.16.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

> > From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> > 
> >  drivers/scsi/gdth.c | 189401 -> 189342 (-59 bytes)
> >  drivers/scsi/gdth.o | 331028 -> 330324 (-704 bytes)
> 
> For the second time of asking, could I just have a single patch doing
> this globally for the entirety of SCSI with reasonable assurance of
> mechanical checking.
> 
> There's no real need to collect maintainer acks for something as trivial
> as this.

Ok, here it goes. But some of them are already in -rc2-mm2 I guess.

Regards,

	Mariusz



Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/NCR_D700.c          |    4 ++--
 drivers/scsi/a4000t.c            |    7 +++----
 drivers/scsi/aic7xxx_old.c       |    8 +++-----
 drivers/scsi/bvme6000_scsi.c     |    7 +++----
 drivers/scsi/dpt_i2o.c           |   27 +++++++++++----------------
 drivers/scsi/gdth.c              |    8 ++++----
 drivers/scsi/ide-scsi.c          |   10 ++++------
 drivers/scsi/lpfc/lpfc_debugfs.c |    7 ++-----
 drivers/scsi/lpfc/lpfc_init.c    |    3 +--
 drivers/scsi/lpfc/lpfc_scsi.c    |    3 +--
 drivers/scsi/megaraid.c          |    3 +--
 drivers/scsi/mvme16x_scsi.c      |    3 +--
 drivers/scsi/osst.c              |    5 ++---
 drivers/scsi/pluto.c             |   24 +++++++++++++-----------
 drivers/scsi/qla2xxx/qla_init.c  |   14 ++++++--------
 drivers/scsi/zorro7xx.c          |    8 +++-----
 16 files changed, 60 insertions(+), 81 deletions(-)

diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/NCR_D700.c linux-2.6.23-rc1-mm1-b/drivers/scsi/NCR_D700.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/NCR_D700.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/NCR_D700.c	2007-07-31 11:13:37.000000000 +0200
@@ -313,10 +313,10 @@ NCR_D700_probe(struct device *dev)
 		break;
 	}

-	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
-	memset(p, '\0', sizeof(*p));
+
 	p->dev = dev;
 	snprintf(p->name, sizeof(p->name), "D700(%s)", dev->bus_id);
 	if (request_irq(irq, NCR_D700_intr, IRQF_SHARED, p->name, p)) {
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/a4000t.c linux-2.6.23-rc1-mm1-b/drivers/scsi/a4000t.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/a4000t.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/a4000t.c	2007-07-31 14:00:37.000000000 +0200
@@ -37,7 +37,7 @@ static struct platform_device *a4000t_sc

 static int __devinit a4000t_probe(struct device *dev)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;

 	if (!(MACH_IS_AMIGA && AMIGAHW_PRESENT(A4000_SCSI)))
@@ -47,12 +47,11 @@ static int __devinit a4000t_probe(struct
 				"A4000T builtin SCSI"))
 		goto out;

-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (!hostdata) {
 		printk(KERN_ERR "a4000t-scsi: Failed to allocate host data\n");
 		goto out_release;
 	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));

 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)ZTWO_VADDR(A4000T_SCSI_ADDR);
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/aic7xxx_old.c linux-2.6.23-rc1-mm1-b/drivers/scsi/aic7xxx_old.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/aic7xxx_old.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/aic7xxx_old.c	2007-07-31 14:03:31.000000000 +0200
@@ -8416,10 +8416,9 @@ aic7xxx_alloc(struct scsi_host_template
     *p = *temp;
     p->host = host;

-    p->scb_data = kmalloc(sizeof(scb_data_type), GFP_ATOMIC);
-    if (p->scb_data != NULL)
+    p->scb_data = kzalloc(sizeof(scb_data_type), GFP_ATOMIC);
+    if (!p->scb_data)
     {
-      memset(p->scb_data, 0, sizeof(scb_data_type));
       scbq_init (&p->scb_data->free_scbs);
     }
     else
@@ -9196,10 +9195,9 @@ aic7xxx_detect(struct scsi_host_template
             printk(KERN_INFO "         this driver, we are ignoring it.\n");
           }
         }
-        else if ( (temp_p = kmalloc(sizeof(struct aic7xxx_host),
+        else if ( (temp_p = kzalloc(sizeof(struct aic7xxx_host),
                                     GFP_ATOMIC)) != NULL )
         {
-          memset(temp_p, 0, sizeof(struct aic7xxx_host));
           temp_p->chip = aic_pdevs[i].chip | AHC_PCI;
           temp_p->flags = aic_pdevs[i].flags;
           temp_p->features = aic_pdevs[i].features;
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/bvme6000_scsi.c linux-2.6.23-rc1-mm1-b/drivers/scsi/bvme6000_scsi.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/bvme6000_scsi.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/bvme6000_scsi.c	2007-07-31 14:04:50.000000000 +0200
@@ -36,19 +36,18 @@ static struct platform_device *bvme6000_
 static __devinit int
 bvme6000_probe(struct device *dev)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;

 	if (!MACH_IS_BVME6000)
 		goto out;

-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (!hostdata) {
 		printk(KERN_ERR "bvme6000-scsi: "
 				"Failed to allocate host data\n");
 		goto out;
 	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));

 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)BVME_NCR53C710_BASE;
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/dpt_i2o.c linux-2.6.23-rc1-mm1-b/drivers/scsi/dpt_i2o.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/dpt_i2o.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/dpt_i2o.c	2007-07-31 11:17:32.000000000 +0200
@@ -950,16 +950,14 @@ static int adpt_install_hba(struct scsi_
 	}

 	// Allocate and zero the data structure
-	pHba = kmalloc(sizeof(adpt_hba), GFP_KERNEL);
-	if( pHba == NULL) {
-		if(msg_addr_virt != base_addr_virt){
+	pHba = kzalloc(sizeof(adpt_hba), GFP_KERNEL);
+	if (!pHba) {
+		if (msg_addr_virt != base_addr_virt)
 			iounmap(msg_addr_virt);
-		}
 		iounmap(base_addr_virt);
 		pci_release_regions(pDev);
 		return -ENOMEM;
 	}
-	memset(pHba, 0, sizeof(adpt_hba));

 	mutex_lock(&adpt_configuration_lock);

@@ -2667,14 +2665,13 @@ static s32 adpt_i2o_init_outbound_q(adpt

 	msg=(u32 __iomem *)(pHba->msg_addr_virt+m);

-	status = kmalloc(4,GFP_KERNEL|ADDR32);
-	if (status==NULL) {
+	status = kzalloc(4, GFP_KERNEL|ADDR32);
+	if (!status) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_WARNING"%s: IOP reset failed - no free memory.\n",
 			pHba->name);
 		return -ENOMEM;
 	}
-	memset(status, 0, 4);

 	writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
 	writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
@@ -2713,12 +2710,11 @@ static s32 adpt_i2o_init_outbound_q(adpt

 	kfree(pHba->reply_pool);

-	pHba->reply_pool = kmalloc(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4, GFP_KERNEL|ADDR32);
-	if(!pHba->reply_pool){
-		printk(KERN_ERR"%s: Could not allocate reply pool\n",pHba->name);
-		return -1;
+	pHba->reply_pool = kzalloc(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4, GFP_KERNEL|ADDR32);
+	if (!pHba->reply_pool) {
+		printk(KERN_ERR "%s: Could not allocate reply pool\n", pHba->name);
+		return -ENOMEM;
 	}
-	memset(pHba->reply_pool, 0 , pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4);

 	ptr = pHba->reply_pool;
 	for(i = 0; i < pHba->reply_fifo_size; i++) {
@@ -2929,12 +2925,11 @@ static int adpt_i2o_build_sys_table(void

 	kfree(sys_tbl);

-	sys_tbl = kmalloc(sys_tbl_len, GFP_KERNEL|ADDR32);
-	if(!sys_tbl) {
+	sys_tbl = kzalloc(sys_tbl_len, GFP_KERNEL|ADDR32);
+	if (!sys_tbl) {
 		printk(KERN_WARNING "SysTab Set failed. Out of memory.\n");
 		return -ENOMEM;
 	}
-	memset(sys_tbl, 0, sys_tbl_len);

 	sys_tbl->num_entries = hba_count;
 	sys_tbl->version = I2OVERSION;
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/gdth.c linux-2.6.23-rc1-mm1-b/drivers/scsi/gdth.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/gdth.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/gdth.c	2007-07-31 14:08:37.000000000 +0200
@@ -458,10 +458,10 @@ int __gdth_execute(struct scsi_device *s
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;

-    scp = kmalloc(sizeof(*scp), GFP_KERNEL);
+    scp = kzalloc(sizeof(*scp), GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
-    memset(scp, 0, sizeof(*scp));
+
     scp->device = sdev;
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
@@ -5273,10 +5273,10 @@ static int gdth_ioctl(struct inode *inod
         hanum = res.ionode;
         ha = gdth_find_ha(hanum);

-        scp  = kmalloc(sizeof(*scp), GFP_KERNEL);
+        scp = kzalloc(sizeof(*scp), GFP_KERNEL);
         if (!scp)
             return -ENOMEM;
-        memset(scp, 0, sizeof(*scp));
+
         scp->device = ha->sdev;
         scp->cmd_len = 12;
         scp->use_sg = 0;
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/ide-scsi.c linux-2.6.23-rc1-mm1-b/drivers/scsi/ide-scsi.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/ide-scsi.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/ide-scsi.c	2007-07-31 14:09:51.000000000 +0200
@@ -328,17 +328,15 @@ static int idescsi_check_condition(ide_d
 	u8             *buf;

 	/* stuff a sense request in front of our current request */
-	pc = kmalloc (sizeof (idescsi_pc_t), GFP_ATOMIC);
-	rq = kmalloc (sizeof (struct request), GFP_ATOMIC);
-	buf = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
-	if (pc == NULL || rq == NULL || buf == NULL) {
+	pc = kzalloc(sizeof(idescsi_pc_t), GFP_ATOMIC);
+	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
+	buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
+	if (!pc || !rq || !buf) {
 		kfree(buf);
 		kfree(rq);
 		kfree(pc);
 		return -ENOMEM;
 	}
-	memset (pc, 0, sizeof (idescsi_pc_t));
-	memset (buf, 0, SCSI_SENSE_BUFFERSIZE);
 	ide_init_drive_cmd(rq);
 	rq->special = (char *) pc;
 	pc->rq = rq;
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_debugfs.c linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_debugfs.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_debugfs.c	2007-07-31 14:11:24.000000000 +0200
@@ -432,14 +432,11 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 	if (!lpfc_debugfs_start_time)
 		lpfc_debugfs_start_time = jiffies;

-	vport->disc_trc = kmalloc(
-		(sizeof(struct lpfc_disc_trc) * lpfc_debugfs_max_disc_trc),
-		GFP_KERNEL);
+	vport->disc_trc = kcalloc(lpfc_debugfs_max_disc_trc,
+				  sizeof(struct lpfc_disc_trc),	GFP_KERNEL);

 	if (!vport->disc_trc)
 		goto debug_failed;
-	memset(vport->disc_trc, 0,
-		(sizeof(struct lpfc_disc_trc) * lpfc_debugfs_max_disc_trc));

 	snprintf(name, sizeof(name), "discovery_trace");
 	vport->debug_disc_trc =
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_init.c linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_init.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_init.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_init.c	2007-07-31 11:07:59.000000000 +0200
@@ -1280,11 +1280,10 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
 	uint32_t *HashWorking;
 	uint32_t *pwwnn = (uint32_t *) phba->wwnn;

-	HashWorking = kmalloc(80 * sizeof(uint32_t), GFP_KERNEL);
+	HashWorking = kcalloc(80, sizeof(uint32_t), GFP_KERNEL);
 	if (!HashWorking)
 		return;

-	memset(HashWorking, 0, (80 * sizeof(uint32_t)));
 	HashWorking[0] = HashWorking[78] = *pwwnn++;
 	HashWorking[1] = HashWorking[79] = *pwwnn;

diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_scsi.c linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_scsi.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_scsi.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_scsi.c	2007-07-31 11:08:46.000000000 +0200
@@ -208,10 +208,9 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
 	dma_addr_t pdma_phys;
 	uint16_t iotag;

-	psb = kmalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
+	psb = kzalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
 	if (!psb)
 		return NULL;
-	memset(psb, 0, sizeof (struct lpfc_scsi_buf));

 	/*
 	 * Get memory from the pci pool to map the virt space to pci bus space
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/megaraid.c linux-2.6.23-rc1-mm1-b/drivers/scsi/megaraid.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/megaraid.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/megaraid.c	2007-08-11 09:50:12.000000000 +0200
@@ -4408,8 +4408,7 @@ mega_internal_command(adapter_t *adapter
 	scmd = &adapter->int_scmd;
 	memset(scmd, 0, sizeof(Scsi_Cmnd));

-	sdev = kmalloc(sizeof(struct scsi_device), GFP_KERNEL);
-	memset(sdev, 0, sizeof(struct scsi_device));
+	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
 	scmd->device = sdev;

 	scmd->device->host = adapter->host;
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/mvme16x_scsi.c linux-2.6.23-rc1-mm1-b/drivers/scsi/mvme16x_scsi.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/mvme16x_scsi.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/mvme16x_scsi.c	2007-07-31 11:02:11.000000000 +0200
@@ -48,13 +48,12 @@ mvme16x_probe(struct device *dev)
 		goto out;
 	}

-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
 	if (hostdata == NULL) {
 		printk(KERN_ERR "mvme16x-scsi: "
 				"Failed to allocate host data\n");
 		goto out;
 	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));

 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)0xfff47000UL;
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/osst.c linux-2.6.23-rc1-mm1-b/drivers/scsi/osst.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/osst.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/osst.c	2007-07-31 14:14:52.000000000 +0200
@@ -5778,13 +5778,12 @@ static int osst_probe(struct device *dev
 	dev_num = i;

 	/* allocate a struct osst_tape for this device */
-	tpnt = kmalloc(sizeof(struct osst_tape), GFP_ATOMIC);
-	if (tpnt == NULL) {
+	tpnt = kzalloc(sizeof(struct osst_tape), GFP_ATOMIC);
+	if (!tpnt) {
 		write_unlock(&os_scsi_tapes_lock);
 		printk(KERN_ERR "osst :E: Can't allocate device descriptor, device not attached.\n");
 		goto out_put_disk;
 	}
-	memset(tpnt, 0, sizeof(struct osst_tape));

 	/* allocate a buffer for this device */
 	i = SDp->host->sg_tablesize;
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/pluto.c linux-2.6.23-rc1-mm1-b/drivers/scsi/pluto.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/pluto.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/pluto.c	2007-07-31 18:18:38.000000000 +0200
@@ -111,13 +111,12 @@ int __init pluto_detect(struct scsi_host
 #endif
 			return 0;
 	}
-	fcs = kmalloc(sizeof (struct ctrl_inquiry) * fcscount, GFP_DMA);
+	fcs = kcalloc(fcscount, sizeof(struct ctrl_inquiry), GFP_DMA);
 	if (!fcs) {
 		printk ("PLUTO: Not enough memory to probe\n");
 		return 0;
 	}

-	memset (fcs, 0, sizeof (struct ctrl_inquiry) * fcscount);
 	memset (&dev, 0, sizeof(dev));
 	atomic_set (&fcss, fcscount);

@@ -211,12 +210,12 @@ int __init pluto_detect(struct scsi_host
 				char *p;
 				long *ages;

-				ages = kmalloc (((inq->channels + 1) * inq->targets) * sizeof(long), GFP_KERNEL);
-				if (!ages) continue;
+				ages = kcalloc((inq->channels + 1) * inq->targets, sizeof(long), GFP_KERNEL);
+				if (!ages)
+					continue;

 				host = scsi_register (tpnt, sizeof (struct pluto));
-				if(!host)
-				{
+				if (!host) {
 					kfree(ages);
 					continue;
 				}
@@ -238,7 +237,6 @@ int __init pluto_detect(struct scsi_host
 				fc->channels = inq->channels + 1;
 				fc->targets = inq->targets;
 				fc->ages = ages;
-				memset (ages, 0, ((inq->channels + 1) * inq->targets) * sizeof(long));

 				pluto->fc = fc;
 				memcpy (pluto->rev_str, inq->revision, 4);
@@ -260,7 +258,7 @@ int __init pluto_detect(struct scsi_host
 		} else
 			fc->fcp_register(fc, TYPE_SCSI_FCP, 1);
 	}
-	kfree((char *)fcs);
+	kfree(fcs);
 	if (nplutos)
 		printk ("PLUTO: Total of %d SparcSTORAGE Arrays found\n", nplutos);
 	return nplutos;
@@ -282,15 +280,19 @@ int pluto_release(struct Scsi_Host *host

 const char *pluto_info(struct Scsi_Host *host)
 {
-	static char buf[128], *p;
+	static char buf[128];
 	struct pluto *pluto = (struct pluto *) host->hostdata;

 	sprintf(buf, "SUN SparcSTORAGE Array %s fw %s serial %s %dx%d on %s",
 		pluto->rev_str, pluto->fw_rev_str, pluto->serial_str,
 		host->max_channel, host->max_id, pluto->fc->name);
 #ifdef __sparc__
-	p = strchr(buf, 0);
-	sprintf(p, " PROM node %x", pluto->fc->dev->prom_node);
+	{
+		char *p;
+
+		p = strchr(buf, 0);
+		sprintf(p, " PROM node %x", pluto->fc->dev->prom_node);
+	}
 #endif
 	return buf;
 }
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/qla2xxx/qla_init.c linux-2.6.23-rc1-mm1-b/drivers/scsi/qla2xxx/qla_init.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/qla2xxx/qla_init.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/qla2xxx/qla_init.c	2007-07-31 14:24:51.000000000 +0200
@@ -1787,12 +1787,11 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 {
 	fc_port_t *fcport;

-	fcport = kmalloc(sizeof(fc_port_t), flags);
-	if (fcport == NULL)
-		return (fcport);
+	fcport = kzalloc(sizeof(fc_port_t), flags);
+	if (!fcport)
+		return NULL;

 	/* Setup fcport template structure. */
-	memset(fcport, 0, sizeof (fc_port_t));
 	fcport->ha = ha;
 	fcport->vp_idx = ha->vp_idx;
 	fcport->port_type = FCT_UNKNOWN;
@@ -1802,7 +1801,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
 	spin_lock_init(&fcport->rport_lock);

-	return (fcport);
+	return fcport;
 }

 /*
@@ -2497,13 +2496,12 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 	rval = QLA_SUCCESS;

 	/* Try GID_PT to get device list, else GAN. */
-	swl = kmalloc(sizeof(sw_info_t) * MAX_FIBRE_DEVICES, GFP_ATOMIC);
-	if (swl == NULL) {
+	swl = kcalloc(MAX_FIBRE_DEVICES, sizeof(sw_info_t), GFP_ATOMIC);
+	if (!swl) {
 		/*EMPTY*/
 		DEBUG2(printk("scsi(%ld): GID_PT allocations failed, fallback "
 		    "on GA_NXT\n", ha->host_no));
 	} else {
-		memset(swl, 0, sizeof(sw_info_t) * MAX_FIBRE_DEVICES);
 		if (qla2x00_gid_pt(ha, swl) != QLA_SUCCESS) {
 			kfree(swl);
 			swl = NULL;
diff -upr linux-2.6.23-rc1-mm1-a/drivers/scsi/zorro7xx.c linux-2.6.23-rc1-mm1-b/drivers/scsi/zorro7xx.c
--- linux-2.6.23-rc1-mm1-a/drivers/scsi/zorro7xx.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/zorro7xx.c	2007-07-31 14:25:58.000000000 +0200
@@ -69,7 +69,7 @@ static struct zorro_device_id zorro7xx_z
 static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 				       const struct zorro_device_id *ent)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
 	struct zorro_driver_data *zdd;
 	unsigned long board, ioaddr;
@@ -89,14 +89,12 @@ static int __devinit zorro7xx_init_one(s
 		return -EBUSY;
 	}

-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (!hostdata) {
 		printk(KERN_ERR "zorro7xx: Failed to allocate host data\n");
 		goto out_release;
 	}

-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
-
 	/* Fill in the required pieces of hostdata */
 	if (ioaddr > 0x01000000)
 		hostdata->base = ioremap(ioaddr, zorro_resource_len(z));
