From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/15] lpfc 8.2.8 : Add kernel-doc function headers - part 5
Date: Sun, 24 Aug 2008 21:49:40 -0400
Message-ID: <1219628981.7890.29.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52453 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbYHYBtj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:49:39 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1ncHQ019942
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:49:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add kernel-doc function headers - part 5


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c | 1063 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 1027 insertions(+), 36 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-07-30 13:05:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 18:50:21.000000000 -0400
@@ -66,10 +66,16 @@ typedef enum _lpfc_iocb_type {
 	LPFC_ABORT_IOCB
 } lpfc_iocb_type;
 
-		/* SLI-2/SLI-3 provide different sized iocbs.  Given a pointer
-		 * to the start of the ring, and the slot number of the
-		 * desired iocb entry, calc a pointer to that entry.
-		 */
+/**
+ * lpfc_cmd_iocb: Get next command iocb entry in the ring.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function returns pointer to next command iocb entry
+ * in the command ring. The caller must hold hbalock to prevent
+ * other threads consume the next command iocb.
+ * SLI-2/SLI-3 provide different sized iocbs.
+ **/
 static inline IOCB_t *
 lpfc_cmd_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
@@ -77,6 +83,16 @@ lpfc_cmd_iocb(struct lpfc_hba *phba, str
 			   pring->cmdidx * phba->iocb_cmd_size);
 }
 
+/**
+ * lpfc_resp_iocb: Get next response iocb entry in the ring.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function returns pointer to next response iocb entry
+ * in the response ring. The caller must hold hbalock to make sure
+ * that no other thread consume the next response iocb.
+ * SLI-2/SLI-3 provide different sized iocbs.
+ **/
 static inline IOCB_t *
 lpfc_resp_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
@@ -84,6 +100,15 @@ lpfc_resp_iocb(struct lpfc_hba *phba, st
 			   pring->rspidx * phba->iocb_rsp_size);
 }
 
+/**
+ * __lpfc_sli_get_iocbq: Allocates an iocb object from iocb pool.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called with hbalock held. This function
+ * allocates a new driver iocb object from the iocb pool. If the
+ * allocation is successful, it returns pointer to the newly
+ * allocated iocb object else it returns NULL.
+ **/
 static struct lpfc_iocbq *
 __lpfc_sli_get_iocbq(struct lpfc_hba *phba)
 {
@@ -94,6 +119,15 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *ph
 	return iocbq;
 }
 
+/**
+ * lpfc_sli_get_iocbq: Allocates an iocb object from iocb pool.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called with no lock held. This function
+ * allocates a new driver iocb object from the iocb pool. If the
+ * allocation is successful, it returns pointer to the newly
+ * allocated iocb object else it returns NULL.
+ **/
 struct lpfc_iocbq *
 lpfc_sli_get_iocbq(struct lpfc_hba *phba)
 {
@@ -106,6 +140,16 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba
 	return iocbq;
 }
 
+/**
+ * __lpfc_sli_release_iocbq: Release iocb to the iocb pool.
+ * @phba: Pointer to HBA context object.
+ * @iocbq: Pointer to driver iocb object.
+ *
+ * This function is called with hbalock held to release driver
+ * iocb object to the iocb pool. The iotag in the iocb object
+ * does not change for each use of the iocb object. This function
+ * clears all other fields of the iocb object when it is freed.
+ **/
 static void
 __lpfc_sli_release_iocbq(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
@@ -118,6 +162,14 @@ __lpfc_sli_release_iocbq(struct lpfc_hba
 	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
 }
 
+/**
+ * lpfc_sli_release_iocbq: Release iocb to the iocb pool.
+ * @phba: Pointer to HBA context object.
+ * @iocbq: Pointer to driver iocb object.
+ *
+ * This function is called with no lock held to release the iocb to
+ * iocb pool.
+ **/
 void
 lpfc_sli_release_iocbq(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
@@ -131,10 +183,21 @@ lpfc_sli_release_iocbq(struct lpfc_hba *
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 }
 
-/*
- * Translate the iocb command to an iocb command type used to decide the final
- * disposition of each completed IOCB.
- */
+/**
+ * lpfc_sli_iocb_cmd_type: Get the iocb type.
+ * @iocb_cmnd : iocb command code.
+ *
+ * This function is called by ring event handler function to get the iocb type.
+ * This function translates the iocb command to an iocb command type used to
+ * decide the final disposition of each completed IOCB.
+ * The function returns
+ * LPFC_UNKNOWN_IOCB if it is an unsupported iocb
+ * LPFC_SOL_IOCB     if it is a solicited iocb completion
+ * LPFC_ABORT_IOCB   if it is an abort iocb
+ * LPFC_UNSOL_IOCB   if it is an unsolicited iocb
+ *
+ * The caller is not required to hold any lock.
+ **/
 static lpfc_iocb_type
 lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd)
 {
@@ -230,6 +293,17 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 	return type;
 }
 
+/**
+ * lpfc_sli_ring_map: Issue config_ring mbox for all rings.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called from SLI initialization code
+ * to configure every ring of the HBA's SLI interface. The
+ * caller is not required to hold any lock. This function issues
+ * a config_ring mailbox command for each ring.
+ * This function returns zero if successful else returns a negative
+ * error code.
+ **/
 static int
 lpfc_sli_ring_map(struct lpfc_hba *phba)
 {
@@ -262,6 +336,18 @@ lpfc_sli_ring_map(struct lpfc_hba *phba)
 	return ret;
 }
 
+/**
+ * lpfc_sli_ringtxcmpl_put: Adds new iocb to the txcmplq.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @piocb: Pointer to the driver iocb object.
+ *
+ * This function is called with hbalock held. The function adds the
+ * new iocb to txcmplq of the given ring. This function always returns
+ * 0. If this function is called for ELS ring, this function checks if
+ * there is a vport associated with the ELS command. This function also
+ * starts els_tmofunc timer if this is an ELS command.
+ **/
 static int
 lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			struct lpfc_iocbq *piocb)
@@ -282,6 +368,16 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba 
 	return 0;
 }
 
+/**
+ * lpfc_sli_ringtx_get: Get first element of the txq.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function is called with hbalock held to get next
+ * iocb in txq of the given ring. If there is any iocb in
+ * the txq, the function returns first iocb in the list after
+ * removing the iocb from the list, else it returns NULL.
+ **/
 static struct lpfc_iocbq *
 lpfc_sli_ringtx_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
@@ -293,6 +389,20 @@ lpfc_sli_ringtx_get(struct lpfc_hba *phb
 	return cmd_iocb;
 }
 
