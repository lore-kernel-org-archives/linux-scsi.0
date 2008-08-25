From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/15] lpfc 8.2.8 : Add kernel-doc function headers - part 2
Date: Sun, 24 Aug 2008 21:49:11 -0400
Message-ID: <1219628951.7890.23.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52422 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbYHYBtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:49:11 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1n91Q019913
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:49:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add kernel-doc function headers - part 2


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c | 1345 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 1340 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-06-30 09:31:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-08-24 18:49:13.000000000 -0400
@@ -53,6 +53,28 @@ static void lpfc_register_new_vport(stru
 
 static int lpfc_max_els_tries = 3;
 
+/**
+ * lpfc_els_chk_latt: Check host link attention event for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine checks whether there is an outstanding host link
+ * attention event during the discovery process with the @vport. It is done
+ * by reading the HBA's Host Attention (HA) register. If there is any host
+ * link attention events during this @vport's discovery process, the @vport
+ * shall be marked as FC_ABORT_DISCOVERY, a host link attention clear shall
+ * be issued if the link state is not already in host link cleared state,
+ * and a return code shall indicate whether the host link attention event
+ * had happened.
+ *
+ * Note that, if either the host link is in state LPFC_LINK_DOWN or @vport
+ * state in LPFC_VPORT_READY, the request for checking host link attention
+ * event will be ignored and a return code shall indicate no host link
+ * attention event had happened.
+ *
+ * Return codes
+ *   0 - no host link attention event happened
+ *   1 - host link attention event happened
+ **/
 int
 lpfc_els_chk_latt(struct lpfc_vport *vport)
 {
@@ -92,6 +114,34 @@ lpfc_els_chk_latt(struct lpfc_vport *vpo
 	return 1;
 }
 
+/**
+ * lpfc_prep_els_iocb: Allocate and prepare a lpfc iocb data structure.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @expectRsp: flag indicating whether response is expected.
+ * @cmdSize: size of the ELS command.
+ * @retry: number of retries to the command IOCB when it fails.
+ * @ndlp: pointer to a node-list data structure.
+ * @did: destination identifier.
+ * @elscmd: the ELS command code.
+ *
+ * This routine is used for allocating a lpfc-IOCB data structure from
+ * the driver lpfc-IOCB free-list and prepare the IOCB with the parameters
+ * passed into the routine for discovery state machine to issue an Extended
+ * Link Service (ELS) commands. It is a generic lpfc-IOCB allocation
+ * and preparation routine that is used by all the discovery state machine
+ * routines and the ELS command-specific fields will be later set up by
+ * the individual discovery machine routines after calling this routine
+ * allocating and preparing a generic IOCB data structure. It fills in the
+ * Buffer Descriptor Entries (BDEs), allocates buffers for both command
+ * payload and response payload (if expected). The reference count on the
+ * ndlp is incremented by 1 and the reference to the ndlp is put into
+ * context1 of the IOCB data structure for this IOCB to hold the ndlp
+ * reference for the command's callback function to access later.
+ *
+ * Return code
+ *   Pointer to the newly allocated/prepared els iocb data structure
+ *   NULL - when els iocb data structure allocation/preparation failed
+ **/
 static struct lpfc_iocbq *
 lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 		   uint16_t cmdSize, uint8_t retry,
@@ -233,6 +283,22 @@ els_iocb_free_pcmb_exit:
 	return NULL;
 }
 
+/**
+ * lpfc_issue_fabric_reglogin: Issue fabric registration login for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine issues a fabric registration login for a @vport. An
+ * active ndlp node with Fabric_DID must already exist for this @vport.
+ * The routine invokes two mailbox commands to carry out fabric registration
+ * login through the HBA firmware: the first mailbox command requests the
+ * HBA to perform link configuration for the @vport; and the second mailbox
+ * command requests the HBA to perform the actual fabric registration login
+ * with the @vport.
+ *
+ * Return code
+ *   0 - successfully issued fabric registration login for @vport
+ *   -ENXIO -- failed to issue fabric registration login for @vport
+ **/
 static int
 lpfc_issue_fabric_reglogin(struct lpfc_vport *vport)
 {
@@ -313,6 +379,26 @@ fail:
 	return -ENXIO;
 }
 
+/**
+ * lpfc_cmpl_els_flogi_fabric: Completion function for flogi to a fabric port.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @sp: pointer to service parameter data structure.
+ * @irsp: pointer to the IOCB within the lpfc response IOCB.
+ *
+ * This routine is invoked by the lpfc_cmpl_els_flogi() completion callback
+ * function to handle the completion of a Fabric Login (FLOGI) into a fabric
+ * port in a fabric topology. It properly sets up the parameters to the @ndlp
+ * from the IOCB response. It also check the newly assigned N_Port ID to the
+ * @vport against the previously assigned N_Port ID. If it is different from
+ * the previously assigned Destination ID (DID), the lpfc_unreg_rpi() routine
+ * is invoked on all the remaining nodes with the @vport to unregister the
+ * Remote Port Indicators (RPIs). Finally, the lpfc_issue_fabric_reglogin()
+ * is invoked to register login to the fabric.
+ *
+ * Return code
+ *   0 - Success (currently, always return 0)
+ **/
 static int
 lpfc_cmpl_els_flogi_fabric(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   struct serv_parm *sp, IOCB_t *irsp)
@@ -416,9 +502,26 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 	return 0;
 }
 
-/*
- * We FLOGIed into an NPort, initiate pt2pt protocol
- */
+/**
+ * lpfc_cmpl_els_flogi_nport: Completion function for flogi to an N_Port.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @sp: pointer to service parameter data structure.
+ *
+ * This routine is invoked by the lpfc_cmpl_els_flogi() completion callback
+ * function to handle the completion of a Fabric Login (FLOGI) into an N_Port
+ * in a point-to-point topology. First, the @vport's N_Port Name is compared
+ * with the received N_Port Name: if the @vport's N_Port Name is greater than
+ * the received N_Port Name lexicographically, this node shall assign local
+ * N_Port ID (PT2PT_LocalID: 1) and remote N_Port ID (PT2PT_RemoteID: 2) and
+ * will send out Port Login (PLOGI) with the N_Port IDs assigned. Otherwise,
+ * this node shall just wait for the remote node to issue PLOGI and assign
+ * N_Port IDs.
+ *
+ * Return code
+ *   0 - Success
+ *   -ENXIO - Fail
+ **/
 static int
 lpfc_cmpl_els_flogi_nport(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			  struct serv_parm *sp)
@@ -516,6 +619,29 @@ fail:
 	return -ENXIO;
 }
 
+/**
+ * lpfc_cmpl_els_flogi: Completion callback function for flogi.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is the top-level completion callback function for issuing
+ * a Fabric Login (FLOGI) command. If the response IOCB reported error,
+ * the lpfc_els_retry() routine shall be invoked to retry the FLOGI. If
+ * retry has been made (either immediately or delayed with lpfc_els_retry()
+ * returning 1), the command IOCB will be released and function returned.
+ * If the retry attempt has been given up (possibly reach the maximum
+ * number of retries), one additional decrement of ndlp reference shall be
+ * invoked before going out after releasing the command IOCB. This will
+ * actually release the remote node (Note, lpfc_els_free_iocb() will also
+ * invoke one decrement of ndlp reference count). If no error reported in
+ * the IOCB status, the command Port ID field is used to determine whether
+ * this is a point-to-point topology or a fabric topology: if the Port ID
+ * field is assigned, it is a fabric topology; otherwise, it is a
+ * point-to-point topology. The routine lpfc_cmpl_els_flogi_fabric() or
+ * lpfc_cmpl_els_flogi_nport() shall be invoked accordingly to handle the
+ * specific topology completion conditions.
+ **/
 static void
 lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		    struct lpfc_iocbq *rspiocb)
@@ -618,6 +744,28 @@ out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 }
 
+/**
+ * lpfc_issue_els_flogi: Issue an flogi iocb command for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @retry: number of retries to the command IOCB.
+ *
+ * This routine issues a Fabric Login (FLOGI) Request ELS command
+ * for a @vport. The initiator service parameters are put into the payload
+ * of the FLOGI Request IOCB and the top-level callback function pointer
+ * to lpfc_cmpl_els_flogi() routine is put to the IOCB completion callback
+ * function field. The lpfc_issue_fabric_iocb routine is invoked to send
+ * out FLOGI ELS command with one outstanding fabric IOCB at a time.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the FLOGI ELS command.
+ *
+ * Return code
+ *   0 - successfully issued flogi iocb for @vport
+ *   1 - failed to issue flogi iocb for @vport
+ **/
 static int
 lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		     uint8_t retry)
@@ -694,6 +842,20 @@ lpfc_issue_els_flogi(struct lpfc_vport *
 	return 0;
 }
 
