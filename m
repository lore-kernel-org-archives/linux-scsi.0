From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH v2 2/2] message: fusion: Replace NULL comparison
Date: Thu,  7 Jun 2018 09:19:02 +0530
Message-ID: <32f62942e8803ea1c9f1389c3784bfcf8962584d.1528342739.git.rvarsha016@gmail.com>
References: <cover.1528342739.git.rvarsha016@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1528342739.git.rvarsha016@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Replace x == NULL with !x, to fix checkpatch issue. This patch also
fixes line over 80 characters warning.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
Following coccinelle script is used to fix the warnings.

@disable is_null@
expression e;
@@
- e == NULL
+!e

Changes in v2:
- Removed coccinelle script from commit message.
- Fixed line over 80 characters warning.

 drivers/message/fusion/mptbase.c | 46 ++++++++++++++++----------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5b98b7fca0f2..8af294619d92 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -488,7 +488,7 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)
 
 	/*  Check for (valid) IO callback!  */
 	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
-		MptCallbacks[cb_idx] == NULL) {
+		!MptCallbacks[cb_idx]) {
 		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",
 				__func__, ioc->name, cb_idx);
 		goto out;
@@ -552,7 +552,7 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 
 	/*  Check for (valid) IO callback!  */
 	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
-		MptCallbacks[cb_idx] == NULL) {
+		!MptCallbacks[cb_idx]) {
 		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",
 				__func__, ioc->name, cb_idx);
 		freeme = 0;
@@ -707,7 +707,7 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass, char *func_name)
 	 *  (slot/handle 0 is reserved!)
 	 */
 	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
