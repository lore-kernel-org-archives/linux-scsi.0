From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Sun, 14 Mar 2004 00:24:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082444.GA3416@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:22682 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263317AbUCNIWP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:22:15 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1661 04/02/28 22:35:59 andrew.vasquez@qlogic.com +3 -0
  Limit SG entry size to make more efficient use of the
  size contraints of the request-queue.
  
  This SG entry size is inline with the size specified in the 6.x
  and 7.x series drivers.

  drivers/scsi/qla2xxx/qla_os.c
    1.9 04/02/28 22:35:52 andrew.vasquez@qlogic.com +1 -1
    Limit SG entry size to make more efficient use of the
    size contraints of the request-queue.

  drivers/scsi/qla2xxx/qla_init.c
    1.8 04/02/28 22:35:52 andrew.vasquez@qlogic.com +4 -1
    Limit the size of the buffer used to load firmware. 

  drivers/scsi/qla2xxx/qla_def.h
    1.8 04/02/28 22:35:52 andrew.vasquez@qlogic.com +1 -1
    Increase an ISP's request queue size.

 drivers/scsi/qla2xxx/qla_def.h  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |    5 ++++-
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/14_sg_resize.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:07:22 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:07:22 2004
@@ -209,7 +209,7 @@
 #define MAX_OUTSTANDING_COMMANDS	1024
 
 /* ISP request and response entry counts (37-65535) */
-#define REQUEST_ENTRY_CNT		1024	/* Number of request entries. */
+#define REQUEST_ENTRY_CNT		2048	/* Number of request entries. */
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:07:22 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:07:22 2004
@@ -603,7 +603,10 @@
 	ha->product_id[3] = mb[4];
 
 	/* Adjust fw RISC transfer size */
-	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * REQUEST_ENTRY_CNT;
+	if (REQUEST_ENTRY_CNT > 1024)
+		ha->fw_transfer_size = REQUEST_ENTRY_SIZE * 1024;
+	else
+		ha->fw_transfer_size = REQUEST_ENTRY_SIZE * REQUEST_ENTRY_CNT;
 
 	if (IS_QLA2200(ha) &&
 	    RD_MAILBOX_REG(ha, reg, 7) == QLA2200A_RISC_ROM_VER) {
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:07:22 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:07:22 2004
@@ -166,7 +166,7 @@
 	.can_queue		= REQUEST_ENTRY_CNT+128,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= 32,
 
 	/*
 	 * The RISC allows for each command to transfer (2^32-1) bytes of data,