+/**
+ * lpfc_sli_next_iocb_slot: Get next iocb slot in the ring.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function is called with hbalock held and the caller must post the
+ * iocb without releasing the lock. If the caller releases the lock,
+ * iocb slot returned by the function is not guaranteed to be available.
+ * The function returns pointer to the next available iocb slot if there
+ * is available slot in the ring, else it returns NULL.
+ * If the get index of the ring is ahead of the put index, the function
+ * will post an error attention event to the worker thread to take the
+ * HBA to offline state.
+ **/
 static IOCB_t *
 lpfc_sli_next_iocb_slot (struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
@@ -336,6 +446,18 @@ lpfc_sli_next_iocb_slot (struct lpfc_hba
 	return lpfc_cmd_iocb(phba, pring);
 }
 
+/**
+ * lpfc_sli_next_iotag: Get an iotag for the iocb.
+ * @phba: Pointer to HBA context object.
+ * @iocbq: Pointer to driver iocb object.
+ *
+ * This function gets an iotag for the iocb. If there is no unused iotag and
+ * the iocbq_lookup_len < 0xffff, this function allocates a bigger iotag_lookup
+ * array and assigns a new iotag.
+ * The function returns the allocated iotag if successful, else returns zero.
+ * Zero is not a valid iotag.
+ * The caller is not required to hold any lock.
+ **/
 uint16_t
 lpfc_sli_next_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
@@ -399,6 +521,20 @@ lpfc_sli_next_iotag(struct lpfc_hba *phb
 	return 0;
 }
 
+/**
+ * lpfc_sli_submit_iocb: Submit an iocb to the firmware.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @iocb: Pointer to iocb slot in the ring.
+ * @nextiocb: Pointer to driver iocb object which need to be
+ *            posted to firmware.
+ *
+ * This function is called with hbalock held to post a new iocb to
+ * the firmware. This function copies the new iocb to ring iocb slot and
+ * updates the ring pointers. It adds the new iocb to txcmplq if there is
+ * a completion call back for this iocb else the function will free the
+ * iocb object.
+ **/
 static void
 lpfc_sli_submit_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		IOCB_t *iocb, struct lpfc_iocbq *nextiocb)
@@ -441,6 +577,18 @@ lpfc_sli_submit_iocb(struct lpfc_hba *ph
 	writel(pring->cmdidx, &phba->host_gp[pring->ringno].cmdPutInx);
 }
 
+/**
+ * lpfc_sli_update_full_ring: Update the chip attention register.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * The caller is not required to hold any lock for calling this function.
+ * This function updates the chip attention bits for the ring to inform firmware
+ * that there are pending work to be done for this ring and requests an
+ * interrupt when there is space available in the ring. This function is
+ * called when the driver is unable to post more iocbs to the ring due
+ * to unavailability of space in the ring.
+ **/
 static void
 lpfc_sli_update_full_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
@@ -460,6 +608,15 @@ lpfc_sli_update_full_ring(struct lpfc_hb
 	pring->stats.iocb_cmd_full++;
 }
 
+/**
+ * lpfc_sli_update_ring: Update chip attention register.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function updates the chip attention register bit for the
+ * given ring to inform HBA that there is more work to be done
+ * in this ring. The caller is not required to hold any lock.
+ **/
 static void
 lpfc_sli_update_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
@@ -473,6 +630,15 @@ lpfc_sli_update_ring(struct lpfc_hba *ph
 	readl(phba->CAregaddr); /* flush */
 }
 
+/**
+ * lpfc_sli_resume_iocb: Process iocbs in the txq.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function is called with hbalock held to post pending iocbs
+ * in the txq to the firmware. This function is called when driver
+ * detects space available in the ring.
+ **/
 static void
 lpfc_sli_resume_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
@@ -504,6 +670,16 @@ lpfc_sli_resume_iocb(struct lpfc_hba *ph
 	return;
 }
 
+/**
+ * lpfc_sli_next_hbq_slot: Get next hbq entry for the HBQ.
+ * @phba: Pointer to HBA context object.
+ * @hbqno: HBQ number.
+ *
+ * This function is called with hbalock held to get the next
+ * available slot for the given HBQ. If there is free slot
+ * available for the HBQ it will return pointer to the next available
+ * HBQ entry else it will return NULL.
+ **/
 static struct lpfc_hbq_entry *
 lpfc_sli_next_hbq_slot(struct lpfc_hba *phba, uint32_t hbqno)
 {
@@ -539,6 +715,15 @@ lpfc_sli_next_hbq_slot(struct lpfc_hba *
 			hbqp->hbqPutIdx;
 }
 
+/**
+ * lpfc_sli_hbqbuf_free_all: Free all the hbq buffers.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called with no lock held to free all the
+ * hbq buffers while uninitializing the SLI interface. It also
+ * frees the HBQ buffers returned by the firmware but not yet
+ * processed by the upper layers.
+ **/
 void
 lpfc_sli_hbqbuf_free_all(struct lpfc_hba *phba)
 {
@@ -584,6 +769,18 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 }
 
+/**
+ * lpfc_sli_hbq_to_firmware: Post the hbq buffer to firmware.
+ * @phba: Pointer to HBA context object.
+ * @hbqno: HBQ number.
+ * @hbq_buf: Pointer to HBQ buffer.
+ *
+ * This function is called with the hbalock held to post a
+ * hbq buffer to the firmware. If the function finds an empty
+ * slot in the HBQ, it will post the buffer. The function will return
+ * pointer to the hbq entry if it successfully post the buffer
+ * else it will return NULL.
+ **/
 static struct lpfc_hbq_entry *
 lpfc_sli_hbq_to_firmware(struct lpfc_hba *phba, uint32_t hbqno,
 			 struct hbq_dmabuf *hbq_buf)
@@ -612,6 +809,7 @@ lpfc_sli_hbq_to_firmware(struct lpfc_hba
 	return hbqe;
 }
 
+/* HBQ for ELS and CT traffic. */
 static struct lpfc_hbq_init lpfc_els_hbq = {
 	.rn = 1,
 	.entry_count = 200,
@@ -623,6 +821,7 @@ static struct lpfc_hbq_init lpfc_els_hbq
 	.add_count = 5,
 };
 
+/* HBQ for the extra ring if needed */
 static struct lpfc_hbq_init lpfc_extra_hbq = {
 	.rn = 1,
 	.entry_count = 200,
@@ -634,11 +833,22 @@ static struct lpfc_hbq_init lpfc_extra_h
 	.add_count = 5,
 };
 
+/* Array of HBQs */
 struct lpfc_hbq_init *lpfc_hbq_defs[] = {
 	&lpfc_els_hbq,
 	&lpfc_extra_hbq,
 };
 
+/**
+ * lpfc_sli_hbqbuf_fill_hbqs: Post more hbq buffers to HBQ.
+ * @phba: Pointer to HBA context object.
+ * @hbqno: HBQ number.
+ * @count: Number of HBQ buffers to be posted.
+ *
+ * This function is called with no lock held to post more
+ * hbq buffers to the given HBQ. The function returns 0
+ * when successful and returns 1 other wise.
+ **/
 static int
 lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno, uint32_t count)
 {
@@ -679,6 +889,15 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hb
 	return 1;
 }
 
+/**
+ * lpfc_sli_hbqbuf_add_hbqs: Post more HBQ buffers to firmware.
+ * @phba: Pointer to HBA context object.
+ * @qno: HBQ number.
+ *
+ * This function posts more buffers to the HBQ. This function
+ * is called with no lock held. The function returns 0 when
+ * successful and returns 1 otherwise.
+ **/
 int
 lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *phba, uint32_t qno)
 {
@@ -686,6 +905,15 @@ lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba
 					 lpfc_hbq_defs[qno]->add_count));
 }
 
+/**
+ * lpfc_sli_hbqbuf_init_hbqs: Post initial buffers to the HBQ.
+ * @phba: Pointer to HBA context object.
+ * @qno:  HBQ queue number.
+ *
+ * This function is called from SLI initialization code path with
+ * no lock held to post initial HBQ buffers to firmware. The
+ * function returns 0 when successful and returns 1 otherwise.
+ **/
 static int
 lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hba *phba, uint32_t qno)
 {
@@ -693,6 +921,16 @@ lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hb
 					 lpfc_hbq_defs[qno]->init_count));
 }
 
