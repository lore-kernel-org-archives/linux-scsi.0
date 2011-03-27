From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT] isci: fixes and cleanups from review
Date: Sat, 26 Mar 2011 19:47:47 -0700
Message-ID: <1301194067.28442.22.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50271 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1C0Clz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Mar 2011 22:41:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: David Milburn <dmilburn@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, hch@infradead.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

isci.git [1]  has been updated with some fixes as well as some upstream
cleanups.  The cleanups are too large to include in their entirety
(~3000 deletions), but the full log (since the last [GIT] isci message)
is below along with the diffs from the smaller patches.

Of course more cleanups are still in progress, this is the set that is
easily verified with a compile check.

--
Dan

[1]: http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/isci.git;a=3Dsumm=
ary

The following changes since commit fa3fa74342e372611ce79636f8fdba69f96c=
84c4:

  Merge branch 'x86-pending' into upstream-pending (2011-03-17 08:59:58=
 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git upstream-=
pending

Dan Williams (11):
      Revert "isci: SATA/STP and SMP tasks are never explicitly put in =
the error path."
      Revert "isci: only call sas_task_abort for tasks with NEED_DEV_RE=
SET"
      isci: reset hardware at init
      isci: fix apc mode definition
      isci: fix a build warning
      Merge branch 'x86-pending' into devel
      isci: reorder init to cleanup unneeded declarations
      isci: kill some long macros
      isci: namespacecheck cleanups
      isci: remove unused "remote_device_started"
      Merge branch 'libsas-pending' into upstream-pending

Dave Jiang (2):
      isci: Remove event_* calls as they are just wrappers
      isci: Remove "screaming" data types

 drivers/scsi/isci/Makefile                         |    2 +-
 drivers/scsi/isci/core/sati_translator_sequence.h  |   16 +-
 drivers/scsi/isci/core/sci_base_port.h             |   56 +-
 drivers/scsi/isci/core/sci_base_request.h          |   10 +-
 drivers/scsi/isci/core/sci_base_state.h            |    8 +-
 drivers/scsi/isci/core/sci_base_state_machine.c    |    4 +-
 drivers/scsi/isci/core/sci_status.h                |    6 +-
 drivers/scsi/isci/core/scic_config_parameters.h    |   13 -
 drivers/scsi/isci/core/scic_controller.h           |  348 ------
 drivers/scsi/isci/core/scic_io_request.h           |    2 +-
 drivers/scsi/isci/core/scic_port.h                 |  100 +--
 drivers/scsi/isci/core/scic_sds_controller.c       | 1274 ++++++++++--=
--------
 drivers/scsi/isci/core/scic_sds_controller.h       |  109 +--
 drivers/scsi/isci/core/scic_sds_phy.c              |  893 +++++-------=
--
 drivers/scsi/isci/core/scic_sds_phy.h              |   91 +--
 drivers/scsi/isci/core/scic_sds_port.c             | 1147 +++++++-----=
------
 drivers/scsi/isci/core/scic_sds_port.h             |  141 +--
 .../isci/core/scic_sds_port_configuration_agent.c  |   99 +-
 .../isci/core/scic_sds_port_configuration_agent.h  |    6 +-
 drivers/scsi/isci/core/scic_sds_remote_device.c    |  679 +++--------
 drivers/scsi/isci/core/scic_sds_remote_device.h    |   21 -
 .../scsi/isci/core/scic_sds_remote_node_context.c  |   46 +-
 .../scsi/isci/core/scic_sds_remote_node_context.h  |   15 +-
 drivers/scsi/isci/core/scic_sds_request.c          |  345 ++----
 drivers/scsi/isci/core/scic_sds_request.h          |   15 +-
 .../scsi/isci/core/scic_sds_smp_remote_device.c    |   44 +-
 drivers/scsi/isci/core/scic_sds_smp_request.c      |  137 ++--
 drivers/scsi/isci/core/scic_sds_ssp_request.c      |    2 +-
 .../scsi/isci/core/scic_sds_stp_packet_request.c   |    4 +-
 .../scsi/isci/core/scic_sds_stp_packet_request.h   |    2 +-
 drivers/scsi/isci/core/scic_sds_stp_pio_request.h  |   13 +-
 .../scsi/isci/core/scic_sds_stp_remote_device.c    |   76 +-
 drivers/scsi/isci/core/scic_sds_stp_request.c      |  251 ++---
 drivers/scsi/isci/core/scic_sds_stp_request.h      |   35 +-
 .../isci/core/scic_sds_unsolicited_frame_control.h |    6 +-
 drivers/scsi/isci/core/scu_registers.h             |   62 +-
 drivers/scsi/isci/core/scu_task_context.h          |   48 +-
 drivers/scsi/isci/events.c                         |  609 ----------
 drivers/scsi/isci/events.h                         |  373 ------
 drivers/scsi/isci/firmware/README                  |    2 +-
 drivers/scsi/isci/host.c                           |   44 +-
 drivers/scsi/isci/init.c                           |   26 +-
 drivers/scsi/isci/isci.h                           |    1 -
 drivers/scsi/isci/port.c                           |   53 +-
 drivers/scsi/isci/port.h                           |   10 +
 drivers/scsi/isci/probe_roms.c                     |    5 +-
 drivers/scsi/isci/probe_roms.h                     |   10 +-
 drivers/scsi/isci/request.c                        |  132 +--
 drivers/scsi/isci/request.h                        |    6 -
 drivers/scsi/isci/task.c                           |   13 +-
 drivers/scsi/isci/task.h                           |   30 +-
 firmware/isci/isci_firmware.bin.ihex               |    4 +-
 52 files changed, 2253 insertions(+), 5191 deletions(-)
 delete mode 100644 drivers/scsi/isci/events.c
 delete mode 100644 drivers/scsi/isci/events.h

commit 2fdebe19b880dbf1e3d5b265da2f2aab887d9522
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Sat Mar 26 17:14:07 2011 -0700

    isci: Remove "screaming" data types
   =20
    Converting the all CAPS data types to lower case.
   =20
    Reported-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 26b604703fb4f8c55a11dcb26d43448b6b3b7a9e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Mar 26 16:56:55 2011 -0700

    isci: remove unused "remote_device_started"
   =20
    These routines are just stubs, re-add them when / if they are neede=
d.  Also
    cleanup remote_device_stopped.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fad023f98205a4852ff12ac3b2f5ba82c528e344
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Mar 26 16:43:01 2011 -0700

    isci: namespacecheck cleanups
   =20
    * mark needlessly global routines static
    * delete unused functions
    * move kernel-doc blocks from header files to source
    * reorder some functions to delete declarations
    * more default handler cleanups phy
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 92314c6110081a0060f913acd26767e9886e009e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Mar 26 16:30:35 2011 -0700

    isci: kill some long macros
   =20
    Delete some macros that are longer to type than the open coded oper=
ation
    that they perform.
   =20
    scic_sds_phy_get_base_state_machine
    scic_sds_phy_get_starting_substate_machine
    scic_sds_port_get_base_state_machine
    scic_sds_port_get_ready_substate_machine
    scic_sds_remote_device_get_base_state_machine
    scic_sds_remote_device_get_ready_substate_machine
    scic_sds_remote_node_context_set_remote_node_index
    scic_sds_controller_get_base_state_machine
   =20
    Also performs some collateral cleanups like killing casts that assu=
me
    structure member ordering, and consolidating a lot of duplicated de=
fault
    handler code (the primary callers of the *_get_base_state_machine m=
acros) via
    a helper.
   =20
    Reported-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0711f8f8ccee3137cd19a327e9232e9777ec5bb2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Mar 26 16:30:06 2011 -0700

    isci: reorder init to cleanup unneeded declarations
   =20
    Just move isci_pci_driver below the function definitions and delete=
 the
    declarations.  A couple other whitespace fixups, and unused symbol
    deletions.
   =20
    Reported-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 7ca2a08..dd96113 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -88,23 +88,8 @@ static DEFINE_PCI_DEVICE_TABLE(isci_id_table) =3D {
 	{}
 };
=20
-struct isci_firmware *isci_firmware;
-
-static int __devinit isci_pci_probe(
-	struct pci_dev *pdev,
-	const struct pci_device_id *device_id_p);
-
-static void __devexit isci_pci_remove(struct pci_dev *pdev);
-
 MODULE_DEVICE_TABLE(pci, isci_id_table);
=20
-static struct pci_driver isci_pci_driver =3D {
-	.name		=3D DRV_NAME,
-	.id_table	=3D isci_id_table,
-	.probe		=3D isci_pci_probe,
-	.remove		=3D __devexit_p(isci_pci_remove),
-};
-
 /* linux isci specific settings */
=20
 #if defined(CONFIG_PBG_HBA_A0)
@@ -343,7 +328,7 @@ static int num_controllers(struct pci_dev *pdev)
 	 */
 	resource_size_t scu_bar_size =3D pci_resource_len(pdev, SCI_SCU_BAR*2=
);
 	resource_size_t smu_bar_size =3D pci_resource_len(pdev, SCI_SMU_BAR*2=
);
-=09
+
 	if (scu_bar_size >=3D SCI_SCU_BAR_SIZE*SCI_MAX_CONTROLLERS &&
 	    smu_bar_size >=3D SCI_SMU_BAR_SIZE*SCI_MAX_CONTROLLERS)
 		return SCI_MAX_CONTROLLERS;
@@ -488,7 +473,7 @@ static void check_si_rev(struct pci_dev *pdev)
 	dev_info(&pdev->dev, "driver configured for %s silicon (rev: %d)\n",
 		 isci_si_rev =3D=3D ISCI_SI_REVA0 ? "A0" :
 		 isci_si_rev =3D=3D ISCI_SI_REVA2 ? "A2" : "B0", pdev->revision);
-	=09
+
 }