+/**
+ * lpfc_els_abort_flogi: Abort all outstanding flogi iocbs.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine aborts all the outstanding Fabric Login (FLOGI) IOCBs
+ * with a @phba. This routine walks all the outstanding IOCBs on the txcmplq
+ * list and issues an abort IOCB commond on each outstanding IOCB that
+ * contains a active Fabric_DID ndlp. Note that this function is to issue
+ * the abort IOCB command on all the outstanding IOCBs, thus when this
+ * function returns, it does not guarantee all the IOCBs are actually aborted.
+ *
+ * Return code
+ *   0 - Sucessfully issued abort iocb on all outstanding flogis (Always 0)
+ **/
 int
 lpfc_els_abort_flogi(struct lpfc_hba *phba)
 {
@@ -729,6 +891,22 @@ lpfc_els_abort_flogi(struct lpfc_hba *ph
 	return 0;
 }
 
+/**
+ * lpfc_initial_flogi: Issue an initial fabric login for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine issues an initial Fabric Login (FLOGI) for the @vport
+ * specified. It first searches the ndlp with the Fabric_DID (0xfffffe) from
+ * the @vport's ndlp list. If no such ndlp found, it will create an ndlp and
+ * put it into the @vport's ndlp list. If an inactive ndlp found on the list,
+ * it will just be enabled and made active. The lpfc_issue_els_flogi() routine
+ * is then invoked with the @vport and the ndlp to perform the FLOGI for the
+ * @vport.
+ *
+ * Return code
+ *   0 - failed to issue initial flogi for @vport
+ *   1 - successfully issued initial flogi for @vport
+ **/
 int
 lpfc_initial_flogi(struct lpfc_vport *vport)
 {
@@ -764,6 +942,22 @@ lpfc_initial_flogi(struct lpfc_vport *vp
 	return 1;
 }
 
+/**
+ * lpfc_initial_fdisc: Issue an initial fabric discovery for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine issues an initial Fabric Discover (FDISC) for the @vport
+ * specified. It first searches the ndlp with the Fabric_DID (0xfffffe) from
+ * the @vport's ndlp list. If no such ndlp found, it will create an ndlp and
+ * put it into the @vport's ndlp list. If an inactive ndlp found on the list,
+ * it will just be enabled and made active. The lpfc_issue_els_fdisc() routine
+ * is then invoked with the @vport and the ndlp to perform the FDISC for the
+ * @vport.
+ *
+ * Return code
+ *   0 - failed to issue initial fdisc for @vport
+ *   1 - successfully issued initial fdisc for @vport
+ **/
 int
 lpfc_initial_fdisc(struct lpfc_vport *vport)
 {
@@ -797,6 +991,17 @@ lpfc_initial_fdisc(struct lpfc_vport *vp
 	return 1;
 }
 
+/**
+ * lpfc_more_plogi: Check and issue remaining plogis for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine checks whether there are more remaining Port Logins
+ * (PLOGI) to be issued for the @vport. If so, it will invoke the routine
+ * lpfc_els_disc_plogi() to go through the Node Port Recovery (NPR) nodes
+ * to issue ELS PLOGIs up to the configured discover threads with the
+ * @vport (@vport->cfg_discovery_threads). The function also decrement
+ * the @vport's num_disc_node by 1 if it is not already 0.
+ **/
 void
 lpfc_more_plogi(struct lpfc_vport *vport)
 {
@@ -819,6 +1024,37 @@ lpfc_more_plogi(struct lpfc_vport *vport
 	return;
 }
 
+/**
+ * lpfc_plogi_confirm_nport: Confirm pologi wwpn matches stored ndlp.
+ * @phba: pointer to lpfc hba data structure.
+ * @prsp: pointer to response IOCB payload.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine checks and indicates whether the WWPN of an N_Port, retrieved
+ * from a PLOGI, matches the WWPN that is stored in the @ndlp for that N_POrt.
+ * The following cases are considered N_Port confirmed:
+ * 1) The N_Port is a Fabric ndlp; 2) The @ndlp is on vport list and matches
+ * the WWPN of the N_Port logged into; 3) The @ndlp is not on vport list but
+ * it does not have WWPN assigned either. If the WWPN is confirmed, the
+ * pointer to the @ndlp will be returned. If the WWPN is not confirmed:
+ * 1) if there is a node on vport list other than the @ndlp with the same
+ * WWPN of the N_Port PLOGI logged into, the lpfc_unreg_rpi() will be invoked
+ * on that node to release the RPI associated with the node; 2) if there is
+ * no node found on vport list with the same WWPN of the N_Port PLOGI logged
+ * into, a new node shall be allocated (or activated). In either case, the
+ * parameters of the @ndlp shall be copied to the new_ndlp, the @ndlp shall
+ * be released and the new_ndlp shall be put on to the vport node list and
+ * its pointer returned as the confirmed node.
+ *
+ * Note that before the @ndlp got "released", the keepDID from not-matching
+ * or inactive "new_ndlp" on the vport node list is assigned to the nlp_DID
+ * of the @ndlp. This is because the release of @ndlp is actually to put it
+ * into an inactive state on the vport node list and the vport node list
+ * management algorithm does not allow two node with a same DID.
+ *
+ * Return code
+ *   pointer to the PLOGI N_Port @ndlp
+ **/
 static struct lpfc_nodelist *
 lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			 struct lpfc_nodelist *ndlp)
@@ -922,6 +1158,17 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	return new_ndlp;
 }
 
+/**
+ * lpfc_end_rscn: Check and handle more rscn for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine checks whether more Registration State Change
+ * Notifications (RSCNs) came in while the discovery state machine was in
+ * the FC_RSCN_MODE. If so, the lpfc_els_handle_rscn() routine will be
+ * invoked to handle the additional RSCNs for the @vport. Otherwise, the
+ * FC_RSCN_MODE bit will be cleared with the @vport to mark as the end of
+ * handling the RSCNs.
+ **/
 void
 lpfc_end_rscn(struct lpfc_vport *vport)
 {
@@ -943,6 +1190,26 @@ lpfc_end_rscn(struct lpfc_vport *vport)
 	}
 }
 
+/**
+ * lpfc_cmpl_els_plogi: Completion callback function for plogi.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is the completion callback function for issuing the Port
+ * Login (PLOGI) command. For PLOGI completion, there must be an active
+ * ndlp on the vport node list that matches the remote node ID from the
+ * PLOGI reponse IOCB. If such ndlp does not exist, the PLOGI is simply
+ * ignored and command IOCB released. The PLOGI response IOCB status is
+ * checked for error conditons. If there is error status reported, PLOGI
+ * retry shall be attempted by invoking the lpfc_els_retry() routine.
+ * Otherwise, the lpfc_plogi_confirm_nport() routine shall be invoked on
+ * the ndlp and the NLP_EVT_CMPL_PLOGI state to the Discover State Machine
+ * (DSM) is set for this PLOGI completion. Finally, it checks whether
+ * there are additional N_Port nodes with the vport that need to perform
+ * PLOGI. If so, the lpfc_more_plogi() routine is invoked to issue addition
+ * PLOGIs.
+ **/
 static void
 lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		    struct lpfc_iocbq *rspiocb)
@@ -1048,6 +1315,27 @@ out:
 	return;
 }
 
+/**
+ * lpfc_issue_els_plogi: Issue an plogi iocb command for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @did: destination port identifier.
+ * @retry: number of retries to the command IOCB.
+ *
+ * This routine issues a Port Login (PLOGI) command to a remote N_Port
+ * (with the @did) for a @vport. Before issuing a PLOGI to a remote N_Port,
+ * the ndlp with the remote N_Port DID must exist on the @vport's ndlp list.
+ * This routine constructs the proper feilds of the PLOGI IOCB and invokes
+ * the lpfc_sli_issue_iocb() routine to send out PLOGI ELS command.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the PLOGI ELS command.
+ *
+ * Return code
+ *   0 - Successfully issued a plogi for @vport
+ *   1 - failed to issue a plogi for @vport
+ **/
 int
 lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 {
@@ -1106,6 +1394,19 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 	return 0;
 }
 
+/**
+ * lpfc_cmpl_els_prli: Completion callback function for prli.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is the completion callback function for a Process Login
+ * (PRLI) ELS command. The PRLI response IOCB status is checked for error
+ * status. If there is error status reported, PRLI retry shall be attempted
+ * by invoking the lpfc_els_retry() routine. Otherwise, the state
+ * NLP_EVT_CMPL_PRLI is sent to the Discover State Machine (DSM) for this
+ * ndlp to mark the PRLI completion.
+ **/
 static void
 lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		   struct lpfc_iocbq *rspiocb)
@@ -1164,6 +1465,27 @@ out:
 	return;
 }
 
+/**
+ * lpfc_issue_els_prli: Issue a prli iocb command for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @retry: number of retries to the command IOCB.
+ *
+ * This routine issues a Process Login (PRLI) ELS command for the
+ * @vport. The PRLI service parameters are set up in the payload of the
+ * PRLI Request command and the pointer to lpfc_cmpl_els_prli() routine
+ * is put to the IOCB completion callback func field before invoking the
+ * routine lpfc_sli_issue_iocb() to send out PRLI command.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the PRLI ELS command.
+ *
+ * Return code
+ *   0 - successfully issued prli iocb command for @vport
+ *   1 - failed to issue prli iocb command for @vport
+ **/
 int
 lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		    uint8_t retry)
@@ -1233,6 +1555,15 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 	return 0;
 }
 