+/**
+ * lpfc_sli_hbqbuf_find: Find the hbq buffer associated with a tag.
+ * @phba: Pointer to HBA context object.
+ * @tag: Tag of the hbq buffer.
+ *
+ * This function is called with hbalock held. This function searches
+ * for the hbq buffer associated with the given tag in the hbq buffer
+ * list. If it finds the hbq buffer, it returns the hbq_buffer other wise
+ * it returns NULL.
+ **/
 static struct hbq_dmabuf *
 lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
 {
@@ -716,6 +954,15 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *ph
 	return NULL;
 }
 
+/**
+ * lpfc_sli_free_hbq: Give back the hbq buffer to firmware.
+ * @phba: Pointer to HBA context object.
+ * @hbq_buffer: Pointer to HBQ buffer.
+ *
+ * This function is called with hbalock. This function gives back
+ * the hbq buffer to firmware. If the HBQ does not have space to
+ * post the buffer, it will free the buffer.
+ **/
 void
 lpfc_sli_free_hbq(struct lpfc_hba *phba, struct hbq_dmabuf *hbq_buffer)
 {
@@ -729,6 +976,15 @@ lpfc_sli_free_hbq(struct lpfc_hba *phba,
 	}
 }
 
+/**
+ * lpfc_sli_chk_mbx_command: Check if the mailbox is a legitimate mailbox.
+ * @mbxCommand: mailbox command code.
+ *
+ * This function is called by the mailbox event handler function to verify
+ * that the completed mailbox command is a legitimate mailbox command. If the
+ * completed mailbox is not known to the function, it will return MBX_SHUTDOWN
+ * and the mailbox event handler will take the HBA offline.
+ **/
 static int
 lpfc_sli_chk_mbx_command(uint8_t mbxCommand)
 {
@@ -793,6 +1049,19 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	}
 	return ret;
 }
+
+/**
+ * lpfc_sli_wake_mbox_wait: Completion handler for mbox issued from
+ *          lpfc_sli_issue_mbox_wait.
+ * @phba: Pointer to HBA context object.
+ * @pmboxq: Pointer to mailbox command.
+ *
+ * This is completion handler function for mailbox commands issued from
+ * lpfc_sli_issue_mbox_wait function. This function is called by the
+ * mailbox event handler function with no lock held. This function
+ * will wake up thread waiting on the wait queue pointed by context1
+ * of the mailbox.
+ **/
 static void
 lpfc_sli_wake_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
@@ -812,6 +1081,17 @@ lpfc_sli_wake_mbox_wait(struct lpfc_hba 
 	return;
 }
 
+
+/**
+ * lpfc_sli_def_mbox_cmpl: Default mailbox completion handler.
+ * @phba: Pointer to HBA context object.
+ * @pmb: Pointer to mailbox object.
+ *
+ * This function is the default mailbox completion handler. It
+ * frees the memory resources associated with the completed mailbox
+ * command. If the completed command is a REG_LOGIN mailbox command,
+ * this function will issue a UREG_LOGIN to re-claim the RPI.
+ **/
 void
 lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
@@ -846,6 +1126,19 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 	return;
 }
 
+/**
+ * lpfc_sli_handle_mb_event: Handle mailbox completions from firmware.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called with no lock held. This function processes all
+ * the completed mailbox commands and gives it to upper layers. The interrupt
+ * service routine processes mailbox completion interrupt and adds completed
+ * mailbox commands to the mboxq_cmpl queue and signals the worker thread.
+ * Worker thread call lpfc_sli_handle_mb_event, which will return the
+ * completed mailbox commands in mboxq_cmpl queue to the upper layers. This
+ * function returns the mailbox commands to the upper layer by calling the
+ * completion handler function of each mailbox.
+ **/
 int
 lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 {
@@ -953,6 +1246,16 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 	return 0;
 }
 
+/**
+ * lpfc_sli_replace_hbqbuff: Replace the HBQ buffer with a new buffer.
+ * @phba: Pointer to HBA context object.
+ * @tag: Tag for the HBQ buffer.
+ *
+ * This function is called from unsolicited event handler code path to get the
+ * HBQ buffer associated with an unsolicited iocb. This function is called with
+ * no lock held. It returns the buffer associated with the given tag and posts
+ * another buffer to the firmware.
+ **/
 static struct lpfc_dmabuf *
 lpfc_sli_replace_hbqbuff(struct lpfc_hba *phba, uint32_t tag)
 {
@@ -997,6 +1300,18 @@ lpfc_sli_replace_hbqbuff(struct lpfc_hba
 	return &new_hbq_entry->dbuf;
 }
 
+/**
+ * lpfc_sli_get_buff: Get the buffer associated with the buffer tag.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @tag: buffer tag.
+ *
+ * This function is called with no lock held. When QUE_BUFTAG_BIT bit
+ * is set in the tag the buffer is posted for a particular exchange,
+ * the function will return the buffer without replacing the buffer.
+ * If the buffer is for unsolicited ELS or CT traffic, this function
+ * returns the buffer and also posts another buffer to the firmware.
+ **/
 static struct lpfc_dmabuf *
 lpfc_sli_get_buff(struct lpfc_hba *phba,
 			struct lpfc_sli_ring *pring,
@@ -1008,6 +1323,21 @@ lpfc_sli_get_buff(struct lpfc_hba *phba,
 		return lpfc_sli_replace_hbqbuff(phba, tag);
 }
 
+
+/**
+ * lpfc_sli_process_unsol_iocb: Unsolicited iocb handler.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @saveq: Pointer to the unsolicited iocb.
+ *
+ * This function is called with no lock held by the ring event handler
+ * when there is an unsolicited iocb posted to the response ring by the
+ * firmware. This function gets the buffer associated with the iocbs
+ * and calls the event handler for the ring. This function handles both
+ * qring buffers and hbq buffers.
+ * When the function returns 1 the caller can free the iocb object otherwise
+ * upper layer functions will free the iocb objects.
+ **/
 static int
 lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			    struct lpfc_iocbq *saveq)
@@ -1192,6 +1522,18 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 	return 1;
 }
 
+/**
+ * lpfc_sli_iocbq_lookup: Find command iocb for the given response iocb.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @prspiocb: Pointer to response iocb object.
+ *
+ * This function looks up the iocb_lookup table to get the command iocb
+ * corresponding to the given response iocb using the iotag of the
+ * response iocb. This function is called with the hbalock held.
+ * This function returns the command iocb object if it finds the command
+ * iocb else returns NULL.
+ **/
 static struct lpfc_iocbq *
 lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 		      struct lpfc_sli_ring *pring,
@@ -1217,6 +1559,23 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *p
 	return NULL;
 }
 
+/**
+ * lpfc_sli_process_sol_iocb: process solicited iocb completion.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @saveq: Pointer to the response iocb to be processed.
+ *
+ * This function is called by the ring event handler for non-fcp
+ * rings when there is a new response iocb in the response ring.
+ * The caller is not required to hold any locks. This function
+ * gets the command iocb associated with the response iocb and
+ * calls the completion handler for the command iocb. If there
+ * is no completion handler, the function will free the resources
+ * associated with command iocb. If the response iocb is for
+ * an already aborted command iocb, the status of the completion
+ * is changed to IOSTAT_LOCAL_REJECT/IOERR_SLI_ABORTED.
+ * This function always returns 1.
+ **/
 static int
 lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			  struct lpfc_iocbq *saveq)
@@ -1282,6 +1641,16 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 	return rc;
 }
 
