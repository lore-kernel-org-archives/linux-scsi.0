From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] sg: relax 16 byte cdb restriction
Date: Tue, 17 Sep 2013 13:01:54 -0400
Message-ID: <52388B02.4050006@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070608000409030603010406"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50408 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab3IQRCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 13:02:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>

This is a multi-part message in MIME format.
--------------070608000409030603010406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From time to time I am asked how to pass a 32 byte SCSI
command (cdb) through the sg driver. My stock answer is
to refer people to the bsg driver for that purpose.
Since the bsg driver and the sg driver now make essentially
the same calls to the underlying block layer interface
it seems about time to relax the 16 byte cdb restriction
on the sg driver. Obviously the implementation to do this
has been well tested already by the bsg driver so the same
implementation is lifted by this patch into the sg driver.

SPC-4 (draft rev 36i section 3.1.30) states the maximum cdb
size in SCSI is 260 bytes. [Seems to me XCDBs could exceed
that since they can contain multiple XCDB descriptors each
of which is 140 bytes long.] Anyway the sg v3 interface
(sg_io_hdr as used by the sg driver) restricts the cdb length
by the type of its 'unsigned char cmd_len;' field, namely
255. So not quite 260 but better than 16. The bsg driver
uses a uint32_t for its cdb length field and may want to
consider putting an upper limit on that ...

Documentation: This file in the kernel:
   Documentation/scsi/scsi-generic.txt
does not describe the sg v3 interface but instead points to
this page:
   http://sg.danny.cz/sg/p/sg_v3_ho.html
which does describe the sg v3 interface. If this patch is
accepted I will update the description of the cmd_len
field in that web page.


ChangeLog:
     - remove the 16 byte CDB (SCSI command) length limit
       from the sg driver by handling longer CDBs the same
       way as the bsg driver. Remove comment from sg.h
       public interface about the cmd_len field being
       limited to 16 bytes.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


--------------070608000409030603010406
Content-Type: text/x-patch;
 name="sg3111_cdb1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg3111_cdb1.patch"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5cbc4bb..c46d4b2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -7,7 +7,7 @@
  * Original driver (sg.c):
  *        Copyright (C) 1992 Lawrence Foard
  * Version 2 and 3 extensions to driver:
- *        Copyright (C) 1998 - 2005 Douglas Gilbert
+ *        Copyright (C) 1998 - 2013 Douglas Gilbert
  *
  *  Modified  19-JAN-1998  Richard Gooch <rgooch@atnf.csiro.au>  Devfs support
  *
@@ -18,8 +18,8 @@
  *
  */
 
-static int sg_version_num = 30534;	/* 2 digits for each component */
-#define SG_VERSION_STR "3.5.34"
+static int sg_version_num = 30535;	/* 2 digits for each component */
+#define SG_VERSION_STR "3.5.35"
 
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
@@ -64,7 +64,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20061027";
+static char *sg_version_date = "20130916";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -74,6 +74,9 @@ static void sg_proc_cleanup(void);
 
 #define SG_MAX_DEVS 32768
 
+#define SG_MAX_CDB_SIZE 255	/* should be 260: spc4r36i 3.1.30 */
+
+
 /*
  * Suppose you want to calculate the formula muldiv(x,m,d)=int(x * m / d)
  * Then when using 32 bit integers x * m may overflow during the calculation.
@@ -542,7 +545,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	Sg_request *srp;
 	struct sg_header old_hdr;
 	sg_io_hdr_t *hp;
-	unsigned char cmnd[MAX_COMMAND_SIZE];
+	unsigned char cmnd[SG_MAX_CDB_SIZE];
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
@@ -574,7 +577,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	buf += SZ_SG_HEADER;
 	__get_user(opcode, buf);
 	if (sfp->next_cmd_len > 0) {
-		if (sfp->next_cmd_len > MAX_COMMAND_SIZE) {
+		if (sfp->next_cmd_len > SG_MAX_CDB_SIZE) {
 			SCSI_LOG_TIMEOUT(1, printk("sg_write: command length too long\n"));
 			sfp->next_cmd_len = 0;
 			sg_remove_request(sfp, srp);
@@ -651,7 +654,7 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 	int k;
 	Sg_request *srp;
 	sg_io_hdr_t *hp;
-	unsigned char cmnd[MAX_COMMAND_SIZE];
+	unsigned char cmnd[SG_MAX_CDB_SIZE];
 	int timeout;
 	unsigned long ul_timeout;
 
@@ -1624,14 +1627,25 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
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
@@ -1718,6 +1732,8 @@ static int sg_finish_rem_req(Sg_request * srp)
 		if (srp->bio)
 			ret = blk_rq_unmap_user(srp->bio);
 
+		if (srp->rq->cmd != srp->rq->__cmd)
+			kfree(srp->rq->cmd);
 		blk_put_request(srp->rq);
 	}
 
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index a9f3c6f..8bba53d 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -11,9 +11,9 @@
 Original driver (sg.h):
 *       Copyright (C) 1992 Lawrence Foard
 Version 2 and 3 extensions to driver:
-*       Copyright (C) 1998 - 2006 Douglas Gilbert
+*       Copyright (C) 1998 - 2013 Douglas Gilbert
 
-    Version: 3.5.34 (20060920)
+    Version: 3.5.35 (20130916)
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


--------------070608000409030603010406--