+/**
+ * lpfc_more_adisc: Issue more adisc as needed.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine determines whether there are more ndlps on a @vport
+ * node list need to have Address Discover (ADISC) issued. If so, it will
+ * invoke the lpfc_els_disc_adisc() routine to issue ADISC on the @vport's
+ * remaining nodes which need to have ADISC sent.
+ **/
 void
 lpfc_more_adisc(struct lpfc_vport *vport)
 {
@@ -1255,6 +1586,18 @@ lpfc_more_adisc(struct lpfc_vport *vport
 	return;
 }
 
+/**
+ * lpfc_rscn_disc: Perform rscn discovery for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine performs Registration State Change Notification (RSCN)
+ * discovery for a @vport. If the @vport's node port recovery count is not
+ * zero, it will invoke the lpfc_els_disc_plogi() to perform PLOGI for all
+ * the nodes that need recovery. If none of the PLOGI were needed through
+ * the lpfc_els_disc_plogi() routine, the lpfc_end_rscn() routine shall be
+ * invoked to check and handle possible more RSCN came in during the period
+ * of processing the current ones.
+ **/
 static void
 lpfc_rscn_disc(struct lpfc_vport *vport)
 {
@@ -1269,6 +1612,22 @@ lpfc_rscn_disc(struct lpfc_vport *vport)
 	lpfc_end_rscn(vport);
 }
 
+/**
+ * lpfc_cmpl_els_adisc: Completion callback function for adisc.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is the completion function for issuing the Address Discover
+ * (ADISC) command. It first checks to see whether link went down during
+ * the discovery process. If so, the node will be marked as node port
+ * recovery for issuing discover IOCB by the link attention handler and
+ * exit. Otherwise, the response status is checked. If error was reported
+ * in the response status, the ADISC command shall be retried by invoking
+ * the lpfc_els_retry() routine. Otherwise, if no error was reported in
+ * the response status, the state machine is invoked to set transition
+ * with respect to NLP_EVT_CMPL_ADISC event.
+ **/
 static void
 lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		    struct lpfc_iocbq *rspiocb)
@@ -1384,6 +1743,26 @@ out:
 	return;
 }
 
+/**
+ * lpfc_issue_els_adisc: Issue an address discover iocb to an node on a vport.
+ * @vport: pointer to a virtual N_Port data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @retry: number of retries to the command IOCB.
+ *
+ * This routine issues an Address Discover (ADISC) for an @ndlp on a
+ * @vport. It prepares the payload of the ADISC ELS command, updates the
+ * and states of the ndlp, and invokes the lpfc_sli_issue_iocb() routine
+ * to issue the ADISC ELS command.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the ADISC ELS command.
+ *
+ * Return code
+ *   0 - successfully issued adisc
+ *   1 - failed to issue adisc
+ **/
 int
 lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		     uint8_t retry)
@@ -1437,6 +1816,18 @@ lpfc_issue_els_adisc(struct lpfc_vport *
 	return 0;
 }
 
+/**
+ * lpfc_cmpl_els_logo: Completion callback function for logo.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is the completion function for issuing the ELS Logout (LOGO)
+ * command. If no error status was reported from the LOGO response, the
+ * state machine of the associated ndlp shall be invoked for transition with
+ * respect to NLP_EVT_CMPL_LOGO event. Otherwise, if error status was reported,
+ * the lpfc_els_retry() routine will be invoked to retry the LOGO command.
+ **/
 static void
 lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		   struct lpfc_iocbq *rspiocb)
@@ -1502,6 +1893,26 @@ out:
 	return;
 }
 
+/**
+ * lpfc_issue_els_logo: Issue a logo to an node on a vport.
+ * @vport: pointer to a virtual N_Port data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @retry: number of retries to the command IOCB.
+ *
+ * This routine constructs and issues an ELS Logout (LOGO) iocb command
+ * to a remote node, referred by an @ndlp on a @vport. It constructs the
+ * payload of the IOCB, properly sets up the @ndlp state, and invokes the
+ * lpfc_sli_issue_iocb() routine to send out the LOGO ELS command.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the LOGO ELS command.
+ *
+ * Return code
+ *   0 - successfully issued logo
+ *   1 - failed to issue logo
+ **/
 int
 lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		    uint8_t retry)
@@ -1563,6 +1974,22 @@ lpfc_issue_els_logo(struct lpfc_vport *v
 	return 0;
 }
 
+/**
+ * lpfc_cmpl_els_cmd: Completion callback function for generic els command.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is a generic completion callback function for ELS commands.
+ * Specifically, it is the callback function which does not need to perform
+ * any command specific operations. It is currently used by the ELS command
+ * issuing routines for the ELS State Change  Request (SCR),
+ * lpfc_issue_els_scr(), and the ELS Fibre Channel Address Resolution
+ * Protocol Response (FARPR) routine, lpfc_issue_els_farpr(). Other than
+ * certain debug loggings, this callback function simply invokes the
+ * lpfc_els_chk_latt() routine to check whether link went down during the
+ * discovery process.
+ **/
 static void
 lpfc_cmpl_els_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		  struct lpfc_iocbq *rspiocb)
@@ -1587,6 +2014,28 @@ lpfc_cmpl_els_cmd(struct lpfc_hba *phba,
 	return;
 }
 
+/**
+ * lpfc_issue_els_scr: Issue a scr to an node on a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @nportid: N_Port identifier to the remote node.
+ * @retry: number of retries to the command IOCB.
+ *
+ * This routine issues a State Change Request (SCR) to a fabric node
+ * on a @vport. The remote node @nportid is passed into the function. It
+ * first search the @vport node list to find the matching ndlp. If no such
+ * ndlp is found, a new ndlp shall be created for this (SCR) purpose. An
+ * IOCB is allocated, payload prepared, and the lpfc_sli_issue_iocb()
+ * routine is invoked to send the SCR IOCB.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the SCR ELS command.
+ *
+ * Return code
+ *   0 - Successfully issued scr command
+ *   1 - Failed to issue scr command
+ **/
 int
 lpfc_issue_els_scr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 {
@@ -1659,6 +2108,28 @@ lpfc_issue_els_scr(struct lpfc_vport *vp
 	return 0;
 }
 
+/**
+ * lpfc_issue_els_farpr: Issue a farp to an node on a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @nportid: N_Port identifier to the remote node.
+ * @retry: number of retries to the command IOCB.
+ *
+ * This routine issues a Fibre Channel Address Resolution Response
+ * (FARPR) to a node on a vport. The remote node N_Port identifier (@nportid)
+ * is passed into the function. It first search the @vport node list to find
+ * the matching ndlp. If no such ndlp is found, a new ndlp shall be created
+ * for this (FARPR) purpose. An IOCB is allocated, payload prepared, and the
+ * lpfc_sli_issue_iocb() routine is invoked to send the FARPR ELS command.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the PARPR ELS command.
+ *
+ * Return code
+ *   0 - Successfully issued farpr command
+ *   1 - Failed to issue farpr command
+ **/
 static int
 lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 {
@@ -1748,6 +2219,18 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 	return 0;
 }
 
+/**
+ * lpfc_cancel_retry_delay_tmo: Cancel the timer with delayed iocb-cmd retry.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @nlp: pointer to a node-list data structure.
+ *
+ * This routine cancels the timer with a delayed IOCB-command retry for
+ * a @vport's @ndlp. It stops the timer for the delayed function retrial and
+ * removes the ELS retry event if it presents. In addition, if the
+ * NLP_NPR_2B_DISC bit is set in the @nlp's nlp_flag bitmap, ADISC IOCB
+ * commands are sent for the @vport's nodes that require issuing discovery
+ * ADISC.
+ **/
 void
 lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct lpfc_nodelist *nlp)
 {
@@ -1794,6 +2277,20 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_
 	return;
 }
 
+/**
+ * lpfc_els_retry_delay: Timer function with a ndlp delayed function timer.
+ * @ptr: holder for the pointer to the timer function associated data (ndlp).
+ *
+ * This routine is invoked by the ndlp delayed-function timer to check
+ * whether there is any pending ELS retry event(s) with the node. If not, it
+ * simply returns. Otherwise, if there is at least one ELS delayed event, it
+ * adds the delayed events to the HBA work list and invokes the
+ * lpfc_worker_wake_up() routine to wake up worker thread to process the
+ * event. Note that lpfc_nlp_get() is called before posting the event to
+ * the work list to hold reference count of ndlp so that it guarantees the
+ * reference to ndlp will still be available when the worker thread gets
+ * to the event associated with the ndlp.
+ **/
 void
 lpfc_els_retry_delay(unsigned long ptr)
 {
@@ -1822,6 +2319,15 @@ lpfc_els_retry_delay(unsigned long ptr)
 	return;
 }
 
+/**
+ * lpfc_els_retry_delay_handler: Work thread handler for ndlp delayed function.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine is the worker-thread handler for processing the @ndlp delayed
+ * event(s), posted by the lpfc_els_retry_delay() routine. It simply retrieves
+ * the last ELS command from the associated ndlp and invokes the proper ELS
+ * function according to the delayed ELS command to retry the command.
+ **/
 void
 lpfc_els_retry_delay_handler(struct lpfc_nodelist *ndlp)
 {
@@ -1884,6 +2390,27 @@ lpfc_els_retry_delay_handler(struct lpfc
 	return;
 }
 
+/**
+ * lpfc_els_retry: Make retry decision on an els command iocb.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine makes a retry decision on an ELS command IOCB, which has
+ * failed. The following ELS IOCBs use this function for retrying the command
+ * when previously issued command responsed with error status: FLOGI, PLOGI,
+ * PRLI, ADISC, LOGO, and FDISC. Based on the ELS command type and the
+ * returned error status, it makes the decision whether a retry shall be
+ * issued for the command, and whether a retry shall be made immediately or
+ * delayed. In the former case, the corresponding ELS command issuing-function
+ * is called to retry the command. In the later case, the ELS command shall
+ * be posted to the ndlp delayed event and delayed function timer set to the
+ * ndlp for the delayed command issusing.
+ *
+ * Return code
+ *   0 - No retry of els command is made
+ *   1 - Immediate or delayed retry of els command is made
+ **/
 static int
 lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	       struct lpfc_iocbq *rspiocb)