+/**
+ * lpfc_sli_rsp_pointers_error: Response ring pointer error handler.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function is called from the iocb ring event handlers when
+ * put pointer is ahead of the get pointer for a ring. This function signal
+ * an error attention condition to the worker thread and the worker
+ * thread will transition the HBA to offline state.
+ **/
 static void
 lpfc_sli_rsp_pointers_error(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
@@ -1312,6 +1681,21 @@ lpfc_sli_rsp_pointers_error(struct lpfc_
 	return;
 }
 
+/**
+ * lpfc_sli_poll_fcp_ring: Handle FCP ring completion in polling mode.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called from lpfc_queuecommand, lpfc_poll_timeout,
+ * lpfc_abort_handler and lpfc_slave_configure when FCP_RING_POLLING
+ * is enabled.
+ *
+ * The caller does not hold any lock.
+ * The function processes each response iocb in the response ring until it
+ * finds an iocb with LE bit set and chains all the iocbs upto the iocb with
+ * LE bit set. The function will call the completion handler of the command iocb
+ * if the response iocb indicates a completion for a command iocb or it is
+ * an abort completion.
+ **/
 void lpfc_sli_poll_fcp_ring(struct lpfc_hba *phba)
 {
 	struct lpfc_sli      *psli  = &phba->sli;
@@ -1465,10 +1849,23 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
 	return;
 }
 
-/*
+/**
+ * lpfc_sli_handle_fast_ring_event: Handle ring events on FCP ring.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @mask: Host attention register mask for this ring.
+ *
+ * This function is called from the interrupt context when there is a ring
+ * event for the fcp ring. The caller does not hold any lock.
+ * The function processes each response iocb in the response ring until it
+ * finds an iocb with LE bit set and chains all the iocbs upto the iocb with
+ * LE bit set. The function will call the completion handler of the command iocb
+ * if the response iocb indicates a completion for a command iocb or it is
+ * an abort completion. The function will call lpfc_sli_process_unsol_iocb
+ * function if this is an unsolicited iocb.
  * This routine presumes LPFC_FCP_RING handling and doesn't bother
- * to check it explicitly.
- */
+ * to check it explicitly. This function always returns 1.
+ **/
 static int
 lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				struct lpfc_sli_ring *pring, uint32_t mask)
@@ -1646,6 +2043,23 @@ lpfc_sli_handle_fast_ring_event(struct l
 	return rc;
 }
 
+/**
+ * lpfc_sli_handle_slow_ring_event: Handle ring events for non-FCP rings.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @mask: Host attention register mask for this ring.
+ *
+ * This function is called from the worker thread when there is a ring
+ * event for non-fcp rings. The caller does not hold any lock .
+ * The function processes each response iocb in the response ring until it
+ * finds an iocb with LE bit set and chains all the iocbs upto the iocb with
+ * LE bit set. The function will call lpfc_sli_process_sol_iocb function if the
+ * response iocb indicates a completion of a command iocb. The function
+ * will call lpfc_sli_process_unsol_iocb function if this is an unsolicited
+ * iocb. The function frees the resources or calls the completion handler if
+ * this iocb is an abort completion. The function returns 0 when the allocated
+ * iocbs are not freed, otherwise returns 1.
+ **/
 int
 lpfc_sli_handle_slow_ring_event(struct lpfc_hba *phba,
 				struct lpfc_sli_ring *pring, uint32_t mask)
@@ -1904,6 +2318,16 @@ lpfc_sli_handle_slow_ring_event(struct l
 	return rc;
 }
 
+/**
+ * lpfc_sli_abort_iocb_ring: Abort all iocbs in the ring.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function aborts all iocbs in the given ring and frees all the iocb
+ * objects in txq. This function issues an abort iocb for all the iocb commands
+ * in txcmplq. The iocbs in the txcmplq is not guaranteed to complete before
+ * the return of this function. The caller is not required to hold any locks.
+ **/
 void
 lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
@@ -1943,6 +2367,19 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 	}
 }
 