-		if (MptCallbacks[cb_idx] == NULL) {
+		if (!MptCallbacks[cb_idx]) {
 			MptCallbacks[cb_idx] = cbfunc;
 			MptDriverClass[cb_idx] = dclass;
 			MptEvHandlers[cb_idx] = NULL;
@@ -928,7 +928,7 @@ mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc)
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 #ifdef MFCNT
-	if (mf == NULL)
+	if (!mf)
 		printk(MYIOC_s_WARN_FMT "IOC Active. No free Msg Frames! "
 		    "Count 0x%x Max 0x%x\n", ioc->name, ioc->mfcnt,
 		    ioc->req_depth);
@@ -1723,7 +1723,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	/* Get logical ptr for PciMem0 space */
 	/*mem = ioremap(mem_phys, msize);*/
 	mem = ioremap(mem_phys, msize);
-	if (mem == NULL) {
+	if (!mem) {
 		printk(MYIOC_s_ERR_FMT ": ERROR - Unable to map adapter"
 			" memory!\n", ioc->name);
 		r = -EINVAL;
@@ -1780,7 +1780,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 #endif
 
 	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
-	if (ioc == NULL) {
+	if (!ioc) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 		return -ENOMEM;
 	}
@@ -2821,7 +2821,7 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 {
 	int sz_first, sz_last;
 
-	if (ioc == NULL)
+	if (!ioc)
 		return;
 
 	sz_first = ioc->alloc_total;
@@ -4328,17 +4328,17 @@ initChainBuffers(MPT_ADAPTER *ioc)
 	/* ReqToChain size must equal the req_depth
 	 * index = req_idx
 	 */
-	if (ioc->ReqToChain == NULL) {
+	if (!ioc->ReqToChain) {
 		sz = ioc->req_depth * sizeof(int);
 		mem = kmalloc(sz, GFP_ATOMIC);
-		if (mem == NULL)
+		if (!mem)
 			return -1;
 
 		ioc->ReqToChain = (int *) mem;
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReqToChain alloc  @ %p, sz=%d bytes\n",
 			 	ioc->name, mem, sz));
 		mem = kmalloc(sz, GFP_ATOMIC);
-		if (mem == NULL)
+		if (!mem)
 			return -1;
 
 		ioc->RequestNB = (int *) mem;
@@ -4403,9 +4403,9 @@ initChainBuffers(MPT_ADAPTER *ioc)
 	ioc->num_chain = num_chain;
 
 	sz = num_chain * sizeof(int);
-	if (ioc->ChainToChain == NULL) {
+	if (!ioc->ChainToChain) {
 		mem = kmalloc(sz, GFP_ATOMIC);
-		if (mem == NULL)
+		if (!mem)
 			return -1;
 
 		ioc->ChainToChain = (int *) mem;
@@ -4443,7 +4443,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 
 	/*  Prime reply FIFO...  */
 
-	if (ioc->reply_frames == NULL) {
+	if (!ioc->reply_frames) {
 		if ( (num_chain = initChainBuffers(ioc)) < 0)
 			return -1;
 		/*
@@ -4495,7 +4495,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 
 		total_size += sz;
 		mem = pci_alloc_consistent(ioc->pcidev, total_size, &alloc_dma);
-		if (mem == NULL) {
+		if (!mem) {
 			printk(MYIOC_s_ERR_FMT "Unable to allocate Reply, Request, Chain Buffers!\n",
 				ioc->name);
 			goto out_fail;
@@ -4573,7 +4573,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		sz = (ioc->req_depth * MPT_SENSE_BUFFER_ALLOC);
 		ioc->sense_buf_pool =
 			pci_alloc_consistent(ioc->pcidev, sz, &ioc->sense_buf_pool_dma);
-		if (ioc->sense_buf_pool == NULL) {
+		if (!ioc->sense_buf_pool) {
 			printk(MYIOC_s_ERR_FMT "Unable to allocate Sense Buffers!\n",
 				ioc->name);
 			goto out_fail;
@@ -5092,7 +5092,7 @@ mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
 
 	/* Get a MF for this command.
 	 */
-	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
+	if (!(mf = mpt_get_msg_frame(mpt_base_index, ioc))) {
 		printk(KERN_DEBUG "%s: no msg frames!\n", __func__);
 		ret = -1;
 		goto out;
@@ -5372,7 +5372,7 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
 		u8	*mem;
 		sz = MPT_MAX_SCSI_DEVICES * sizeof(int);
 		mem = kmalloc(sz, GFP_ATOMIC);
-		if (mem == NULL)
+		if (!mem)
 			return -EFAULT;
 
 		ioc->spi_data.nvram = (int *) mem;
@@ -5692,8 +5692,8 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
 		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
 			continue;
 
-		if ((component_info = kmalloc(sizeof (*component_info),
-		 GFP_KERNEL)) == NULL)
+		component_info = kmalloc(sizeof(*component_info), GFP_KERNEL);
+		if (!component_info)
 			continue;
 
 		component_info->volumeID = id;
@@ -6106,7 +6106,7 @@ mpt_read_ioc_pg_4(MPT_ADAPTER *ioc)
 	if (header.PageLength == 0)
 		return;
 
-	if ( (pIoc4 = ioc->spi_data.pIocPg4) == NULL ) {
+	if (!(pIoc4 = ioc->spi_data.pIocPg4)) {
 		iocpage4sz = (header.PageLength + 4) * 4; /* Allow 4 additional SEP's */
 		pIoc4 = pci_alloc_consistent(ioc->pcidev, iocpage4sz, &ioc4_dma);
 		if (!pIoc4)
@@ -6302,7 +6302,7 @@ SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp)
 {
 	EventAck_t	*pAck;
 
-	if ((pAck = (EventAck_t *) mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
+	if (!(pAck = (EventAck_t *)mpt_get_msg_frame(mpt_base_index, ioc))) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
 		    ioc->name, __func__));
 		return -1;
@@ -6393,7 +6393,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 
 	/* Get and Populate a free Frame
 	 */
-	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
+	if (!(mf = mpt_get_msg_frame(mpt_base_index, ioc))) {
 		dcprintk(ioc, printk(MYIOC_s_WARN_FMT
 		"mpt_config: no msg frames!\n", ioc->name));
 		ret = -EAGAIN;
@@ -6605,7 +6605,7 @@ static int
 procmpt_create(void)
 {
 	mpt_proc_root_dir = proc_mkdir(MPT_PROCFS_MPTBASEDIR, NULL);
-	if (mpt_proc_root_dir == NULL)
+	if (!mpt_proc_root_dir)
 		return -ENOTDIR;
 
 	proc_create_single("summary", S_IRUGO, mpt_proc_root_dir,
-- 
2.17.0