@@ -2182,12 +2709,26 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 	return 0;
 }
 
+/**
+ * lpfc_els_free_data: Free lpfc dma buffer and data structure with an iocb.
+ * @phba: pointer to lpfc hba data structure.
+ * @buf_ptr1: pointer to the lpfc DMA buffer data structure.
+ *
+ * This routine releases the lpfc DMA (Direct Memory Access) buffer(s)
+ * associated with a command IOCB back to the lpfc DMA buffer pool. It first
+ * checks to see whether there is a lpfc DMA buffer associated with the
+ * response of the command IOCB. If so, it will be released before releasing
+ * the lpfc DMA buffer associated with the IOCB itself.
+ *
+ * Return code
+ *   0 - Successfully released lpfc DMA buffer (currently, always return 0)
+ **/
 static int
 lpfc_els_free_data(struct lpfc_hba *phba, struct lpfc_dmabuf *buf_ptr1)
 {
 	struct lpfc_dmabuf *buf_ptr;
 
-	/* Free the response before processing the command.  */
+	/* Free the response before processing the command. */
 	if (!list_empty(&buf_ptr1->list)) {
 		list_remove_head(&buf_ptr1->list, buf_ptr,
 				 struct lpfc_dmabuf,
@@ -2200,6 +2741,18 @@ lpfc_els_free_data(struct lpfc_hba *phba
 	return 0;
 }
 
+/**
+ * lpfc_els_free_bpl: Free lpfc dma buffer and data structure with bpl.
+ * @phba: pointer to lpfc hba data structure.
+ * @buf_ptr: pointer to the lpfc dma buffer data structure.
+ *
+ * This routine releases the lpfc Direct Memory Access (DMA) buffer
+ * associated with a Buffer Pointer List (BPL) back to the lpfc DMA buffer
+ * pool.
+ *
+ * Return code
+ *   0 - Successfully released lpfc DMA buffer (currently, always return 0)
+ **/
 static int
 lpfc_els_free_bpl(struct lpfc_hba *phba, struct lpfc_dmabuf *buf_ptr)
 {
@@ -2208,6 +2761,33 @@ lpfc_els_free_bpl(struct lpfc_hba *phba,
 	return 0;
 }
 
+/**
+ * lpfc_els_free_iocb: Free a command iocb and its associated resources.
+ * @phba: pointer to lpfc hba data structure.
+ * @elsiocb: pointer to lpfc els command iocb data structure.
+ *
+ * This routine frees a command IOCB and its associated resources. The
+ * command IOCB data structure contains the reference to various associated
+ * resources, these fields must be set to NULL if the associated reference
+ * not present:
+ *   context1 - reference to ndlp
+ *   context2 - reference to cmd
+ *   context2->next - reference to rsp
+ *   context3 - reference to bpl
+ *
+ * It first properly decrements the reference count held on ndlp for the
+ * IOCB completion callback function. If LPFC_DELAY_MEM_FREE flag is not
+ * set, it invokes the lpfc_els_free_data() routine to release the Direct
+ * Memory Access (DMA) buffers associated with the IOCB. Otherwise, it
+ * adds the DMA buffer the @phba data structure for the delayed release.
+ * If reference to the Buffer Pointer List (BPL) is present, the
+ * lpfc_els_free_bpl() routine is invoked to release the DMA memory
+ * associated with BPL. Finally, the lpfc_sli_release_iocbq() routine is
+ * invoked to release the IOCB data structure back to @phba IOCBQ list.
+ *
+ * Return code
+ *   0 - Success (currently, always return 0)
+ **/
 int
 lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 {
@@ -2274,6 +2854,23 @@ lpfc_els_free_iocb(struct lpfc_hba *phba
 	return 0;
 }
 
+/**
+ * lpfc_cmpl_els_logo_acc: Completion callback function to logo acc response.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is the completion callback function to the Logout (LOGO)
+ * Accept (ACC) Response ELS command. This routine is invoked to indicate
+ * the completion of the LOGO process. It invokes the lpfc_nlp_not_used() to
+ * release the ndlp if it has the last reference remaining (reference count
+ * is 1). If succeeded (meaning ndlp released), it sets the IOCB context1
+ * field to NULL to inform the following lpfc_els_free_iocb() routine no
+ * ndlp reference count needs to be decremented. Otherwise, the ndlp
+ * reference use-count shall be decremented by the lpfc_els_free_iocb()
+ * routine. Finally, the lpfc_els_free_iocb() is invoked to release the
+ * IOCB data structure.
+ **/
 static void
 lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		       struct lpfc_iocbq *rspiocb)
@@ -2311,6 +2908,19 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 	return;
 }
 
+/**
+ * lpfc_mbx_cmpl_dflt_rpi: Completion callbk func for unreg dflt rpi mbox cmd.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * This routine is the completion callback function for unregister default
+ * RPI (Remote Port Index) mailbox command to the @phba. It simply releases
+ * the associated lpfc Direct Memory Access (DMA) buffer back to the pool and
+ * decrements the ndlp reference count held for this completion callback
+ * function. After that, it invokes the lpfc_nlp_not_used() to check
+ * whether there is only one reference left on the ndlp. If so, it will
+ * perform one more decrement and trigger the release of the ndlp.
+ **/
 void
 lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
@@ -2332,6 +2942,22 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 	return;
 }
 
+/**
+ * lpfc_cmpl_els_rsp: Completion callback function for els response iocb cmd.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is the completion callback function for ELS Response IOCB
+ * command. In normal case, this callback function just properly sets the
+ * nlp_flag bitmap in the ndlp data structure, if the mbox command reference
+ * field in the command IOCB is not NULL, the referred mailbox command will
+ * be send out, and then invokes the lpfc_els_free_iocb() routine to release
+ * the IOCB. Under error conditions, such as when a LS_RJT is returned or a
+ * link down event occurred during the discovery, the lpfc_nlp_not_used()
+ * routine shall be invoked trying to release the ndlp if no other threads
+ * are currently referring it.
+ **/
 static void
 lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		  struct lpfc_iocbq *rspiocb)
@@ -2487,6 +3113,31 @@ out:
 	return;
 }
 
+/**
+ * lpfc_els_rsp_acc: Prepare and issue an acc response iocb command.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @flag: the els command code to be accepted.
+ * @oldiocb: pointer to the original lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @mbox: pointer to the driver internal queue element for mailbox command.
+ *
+ * This routine prepares and issues an Accept (ACC) response IOCB
+ * command. It uses the @flag to properly set up the IOCB field for the
+ * specific ACC response command to be issued and invokes the
+ * lpfc_sli_issue_iocb() routine to send out ACC response IOCB. If a
+ * @mbox pointer is passed in, it will be put into the context_un.mbox
+ * field of the IOCB for the completion callback function to issue the
+ * mailbox command to the HBA later when callback is invoked.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the corresponding response ELS IOCB command.
+ *
+ * Return code
+ *   0 - Successfully issued acc response
+ *   1 - Failed to issue acc response
+ **/
 int
 lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		 struct lpfc_iocbq *oldiocb, struct lpfc_nodelist *ndlp,
@@ -2601,6 +3252,28 @@ lpfc_els_rsp_acc(struct lpfc_vport *vpor
 	return 0;
 }
 
+/**
+ * lpfc_els_rsp_reject: Propare and issue a rjt response iocb command.
+ * @vport: pointer to a virtual N_Port data structure.
+ * @rejectError:
+ * @oldiocb: pointer to the original lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @mbox: pointer to the driver internal queue element for mailbox command.
+ *
+ * This routine prepares and issue an Reject (RJT) response IOCB
+ * command. If a @mbox pointer is passed in, it will be put into the
+ * context_un.mbox field of the IOCB for the completion callback function
+ * to issue to the HBA later.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the reject response ELS IOCB command.
+ *
+ * Return code
+ *   0 - Successfully issued reject response
+ *   1 - Failed to issue reject response
+ **/
 int
 lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 		    struct lpfc_iocbq *oldiocb, struct lpfc_nodelist *ndlp,
@@ -2660,6 +3333,25 @@ lpfc_els_rsp_reject(struct lpfc_vport *v
 	return 0;
 }
 
+/**
+ * lpfc_els_rsp_adisc_acc: Prepare and issue acc response to adisc iocb cmd.
+ * @vport: pointer to a virtual N_Port data structure.
+ * @oldiocb: pointer to the original lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine prepares and issues an Accept (ACC) response to Address
+ * Discover (ADISC) ELS command. It simply prepares the payload of the IOCB
+ * and invokes the lpfc_sli_issue_iocb() routine to send out the command.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the ADISC Accept response ELS IOCB command.
+ *
+ * Return code
+ *   0 - Successfully issued acc adisc response
+ *   1 - Failed to issue adisc acc response
+ **/
 int
 lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		       struct lpfc_nodelist *ndlp)
