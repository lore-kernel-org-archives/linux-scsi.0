From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/15] lpfc 8.2.8 : Add kernel-doc function headers - part 4
Date: Sun, 24 Aug 2008 21:49:34 -0400
Message-ID: <1219628974.7890.27.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52449 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYHYBtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:49:33 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1nVAp019936
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:49:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add kernel-doc function headers - part 4


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_mbox.c |  468 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 lpfc_mem.c  |  115 ++++++++++++++
 2 files changed, 512 insertions(+), 71 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2008-02-06 11:02:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2008-08-24 18:49:52.000000000 -0400
@@ -37,10 +37,20 @@
 #include "lpfc_crtn.h"
 #include "lpfc_compat.h"
 
-/**********************************************/
-
-/*                mailbox command             */
-/**********************************************/
+/**
+ * lpfc_dump_mem: Prepare a mailbox command for retrieving HBA's VPD memory.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ * @offset: offset for dumping VPD memory mailbox command.
+ *
+ * The dump mailbox command provides a method for the device driver to obtain
+ * various types of information from the HBA device.
+ *
+ * This routine prepares the mailbox command for dumping HBA Vital Product
+ * Data (VPD) memory. This mailbox command is to be used for retrieving a
+ * portion (DMP_RSP_SIZE bytes) of a HBA's VPD from the HBA at an address
+ * offset specified by the offset parameter.
+ **/
 void
 lpfc_dump_mem(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, uint16_t offset)
 {
@@ -65,10 +75,17 @@ lpfc_dump_mem(struct lpfc_hba * phba, LP
 	return;
 }
 
-/**********************************************/
-/*  lpfc_read_nv  Issue a READ NVPARAM        */
-/*                mailbox command             */
-/**********************************************/
+/**
+ * lpfc_read_nv: Prepare a mailbox command for reading HBA's NVRAM param.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The read NVRAM mailbox command returns the HBA's non-volatile parameters
+ * that are used as defaults when the Fibre Channel link is brought on-line.
+ *
+ * This routine prepares the mailbox command for reading information stored
+ * in the HBA's NVRAM. Specifically, the HBA's WWNN and WWPN.
+ **/
 void
 lpfc_read_nv(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
@@ -81,10 +98,19 @@ lpfc_read_nv(struct lpfc_hba * phba, LPF
 	return;
 }
 
-/**********************************************/
-/*  lpfc_config_async  Issue a                */
-/*  MBX_ASYNC_EVT_ENABLE mailbox command      */
-/**********************************************/
+/**
+ * lpfc_config_async: Prepare a mailbox command for enabling HBA async event.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ * @ring: ring number for the asynchronous event to be configured.
+ *
+ * The asynchronous event enable mailbox command is used to enable the
+ * asynchronous event posting via the ASYNC_STATUS_CN IOCB response and
+ * specifies the default ring to which events are posted.
+ *
+ * This routine prepares the mailbox command for enabling HBA asynchronous
+ * event support on a IOCB ring.
+ **/
 void
 lpfc_config_async(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb,
 		uint32_t ring)
@@ -99,10 +125,19 @@ lpfc_config_async(struct lpfc_hba * phba
 	return;
 }
 
-/**********************************************/
-/*  lpfc_heart_beat  Issue a HEART_BEAT       */
-/*                mailbox command             */
-/**********************************************/
+/**
+ * lpfc_heart_beat: Prepare a mailbox command for heart beat.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The heart beat mailbox command is used to detect an unresponsive HBA, which
+ * is defined as any device where no error attention is sent and both mailbox
+ * and rings are not processed.
+ *
+ * This routine prepares the mailbox command for issuing a heart beat in the
+ * form of mailbox command to the HBA. The timely completion of the heart
+ * beat mailbox command indicates the health of the HBA.
+ **/
 void
 lpfc_heart_beat(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
@@ -115,10 +150,26 @@ lpfc_heart_beat(struct lpfc_hba * phba, 
 	return;
 }
 
-/**********************************************/
-/*  lpfc_read_la  Issue a READ LA             */
-/*                mailbox command             */
-/**********************************************/
+/**
+ * lpfc_read_la: Prepare a mailbox command for reading HBA link attention.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ * @mp: DMA buffer memory for reading the link attention information into.
+ *
+ * The read link attention mailbox command is issued to read the Link Event
+ * Attention information indicated by the HBA port when the Link Event bit
+ * of the Host Attention (HSTATT) register is set to 1. A Link Event
+ * Attention occurs based on an exception detected at the Fibre Channel link
+ * interface.
+ *
+ * This routine prepares the mailbox command for reading HBA link attention
+ * information. A DMA memory has been set aside and address passed to the
+ * HBA through @mp for the HBA to DMA link attention information into the
+ * memory as part of the execution of the mailbox command.
+ *
+ * Return codes
+ *    0 - Success (currently always return 0)
+ **/
 int
 lpfc_read_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, struct lpfc_dmabuf *mp)
 {
@@ -143,10 +194,21 @@ lpfc_read_la(struct lpfc_hba * phba, LPF
 	return (0);
 }
 
-/**********************************************/
-/*  lpfc_clear_la  Issue a CLEAR LA           */
-/*                 mailbox command            */
-/**********************************************/
+/**
+ * lpfc_clear_la: Prepare a mailbox command for clearing HBA link attention.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The clear link attention mailbox command is issued to clear the link event
+ * attention condition indicated by the Link Event bit of the Host Attention
+ * (HSTATT) register. The link event attention condition is cleared only if
+ * the event tag specified matches that of the current link event counter.
+ * The current event tag is read using the read link attention event mailbox
+ * command.
+ *
+ * This routine prepares the mailbox command for clearing HBA link attention
+ * information.
+ **/
 void
 lpfc_clear_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
@@ -161,10 +223,20 @@ lpfc_clear_la(struct lpfc_hba * phba, LP
 	return;
 }
 
-/**************************************************/
-/*  lpfc_config_link  Issue a CONFIG LINK         */
-/*                    mailbox command             */
-/**************************************************/
+/**
+ * lpfc_config_link: Prepare a mailbox command for configuring link on a HBA.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The configure link mailbox command is used before the initialize link
+ * mailbox command to override default value and to configure link-oriented
+ * parameters such as DID address and various timers. Typically, this
+ * command would be used after an F_Port login to set the returned DID address
+ * and the fabric timeout values. This command is not valid before a configure
+ * port command has configured the HBA port.
+ *
+ * This routine prepares the mailbox command for configuring link on a HBA.
+ **/
 void
 lpfc_config_link(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
@@ -199,10 +271,20 @@ lpfc_config_link(struct lpfc_hba * phba,
 	return;
 }
 
-/**********************************************/
-/*  lpfc_init_link  Issue an INIT LINK        */
-/*                  mailbox command           */
-/**********************************************/
+/**
+ * lpfc_init_link: Prepare a mailbox command for initialize link on a HBA.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ * @topology: the link topology for the link to be initialized to.
+ * @linkspeed: the link speed for the link to be initialized to.
+ *
+ * The initialize link mailbox command is used to initialize the Fibre
+ * Channel link. This command must follow a configure port command that
+ * establishes the mode of operation.
+ *
+ * This routine prepares the mailbox command for initializing link on a HBA
+ * with the specified link topology and speed.
+ **/
 void
 lpfc_init_link(struct lpfc_hba * phba,
 	       LPFC_MBOXQ_t * pmb, uint32_t topology, uint32_t linkspeed)
@@ -269,10 +351,27 @@ lpfc_init_link(struct lpfc_hba * phba,
 	return;
 }
 
-/**********************************************/
-/*  lpfc_read_sparam  Issue a READ SPARAM     */
-/*                    mailbox command         */
-/**********************************************/
+/**
+ * lpfc_read_sparam: Prepare a mailbox command for reading HBA parameters.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ * @vpi: virtual N_Port identifier.
+ *
+ * The read service parameter mailbox command is used to read the HBA port
+ * service parameters. The service parameters are read into the buffer
+ * specified directly by a BDE in the mailbox command. These service
+ * parameters may then be used to build the payload of an N_Port/F_POrt
+ * login request and reply (LOGI/ACC).
+ *
+ * This routine prepares the mailbox command for reading HBA port service
+ * parameters. The DMA memory is allocated in this function and the addresses
+ * are populated into the mailbox command for the HBA to DMA the service
+ * parameters into.
+ *
+ * Return codes
+ *    0 - Success
+ *    1 - DMA memory allocation failed
+ **/
 int
 lpfc_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb, int vpi)
 {
@@ -312,10 +411,21 @@ lpfc_read_sparam(struct lpfc_hba *phba, 
 	return (0);
 }
 
-/********************************************/
-/*  lpfc_unreg_did  Issue a UNREG_DID       */
-/*                  mailbox command         */
-/********************************************/
+/**
+ * lpfc_unreg_did: Prepare a mailbox command for unregistering DID.
+ * @phba: pointer to lpfc hba data structure.
+ * @vpi: virtual N_Port identifier.
+ * @did: remote port identifier.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The unregister DID mailbox command is used to unregister an N_Port/F_Port
+ * login for an unknown RPI by specifying the DID of a remote port. This
+ * command frees an RPI context in the HBA port. This has the effect of
+ * performing an implicit N_Port/F_Port logout.
+ *
+ * This routine prepares the mailbox command for unregistering a remote
+ * N_Port/F_Port (DID) login.
+ **/
 void
 lpfc_unreg_did(struct lpfc_hba * phba, uint16_t vpi, uint32_t did,
 	       LPFC_MBOXQ_t * pmb)
@@ -333,10 +443,19 @@ lpfc_unreg_did(struct lpfc_hba * phba, u
 	return;
 }
 
-/**********************************************/
-/*  lpfc_read_nv  Issue a READ CONFIG         */
-/*                mailbox command             */
-/**********************************************/
+/**
+ * lpfc_read_config: Prepare a mailbox command for reading HBA configuration.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The read configuration mailbox command is used to read the HBA port
+ * configuration parameters. This mailbox command provides a method for
+ * seeing any parameters that may have changed via various configuration
+ * mailbox commands.
+ *
+ * This routine prepares the mailbox command for reading out HBA configuration
+ * parameters.
+ **/
 void
 lpfc_read_config(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
@@ -350,10 +469,18 @@ lpfc_read_config(struct lpfc_hba * phba,
 	return;
 }
 
-/*************************************************/
-/*  lpfc_read_lnk_stat  Issue a READ LINK STATUS */
-/*                mailbox command                */
-/*************************************************/
+/**
+ * lpfc_read_lnk_stat: Prepare a mailbox command for reading HBA link stats.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The read link status mailbox command is used to read the link status from
+ * the HBA. Link status includes all link-related error counters. These
+ * counters are maintained by the HBA and originated in the link hardware
+ * unit. Note that all of these counters wrap.
+ *
+ * This routine prepares the mailbox command for reading out HBA link status.
+ **/
 void
 lpfc_read_lnk_stat(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
@@ -367,10 +494,30 @@ lpfc_read_lnk_stat(struct lpfc_hba * phb
 	return;
 }
 
-/********************************************/
-/*  lpfc_reg_login  Issue a REG_LOGIN       */
-/*                  mailbox command         */
-/********************************************/
+/**
+ * lpfc_reg_login: Prepare a mailbox command for registering remote login.
+ * @phba: pointer to lpfc hba data structure.
+ * @vpi: virtual N_Port identifier.
+ * @did: remote port identifier.
+ * @param: pointer to memory holding the server parameters.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ * @flag: action flag to be passed back for the complete function.
+ *
+ * The registration login mailbox command is used to register an N_Port or
+ * F_Port login. This registration allows the HBA to cache the remote N_Port
+ * service parameters internally and thereby make the appropriate FC-2
+ * decisions. The remote port service parameters are handed off by the driver
+ * to the HBA using a descriptor entry that directly identifies a buffer in
+ * host memory. In exchange, the HBA returns an RPI identifier.
+ *
+ * This routine prepares the mailbox command for registering remote port login.
+ * The function allocates DMA buffer for passing the service parameters to the
+ * HBA with the mailbox command.
+ *
+ * Return codes
+ *    0 - Success
+ *    1 - DMA memory allocation failed
+ **/
 int
 lpfc_reg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t did,
 	       uint8_t *param, LPFC_MBOXQ_t *pmb, uint32_t flag)
@@ -418,10 +565,20 @@ lpfc_reg_login(struct lpfc_hba *phba, ui
 	return (0);
 }
 
-/**********************************************/
-/*  lpfc_unreg_login  Issue a UNREG_LOGIN     */
-/*                    mailbox command         */
-/**********************************************/
+/**
+ * lpfc_unreg_login: Prepare a mailbox command for unregistering remote login.
+ * @phba: pointer to lpfc hba data structure.
+ * @vpi: virtual N_Port identifier.
+ * @rpi: remote port identifier
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The unregistration login mailbox command is used to unregister an N_Port
+ * or F_Port login. This command frees an RPI context in the HBA. It has the
+ * effect of performing an implicit N_Port/F_Port logout.
+ *
+ * This routine prepares the mailbox command for unregistering remote port
+ * login.
+ **/
 void
 lpfc_unreg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t rpi,
 		 LPFC_MBOXQ_t * pmb)
@@ -440,10 +597,21 @@ lpfc_unreg_login(struct lpfc_hba *phba, 
 	return;
 }
 
-/**************************************************/
-/*  lpfc_reg_vpi   Issue a REG_VPI                */
-/*                    mailbox command             */
-/**************************************************/
+/**
+ * lpfc_reg_vpi: Prepare a mailbox command for registering vport identifier.
+ * @phba: pointer to lpfc hba data structure.
+ * @vpi: virtual N_Port identifier.
+ * @sid: Fibre Channel S_ID (N_Port_ID assigned to a virtual N_Port).
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The registration vport identifier mailbox command is used to activate a
+ * virtual N_Port after it has acquired an N_Port_ID. The HBA validates the
+ * N_Port_ID against the information in the selected virtual N_Port context
+ * block and marks it active to allow normal processing of IOCB commands and
+ * received unsolicited exchanges.
+ *
+ * This routine prepares the mailbox command for registering a virtual N_Port.
+ **/
 void
 lpfc_reg_vpi(struct lpfc_hba *phba, uint16_t vpi, uint32_t sid,
 	     LPFC_MBOXQ_t *pmb)
@@ -461,10 +629,22 @@ lpfc_reg_vpi(struct lpfc_hba *phba, uint
 
 }
 
-/**************************************************/
-/*  lpfc_unreg_vpi   Issue a UNREG_VNPI           */
-/*                    mailbox command             */
-/**************************************************/
+/**
+ * lpfc_unreg_vpi: Prepare a mailbox command for unregistering vport id.
+ * @phba: pointer to lpfc hba data structure.
+ * @vpi: virtual N_Port identifier.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The unregistration vport identifier mailbox command is used to inactivate
+ * a virtual N_Port. The driver must have logged out and unregistered all
+ * remote N_Ports to abort any activity on the virtual N_Port. The HBA will
+ * unregisters any default RPIs associated with the specified vpi, aborting
+ * any active exchanges. The HBA will post the mailbox response after making
+ * the virtual N_Port inactive.
+ *
+ * This routine prepares the mailbox command for unregistering a virtual
+ * N_Port.
+ **/
 void
 lpfc_unreg_vpi(struct lpfc_hba *phba, uint16_t vpi, LPFC_MBOXQ_t *pmb)
 {
@@ -479,6 +659,13 @@ lpfc_unreg_vpi(struct lpfc_hba *phba, ui
 
 }
 
+/**
+ * lpfc_config_pcb_setup: Set up IOCB rings in the Port Control Block (PCB)
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine sets up and initializes the IOCB rings in the Port Control
+ * Block (PCB).
+ **/
 static void
 lpfc_config_pcb_setup(struct lpfc_hba * phba)
 {
@@ -536,6 +723,20 @@ lpfc_config_pcb_setup(struct lpfc_hba * 
 	}
 }
 
+/**
+ * lpfc_read_rev: Prepare a mailbox command for reading HBA revision.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The read revision mailbox command is used to read the revision levels of
+ * the HBA components. These components include hardware units, resident
+ * firmware, and available firmware. HBAs that supports SLI-3 mode of
+ * operation provide different response information depending on the version
+ * requested by the driver.
+ *
+ * This routine prepares the mailbox command for reading HBA revision
+ * information.
+ **/
 void
 lpfc_read_rev(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
@@ -548,6 +749,16 @@ lpfc_read_rev(struct lpfc_hba * phba, LP
 	return;
 }
 
+/**
+ * lpfc_build_hbq_profile2: Set up the HBQ Selection Profile 2.
+ * @hbqmb: pointer to the HBQ configuration data structure in mailbox command.
+ * @hbq_desc: pointer to the HBQ selection profile descriptor.
+ *
+ * The Host Buffer Queue (HBQ) Selection Profile 2 specifies that the HBA
+ * tests the incoming frames' R_CTL/TYPE fields with works 10:15 and performs
+ * the Sequence Length Test using the fields in the Selection Profile 2
+ * extension in words 20:31.
+ **/
 static void
 lpfc_build_hbq_profile2(struct config_hbq_var *hbqmb,
 			struct lpfc_hbq_init  *hbq_desc)
@@ -557,6 +768,16 @@ lpfc_build_hbq_profile2(struct config_hb
 	hbqmb->profiles.profile2.seqlenoff  = hbq_desc->seqlenoff;
 }
 
+/**
+ * lpfc_build_hbq_profile3: Set up the HBQ Selection Profile 3.
+ * @hbqmb: pointer to the HBQ configuration data structure in mailbox command.
+ * @hbq_desc: pointer to the HBQ selection profile descriptor.
+ *
+ * The Host Buffer Queue (HBQ) Selection Profile 3 specifies that the HBA
+ * tests the incoming frame's R_CTL/TYPE fields with words 10:15 and performs
+ * the Sequence Length Test and Byte Field Test using the fields in the
+ * Selection Profile 3 extension in words 20:31.
+ **/
 static void
 lpfc_build_hbq_profile3(struct config_hbq_var *hbqmb,
 			struct lpfc_hbq_init  *hbq_desc)
@@ -569,6 +790,17 @@ lpfc_build_hbq_profile3(struct config_hb
 	       sizeof(hbqmb->profiles.profile3.cmdmatch));
 }
 
+/**
+ * lpfc_build_hbq_profile5: Set up the HBQ Selection Profile 5.
+ * @hbqmb: pointer to the HBQ configuration data structure in mailbox command.
+ * @hbq_desc: pointer to the HBQ selection profile descriptor.
+ *
+ * The Host Buffer Queue (HBQ) Selection Profile 5 specifies a header HBQ. The
+ * HBA tests the initial frame of an incoming sequence using the frame's
+ * R_CTL/TYPE fields with words 10:15 and performs the Sequence Length Test
+ * and Byte Field Test using the fields in the Selection Profile 5 extension
+ * words 20:31.
+ **/
 static void
 lpfc_build_hbq_profile5(struct config_hbq_var *hbqmb,
 			struct lpfc_hbq_init  *hbq_desc)
@@ -581,6 +813,20 @@ lpfc_build_hbq_profile5(struct config_hb
 	       sizeof(hbqmb->profiles.profile5.cmdmatch));
 }
 
+/**
+ * lpfc_config_hbq: Prepare a mailbox command for configuring an HBQ.
+ * @phba: pointer to lpfc hba data structure.
+ * @id: HBQ identifier.
+ * @hbq_desc: pointer to the HBA descriptor data structure.
+ * @hbq_entry_index: index of the HBQ entry data structures.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The configure HBQ (Host Buffer Queue) mailbox command is used to configure
+ * an HBQ. The configuration binds events that require buffers to a particular
+ * ring and HBQ based on a selection profile.
+ *
+ * This routine prepares the mailbox command for configuring an HBQ.
+ **/
 void
 lpfc_config_hbq(struct lpfc_hba *phba, uint32_t id,
 		 struct lpfc_hbq_init *hbq_desc,
@@ -641,8 +887,23 @@ lpfc_config_hbq(struct lpfc_hba *phba, u
 	return;
 }
 
-
-
+/**
+ * lpfc_config_ring: Prepare a mailbox command for configuring an IOCB ring.
+ * @phba: pointer to lpfc hba data structure.
+ * @ring:
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The configure ring mailbox command is used to configure an IOCB ring. This
+ * configuration binds from one to six of HBA RC_CTL/TYPE mask entries to the
+ * ring. This is used to map incoming sequences to a particular ring whose
+ * RC_CTL/TYPE mask entry matches that of the sequence. The driver should not
+ * attempt to configure a ring whose number is greater than the number
+ * specified in the Port Control Block (PCB). It is an error to issue the
+ * configure ring command more than once with the same ring number. The HBA
+ * returns an error if the driver attempts this.
+ *
+ * This routine prepares the mailbox command for configuring IOCB ring.
+ **/
 void
 lpfc_config_ring(struct lpfc_hba * phba, int ring, LPFC_MBOXQ_t * pmb)
 {
@@ -684,6 +945,20 @@ lpfc_config_ring(struct lpfc_hba * phba,
 	return;
 }
 
+/**
+ * lpfc_config_port: Prepare a mailbox command for configuring port.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The configure port mailbox command is used to identify the Port Control
+ * Block (PCB) in the driver memory. After this command is issued, the
+ * driver must not access the mailbox in the HBA without first resetting
+ * the HBA. The HBA may copy the PCB information to internal storage for
+ * subsequent use; the driver can not change the PCB information unless it
+ * resets the HBA.
+ *
+ * This routine prepares the mailbox command for configuring port.
+ **/
 void
 lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
@@ -839,6 +1114,21 @@ lpfc_config_port(struct lpfc_hba *phba, 
 			      sizeof(PCB_t));
 }
 
+/**
+ * lpfc_kill_board: Prepare a mailbox command for killing board.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The kill board mailbox command is used to tell firmware to perform a
+ * graceful shutdown of a channel on a specified board to prepare for reset.
+ * When the kill board mailbox command is received, the ER3 bit is set to 1
+ * in the Host Status register and the ER Attention bit is set to 1 in the
+ * Host Attention register of the HBA function that received the kill board
+ * command.
+ *
+ * This routine prepares the mailbox command for killing the board in
+ * preparation for a graceful shutdown.
+ **/
 void
 lpfc_kill_board(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
@@ -850,6 +1140,16 @@ lpfc_kill_board(struct lpfc_hba * phba, 
 	return;
 }
 
+/**
+ * lpfc_mbox_put: Put a mailbox cmd into the tail of driver's mailbox queue.
+ * @phba: pointer to lpfc hba data structure.
+ * @mbq: pointer to the driver internal queue element for mailbox command.
+ *
+ * Driver maintains a internal mailbox command queue implemented as a linked
+ * list. When a mailbox command is issued, it shall be put into the mailbox
+ * command queue such that they shall be processed orderly as HBA can process
+ * one mailbox command at a time.
+ **/
 void
 lpfc_mbox_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
 {
@@ -864,6 +1164,20 @@ lpfc_mbox_put(struct lpfc_hba * phba, LP
 	return;
 }
 
+/**
+ * lpfc_mbox_get: Remove a mailbox cmd from the head of driver's mailbox queue.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * Driver maintains a internal mailbox command queue implemented as a linked
+ * list. When a mailbox command is issued, it shall be put into the mailbox
+ * command queue such that they shall be processed orderly as HBA can process
+ * one mailbox command at a time. After HBA finished processing a mailbox
+ * command, the driver will remove a pending mailbox command from the head of
+ * the mailbox command queue and send to the HBA for processing.
+ *
+ * Return codes
+ *    pointer to the driver internal queue element for mailbox command.
+ **/
 LPFC_MBOXQ_t *
 lpfc_mbox_get(struct lpfc_hba * phba)
 {
@@ -877,6 +1191,17 @@ lpfc_mbox_get(struct lpfc_hba * phba)
 	return mbq;
 }
 
+/**
+ * lpfc_mbox_cmpl_put: Put mailbox command into mailbox command complete list.
+ * @phba: pointer to lpfc hba data structure.
+ * @mbq: pointer to the driver internal queue element for mailbox command.
+ *
+ * This routine put the completed mailbox command into the mailbox command
+ * complete list. This routine is called from driver interrupt handler
+ * context.The mailbox complete list is used by the driver worker thread
+ * to process mailbox complete callback functions outside the driver interrupt
+ * handler.
+ **/
 void
 lpfc_mbox_cmpl_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
 {
@@ -887,6 +1212,17 @@ lpfc_mbox_cmpl_put(struct lpfc_hba * phb
 	return;
 }
 
+/**
+ * lpfc_mbox_tmo_val: Retrieve mailbox command timeout value.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmd: mailbox command code.
+ *
+ * This routine retrieves the proper timeout value according to the mailbox
+ * command code.
+ *
+ * Return codes
+ *    Timeout value to be used for the given mailbox command
+ **/
 int
 lpfc_mbox_tmo_val(struct lpfc_hba *phba, int cmd)
 {
diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2008-08-24 18:49:52.000000000 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -39,7 +39,21 @@
 #define LPFC_MEM_POOL_SIZE      64      /* max elem in non-DMA safety pool */
 

-
+/**
+ * lpfc_mem_alloc: create and allocate all PCI and memory pools
+ * @phba: HBA to allocate pools for
+ *
+ * Description: Creates and allocates PCI pools lpfc_scsi_dma_buf_pool,
+ * lpfc_mbuf_pool, lpfc_hbq_pool.  Creates and allocates kmalloc-backed mempools
+ * for LPFC_MBOXQ_t and lpfc_nodelist.  Also allocates the VPI bitmask.
+ *
+ * Notes: Not interrupt-safe.  Must be called with no locks held.  If any
+ * allocation fails, frees all successfully allocated memory before returning.
+ *
+ * Returns:
+ *   0 on success
+ *   -ENOMEM on failure (if any memory allocations fail)
+ **/
 int
 lpfc_mem_alloc(struct lpfc_hba * phba)
 {
@@ -120,6 +134,16 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
 	return -ENOMEM;
 }
 
+/**
+ * lpfc_mem_free: Frees all PCI and memory allocated by lpfc_mem_alloc
+ * @phba: HBA to free memory for
+ *
+ * Description: Frees PCI pools lpfc_scsi_dma_buf_pool, lpfc_mbuf_pool,
+ * lpfc_hbq_pool.  Frees kmalloc-backed mempools for LPFC_MBOXQ_t and
+ * lpfc_nodelist.  Also frees the VPI bitmask.
+ *
+ * Returns: None
+ **/
 void
 lpfc_mem_free(struct lpfc_hba * phba)
 {
@@ -181,12 +205,29 @@ lpfc_mem_free(struct lpfc_hba * phba)
 	phba->lpfc_scsi_dma_buf_pool = NULL;
 	phba->lpfc_mbuf_pool = NULL;
 
-				/* Free the iocb lookup array */
+	/* Free the iocb lookup array */
 	kfree(psli->iocbq_lookup);
 	psli->iocbq_lookup = NULL;
-
 }
 
+/**
+ * lpfc_mbuf_alloc: Allocate an mbuf from the lpfc_mbuf_pool PCI pool
+ * @phba: HBA which owns the pool to allocate from
+ * @mem_flags: indicates if this is a priority (MEM_PRI) allocation
+ * @handle: used to return the DMA-mapped address of the mbuf
+ *
+ * Description: Allocates a DMA-mapped buffer from the lpfc_mbuf_pool PCI pool.
+ * Allocates from generic pci_pool_alloc function first and if that fails and
+ * mem_flags has MEM_PRI set (the only defined flag), returns an mbuf from the
+ * HBA's pool.
+ *
+ * Notes: Not interrupt-safe.  Must be called with no locks held.  Takes
+ * phba->hbalock.
+ *
+ * Returns:
+ *   pointer to the allocated mbuf on success
+ *   NULL on failure
+ **/
 void *
 lpfc_mbuf_alloc(struct lpfc_hba *phba, int mem_flags, dma_addr_t *handle)
 {
@@ -206,6 +247,20 @@ lpfc_mbuf_alloc(struct lpfc_hba *phba, i
 	return ret;
 }
 
+/**
+ * __lpfc_mem_free: Free an mbuf from the lpfc_mbuf_pool PCI pool (locked)
+ * @phba: HBA which owns the pool to return to
+ * @virt: mbuf to free
+ * @dma: the DMA-mapped address of the lpfc_mbuf_pool to be freed
+ *
+ * Description: Returns an mbuf lpfc_mbuf_pool to the lpfc_mbuf_safety_pool if
+ * it is below its max_count, frees the mbuf otherwise.
+ *
+ * Notes: Must be called with phba->hbalock held to synchronize access to
+ * lpfc_mbuf_safety_pool.
+ *
+ * Returns: None
+ **/
 void
 __lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 {
@@ -221,7 +276,21 @@ __lpfc_mbuf_free(struct lpfc_hba * phba,
 	return;
 }
 
+/**
+ * lpfc_mem_free: Free an mbuf from the lpfc_mbuf_pool PCI pool (unlocked)
+ * @phba: HBA which owns the pool to return to
+ * @virt: mbuf to free
+ * @dma: the DMA-mapped address of the lpfc_mbuf_pool to be freed
+ *
+ * Description: Returns an mbuf lpfc_mbuf_pool to the lpfc_mbuf_safety_pool if
+ * it is below its max_count, frees the mbuf otherwise.
+ *
+ * Notes: Takes phba->hbalock.  Can be called with or without other locks held.
+ *
+ * Returns: None
+ **/
 void
+
 lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 {
 	unsigned long iflags;
@@ -232,6 +301,19 @@ lpfc_mbuf_free(struct lpfc_hba * phba, v
 	return;
 }
 
+/**
+ * lpfc_els_hbq_alloc: Allocate an HBQ buffer
+ * @phba: HBA to allocate HBQ buffer for
+ *
+ * Description: Allocates a DMA-mapped HBQ buffer from the lpfc_hbq_pool PCI
+ * pool along a non-DMA-mapped container for it.
+ *
+ * Notes: Not interrupt-safe.  Must be called with no locks held.
+ *
+ * Returns:
+ *   pointer to HBQ on success
+ *   NULL on failure
+ **/
 struct hbq_dmabuf *
 lpfc_els_hbq_alloc(struct lpfc_hba *phba)
 {
@@ -251,6 +333,18 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba
 	return hbqbp;
 }
 
+/**
+ * lpfc_mem_hbq_free: Frees an HBQ buffer allocated with lpfc_els_hbq_alloc
+ * @phba: HBA buffer was allocated for
+ * @hbqbp: HBQ container returned by lpfc_els_hbq_alloc
+ *
+ * Description: Frees both the container and the DMA-mapped buffer returned by
+ * lpfc_els_hbq_alloc.
+ *
+ * Notes: Can be called with or without locks held.
+ *
+ * Returns: None
+ **/
 void
 lpfc_els_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp)
 {
@@ -259,7 +353,18 @@ lpfc_els_hbq_free(struct lpfc_hba *phba,
 	return;
 }
 
-/* This is ONLY called for the LPFC_ELS_HBQ */
+/**
+ * lpfc_in_buf_free: Free a DMA buffer
+ * @phba: HBA buffer is associated with
+ * @mp: Buffer to free
+ *
+ * Description: Frees the given DMA buffer in the appropriate way given if the
+ * HBA is running in SLI3 mode with HBQs enabled.
+ *
+ * Notes: Takes phba->hbalock.  Can be called with or without other locks held.
+ *
+ * Returns: None
+ **/
 void
 lpfc_in_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 {


