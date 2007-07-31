From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/8] lpfc 8.2.2 : Error messages and debugfs updates
Date: Tue, 31 Jul 2007 21:27:16 +0000 (UTC)
Message-ID: <1186067383.14374.14.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50129 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbXGaV0v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 17:26:51 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l6VLQnie028958
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 14:26:50 -0700 (PDT)
Date: Thu, 02 Aug 2007 11:09:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Error messages and debugfs updates:
 - Fix up GID_FT error messages
 - Enhance debugfs with slow_ring_trace, dumpslim and nodelist information
 - Add log type (and messages) for vport state changes
 - Enhance log messages when retries ELS fail


Signed-off-by: James Smart <James.Smart@emulex.com>



diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-08-02 09:18:14.000000000 -0400
@@ -271,6 +271,8 @@ extern void lpfc_debugfs_initialize(stru
 extern void lpfc_debugfs_terminate(struct lpfc_vport *);
 extern void lpfc_debugfs_disc_trc(struct lpfc_vport *, int, char *, uint32_t,
 	uint32_t, uint32_t);
+extern void lpfc_debugfs_slow_ring_trc(struct lpfc_hba *, char *, uint32_t,
+	uint32_t, uint32_t);
 
 /* Interface exported by fabric iocb scheduler */
 int lpfc_issue_fabric_iocb(struct lpfc_hba *, struct lpfc_iocbq *);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 09:18:14.000000000 -0400
@@ -607,7 +607,25 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 		} else if (CTrsp->CommandResponse.bits.CmdRsp ==
 			   be16_to_cpu(SLI_CT_RESPONSE_FS_RJT)) {
 			/* NameServer Rsp Error */
-			lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
+			if ((CTrsp->ReasonCode == SLI_CT_UNABLE_TO_PERFORM_REQ)
+			    && (CTrsp->Explanation == SLI_CT_NO_FC4_TYPES)) {
+				lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
+					"%d (%d):0269 No NameServer Entries "
+					"Data: x%x x%x x%x x%x\n",
+					phba->brd_no, vport->vpi,
+					CTrsp->CommandResponse.bits.CmdRsp,
+					(uint32_t) CTrsp->ReasonCode,
+					(uint32_t) CTrsp->Explanation,
+					vport->fc_flag);
+
+				lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+				"GID_FT no entry  cmd:x%x rsn:x%x exp:x%x",
+				(uint32_t)CTrsp->CommandResponse.bits.CmdRsp,
+				(uint32_t) CTrsp->ReasonCode,
+				(uint32_t) CTrsp->Explanation);
+			}
+			else {
+				lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
 					"%d (%d):0240 NameServer Rsp Error "
 					"Data: x%x x%x x%x x%x\n",
 					phba->brd_no, vport->vpi,
@@ -616,11 +634,13 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 					(uint32_t) CTrsp->Explanation,
 					vport->fc_flag);
 
-			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+				lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
 				"GID_FT rsp err1  cmd:x%x rsn:x%x exp:x%x",
 				(uint32_t)CTrsp->CommandResponse.bits.CmdRsp,
 				(uint32_t) CTrsp->ReasonCode,
 				(uint32_t) CTrsp->Explanation);
