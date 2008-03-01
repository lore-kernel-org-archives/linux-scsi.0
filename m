From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 6/6] docbook: fix fusion source files
Date: Fri, 29 Feb 2008 22:03:27 -0800
Message-ID: <20080229220327.f2908b41.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:32121 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbYCAGEj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Mar 2008 01:04:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
Cc: Eric.Moore@lsi.com, support@lsi.com, jejb <James.Bottomley@HansenPartnership.com>, akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problems in fusion source files.
These cause the generated docbook to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/message/fusion/mptbase.c  |   25 +++++++++++++------------
 drivers/message/fusion/mptscsih.c |   14 +++++---------
 2 files changed, 18 insertions(+), 21 deletions(-)

--- lin2625-rc3g2-kdoc.orig/drivers/message/fusion/mptbase.c
+++ lin2625-rc3g2-kdoc/drivers/message/fusion/mptbase.c
@@ -632,8 +632,7 @@ mpt_deregister(u8 cb_idx)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_event_register - Register protocol-specific event callback
- *	handler.
+ *	mpt_event_register - Register protocol-specific event callback handler.
  *	@cb_idx: previously registered (via mpt_register) callback handle
  *	@ev_cbfunc: callback function
  *
@@ -654,8 +653,7 @@ mpt_event_register(u8 cb_idx, MPT_EVHAND
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_event_deregister - Deregister protocol-specific event callback
- *	handler.
+ *	mpt_event_deregister - Deregister protocol-specific event callback handler
  *	@cb_idx: previously registered callback handle
  *
  *	Each protocol-specific driver should call this routine
@@ -765,11 +763,13 @@ mpt_device_driver_deregister(u8 cb_idx)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_get_msg_frame - Obtain a MPT request frame from the pool (of 1024)
- *	allocated per MPT adapter.
+ *	mpt_get_msg_frame - Obtain an MPT request frame from the pool
  *	@cb_idx: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *
+ *	Obtain an MPT request frame from the pool (of 1024) that are
+ *	allocated per MPT adapter.
+ *
  *	Returns pointer to a MPT request frame or %NULL if none are available
  *	or IOC is not active.
  */
@@ -834,13 +834,12 @@ mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_put_msg_frame - Send a protocol specific MPT request frame
- *	to a IOC.
+ *	mpt_put_msg_frame - Send a protocol-specific MPT request frame to an IOC
  *	@cb_idx: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *	@mf: Pointer to MPT request frame
  *
- *	This routine posts a MPT request frame to the request post FIFO of a
+ *	This routine posts an MPT request frame to the request post FIFO of a
  *	specific MPT adapter.
  */
 void
@@ -868,13 +867,15 @@ mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER
 }
 
 /**
- *	mpt_put_msg_frame_hi_pri - Send a protocol specific MPT request frame
- *	to a IOC using hi priority request queue.
+ *	mpt_put_msg_frame_hi_pri - Send a hi-pri protocol-specific MPT request frame
  *	@cb_idx: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *	@mf: Pointer to MPT request frame
  *
- *	This routine posts a MPT request frame to the request post FIFO of a
+ *	Send a protocol-specific MPT request frame to an IOC using
+ *	hi-priority request queue.
+ *
+ *	This routine posts an MPT request frame to the request post FIFO of a
  *	specific MPT adapter.
  **/
 void
--- lin2625-rc3g2-kdoc.orig/drivers/message/fusion/mptscsih.c
+++ lin2625-rc3g2-kdoc/drivers/message/fusion/mptscsih.c
@@ -1533,7 +1533,7 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
  *
  *	Remark: Currently invoked from a non-interrupt thread (_bh).
  *
- *	Remark: With old EH code, at most 1 SCSI TaskMgmt function per IOC
+ *	Note: With old EH code, at most 1 SCSI TaskMgmt function per IOC
  *	will be active.
  *
  *	Returns 0 for SUCCESS, or %FAILED.
@@ -2537,14 +2537,12 @@ mptscsih_copy_sense_data(struct scsi_cmn
 
 /**
  * mptscsih_get_scsi_lookup
- *
- * retrieves scmd entry from ScsiLookup[] array list
- *
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
  *
- * Returns the scsi_cmd pointer
+ * retrieves scmd entry from ScsiLookup[] array list
  *
+ * Returns the scsi_cmd pointer
  **/
 static struct scsi_cmnd *
 mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i)
@@ -2561,14 +2559,12 @@ mptscsih_get_scsi_lookup(MPT_ADAPTER *io
 
 /**
  * mptscsih_getclear_scsi_lookup
- *
- * retrieves and clears scmd entry from ScsiLookup[] array list
- *
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
  *
- * Returns the scsi_cmd pointer
+ * retrieves and clears scmd entry from ScsiLookup[] array list
  *
+ * Returns the scsi_cmd pointer
  **/
 static struct scsi_cmnd *
 mptscsih_getclear_scsi_lookup(MPT_ADAPTER *ioc, int i)
