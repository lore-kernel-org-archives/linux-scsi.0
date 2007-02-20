From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] fusion kernel-doc warning fixes
Date: Tue, 20 Feb 2007 11:17:03 -0800
Message-ID: <20070220111703.c7f38683.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:42458 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbXBTTUn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Feb 2007 14:20:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@linux-foundation.org>, mpt_linux_developer@lsi.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in fusion driver code.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/message/fusion/mptbase.c  |   22 +++++++---------------
 drivers/message/fusion/mptscsih.c |   15 ++++++++++-----
 drivers/message/fusion/mptspi.c   |   11 +++++------
 3 files changed, 22 insertions(+), 26 deletions(-)

--- linux-2.6.20-git15.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6.20-git15/drivers/message/fusion/mptbase.c
@@ -4739,12 +4739,8 @@ mpt_readScsiDevicePageHeaders(MPT_ADAPTE
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
@@ -4764,15 +4760,11 @@ mpt_inactive_raid_list_free(MPT_ADAPTER 
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
@@ -6663,7 +6655,7 @@ union loginfo_type {
 /**
  *	mpt_iocstatus_info_config - IOCSTATUS information for config pages
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	ioc_status: U32 IOCStatus word from IOC
+ *	@ioc_status: U32 IOCStatus word from IOC
  *	@mf: Pointer to MPT request frame
  *
  *	Refer to lsi/mpi.h.
--- linux-2.6.20-git15.orig/drivers/message/fusion/mptscsih.c
+++ linux-2.6.20-git15/drivers/message/fusion/mptscsih.c
@@ -1537,21 +1537,23 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
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
@@ -1650,9 +1652,11 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
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
@@ -2022,6 +2026,7 @@ mptscsih_tm_pending_wait(MPT_SCSI_HOST *
 /**
  *	mptscsih_tm_wait_for_completion - wait for completion of TM task
  *	@hd: Pointer to MPT host structure.
+ *	@timeout: timeout value
  *
  *	Returns {SUCCESS,FAILED}.
  */
--- linux-2.6.20-git15.orig/drivers/message/fusion/mptspi.c
+++ linux-2.6.20-git15/drivers/message/fusion/mptspi.c
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
