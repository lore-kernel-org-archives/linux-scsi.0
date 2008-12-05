From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 12/14] lpfc 8.3.0 :  Add BlockGuard support (T10-DIF) Part 2
Date: Thu, 4 Dec 2008 22:40:02 -0500
Message-ID: <1228448402.19053.57.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45990 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYLEOny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:54 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5Ehru6004300
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:54 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Add BlockGuard support (T10-DIF) Part 2

Add SCSI data path, error handling, and debugfs code to complete
BlockGuard support.


Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_debugfs.c |  152 +++++++
 drivers/scsi/lpfc/lpfc_mbox.c    |    2 
 drivers/scsi/lpfc/lpfc_scsi.c    |  874 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_scsi.h    |    2 
 drivers/scsi/lpfc/lpfc_sli.c     |   13 +
 5 files changed, 1026 insertions(+), 17 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -907,6 +907,91 @@ out:
 	return rc;
 }
 
+static int
+lpfc_debugfs_dumpData_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_debug *debug;
+	int rc = -ENOMEM;
+
+	if (!_dump_buf_data)
+		return -EBUSY;
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	/* Round to page boundry */
+	printk(KERN_ERR "BLKGRD %s: _dump_buf_data=0x%p\n",
+			__func__, _dump_buf_data);
+	debug->buffer = _dump_buf_data;
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->len = (1 << _dump_buf_data_order) << PAGE_SHIFT;
+	file->private_data = debug;
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static int
+lpfc_debugfs_dumpDif_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_debug *debug;
+	int rc = -ENOMEM;
+
+	if (!_dump_buf_dif)
+		return -EBUSY;
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	/* Round to page boundry */
+	printk(KERN_ERR "BLKGRD %s: _dump_buf_dif=0x%p file=%s\n", __func__,
+	       _dump_buf_dif, file->f_dentry->d_name.name);
+	debug->buffer = _dump_buf_dif;
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->len = (1 << _dump_buf_dif_order) << PAGE_SHIFT;
+	file->private_data = debug;
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static ssize_t
+lpfc_debugfs_dumpDataDif_write(struct file *file, const char __user *buf,
+		  size_t nbytes, loff_t *ppos)
+{
+	/*
+	 * The Data/DIF buffers only save one failing IO
+	 * The write op is used as a reset mechanism after an IO has
+	 * already been saved to the next one can be saved
+	 */
+	spin_lock(&_dump_buf_lock);
+
+	memset((void *)_dump_buf_data, 0,
+			((1 << PAGE_SHIFT) << _dump_buf_data_order));
+	memset((void *)_dump_buf_dif, 0,
+			((1 << PAGE_SHIFT) << _dump_buf_dif_order));
+
+	_dump_buf_done = 0;
+
+	spin_unlock(&_dump_buf_lock);
+
+	return nbytes;
+}
+
+
+
 /**
  * lpfc_debugfs_nodelist_open - Open the nodelist debugfs file.
  * @inode: The inode pointer that contains a vport pointer.
@@ -1035,6 +1120,17 @@ lpfc_debugfs_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int
+lpfc_debugfs_dumpDataDif_release(struct inode *inode, struct file *file)
+{
+	struct lpfc_debug *debug = file->private_data;
+
+	debug->buffer = NULL;
+	kfree(debug);
+
+	return 0;
+}
+
 #undef lpfc_debugfs_op_disc_trc
 static struct file_operations lpfc_debugfs_op_disc_trc = {
 	.owner =        THIS_MODULE,
@@ -1080,6 +1176,26 @@ static struct file_operations lpfc_debugfs_op_dumpHostSlim = {
 	.release =      lpfc_debugfs_release,
 };
 
+#undef lpfc_debugfs_op_dumpData
+static struct file_operations lpfc_debugfs_op_dumpData = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_dumpData_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.write =	lpfc_debugfs_dumpDataDif_write,
+	.release =      lpfc_debugfs_dumpDataDif_release,
+};
+
+#undef lpfc_debugfs_op_dumpDif
+static struct file_operations lpfc_debugfs_op_dumpDif = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_dumpDif_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.write =	lpfc_debugfs_dumpDataDif_write,
+	.release =      lpfc_debugfs_dumpDataDif_release,
+};
+
 #undef lpfc_debugfs_op_slow_ring_trc
 static struct file_operations lpfc_debugfs_op_slow_ring_trc = {
 	.owner =        THIS_MODULE,
@@ -1176,6 +1292,32 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			goto debug_failed;
 		}
 
+		/* Setup dumpData */
+		snprintf(name, sizeof(name), "dumpData");
+		phba->debug_dumpData =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				 phba->hba_debugfs_root,
+				 phba, &lpfc_debugfs_op_dumpData);
+		if (!phba->debug_dumpData) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+				"0800 Cannot create debugfs dumpData\n");
+			goto debug_failed;
+		}
+
+		/* Setup dumpDif */
+		snprintf(name, sizeof(name), "dumpDif");
+		phba->debug_dumpDif =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				 phba->hba_debugfs_root,
+				 phba, &lpfc_debugfs_op_dumpDif);
+		if (!phba->debug_dumpDif) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+				"0801 Cannot create debugfs dumpDif\n");
+			goto debug_failed;
+		}
+
+
+
 		/* Setup slow ring trace */
 		if (lpfc_debugfs_max_slow_ring_trc) {
 			num = lpfc_debugfs_max_slow_ring_trc - 1;
@@ -1340,6 +1482,16 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 			debugfs_remove(phba->debug_dumpHostSlim); /* HostSlim */
 			phba->debug_dumpHostSlim = NULL;
 		}