@@ -2716,6 +3408,25 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport
 	return 0;
 }
 
+/**
+ * lpfc_els_rsp_prli_acc: Prepare and issue acc response to prli iocb cmd.
+ * @vport: pointer to a virtual N_Port data structure.
+ * @oldiocb: pointer to the original lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine prepares and issues an Accept (ACC) response to Process
+ * Login (PRLI) ELS command. It simply prepares the payload of the IOCB
+ * and invokes the lpfc_sli_issue_iocb() routine to send out the command.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the PRLI Accept response ELS IOCB command.
+ *
+ * Return code
+ *   0 - Successfully issued acc prli response
+ *   1 - Failed to issue acc prli response
+ **/
 int
 lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		      struct lpfc_nodelist *ndlp)
@@ -2795,6 +3506,32 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport 
 	return 0;
 }
 
+/**
+ * lpfc_els_rsp_rnid_acc: Issue rnid acc response iocb command.
+ * @vport: pointer to a virtual N_Port data structure.
+ * @format: rnid command format.
+ * @oldiocb: pointer to the original lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine issues a Request Node Identification Data (RNID) Accept
+ * (ACC) response. It constructs the RNID ACC response command according to
+ * the proper @format and then calls the lpfc_sli_issue_iocb() routine to
+ * issue the response. Note that this command does not need to hold the ndlp
+ * reference count for the callback. So, the ndlp reference count taken by
+ * the lpfc_prep_els_iocb() routine is put back and the context1 field of
+ * IOCB is set to NULL to indicate to the lpfc_els_free_iocb() routine that
+ * there is no ndlp reference available.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function. However, for the RNID Accept Response ELS command,
+ * this is undone later by this routine after the IOCB is allocated.
+ *
+ * Return code
+ *   0 - Successfully issued acc rnid response
+ *   1 - Failed to issue acc rnid response
+ **/
 static int
 lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 		      struct lpfc_iocbq *oldiocb, struct lpfc_nodelist *ndlp)
@@ -2875,6 +3612,25 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport 
 	return 0;
 }
 
+/**
+ * lpfc_els_disc_adisc: Issue remaining adisc iocbs to npr nodes of a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine issues Address Discover (ADISC) ELS commands to those
+ * N_Ports which are in node port recovery state and ADISC has not been issued
+ * for the @vport. Each time an ELS ADISC IOCB is issued by invoking the
+ * lpfc_issue_els_adisc() routine, the per @vport number of discover count
+ * (num_disc_nodes) shall be incremented. If the num_disc_nodes reaches a
+ * pre-configured threshold (cfg_discovery_threads), the @vport fc_flag will
+ * be marked with FC_NLP_MORE bit and the process of issuing remaining ADISC
+ * IOCBs quit for later pick up. On the other hand, after walking through
+ * all the ndlps with the @vport and there is none ADISC IOCB issued, the
+ * @vport fc_flag shall be cleared with FC_NLP_MORE bit indicating there is
+ * no more ADISC need to be sent.
+ *
+ * Return code
+ *    The number of N_Ports with adisc issued.
+ **/
 int
 lpfc_els_disc_adisc(struct lpfc_vport *vport)
 {
@@ -2914,6 +3670,25 @@ lpfc_els_disc_adisc(struct lpfc_vport *v
 	return sentadisc;
 }
 
+/**
+ * lpfc_els_disc_plogi: Issue plogi for all npr nodes of a vport before adisc.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine issues Port Login (PLOGI) ELS commands to all the N_Ports
+ * which are in node port recovery state, with a @vport. Each time an ELS
+ * ADISC PLOGI IOCB is issued by invoking the lpfc_issue_els_plogi() routine,
+ * the per @vport number of discover count (num_disc_nodes) shall be
+ * incremented. If the num_disc_nodes reaches a pre-configured threshold
+ * (cfg_discovery_threads), the @vport fc_flag will be marked with FC_NLP_MORE
+ * bit set and quit the process of issuing remaining ADISC PLOGIN IOCBs for
+ * later pick up. On the other hand, after walking through all the ndlps with
+ * the @vport and there is none ADISC PLOGI IOCB issued, the @vport fc_flag
+ * shall be cleared with the FC_NLP_MORE bit indicating there is no more ADISC
+ * PLOGI need to be sent.
+ *
+ * Return code
+ *   The number of N_Ports with plogi issued.
+ **/
 int
 lpfc_els_disc_plogi(struct lpfc_vport *vport)
 {
@@ -2954,6 +3729,15 @@ lpfc_els_disc_plogi(struct lpfc_vport *v
 	return sentplogi;
 }
 
+/**
+ * lpfc_els_flush_rscn: Clean up any rscn activities with a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine cleans up any Registration State Change Notification
+ * (RSCN) activity with a @vport. Note that the fc_rscn_flush flag of the
+ * @vport together with the host_lock is used to prevent multiple thread
+ * trying to access the RSCN array on a same @vport at the same time.
+ **/
 void
 lpfc_els_flush_rscn(struct lpfc_vport *vport)
 {
@@ -2984,6 +3768,18 @@ lpfc_els_flush_rscn(struct lpfc_vport *v
 	vport->fc_rscn_flush = 0;
 }
 
+/**
+ * lpfc_rscn_payload_check: Check whether there is a pending rscn to a did.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @did: remote destination port identifier.
+ *
+ * This routine checks whether there is any pending Registration State
+ * Configuration Notification (RSCN) to a @did on @vport.
+ *
+ * Return code
+ *   None zero - The @did matched with a pending rscn
+ *   0 - not able to match @did with a pending rscn
+ **/
 int
 lpfc_rscn_payload_check(struct lpfc_vport *vport, uint32_t did)
 {
@@ -3053,6 +3849,17 @@ return_did_out:
 	return did;
 }
 
+/**
+ * lpfc_rscn_recovery_check: Send recovery event to vport nodes matching rscn
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine sends recovery (NLP_EVT_DEVICE_RECOVERY) event to the
+ * state machine for a @vport's nodes that are with pending RSCN (Registration
+ * State Change Notification).
+ *
+ * Return code
+ *   0 - Successful (currently alway return 0)
+ **/
 static int
 lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 {
@@ -3071,6 +3878,28 @@ lpfc_rscn_recovery_check(struct lpfc_vpo
 	return 0;
 }
 
+/**
+ * lpfc_els_rcv_rscn: Process an unsolicited rscn iocb.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes an unsolicited RSCN (Registration State Change
+ * Notification) IOCB. First, the payload of the unsolicited RSCN is walked
+ * to invoke fc_host_post_event() routine to the FC transport layer. If the
+ * discover state machine is about to begin discovery, it just accepts the
+ * RSCN and the discovery process will satisfy the RSCN. If this RSCN only
+ * contains N_Port IDs for other vports on this HBA, it just accepts the
+ * RSCN and ignore processing it. If the state machine is in the recovery
+ * state, the fc_rscn_id_list of this @vport is walked and the
+ * lpfc_rscn_recovery_check() routine is invoked to send recovery event for
+ * all nodes that match RSCN payload. Otherwise, the lpfc_els_handle_rscn()
+ * routine is invoked to handle the RSCN event.
+ *
+ * Return code
+ *   0 - Just sent the acc response
+ *   1 - Sent the acc response and waited for name server completion
+ **/
 static int
 lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		  struct lpfc_nodelist *ndlp)
@@ -3241,6 +4070,22 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 	return lpfc_els_handle_rscn(vport);
 }
 
+/**
+ * lpfc_els_handle_rscn: Handle rscn for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine handles the Registration State Configuration Notification
+ * (RSCN) for a @vport. If login to NameServer does not exist, a new ndlp shall
+ * be created and a Port Login (PLOGI) to the NameServer is issued. Otherwise,
+ * if the ndlp to NameServer exists, a Common Transport (CT) command to the
+ * NameServer shall be issued. If CT command to the NameServer fails to be
+ * issued, the lpfc_els_flush_rscn() routine shall be invoked to clean up any
+ * RSCN activities with the @vport.
+ *
+ * Return code
+ *   0 - Cleaned up rscn on the @vport
+ *   1 - Wait for plogi to name server before proceed
+ **/
 int
 lpfc_els_handle_rscn(struct lpfc_vport *vport)
 {
@@ -3313,6 +4158,31 @@ lpfc_els_handle_rscn(struct lpfc_vport *
 	return 0;
 }
 
+/**
+ * lpfc_els_rcv_flogi: Process an unsolicited flogi iocb.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes Fabric Login (FLOGI) IOCB received as an ELS
+ * unsolicited event. An unsolicited FLOGI can be received in a point-to-
+ * point topology. As an unsolicited FLOGI should not be received in a loop
+ * mode, any unsolicited FLOGI received in loop mode shall be ignored. The
+ * lpfc_check_sparm() routine is invoked to check the parameters in the
+ * unsolicited FLOGI. If parameters validation failed, the routine
+ * lpfc_els_rsp_reject() shall be called with reject reason code set to
+ * LSEXP_SPARM_OPTIONS to reject the FLOGI. Otherwise, the Port WWN in the
+ * FLOGI shall be compared with the Port WWN of the @vport to determine who
+ * will initiate PLOGI. The higher lexicographical value party shall has
+ * higher priority (as the winning port) and will initiate PLOGI and
+ * communicate Port_IDs (Addresses) for both nodes in PLOGI. The result
+ * of this will be marked in the @vport fc_flag field with FC_PT2PT_PLOGI
+ * and then the lpfc_els_rsp_acc() routine is invoked to accept the FLOGI.
+ *
+ * Return code
+ *   0 - Successfully processed the unsolicited flogi
+ *   1 - Failed to process the unsolicited flogi
+ **/
 static int
 lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		   struct lpfc_nodelist *ndlp)
@@ -3402,6 +4272,22 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vp
 	return 0;
 }
 
+/**
+ * lpfc_els_rcv_rnid: Process an unsolicited rnid iocb.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes Request Node Identification Data (RNID) IOCB
+ * received as an ELS unsolicited event. Only when the RNID specified format
+ * 0x0 or 0xDF (Topology Discovery Specific Node Identification Data)
+ * present, this routine will invoke the lpfc_els_rsp_rnid_acc() routine to
+ * Accept (ACC) the RNID ELS command. All the other RNID formats are
+ * rejected by invoking the lpfc_els_rsp_reject() routine.
+ *
+ * Return code
+ *   0 - Successfully processed rnid iocb (currently always return 0)
+ **/
 static int
 lpfc_els_rcv_rnid(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		  struct lpfc_nodelist *ndlp)
@@ -3441,6 +4327,19 @@ lpfc_els_rcv_rnid(struct lpfc_vport *vpo
 	return 0;
 }
 
+/**
+ * lpfc_els_rcv_lirr: Process an unsolicited lirr iocb.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes a Link Incident Report Registration(LIRR) IOCB
+ * received as an ELS unsolicited event. Currently, this function just invokes
+ * the lpfc_els_rsp_reject() routine to reject the LIRR IOCB unconditionally.
+ *
+ * Return code
+ *   0 - Successfully processed lirr iocb (currently always return 0)
+ **/
 static int
 lpfc_els_rcv_lirr(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		  struct lpfc_nodelist *ndlp)
@@ -3456,6 +4355,25 @@ lpfc_els_rcv_lirr(struct lpfc_vport *vpo
 	return 0;
 }
 
+/**
+ * lpfc_els_rsp_rps_acc: Completion callbk func for MBX_READ_LNK_STAT mbox cmd.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * This routine is the completion callback function for the MBX_READ_LNK_STAT
+ * mailbox command. This callback function is to actually send the Accept
+ * (ACC) response to a Read Port Status (RPS) unsolicited IOCB event. It
+ * collects the link statistics from the completion of the MBX_READ_LNK_STAT
+ * mailbox command, constructs the RPS response with the link statistics
+ * collected, and then invokes the lpfc_sli_issue_iocb() routine to send ACC
+ * response to the RPS.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the RPS Accept Response ELS IOCB command.
+ *
+ **/
 static void
 lpfc_els_rsp_rps_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
@@ -3531,6 +4449,24 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *ph
 	return;
 }
 