+			}
+
 
 		} else {
 			/* NameServer Rsp Error */
@@ -696,7 +716,7 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba 
 			if ((fbits & FC4_FEATURE_INIT) &&
 			    !(fbits & FC4_FEATURE_TARGET)) {
 				lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
-						"%d (%d):0245 Skip x%x GFF "
+						"%d (%d):0270 Skip x%x GFF "
 						"NameServer Rsp Data: (init) "
 						"x%x x%x\n", phba->brd_no,
 						vport->vpi, did, fbits,
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2007-08-02 09:18:14.000000000 -0400
@@ -75,11 +75,18 @@ static int lpfc_debugfs_enable = 0;
 module_param(lpfc_debugfs_enable, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_enable, "Enable debugfs services");
 
-static int lpfc_debugfs_max_disc_trc = 0;  /* This MUST be a power of 2 */
+/* This MUST be a power of 2 */
+static int lpfc_debugfs_max_disc_trc = 0;
 module_param(lpfc_debugfs_max_disc_trc, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_max_disc_trc,
 	"Set debugfs discovery trace depth");
 
+/* This MUST be a power of 2 */
+static int lpfc_debugfs_max_slow_ring_trc = 0;
+module_param(lpfc_debugfs_max_slow_ring_trc, int, 0);
+MODULE_PARM_DESC(lpfc_debugfs_max_slow_ring_trc,
+	"Set debugfs slow ring trace depth");
+
 static int lpfc_debugfs_mask_disc_trc = 0;
 module_param(lpfc_debugfs_mask_disc_trc, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_mask_disc_trc,
@@ -87,19 +94,22 @@ MODULE_PARM_DESC(lpfc_debugfs_mask_disc_
 
 #include <linux/debugfs.h>
 
-/* size of discovery_trace output line */
-#define LPFC_DISC_TRC_ENTRY_SIZE 80
+/* size of output line, for discovery_trace and slow_ring_trace */
+#define LPFC_DEBUG_TRC_ENTRY_SIZE 100
 
 /* nodelist output buffer size */
 #define LPFC_NODELIST_SIZE 8192
 #define LPFC_NODELIST_ENTRY_SIZE 120
 
+/* dump_slim output buffer size */
+#define LPFC_DUMPSLIM_SIZE 4096
+
 struct lpfc_debug {
 	char *buffer;
 	int  len;
 };
 
-atomic_t lpfc_debugfs_disc_trc_cnt = ATOMIC_INIT(0);
+atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
 unsigned long lpfc_debugfs_start_time = 0L;
 
 static int
@@ -107,8 +117,8 @@ lpfc_debugfs_disc_trc_data(struct lpfc_v
 {
 	int i, index, len, enable;
 	uint32_t ms;
-	struct lpfc_disc_trc *dtp;
-	char buffer[80];
+	struct lpfc_debugfs_trc *dtp;
+	char buffer[LPFC_DEBUG_TRC_ENTRY_SIZE];
 

 	enable = lpfc_debugfs_enable;
@@ -122,7 +132,8 @@ lpfc_debugfs_disc_trc_data(struct lpfc_v
 		if (!dtp->fmt)
 			continue;
 		ms = jiffies_to_msecs(dtp->jif - lpfc_debugfs_start_time);
-		snprintf(buffer, 80, "%010d:%010d ms:%s\n",
+		snprintf(buffer,
+			LPFC_DEBUG_TRC_ENTRY_SIZE, "%010d:%010d ms:%s\n",
 			dtp->seq_cnt, ms, dtp->fmt);
 		len +=  snprintf(buf+len, size-len, buffer,
 			dtp->data1, dtp->data2, dtp->data3);
@@ -132,7 +143,50 @@ lpfc_debugfs_disc_trc_data(struct lpfc_v
 		if (!dtp->fmt)
 			continue;
 		ms = jiffies_to_msecs(dtp->jif - lpfc_debugfs_start_time);
-		snprintf(buffer, 80, "%010d:%010d ms:%s\n",
+		snprintf(buffer,
+			LPFC_DEBUG_TRC_ENTRY_SIZE, "%010d:%010d ms:%s\n",
+			dtp->seq_cnt, ms, dtp->fmt);
+		len +=  snprintf(buf+len, size-len, buffer,
+			dtp->data1, dtp->data2, dtp->data3);
+	}
+
+	lpfc_debugfs_enable = enable;
+	return len;
+}
+
+static int
+lpfc_debugfs_slow_ring_trc_data(struct lpfc_hba *phba, char *buf, int size)
+{
+	int i, index, len, enable;
+	uint32_t ms;
+	struct lpfc_debugfs_trc *dtp;
+	char buffer[LPFC_DEBUG_TRC_ENTRY_SIZE];
+
+
+	enable = lpfc_debugfs_enable;
+	lpfc_debugfs_enable = 0;
+
+	len = 0;
+	index = (atomic_read(&phba->slow_ring_trc_cnt) + 1) &
+		(lpfc_debugfs_max_slow_ring_trc - 1);
+	for (i = index; i < lpfc_debugfs_max_slow_ring_trc; i++) {
+		dtp = phba->slow_ring_trc + i;
+		if (!dtp->fmt)
+			continue;
+		ms = jiffies_to_msecs(dtp->jif - lpfc_debugfs_start_time);
+		snprintf(buffer,
+			LPFC_DEBUG_TRC_ENTRY_SIZE, "%010d:%010d ms:%s\n",
+			dtp->seq_cnt, ms, dtp->fmt);
+		len +=  snprintf(buf+len, size-len, buffer,
+			dtp->data1, dtp->data2, dtp->data3);
+	}
+	for (i = 0; i < index; i++) {
+		dtp = phba->slow_ring_trc + i;
+		if (!dtp->fmt)
+			continue;
+		ms = jiffies_to_msecs(dtp->jif - lpfc_debugfs_start_time);
+		snprintf(buffer,
+			LPFC_DEBUG_TRC_ENTRY_SIZE, "%010d:%010d ms:%s\n",
 			dtp->seq_cnt, ms, dtp->fmt);
 		len +=  snprintf(buf+len, size-len, buffer,
 			dtp->data1, dtp->data2, dtp->data3);
@@ -143,6 +197,95 @@ lpfc_debugfs_disc_trc_data(struct lpfc_v
 }
 
 static int
+lpfc_debugfs_dumpslim_data(struct lpfc_hba *phba, char *buf, int size)
+{
+	int len = 0;
+	int cnt, i, off;
+	uint32_t word0, word1, word2, word3;
+	uint32_t *ptr;
+	struct lpfc_pgp *pgpp;
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring *pring;
+
+	cnt = LPFC_DUMPSLIM_SIZE;
+	off = 0;
+	spin_lock_irq(&phba->hbalock);
+
+	len +=  snprintf(buf+len, size-len, "SLIM Mailbox\n");
+	ptr = (uint32_t *)phba->slim2p;
+	i = sizeof(MAILBOX_t);
+	while (i > 0) {
+		len +=  snprintf(buf+len, size-len,
+		"%08x: %08x %08x %08x %08x %08x %08x %08x %08x\n",
+		off, *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4),
+		*(ptr+5), *(ptr+6), *(ptr+7));
+		ptr += 8;
+		i -= (8 * sizeof(uint32_t));
+		off += (8 * sizeof(uint32_t));
+	}
+
+	len +=  snprintf(buf+len, size-len, "SLIM PCB\n");
+	ptr = (uint32_t *)&phba->slim2p->pcb;
+	i = sizeof(PCB_t);
+	while (i > 0) {
+		len +=  snprintf(buf+len, size-len,
+		"%08x: %08x %08x %08x %08x %08x %08x %08x %08x\n",
+		off, *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4),
+		*(ptr+5), *(ptr+6), *(ptr+7));
+		ptr += 8;
+		i -= (8 * sizeof(uint32_t));
+		off += (8 * sizeof(uint32_t));
+	}
+
+	pgpp = (struct lpfc_pgp *)&phba->slim2p->mbx.us.s3_pgp.port;
+	pring = &psli->ring[0];
+	len +=  snprintf(buf+len, size-len,
+		"Ring 0: CMD GetInx:%d (Max:%d Next:%d Local:%d flg:x%x)  "
+		"RSP PutInx:%d Max:%d\n",
+		pgpp->cmdGetInx, pring->numCiocb,
+		pring->next_cmdidx, pring->local_getidx, pring->flag,
+		pgpp->rspPutInx, pring->numRiocb);
+	pgpp++;
+
+	pring = &psli->ring[1];
+	len +=  snprintf(buf+len, size-len,
+		"Ring 1: CMD GetInx:%d (Max:%d Next:%d Local:%d flg:x%x)  "
+		"RSP PutInx:%d Max:%d\n",
+		pgpp->cmdGetInx, pring->numCiocb,
+		pring->next_cmdidx, pring->local_getidx, pring->flag,
+		pgpp->rspPutInx, pring->numRiocb);
+	pgpp++;
+
+	pring = &psli->ring[2];
+	len +=  snprintf(buf+len, size-len,
+		"Ring 2: CMD GetInx:%d (Max:%d Next:%d Local:%d flg:x%x)  "
+		"RSP PutInx:%d Max:%d\n",
+		pgpp->cmdGetInx, pring->numCiocb,
+		pring->next_cmdidx, pring->local_getidx, pring->flag,
+		pgpp->rspPutInx, pring->numRiocb);
+	pgpp++;
+
+	pring = &psli->ring[3];
+	len +=  snprintf(buf+len, size-len,
+		"Ring 3: CMD GetInx:%d (Max:%d Next:%d Local:%d flg:x%x)  "
+		"RSP PutInx:%d Max:%d\n",
+		pgpp->cmdGetInx, pring->numCiocb,
+		pring->next_cmdidx, pring->local_getidx, pring->flag,
+		pgpp->rspPutInx, pring->numRiocb);
+
+
+	ptr = (uint32_t *)&phba->slim2p->mbx.us.s3_pgp.hbq_get;
+	word0 = readl(phba->HAregaddr);
+	word1 = readl(phba->CAregaddr);
+	word2 = readl(phba->HSregaddr);
+	word3 = readl(phba->HCregaddr);
+	len +=  snprintf(buf+len, size-len, "HA:%08x CA:%08x HS:%08x HC:%08x\n",
+	word0, word1, word2, word3);
+	spin_unlock_irq(&phba->hbalock);
+	return len;
+}
+
+static int
 lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 {
 	int len = 0;
@@ -204,7 +347,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 		len +=  snprintf(buf+len, size-len, "RPI:%03d flag:x%08x ",
 			ndlp->nlp_rpi, ndlp->nlp_flag);
 		if (!ndlp->nlp_type)
-			len +=  snprintf(buf+len, size-len, "UNKNOWN_TYPE");
+			len +=  snprintf(buf+len, size-len, "UNKNOWN_TYPE ");
 		if (ndlp->nlp_type & NLP_FC_NODE)
 			len +=  snprintf(buf+len, size-len, "FC_NODE ");
 		if (ndlp->nlp_type & NLP_FABRIC)
@@ -213,7 +356,9 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 			len +=  snprintf(buf+len, size-len, "FCP_TGT sid:%d ",
 				ndlp->nlp_sid);
 		if (ndlp->nlp_type & NLP_FCP_INITIATOR)
-			len +=  snprintf(buf+len, size-len, "FCP_INITIATOR");
+			len +=  snprintf(buf+len, size-len, "FCP_INITIATOR ");
+		len += snprintf(buf+len, size-len, "refcnt:%x",
+			atomic_read(&ndlp->kref.refcount));
 		len +=  snprintf(buf+len, size-len, "\n");
 	}
 	spin_unlock_irq(shost->host_lock);
@@ -227,7 +372,7 @@ lpfc_debugfs_disc_trc(struct lpfc_vport 
 	uint32_t data1, uint32_t data2, uint32_t data3)
 {
 #ifdef CONFIG_LPFC_DEBUG_FS
-	struct lpfc_disc_trc *dtp;
+	struct lpfc_debugfs_trc *dtp;
 	int index;
 
 	if (!(lpfc_debugfs_mask_disc_trc & mask))
@@ -244,7 +389,32 @@ lpfc_debugfs_disc_trc(struct lpfc_vport 
 	dtp->data1 = data1;
 	dtp->data2 = data2;
 	dtp->data3 = data3;
-	dtp->seq_cnt = atomic_inc_return(&lpfc_debugfs_disc_trc_cnt);
+	dtp->seq_cnt = atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
+	dtp->jif = jiffies;
+#endif
+	return;
+}
+
+inline void
+lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
+	uint32_t data1, uint32_t data2, uint32_t data3)
+{
+#ifdef CONFIG_LPFC_DEBUG_FS
+	struct lpfc_debugfs_trc *dtp;
+	int index;
+
+	if (!lpfc_debugfs_enable || !lpfc_debugfs_max_slow_ring_trc ||
+		!phba || !phba->slow_ring_trc)
+		return;
+
+	index = atomic_inc_return(&phba->slow_ring_trc_cnt) &
+		(lpfc_debugfs_max_slow_ring_trc - 1);
+	dtp = phba->slow_ring_trc + index;
+	dtp->fmt = fmt;
+	dtp->data1 = data1;
+	dtp->data2 = data2;
+	dtp->data3 = data3;
+	dtp->seq_cnt = atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
 	dtp->jif = jiffies;
 #endif
 	return;
@@ -269,7 +439,7 @@ lpfc_debugfs_disc_trc_open(struct inode 
 		goto out;
 
 	/* Round to page boundry */
-	size =  (lpfc_debugfs_max_disc_trc * LPFC_DISC_TRC_ENTRY_SIZE);
+	size =  (lpfc_debugfs_max_disc_trc * LPFC_DEBUG_TRC_ENTRY_SIZE);
 	size = PAGE_ALIGN(size);
 
 	debug->buffer = kmalloc(size, GFP_KERNEL);
@@ -287,6 +457,68 @@ out:
 }
 
 static int
+lpfc_debugfs_slow_ring_trc_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_hba *phba = inode->i_private;
+	struct lpfc_debug *debug;
+	int size;
+	int rc = -ENOMEM;
+
+	if (!lpfc_debugfs_max_slow_ring_trc) {
+		 rc = -ENOSPC;
+		goto out;
+	}
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	/* Round to page boundry */
+	size =  (lpfc_debugfs_max_slow_ring_trc * LPFC_DEBUG_TRC_ENTRY_SIZE);
+	size = PAGE_ALIGN(size);
+
+	debug->buffer = kmalloc(size, GFP_KERNEL);
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->len = lpfc_debugfs_slow_ring_trc_data(phba, debug->buffer, size);
+	file->private_data = debug;
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static int
+lpfc_debugfs_dumpslim_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_hba *phba = inode->i_private;
+	struct lpfc_debug *debug;
+	int rc = -ENOMEM;
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	/* Round to page boundry */
+	debug->buffer = kmalloc(LPFC_DUMPSLIM_SIZE, GFP_KERNEL);
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->len = lpfc_debugfs_dumpslim_data(phba, debug->buffer,
+		LPFC_DUMPSLIM_SIZE);
+	file->private_data = debug;
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static int
 lpfc_debugfs_nodelist_open(struct inode *inode, struct file *file)
 {
 	struct lpfc_vport *vport = inode->i_private;
@@ -372,6 +604,24 @@ static struct file_operations lpfc_debug
 	.release =      lpfc_debugfs_release,
 };
 
+#undef lpfc_debugfs_op_dumpslim
+static struct file_operations lpfc_debugfs_op_dumpslim = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_dumpslim_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.release =      lpfc_debugfs_release,
+};
+
+#undef lpfc_debugfs_op_slow_ring_trc
+static struct file_operations lpfc_debugfs_op_slow_ring_trc = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_slow_ring_trc_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.release =      lpfc_debugfs_release,
+};
+
 static struct dentry *lpfc_debugfs_root = NULL;
 static atomic_t lpfc_debugfs_hba_count;
 #endif
@@ -387,60 +637,142 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 	if (!lpfc_debugfs_enable)
 		return;
 
-	if (lpfc_debugfs_max_disc_trc) {
-		num = lpfc_debugfs_max_disc_trc - 1;
-		if (num & lpfc_debugfs_max_disc_trc) {
-			/* Change to be a power of 2 */
-			num = lpfc_debugfs_max_disc_trc;
-			i = 0;
-			while (num > 1) {
-				num = num >> 1;
-				i++;
-			}
-			lpfc_debugfs_max_disc_trc = (1 << i);
-			printk(KERN_ERR
-				"lpfc_debugfs_max_disc_trc changed to %d\n",
-				lpfc_debugfs_max_disc_trc);
-		}
-	}
-
+	/* Setup lpfc root directory */
 	if (!lpfc_debugfs_root) {
 		lpfc_debugfs_root = debugfs_create_dir("lpfc", NULL);
 		atomic_set(&lpfc_debugfs_hba_count, 0);
-		if (!lpfc_debugfs_root)
+		if (!lpfc_debugfs_root) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"%d:0409 Cannot create debugfs root (lpfc)",
+				phba->brd_no);
 			goto debug_failed;
+		}
 	}
 
+	if (!lpfc_debugfs_start_time)
+		lpfc_debugfs_start_time = jiffies;
+
+	/* Setup lpfcX directory for specific HBA */
 	snprintf(name, sizeof(name), "lpfc%d", phba->brd_no);
 	if (!phba->hba_debugfs_root) {
 		phba->hba_debugfs_root =
 			debugfs_create_dir(name, lpfc_debugfs_root);
-		if (!phba->hba_debugfs_root)
+		if (!phba->hba_debugfs_root) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"%d:0409 Cannot create debugfs hba (lpfc%d)",
+				phba->brd_no, phba->brd_no);
 			goto debug_failed;
+		}
 		atomic_inc(&lpfc_debugfs_hba_count);
 		atomic_set(&phba->debugfs_vport_count, 0);
+
+		/* Setup dumpslim */
+		snprintf(name, sizeof(name), "dumpslim");
+		phba->debug_dumpslim =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				 phba->hba_debugfs_root,
+				 phba, &lpfc_debugfs_op_dumpslim);
+		if (!phba->debug_dumpslim) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"%d:0409 Cannot create debugfs dumpslim (lpfc%d)",
+				phba->brd_no, phba->brd_no);
+			goto debug_failed;
+		}
+
+		/* Setup slow ring trace */
+		if (lpfc_debugfs_max_slow_ring_trc) {
+			num = lpfc_debugfs_max_slow_ring_trc - 1;
+			if (num & lpfc_debugfs_max_slow_ring_trc) {
+				/* Change to be a power of 2 */
+				num = lpfc_debugfs_max_slow_ring_trc;
+				i = 0;
+				while (num > 1) {
+					num = num >> 1;
+					i++;
+				}
+				lpfc_debugfs_max_slow_ring_trc = (1 << i);
+				printk(KERN_ERR
+				"lpfc_debugfs_max_slow_ring_trc change to %d\n",
+					lpfc_debugfs_max_slow_ring_trc);
+			}
+		}
+
+
+		snprintf(name, sizeof(name), "slow_ring_trace");
+		phba->debug_slow_ring_trc =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				 phba->hba_debugfs_root,
+				 phba, &lpfc_debugfs_op_slow_ring_trc);
+		if (!phba->debug_slow_ring_trc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"%d:0409 Cannot create debugfs "
+				"slow_ring_trace (lpfc%d)",
+				phba->brd_no, phba->brd_no);
+			goto debug_failed;
+		}
+		if (!phba->slow_ring_trc) {
+			phba->slow_ring_trc = kmalloc(
+				(sizeof(struct lpfc_debugfs_trc) *
+				lpfc_debugfs_max_slow_ring_trc),
+				GFP_KERNEL);
+			if (!phba->slow_ring_trc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"%d:0409 Cannot create debugfs "
+				"slow_ring buffer (lpfc%d)",
+				phba->brd_no, phba->brd_no);
+				goto debug_failed;
+			}
+			atomic_set(&phba->slow_ring_trc_cnt, 0);
+			memset(phba->slow_ring_trc, 0,
+				(sizeof(struct lpfc_debugfs_trc) *
+				lpfc_debugfs_max_slow_ring_trc));
+		}
 	}
 
 	snprintf(name, sizeof(name), "vport%d", vport->vpi);
 	if (!vport->vport_debugfs_root) {
 		vport->vport_debugfs_root =
 			debugfs_create_dir(name, phba->hba_debugfs_root);
-		if (!vport->vport_debugfs_root)
+		if (!vport->vport_debugfs_root) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"%d:0409 Cant create debugfs vport%d (lpfc%d)",
+				phba->brd_no, vport->vpi, phba->brd_no);
 			goto debug_failed;