=20
 static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct=
 pci_device_id *id)
@@ -577,6 +562,13 @@ static void __devexit isci_pci_remove(struct pci_d=
ev *pdev)
 	}
 }
=20
+static struct pci_driver isci_pci_driver =3D {
+	.name		=3D DRV_NAME,
+	.id_table	=3D isci_id_table,
+	.probe		=3D isci_pci_probe,
+	.remove		=3D __devexit_p(isci_pci_remove),
+};
+
 static __init int isci_init(void)
 {
 	int err;

commit cc41fde7c95fa8672ae32d3f696ba860621ce956
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Sat Mar 26 16:11:51 2011 -0700

    isci: Remove event_* calls as they are just wrappers
   =20
    Removed isci_event_* calls and call those functions directly.
   =20
    Reported-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f498041a46e7f9f2c931d157661914cdfdbd66bd
Merge: b1d1718 4ac5ee3
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Mar 26 16:07:05 2011 -0700

    Merge branch 'x86-pending' into devel
   =20
    pci_map_biosrom() has been accepted into tip.git/x86/platform, so
    unblock the backlog of changes that were pinned behind this patch.
   =20
    * x86-pending:
      isci: fix a build warning
      isci: fix apc mode definition
      isci: exposing user parameters via module params
      isci: fix oem parameter initialization and mode detection
      isci: Fixup for OEM parameter EFI variable retrieval
      isci: fixup with testing from isci OROM in BIOS
      isci: copy the oem parameters instead of assign
      isci: update efi variable name and guid
      isci: add support for 2 more oem parmeters
      isci: Adding EFI variable skeletal support
      isci: Add support for probing OROM for OEM params
      x86: introduce pci_map_biosrom()

commit 4ac5ee33ded761273337fef0e0f32332be57b349
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Mar 25 10:05:58 2011 -0700

    isci: fix a build warning
   =20
    Use min_t to address:
    drivers/scsi/isci/probe_roms.c: In function =E2=80=98isci_get_efi_v=
ar=E2=80=99:
    drivers/scsi/isci/probe_roms.c:241: warning: comparison of distinct=
 pointer types lacks a cast
   =20
    Reported-by: David Milburn <dmilburn@redhat.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/probe_roms.c b/drivers/scsi/isci/probe_r=
oms.c
index a69be59..b53d1c2 100644
--- a/drivers/scsi/isci/probe_roms.c
+++ b/drivers/scsi/isci/probe_roms.c
@@ -238,9 +238,8 @@ struct isci_orom *isci_get_efi_var(struct pci_dev *=
pdev)
 		return NULL;
 	}
