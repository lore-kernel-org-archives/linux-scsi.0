From: akpm@linux-foundation.org
Subject: [patch 28/29] fusion kernel-doc warning fixes
Date: Tue, 06 Mar 2007 02:46:53 -0800
Message-ID: <200703061046.l26AkrFp020086@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35016 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964821AbXCFKr2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2007 05:47:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com, Eric.Moore@lsil.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in fusion driver code.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c  |   22 +++++++---------------
 drivers/message/fusion/mptscsih.c |   15 ++++++++++-----
 drivers/message/fusion/mptspi.c   |   11 +++++------
 3 files changed, 22 insertions(+), 26 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~fusion-kernel-doc-warning-fixes drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~fusion-kernel-doc-warning-fixes
+++ a/drivers/message/fusion/mptbase.c
@@ -4745,12 +4745,8 @@ mpt_readScsiDevicePageHeaders(MPT_ADAPTE
 }
 
 /**
- * mpt_inactive_raid_list_free
- *
- * This clears this link list.
- *
- * @ioc - pointer to per adapter structure
- *
+ * mpt_inactive_raid_list_free - This clears this link list.
+ * @ioc : pointer to per adapter structure
  **/
 static void
 mpt_inactive_raid_list_free(MPT_ADAPTER *ioc)
@@ -4770,15 +4766,11 @@ mpt_inactive_raid_list_free(MPT_ADAPTER 
 }
 
 /**
- * mpt_inactive_raid_volumes
- *
- * This sets up link list of phy_disk_nums for devices belonging in an inactive volume
- *
- * @ioc - pointer to per adapter structure
- * @channel - volume channel
- * @id - volume target id
- *
+ * mpt_inactive_raid_volumes - sets up link list of phy_disk_nums for devices belonging in an inactive volume
  *
+ * @ioc : pointer to per adapter structure
+ * @channel : volume channel
+ * @id : volume target id
  **/
 static void
 mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
@@ -6669,7 +6661,7 @@ union loginfo_type {
 /**
  *	mpt_iocstatus_info_config - IOCSTATUS information for config pages
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	ioc_status: U32 IOCStatus word from IOC
+ *	@ioc_status: U32 IOCStatus word from IOC
  *	@mf: Pointer to MPT request frame
  *
  *	Refer to lsi/mpi.h.
diff -puN drivers/message/fusion/mptscsih.c~fusion-kernel-doc-warning-fixes drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~fusion-kernel-doc-warning-fixes
+++ a/drivers/message/fusion/mptscsih.c
@@ -1540,21 +1540,23 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_TMHandler - Generic handler for SCSI Task Management.
- *	Fall through to mpt_HardResetHandler if: not operational, too many
- *	failed TM requests or handshake failure.
- *
- *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@hd: Pointer to MPT SCSI HOST structure
  *	@type: Task Management type
+ *	@channel: channel number for task management
  *	@id: Logical Target ID for reset (if appropriate)
  *	@lun: Logical Unit for reset (if appropriate)
  *	@ctx2abort: Context for the task to be aborted (if appropriate)
+ *	@timeout: timeout for task management control
+ *
+ *	Fall through to mpt_HardResetHandler if: not operational, too many
+ *	failed TM requests or handshake failure.
  *
  *	Remark: Currently invoked from a non-interrupt thread (_bh).
  *
  *	Remark: With old EH code, at most 1 SCSI TaskMgmt function per IOC
  *	will be active.
  *
- *	Returns 0 for SUCCESS, or FAILED.
+ *	Returns 0 for SUCCESS, or %FAILED.
  **/
 int
 mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
@@ -1653,9 +1655,11 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
  *	mptscsih_IssueTaskMgmt - Generic send Task Management function.
  *	@hd: Pointer to MPT_SCSI_HOST structure
  *	@type: Task Management type
+ *	@channel: channel number for task management
  *	@id: Logical Target ID for reset (if appropriate)
  *	@lun: Logical Unit for reset (if appropriate)
  *	@ctx2abort: Context for the task to be aborted (if appropriate)
+ *	@timeout: timeout for task management control
  *
  *	Remark: _HardResetHandler can be invoked from an interrupt thread (timer)
  *	or a non-interrupt thread.  In the former, must not call schedule().
@@ -2025,6 +2029,7 @@ mptscsih_tm_pending_wait(MPT_SCSI_HOST *
 /**
  *	mptscsih_tm_wait_for_completion - wait for completion of TM task
  *	@hd: Pointer to MPT host structure.
+ *	@timeout: timeout value
  *
  *	Returns {SUCCESS,FAILED}.
  */
diff -puN drivers/message/fusion/mptspi.c~fusion-kernel-doc-warning-fixes drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c~fusion-kernel-doc-warning-fixes
+++ a/drivers/message/fusion/mptspi.c
@@ -96,14 +96,13 @@ static int	mptspiTaskCtx = -1;
 static int	mptspiInternalCtx = -1; /* Used only for internal commands */
 
 /**
- * 	mptspi_setTargetNegoParms  - Update the target negotiation
- *	parameters based on the the Inquiry data, adapter capabilities,
- *	and NVRAM settings
- *
+ * 	mptspi_setTargetNegoParms  - Update the target negotiation parameters
  *	@hd: Pointer to a SCSI Host Structure
- *	@vtarget: per target private data
+ *	@target: per target private data
  *	@sdev: SCSI device
  *
+ * 	Update the target negotiation parameters based on the the Inquiry
+ *	data, adapter capabilities, and NVRAM settings.
  **/
 static void
 mptspi_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target,
@@ -234,7 +233,7 @@ mptspi_setTargetNegoParms(MPT_SCSI_HOST 
 /**
  * 	mptspi_writeIOCPage4  - write IOC Page 4
  *	@hd: Pointer to a SCSI Host Structure
- *	@channel:
+ *	@channel: channel number
  *	@id: write IOC Page4 for this ID & Bus
  *
  *	Return: -EAGAIN if unable to obtain a Message Frame
_