+/**
+ * lpfc_sli_brdready: Check for host status bits.
+ * @phba: Pointer to HBA context object.
+ * @mask: Bit mask to be checked.
+ *
+ * This function reads the host status register and compares
+ * with the provided bit mask to check if HBA completed
+ * the restart. This function will wait in a loop for the
+ * HBA to complete restart. If the HBA does not restart within
+ * 15 iterations, the function will reset the HBA again. The
+ * function returns 1 when HBA fail to restart otherwise returns
+ * zero.
+ **/
 int
 lpfc_sli_brdready(struct lpfc_hba *phba, uint32_t mask)
 {
@@ -1990,6 +2427,13 @@ lpfc_sli_brdready(struct lpfc_hba *phba,
 
 #define BARRIER_TEST_PATTERN (0xdeadbeef)
 
+/**
+ * lpfc_reset_barrier: Make HBA ready for HBA reset.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called before resetting an HBA. This
+ * function requests HBA to quiesce DMAs before a reset.
+ **/
 void lpfc_reset_barrier(struct lpfc_hba *phba)
 {
 	uint32_t __iomem *resp_buf;
@@ -2063,6 +2507,17 @@ restore_hc:
 	readl(phba->HCregaddr); /* flush */
 }
 
+/**
+ * lpfc_sli_brdkill: Issue a kill_board mailbox command.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function issues a kill_board mailbox command and waits for
+ * the error attention interrupt. This function is called for stopping
+ * the firmware processing. The caller is not required to hold any
+ * locks. This function calls lpfc_hba_down_post function to free
+ * any pending commands after the kill. The function will return 1 when it
+ * fails to kill the board else will return 0.
+ **/
 int
 lpfc_sli_brdkill(struct lpfc_hba *phba)
 {
@@ -2139,6 +2594,17 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 	return ha_copy & HA_ERATT ? 0 : 1;
 }
 
+/**
+ * lpfc_sli_brdreset: Reset the HBA.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function resets the HBA by writing HC_INITFF to the control
+ * register. After the HBA resets, this function resets all the iocb ring
+ * indices. This function disables PCI layer parity checking during
+ * the reset.
+ * This function returns 0 always.
+ * The caller is not required to hold any locks.
+ **/
 int
 lpfc_sli_brdreset(struct lpfc_hba *phba)
 {
@@ -2191,6 +2657,19 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
 	return 0;
 }
 
+/**
+ * lpfc_sli_brdrestart: Restart the HBA.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called in the SLI initialization code path to
+ * restart the HBA. The caller is not required to hold any lock.
+ * This function writes MBX_RESTART mailbox command to the SLIM and
+ * resets the HBA. At the end of the function, it calls lpfc_hba_down_post
+ * function to free any pending commands. The function enables
+ * POST only during the first initialization. The function returns zero.
+ * The function does not guarantee completion of MBX_RESTART mailbox
+ * command before the return of this function.
+ **/
 int
 lpfc_sli_brdrestart(struct lpfc_hba *phba)
 {
@@ -2251,6 +2730,16 @@ lpfc_sli_brdrestart(struct lpfc_hba *phb
 	return 0;
 }
 
+/**
+ * lpfc_sli_chipset_init: Wait for the restart of the HBA after a restart.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called after a HBA restart to wait for successful
+ * restart of the HBA. Successful restart of the HBA is indicated by
+ * HS_FFRDY and HS_MBRDY bits. If the HBA fails to restart even after 15
+ * iteration, the function will restart the HBA again. The function returns
+ * zero if HBA successfully restarted else returns negative error code.
+ **/
 static int
 lpfc_sli_chipset_init(struct lpfc_hba *phba)
 {
@@ -2336,12 +2825,25 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 	return 0;
 }
 
+/**
+ * lpfc_sli_hbq_count: Get the number of HBQs to be configured.
+ *
+ * This function calculates and returns the number of HBQs required to be
+ * configured.
+ **/
 int
 lpfc_sli_hbq_count(void)
 {
 	return ARRAY_SIZE(lpfc_hbq_defs);
 }
 
+/**
+ * lpfc_sli_hbq_entry_count: Calculate total number of hbq entries.
+ *
+ * This function adds the number of hbq entries in every HBQ to get
+ * the total number of hbq entries required for the HBA and returns
+ * the total count.
+ **/
 static int
 lpfc_sli_hbq_entry_count(void)
 {
@@ -2354,12 +2856,27 @@ lpfc_sli_hbq_entry_count(void)
 	return count;
 }
 
+/**
+ * lpfc_sli_hbq_size: Calculate memory required for all hbq entries.
+ *
+ * This function calculates amount of memory required for all hbq entries
+ * to be configured and returns the total memory required.
+ **/
 int
 lpfc_sli_hbq_size(void)
 {
 	return lpfc_sli_hbq_entry_count() * sizeof(struct lpfc_hbq_entry);
 }
 
+/**
+ * lpfc_sli_hbq_setup: configure and initialize HBQs.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called during the SLI initialization to configure
+ * all the HBQs and post buffers to the HBQ. The caller is not
+ * required to hold any locks. This function will return zero if successful
+ * else it will return negative error code.
+ **/
 static int
 lpfc_sli_hbq_setup(struct lpfc_hba *phba)
 {
@@ -2422,6 +2939,19 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 	return 0;
 }
 
+/**
+ * lpfc_do_config_port: Issue config port mailbox command.
+ * @phba: Pointer to HBA context object.
+ * @sli_mode: sli mode - 2/3
+ *
+ * This function is called by the sli intialization code path
+ * to issue config_port mailbox command. This function restarts the
+ * HBA firmware and issues a config_port mailbox command to configure
+ * the SLI interface in the sli mode specified by sli_mode
+ * variable. The caller is not required to hold any locks.
+ * The function returns 0 if successful, else returns negative error
+ * code.
+ **/
 static int
 lpfc_do_config_port(struct lpfc_hba *phba, int sli_mode)
 {
@@ -2500,6 +3030,20 @@ do_prep_failed:
 	return rc;
 }
 
+
+/**
+ * lpfc_sli_hba_setup: SLI intialization function.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is the main SLI intialization function. This function
+ * is called by the HBA intialization code, HBA reset code and HBA
+ * error attention handler code. Caller is not required to hold any
+ * locks. This function issues config_port mailbox command to configure
+ * the SLI, setup iocb rings and HBQ rings. In the end the function
+ * calls the config_port_post function to issue init_link mailbox
+ * command and to start the discovery. The function will return zero
+ * if successful, else it will return negative error code.
+ **/
 int
 lpfc_sli_hba_setup(struct lpfc_hba *phba)
 {
@@ -2581,19 +3125,19 @@ lpfc_sli_hba_setup_error:
 	return rc;
 }
 
-/*! lpfc_mbox_timeout
- *
- * \pre
- * \post
- * \param hba Pointer to per struct lpfc_hba structure
- * \param l1  Pointer to the driver's mailbox queue.
- * \return
- *   void
- *
- * \b Description:
+
+/**
+ * lpfc_mbox_timeout: Timeout call back function for mbox timer.
+ * @ptr: context object - pointer to hba structure.
  *
- * This routine handles mailbox timeout events at timer interrupt context.
- */
+ * This is the callback function for mailbox timer. The mailbox
+ * timer is armed when a new mailbox command is issued and the timer
+ * is deleted when the mailbox complete. The function is called by
+ * the kernel timer code when a mailbox does not complete within
+ * expected time. This function wakes up the worker thread to
+ * process the mailbox timeout and returns. All the processing is
+ * done by the worker thread function lpfc_mbox_timeout_handler.
+ **/
 void
 lpfc_mbox_timeout(unsigned long ptr)
 {
@@ -2612,6 +3156,15 @@ lpfc_mbox_timeout(unsigned long ptr)
 	return;
 }
 
+
+/**
+ * lpfc_mbox_timeout_handler: Worker thread function to handle mailbox timeout.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called from worker thread when a mailbox command times out.
+ * The caller is not required to hold any locks. This function will reset the
+ * HBA and recover all the pending commands.
+ **/
 void
 lpfc_mbox_timeout_handler(struct lpfc_hba *phba)
 {
@@ -2666,6 +3219,32 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 	return;
 }
 
+/**
+ * lpfc_sli_issue_mbox: Issue a mailbox command to firmware.
+ * @phba: Pointer to HBA context object.
+ * @pmbox: Pointer to mailbox object.
+ * @flag: Flag indicating how the mailbox need to be processed.
+ *
+ * This function is called by discovery code and HBA management code
+ * to submit a mailbox command to firmware. This function gets the
+ * hbalock to protect the data structures.
+ * The mailbox command can be submitted in polling mode, in which case
+ * this function will wait in a polling loop for the completion of the
+ * mailbox.
+ * If the mailbox is submitted in no_wait mode (not polling) the
+ * function will submit the command and returns immediately without waiting
+ * for the mailbox completion. The no_wait is supported only when HBA
+ * is in SLI2/SLI3 mode - interrupts are enabled.
+ * The SLI interface allows only one mailbox pending at a time. If the
+ * mailbox is issued in polling mode and there is already a mailbox
+ * pending, then the function will return an error. If the mailbox is issued
+ * in NO_WAIT mode and there is a mailbox pending already, the function
+ * will return MBX_BUSY after queuing the mailbox into mailbox queue.
+ * The sli layer owns the mailbox object until the completion of mailbox
+ * command if this function return MBX_BUSY or MBX_SUCCESS. For all other
+ * return codes the caller owns the mailbox command after the return of
+ * the function.
+ **/
 int
 lpfc_sli_issue_mbox(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox, uint32_t flag)
 {
@@ -2980,9 +3559,16 @@ out_not_finished:
 	return MBX_NOT_FINISHED;
 }
 
-/*
- * Caller needs to hold lock.
- */
+/**
+ * __lpfc_sli_ringtx_put: Add an iocb to the txq.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @piocb: Pointer to address of newly added command iocb.
+ *
+ * This function is called with hbalock held to add a command
+ * iocb to the txq when SLI layer cannot submit the command iocb
+ * to the ring.
+ **/
 static void
 __lpfc_sli_ringtx_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		    struct lpfc_iocbq *piocb)
@@ -2992,6 +3578,23 @@ __lpfc_sli_ringtx_put(struct lpfc_hba *p
 	pring->txq_cnt++;
 }
 
+/**
+ * lpfc_sli_next_iocb: Get the next iocb in the txq.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @piocb: Pointer to address of newly added command iocb.
+ *
+ * This function is called with hbalock held before a new
+ * iocb is submitted to the firmware. This function checks
+ * txq to flush the iocbs in txq to Firmware before
+ * submitting new iocbs to the Firmware.
+ * If there are iocbs in the txq which need to be submitted
+ * to firmware, lpfc_sli_next_iocb returns the first element
+ * of the txq after dequeuing it from txq.
+ * If there is no iocb in the txq then the function will return
+ * *piocb and *piocb is set to NULL. Caller needs to check
+ * *piocb to find if there are more commands in the txq.
+ **/
 static struct lpfc_iocbq *
 lpfc_sli_next_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		   struct lpfc_iocbq **piocb)
@@ -3007,9 +3610,30 @@ lpfc_sli_next_iocb(struct lpfc_hba *phba
 	return nextiocb;
 }
 
-/*
- * Lockless version of lpfc_sli_issue_iocb.
- */
+/**
+ * __lpfc_sli_issue_iocb: Lockless version of lpfc_sli_issue_iocb.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @piocb: Pointer to command iocb.
+ * @flag: Flag indicating if this command can be put into txq.
+ *
+ * __lpfc_sli_issue_iocb is used by other functions in the driver
+ * to issue an iocb command to the HBA. If the PCI slot is recovering
+ * from error state or if HBA is resetting or if LPFC_STOP_IOCB_EVENT
+ * flag is turned on, the function returns IOCB_ERROR.
+ * When the link is down, this function allows only iocbs for
+ * posting buffers.
+ * This function finds next available slot in the command ring and
+ * posts the command to the available slot and writes the port
+ * attention register to request HBA start processing new iocb.
+ * If there is no slot available in the ring and
+ * flag & SLI_IOCB_RET_IOCB is set, the new iocb is added to the
+ * txq, otherwise the function returns IOCB_BUSY.
+ *
+ * This function is called with hbalock held.
+ * The function will return success after it successfully submit the
+ * iocb to firmware or after adding to the txq.
+ **/
 static int
 __lpfc_sli_issue_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		    struct lpfc_iocbq *piocb, uint32_t flag)
