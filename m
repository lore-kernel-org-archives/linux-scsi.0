From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] sg: restore command permission for TYPE_SCANNER
Date: Sat, 26 Jul 2008 18:03:24 +0900
Message-ID: <1217063005-25083-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <20080724123140V.fujita.tomonori@lab.ntt.co.jp>
 <1217063005-25083-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1217063005-25083-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:49373 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYGZJFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jul 2008 05:05:22 -0400
In-Reply-To: <1217063005-25083-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, dan.j.williams@intel.com, adel.gadllah@gmail.com, pjones@redhat.com, viro@ZenIV.linux.org.uk, dougg@torque.net, matthew@wil.cx, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

sg allowed any command for TYPE_SCANNER. The cmd_filter patchset
doesn't. We can't change sg's permission since it might break the
existing software.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 207c357..2973773 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -217,6 +217,18 @@ static int sg_last_dev(void);
 #define SZ_SG_IOVEC sizeof(sg_iovec_t)
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
 
+static int sg_allow_access(struct file *filp, unsigned char *cmd)
+{
+	struct sg_fd *sfp = (struct sg_fd *)filp->private_data;
+	struct request_queue *q = sfp->parentdp->device->request_queue;
+
+	if (sfp->parentdp->device->type == TYPE_SCANNER)
+		return 0;
+
+	return blk_verify_command(&q->cmd_filter,
+				  cmd, filp->f_mode & FMODE_WRITE);
+}
+
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -641,7 +653,6 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 	int timeout;
 	unsigned long ul_timeout;
-	struct request_queue *q;
 
 	if (count < SZ_SG_IO_HDR)
 		return -EINVAL;
@@ -690,9 +701,7 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 		sg_remove_request(sfp, srp);
 		return -EFAULT;
 	}
-	q = sfp->parentdp->device->request_queue;
-	if (read_only && blk_verify_command(&q->cmd_filter, cmnd,
-					    file->f_mode & FMODE_WRITE)) {
+	if (read_only && sg_allow_access(file, cmnd)) {
 		sg_remove_request(sfp, srp);
 		return -EPERM;
 	}
@@ -1061,14 +1070,11 @@ sg_ioctl(struct inode *inode, struct file *filp,
 			return -ENODEV;
 		if (read_only) {
 			unsigned char opcode = WRITE_6;
-			struct request_queue *q = sdp->device->request_queue;
 			Scsi_Ioctl_Command __user *siocp = p;
 
 			if (copy_from_user(&opcode, siocp->data, 1))
 				return -EFAULT;
-			if (blk_verify_command(&q->cmd_filter,
-					       &opcode,
-					       filp->f_mode & FMODE_WRITE))
+			if (sg_allow_access(filp, &opcode))
 				return -EPERM;
 		}
 		return sg_scsi_ioctl(filp, sdp->device->request_queue, NULL, p);
-- 
1.5.4.2

