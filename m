From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2] sg: relax 16 byte cdb restriction
Date: Wed, 30 Oct 2013 18:25:39 -0400
Message-ID: <52718763.9030308@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010207000702050903030102"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38464 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3J3W0D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 18:26:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>

This is a multi-part message in MIME format.
--------------010207000702050903030102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is essentially the same patch sent 6 weeks ago:
   http://marc.info/?l=linux-scsi&m=137943733409512&w=2
re-based on '[PATCH v2] sg: O_EXCL and other lock handling'.

ChangeLog:
     - remove the 16 byte CDB (SCSI command) length limit
       from the sg driver by handling longer CDBs the same
       way as the bsg driver. Remove comment from sg.h
       public interface about the cmd_len field being
       limited to 16 bytes.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------010207000702050903030102
Content-Type: text/x-patch;
 name="sg.c_cdb_dg1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg.c_cdb_dg1.patch"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 99c643f..4d434b9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -62,7 +62,7 @@ static int sg_version_num = 30535;	/* 2 digits for each component */
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20131029";
+static char *sg_version_date = "20131030";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -72,6 +72,9 @@ static void sg_proc_cleanup(void);
 
 #define SG_MAX_DEVS 32768
 
+#define SG_MAX_CDB_SIZE 255	/* should be 260: spc4r36i 3.1.30 */
+
+
 /*
  * Suppose you want to calculate the formula muldiv(x,m,d)=int(x * m / d)
  * Then when using 32 bit integers x * m may overflow during the calculation.
@@ -574,7 +577,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	Sg_request *srp;
 	struct sg_header old_hdr;
 	sg_io_hdr_t *hp;
-	unsigned char cmnd[MAX_COMMAND_SIZE];
+	unsigned char cmnd[SG_MAX_CDB_SIZE];
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
@@ -606,7 +609,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	buf += SZ_SG_HEADER;
 	__get_user(opcode, buf);
 	if (sfp->next_cmd_len > 0) {
-		if (sfp->next_cmd_len > MAX_COMMAND_SIZE) {
+		if (sfp->next_cmd_len > SG_MAX_CDB_SIZE) {
 			SCSI_LOG_TIMEOUT(1, printk("sg_write: command length too long\n"));
 			sfp->next_cmd_len = 0;
 			sg_remove_request(sfp, srp);
@@ -683,7 +686,7 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 	int k;
 	Sg_request *srp;
 	sg_io_hdr_t *hp;
-	unsigned char cmnd[MAX_COMMAND_SIZE];
+	unsigned char cmnd[SG_MAX_CDB_SIZE];
 	int timeout;
 	unsigned long ul_timeout;
 
@@ -1659,14 +1662,25 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 	struct rq_map_data *md, map_data;
 	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
+	unsigned char * long_cmdp = NULL;
 
 	SCSI_LOG_TIMEOUT(4, printk(KERN_INFO "sg_start_req: dxfer_len=%d\n",
 				   dxfer_len));
+	if (hp->cmd_len > BLK_MAX_CDB) {
+		long_cmdp = kzalloc(hp->cmd_len, GFP_KERNEL);
+		if (!long_cmdp)
+			return -ENOMEM;
+	}
 
 	rq = blk_get_request(q, rw, GFP_ATOMIC);
-	if (!rq)
+	if (!rq) {
+		if (long_cmdp)
+			kfree(long_cmdp);
 		return -ENOMEM;
+	}
 
+	if (hp->cmd_len > BLK_MAX_CDB)
+		rq->cmd = long_cmdp;
 	memcpy(rq->cmd, cmd, hp->cmd_len);
 
 	rq->cmd_len = hp->cmd_len;
@@ -1753,6 +1767,8 @@ static int sg_finish_rem_req(Sg_request * srp)
 		if (srp->bio)
 			ret = blk_rq_unmap_user(srp->bio);
 
+		if (srp->rq->cmd != srp->rq->__cmd)
+			kfree(srp->rq->cmd);
 		blk_put_request(srp->rq);
 	}
 
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index a9f3c6f..18d4aaa 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -11,9 +11,9 @@
 Original driver (sg.h):
 *       Copyright (C) 1992 Lawrence Foard
 Version 2 and 3 extensions to driver:
-*       Copyright (C) 1998 - 2006 Douglas Gilbert
+*       Copyright (C) 1998 - 2013 Douglas Gilbert
 
-    Version: 3.5.34 (20060920)
+    Version: 3.5.35 (20130930)
     This version is for 2.6 series kernels.
 
     For a full changelog see http://www.torque.net/sg
@@ -87,7 +87,7 @@ typedef struct sg_io_hdr
 {
     int interface_id;           /* [i] 'S' for SCSI generic (required) */
     int dxfer_direction;        /* [i] data transfer direction  */
-    unsigned char cmd_len;      /* [i] SCSI command length ( <= 16 bytes) */
+    unsigned char cmd_len;      /* [i] SCSI command length */
     unsigned char mx_sb_len;    /* [i] max length to write to sbp */
     unsigned short iovec_count; /* [i] 0 implies no scatter gather */
     unsigned int dxfer_len;     /* [i] byte count of data transfer */

--------------010207000702050903030102--