+		}
 		atomic_inc(&phba->debugfs_vport_count);
 	}
 
-	if (!lpfc_debugfs_start_time)
-		lpfc_debugfs_start_time = jiffies;
+	if (lpfc_debugfs_max_disc_trc) {
+		num = lpfc_debugfs_max_disc_trc - 1;
+		if (num & lpfc_debugfs_max_disc_trc) {
+			/* Change to be a power of 2 */
+			num = lpfc_debugfs_max_disc_trc;
+			i = 0;
+			while (num > 1) {
+				num = num >> 1;
+				i++;
+			}
+			lpfc_debugfs_max_disc_trc = (1 << i);
+			printk(KERN_ERR
+				"lpfc_debugfs_max_disc_trc changed to %d\n",
+				lpfc_debugfs_max_disc_trc);
+		}
+	}
 
 	vport->disc_trc = kmalloc(
-		(sizeof(struct lpfc_disc_trc) * lpfc_debugfs_max_disc_trc),
+		(sizeof(struct lpfc_debugfs_trc) * lpfc_debugfs_max_disc_trc),
 		GFP_KERNEL);
 
-	if (!vport->disc_trc)
+	if (!vport->disc_trc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"%d:0409 Cannot create debugfs "
+			"vport%d disc trace buffer (lpfc%d)",
+			phba->brd_no, vport->vpi, phba->brd_no);
 		goto debug_failed;