+		if (phba->debug_dumpData) {
+			debugfs_remove(phba->debug_dumpData); /* dumpData */
+			phba->debug_dumpData = NULL;
+		}
+
+		if (phba->debug_dumpDif) {
+			debugfs_remove(phba->debug_dumpDif); /* dumpDif */
+			phba->debug_dumpDif = NULL;
+		}
+
 		if (phba->slow_ring_trc) {
 			kfree(phba->slow_ring_trc);
 			phba->slow_ring_trc = NULL;
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1099,6 +1099,8 @@ lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	/* If HBA supports SLI=3 ask for it */
 
 	if (phba->sli_rev == 3 && phba->vpd.sli3Feat.cerbm) {
+		if (phba->cfg_enable_bg)
+			mb->un.varCfgPort.cbg = 1; /* configure BlockGuard */
 		mb->un.varCfgPort.cerbm = 1; /* Request HBQs */
 		mb->un.varCfgPort.ccrp = 1; /* Command Ring Polling */
 		mb->un.varCfgPort.cinb = 1; /* Interrupt Notification Block */
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -18,13 +18,14 @@
  * more details, a copy of which can be found in the file COPYING  *
  * included with this package.                                     *
  *******************************************************************/
-
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_fc.h>
@@ -43,6 +44,73 @@
 #define LPFC_RESET_WAIT  2
 #define LPFC_ABORT_WAIT  2
 
+int _dump_buf_done;
+
+static char *dif_op_str[] = {
+	"SCSI_PROT_NORMAL",
+	"SCSI_PROT_READ_INSERT",
+	"SCSI_PROT_WRITE_STRIP",
+	"SCSI_PROT_READ_STRIP",
+	"SCSI_PROT_WRITE_INSERT",
+	"SCSI_PROT_READ_PASS",
+	"SCSI_PROT_WRITE_PASS",
+	"SCSI_PROT_READ_CONVERT",
+	"SCSI_PROT_WRITE_CONVERT"
+};
+
+static void
+lpfc_debug_save_data(struct scsi_cmnd *cmnd)
+{
+	void *src, *dst;
+	struct scatterlist *sgde = scsi_sglist(cmnd);
+
+	if (!_dump_buf_data) {
+		printk(KERN_ERR "BLKGRD ERROR %s _dump_buf_data is NULL\n",
+				__func__);
+		return;
+	}
+
+
+	if (!sgde) {
+		printk(KERN_ERR "BLKGRD ERROR: data scatterlist is null\n");
+		return;
+	}
+
+	dst = (void *) _dump_buf_data;
+	while (sgde) {
+		src = sg_virt(sgde);
+		memcpy(dst, src, sgde->length);
+		dst += sgde->length;
+		sgde = sg_next(sgde);
+	}
+}
+
+static void
+lpfc_debug_save_dif(struct scsi_cmnd *cmnd)
+{
+	void *src, *dst;
+	struct scatterlist *sgde = scsi_prot_sglist(cmnd);
+
+	if (!_dump_buf_dif) {
+		printk(KERN_ERR "BLKGRD ERROR %s _dump_buf_data is NULL\n",
+				__func__);
+		return;
+	}
+
+	if (!sgde) {
+		printk(KERN_ERR "BLKGRD ERROR: prot scatterlist is null\n");
+		return;
+	}
+
+	dst = _dump_buf_dif;
+	while (sgde) {
+		src = sg_virt(sgde);
+		memcpy(dst, src, sgde->length);
+		dst += sgde->length;
+		sgde = sg_next(sgde);
+	}
+}
+
 /**
  * lpfc_update_stats: Update statistical data for the command completion.
  * @phba: Pointer to HBA object.
@@ -463,7 +531,8 @@ lpfc_new_scsi_buf(struct lpfc_vport *vport)
 	 */
 	iocb = &psb->cur_iocbq.iocb;
 	iocb->un.fcpi64.bdl.ulpIoTag32 = 0;
-	if (phba->sli_rev == 3) {
+	if ((phba->sli_rev == 3) &&
+	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED)) {
 		/* fill in immediate fcp command BDE */
 		iocb->un.fcpi64.bdl.bdeFlags = BUFF_TYPE_BDE_IMMED;
 		iocb->un.fcpi64.bdl.bdeSize = sizeof(struct fcp_cmnd);
@@ -516,6 +585,7 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba)
 	if (lpfc_cmd) {
 		lpfc_cmd->seg_cnt = 0;
 		lpfc_cmd->nonsg_phys = 0;
+		lpfc_cmd->prot_seg_cnt = 0;
 	}
 	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
 	return  lpfc_cmd;
@@ -590,7 +660,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 		lpfc_cmd->seg_cnt = nseg;
 		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
 			printk(KERN_ERR "%s: Too many sg segments from "
-			       "dma_map_sg.  Config %d, seg_cnt %d",
+			       "dma_map_sg.  Config %d, seg_cnt %d\n",
 			       __func__, phba->cfg_sg_seg_cnt,
 			       lpfc_cmd->seg_cnt);
 			scsi_dma_unmap(scsi_cmnd);
@@ -609,6 +679,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 		scsi_for_each_sg(scsi_cmnd, sgel, nseg, num_bde) {
 			physaddr = sg_dma_address(sgel);
 			if (phba->sli_rev == 3 &&
+			    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
 			    nseg <= LPFC_EXT_DATA_BDE_COUNT) {
 				data_bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 				data_bde->tus.f.bdeSize = sg_dma_len(sgel);
@@ -634,7 +705,8 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	 * explicitly reinitialized and for SLI-3 the extended bde count is
 	 * explicitly reinitialized since all iocb memory resources are reused.
 	 */
-	if (phba->sli_rev == 3) {
+	if (phba->sli_rev == 3 &&
+	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED)) {
 		if (num_bde > LPFC_EXT_DATA_BDE_COUNT) {
 			/*
 			 * The extended IOCB format can only fit 3 BDE or a BPL.
@@ -661,9 +733,685 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 			((num_bde + 2) * sizeof(struct ulp_bde64));
 	}
 	fcp_cmnd->fcpDl = cpu_to_be32(scsi_bufflen(scsi_cmnd));
+
+	/*
+	 * Due to difference in data length between DIF/non-DIF paths,
+	 * we need to set word 4 of IOCB here
+	 */
+	iocb_cmd->un.fcpi.fcpi_parm = le32_to_cpu(scsi_bufflen(scsi_cmnd));
 	return 0;
 }
 
+/*
+ * Given a scsi cmnd, determine the BlockGuard profile to be used
+ * with the cmd
+ */
+static int
+lpfc_sc_to_sli_prof(struct scsi_cmnd *sc)
+{
+	uint8_t guard_type = scsi_host_get_guard(sc->device->host);
+	uint8_t ret_prof = LPFC_PROF_INVALID;
+
+	if (guard_type == SHOST_DIX_GUARD_IP) {
+		switch (scsi_get_prot_op(sc)) {
+		case SCSI_PROT_READ_INSERT:
+		case SCSI_PROT_WRITE_STRIP:
+			ret_prof = LPFC_PROF_AST2;
+			break;
+
+		case SCSI_PROT_READ_STRIP:
+		case SCSI_PROT_WRITE_INSERT:
+			ret_prof = LPFC_PROF_A1;
+			break;
+
+		case SCSI_PROT_READ_CONVERT:
+		case SCSI_PROT_WRITE_CONVERT:
+			ret_prof = LPFC_PROF_AST1;
+			break;
+
+		case SCSI_PROT_READ_PASS:
+		case SCSI_PROT_WRITE_PASS:
+		case SCSI_PROT_NORMAL:
+		default:
+			printk(KERN_ERR "Bad op/guard:%d/%d combination\n",
+					scsi_get_prot_op(sc), guard_type);
+			break;
+
+		}
+	} else if (guard_type == SHOST_DIX_GUARD_CRC) {
+		switch (scsi_get_prot_op(sc)) {
+		case SCSI_PROT_READ_STRIP:
+		case SCSI_PROT_WRITE_INSERT:
+			ret_prof = LPFC_PROF_A1;
+			break;
+
+		case SCSI_PROT_READ_PASS:
+		case SCSI_PROT_WRITE_PASS:
+			ret_prof = LPFC_PROF_C1;
+			break;
+
+		case SCSI_PROT_READ_CONVERT:
+		case SCSI_PROT_WRITE_CONVERT:
+		case SCSI_PROT_READ_INSERT:
+		case SCSI_PROT_WRITE_STRIP:
+		case SCSI_PROT_NORMAL:
+		default:
+			printk(KERN_ERR "Bad op/guard:%d/%d combination\n",
+					scsi_get_prot_op(sc), guard_type);
+			break;
+		}
+	} else {
+		/* unsupported format */
+		BUG();
+	}
+
+	return ret_prof;
+}
+
+struct scsi_dif_tuple {
+	__be16 guard_tag;       /* Checksum */
+	__be16 app_tag;         /* Opaque storage */
+	__be32 ref_tag;         /* Target LBA or indirect LBA */
+};
+
+static inline unsigned
+lpfc_cmd_blksize(struct scsi_cmnd *sc)
+{
+	return sc->device->sector_size;
+}
+
+/**
+ * lpfc_get_cmd_dif_parms - Extract DIF parameters from SCSI command
+ * @sc:             in: SCSI command
+ * @apptagmask      out: app tag mask
+ * @apptagval       out: app tag value
+ * @reftag          out: ref tag (reference tag)
+ *
+ * Description:
+ *   Extract DIF paramters from the command if possible.  Otherwise,
+ *   use default paratmers.
+ *
+ **/
+static inline void
+lpfc_get_cmd_dif_parms(struct scsi_cmnd *sc, uint16_t *apptagmask,
+		uint16_t *apptagval, uint32_t *reftag)
+{
+	struct  scsi_dif_tuple *spt;
+	unsigned char op = scsi_get_prot_op(sc);
+	unsigned int protcnt = scsi_prot_sg_count(sc);
+	static int cnt;
+
+	if (protcnt && (op == SCSI_PROT_WRITE_STRIP ||
+				op == SCSI_PROT_WRITE_PASS ||
+				op == SCSI_PROT_WRITE_CONVERT)) {
+
+		cnt++;
+		spt = page_address(sg_page(scsi_prot_sglist(sc))) +
+			scsi_prot_sglist(sc)[0].offset;
+		*apptagmask = 0;
+		*apptagval = 0;
+		*reftag = cpu_to_be32(spt->ref_tag);
+
+	} else {
+		/* SBC defines ref tag to be lower 32bits of LBA */
+		*reftag = (uint32_t) (0xffffffff & scsi_get_lba(sc));
+		*apptagmask = 0;
+		*apptagval = 0;
+	}
+}
+
+/*
+ * This function sets up buffer list for protection groups of
+ * type LPFC_PG_TYPE_NO_DIF
+ *
+ * This is usually used when the HBA is instructed to generate
+ * DIFs and insert them into data stream (or strip DIF from
+ * incoming data stream)
+ *
+ * The buffer list consists of just one protection group described
+ * below:
+ *                                +-------------------------+
+ *   start of prot group  -->     |          PDE_1          |
+ *                                +-------------------------+
+ *                                |         Data BDE        |
+ *                                +-------------------------+
+ *                                |more Data BDE's ... (opt)|
+ *                                +-------------------------+
+ *
+ * @sc: pointer to scsi command we're working on
+ * @bpl: pointer to buffer list for protection groups
+ * @datacnt: number of segments of data that have been dma mapped
+ *
+ * Note: Data s/g buffers have been dma mapped
+ */
+static int
+lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
+		struct ulp_bde64 *bpl, int datasegcnt)
+{
+	struct scatterlist *sgde = NULL; /* s/g data entry */
+	struct lpfc_pde *pde1 = NULL;
+	dma_addr_t physaddr;
+	int i = 0, num_bde = 0;
+	int datadir = sc->sc_data_direction;
+	int prof = LPFC_PROF_INVALID;
+	unsigned blksize;
+	uint32_t reftag;
+	uint16_t apptagmask, apptagval;
+
+	pde1 = (struct lpfc_pde *) bpl;
+	prof = lpfc_sc_to_sli_prof(sc);
+
+	if (prof == LPFC_PROF_INVALID)
+		goto out;
+
+	/* extract some info from the scsi command for PDE1*/
+	blksize = lpfc_cmd_blksize(sc);
+	lpfc_get_cmd_dif_parms(sc, &apptagmask, &apptagval, &reftag);
+
+	/* setup PDE1 with what we have */
+	lpfc_pde_set_bg_parms(pde1, LPFC_PDE1_DESCRIPTOR, prof, blksize,
+			BG_EC_STOP_ERR);
+	lpfc_pde_set_dif_parms(pde1, apptagmask, apptagval, reftag);
+
+	num_bde++;
+	bpl++;
+
+	/* assumption: caller has already run dma_map_sg on command data */
+	scsi_for_each_sg(sc, sgde, datasegcnt, i) {
+		physaddr = sg_dma_address(sgde);
+		bpl->addrLow = le32_to_cpu(putPaddrLow(physaddr));
+		bpl->addrHigh = le32_to_cpu(putPaddrHigh(physaddr));
+		bpl->tus.f.bdeSize = sg_dma_len(sgde);
+		if (datadir == DMA_TO_DEVICE)
+			bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		else
+			bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64I;
+		bpl->tus.w = le32_to_cpu(bpl->tus.w);
+		bpl++;
+		num_bde++;
+	}
+
+out:
+	return num_bde;
+}
+
+/*
+ * This function sets up buffer list for protection groups of
+ * type LPFC_PG_TYPE_DIF_BUF
+ *
+ * This is usually used when DIFs are in their own buffers,
+ * separate from the data. The HBA can then by instructed
+ * to place the DIFs in the outgoing stream.  For read operations,
+ * The HBA could extract the DIFs and place it in DIF buffers.
+ *
+ * The buffer list for this type consists of one or more of the
+ * protection groups described below:
+ *                                    +-------------------------+
+ *   start of first prot group  -->   |          PDE_1          |
+ *                                    +-------------------------+
+ *                                    |      PDE_3 (Prot BDE)   |
+ *                                    +-------------------------+
+ *                                    |        Data BDE         |
+ *                                    +-------------------------+
+ *                                    |more Data BDE's ... (opt)|
+ *                                    +-------------------------+
+ *   start of new  prot group  -->    |          PDE_1          |
+ *                                    +-------------------------+
+ *                                    |          ...            |
+ *                                    +-------------------------+
+ *
+ * @sc: pointer to scsi command we're working on
+ * @bpl: pointer to buffer list for protection groups
+ * @datacnt: number of segments of data that have been dma mapped
+ * @protcnt: number of segment of protection data that have been dma mapped
+ *
+ * Note: It is assumed that both data and protection s/g buffers have been
+ *       mapped for DMA
+ */
+static int
+lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
+		struct ulp_bde64 *bpl, int datacnt, int protcnt)
+{
+	struct scatterlist *sgde = NULL; /* s/g data entry */
+	struct scatterlist *sgpe = NULL; /* s/g prot entry */
+	struct lpfc_pde *pde1 = NULL;
+	struct ulp_bde64 *prot_bde = NULL;
+	dma_addr_t dataphysaddr, protphysaddr;
+	unsigned short curr_data = 0, curr_prot = 0;
+	unsigned int split_offset, protgroup_len;
+	unsigned int protgrp_blks, protgrp_bytes;
+	unsigned int remainder, subtotal;
+	int prof = LPFC_PROF_INVALID;
+	int datadir = sc->sc_data_direction;
+	unsigned char pgdone = 0, alldone = 0;
+	unsigned blksize;
+	uint32_t reftag;
+	uint16_t apptagmask, apptagval;
+	int num_bde = 0;
+
+	sgpe = scsi_prot_sglist(sc);
+	sgde = scsi_sglist(sc);
+
+	if (!sgpe || !sgde) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
+				"9020 Invalid s/g entry: data=0x%p prot=0x%p\n",
+				sgpe, sgde);
+		return 0;
+	}
+
+	prof = lpfc_sc_to_sli_prof(sc);
+	if (prof == LPFC_PROF_INVALID)
+		goto out;
+
+	/* extract some info from the scsi command for PDE1*/
+	blksize = lpfc_cmd_blksize(sc);
+	lpfc_get_cmd_dif_parms(sc, &apptagmask, &apptagval, &reftag);
+
+	split_offset = 0;
+	do {
+		/* setup the first PDE_1 */
+		pde1 = (struct lpfc_pde *) bpl;
+
+		lpfc_pde_set_bg_parms(pde1, LPFC_PDE1_DESCRIPTOR, prof, blksize,
+				BG_EC_STOP_ERR);
+		lpfc_pde_set_dif_parms(pde1, apptagmask, apptagval, reftag);
+
+		num_bde++;
+		bpl++;
+
+		/* setup the first BDE that points to protection buffer */
+		prot_bde = (struct ulp_bde64 *) bpl;
+		protphysaddr = sg_dma_address(sgpe);
+		prot_bde->addrLow = le32_to_cpu(putPaddrLow(protphysaddr));
+		prot_bde->addrHigh = le32_to_cpu(putPaddrHigh(protphysaddr));
+		protgroup_len = sg_dma_len(sgpe);
+
+
+		/* must be integer multiple of the DIF block length */
+		BUG_ON(protgroup_len % 8);
+
+		protgrp_blks = protgroup_len / 8;
+		protgrp_bytes = protgrp_blks * blksize;
+
+		prot_bde->tus.f.bdeSize = protgroup_len;
+		if (datadir == DMA_TO_DEVICE)
+			prot_bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		else
+			prot_bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64I;
+		prot_bde->tus.w = le32_to_cpu(bpl->tus.w);
+
+		curr_prot++;
+		num_bde++;
+
+		/* setup BDE's for data blocks associated with DIF data */
+		pgdone = 0;
+		subtotal = 0; /* total bytes processed for current prot grp */
+		while (!pgdone) {
+			if (!sgde) {
+				printk(KERN_ERR "%s Invalid data segment\n",
+						__func__);
+				return 0;
+			}
+			bpl++;
+			dataphysaddr = sg_dma_address(sgde) + split_offset;
+			bpl->addrLow = le32_to_cpu(putPaddrLow(dataphysaddr));
+			bpl->addrHigh = le32_to_cpu(putPaddrHigh(dataphysaddr));
+
+			remainder = sg_dma_len(sgde) - split_offset;
+
+			if ((subtotal + remainder) <= protgrp_bytes) {
+				/* we can use this whole buffer */
+				bpl->tus.f.bdeSize = remainder;
+				split_offset = 0;
+
+				if ((subtotal + remainder) == protgrp_bytes)
+					pgdone = 1;
+			} else {
+				/* must split this buffer with next prot grp */
+				bpl->tus.f.bdeSize = protgrp_bytes - subtotal;
+				split_offset += bpl->tus.f.bdeSize;
+			}
+
+			subtotal += bpl->tus.f.bdeSize;
+
+			if (datadir == DMA_TO_DEVICE)
+				bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+			else
+				bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64I;
+			bpl->tus.w = le32_to_cpu(bpl->tus.w);
+
+			num_bde++;
+			curr_data++;
+
+			if (split_offset)
+				break;
+
+			/* Move to the next s/g segment if possible */
+			sgde = sg_next(sgde);
+		}
+
+		/* are we done ? */
+		if (curr_prot == protcnt) {
+			alldone = 1;
+		} else if (curr_prot < protcnt) {
+			/* advance to next prot buffer */
+			sgpe = sg_next(sgpe);
+			bpl++;
+
+			/* update the reference tag */
+			reftag += protgrp_blks;
+		} else {
+			/* if we're here, we have a bug */
+			printk(KERN_ERR "BLKGRD: bug in %s\n", __func__);
+		}
+
+	} while (!alldone);
+
+out:
+
+
+	return num_bde;
+}
+/*
+ * Given a SCSI command that supports DIF, determine composition of protection
+ * groups involved in setting up buffer lists
+ *
+ * Returns:
+ *			      for DIF (for both read and write)
+ * */
+static int
+lpfc_prot_group_type(struct lpfc_hba *phba, struct scsi_cmnd *sc)
+{
+	int ret = LPFC_PG_TYPE_INVALID;
+	unsigned char op = scsi_get_prot_op(sc);
+
+	switch (op) {
+	case SCSI_PROT_READ_STRIP:
+	case SCSI_PROT_WRITE_INSERT:
+		ret = LPFC_PG_TYPE_NO_DIF;
+		break;
+	case SCSI_PROT_READ_INSERT:
+	case SCSI_PROT_WRITE_STRIP:
+	case SCSI_PROT_READ_PASS:
+	case SCSI_PROT_WRITE_PASS:
+	case SCSI_PROT_WRITE_CONVERT:
+	case SCSI_PROT_READ_CONVERT:
+		ret = LPFC_PG_TYPE_DIF_BUF;
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
+				"9021 Unsupported protection op:%d\n", op);
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * This is the protection/DIF aware version of
+ * lpfc_scsi_prep_dma_buf(). It may be a good idea to combine the
+ * two functions eventually, but for now, it's here
+ */
+static int
+lpfc_bg_scsi_prep_dma_buf(struct lpfc_hba *phba,
+		struct lpfc_scsi_buf *lpfc_cmd)
+{
+	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
+	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
+	struct ulp_bde64 *bpl = lpfc_cmd->fcp_bpl;
+	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
+	uint32_t num_bde = 0;
+	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
+	int prot_group_type = 0;
+	int diflen, fcpdl;
+	unsigned blksize;
+
+	/*
+	 * Start the lpfc command prep by bumping the bpl beyond fcp_cmnd
+	 *  fcp_rsp regions to the first data bde entry
+	 */
+	bpl += 2;
+	if (scsi_sg_count(scsi_cmnd)) {
+		/*
+		 * The driver stores the segment count returned from pci_map_sg
+		 * because this a count of dma-mappings used to map the use_sg
+		 * pages.  They are not guaranteed to be the same for those
+		 * architectures that implement an IOMMU.
+		 */
+		datasegcnt = dma_map_sg(&phba->pcidev->dev,
+					scsi_sglist(scsi_cmnd),
+					scsi_sg_count(scsi_cmnd), datadir);
+		if (unlikely(!datasegcnt))
+			return 1;
+
+		lpfc_cmd->seg_cnt = datasegcnt;
+		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
+			printk(KERN_ERR "%s: Too many sg segments from "
+					"dma_map_sg.  Config %d, seg_cnt %d\n",
+					__func__, phba->cfg_sg_seg_cnt,
+					lpfc_cmd->seg_cnt);
+			scsi_dma_unmap(scsi_cmnd);
+			return 1;
+		}
+
+		prot_group_type = lpfc_prot_group_type(phba, scsi_cmnd);
+
+		switch (prot_group_type) {
+		case LPFC_PG_TYPE_NO_DIF:
+			num_bde = lpfc_bg_setup_bpl(phba, scsi_cmnd, bpl,
+					datasegcnt);
+			/* we shoud have 2 or more entries in buffer list */
+			if (num_bde < 2)
+				goto err;
+			break;
+		case LPFC_PG_TYPE_DIF_BUF:{
+			/*
+			 * This type indicates that protection buffers are
+			 * passed to the driver, so that needs to be prepared
+			 * for DMA
+			 */
+			protsegcnt = dma_map_sg(&phba->pcidev->dev,
+					scsi_prot_sglist(scsi_cmnd),
+					scsi_prot_sg_count(scsi_cmnd), datadir);
+			if (unlikely(!protsegcnt)) {
+				scsi_dma_unmap(scsi_cmnd);
+				return 1;
+			}
+
+			lpfc_cmd->prot_seg_cnt = protsegcnt;
+			if (lpfc_cmd->prot_seg_cnt
+			    > phba->cfg_prot_sg_seg_cnt) {
+				printk(KERN_ERR "%s: Too many prot sg segments "
+						"from dma_map_sg.  Config %d,"
+						"prot_seg_cnt %d\n", __func__,
+						phba->cfg_prot_sg_seg_cnt,
+						lpfc_cmd->prot_seg_cnt);
+				dma_unmap_sg(&phba->pcidev->dev,
+					     scsi_prot_sglist(scsi_cmnd),
+					     scsi_prot_sg_count(scsi_cmnd),
+					     datadir);
+				scsi_dma_unmap(scsi_cmnd);
+				return 1;
+			}
+
+			num_bde = lpfc_bg_setup_bpl_prot(phba, scsi_cmnd, bpl,
+					datasegcnt, protsegcnt);
+			/* we shoud have 3 or more entries in buffer list */
+			if (num_bde < 3)
+				goto err;
+			break;
+		}
+		case LPFC_PG_TYPE_INVALID:
+		default:
+			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
+					"9022 Unexpected protection group %i\n",
+					prot_group_type);
+			return 1;
+		}
+	}
+
+	/*
+	 * Finish initializing those IOCB fields that are dependent on the
+	 * scsi_cmnd request_buffer.  Note that the bdeSize is explicitly
+	 * reinitialized since all iocb memory resources are used many times
+	 * for transmit, receive, and continuation bpl's.
+	 */
+	iocb_cmd->un.fcpi64.bdl.bdeSize = (2 * sizeof(struct ulp_bde64));
+	iocb_cmd->un.fcpi64.bdl.bdeSize += (num_bde * sizeof(struct ulp_bde64));
+	iocb_cmd->ulpBdeCount = 1;
+	iocb_cmd->ulpLe = 1;
+
+	fcpdl = scsi_bufflen(scsi_cmnd);
+
+	if (scsi_get_prot_type(scsi_cmnd) == SCSI_PROT_DIF_TYPE1) {
+		/*
+		 * We are in DIF Type 1 mode
+		 * Every data block has a 8 byte DIF (trailer)
+		 * attached to it.  Must ajust FCP data length
+		 */
+		blksize = lpfc_cmd_blksize(scsi_cmnd);
+		diflen = (fcpdl / blksize) * 8;
+		fcpdl += diflen;
+	}
+	fcp_cmnd->fcpDl = be32_to_cpu(fcpdl);
+
+	/*
+	 * Due to difference in data length between DIF/non-DIF paths,
+	 * we need to set word 4 of IOCB here
+	 */
+	iocb_cmd->un.fcpi.fcpi_parm = fcpdl;
+
+	return 0;
+err:
+	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
+			"9023 Could not setup all needed BDE's"
+			"prot_group_type=%d, num_bde=%d\n",
+			prot_group_type, num_bde);
+	return 1;
+}
+
+/*
+ * This function checks for BlockGuard errors detected by
+ * the HBA.  In case of errors, the ASC/ASCQ fields in the
+ * sense buffer will be set accordingly, paired with
+ * ILLEGAL_REQUEST to signal to the kernel that the HBA
+ * detected corruption.
+ *
+ * Returns:
+ *  0 - No error found
+ *  1 - BlockGuard error found
+ * -1 - Internal error (bad profile, ...etc)
+ */
+static int
+lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd,
+			struct lpfc_iocbq *pIocbOut)
+{
+	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
+	struct sli3_bg_fields *bgf = &pIocbOut->iocb.unsli3.sli3_bg;
+	int ret = 0;
+	uint32_t bghm = bgf->bghm;
+	uint32_t bgstat = bgf->bgstat;
+	uint64_t failing_sector = 0;
+
+	printk(KERN_ERR "BG ERROR in cmd 0x%x lba 0x%llx blk cnt 0x%lx "
+			"bgstat=0x%x bghm=0x%x\n",
+			cmd->cmnd[0], (u64)scsi_get_lba(cmd),
+			cmd->request->nr_sectors, bgstat, bghm);
+
+	spin_lock(&_dump_buf_lock);
+	if (!_dump_buf_done) {
+		printk(KERN_ERR "Saving Data for %u blocks to debugfs\n",
+				(cmd->cmnd[7] << 8 | cmd->cmnd[8]));
+		lpfc_debug_save_data(cmd);
+
+		/* If we have a prot sgl, save the DIF buffer */
+		if (lpfc_prot_group_type(phba, cmd) ==
+				LPFC_PG_TYPE_DIF_BUF) {
+			printk(KERN_ERR "Saving DIF for %u blocks to debugfs\n",
+					(cmd->cmnd[7] << 8 | cmd->cmnd[8]));
+			lpfc_debug_save_dif(cmd);
+		}
+
+		_dump_buf_done = 1;
+	}
+	spin_unlock(&_dump_buf_lock);
+
+	if (lpfc_bgs_get_invalid_prof(bgstat)) {
+		cmd->result = ScsiResult(DID_ERROR, 0);
+		printk(KERN_ERR "Invalid BlockGuard profile. bgstat:0x%x\n",
+				bgstat);
+		ret = (-1);
+		goto out;
+	}
+
+	if (lpfc_bgs_get_uninit_dif_block(bgstat)) {
+		cmd->result = ScsiResult(DID_ERROR, 0);
+		printk(KERN_ERR "Invalid BlockGuard DIF Block. bgstat:0x%x\n",
+				bgstat);
+		ret = (-1);
+		goto out;
+	}
+
+	if (lpfc_bgs_get_guard_err(bgstat)) {
+		ret = 1;
+
+		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
+				0x10, 0x1);
+		cmd->result = (DRIVER_SENSE|SUGGEST_DIE) << 24
+			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
+		phba->bg_guard_err_cnt++;
+		printk(KERN_ERR "BLKGRD: guard_tag error\n");
+	}
+
+	if (lpfc_bgs_get_reftag_err(bgstat)) {
+		ret = 1;
+
+		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
+				0x10, 0x3);
+		cmd->result = (DRIVER_SENSE|SUGGEST_DIE) << 24
+			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
+
+		phba->bg_reftag_err_cnt++;
+		printk(KERN_ERR "BLKGRD: ref_tag error\n");
+	}
+
+	if (lpfc_bgs_get_apptag_err(bgstat)) {
+		ret = 1;
+
+		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
+				0x10, 0x2);
+		cmd->result = (DRIVER_SENSE|SUGGEST_DIE) << 24
+			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
+
+		phba->bg_apptag_err_cnt++;
+		printk(KERN_ERR "BLKGRD: app_tag error\n");
+	}
+
+	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
+		/*
+		 * setup sense data descriptor 0 per SPC-4 as an information
+		 * field, and put the failing LBA in it
+		 */
+		cmd->sense_buffer[8] = 0;     /* Information */
+		cmd->sense_buffer[9] = 0xa;   /* Add. length */
+		do_div(bghm, cmd->device->sector_size);
+
+		failing_sector = scsi_get_lba(cmd);
+		failing_sector += bghm;
+
+		put_unaligned_be64(failing_sector, &cmd->sense_buffer[10]);
+	}
+
+	if (!ret) {
+		/* No error was reported - problem in FW? */
+		cmd->result = ScsiResult(DID_ERROR, 0);
+		printk(KERN_ERR "BLKGRD: no errors reported!\n");
+	}
+
+out:
+	return ret;
+}
+
 /**
  * lpfc_send_scsi_error_event: Posts an event when there is SCSI error.
  * @phba: Pointer to hba context object.
@@ -775,6 +1523,10 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
 	 */
 	if (psb->seg_cnt > 0)
 		scsi_dma_unmap(psb->pCmd);
