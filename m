From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] SCSI: Add TASK_ABORTED to status_byte macro
Date: Wed, 9 Mar 2005 09:26:34 -0800
Message-ID: <20050309172633.GA7151@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43993 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262097AbVCIR06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 12:26:58 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j29HQwo3018257
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 12:26:58 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j29HQw15242602
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 12:26:58 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j29HQvTY014690
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 12:26:57 -0500
Received: from hmsbounty.us.ibm.com (sig-9-49-139-213.mts.ibm.com [9.49.139.213])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j29HQuUd014209
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 12:26:56 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here is a refresh of an update to the status_byte macro.

Previous mail
http://marc.theaimsgroup.com/?l=linux-scsi&m=110322214824566&w=2

-andmike
--
Michael Anderson
andmike@us.ibm.com

Add TASK_ABORTED and ACA_ACTIVE to status_byte macro.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 linux-2.6.11-andmike/drivers/scsi/scsi_error.c |    2 ++
 linux-2.6.11-andmike/include/scsi/scsi.h       |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_error.c~tsk_abrt drivers/scsi/scsi_error.c
--- linux-2.6.11/drivers/scsi/scsi_error.c~tsk_abrt	2005-03-07 15:29:09.000000000 -0800
+++ linux-2.6.11-andmike/drivers/scsi/scsi_error.c	2005-03-07 15:29:09.000000000 -0800
@@ -1373,6 +1373,7 @@ int scsi_decide_disposition(struct scsi_
 		return ADD_TO_MLQUEUE;
 	case GOOD:
 	case COMMAND_TERMINATED:
+	case TASK_ABORTED:
 		return SUCCESS;
 	case CHECK_CONDITION:
 		rtn = scsi_check_sense(scmd);
@@ -1386,6 +1387,7 @@ int scsi_decide_disposition(struct scsi_
 	case CONDITION_GOOD:
 	case INTERMEDIATE_GOOD:
 	case INTERMEDIATE_C_GOOD:
+	case ACA_ACTIVE:
 		/*
 		 * who knows?  FIXME(eric)
 		 */
diff -puN include/scsi/scsi.h~tsk_abrt include/scsi/scsi.h
--- linux-2.6.11/include/scsi/scsi.h~tsk_abrt	2005-03-07 15:29:09.000000000 -0800
+++ linux-2.6.11-andmike/include/scsi/scsi.h	2005-03-07 15:29:09.000000000 -0800
@@ -169,8 +169,10 @@ static inline int scsi_status_is_good(in
 #define RESERVATION_CONFLICT 0x0c
 #define COMMAND_TERMINATED   0x11
 #define QUEUE_FULL           0x14
+#define ACA_ACTIVE           0x18
+#define TASK_ABORTED         0x20
 
-#define STATUS_MASK          0x3e
+#define STATUS_MASK          0xfe
 
 /*
  *  SENSE KEYS
@@ -348,7 +350,7 @@ struct scsi_lun {
  *      host_byte   = set by low-level driver to indicate status.
  *      driver_byte = set by mid-level.
  */
-#define status_byte(result) (((result) >> 1) & 0x1f)
+#define status_byte(result) (((result) >> 1) & 0x7f)
 #define msg_byte(result)    (((result) >> 8) & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 #define driver_byte(result) (((result) >> 24) & 0xff)
_