+/**
+ * lpfc_els_rcv_rps: Process an unsolicited rps iocb.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes Read Port Status (RPS) IOCB received as an
+ * ELS unsolicited event. It first checks the remote port state. If the
+ * remote port is not in NLP_STE_UNMAPPED_NODE state or NLP_STE_MAPPED_NODE
+ * state, it invokes the lpfc_els_rsp_reject() routine to send the reject
+ * response. Otherwise, it issue the MBX_READ_LNK_STAT mailbox command
+ * for reading the HBA link statistics. It is for the callback function,
+ * lpfc_els_rsp_rps_acc(), set to the MBX_READ_LNK_STAT mailbox command
+ * to actually sending out RPS Accept (ACC) response.
+ *
+ * Return codes
+ *   0 - Successfully processed rps iocb (currently always return 0)
+ **/
 static int
 lpfc_els_rcv_rps(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		 struct lpfc_nodelist *ndlp)
@@ -3592,6 +4528,25 @@ lpfc_els_rcv_rps(struct lpfc_vport *vpor
 	return 0;
 }
 
+/**
+ * lpfc_els_rsp_rpl_acc: Issue an accept rpl els command.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdsize: size of the ELS command.
+ * @oldiocb: pointer to the original lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine issuees an Accept (ACC) Read Port List (RPL) ELS command.
+ * It is to be called by the lpfc_els_rcv_rpl() routine to accept the RPL.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the RPL Accept Response ELS command.
+ *
+ * Return code
+ *   0 - Successfully issued ACC RPL ELS command
+ *   1 - Failed to issue ACC RPL ELS command
+ **/
 static int
 lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 		     struct lpfc_iocbq *oldiocb, struct lpfc_nodelist *ndlp)
@@ -3645,6 +4600,22 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *
 	return 0;
 }
 
+/**
+ * lpfc_els_rcv_rpl: Process an unsolicited rpl iocb.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes Read Port List (RPL) IOCB received as an ELS
+ * unsolicited event. It first checks the remote port state. If the remote
+ * port is not in NLP_STE_UNMAPPED_NODE and NLP_STE_MAPPED_NODE states, it
+ * invokes the lpfc_els_rsp_reject() routine to send reject response.
+ * Otherwise, this routine then invokes the lpfc_els_rsp_rpl_acc() routine
+ * to accept the RPL.
+ *
+ * Return code
+ *   0 - Successfully processed rpl iocb (currently always return 0)
+ **/
 static int
 lpfc_els_rcv_rpl(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		 struct lpfc_nodelist *ndlp)
@@ -3685,6 +4656,30 @@ lpfc_els_rcv_rpl(struct lpfc_vport *vpor
 	return 0;
 }
 
+/**
+ * lpfc_els_rcv_farp: Process an unsolicited farp request els command.
+ * @vport: pointer to a virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes Fibre Channel Address Resolution Protocol
+ * (FARP) Request IOCB received as an ELS unsolicited event. Currently,
+ * the lpfc driver only supports matching on WWPN or WWNN for FARP. As such,
+ * FARP_MATCH_PORT flag and FARP_MATCH_NODE flag are checked against the
+ * Match Flag in the FARP request IOCB: if FARP_MATCH_PORT flag is set, the
+ * remote PortName is compared against the FC PortName stored in the @vport
+ * data structure; if FARP_MATCH_NODE flag is set, the remote NodeName is
+ * compared against the FC NodeName stored in the @vport data structure.
+ * If any of these matches and the FARP_REQUEST_FARPR flag is set in the
+ * FARP request IOCB Response Flag, the lpfc_issue_els_farpr() routine is
+ * invoked to send out FARP Response to the remote node. Before sending the
+ * FARP Response, however, the FARP_REQUEST_PLOGI flag is check in the FARP
+ * request IOCB Response Flag and, if it is set, the lpfc_issue_els_plogi()
+ * routine is invoked to log into the remote port first.
+ *
+ * Return code
+ *   0 - Either the FARP Match Mode not supported or successfully processed
+ **/
 static int
 lpfc_els_rcv_farp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		  struct lpfc_nodelist *ndlp)
@@ -3744,6 +4739,20 @@ lpfc_els_rcv_farp(struct lpfc_vport *vpo
 	return 0;
 }
 
+/**
+ * lpfc_els_rcv_farpr: Process an unsolicited farp response iocb.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes Fibre Channel Address Resolution Protocol
+ * Response (FARPR) IOCB received as an ELS unsolicited event. It simply
+ * invokes the lpfc_els_rsp_acc() routine to the remote node to accept
+ * the FARP response request.
+ *
+ * Return code
+ *   0 - Successfully processed FARPR IOCB (currently always return 0)
+ **/
 static int
 lpfc_els_rcv_farpr(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		   struct lpfc_nodelist  *ndlp)
@@ -3768,6 +4777,25 @@ lpfc_els_rcv_farpr(struct lpfc_vport *vp
 	return 0;
 }
 
+/**
+ * lpfc_els_rcv_fan: Process an unsolicited fan iocb command.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @fan_ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes a Fabric Address Notification (FAN) IOCB
+ * command received as an ELS unsolicited event. The FAN ELS command will
+ * only be processed on a physical port (i.e., the @vport represents the
+ * physical port). The fabric NodeName and PortName from the FAN IOCB are
+ * compared against those in the phba data structure. If any of those is
+ * different, the lpfc_initial_flogi() routine is invoked to initialize
+ * Fabric Login (FLOGI) to the fabric to start the discover over. Otherwise,
+ * if both of those are identical, the lpfc_issue_fabric_reglogin() routine
+ * is invoked to register login to the fabric.
+ *
+ * Return code
+ *   0 - Successfully processed fan iocb (currently always return 0).
+ **/
 static int
 lpfc_els_rcv_fan(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		 struct lpfc_nodelist *fan_ndlp)
@@ -3797,6 +4825,16 @@ lpfc_els_rcv_fan(struct lpfc_vport *vpor
 	return 0;
 }
 
