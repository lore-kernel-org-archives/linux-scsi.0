From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] add scsi_cmd_ioctl (SG_IO) support for st
Date: Sun, 1 Feb 2004 12:50:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201125031.A18128@beaverton.ibm.com>
References: <20040201124803.A18050@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:14030 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265415AbUBAUvB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2004 15:51:01 -0500
Content-Disposition: inline
In-Reply-To: <20040201124803.A18050@beaverton.ibm.com>; from patmans@us.ibm.com on Sun, Feb 01, 2004 at 12:48:03PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

Add SG_IO support for st, so we can send scsi commands directly to an st
device.

Though st (still?) needs to move to move away from cdev for udev to
function with it.

diff -uprN -X /home/patman/dontdiff bk-2.6.2-rc3/drivers/scsi/st.c char_sg_io-bk-2.6.2-rc3/drivers/scsi/st.c
--- bk-2.6.2-rc3/drivers/scsi/st.c	Mon Jan  5 08:46:42 2004
+++ char_sg_io-bk-2.6.2-rc3/drivers/scsi/st.c	Sun Feb  1 11:53:03 2004
@@ -179,6 +179,7 @@ static int sgl_unmap_user_pages(struct s
 
 static int st_probe(struct device *);
 static int st_remove(struct device *);
+static int st_init_command(struct scsi_cmnd *);
 
 static void do_create_driverfs_files(void);
 static void do_remove_driverfs_files(void);
@@ -191,6 +192,7 @@ static struct scsi_driver st_template = 
 		.probe		= st_probe,
 		.remove		= st_remove,
 	},
+	.init_command		= st_init_command,
 };
 
 static int st_compression(Scsi_Tape *, int);
@@ -3389,7 +3391,11 @@ static int st_ioctl(struct inode *inode,
 		goto out;
 	}
 	up(&STp->lock);
-	return scsi_ioctl(STp->device, cmd_in, (void *) arg);
+	i = scsi_cmd_ioctl(STp->disk, cmd_in, arg);
+	if (i != -ENOTTY)
+		return i;
+	else
+		return scsi_ioctl(STp->device, cmd_in, (void *) arg);
 
  out:
 	up(&STp->lock);
@@ -3796,6 +3802,7 @@ static int st_probe(struct device *dev)
 	tpnt->disk = disk;
 	sprintf(disk->disk_name, "st%d", i);
 	disk->private_data = &tpnt->driver;
+	disk->queue = SDp->request_queue;
 	tpnt->driver = &st_template;
 	scsi_tapes[i] = tpnt;
 	dev_num = i;
@@ -3983,6 +3990,41 @@ static int st_remove(struct device *dev)
 
 	write_unlock(&st_dev_arr_lock);
 	return 0;
+}
+
+static void st_intr(struct scsi_cmnd *SCpnt)
+{
+	scsi_io_completion(SCpnt, (SCpnt->result ? 0: SCpnt->bufflen >> 9), 1);
+}
+
+/*
+ * st_init_command: only called via the scsi_cmd_ioctl (block SG_IO)
+ * interface for REQ_BLOCK_PC commands.
+ */
+static int st_init_command(struct scsi_cmnd *SCpnt)
+{
+	struct request *rq;
+
+	if (!(SCpnt->request->flags & REQ_BLOCK_PC))
+		return 0;
+
+	rq = SCpnt->request;
+	if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
+		return 0;
+
+	memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
+
+	if (rq_data_dir(rq) == WRITE)
+		SCpnt->sc_data_direction = DMA_TO_DEVICE;
+	else if (rq->data_len)
+		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
+	else
+		SCpnt->sc_data_direction = DMA_NONE;
+
+	SCpnt->timeout_per_command = rq->timeout;
+	SCpnt->transfersize = rq->data_len;
+	SCpnt->done = st_intr;
+	return 1;
 }
 
 static int __init init_st(void)