+	}
+	atomic_set(&vport->disc_trc_cnt, 0);
 	memset(vport->disc_trc, 0,
-		(sizeof(struct lpfc_disc_trc) * lpfc_debugfs_max_disc_trc));
+		(sizeof(struct lpfc_debugfs_trc) * lpfc_debugfs_max_disc_trc));
 
 	snprintf(name, sizeof(name), "discovery_trace");
 	vport->debug_disc_trc =
@@ -449,8 +781,9 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				 vport, &lpfc_debugfs_op_disc_trc);
 	if (!vport->debug_disc_trc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"%d:0409 Cannot create debugfs",
-				phba->brd_no);
+			"%d:0409 Cannot create debugfs "
+			"vport%d discovery_trace (lpfc%d)",
+			phba->brd_no, vport->vpi, phba->brd_no);
 		goto debug_failed;
 	}
 	snprintf(name, sizeof(name), "nodelist");
@@ -460,8 +793,8 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				 vport, &lpfc_debugfs_op_nodelist);
 	if (!vport->debug_nodelist) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"%d:0409 Cannot create debugfs",
-				phba->brd_no);
+			"%d:0409 Cant create debugfs vport%d nodelist (lpfc%d)",
+			phba->brd_no, vport->vpi, phba->brd_no);
 		goto debug_failed;
 	}
 debug_failed:
@@ -488,21 +821,41 @@ lpfc_debugfs_terminate(struct lpfc_vport
 		debugfs_remove(vport->debug_nodelist); /* nodelist */
 		vport->debug_nodelist = NULL;
 	}
+
 	if (vport->vport_debugfs_root) {
 		debugfs_remove(vport->vport_debugfs_root); /* vportX */
 		vport->vport_debugfs_root = NULL;
 		atomic_dec(&phba->debugfs_vport_count);
 	}
 	if (atomic_read(&phba->debugfs_vport_count) == 0) {
-		debugfs_remove(vport->phba->hba_debugfs_root); /* lpfcX */
-		vport->phba->hba_debugfs_root = NULL;
-		atomic_dec(&lpfc_debugfs_hba_count);
+
+		if (phba->debug_dumpslim) {
+			debugfs_remove(phba->debug_dumpslim); /* dumpslim */
+			phba->debug_dumpslim = NULL;
+		}
+		if (phba->slow_ring_trc) {
+			kfree(phba->slow_ring_trc);
+			phba->slow_ring_trc = NULL;
+		}
+		if (phba->debug_slow_ring_trc) {
+			/* slow_ring_trace */
+			debugfs_remove(phba->debug_slow_ring_trc);
+			phba->debug_slow_ring_trc = NULL;
+		}
+
+		if (phba->hba_debugfs_root) {
+			debugfs_remove(phba->hba_debugfs_root); /* lpfcX */
+			phba->hba_debugfs_root = NULL;
+			atomic_dec(&lpfc_debugfs_hba_count);
+		}
+
 		if (atomic_read(&lpfc_debugfs_hba_count) == 0) {
 			debugfs_remove(lpfc_debugfs_root); /* lpfc */
 			lpfc_debugfs_root = NULL;
 		}
 	}
 #endif