+/**
+ * lpfc_els_timeout: Handler funciton to the els timer.
+ * @ptr: holder for the timer function associated data.
+ *
+ * This routine is invoked by the ELS timer after timeout. It posts the ELS
+ * timer timeout event by setting the WORKER_ELS_TMO bit to the work port
+ * event bitmap and then invokes the lpfc_worker_wake_up() routine to wake
+ * up the worker thread. It is for the worker thread to invoke the routine
+ * lpfc_els_timeout_handler() to work on the posted event WORKER_ELS_TMO.
+ **/
 void
 lpfc_els_timeout(unsigned long ptr)
 {
@@ -3816,6 +4854,15 @@ lpfc_els_timeout(unsigned long ptr)
 	return;
 }
 
+/**
+ * lpfc_els_timeout_handler: Process an els timeout event.
+ * @vport: pointer to a virtual N_Port data structure.
+ *
+ * This routine is the actual handler function that processes an ELS timeout
+ * event. It walks the ELS ring to get and abort all the IOCBs (except the
+ * ABORT/CLOSE/FARP/FARPR/FDISC), which are associated with the @vport by
+ * invoking the lpfc_sli_issue_abort_iotag() routine.
+ **/
 void
 lpfc_els_timeout_handler(struct lpfc_vport *vport)
 {
@@ -3886,6 +4933,26 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 		mod_timer(&vport->els_tmofunc, jiffies + HZ * timeout);
 }
 
+/**
+ * lpfc_els_flush_cmd: Clean up the outstanding els commands to a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine is used to clean up all the outstanding ELS commands on a
+ * @vport. It first aborts the @vport by invoking lpfc_fabric_abort_vport()
+ * routine. After that, it walks the ELS transmit queue to remove all the
+ * IOCBs with the @vport other than the QUE_RING and ABORT/CLOSE IOCBs. For
+ * the IOCBs with a non-NULL completion callback function, the callback
+ * function will be invoked with the status set to IOSTAT_LOCAL_REJECT and
+ * un.ulpWord[4] set to IOERR_SLI_ABORTED. For IOCBs with a NULL completion
+ * callback function, the IOCB will simply be released. Finally, it walks
+ * the ELS transmit completion queue to issue an abort IOCB to any transmit
+ * completion queue IOCB that is associated with the @vport and is not
+ * an IOCB from libdfc (i.e., the management plane IOCBs that are not
+ * part of the discovery state machine) out to HBA by invoking the
+ * lpfc_sli_issue_abort_iotag() routine. Note that this function issues the
+ * abort IOCB to any transmit completion queueed IOCB, it does not guarantee
+ * the IOCBs are aborted when this function returns.
+ **/
 void
 lpfc_els_flush_cmd(struct lpfc_vport *vport)
 {
@@ -3948,6 +5015,23 @@ lpfc_els_flush_cmd(struct lpfc_vport *vp
 	return;
 }
 
+/**
+ * lpfc_els_flush_all_cmd: Clean up all the outstanding els commands to a HBA.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is used to clean up all the outstanding ELS commands on a
+ * @phba. It first aborts the @phba by invoking the lpfc_fabric_abort_hba()
+ * routine. After that, it walks the ELS transmit queue to remove all the
+ * IOCBs to the @phba other than the QUE_RING and ABORT/CLOSE IOCBs. For
+ * the IOCBs with the completion callback function associated, the callback
+ * function will be invoked with the status set to IOSTAT_LOCAL_REJECT and
+ * un.ulpWord[4] set to IOERR_SLI_ABORTED. For IOCBs without the completion
+ * callback function associated, the IOCB will simply be released. Finally,
+ * it walks the ELS transmit completion queue to issue an abort IOCB to any
+ * transmit completion queue IOCB that is not an IOCB from libdfc (i.e., the
+ * management plane IOCBs that are not part of the discovery state machine)
+ * out to HBA by invoking the lpfc_sli_issue_abort_iotag() routine.
+ **/
 void
 lpfc_els_flush_all_cmd(struct lpfc_hba  *phba)
 {
@@ -3992,6 +5076,20 @@ lpfc_els_flush_all_cmd(struct lpfc_hba  
 	return;
 }
 
+/**
+ * lpfc_els_unsol_buffer: Process an unsolicited event data buffer.
+ * @phba: pointer to lpfc hba data structure.
+ * @pring: pointer to a SLI ring.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @elsiocb: pointer to lpfc els command iocb data structure.
+ *
+ * This routine is used for processing the IOCB associated with a unsolicited
+ * event. It first determines whether there is an existing ndlp that matches
+ * the DID from the unsolicited IOCB. If not, it will create a new one with
+ * the DID from the unsolicited IOCB. The ELS command from the unsolicited
+ * IOCB is then used to invoke the proper routine and to set up proper state
+ * of the discovery state machine.
+ **/
 static void
 lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		      struct lpfc_vport *vport, struct lpfc_iocbq *elsiocb)
@@ -4282,6 +5380,19 @@ dropit:
 	phba->fc_stat.elsRcvDrop++;
 }
 
+/**
+ * lpfc_find_vport_by_vpid: Find a vport on a HBA through vport identifier.
+ * @phba: pointer to lpfc hba data structure.
+ * @vpi: host virtual N_Port identifier.
+ *
+ * This routine finds a vport on a HBA (referred by @phba) through a
+ * @vpi. The function walks the HBA's vport list and returns the address
+ * of the vport with the matching @vpi.
+ *
+ * Return code
+ *    NULL - No vport with the matching @vpi found
+ *    Otherwise - Address to the vport with the matching @vpi.
+ **/
 static struct lpfc_vport *
 lpfc_find_vport_by_vpid(struct lpfc_hba *phba, uint16_t vpi)
 {
@@ -4299,6 +5410,18 @@ lpfc_find_vport_by_vpid(struct lpfc_hba 
 	return NULL;
 }
 
+/**
+ * lpfc_els_unsol_event: Process an unsolicited event from an els sli ring.
+ * @phba: pointer to lpfc hba data structure.
+ * @pring: pointer to a SLI ring.
+ * @elsiocb: pointer to lpfc els iocb data structure.
+ *
+ * This routine is used to process an unsolicited event received from a SLI
+ * (Service Level Interface) ring. The actual processing of the data buffer
+ * associated with the unsolicited event is done by invoking the routine
+ * lpfc_els_unsol_buffer() after properly set up the iocb buffer from the
+ * SLI ring on which the unsolicited event was received.
+ **/
 void
 lpfc_els_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		     struct lpfc_iocbq *elsiocb)
@@ -4376,6 +5499,19 @@ lpfc_els_unsol_event(struct lpfc_hba *ph
 	}
 }
 
+/**
+ * lpfc_do_scr_ns_plogi: Issue a plogi to the name server for scr.
+ * @phba: pointer to lpfc hba data structure.
+ * @vport: pointer to a virtual N_Port data structure.
+ *
+ * This routine issues a Port Login (PLOGI) to the Name Server with
+ * State Change Request (SCR) for a @vport. This routine will create an
+ * ndlp for the Name Server associated to the @vport if such node does
+ * not already exist. The PLOGI to Name Server is issued by invoking the
+ * lpfc_issue_els_plogi() routine. If Fabric-Device Management Interface
+ * (FDMI) is configured to the @vport, a FDMI node will be created and
+ * the PLOGI to FDMI is issued by invoking lpfc_issue_els_plogi() routine.
+ **/
 void
 lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct lpfc_vport *vport)
 {
@@ -4434,6 +5570,18 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 	return;
 }
 
+/**
+ * lpfc_cmpl_reg_new_vport: Completion callback function to register new vport.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * This routine is the completion callback function to register new vport
+ * mailbox command. If the new vport mailbox command completes successfully,
+ * the fabric registration login shall be performed on physical port (the
+ * new vport created is actually a physical port, with VPI 0) or the port
+ * login to Name Server for State Change Request (SCR) will be performed
+ * on virtual port (real virtual port, with VPI greater than 0).
+ **/
 static void
 lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
@@ -4491,6 +5639,15 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 	return;
 }
 
+/**
+ * lpfc_register_new_vport: Register a new vport with a HBA.
+ * @phba: pointer to lpfc hba data structure.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine registers the @vport as a new virtual port with a HBA.
+ * It is done through a registering vpi mailbox command.
+ **/
 static void
 lpfc_register_new_vport(struct lpfc_hba *phba, struct lpfc_vport *vport,
 			struct lpfc_nodelist *ndlp)
@@ -4531,6 +5688,26 @@ mbox_err_exit:
 	return;
 }
 
+/**
+ * lpfc_cmpl_els_fdisc: Completion function for fdisc iocb command.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is the completion callback function to a Fabric Discover
+ * (FDISC) ELS command. Since all the FDISC ELS commands are issued
+ * single threaded, each FDISC completion callback function will reset
+ * the discovery timer for all vports such that the timers will not get
+ * unnecessary timeout. The function checks the FDISC IOCB status. If error
+ * detected, the vport will be set to FC_VPORT_FAILED state. Otherwise,the
+ * vport will set to FC_VPORT_ACTIVE state. It then checks whether the DID
+ * assigned to the vport has been changed with the completion of the FDISC
+ * command. If so, both RPI (Remote Port Index) and VPI (Virtual Port Index)
+ * are unregistered from the HBA, and then the lpfc_register_new_vport()
+ * routine is invoked to register new vport with the HBA. Otherwise, the
+ * lpfc_do_scr_ns_plogi() routine is invoked to issue a PLOGI to the Name
+ * Server for State Change Request (SCR).
+ **/
 static void
 lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		    struct lpfc_iocbq *rspiocb)