=20
-	copy_len =3D min(evar->DataSize,
-		       min(oem_hdr->len - sizeof(*oem_hdr),
-			   sizeof(*rom)));
+	copy_len =3D min_t(u16, evar->DataSize,
+			 min_t(u16, oem_hdr->len - sizeof(*oem_hdr), sizeof(*rom)));
=20
 	memcpy(rom, (char *)evar->Data + sizeof(*oem_hdr), copy_len);
=20

commit d9d38c386335cd1247cf3d5f7ce51bdc24417ca7
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Mar 25 09:58:15 2011 -0700

    isci: fix apc mode definition
   =20
    The original apc mode definition is the correct one, the fix from c=
ommit
    f7ec5db1 "isci: fix oem parameter initialization and mode detection=
" was based
    on a typo from a specification update.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/probe_roms.h b/drivers/scsi/isci/probe_r=
oms.h
index 1b44483..c2162cf 100644
--- a/drivers/scsi/isci/probe_roms.h
+++ b/drivers/scsi/isci/probe_roms.h
@@ -96,10 +96,6 @@ struct isci_oem_hdr {
 #define ISCI_ROM_SIG		"ISCUOEMB"
 #define ISCI_ROM_SIG_SIZE	8
=20
-#define ISCI_PREBOOT_SOURCE_INIT     (0x00)
-#define ISCI_PREBOOT_SOURCE_OROM     (0x80)
-#define ISCI_PREBOOT_SOURCE_EFI      (0x81)
-
 #define ISCI_EFI_VENDOR_GUID	\
 	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, \
 			0x1a, 0x04, 0xc6)