+	return;
 }
 

diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
--- a/drivers/scsi/lpfc/lpfc_debugfs.h	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h	2007-08-02 09:18:14.000000000 -0400
@@ -22,7 +22,7 @@
 #define _H_LPFC_DEBUG_FS
 
 #ifdef CONFIG_LPFC_DEBUG_FS
-struct lpfc_disc_trc {
+struct lpfc_debugfs_trc {
 	char *fmt;
 	uint32_t data1;
 	uint32_t data2;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-08-02 09:18:14.000000000 -0400
@@ -2033,12 +2033,11 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 	}
 
 	/* No retry ELS command <elsCmd> to remote NPORT <did> */
-	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"%d (%d):0108 No retry ELS command x%x to remote "
-			"NPORT x%x Data: x%x\n",
-			phba->brd_no, vport->vpi,
-			cmd, did, cmdiocb->retry);
-
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+			 "0108 No retry ELS command x%x to remote "
+			 "NPORT x%x Retried:%d Error:x%x/%x\n",
+			 cmd, did, cmdiocb->retry, irsp->ulpStatus,
+			 irsp->un.ulpWord[4]);
 	return 0;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-08-02 09:18:14.000000000 -0400
@@ -335,7 +335,7 @@ struct lpfc_vport {
 	struct dentry *debug_disc_trc;
 	struct dentry *debug_nodelist;
 	struct dentry *vport_debugfs_root;
-	struct lpfc_disc_trc *disc_trc;
+	struct lpfc_debugfs_trc *disc_trc;
 	atomic_t disc_trc_cnt;
 #endif
 };