+	if (psb->prot_seg_cnt > 0)
+		dma_unmap_sg(&phba->pcidev->dev, scsi_prot_sglist(psb->pCmd),
+				scsi_prot_sg_count(psb->pCmd),
+				psb->pCmd->sc_data_direction);
 }
 
 /**
@@ -828,7 +1580,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		logit = LOG_FCP;
 
 	lpfc_printf_vlog(vport, KERN_WARNING, logit,
-			 "0730 FCP command x%x failed: x%x SNS x%x x%x "
+			 "9024 FCP command x%x failed: x%x SNS x%x x%x "
 			 "Data: x%x x%x x%x x%x x%x\n",
 			 cmnd->cmnd[0], scsi_status,
 			 be32_to_cpu(*lp), be32_to_cpu(*(lp + 3)), resp_info,
@@ -851,7 +1603,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		scsi_set_resid(cmnd, be32_to_cpu(fcprsp->rspResId));
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-				 "0716 FCP Read Underrun, expected %d, "
+				 "9025 FCP Read Underrun, expected %d, "
 				 "residual %d Data: x%x x%x x%x\n",
 				 be32_to_cpu(fcpcmd->fcpDl),
 				 scsi_get_resid(cmnd), fcpi_parm, cmnd->cmnd[0],
@@ -867,7 +1619,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 			(scsi_get_resid(cmnd) != fcpi_parm)) {
 			lpfc_printf_vlog(vport, KERN_WARNING,
 					 LOG_FCP | LOG_FCP_ERROR,
-					 "0735 FCP Read Check Error "
+					 "9026 FCP Read Check Error "
 					 "and Underrun Data: x%x x%x x%x x%x\n",
 					 be32_to_cpu(fcpcmd->fcpDl),
 					 scsi_get_resid(cmnd), fcpi_parm,
@@ -886,7 +1638,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		    (scsi_bufflen(cmnd) - scsi_get_resid(cmnd)
 		     < cmnd->underflow)) {
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-					 "0717 FCP command x%x residual "
+					 "9027 FCP command x%x residual "
 					 "underrun converted to error "
 					 "Data: x%x x%x x%x\n",
 					 cmnd->cmnd[0], scsi_bufflen(cmnd),
@@ -895,7 +1647,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		}
 	} else if (resp_info & RESID_OVER) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
-				 "0720 FCP command x%x residual overrun error. "
+				 "9028 FCP command x%x residual overrun error. "
 				 "Data: x%x x%x \n", cmnd->cmnd[0],
 				 scsi_bufflen(cmnd), scsi_get_resid(cmnd));
 		host_status = DID_ERROR;
@@ -907,7 +1659,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 	} else if ((scsi_status == SAM_STAT_GOOD) && fcpi_parm &&
 			(cmnd->sc_data_direction == DMA_FROM_DEVICE)) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP | LOG_FCP_ERROR,
-				 "0734 FCP Read Check Error Data: "
+				 "9029 FCP Read Check Error Data: "
 				 "x%x x%x x%x x%x\n",
 				 be32_to_cpu(fcpcmd->fcpDl),
 				 be32_to_cpu(fcprsp->rspResId),
@@ -960,7 +1712,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			lpfc_cmd->status = IOSTAT_DEFAULT;
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
-				 "0729 FCP cmd x%x failed <%d/%d> "
+				 "9030 FCP cmd x%x failed <%d/%d> "
 				 "status: x%x result: x%x Data: x%x x%x\n",
 				 cmd->cmnd[0],
 				 cmd->device ? cmd->device->id : 0xffff,
@@ -1008,7 +1760,28 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			    lpfc_cmd->result == IOERR_ABORT_REQUESTED) {
 				cmd->result = ScsiResult(DID_REQUEUE, 0);
 				break;
-			} /* else: fall through */
+			}
+
+			if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
+			     lpfc_cmd->result == IOERR_TX_DMA_FAILED) &&
+			     pIocbOut->iocb.unsli3.sli3_bg.bgstat) {
+				if (scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
+					/*
+					 * This is a response for a BG enabled
+					 * cmd. Parse BG error
+					 */
+					lpfc_parse_bg_err(phba, lpfc_cmd,
+							pIocbOut);
+					break;
+				} else {
+					lpfc_printf_vlog(vport, KERN_WARNING,
+							LOG_BG,
+							"9031 non-zero BGSTAT "
+							"on unprotected cmd");
+				}
+			}
+
+		/* else: fall through */
 		default:
 			cmd->result = ScsiResult(DID_ERROR, 0);
 			break;