@@ -4617,6 +5794,26 @@ out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 }
 
+/**
+ * lpfc_issue_els_fdisc: Issue a fdisc iocb command.
+ * @vport: pointer to a virtual N_Port data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @retry: number of retries to the command IOCB.
+ *
+ * This routine prepares and issues a Fabric Discover (FDISC) IOCB to
+ * a remote node (@ndlp) off a @vport. It uses the lpfc_issue_fabric_iocb()
+ * routine to issue the IOCB, which makes sure only one outstanding fabric
+ * IOCB will be sent off HBA at any given time.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the FDISC ELS command.
+ *
+ * Return code
+ *   0 - Successfully issued fdisc iocb command
+ *   1 - Failed to issue fdisc iocb command
+ **/
 static int
 lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		     uint8_t retry)
@@ -4691,6 +5888,20 @@ lpfc_issue_els_fdisc(struct lpfc_vport *
 	return 0;
 }
 
+/**
+ * lpfc_cmpl_els_npiv_logo: Completion function with vport logo.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is the completion callback function to the issuing of a LOGO
+ * ELS command off a vport. It frees the command IOCB and then decrement the
+ * reference count held on ndlp for this completion function, indicating that
+ * the reference to the ndlp is no long needed. Note that the
+ * lpfc_els_free_iocb() routine decrements the ndlp reference held for this
+ * callback function and an additional explicit ndlp reference decrementation
+ * will trigger the actual release of the ndlp.
+ **/
 static void
 lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			struct lpfc_iocbq *rspiocb)
@@ -4712,6 +5923,22 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba 
 	lpfc_nlp_put(ndlp);
 }
 
+/**
+ * lpfc_issue_els_npiv_logo: Issue a logo off a vport.
+ * @vport: pointer to a virtual N_Port data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine issues a LOGO ELS command to an @ndlp off a @vport.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the LOGO ELS command.
+ *
+ * Return codes
+ *   0 - Successfully issued logo off the @vport
+ *   1 - Failed to issue logo off the @vport
+ **/
 int
 lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
@@ -4757,6 +5984,17 @@ lpfc_issue_els_npiv_logo(struct lpfc_vpo
 	return 0;
 }
 
+/**
+ * lpfc_fabric_block_timeout: Handler function to the fabric block timer.
+ * @ptr: holder for the timer function associated data.
+ *
+ * This routine is invoked by the fabric iocb block timer after
+ * timeout. It posts the fabric iocb block timeout event by setting the
+ * WORKER_FABRIC_BLOCK_TMO bit to work port event bitmap and then invokes
+ * lpfc_worker_wake_up() routine to wake up the worker thread. It is for
+ * the worker thread to invoke the lpfc_unblock_fabric_iocbs() on the
+ * posted event WORKER_FABRIC_BLOCK_TMO.
+ **/
 void
 lpfc_fabric_block_timeout(unsigned long ptr)
 {
@@ -4775,6 +6013,16 @@ lpfc_fabric_block_timeout(unsigned long 
 	return;
 }
 
+/**
+ * lpfc_resume_fabric_iocbs: Issue a fabric iocb from driver internal list.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine issues one fabric iocb from the driver internal list to
+ * the HBA. It first checks whether it's ready to issue one fabric iocb to
+ * the HBA (whether there is no outstanding fabric iocb). If so, it shall
+ * remove one pending fabric iocb from the driver internal list and invokes
+ * lpfc_sli_issue_iocb() routine to send the fabric iocb to the HBA.
+ **/
 static void
 lpfc_resume_fabric_iocbs(struct lpfc_hba *phba)
 {
@@ -4824,6 +6072,15 @@ repeat:
 	return;
 }
 
+/**
+ * lpfc_unblock_fabric_iocbs: Unblock issuing fabric iocb command.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine unblocks the  issuing fabric iocb command. The function
+ * will clear the fabric iocb block bit and then invoke the routine
+ * lpfc_resume_fabric_iocbs() to issue one of the pending fabric iocb
+ * from the driver internal fabric iocb list.
+ **/
 void
 lpfc_unblock_fabric_iocbs(struct lpfc_hba *phba)
 {
@@ -4833,6 +6090,15 @@ lpfc_unblock_fabric_iocbs(struct lpfc_hb
 	return;
 }
 
+/**
+ * lpfc_block_fabric_iocbs: Block issuing fabric iocb command.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine blocks the issuing fabric iocb for a specified amount of
+ * time (currently 100 ms). This is done by set the fabric iocb block bit
+ * and set up a timeout timer for 100ms. When the block bit is set, no more
+ * fabric iocb will be issued out of the HBA.
+ **/
 static void
 lpfc_block_fabric_iocbs(struct lpfc_hba *phba)
 {
@@ -4846,6 +6112,19 @@ lpfc_block_fabric_iocbs(struct lpfc_hba 
 	return;
 }
 
+/**
+ * lpfc_cmpl_fabric_iocb: Completion callback function for fabric iocb.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine is the callback function that is put to the fabric iocb's
+ * callback function pointer (iocb->iocb_cmpl). The original iocb's callback
+ * function pointer has been stored in iocb->fabric_iocb_cmpl. This callback
+ * function first restores and invokes the original iocb's callback function
+ * and then invokes the lpfc_resume_fabric_iocbs() routine to issue the next
+ * fabric bound iocb from the driver internal fabric iocb list onto the wire.
+ **/
 static void
 lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_iocbq *rspiocb)
@@ -4892,6 +6171,30 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *p
 	}
 }
 
+/**
+ * lpfc_issue_fabric_iocb: Issue a fabric iocb command.
+ * @phba: pointer to lpfc hba data structure.
+ * @iocb: pointer to lpfc command iocb data structure.
+ *
+ * This routine is used as the top-level API for issuing a fabric iocb command
+ * such as FLOGI and FDISC. To accommodate certain switch fabric, this driver
+ * function makes sure that only one fabric bound iocb will be outstanding at
+ * any given time. As such, this function will first check to see whether there
+ * is already an outstanding fabric iocb on the wire. If so, it will put the
+ * newly issued iocb onto the driver internal fabric iocb list, waiting to be
+ * issued later. Otherwise, it will issue the iocb on the wire and update the
+ * fabric iocb count it indicate that there is one fabric iocb on the wire.
+ *
+ * Note, this implementation has a potential sending out fabric IOCBs out of
+ * order. The problem is caused by the construction of the "ready" boolen does
+ * not include the condition that the internal fabric IOCB list is empty. As
+ * such, it is possible a fabric IOCB issued by this routine might be "jump"
+ * ahead of the fabric IOCBs in the internal list.
+ *
+ * Return code
+ *   IOCB_SUCCESS - either fabric iocb put on the list or issued successfully
+ *   IOCB_ERROR - failed to issue fabric iocb
+ **/
 static int
 lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 {
@@ -4937,7 +6240,17 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *
 	return ret;
 }
 
-
+/**
+ * lpfc_fabric_abort_vport: Abort a vport's iocbs from driver fabric iocb list.
+ * @vport: pointer to a virtual N_Port data structure.
+ *
+ * This routine aborts all the IOCBs associated with a @vport from the
+ * driver internal fabric IOCB list. The list contains fabric IOCBs to be
+ * issued to the ELS IOCB ring. This abort function walks the fabric IOCB
+ * list, removes each IOCB associated with the @vport off the list, set the
+ * status feild to IOSTAT_LOCAL_REJECT, and invokes the callback function
+ * associated with the IOCB.
+ **/
 static void lpfc_fabric_abort_vport(struct lpfc_vport *vport)
 {
 	LIST_HEAD(completions);
@@ -4967,6 +6280,17 @@ static void lpfc_fabric_abort_vport(stru
 	}
 }
 
+/**
+ * lpfc_fabric_abort_nport: Abort a ndlp's iocbs from driver fabric iocb list.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine aborts all the IOCBs associated with an @ndlp from the
+ * driver internal fabric IOCB list. The list contains fabric IOCBs to be
+ * issued to the ELS IOCB ring. This abort function walks the fabric IOCB
+ * list, removes each IOCB associated with the @ndlp off the list, set the
+ * status feild to IOSTAT_LOCAL_REJECT, and invokes the callback function
+ * associated with the IOCB.
+ **/
 void lpfc_fabric_abort_nport(struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(completions);
@@ -4996,6 +6320,17 @@ void lpfc_fabric_abort_nport(struct lpfc
 	}
 }
 
+/**
+ * lpfc_fabric_abort_hba: Abort all iocbs on driver fabric iocb list.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine aborts all the IOCBs currently on the driver internal
+ * fabric IOCB list. The list contains fabric IOCBs to be issued to the ELS
+ * IOCB ring. This function takes the entire IOCB list off the fabric IOCB
+ * list, removes IOCBs off the list, set the status feild to
+ * IOSTAT_LOCAL_REJECT, and invokes the callback function associated with
+ * the IOCB.
+ **/
 void lpfc_fabric_abort_hba(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);