@@ -3106,6 +3730,19 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *p
 }
 

+/**
+ * lpfc_sli_issue_iocb: Wrapper function for __lpfc_sli_issue_iocb.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @piocb: Pointer to command iocb.
+ * @flag: Flag indicating if this command can be put into txq.
+ *
+ * lpfc_sli_issue_iocb is a wrapper around __lpfc_sli_issue_iocb
+ * function. This function gets the hbalock and calls
+ * __lpfc_sli_issue_iocb function and will return the error returned
+ * by __lpfc_sli_issue_iocb function. This wrapper is used by
+ * functions which do not hold hbalock.
+ **/
 int
 lpfc_sli_issue_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		    struct lpfc_iocbq *piocb, uint32_t flag)
@@ -3120,6 +3757,17 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phb
 	return rc;
 }
 
+/**
+ * lpfc_extra_ring_setup: Extra ring setup function.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called while driver attaches with the
+ * HBA to setup the extra ring. The extra ring is used
+ * only when driver needs to support target mode functionality
+ * or IP over FC functionalities.
+ *
+ * This function is called with no lock held.
+ **/
 static int
 lpfc_extra_ring_setup( struct lpfc_hba *phba)
 {
@@ -3155,6 +3803,19 @@ lpfc_extra_ring_setup( struct lpfc_hba *
 	return 0;
 }
 
+/**
+ * lpfc_sli_async_event_handler: ASYNC iocb handler function.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @iocbq: Pointer to iocb object.
+ *
+ * This function is called by the slow ring event handler
+ * function when there is an ASYNC event iocb in the ring.
+ * This function is called with no lock held.
+ * Currently this function handles only temperature related
+ * ASYNC events. The function decodes the temperature sensor
+ * event message and posts events for the management applications.
+ **/
 static void
 lpfc_sli_async_event_handler(struct lpfc_hba * phba,
 	struct lpfc_sli_ring * pring, struct lpfc_iocbq * iocbq)
@@ -3210,6 +3871,17 @@ lpfc_sli_async_event_handler(struct lpfc
 }
 

+/**
+ * lpfc_sli_setup: SLI ring setup function.
+ * @phba: Pointer to HBA context object.
+ *
+ * lpfc_sli_setup sets up rings of the SLI interface with
+ * number of iocbs per ring and iotags. This function is
+ * called while driver attach to the HBA and before the
+ * interrupts are enabled. So there is no need for locking.
+ *
+ * This function always returns 0.
+ **/
 int
 lpfc_sli_setup(struct lpfc_hba *phba)
 {
@@ -3321,6 +3993,17 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 	return 0;
 }
 
+/**
+ * lpfc_sli_queue_setup: Queue initialization function.
+ * @phba: Pointer to HBA context object.
+ *
+ * lpfc_sli_queue_setup sets up mailbox queues and iocb queues for each
+ * ring. This function also initializes ring indices of each ring.
+ * This function is called during the initialization of the SLI
+ * interface of an HBA.
+ * This function is called with no lock held and always returns
+ * 1.
+ **/
 int
 lpfc_sli_queue_setup(struct lpfc_hba *phba)
 {
@@ -3349,6 +4032,23 @@ lpfc_sli_queue_setup(struct lpfc_hba *ph
 	return 1;
 }
 
+/**
+ * lpfc_sli_host_down: Vport cleanup function.
+ * @vport: Pointer to virtual port object.
+ *
+ * lpfc_sli_host_down is called to clean up the resources
+ * associated with a vport before destroying virtual
+ * port data structures.
+ * This function does following operations:
+ * - Free discovery resources associated with this virtual
+ *   port.
+ * - Free iocbs associated with this virtual port in
+ *   the txq.
+ * - Send abort for all iocb commands associated with this
+ *   vport in txcmplq.
+ *
+ * This function is called with no lock held and always returns 1.
+ **/
 int
 lpfc_sli_host_down(struct lpfc_vport *vport)
 {
@@ -3411,6 +4111,21 @@ lpfc_sli_host_down(struct lpfc_vport *vp
 	return 1;
 }
 
+/**
+ * lpfc_sli_hba_down: Resource cleanup function for the HBA.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function cleans up all iocb, buffers, mailbox commands
+ * while shutting down the HBA. This function is called with no
+ * lock held and always returns 1.
+ * This function does the following to cleanup driver resources:
+ * - Free discovery resources for each virtual port
+ * - Cleanup any pending fabric iocbs
+ * - Iterate through the iocb txq and free each entry
+ *   in the list.
+ * - Free up any buffer posted to the HBA
+ * - Free mailbox commands in the mailbox queue.
+ **/
 int
 lpfc_sli_hba_down(struct lpfc_hba *phba)
 {
@@ -3501,6 +4216,18 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	return 1;
 }
 
+/**
+ * lpfc_sli_pcimem_bcopy: SLI memory copy function.
+ * @srcp: Source memory pointer.
+ * @destp: Destination memory pointer.
+ * @cnt: Number of words required to be copied.
+ *
+ * This function is used for copying data between driver memory
+ * and the SLI memory. This function also changes the endianness
+ * of each word if native endianness is different from SLI
+ * endianness. This function can be called with or without
+ * lock.
+ **/
 void
 lpfc_sli_pcimem_bcopy(void *srcp, void *destp, uint32_t cnt)
 {
@@ -3518,6 +4245,17 @@ lpfc_sli_pcimem_bcopy(void *srcp, void *
 	}
 }
 
+
+/**
+ * lpfc_sli_ringpostbuf_put: Function to add a buffer to postbufq.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @mp: Pointer to driver buffer object.
+ *
+ * This function is called with no lock held.
+ * It always return zero after adding the buffer to the postbufq
+ * buffer list.
+ **/
 int
 lpfc_sli_ringpostbuf_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 struct lpfc_dmabuf *mp)
@@ -3531,6 +4269,18 @@ lpfc_sli_ringpostbuf_put(struct lpfc_hba
 	return 0;
 }
 
+/**
+ * lpfc_sli_get_buffer_tag: Tag allocation function for a buffer posted
+ *          using CMD_QUE_XRI64_CX iocb.
+ * @phba: Pointer to HBA context object.
+ *
+ * When HBQ is enabled, buffers are searched based on tags. This function
+ * allocates a tag for buffer posted using CMD_QUE_XRI64_CX iocb. The
+ * tag is bit wise or-ed with QUE_BUFTAG_BIT to make sure that the tag
+ * does not conflict with tags of buffer posted for unsolicited events.
+ * The function returns the allocated tag. The function is called with
+ * no locks held.
+ **/
 uint32_t
 lpfc_sli_get_buffer_tag(struct lpfc_hba *phba)
 {
@@ -3545,6 +4295,22 @@ lpfc_sli_get_buffer_tag(struct lpfc_hba 
 	return phba->buffer_tag_count;
 }
 
+/**
+ * lpfc_sli_ring_taggedbuf_get: Search HBQ buffer associated with
+ *              posted using CMD_QUE_XRI64_CX iocb.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @tag: Buffer tag.
+ *
+ * Buffers posted using CMD_QUE_XRI64_CX iocb are in pring->postbufq
+ * list. After HBA DMA data to these buffers, CMD_IOCB_RET_XRI64_CX
+ * iocb is posted to the response ring with the tag of the buffer.
+ * This function searches the pring->postbufq list using the tag
+ * to find buffer associated with CMD_IOCB_RET_XRI64_CX
+ * iocb. If the buffer is found then lpfc_dmabuf object of the
+ * buffer is returned to the caller else NULL is returned.
+ * This function is called with no lock held.
+ **/
 struct lpfc_dmabuf *
 lpfc_sli_ring_taggedbuf_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			uint32_t tag)
@@ -3573,6 +4339,23 @@ lpfc_sli_ring_taggedbuf_get(struct lpfc_
 	return NULL;
 }
 
+/**
+ * lpfc_sli_ringpostbuf_get: SLI2 buffer search function for
+ *      unsolicited ct and els events.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @phys: DMA address of the buffer.
+ *
+ * This function searches the buffer list using the dma_address
+ * of unsolicited event to find the driver's lpfc_dmabuf object
+ * corresponding to the dma_address. The function returns the
+ * lpfc_dmabuf object if a buffer is found else it returns NULL.
+ * This function is called by the ct and els unsolicited event
+ * handlers to get the buffer associated with the unsolicited
+ * event.
+ *
+ * This function is called with no lock held.
+ **/
 struct lpfc_dmabuf *
 lpfc_sli_ringpostbuf_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 dma_addr_t phys)
@@ -3600,6 +4383,17 @@ lpfc_sli_ringpostbuf_get(struct lpfc_hba
 	return NULL;
 }
 
+/**
+ * lpfc_sli_abort_els_cmpl: Completion handler for the els abort iocbs.
+ * @phba: Pointer to HBA context object.
+ * @cmdiocb: Pointer to driver command iocb object.
+ * @rspiocb: Pointer to driver response iocb object.
+ *
+ * This function is the completion handler for the abort iocbs for
+ * ELS commands. This function is called from the ELS ring event
+ * handler with no lock held. This function frees memory resources
+ * associated with the abort iocb.
+ **/
 static void
 lpfc_sli_abort_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			struct lpfc_iocbq *rspiocb)
