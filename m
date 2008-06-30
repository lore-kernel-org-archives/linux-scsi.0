From: christof.schmitt@de.ibm.com
Subject: [patch 04/11] zfcp: Small QDIO cleanups
Date: Mon, 30 Jun 2008 12:52:40 +0200
Message-ID: <20080630110057.038561000@de.ibm.com>
References: <20080630105236.960064000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56664 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbYF3LBs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 07:01:48 -0400
Content-Disposition: inline; filename=qdio-small-cleanup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

QBUFF_PER_PAGE is only used inside the qdio module, so move it to
zfcp_qdio.c

zfcp_qdio_zero_sbals is now only used in the qdio module, so make it
static.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h  |    2 --
 drivers/s390/scsi/zfcp_ext.h  |    1 -
 drivers/s390/scsi/zfcp_qdio.c |   31 +++++++++++++------------------
 3 files changed, 13 insertions(+), 21 deletions(-)

--- a/drivers/s390/scsi/zfcp_ext.h	2008-06-27 18:06:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-06-27 18:08:22.000000000 +0200
@@ -43,7 +43,6 @@ extern void _zfcp_scan_ports_later(struc
 /******************************* S/390 IO ************************************/
 extern int  zfcp_ccw_register(void);
 
-extern void zfcp_qdio_zero_sbals(struct qdio_buffer **, int, int);
 extern int  zfcp_qdio_allocate(struct zfcp_adapter *);
 extern void zfcp_qdio_free(struct zfcp_adapter *);
 extern int  zfcp_qdio_send(struct zfcp_fsf_req *fsf_req);
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-06-27 18:06:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-06-27 18:08:22.000000000 +0200
@@ -11,6 +11,7 @@
 /* FIXME(tune): free space should be one max. SBAL chain plus what? */
 #define ZFCP_QDIO_PCI_INTERVAL	(QDIO_MAX_BUFFERS_PER_Q \
 				- (ZFCP_MAX_SBALS_PER_REQ + 4))
+#define QBUFF_PER_PAGE		(PAGE_SIZE / sizeof(struct qdio_buffer))
 
 static int zfcp_qdio_buffers_enqueue(struct qdio_buffer **sbal)
 {
@@ -63,6 +64,16 @@ static void zfcp_qdio_handler_error(stru
 				ZFCP_STATUS_COMMON_ERP_FAILED, id, NULL);
 }
 
+static void zfcp_qdio_zero_sbals(struct qdio_buffer *sbal[], int first, int cnt)
+{
+	int i, sbal_idx;
+
+	for (i = first; i < first + cnt; i++) {
+		sbal_idx = i % QDIO_MAX_BUFFERS_PER_Q;
+		memset(sbal[sbal_idx], 0, sizeof(struct qdio_buffer));
+	}
+}
+
 static void zfcp_qdio_int_req(struct ccw_device *cdev, unsigned int status,
 			      unsigned int qdio_err, unsigned int siga_err,
 			      unsigned int queue_no, int first, int count,
@@ -366,22 +377,6 @@ int zfcp_qdio_send(struct zfcp_fsf_req *
 }
 
 /**
- * zfcp_qdio_zero_sbals - zero all sbals of the specified area and queue
- * @buf: pointer to array of SBALS
- * @first: integer specifying the SBAL number to start
- * @count: integer specifying the number of SBALS to process
- */
-void zfcp_qdio_zero_sbals(struct qdio_buffer *sbal[], int first, int count)
-{
-	int i, sbal_idx;
-
-	for (i = first; i < first + count; i++) {
-		sbal_idx = i % QDIO_MAX_BUFFERS_PER_Q;
-		memset(sbal[sbal_idx], 0, sizeof(struct qdio_buffer));
-	}
-}
-
-/**
  * zfcp_qdio_allocate - allocate queue memory and initialize QDIO data
  * @adapter: pointer to struct zfcp_adapter
  * Returns: -ENOMEM on memory allocation error or return value from
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-27 18:07:57.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-27 18:08:22.000000000 +0200
@@ -100,8 +100,6 @@ zfcp_address_to_sg(void *address, struct
 
 #define ZFCP_TYPE2_RECOVERY_TIME        8	/* seconds */
 
-#define QBUFF_PER_PAGE			(PAGE_SIZE / sizeof(struct qdio_buffer))
-
 /********************* FSF SPECIFIC DEFINES *********************************/
 
 #define ZFCP_ULP_INFO_VERSION                   26

-- 