@@ -547,6 +547,10 @@ struct lpfc_hba {
 #ifdef CONFIG_LPFC_DEBUG_FS
 	struct dentry *hba_debugfs_root;
 	atomic_t debugfs_vport_count;
+	struct dentry *debug_dumpslim;
+	struct dentry *debug_slow_ring_trc;
+	struct lpfc_debugfs_trc *slow_ring_trc;
+	atomic_t slow_ring_trc_cnt;
 #endif
 
 	/* Fields used for heart beat. */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 09:18:14.000000000 -0400
@@ -426,10 +426,19 @@ lpfc_work_done(struct lpfc_hba *phba)
 		spin_lock_irq(&phba->hbalock);
 		control = readl(phba->HCregaddr);
 		if (!(control & (HC_R0INT_ENA << LPFC_ELS_RING))) {
+			lpfc_debugfs_slow_ring_trc(phba,
+				"WRK Enable ring: cntl:x%x hacopy:x%x",
+				control, ha_copy, 0);
+
 			control |= (HC_R0INT_ENA << LPFC_ELS_RING);
 			writel(control, phba->HCregaddr);
 			readl(phba->HCregaddr); /* flush */
 		}
+		else {
+			lpfc_debugfs_slow_ring_trc(phba,
+				"WRK Ring ok:     cntl:x%x hacopy:x%x",
+				control, ha_copy, 0);
+		}
 		spin_unlock_irq(&phba->hbalock);
 	}
 	lpfc_work_list_done(phba);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-08-02 09:18:14.000000000 -0400