@@ -1243,7 +2016,6 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		} else {
 			iocb_cmd->ulpCommand = CMD_FCP_IREAD64_CR;
 			iocb_cmd->ulpPU = PARM_READ_CHECK;
-			iocb_cmd->un.fcpi.fcpi_parm = scsi_bufflen(scsi_cmnd);
 			fcp_cmnd->fcpCntl3 = READ_DATA;
 			phba->fc4InputRequests++;
 		}
@@ -1254,7 +2026,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		fcp_cmnd->fcpCntl3 = 0;
 		phba->fc4ControlRequests++;
 	}
-	if (phba->sli_rev == 3)
+	if (phba->sli_rev == 3 &&
+	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED))
 		lpfc_fcpcmd_to_iocb(iocb_cmd->unsli3.fcp_ext.icd, fcp_cmnd);
 	/*
 	 * Finish initializing those IOCB fields that are independent
@@ -1312,7 +2085,8 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
 	int_to_scsilun(lun, &fcp_cmnd->fcp_lun);
 	fcp_cmnd->fcpCntl2 = task_mgmt_cmd;
-	if (vport->phba->sli_rev == 3)
+	if (vport->phba->sli_rev == 3 &&
+	    !(vport->phba->sli3_options & LPFC_SLI3_BG_ENABLED))
 		lpfc_fcpcmd_to_iocb(piocb->unsli3.fcp_ext.icd, fcp_cmnd);
 	piocb->ulpCommand = CMD_FCP_ICMND64_CR;
 	piocb->ulpContext = ndlp->nlp_rpi;
@@ -1541,6 +2315,17 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		goto out_fail_command;
 	}
 
+	if (!(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
+		scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
+
+		printk(KERN_ERR "BLKGRD ERROR: rcvd protected cmd:%02x op:%02x "
+				"str=%s without registering for BlockGuard - "
+				"Rejecting command\n",
+				cmnd->cmnd[0], scsi_get_prot_op(cmnd),
+				dif_op_str[scsi_get_prot_op(cmnd)]);
+		goto out_fail_command;
+	}
+
 	/*
 	 * Catch race where our node has transitioned, but the
 	 * transport is still transitioning.
@@ -1574,7 +2359,64 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	cmnd->host_scribble = (unsigned char *)lpfc_cmd;
 	cmnd->scsi_done = done;
 
-	err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
+	if (scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+				"9033 BLKGRD: rcvd protected cmd:%02x op:%02x "
+				"str=%s\n",
+				cmnd->cmnd[0], scsi_get_prot_op(cmnd),
+				dif_op_str[scsi_get_prot_op(cmnd)]);
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+				"9034 BLKGRD: CDB: %02x %02x %02x %02x %02x "
+				"%02x %02x %02x %02x %02x \n",
+				cmnd->cmnd[0], cmnd->cmnd[1], cmnd->cmnd[2],
+				cmnd->cmnd[3], cmnd->cmnd[4], cmnd->cmnd[5],
+				cmnd->cmnd[6], cmnd->cmnd[7], cmnd->cmnd[8],
+				cmnd->cmnd[9]);
+		if (cmnd->cmnd[0] == READ_10)
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+					"9035 BLKGRD: READ @ sector %llu, "
+					 "count %lu\n",
+					 (u64)scsi_get_lba(cmnd),
+					cmnd->request->nr_sectors);
+		else if (cmnd->cmnd[0] == WRITE_10)
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+					"9036 BLKGRD: WRITE @ sector %llu, "
+					"count %lu cmd=%p\n",
+					(u64)scsi_get_lba(cmnd),
+					cmnd->request->nr_sectors,
+					cmnd);
+
+		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
+	} else {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+				"9038 BLKGRD: rcvd unprotected cmd:%02x op:%02x"
+				" str=%s\n",
+				cmnd->cmnd[0], scsi_get_prot_op(cmnd),
+				dif_op_str[scsi_get_prot_op(cmnd)]);
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+				 "9039 BLKGRD: CDB: %02x %02x %02x %02x %02x "
+				 "%02x %02x %02x %02x %02x \n",
+				 cmnd->cmnd[0], cmnd->cmnd[1], cmnd->cmnd[2],
+				 cmnd->cmnd[3], cmnd->cmnd[4], cmnd->cmnd[5],
+				 cmnd->cmnd[6], cmnd->cmnd[7], cmnd->cmnd[8],
+				 cmnd->cmnd[9]);
+		if (cmnd->cmnd[0] == READ_10)
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+					 "9040 dbg: READ @ sector %llu, "
+					 "count %lu\n", (u64)scsi_get_lba(cmnd),
+					 cmnd->request->nr_sectors);
+		else if (cmnd->cmnd[0] == WRITE_10)
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+					 "9041 dbg: WRITE @ sector %llu, "
+					 "count %lu cmd=%p\n",
+					 (u64)scsi_get_lba(cmnd),
+					 cmnd->request->nr_sectors, cmnd);
+		else
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+					 "9042 dbg: parser not implemented\n");
+		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
+	}
+
 	if (err)
 		goto out_host_busy_free_buf;
 
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -124,6 +124,8 @@ struct lpfc_scsi_buf {
 	uint32_t   seg_cnt;	/* Number of scatter-gather segments returned by
 				 * dma_map_sg.  The driver needs this for calls
 				 * to dma_unmap_sg. */