@@ -116,8 +112,8 @@ struct isci_oem_hdr {
  * being assigned is sufficient to declare manual PORT configuration.
  */
 enum SCIC_PORT_CONFIGURATION_MODE {
-	SCIC_PORT_AUTOMATIC_CONFIGURATION_MODE =3D 0,
-	SCIC_PORT_MANUAL_CONFIGURATION_MODE =3D 1
+	SCIC_PORT_MANUAL_CONFIGURATION_MODE =3D 0,
+	SCIC_PORT_AUTOMATIC_CONFIGURATION_MODE =3D 1
 };
=20
 struct sci_bios_oem_param_block_hdr {
diff --git a/firmware/isci/isci_firmware.bin.ihex b/firmware/isci/isci_=
firmware.bin.ihex
index 4f8767c..31b5ecf 100644
--- a/firmware/isci/isci_firmware.bin.ihex
+++ b/firmware/isci/isci_firmware.bin.ihex
@@ -1,11 +1,11 @@
 :10000000495343554F454D42E70017100002000089
-:10001000000000000000000001000000000000FFE0
+:10001000000000000000000101000000000000FFDF
 :10002000FFCF5F01000000037C0E00037C0E000385
 :100030007C0E00037C0E00FFFFCF5F010000000379
 :100040007C0E00037C0E00037C0E00037C0E00FF80
 :10005000FFCF5F01000000037C0E00037C0E000355
 :100060007C0E00037C0E00FFFFCF5F010000000349
-:100070007C0E00037C0E00037C0E00037C0E00004F
+:100070007C0E00037C0E00037C0E00037C0E00014E
 :1000800001000000000000FFFFCF5F02000000033E
 :100090007C0E00037C0E00037C0E00037C0E00FF30
 :1000A000FFCF5F02000000037C0E00037C0E000304

commit b1d171853724d7cd5e151785535aff242ce98860
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 23 17:31:27 2011 -0700

    isci: reset hardware at init
   =20
    Don't assume the hardware is in a known state at init.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/core/scic_sds_controller.c b/drivers/scs=
i/isci/core/scic_sds_controller.c
index 180bb1e..799a04b 100644
--- a/drivers/scsi/isci/core/scic_sds_controller.c
+++ b/drivers/scsi/isci/core/scic_sds_controller.c
@@ -2116,7 +2116,7 @@ enum sci_status scic_controller_construct(struct =
scic_sds_controller *controller
 	/* Initialize the User and OEM parameters to default values. */
 	scic_sds_controller_set_default_config_parameters(controller);
=20
-	return SCI_SUCCESS;
+	return scic_controller_reset(controller);
 }
=20
 /* -------------------------------------------------------------------=
-------- */
@@ -3562,6 +3562,7 @@ const struct scic_sds_controller_state_handler sc=
ic_sds_controller_state_handler
 		.terminate_request =3D scic_sds_controller_default_request_handler,
 	},
 	[SCI_BASE_CONTROLLER_STATE_RESET] =3D {
+		.base.reset        =3D scic_sds_controller_general_reset_handler,
 		.base.initialize   =3D scic_sds_controller_reset_state_initialize_ha=
ndler,
 		.base.start_io     =3D scic_sds_controller_default_start_operation_h=
andler,
 		.base.complete_io  =3D scic_sds_controller_default_request_handler,

commit 7f218d67ce8de2c3390f319137d96cafe946f38b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 22 17:45:11 2011 -0700

    Revert "isci: only call sas_task_abort for tasks with NEED_DEV_RESE=
T"
   =20
    This reverts commit 8dc962d12c66ebacf1ce60f510b3a41d6aa5ffe1.
   =20
    Gating which tasks are eligible for sas_task_abort is already handl=
ed by
    libsas no need to add explicit handling.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 1d2e417..eba8e0b 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -798,8 +798,7 @@ static void isci_task_save_for_upper_layer_completi=
on(
=20
 	task_notification_selection
 		=3D isci_task_set_completion_status(task, response, status,
-						  task_notification_selection,
-						  request->status);
+						  task_notification_selection);
=20
 	/* Tasks aborted specifically by a call to the lldd_abort_task
 	 * function should not be completed to the host in the regular path.
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index a80685f..d483680 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -84,7 +84,7 @@ static void isci_task_refuse(struct isci_host *ihost,=
 struct sas_task *task,
=20
 	disposition =3D isci_perform_normal_io_completion;
 	disposition =3D isci_task_set_completion_status(task, response, statu=
s,
-						      disposition, completed);
+						      disposition);
=20
 	/* Tasks aborted specifically by a call to the lldd_abort_task
 	 * function should not be completed to the host in the regular path.
diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index 11c0b8a..9754b43 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -293,23 +293,19 @@ static inline void isci_task_all_done(
 */
 static inline enum isci_completion_selection
 isci_task_set_completion_status(
-	struct sas_task                *task,
-	enum service_response          response,
-	enum exec_status               status,
-	enum isci_completion_selection task_notification_selection,
-	enum isci_request_status       request_status)
+	struct sas_task *task,
+	enum service_response response,
+	enum exec_status status,
+	enum isci_completion_selection task_notification_selection)
 {
 	unsigned long flags;
=20
 	spin_lock_irqsave(&task->task_state_lock, flags);
=20
-	/* Only let an I/O into the error path for reset purposes
-	 * if it's not already being aborted; if "completed", and if a device
-	 * reset is being indicated, make sure the I/O is in the error path.
-	 */
-	if (request_status =3D=3D completed &&
-	    (task->task_state_flags & SAS_TASK_NEED_DEV_RESET)) {
-
+	/* If a device reset is being indicated, make sure the I/O
+	* is in the error path.
+	*/
+	if (task->task_state_flags & SAS_TASK_NEED_DEV_RESET) {
 		/* Fail the I/O to make sure it goes into the error path. */
 		response =3D SAS_TASK_UNDELIVERED;
 		status =3D SAM_STAT_TASK_ABORTED;

commit bcc5d45c87ee5a0adee4558f10b578b2cf3106e9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 22 17:41:00 2011 -0700

    Revert "isci: SATA/STP and SMP tasks are never explicitly put in th=
e error path."
   =20
    This reverts commit 7a18a48e0f70b8d17064523d8473d48a87d0400a.
   =20
    sas_task_abort already handles internal commands so this determinat=
ion
    is not needed in lldd's.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 15b9509..dc231c2 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -331,39 +331,21 @@ static void isci_host_completion_routine(unsigned=
 long data)
=20
 		task =3D isci_request_access_task(request);
=20
+		/* Use sas_task_abort */
+		dev_warn(&isci_host->pdev->dev,
+			 "%s: Error - request/task =3D %p/%p\n",
+			 __func__,
+			 request,
+			 task);
+
 		if (task !=3D NULL) {
=20
-			if (task->task_proto & (SAS_PROTOCOL_SATA
-					      | SAS_PROTOCOL_SMP
-					      | SAS_PROTOCOL_STP)) {
-				/* SATA/STP and SMP tasks are not put into the
-				 * error path because of those protocols'
-				 * discovery implementation in libsas.
-				 *
-				 * The only thing that can be done now is to
-				 * let the I/O timeout so that the abort
-				 * task interface will be called.
-				 */
-				dev_warn(&isci_host->pdev->dev,
-					 "%s: Error - SMP/SATA/STP (%x) "
-					 "request/task =3D %p/%p is being left"
-					 "to time out!\n",
-					 __func__, task->task_proto, request,
-					 task);
-
-			} else {
-				/* Use sas_task_abort */
-				dev_warn(&isci_host->pdev->dev,
-					 "%s: Error - request/task =3D %p/%p\n",
-					 __func__, request, task);
-
-				/* Put the task into the abort path if it's
-				 * not there already.
-				*/
-				if (!(task->task_state_flags
-				     & SAS_TASK_STATE_ABORTED))
-					sas_task_abort(task);
-			}
+			/* Put the task into the abort path if it's not there
+			 * already.
+			 */
+			if (!(task->task_state_flags & SAS_TASK_STATE_ABORTED))
+				sas_task_abort(task);
+
 		} else {
 			/* This is a case where the request has completed with a
 			 * status such that it needed further target servicing,
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 6d81c41..1d2e417 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -356,6 +356,33 @@ int isci_request_alloc_tmf(
 }
=20
 /**
+ * isci_request_signal_device_reset() - This function will set the "de=
vice
+ *    needs target reset" flag in the given sas_tasks' task_state_flag=
s, and
+ *    then cause the task to be added into the SCSI error handler queu=
e which
+ *    will eventually be escalated to a target reset.
+ *
+ *
+ */
+static void isci_request_signal_device_reset(
+	struct isci_request *isci_request)
+{
+	unsigned long flags;
+	struct sas_task *task =3D isci_request_access_task(isci_request);
+
+	dev_dbg(&isci_request->isci_host->pdev->dev,
+		"%s: request=3D%p, task=3D%p\n", __func__, isci_request, task);
+
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	task->task_state_flags |=3D SAS_TASK_NEED_DEV_RESET;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+	/* Cause this task to be scheduled in the SCSI error handler
+	 * thread.
+	 */
+	sas_task_abort(task);
+}
+
+/**
  * isci_request_execute() - This function allocates the isci_request o=
bject,
  *    all fills in some common fields.
  * @isci_host: This parameter specifies the ISCI host object
@@ -408,8 +435,7 @@ int isci_request_execute(
 			);
=20
 		if (status =3D=3D SCI_SUCCESS ||
-		    (status =3D=3D SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED &&
-		     task->task_proto !=3D SAS_PROTOCOL_SMP)) {
+		    status =3D=3D SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED) {
=20
 			/* Either I/O started OK, or the core has signaled that
 			 * the device needs a target reset.
@@ -427,12 +453,6 @@ int isci_request_execute(
 				/* Save the tag for possible task mgmt later. */
 				request->io_tag =3D scic_io_request_get_io_tag(
 						     request->sci_request_handle);
-			} else {
-				/* The request did not really start in the
-				 * hardware, so clear the request handle
-				 * here so no terminations will be done.
-				*/
-				request->sci_request_handle =3D NULL;
 			}
 		} else
 			dev_warn(&isci_host->pdev->dev,
@@ -441,28 +461,14 @@ int isci_request_execute(
=20
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
=20
-		if (status =3D=3D SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED &&
-		    task->task_proto !=3D SAS_PROTOCOL_SMP) {
-
-			dev_dbg(&request->isci_host->pdev->dev,
-				"%s: request=3D%p, task=3D%p\n",
-				__func__, request, task);
-
+		if (status =3D=3D
+		    SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED) {
 			/* Signal libsas that we need the SCSI error
 			* handler thread to work on this I/O and that
 			* we want a device reset.
 			*/
-			spin_lock_irqsave(&task->task_state_lock, flags);
-			task->task_state_flags |=3D SAS_TASK_NEED_DEV_RESET;
-			spin_unlock_irqrestore(&task->task_state_lock, flags);
-
-			if (task->task_proto & SAS_PROTOCOL_SSP) {
+			isci_request_signal_device_reset(request);
=20
-				/* Cause this task to be scheduled in the SCSI
-				 * error handler thread.
-				 */
-				sas_task_abort(task);
-			}
 			/* Change the status, since we are holding
 			* the I/O until it is managed by the SCSI
 			* error handler.


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