@@ -395,6 +395,14 @@ lpfc_sli_submit_iocb(struct lpfc_hba *ph
 	 */
 	nextiocb->iocb.ulpIoTag = (nextiocb->iocb_cmpl) ? nextiocb->iotag : 0;
 
+	if (pring->ringno == LPFC_ELS_RING) {
+		lpfc_debugfs_slow_ring_trc(phba,
+			"IOCB cmd ring:   wd4:x%08x wd6:x%08x wd7:x%08x",
+			*(((uint32_t *) &nextiocb->iocb) + 4),
+			*(((uint32_t *) &nextiocb->iocb) + 6),
+			*(((uint32_t *) &nextiocb->iocb) + 7));
+	}
+
 	/*
 	 * Issue iocb command to adapter
 	 */
@@ -1542,6 +1550,14 @@ lpfc_sli_handle_slow_ring_event(struct l
 		if (++pring->rspidx >= portRspMax)
 			pring->rspidx = 0;
 
+		if (pring->ringno == LPFC_ELS_RING) {
+			lpfc_debugfs_slow_ring_trc(phba,
+			"IOCB rsp ring:   wd4:x%08x wd6:x%08x wd7:x%08x",
+				*(((uint32_t *) irsp) + 4),
+				*(((uint32_t *) irsp) + 6),
+				*(((uint32_t *) irsp) + 7));
+		}
+
 		writel(pring->rspidx, &phba->host_gp[pring->ringno].rspGetInx);
 
 		if (list_empty(&(pring->iocb_continueq))) {
@@ -3850,12 +3866,33 @@ lpfc_intr_handler(int irq, void *dev_id)
 			if (status & HA_RXMASK) {
 				spin_lock(&phba->hbalock);
 				control = readl(phba->HCregaddr);
+
+				lpfc_debugfs_slow_ring_trc(phba,
+				"ISR slow ring:   ctl:x%x stat:x%x isrcnt:x%x",
+				control, status,
+				(uint32_t)phba->sli.slistat.sli_intr);
+
 				if (control & (HC_R0INT_ENA << LPFC_ELS_RING)) {
+					lpfc_debugfs_slow_ring_trc(phba,
+						"ISR Disable ring:"
+						"pwork:x%x hawork:x%x wait:x%x",
+						phba->work_ha, work_ha_copy,
+						(uint32_t)((unsigned long)
+						phba->work_wait));
+
 					control &=
 					    ~(HC_R0INT_ENA << LPFC_ELS_RING);
 					writel(control, phba->HCregaddr);
 					readl(phba->HCregaddr); /* flush */
 				}
+				else {
+					lpfc_debugfs_slow_ring_trc(phba,
+						"ISR slow ring:   pwork:"
+						"x%x hawork:x%x wait:x%x",
+						phba->work_ha, work_ha_copy,
+						(uint32_t)((unsigned long)
+						phba->work_wait));
+				}
 				spin_unlock(&phba->hbalock);
 			}
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 09:18:14.000000000 -0400
@@ -326,6 +326,8 @@ lpfc_vport_create(struct fc_vport *fc_vp
 	rc = VPORT_OK;
 
 out:
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
+			"1825 Vport Created.\n");
 	lpfc_host_attrib_init(lpfc_shost_from_vport(vport));
 error_out:
 	return rc;
@@ -371,6 +373,8 @@ disable_vport(struct fc_vport *fc_vport)
 	lpfc_mbx_unreg_vpi(vport);
 
 	lpfc_vport_set_state(vport, FC_VPORT_DISABLED);
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
+			 "1826 Vport Disabled.\n");
 	return VPORT_OK;
 }
 
@@ -408,7 +412,8 @@ enable_vport(struct fc_vport *fc_vport)
 	} else {
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	}
-
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
+			 "1827 Vport Enabled.\n");
 	return VPORT_OK;
 }
 
@@ -511,7 +516,8 @@ skip_logo:
 	spin_lock_irq(&phba->hbalock);
 	list_del_init(&vport->listentry);
 	spin_unlock_irq(&phba->hbalock);
-
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
+			 "1828 Vport Deleted.\n");
 	rc = VPORT_OK;
 out:
 	scsi_host_put(shost);


