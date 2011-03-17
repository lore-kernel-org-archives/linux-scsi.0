From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT] isci: fixes
Date: Thu, 17 Mar 2011 09:31:21 -0700
Message-ID: <1300379481.26377.21.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33918 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab1CQQ2H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 12:28:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Ed Nadolski <edmund.nadolski@intel.com>, Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>

The following changes since commit e1284121af9ead5b7490b3d2b0b47cce04db4361:

  Merge branch 'x86-pending' into upstream-pending (2011-03-10 00:15:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git upstream-pending

1/ Fixes around the usage of sas_task_abort()

2/ OEM parameter retrieval fixes

3/ Support for tuning some core parameters via module parameters (see
modinfo isci)

4/ Various cleanup and compile fixes

As before the upstream-pending branch is a convenience merge of master,
x86-pending, and libsas-pending.  The pci_map_biosrom() patch on
x86-pending [1] and all the libsas-pending patches have been submitted
for inclusion in 2.6.39.

--
Dan

[1]: http://marc.info/?l=linux-kernel&m=130023369018524&w=2

Dan Williams (6):
      isci: fix incorrect assumptions about task->dev and task->dev->port being NULL
      libsas: check dev->gone before submitting sata i/o
      isci: task.h compile and checkpatch fixes
      isci: fix oem parameter initialization and mode detection
      Merge branch 'libsas-pending' into upstream-pending
      Merge branch 'x86-pending' into upstream-pending

Dave Jiang (2):
      isci: Fixup for OEM parameter EFI variable retrieval
      isci: exposing user parameters via module params

Jeff Skirvin (3):
      isci: don't hold scic_lock over calls to sas_task_abort()
      isci: only call sas_task_abort for tasks with NEED_DEV_RESET
      isci: SATA/STP and SMP tasks are never explicitly put in the error path.

 drivers/scsi/isci/core/sci_base_controller.h |    2 -
 drivers/scsi/isci/core/scic_sds_controller.c |  103 ++++++++--------
 drivers/scsi/isci/firmware/create_fw.c       |   11 ++-
 drivers/scsi/isci/firmware/create_fw.h       |   39 ++++---
 drivers/scsi/isci/host.c                     |  102 +++++++++++-----
 drivers/scsi/isci/init.c                     |   36 +++++-
 drivers/scsi/isci/isci.h                     |    8 ++
 drivers/scsi/isci/probe_roms.c               |   73 +++++++++--
 drivers/scsi/isci/probe_roms.h               |   10 +-
 drivers/scsi/isci/request.c                  |   87 ++++++-------
 drivers/scsi/isci/task.c                     |  168 +++++++++-----------------
 drivers/scsi/isci/task.h                     |   60 +++++-----
 drivers/scsi/libsas/sas_scsi_host.c          |   14 +-
 firmware/isci/isci_firmware.bin.ihex         |   28 ++--
 14 files changed, 412 insertions(+), 329 deletions(-)

commit 96d087f60b6533fcf7222b58cbb102b1fecc60dd
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed Mar 16 14:57:23 2011 -0700

    isci: exposing user parameters via module params
    
    Exposing the user config parameters through the kernel module parameters.
    The kernel module params will have the default values set and we will no
    longer pulling the default values for user params from the core.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f7ec5db11172ec99efc3a43da774109917264826
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Mar 11 10:43:57 2011 -0800

    isci: fix oem parameter initialization and mode detection
    
    1/ Since commit 1709eec5 "isci: Move firmware loading to per PCI device" we have
       been silently falling back to built-in defaults for the parameter settings by
       skipping the call to scic_oem_parameters_set().
    
    2/ The afe parameters from the firmware were not being honored
    
    3/ The latest oem parameter definition flips the mode_type values which are
       now 0: for APC 1: for MPC.  For APC we need to make sure all the phys
       default to the same address otherwise strict_wide_ports will cause duplicate
       domains.
    
    4/ Fix up the driver announcement to indicate the source of the
       parameters.
    
    5/ Fix up the sas addresses to be unique per controller (in the fallback case)
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a32657b5602c3a51175824a2a41e448a9d7a1adb
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 17 08:04:43 2011 -0700

    isci: task.h compile and checkpatch fixes
    
    A usage of "FALSE" leaked in as well as some checkpatch escapes.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 7a18a48e0f70b8d17064523d8473d48a87d0400a
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Wed Mar 16 09:42:03 2011 -0700

    isci: SATA/STP and SMP tasks are never explicitly put in the error path.
    
    Since both SATA/STP and SMP device discovery work in their own threads
    and depend on their own timeout mechanism, errors detected in the
    execution of I/Os to those devices which would normally promote those
    I/Os into the error handler path instead are left to timeout, so that
    correct timeout handling will happen in whatever context in which the
    I/Os were started.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8dc962d12c66ebacf1ce60f510b3a41d6aa5ffe1
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Wed Mar 16 09:42:01 2011 -0700

    isci: only call sas_task_abort for tasks with NEED_DEV_RESET
    
    Aborted I/O (i.e one with a status not set to "completed" when being
    returned to libsas) are not allowed to enter the libsas error handler
    path.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6da3799637bc3a8cf62af72ab6e91ab9717f147f
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Wed Mar 16 09:41:59 2011 -0700

    isci: don't hold scic_lock over calls to sas_task_abort()
    
    In the case where submitted I/Os fail with the status code
    SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED, the execute function now waits
    until scic_lock is cleared before calling the helper function
    "isci_request_signal_device_reset" which sets the flag for the pending
    reset condition on the I/O.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 202eec1a3df59f2b0c7ba6d33735858dfe2f3cb4
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Fri Mar 11 14:04:43 2011 -0800

    isci: Fixup for OEM parameter EFI variable retrieval
    
    Updating the EFI variable OEM parameter retrieval after examining the EFI
    variable exported via sysfs.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0d17f0069cee7cf8b51a67d35130ebf35fe72522
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Mar 11 14:06:08 2011 -0800

    libsas: check dev->gone before submitting sata i/o
    
    Head off doomed-to-fail i/o in sas_queuecommand before sending it down
    the ata path.
    
    Before:
    sd 7:0:0:0: [sdd] Synchronizing SCSI cache
    ata8: no sense translation for status: 0x00
    ata8: translated ATA stat/err 0x00/00 to SCSI SK/ASC/ASCQ 0xb/00/00
    ata8.00: device reported invalid CHS sector 0
    ata8: status=0x00 { }
    ata8: no sense translation for status: 0x00
    ata8: translated ATA stat/err 0x00/00 to SCSI SK/ASC/ASCQ 0xb/00/00
    ata8.00: device reported invalid CHS sector 0
    ata8: status=0x00 { }
    ata8: no sense translation for status: 0x00
    ata8: translated ATA stat/err 0x00/00 to SCSI SK/ASC/ASCQ 0xb/00/00
    ata8.00: device reported invalid CHS sector 0
    ata8: status=0x00 { }
    sd 7:0:0:0: [sdd]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
    sd 7:0:0:0: [sdd]  Sense Key : Aborted Command [current] [descriptor]
    sd 7:0:0:0: [sdd]  Add. Sense: No additional sense information
    sd 7:0:0:0: [sdd] Stopping disk
    
    After:
    sd 9:0:0:0: [sdd] Synchronizing SCSI cache
    sd 9:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
    sd 9:0:0:0: [sdd] Stopping disk
    sd 9:0:0:0: [sdd] START_STOP FAILED
    sd 9:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
    
    This is a cosmetic change as sata i/o can still leak to a gone device,
    but this addresses the nominal hotplug case when releasing the target.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 73bab83af393eaa6053d3b15cd258409e6b3c805
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Mar 11 10:13:51 2011 -0800

    isci: fix incorrect assumptions about task->dev and task->dev->port being NULL
    
    A domain_device has the same lifetime as its related scsi_target.  The
    scsi_target is reference counted based on outstanding commands,
    therefore it is safe to assume that if we have a valid sas_task that the
    ->dev pointer is also valid.
    
    The asd_sas_port of a domain_device has the same lifetime as the driver
    so it can also never be NULL as long as the sas_task is valid and the
    driver is loaded.
    
    This also cleans up isci_task_complete_for_upper_layer(), renames it to
    isci_task_refuse() and notices that the isci_completion_selection
    parameter was set to isci_perform_normal_io_completion by all callers.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/core/sci_base_controller.h b/drivers/scsi/isci/core/sci_base_controller.h
index 36c5340..8e0c46f 100644
--- a/drivers/scsi/isci/core/sci_base_controller.h
+++ b/drivers/scsi/isci/core/sci_base_controller.h
@@ -289,8 +289,6 @@ static inline void sci_base_controller_construct(
 	u32 mde_count,
 	struct sci_base_memory_descriptor_list *next_mdl)
 {
-	scic_base->parent.private = NULL;
-
 	sci_base_state_machine_construct(
 		&scic_base->state_machine,
 		&scic_base->parent,
diff --git a/drivers/scsi/isci/core/scic_sds_controller.c b/drivers/scsi/isci/core/scic_sds_controller.c
index 74daee9..a4607b1 100644
--- a/drivers/scsi/isci/core/scic_sds_controller.c
+++ b/drivers/scsi/isci/core/scic_sds_controller.c
@@ -595,6 +595,7 @@ void scic_sds_controller_enable_port_task_scheduler(
  */
 void scic_sds_controller_afe_initialization(struct scic_sds_controller *scic)
 {
+	const struct scic_sds_oem_params *oem = &scic->oem_parameters.sds1;
 	u32 afe_status;
 	u32 phy_id;
 
@@ -632,6 +633,8 @@ void scic_sds_controller_afe_initialization(struct scic_sds_controller *scic)
 	}
 
 	for (phy_id = 0; phy_id < SCI_MAX_PHYS; phy_id++) {
+		const struct sci_phy_oem_params *oem_phy = &oem->phys[phy_id];
+
 		if (is_b0()) {
 			 /* Configure transmitter SSC parameters */
 			scu_afe_txreg_write(scic, phy_id, afe_tx_ssc_control, 0x00030000);
@@ -691,16 +694,16 @@ void scic_sds_controller_afe_initialization(struct scic_sds_controller *scic)
 		}
 		udelay(AFE_REGISTER_WRITE_DELAY);
 
-		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control0, 0x000E7C03);
+		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control0, oem_phy->afe_tx_amp_control0);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 
-		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control1, 0x000E7C03);
+		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control0, oem_phy->afe_tx_amp_control1);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 
-		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control2, 0x000E7C03);
+		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control0, oem_phy->afe_tx_amp_control2);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 
-		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control3, 0x000E7C03);
+		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control0, oem_phy->afe_tx_amp_control3);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 	}
 