@@ -3665,6 +4459,17 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 	return;
 }
 
+/**
+ * lpfc_ignore_els_cmpl: Completion handler for aborted ELS command.
+ * @phba: Pointer to HBA context object.
+ * @cmdiocb: Pointer to driver command iocb object.
+ * @rspiocb: Pointer to driver response iocb object.
+ *
+ * The function is called from SLI ring event handler with no
+ * lock held. This function is the completion handler for ELS commands
+ * which are aborted. The function frees memory resources used for
+ * the aborted ELS commands.
+ **/
 static void
 lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		     struct lpfc_iocbq *rspiocb)
@@ -3684,6 +4489,17 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *ph
 	return;
 }
 
+/**
+ * lpfc_sli_issue_abort_iotag: Abort function for a command iocb.
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @cmdiocb: Pointer to driver command iocb object.
+ *
+ * This function issues an abort iocb for the provided command
+ * iocb. This function is called with hbalock held.
+ * The function returns 0 when it fails due to memory allocation
+ * failure or when the command iocb is an abort request.
+ **/
 int
 lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			   struct lpfc_iocbq *cmdiocb)
@@ -3757,6 +4573,29 @@ abort_iotag_exit:
 	return retval;
 }
 
+/**
+ * lpfc_sli_validate_fcp_iocb: Filtering function, used to find commands
+ *                    associated with a vport/SCSI target/lun.
+ * @iocbq: Pointer to driver iocb object.
+ * @vport: Pointer to driver virtual port object.
+ * @tgt_id: SCSI ID of the target.
+ * @lun_id: LUN ID of the scsi device.
+ * @ctx_cmd: LPFC_CTX_LUN/LPFC_CTX_TGT/LPFC_CTX_HOST
+ *
+ * This function acts as iocb filter for functions which abort or count
+ * all FCP iocbs pending on a lun/SCSI target/SCSI host. It will return
+ * 0 if the filtering criteria is met for the given iocb and will return
+ * 1 if the filtering criteria is not met.
+ * If ctx_cmd == LPFC_CTX_LUN, the function returns 0 only if the
+ * given iocb is for the SCSI device specified by vport, tgt_id and
+ * lun_id parameter.
+ * If ctx_cmd == LPFC_CTX_TGT,  the function returns 0 only if the
+ * given iocb is for the SCSI target specified by vport and tgt_id
+ * parameters.
+ * If ctx_cmd == LPFC_CTX_HOST, the function returns 0 only if the
+ * given iocb is for the SCSI host associated with the given vport.
+ * This function is called with no locks held.
+ **/
 static int
 lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
 			   uint16_t tgt_id, uint64_t lun_id,
@@ -3800,6 +4639,25 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_i
 	return rc;
 }
 
+/**
+ * lpfc_sli_sum_iocb: Function to count the number of FCP iocbs pending.
+ * @vport: Pointer to virtual port.
+ * @tgt_id: SCSI ID of the target.
+ * @lun_id: LUN ID of the scsi device.
+ * @ctx_cmd: LPFC_CTX_LUN/LPFC_CTX_TGT/LPFC_CTX_HOST.
+ *
+ * This function returns number of FCP commands pending for the vport.
+ * When ctx_cmd == LPFC_CTX_LUN, the function returns number of FCP
+ * commands pending on the vport associated with SCSI device specified
+ * by tgt_id and lun_id parameters.
+ * When ctx_cmd == LPFC_CTX_TGT, the function returns number of FCP
+ * commands pending on the vport associated with SCSI target specified
+ * by tgt_id parameter.
+ * When ctx_cmd == LPFC_CTX_HOST, the function returns number of FCP
+ * commands pending on the vport.
+ * This function returns the number of iocbs which satisfy the filter.
+ * This function is called without any lock held.
+ **/
 int
 lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 		  lpfc_ctx_cmd ctx_cmd)
@@ -3819,6 +4677,17 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vpo
 	return sum;
 }
 
+/**
+ * lpfc_sli_abort_fcp_cmpl: Completion handler function for an aborted
+ *       FCP iocb.
+ * @phba: Pointer to HBA context object
+ * @cmdiocb: Pointer to command iocb object.
+ * @rspiocb: Pointer to response iocb object.
+ *
+ * This function is called when an aborted FCP iocb completes. This
+ * function is called by the ring event handler with no lock held.
+ * This function frees the iocb.
+ **/
 void
 lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			struct lpfc_iocbq *rspiocb)