+	uint32_t prot_seg_cnt;  /* seg_cnt's counterpart for protection data */
+
 	dma_addr_t nonsg_phys;	/* Non scatter-gather physical address. */
 
 	/*
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -542,6 +542,7 @@ lpfc_sli_submit_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	 */
 	nextiocb->iocb.ulpIoTag = (nextiocb->iocb_cmpl) ? nextiocb->iotag : 0;
 
+
 	if (pring->ringno == LPFC_ELS_RING) {
 		lpfc_debugfs_slow_ring_trc(phba,
 			"IOCB cmd ring:   wd4:x%08x wd6:x%08x wd7:x%08x",
@@ -3044,7 +3045,8 @@ lpfc_sli_config_port(struct lpfc_hba *phba, int sli_mode)
 		phba->sli3_options &= ~(LPFC_SLI3_NPIV_ENABLED |
 					LPFC_SLI3_HBQ_ENABLED |
 					LPFC_SLI3_CRP_ENABLED |
-					LPFC_SLI3_INB_ENABLED);
+					LPFC_SLI3_INB_ENABLED |
+					LPFC_SLI3_BG_ENABLED);
 		if (rc != MBX_SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0442 Adapter failed to init, mbxCmd x%x "
@@ -3089,6 +3091,15 @@ lpfc_sli_config_port(struct lpfc_hba *phba, int sli_mode)
 			phba->inb_ha_copy = NULL;
 			phba->inb_counter = NULL;
 		}
+
+		if (phba->cfg_enable_bg) {
+			if (pmb->mb.un.varCfgPort.gbg)
+				phba->sli3_options |= LPFC_SLI3_BG_ENABLED;
+			else
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0443 Adapter did not grant "
+						"BlockGuard\n");
+		}
 	} else {
 		phba->hbq_get = NULL;
 		phba->port_gp = phba->mbox->us.s2.port;