@@ -2027,6 +2030,7 @@ void scic_sds_controller_release_frame(
  */
 static void scic_sds_controller_set_default_config_parameters(struct scic_sds_controller *scic)
 {
+	struct isci_host *ihost = sci_object_get_association(scic);
 	u16 index;
 
 	/* Default to APC mode. */
@@ -2058,7 +2062,7 @@ static void scic_sds_controller_set_default_config_parameters(struct scic_sds_co
 		 * is worked around by having the upper 32-bits of SAS address
 		 * with a value greater then the Vitesse company identifier.
 		 * Hence, usage of 0x5FCFFFFF. */
-		scic->oem_parameters.sds1.phys[index].sas_address.low = 0x00000001;
+		scic->oem_parameters.sds1.phys[index].sas_address.low = 0x1 + ihost->id;
 		scic->oem_parameters.sds1.phys[index].sas_address.high = 0x5FCFFFFF;
 	}
 
@@ -2544,41 +2548,46 @@ enum sci_status scic_user_parameters_set(
 	struct scic_sds_controller *scic,
 	union scic_user_parameters *scic_parms)
 {
-	if (
-		(scic->parent.state_machine.current_state_id
-		 == SCI_BASE_CONTROLLER_STATE_RESET)
-		|| (scic->parent.state_machine.current_state_id
-		    == SCI_BASE_CONTROLLER_STATE_INITIALIZING)
-		|| (scic->parent.state_machine.current_state_id
-		    == SCI_BASE_CONTROLLER_STATE_INITIALIZED)
-		) {
+	u32 state = scic->parent.state_machine.current_state_id;
+
+	if (state == SCI_BASE_CONTROLLER_STATE_RESET ||
+	    state == SCI_BASE_CONTROLLER_STATE_INITIALIZING ||
+	    state == SCI_BASE_CONTROLLER_STATE_INITIALIZED) {
 		u16 index;
 
 		/*
 		 * Validate the user parameters.  If they are not legal, then
-		 * return a failure. */
+		 * return a failure.
+		 */
 		for (index = 0; index < SCI_MAX_PHYS; index++) {
-			if (!(scic_parms->sds1.phys[index].max_speed_generation
-			     <= SCIC_SDS_PARM_MAX_SPEED
-			     && scic_parms->sds1.phys[index].max_speed_generation
-			     > SCIC_SDS_PARM_NO_SPEED))
+			struct sci_phy_user_params *user_phy;
+
+			user_phy = &scic_parms->sds1.phys[index];
+
+			if (!((user_phy->max_speed_generation <=
+						SCIC_SDS_PARM_MAX_SPEED) &&
+			      (user_phy->max_speed_generation >
+						SCIC_SDS_PARM_NO_SPEED)))
 				return SCI_FAILURE_INVALID_PARAMETER_VALUE;
 
-			if (scic_parms->sds1.phys[index].in_connection_align_insertion_frequency < 3)
+			if (user_phy->in_connection_align_insertion_frequency <
+					3)
 				return SCI_FAILURE_INVALID_PARAMETER_VALUE;
-			if (
-			    (scic_parms->sds1.phys[index].in_connection_align_insertion_frequency < 3) ||
-			    (scic_parms->sds1.phys[index].align_insertion_frequency == 0) ||
-			    (scic_parms->sds1.phys[index].notify_enable_spin_up_insertion_frequency == 0)
-			    )
+
+			if ((user_phy->in_connection_align_insertion_frequency <
+						3) ||
+			    (user_phy->align_insertion_frequency == 0) ||
+			    (user_phy->
+				notify_enable_spin_up_insertion_frequency ==
+						0))
 				return SCI_FAILURE_INVALID_PARAMETER_VALUE;
 		}
 
 		if ((scic_parms->sds1.stp_inactivity_timeout == 0) ||
-		   (scic_parms->sds1.ssp_inactivity_timeout == 0) ||
-		   (scic_parms->sds1.stp_max_occupancy_timeout == 0) ||
-		   (scic_parms->sds1.ssp_max_occupancy_timeout == 0) ||
-		   (scic_parms->sds1.no_outbound_task_timeout == 0))
+		    (scic_parms->sds1.ssp_inactivity_timeout == 0) ||
+		    (scic_parms->sds1.stp_max_occupancy_timeout == 0) ||
+		    (scic_parms->sds1.ssp_max_occupancy_timeout == 0) ||
+		    (scic_parms->sds1.no_outbound_task_timeout == 0))
 			return SCI_FAILURE_INVALID_PARAMETER_VALUE;
 
 		memcpy(&scic->user_parameters, scic_parms, sizeof(*scic_parms));
@@ -2604,14 +2613,11 @@ enum sci_status scic_oem_parameters_set(
 	struct scic_sds_controller *scic,
 	union scic_oem_parameters *scic_parms)
 {
-	if (
-		(scic->parent.state_machine.current_state_id
-		 == SCI_BASE_CONTROLLER_STATE_RESET)
-		|| (scic->parent.state_machine.current_state_id
-		    == SCI_BASE_CONTROLLER_STATE_INITIALIZING)
-		|| (scic->parent.state_machine.current_state_id
-		    == SCI_BASE_CONTROLLER_STATE_INITIALIZED)
-		) {
+	u32 state = scic->parent.state_machine.current_state_id;
+
+	if (state == SCI_BASE_CONTROLLER_STATE_RESET ||
+	    state == SCI_BASE_CONTROLLER_STATE_INITIALIZING ||
+	    state == SCI_BASE_CONTROLLER_STATE_INITIALIZED) {
 		u16 index;
 		u8  combined_phy_mask = 0;
 
@@ -2619,39 +2625,38 @@ enum sci_status scic_oem_parameters_set(
 		 * Validate the oem parameters.  If they are not legal, then
 		 * return a failure. */
 		for (index = 0; index < SCI_MAX_PORTS; index++) {
-			if (scic_parms->sds1.ports[index].phy_mask > SCIC_SDS_PARM_PHY_MASK_MAX) {
+			if (scic_parms->sds1.ports[index].phy_mask > SCIC_SDS_PARM_PHY_MASK_MAX)
 				return SCI_FAILURE_INVALID_PARAMETER_VALUE;
-			}
 		}
 
 		for (index = 0; index < SCI_MAX_PHYS; index++) {
-			if (
-				scic_parms->sds1.phys[index].sas_address.high == 0
-				&& scic_parms->sds1.phys[index].sas_address.low  == 0
-				) {
+			if ((scic_parms->sds1.phys[index].sas_address.high == 0) &&
+			    (scic_parms->sds1.phys[index].sas_address.low == 0))
 				return SCI_FAILURE_INVALID_PARAMETER_VALUE;
-			}
 		}
 
-		if (scic_parms->sds1.controller.mode_type == SCIC_PORT_AUTOMATIC_CONFIGURATION_MODE) {
+		if (scic_parms->sds1.controller.mode_type ==
+				SCIC_PORT_AUTOMATIC_CONFIGURATION_MODE) {
 			for (index = 0; index < SCI_MAX_PHYS; index++) {
 				if (scic_parms->sds1.ports[index].phy_mask != 0)
 					return SCI_FAILURE_INVALID_PARAMETER_VALUE;
 			}
-		} else if (scic_parms->sds1.controller.mode_type == SCIC_PORT_MANUAL_CONFIGURATION_MODE) {
+		} else if (scic_parms->sds1.controller.mode_type ==
+				SCIC_PORT_MANUAL_CONFIGURATION_MODE) {
 			for (index = 0; index < SCI_MAX_PHYS; index++)
 				combined_phy_mask |= scic_parms->sds1.ports[index].phy_mask;
 
 			if (combined_phy_mask == 0)
 				return SCI_FAILURE_INVALID_PARAMETER_VALUE;
-		} else {
+		} else
 			return SCI_FAILURE_INVALID_PARAMETER_VALUE;
-		}
 
-		if (scic_parms->sds1.controller.max_concurrent_dev_spin_up > MAX_CONCURRENT_DEVICE_SPIN_UP_COUNT)
+		if (scic_parms->sds1.controller.max_concurrent_dev_spin_up >
+				MAX_CONCURRENT_DEVICE_SPIN_UP_COUNT)
 			return SCI_FAILURE_INVALID_PARAMETER_VALUE;
 
-		memcpy(&scic->oem_parameters, scic_parms, sizeof(*scic_parms));
+		scic->oem_parameters.sds1 = scic_parms->sds1;
+
 		return SCI_SUCCESS;
 	}
 
diff --git a/drivers/scsi/isci/firmware/create_fw.c b/drivers/scsi/isci/firmware/create_fw.c
index f8f96d6..c7a2887 100644
--- a/drivers/scsi/isci/firmware/create_fw.c
+++ b/drivers/scsi/isci/firmware/create_fw.c
@@ -44,7 +44,7 @@ void set_binary_values(struct isci_orom *isci_orom)
 
 	/* setting OROM signature */
 	strncpy(isci_orom->hdr.signature, sig, strlen(sig));
-	isci_orom->hdr.version = 0x10;
+	isci_orom->hdr.version = version;
 	isci_orom->hdr.total_block_length = sizeof(struct isci_orom);
 	isci_orom->hdr.hdr_length = sizeof(struct sci_bios_oem_param_block_hdr);
 	isci_orom->hdr.num_elements = num_elements;
@@ -65,6 +65,15 @@ void set_binary_values(struct isci_orom *isci_orom)
 				(__u32)(sas_addr[ctrl_idx][phy_idx] >> 32);
 			isci_orom->ctrl[ctrl_idx].phys[phy_idx].sas_address.low =
 				(__u32)(sas_addr[ctrl_idx][phy_idx]);
+
+			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control0 =
+				afe_tx_amp_control0;
+			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control1 =
+				afe_tx_amp_control1;
+			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control2 =
+				afe_tx_amp_control2;
+			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control3 =
+				afe_tx_amp_control3;
 		}
 	}
 }
diff --git a/drivers/scsi/isci/firmware/create_fw.h b/drivers/scsi/isci/firmware/create_fw.h
index 788a8de..9f9afbd 100644
--- a/drivers/scsi/isci/firmware/create_fw.h
+++ b/drivers/scsi/isci/firmware/create_fw.h
@@ -25,14 +25,37 @@ static const int num_elements = 2;
  * if there is a port/phy on which you do not wish to override the default
  * values, use the value assigned to UNINIT_PARAM (255).
  */
+
 /* discovery mode type (port auto config mode by default ) */
+
+/*
+ * if there is a port/phy on which you do not wish to override the default
+ * values, use the value "0000000000000000". SAS address of zero's is
+ * considered invalid and will not be used.
+ */
 #ifdef MPC
 static const int mode_type = SCIC_PORT_MANUAL_CONFIGURATION_MODE;
 static const __u8 phy_mask[2][4] = { {1, 2, 4, 8},
 				     {1, 2, 4, 8} };
+static const unsigned long long sas_addr[2][4] = { { 0x5FCFFFFFF0000001ULL,
+						     0x5FCFFFFFF0000002ULL,
+						     0x5FCFFFFFF0000003ULL,
+						     0x5FCFFFFFF0000004ULL },
+						   { 0x5FCFFFFFF0000005ULL,
+						     0x5FCFFFFFF0000006ULL,
+						     0x5FCFFFFFF0000007ULL,
+						     0x5FCFFFFFF0000008ULL } };
 #else	/* APC (default) */
 static const int mode_type = SCIC_PORT_AUTOMATIC_CONFIGURATION_MODE;
 static const __u8 phy_mask[2][4];
+static const unsigned long long sas_addr[2][4] = { { 0x5FCFFFFF00000001ULL,
+						     0x5FCFFFFF00000001ULL,
+						     0x5FCFFFFF00000001ULL,
+						     0x5FCFFFFF00000001ULL },
+						   { 0x5FCFFFFF00000002ULL,
+						     0x5FCFFFFF00000002ULL,
+						     0x5FCFFFFF00000002ULL,
+						     0x5FCFFFFF00000002ULL } };
 #endif
 
 /* Maximum number of concurrent device spin up */
@@ -47,22 +70,8 @@ static const unsigned int afe_tx_amp_control1 = 0x000e7c03;
 static const unsigned int afe_tx_amp_control2 = 0x000e7c03;
 static const unsigned int afe_tx_amp_control3 = 0x000e7c03;
 
-/*
- * if there is a port/phy on which you do not wish to override the default
- * values, use the value "0000000000000000". SAS address of zero's is
- * considered invalid and will not be used.
- */
-static const unsigned long long sas_addr[2][4] = { { 0x5FCFFFFFF0000000ULL,
-						     0x5FCFFFFFF1000000ULL,
-						     0x5FCFFFFFF2000000ULL,
-						     0x5FCFFFFFF3000000ULL },
-						   { 0x5FCFFFFFF4000000ULL,
-						     0x5FCFFFFFF5000000ULL,
-						     0x5FCFFFFFF6000000ULL,
-						     0x5FCFFFFFF7000000ULL } };
-
 static const char blob_name[] = "isci_firmware.bin";
 static const char sig[] = "ISCUOEMB";
-static const unsigned char version = 1;
+static const unsigned char version = 0x10;
 
 #endif
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index bb5b54d..8712b2e 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -332,21 +332,39 @@ static void isci_host_completion_routine(unsigned long data)
 
 		task = isci_request_access_task(request);
 
-		/* Use sas_task_abort */
-		dev_warn(&isci_host->pdev->dev,
-			 "%s: Error - request/task = %p/%p\n",
-			 __func__,
-			 request,
-			 task);
-
 		if (task != NULL) {
 
-			/* Put the task into the abort path if it's not there
-			 * already.
-			 */
-			if (!(task->task_state_flags & SAS_TASK_STATE_ABORTED))
-				sas_task_abort(task);
-
+			if (task->task_proto & (SAS_PROTOCOL_SATA
+					      | SAS_PROTOCOL_SMP
+					      | SAS_PROTOCOL_STP)) {
+				/* SATA/STP and SMP tasks are not put into the
+				 * error path because of those protocols'
+				 * discovery implementation in libsas.
+				 *
+				 * The only thing that can be done now is to
+				 * let the I/O timeout so that the abort
+				 * task interface will be called.
+				 */
+				dev_warn(&isci_host->pdev->dev,
+					 "%s: Error - SMP/SATA/STP (%x) "
+					 "request/task = %p/%p is being left"
+					 "to time out!\n",
+					 __func__, task->task_proto, request,
+					 task);
+
+			} else {
+				/* Use sas_task_abort */
+				dev_warn(&isci_host->pdev->dev,
+					 "%s: Error - request/task = %p/%p\n",
+					 __func__, request, task);
+
+				/* Put the task into the abort path if it's
+				 * not there already.
+				*/
+				if (!(task->task_state_flags
+				     & SAS_TASK_STATE_ABORTED))
+					sas_task_abort(task);
+			}
 		} else {
 			/* This is a case where the request has completed with a
 			 * status such that it needed further target servicing,
@@ -413,12 +431,38 @@ static void __iomem *smu_base(struct isci_host *isci_host)
 	return pcim_iomap_table(pdev)[SCI_SMU_BAR * 2] + SCI_SMU_BAR_SIZE * id;
 }
 
+static void isci_user_parameters_get(
+		struct isci_host *isci_host,
+		union scic_user_parameters *scic_user_params)
+{
+	struct scic_sds_user_parameters *u = &scic_user_params->sds1;
+	int i;
+
+	for (i = 0; i < SCI_MAX_PHYS; i++) {
+		struct sci_phy_user_params *u_phy = &u->phys[i];
+
+		u_phy->max_speed_generation = phy_gen;
+
+		/* we are not exporting these for now */
+		u_phy->align_insertion_frequency = 0x7f;
+		u_phy->in_connection_align_insertion_frequency = 0xff;
+		u_phy->notify_enable_spin_up_insertion_frequency = 0x33;
+	}
+
+	u->stp_inactivity_timeout = stp_inactive_to;
+	u->ssp_inactivity_timeout = ssp_inactive_to;
+	u->stp_max_occupancy_timeout = stp_max_occ_to;
+	u->ssp_max_occupancy_timeout = ssp_max_occ_to;
+	u->no_outbound_task_timeout = no_outbound_task_to;
+	u->max_number_concurrent_device_spin_up = max_concurr_spinup;
+}
+
 int isci_host_init(struct isci_host *isci_host)
 {
 	int err = 0, i;
 	enum sci_status status;
 	struct scic_sds_controller *controller;
-	union scic_oem_parameters scic_oem_params;
+	union scic_oem_parameters oem;
 	union scic_user_parameters scic_user_params;
 	struct isci_pci_info *pci_info = to_pci_info(isci_host->pdev);
 
@@ -435,6 +479,7 @@ int isci_host_init(struct isci_host *isci_host)
 	}
 
 	isci_host->core_controller = controller;
+	sci_object_set_association(isci_host->core_controller, isci_host);
 	spin_lock_init(&isci_host->state_lock);
 	spin_lock_init(&isci_host->scic_lock);
 	spin_lock_init(&isci_host->queue_lock);
@@ -457,17 +502,11 @@ int isci_host_init(struct isci_host *isci_host)
 	isci_host->sas_ha.dev = &isci_host->pdev->dev;
 	isci_host->sas_ha.lldd_ha = isci_host;
 
-	/*----------- SCIC controller Initialization Stuff ------------------
-	 * set association host adapter struct in core controller.
-	 */
-	sci_object_set_association(isci_host->core_controller,
-				   (void *)isci_host);
-
 	/*
 	 * grab initial values stored in the controller object for OEM and USER
 	 * parameters
 	 */
-	scic_user_parameters_get(controller, &scic_user_params);
+	isci_user_parameters_get(isci_host, &scic_user_params);
 	status = scic_user_parameters_set(isci_host->core_controller,
 					  &scic_user_params);
 	if (status != SCI_SUCCESS) {
@@ -477,11 +516,11 @@ int isci_host_init(struct isci_host *isci_host)
 		return -ENODEV;
 	}
 
-	scic_oem_parameters_get(controller, &scic_oem_params);
+	scic_oem_parameters_get(controller, &oem);
 
 	/* grab any OEM parameters specified in orom */
 	if (pci_info->orom) {
-		status = isci_parse_oem_parameters(&scic_oem_params,
+		status = isci_parse_oem_parameters(&oem,
 						   pci_info->orom,
 						   isci_host->id);
 		if (status != SCI_SUCCESS) {
@@ -489,15 +528,14 @@ int isci_host_init(struct isci_host *isci_host)
 				 "parsing firmware oem parameters failed\n");
 			return -EINVAL;
 		}
-	} else {
-		status = scic_oem_parameters_set(isci_host->core_controller,
-						 &scic_oem_params);
-		if (status != SCI_SUCCESS) {
-			dev_warn(&isci_host->pdev->dev,
-				 "%s: scic_oem_parameters_set failed\n",
-				 __func__);
-			return -ENODEV;
-		}
+	}
+
+	status = scic_oem_parameters_set(isci_host->core_controller, &oem);
+	if (status != SCI_SUCCESS) {
+		dev_warn(&isci_host->pdev->dev,
+				"%s: scic_oem_parameters_set failed\n",
+				__func__);
+		return -ENODEV;
 	}
 
 	tasklet_init(&isci_host->completion_tasklet,
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 6ec1ab8..7ca2a08 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -114,9 +114,37 @@ int isci_si_rev = ISCI_SI_REVA2;
 #else
 int isci_si_rev = ISCI_SI_REVB0;
 #endif
-module_param(isci_si_rev, int, S_IRUGO | S_IWUSR);
+module_param(isci_si_rev, int, 0);
 MODULE_PARM_DESC(isci_si_rev, "override default si rev (0: A0 1: A2 2: B0)");
 
+unsigned char no_outbound_task_to = 20;
+module_param(no_outbound_task_to, byte, 0);
+MODULE_PARM_DESC(no_outbound_task_to, "No Outbound Task Timeout (1us incr)");
+
+u16 ssp_max_occ_to = 20;
+module_param(ssp_max_occ_to, ushort, 0);
+MODULE_PARM_DESC(ssp_max_occ_to, "SSP Max occupancy timeout (100us incr)");
+
+u16 stp_max_occ_to = 5;
+module_param(stp_max_occ_to, ushort, 0);
+MODULE_PARM_DESC(stp_max_occ_to, "STP Max occupancy timeout (100us incr)");
+
+u16 ssp_inactive_to = 5;
+module_param(ssp_inactive_to, ushort, 0);
+MODULE_PARM_DESC(ssp_inactive_to, "SSP inactivity timeout (100us incr)");
+
+u16 stp_inactive_to = 5;
+module_param(stp_inactive_to, ushort, 0);
+MODULE_PARM_DESC(stp_inactive_to, "STP inactivity timeout (100us incr)");
+
+unsigned char phy_gen = 3;
+module_param(phy_gen, byte, 0);
+MODULE_PARM_DESC(phy_gen, "PHY generation (1: 1.5Gbps 2: 3.0Gbps 3: 6.0Gbps)");
+
+unsigned char max_concurr_spinup = 1;
+module_param(max_concurr_spinup, byte, 0);
+MODULE_PARM_DESC(max_concurr_spinup, "Max concurrent device spinup");
+
 static struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
@@ -470,6 +498,7 @@ static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_devic
 	struct isci_host *isci_host;
 	const struct firmware *fw = NULL;
 	struct isci_orom *orom;
+	char *source = "(platform)";
 
 	check_si_rev(pdev);
 
@@ -484,6 +513,7 @@ static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_devic
 		orom = isci_request_oprom(pdev);
 
 	if (!orom) {
+		source = "(firmware)";
 		orom = isci_request_firmware(pdev, fw);
 		if (!orom) {
 			/* TODO convert this to WARN_TAINT_ONCE once the
@@ -500,9 +530,9 @@ static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_devic
 
 	if (orom)
 		dev_info(&pdev->dev,
-			 "OEM SAS parameters (version: %u.%u) loaded\n",
+			 "OEM SAS parameters (version: %u.%u) loaded %s\n",
 			 (orom->hdr.version & 0xf0) >> 4,
-			 (orom->hdr.version & 0xf));
+			 (orom->hdr.version & 0xf), source);
 
 	pci_info->orom = orom;
 
diff --git a/drivers/scsi/isci/isci.h b/drivers/scsi/isci/isci.h
index 83422d4..a2df59c 100644
--- a/drivers/scsi/isci/isci.h
+++ b/drivers/scsi/isci/isci.h
@@ -75,6 +75,14 @@
 #include "task.h"
 #include "sata.h"
 
+extern unsigned char no_outbound_task_to;
+extern u16 ssp_max_occ_to;
+extern u16 stp_max_occ_to;
+extern u16 ssp_inactive_to;
+extern u16 stp_inactive_to;
+extern unsigned char phy_gen;
+extern unsigned char max_concurr_spinup;
+
 irqreturn_t isci_msix_isr(int vec, void *data);
 irqreturn_t isci_intx_isr(int vec, void *data);
 irqreturn_t isci_error_isr(int vec, void *data);
diff --git a/drivers/scsi/isci/probe_roms.c b/drivers/scsi/isci/probe_roms.c
index 3f6f8c9..a69be59 100644
--- a/drivers/scsi/isci/probe_roms.c
+++ b/drivers/scsi/isci/probe_roms.c
@@ -61,6 +61,11 @@ struct isci_orom *isci_request_oprom(struct pci_dev *pdev)
 
 	len = pci_biosrom_size(pdev);
 	rom = devm_kzalloc(&pdev->dev, sizeof(*rom), GFP_KERNEL);
+	if (!rom) {
+		dev_warn(&pdev->dev,
+			 "Unable to allocate memory for orom\n");
+		return NULL;
+	}
 
 	for (i = 0; i < len && rom; i += ISCI_OEM_SIG_SIZE) {
 		memcpy_fromio(oem_sig, oprom + i, ISCI_OEM_SIG_SIZE);
@@ -133,10 +138,7 @@ enum sci_status isci_parse_oem_parameters(union scic_oem_parameters *oem_params,
 	    scu_index > orom->hdr.num_elements || !oem_params)
 		return -EINVAL;
 
-	memcpy(oem_params,
-	       &orom->ctrl[scu_index],
-	       sizeof(struct scic_sds_oem_params));
-
+	oem_params->sds1 = orom->ctrl[scu_index];
 	return 0;
 }
 
@@ -172,7 +174,11 @@ struct isci_orom *isci_get_efi_var(struct pci_dev *pdev)
 {
 	struct efi_variable *evar;
 	efi_status_t status;
-	struct isci_orom *orom = NULL;
+	struct isci_orom *rom = NULL;
+	struct isci_oem_hdr *oem_hdr;
+	u8 *tmp, sum;
+	int j;
+	size_t copy_len;
 
 	evar = devm_kzalloc(&pdev->dev,
 			    sizeof(struct efi_variable),
@@ -183,6 +189,16 @@ struct isci_orom *isci_get_efi_var(struct pci_dev *pdev)
 		return NULL;
 	}
 
+	rom = devm_kzalloc(&pdev->dev, sizeof(*rom), GFP_KERNEL);
+	if (!rom) {
+		dev_warn(&pdev->dev,
+			 "Unable to allocate memory for orom\n");
+		return NULL;
+	}
+
+	for (j = 0; j < strlen(ISCI_EFI_VAR_NAME) + 1; j++)
+		evar->VariableName[j] = ISCI_EFI_VAR_NAME[j];
+
 	evar->DataSize = 1024;
 	evar->VendorGuid = ISCI_EFI_VENDOR_GUID;
 	evar->Attributes = ISCI_EFI_ATTRIBUTES;
@@ -193,19 +209,48 @@ struct isci_orom *isci_get_efi_var(struct pci_dev *pdev)
 				   &evar->DataSize,
 				   evar->Data);
 
-	if (status == EFI_SUCCESS)
-		orom = (struct isci_orom *)evar->Data;
-	else
+	if (status != EFI_SUCCESS) {
 		dev_warn(&pdev->dev,
 			 "Unable to obtain EFI variable for OEM parms\n");
+		return NULL;
+	}
+
+	oem_hdr = (struct isci_oem_hdr *)evar->Data;
 
-	if (orom && memcmp(orom->hdr.signature, ISCI_ROM_SIG,
-			   strlen(ISCI_ROM_SIG)) != 0)
+	if (memcmp(oem_hdr->sig, ISCI_OEM_SIG, ISCI_OEM_SIG_SIZE) != 0) {
 		dev_warn(&pdev->dev,
-			 "Verifying OROM signature failed\n");
+			 "Invalid OEM header signature\n");
+		return NULL;
+	}
 
-	if (!orom)
-		devm_kfree(&pdev->dev, evar);
+	/* calculate checksum */
+	tmp = (u8 *)oem_hdr;
+	for (j = 0, sum = 0; j < sizeof(oem_hdr); j++, tmp++)
+		sum += *tmp;
 
-	return orom;
+	tmp = (u8 *)rom;
+	for (j = 0; j < sizeof(*rom); j++, tmp++)
+		sum += *tmp;
+
+	if (sum != 0) {
+		dev_warn(&pdev->dev,
+			 "OEM table checksum failed\n");
+		return NULL;
+	}
+
+	copy_len = min(evar->DataSize,
+		       min(oem_hdr->len - sizeof(*oem_hdr),
+			   sizeof(*rom)));
+
+	memcpy(rom, (char *)evar->Data + sizeof(*oem_hdr), copy_len);
+
+	if (memcmp(rom->hdr.signature,
+		   ISCI_ROM_SIG,
+		   ISCI_ROM_SIG_SIZE) != 0) {
+		dev_warn(&pdev->dev,
+			 "Invalid OEM table signature\n");
+		return NULL;
+	}
+
+	return rom;
 }
diff --git a/drivers/scsi/isci/probe_roms.h b/drivers/scsi/isci/probe_roms.h
index 0449239..1b44483 100644
--- a/drivers/scsi/isci/probe_roms.h
+++ b/drivers/scsi/isci/probe_roms.h
@@ -96,11 +96,15 @@ struct isci_oem_hdr {
 #define ISCI_ROM_SIG		"ISCUOEMB"
 #define ISCI_ROM_SIG_SIZE	8
 
+#define ISCI_PREBOOT_SOURCE_INIT     (0x00)
+#define ISCI_PREBOOT_SOURCE_OROM     (0x80)
+#define ISCI_PREBOOT_SOURCE_EFI      (0x81)
+
 #define ISCI_EFI_VENDOR_GUID	\
 	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, \
 			0x1a, 0x04, 0xc6)
 #define ISCI_EFI_ATTRIBUTES	0
-#define ISCI_EFI_VAR_NAME	"RST_SCU_OEM"
+#define ISCI_EFI_VAR_NAME	"RstScuO"
 
 /* Allowed PORT configuration modes APC Automatic PORT configuration mode is
  * defined by the OEM configuration parameters providing no PHY_MASK parameters
@@ -112,8 +116,8 @@ struct isci_oem_hdr {
  * being assigned is sufficient to declare manual PORT configuration.
  */
 enum SCIC_PORT_CONFIGURATION_MODE {
-	SCIC_PORT_MANUAL_CONFIGURATION_MODE = 0,
-	SCIC_PORT_AUTOMATIC_CONFIGURATION_MODE = 1
+	SCIC_PORT_AUTOMATIC_CONFIGURATION_MODE = 0,
+	SCIC_PORT_MANUAL_CONFIGURATION_MODE = 1
 };
 
 struct sci_bios_oem_param_block_hdr {
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 0156431..6d81c41 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -356,33 +356,6 @@ int isci_request_alloc_tmf(
 }
 
 /**
- * isci_request_signal_device_reset() - This function will set the "device
- *    needs target reset" flag in the given sas_tasks' task_state_flags, and
- *    then cause the task to be added into the SCSI error handler queue which
- *    will eventually be escalated to a target reset.
- *
- *
- */
-static void isci_request_signal_device_reset(
-	struct isci_request *isci_request)
-{
-	unsigned long flags;
-	struct sas_task *task = isci_request_access_task(isci_request);
-
-	dev_dbg(&isci_request->isci_host->pdev->dev,
-		"%s: request=%p, task=%p\n", __func__, isci_request, task);
-
-	spin_lock_irqsave(&task->task_state_lock, flags);
-	task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
-
-	/* Cause this task to be scheduled in the SCSI error handler
-	 * thread.
-	 */
-	sas_task_abort(task);
-}
-
-/**
  * isci_request_execute() - This function allocates the isci_request object,
  *    all fills in some common fields.
  * @isci_host: This parameter specifies the ISCI host object
@@ -435,7 +408,8 @@ int isci_request_execute(
 			);
 
 		if (status == SCI_SUCCESS ||
-		    status == SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED) {
+		    (status == SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED &&
+		     task->task_proto != SAS_PROTOCOL_SMP)) {
 
 			/* Either I/O started OK, or the core has signaled that
 			 * the device needs a target reset.
@@ -449,26 +423,17 @@ int isci_request_execute(
 			list_add(&request->dev_node,
 				 &isci_device->reqs_in_process);
 
-			if (status ==
-				SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED) {
-				/* Signal libsas that we need the SCSI error
-				 * handler thread to work on this I/O and that
-				 * we want a device reset.
-				 */
-				isci_request_signal_device_reset(request);
-
-				/* Change the status, since we are holding
-				 * the I/O until it is managed by the SCSI
-				 * error handler.
-				 */
-				status = SCI_SUCCESS;
-			}
-			else
+			if (status == SCI_SUCCESS) {
 				/* Save the tag for possible task mgmt later. */
 				request->io_tag = scic_io_request_get_io_tag(
 						     request->sci_request_handle);
-
-
+			} else {
+				/* The request did not really start in the
+				 * hardware, so clear the request handle
+				 * here so no terminations will be done.
+				*/
+				request->sci_request_handle = NULL;
+			}
 		} else
 			dev_warn(&isci_host->pdev->dev,
 				 "%s: failed request start\n",
@@ -476,6 +441,35 @@ int isci_request_execute(
 
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 
+		if (status == SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED &&
+		    task->task_proto != SAS_PROTOCOL_SMP) {
+
+			dev_dbg(&request->isci_host->pdev->dev,
+				"%s: request=%p, task=%p\n",
+				__func__, request, task);
+
+			/* Signal libsas that we need the SCSI error
+			* handler thread to work on this I/O and that
+			* we want a device reset.
+			*/
+			spin_lock_irqsave(&task->task_state_lock, flags);
+			task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+			if (task->task_proto & SAS_PROTOCOL_SSP) {
+
+				/* Cause this task to be scheduled in the SCSI
+				 * error handler thread.
+				 */
+				sas_task_abort(task);
+			}
+			/* Change the status, since we are holding
+			* the I/O until it is managed by the SCSI
+			* error handler.
+			*/
+			status = SCI_SUCCESS;
+		}
+
 	} else
 		dev_warn(&isci_host->pdev->dev,
 			 "%s: request_construct failed - status = 0x%x\n",
@@ -798,7 +792,8 @@ static void isci_task_save_for_upper_layer_completion(
 
 	task_notification_selection
 		= isci_task_set_completion_status(task, response, status,
-						  task_notification_selection);
+						  task_notification_selection,
+						  request->status);
 
 	/* Tasks aborted specifically by a call to the lldd_abort_task
 	 * function should not be completed to the host in the regular path.
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index d00b4c9..a80685f 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -67,39 +67,36 @@
 #include "task.h"
 
 /**
-* isci_task_complete_for_upper_layer() - This function completes the request
-*    to the upper layer driver in the case where an I/O needs to be completed
-*    back in the submit path.
-* @host: This parameter is a pointer to the host on which the the request
-*    should be queued (either as an error or success).
-* @task: This parameter is the completed request.
-* @response: This parameter is the response code for the completed task.
-* @status: This parameter is the status code for the completed task.
+* isci_task_refuse() - complete the request to the upper layer driver in
+*     the case where an I/O needs to be completed back in the submit path.
+* @ihost: host on which the the request was queued
+* @task: request to complete
+* @response: response code for the completed task.
+* @status: status code for the completed task.
 *
-* none.
 */
-static void isci_task_complete_for_upper_layer(struct sas_task *task,
-					       enum service_response response,
-					       enum exec_status status,
-					       enum isci_completion_selection task_notification_selection)
+static void isci_task_refuse(struct isci_host *ihost, struct sas_task *task,
+			     enum service_response response,
+			     enum exec_status status)
+
 {
-	unsigned long    flags = 0;
-	struct Scsi_Host *host = NULL;
+	enum isci_completion_selection disposition;
 
-	task_notification_selection
-		= isci_task_set_completion_status(task, response, status,
-						  task_notification_selection);
+	disposition = isci_perform_normal_io_completion;
+	disposition = isci_task_set_completion_status(task, response, status,
+						      disposition, completed);
 
 	/* Tasks aborted specifically by a call to the lldd_abort_task
-	* function should not be completed to the host in the regular path.
-	*/
-	switch (task_notification_selection) {
+	 * function should not be completed to the host in the regular path.
+	 */
+	switch (disposition) {
 		case isci_perform_normal_io_completion:
 			/* Normal notification (task_done) */
-			dev_dbg(task->dev->port->ha->dev,
+			dev_dbg(&ihost->pdev->dev,
 				"%s: Normal - task = %p, response=%d, status=%d\n",
 				__func__, task, response, status);
 
+			task->lldd_task = NULL;
 			if (dev_is_sata(task->dev)) {
 				/* Since we are still in the submit path, and since
 				* libsas takes the host lock on behalf of SATA
@@ -107,44 +104,36 @@ static void isci_task_complete_for_upper_layer(struct sas_task *task,
 				* before we can call back and report the I/O
 				* submission error.
 				*/
-				if (task->dev
-				    && task->dev->port
-				    && task->dev->port->ha) {
+				unsigned long flags;
 
-					host = task->dev->port->ha->core.shost;
-					raw_local_irq_save(flags);
-					spin_unlock(host->host_lock);
-				}
+				raw_local_irq_save(flags);
+				spin_unlock(ihost->shost->host_lock);
 				task->task_done(task);
-				if (host) {
-					spin_lock(host->host_lock);
-					raw_local_irq_restore(flags);
-				}
+				spin_lock(ihost->shost->host_lock);
+				raw_local_irq_restore(flags);
 			} else
 				task->task_done(task);
-
-			task->lldd_task = NULL;
 			break;
 
 		case isci_perform_aborted_io_completion:
 			/* No notification because this request is already in the
 			* abort path.
 			*/
-			dev_warn(task->dev->port->ha->dev,
+			dev_warn(&ihost->pdev->dev,
 				 "%s: Aborted - task = %p, response=%d, status=%d\n",
 				 __func__, task, response, status);
 			break;
 
 		case isci_perform_error_io_completion:
 			/* Use sas_task_abort */
-			dev_warn(task->dev->port->ha->dev,
+			dev_warn(&ihost->pdev->dev,
 				 "%s: Error - task = %p, response=%d, status=%d\n",
 				 __func__, task, response, status);
 			sas_task_abort(task);
 			break;
 
 		default:
-			dev_warn(task->dev->port->ha->dev,
+			dev_warn(&ihost->pdev->dev,
 				 "%s: isci task notification default case!",
 				 __func__);
 			sas_task_abort(task);
@@ -152,6 +141,10 @@ static void isci_task_complete_for_upper_layer(struct sas_task *task,
 	}
 }
 
+#define for_each_sas_task(num, task) \
+	for (; num > 0; num--,\
+	     task = list_entry(task->list.next, struct sas_task, list))
+
 /**
  * isci_task_execute_task() - This function is one of the SAS Domain Template
  *    functions. This function is called by libsas to send a task down to
@@ -164,7 +157,7 @@ static void isci_task_complete_for_upper_layer(struct sas_task *task,
  */
 int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
 {
-	struct isci_host *isci_host;
+	struct isci_host *ihost = task->dev->port->ha->lldd_ha;
 	struct isci_request *request = NULL;
 	struct isci_remote_device *device;
 	unsigned long flags;
@@ -172,60 +165,23 @@ int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
 	enum sci_status status;
 	enum isci_status device_status;
 
-	dev_dbg(task->dev->port->ha->dev, "%s: num=%d\n", __func__, num);
-
-	if ((task->dev == NULL) || (task->dev->port == NULL)) {
-
-		/* Indicate SAS_TASK_UNDELIVERED, so that the scsi midlayer
-		 * removes the target.
-		 */
-		isci_task_complete_for_upper_layer(
-			task,
-			SAS_TASK_UNDELIVERED,
-			SAS_DEVICE_UNKNOWN,
-			isci_perform_normal_io_completion
-			);
-		return 0;  /* The I/O was accepted (and failed). */
-	}
-	isci_host = isci_host_from_sas_ha(task->dev->port->ha);
+	dev_dbg(&ihost->pdev->dev, "%s: num=%d\n", __func__, num);
 
 	/* Check if we have room for more tasks */
-	ret = isci_host_can_queue(isci_host, num);
+	ret = isci_host_can_queue(ihost, num);
 
 	if (ret) {
-		dev_warn(task->dev->port->ha->dev, "%s: queue full\n", __func__);
+		dev_warn(&ihost->pdev->dev, "%s: queue full\n", __func__);
 		return ret;
 	}
 
-	do {
-		dev_dbg(task->dev->port->ha->dev,
+	for_each_sas_task(num, task) {
+		dev_dbg(&ihost->pdev->dev,
 			"task = %p, num = %d; dev = %p; cmd = %p\n",
 			    task, num, task->dev, task->uldd_task);
 
-		if ((task->dev == NULL) || (task->dev->port == NULL)) {
-			dev_warn(task->dev->port->ha->dev,
-				 "%s: task %p's port or dev == NULL!\n",
-				 __func__, task);
-
-			/* Indicate SAS_TASK_UNDELIVERED, so that the scsi
-			 * midlayer removes the target.
-			 */
-			isci_task_complete_for_upper_layer(
-				task,
-				SAS_TASK_UNDELIVERED,
-				SAS_DEVICE_UNKNOWN,
-				isci_perform_normal_io_completion
-				);
-			/* We don't have a valid host reference, so we
-			 * can't control the host queueing condition.
-			 */
-			goto next_task;
-		}
-
 		device = isci_dev_from_domain_dev(task->dev);
 
-		isci_host = isci_host_from_sas_ha(task->dev->port->ha);
-
 		if (device)
 			device_status = device->status;
 		else
@@ -239,34 +195,28 @@ int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
 		if (device_status != isci_ready_for_io) {
 
 			/* Forces a retry from scsi mid layer. */
-			dev_warn(task->dev->port->ha->dev,
+			dev_warn(&ihost->pdev->dev,
 				 "%s: task %p: isci_host->status = %d, "
 				 "device = %p; device_status = 0x%x\n\n",
 				 __func__,
 				 task,
-				 isci_host_get_state(isci_host),
+				 isci_host_get_state(ihost),
 				 device, device_status);
 
 			if (device_status == isci_ready) {
 				/* Indicate QUEUE_FULL so that the scsi midlayer
 				* retries.
 				*/
-				isci_task_complete_for_upper_layer(
-					task,
-					SAS_TASK_COMPLETE,
-					SAS_QUEUE_FULL,
-					isci_perform_normal_io_completion
-					);
+				isci_task_refuse(ihost, task,
+						 SAS_TASK_COMPLETE,
+						 SAS_QUEUE_FULL);
 			} else {
 				/* Else, the device is going down. */
-				isci_task_complete_for_upper_layer(
-					task,
-					SAS_TASK_UNDELIVERED,
-					SAS_DEVICE_UNKNOWN,
-					isci_perform_normal_io_completion
-					);
+				isci_task_refuse(ihost, task,
+						 SAS_TASK_UNDELIVERED,
+						 SAS_DEVICE_UNKNOWN);
 			}
-			isci_host_can_dequeue(isci_host, 1);
+			isci_host_can_dequeue(ihost, 1);
 		} else {
 			/* There is a device and it's ready for I/O. */
 			spin_lock_irqsave(&task->task_state_lock, flags);
@@ -276,12 +226,9 @@ int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
 				spin_unlock_irqrestore(&task->task_state_lock,
 						       flags);
 
-				isci_task_complete_for_upper_layer(
-					task,
-					SAS_TASK_UNDELIVERED,
-					SAM_STAT_TASK_ABORTED,
-					isci_perform_normal_io_completion
-					);
+				isci_task_refuse(ihost, task,
+						 SAS_TASK_UNDELIVERED,
+						 SAM_STAT_TASK_ABORTED);
 
 				/* The I/O was aborted. */
 
@@ -290,7 +237,7 @@ int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
 				spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 				/* build and send the request. */
-				status = isci_request_execute(isci_host, task, &request,
+				status = isci_request_execute(ihost, task, &request,
 							      gfp_flags);
 
 				if (status != SCI_SUCCESS) {
@@ -307,19 +254,14 @@ int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
 					* SAS_TASK_UNDELIVERED next time
 					* through.
 					*/
-					isci_task_complete_for_upper_layer(
-						task,
-						SAS_TASK_COMPLETE,
-						SAS_QUEUE_FULL,
-						isci_perform_normal_io_completion
-						);
-					isci_host_can_dequeue(isci_host, 1);
+					isci_task_refuse(ihost, task,
+							 SAS_TASK_COMPLETE,
+							 SAS_QUEUE_FULL);
+					isci_host_can_dequeue(ihost, 1);
 				}
 			}
 		}
-next_task:
-		task = list_entry(task->list.next, struct sas_task, list);
-	} while (--num > 0);
+	}
 	return 0;
 }
 
diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index b84bedd..11c0b8a 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -293,19 +293,22 @@ static inline void isci_task_all_done(
 */
 static inline enum isci_completion_selection
 isci_task_set_completion_status(
-	struct sas_task *task,
-	enum service_response response,
-	enum exec_status status,
-	enum isci_completion_selection task_notification_selection)
+	struct sas_task                *task,
+	enum service_response          response,
+	enum exec_status               status,
+	enum isci_completion_selection task_notification_selection,
+	enum isci_request_status       request_status)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 
-	/* If a device reset is being indicated, make sure the I/O
-	* is in the error path.
-	*/
-	if (task->task_state_flags & SAS_TASK_NEED_DEV_RESET) {
+	/* Only let an I/O into the error path for reset purposes
+	 * if it's not already being aborted; if "completed", and if a device
+	 * reset is being indicated, make sure the I/O is in the error path.
+	 */
+	if (request_status == completed &&
+	    (task->task_state_flags & SAS_TASK_NEED_DEV_RESET)) {
 
 		/* Fail the I/O to make sure it goes into the error path. */
 		response = SAS_TASK_UNDELIVERED;
@@ -317,28 +320,25 @@ isci_task_set_completion_status(
 	task->task_status.stat = status;
 
 	switch (task_notification_selection) {
-
-		case isci_perform_aborted_io_completion:
-			/* This path can occur with task-managed requests as well as
-			* requests terminated because of LUN or device resets.
-			*/
-			/* Fall through to the normal case... */
-
-		case isci_perform_normal_io_completion:
-			/* Normal notification (task_done) */
-			isci_set_task_doneflags(task);
-			break;
-
-		default:
-			WARN_ON(FALSE);
-			/* Fall through to the error case... */
-
-		case isci_perform_error_io_completion:
-			/* Use sas_task_abort */
-			/* Leave SAS_TASK_STATE_DONE clear
-			*  Leave SAS_TASK_AT_INITIATOR set.
-			*/
-			break;
+	case isci_perform_aborted_io_completion:
+		/* This path can occur with task-managed requests as well as
+		 * requests terminated because of LUN or device resets.
+		 */
+		/* Fall through to the normal case... */
+	case isci_perform_normal_io_completion:
+		/* Normal notification (task_done) */
+		isci_set_task_doneflags(task);
+		break;
+	default:
+		WARN_ONCE(1, "unknown task_notification_selection: %d\n",
+			 task_notification_selection);
+		/* Fall through to the error case... */
+	case isci_perform_error_io_completion:
+		/* Use sas_task_abort */
+		/* Leave SAS_TASK_STATE_DONE clear
+		 * Leave SAS_TASK_AT_INITIATOR set.
+		 */
+		break;
 	}
 
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1787bd2..ce3efff 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -218,6 +218,13 @@ int sas_queuecommand(struct scsi_cmnd *cmd,
 		struct sas_ha_struct *sas_ha = dev->port->ha;
 		struct sas_task *task;
 
+		/* If the device fell off, no sense in issuing commands */
+		if (dev->gone) {
+			cmd->result = DID_BAD_TARGET << 16;
+			scsi_done(cmd);
+			goto out;
+		}
+
 		if (dev_is_sata(dev)) {
 			unsigned long flags;
 
@@ -228,13 +235,6 @@ int sas_queuecommand(struct scsi_cmnd *cmd,
 			goto out;
 		}
 
-		/* If the device fell off, no sense in issuing commands */
-		if (dev->gone) {
-			cmd->result = DID_BAD_TARGET << 16;
-			scsi_done(cmd);
-			goto out;
-		}
-
 		res = -ENOMEM;
 		task = sas_create_task(cmd, dev, GFP_ATOMIC);
 		if (!task)
diff --git a/firmware/isci/isci_firmware.bin.ihex b/firmware/isci/isci_firmware.bin.ihex
index b1bb5cf..4f8767c 100644
--- a/firmware/isci/isci_firmware.bin.ihex
+++ b/firmware/isci/isci_firmware.bin.ihex
@@ -1,16 +1,16 @@
 :10000000495343554F454D42E70017100002000089
-:10001000000000000000000101000000000000FFDF
-:10002000FFCF5F000000F0000000000000000000B3
-:1000300000000000000000FFFFCF5F000000F100A3
-:10004000000000000000000000000000000000FFB1
-:10005000FFCF5F000000F200000000000000000081
-:1000600000000000000000FFFFCF5F000000F30071
-:10007000000000000000000000000000000000017F
-:1000800001000000000000FFFFCF5F000000F4004F
-:10009000000000000000000000000000000000FF61
-:1000A000FFCF5F000000F50000000000000000002E
-:1000B00000000000000000FFFFCF5F000000F6001E
-:1000C000000000000000000000000000000000FF31
-:1000D000FFCF5F000000F7000000000000000000FC
-:0700E0000000000000000019
+:10001000000000000000000001000000000000FFE0
+:10002000FFCF5F01000000037C0E00037C0E000385
+:100030007C0E00037C0E00FFFFCF5F010000000379
+:100040007C0E00037C0E00037C0E00037C0E00FF80
+:10005000FFCF5F01000000037C0E00037C0E000355
+:100060007C0E00037C0E00FFFFCF5F010000000349
+:100070007C0E00037C0E00037C0E00037C0E00004F
+:1000800001000000000000FFFFCF5F02000000033E
+:100090007C0E00037C0E00037C0E00037C0E00FF30
+:1000A000FFCF5F02000000037C0E00037C0E000304
+:1000B0007C0E00037C0E00FFFFCF5F0200000003F8
+:1000C0007C0E00037C0E00037C0E00037C0E00FF00
+:1000D000FFCF5F02000000037C0E00037C0E0003D4
+:0700E0007C0E00037C0E0002
 :00000001FF