@@ -3827,6 +4696,28 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba 
 	return;
 }
 
+/**
+ * lpfc_sli_abort_iocb: This function issue abort for all SCSI commands
+ *          pending on a SCSI host(vport)/target/lun.
+ * @vport: Pointer to virtual port.
+ * @pring: Pointer to driver SLI ring object.
+ * @tgt_id: SCSI ID of the target.
+ * @lun_id: LUN ID of the scsi device.
+ * @abort_cmd: LPFC_CTX_LUN/LPFC_CTX_TGT/LPFC_CTX_HOST.
+ *
+ * This function sends an abort command for every SCSI command
+ * associated with the given virtual port pending on the ring
+ * filtered by lpfc_sli_validate_fcp_iocb function.
+ * When abort_cmd == LPFC_CTX_LUN, the function sends abort only to the
+ * FCP iocbs associated with lun specified by tgt_id and lun_id
+ * parameters
+ * When abort_cmd == LPFC_CTX_TGT, the function sends abort only to the
+ * FCP iocbs associated with SCSI target specified by tgt_id parameter.
+ * When abort_cmd == LPFC_CTX_HOST, the function sends abort to all
+ * FCP iocbs associated with virtual port.
+ * This function returns number of iocbs it failed to abort.
+ * This function is called with no locks held.
+ **/
 int
 lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		    uint16_t tgt_id, uint64_t lun_id, lpfc_ctx_cmd abort_cmd)
@@ -3878,6 +4769,24 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
 	return errcnt;
 }
 
+/**
+ * lpfc_sli_wake_iocb_wait: iocb completion handler for iocb issued using
+ *                          lpfc_sli_issue_iocb_wait.
+ * @phba: Pointer to HBA context object.
+ * @cmdiocbq: Pointer to command iocb.
+ * @rspiocbq: Pointer to response iocb.
+ *
+ * This function is the completion handler for iocbs issued using
+ * lpfc_sli_issue_iocb_wait function. This function is called by the
+ * ring event handler function without any lock held. This function
+ * can be called from both worker thread context and interrupt
+ * context. This function also can be called from other thread which
+ * cleans up the SLI layer objects.
+ * This function copy the contents of the response iocb to the
+ * response iocb memory object provided by the caller of
+ * lpfc_sli_issue_iocb_wait and then wakes up the thread which
+ * sleeps for the iocb completion.
+ **/
 static void
 lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 			struct lpfc_iocbq *cmdiocbq,
@@ -3899,13 +4808,36 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba 
 	return;
 }
 
-/*
- * Issue the caller's iocb and wait for its completion, but no longer than the
- * caller's timeout.  Note that iocb_flags is cleared before the
- * lpfc_sli_issue_call since the wake routine sets a unique value and by
- * definition this is a wait function.
- */
-
+/**
+ * lpfc_sli_issue_iocb_wait: Synchronous function to issue iocb commands.
+ * @phba: Pointer to HBA context object..
+ * @pring: Pointer to sli ring.
+ * @piocb: Pointer to command iocb.
+ * @prspiocbq: Pointer to response iocb.
+ * @timeout: Timeout in number of seconds.
+ *
+ * This function issues the iocb to firmware and waits for the
+ * iocb to complete. If the iocb command is not
+ * completed within timeout seconds, it returns IOCB_TIMEDOUT.
+ * Caller should not free the iocb resources if this function
+ * returns IOCB_TIMEDOUT.
+ * The function waits for the iocb completion using an
+ * non-interruptible wait.
+ * This function will sleep while waiting for iocb completion.
+ * So, this function should not be called from any context which
+ * does not allow sleeping. Due to the same reason, this function
+ * cannot be called with interrupt disabled.
+ * This function assumes that the iocb completions occur while
+ * this function sleep. So, this function cannot be called from
+ * the thread which process iocb completion for this ring.
+ * This function clears the iocb_flag of the iocb object before
+ * issuing the iocb and the iocb completion handler sets this
+ * flag and wakes this thread when the iocb completes.
+ * The contents of the response iocb will be copied to prspiocbq
+ * by the completion handler when the command completes.
+ * This function returns IOCB_SUCCESS when success.
+ * This function is called with no lock held.
+ **/
 int
 lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 			 struct lpfc_sli_ring *pring,
@@ -3983,6 +4915,32 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 	return retval;
 }
 
+/**
+ * lpfc_sli_issue_mbox_wait: Synchronous function to issue mailbox.
+ * @phba: Pointer to HBA context object.
+ * @pmboxq: Pointer to driver mailbox object.
+ * @timeout: Timeout in number of seconds.
+ *
+ * This function issues the mailbox to firmware and waits for the
+ * mailbox command to complete. If the mailbox command is not
+ * completed within timeout seconds, it returns MBX_TIMEOUT.
+ * The function waits for the mailbox completion using an
+ * interruptible wait. If the thread is woken up due to a
+ * signal, MBX_TIMEOUT error is returned to the caller. Caller
+ * should not free the mailbox resources, if this function returns
+ * MBX_TIMEOUT.
+ * This function will sleep while waiting for mailbox completion.
+ * So, this function should not be called from any context which
+ * does not allow sleeping. Due to the same reason, this function
+ * cannot be called with interrupt disabled.
+ * This function assumes that the mailbox completion occurs while
+ * this function sleep. So, this function cannot be called from
+ * the worker thread which processes mailbox completion.
+ * This function is called in the context of HBA management
+ * applications.
+ * This function returns MBX_SUCCESS when successful.
+ * This function is called with no lock held.
+ **/
 int
 lpfc_sli_issue_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq,
 			 uint32_t timeout)
@@ -4027,6 +4985,18 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 	return retval;
 }
 
+/**
+ * lpfc_sli_flush_mbox_queue: mailbox queue cleanup function.
+ * @phba: Pointer to HBA context.
+ *
+ * This function is called to cleanup any pending mailbox
+ * objects in the driver queue before bringing the HBA offline.
+ * This function is called while resetting the HBA.
+ * The function is called without any lock held. The function
+ * takes hbalock to update SLI data structure.
+ * This function returns 1 when there is an active mailbox
+ * command pending else returns 0.
+ **/
 int
 lpfc_sli_flush_mbox_queue(struct lpfc_hba * phba)
 {
@@ -4058,6 +5028,27 @@ lpfc_sli_flush_mbox_queue(struct lpfc_hb
 	return (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE) ? 1 : 0;
 }
 
+/**
+ * lpfc_intr_handler: The interrupt handler of lpfc driver.
+ * @irq: Interrupt number.
+ * @dev_id: The device context pointer.
+ *
+ * This function is called from the PCI layer when there is
+ * an event in the HBA which requires driver attention. When
+ * the PCI slot is in error recovery or the HBA is undergoing
+ * initialization the interrupt handler will not process the
+ * interrupt.
+ * The error attention, link attention and els ring attention
+ * events are handled by the worker thread. The interrupt
+ * handler signals the worker thread and returns for these
+ * events.
+ * The SCSI ring event and mailbox events are handled in the
+ * interrupt context.
+ * This function is called without any lock held. It gets the
+ * hbalock to access and update SLI data structures.
+ * This function returns IRQ_HANDLED when interrupt is handled
+ * else it returns IRQ_NONE.
+ **/
 irqreturn_t
 lpfc_intr_handler(int irq, void *dev_id)
 {


