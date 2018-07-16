From: Jann Horn <jannh@google.com>
Subject: [PATCH v4] bsg: mitigate read/write abuse, block uaccess in release
Date: Mon, 16 Jul 2018 18:51:54 +0200
Message-ID: <20180716165154.58794-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, jannh@google.com
Cc: linux-kernel@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Al Viro <viro@zeniv.linux.org.uk>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, kernel-hardening@lists.openwall.com, security@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

As Al Viro noted in commit 128394eff343 ("sg_write()/bsg_write() is not fit
to be called under KERNEL_DS"), bsg improperly accesses userspace
memory outside the provided buffer, permitting kernel memory corruption via
splice().
But bsg doesn't just do it on ->write(), also on ->read() and ->release().

As a band-aid, make sure that the ->read() and ->write() handlers can not
be called in weird contexts (kernel context or credentials different from
file opener), like for ib_safe_file_access().
Also, completely prevent user memory accesses in ->release() context.

Also put a deprecation warning in the read/write handlers.

This is similar to commit 26b5b874aff5 ("scsi: sg: mitigate read/write
abuse"), which deals with similar issues in /dev/sg*.

Fixes: 3d6392cfbd7d ("bsg: support for full generic block layer SG v3")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jann Horn <jannh@google.com>
---
Resending for bsg as requested by Christoph Hellwig.

("PATCH v4" is a bit of a misnomer, but probably less confusing than
anything else I could have put in the subject line? Is there a canonical
way to deal with patch series that have been split up?)

changes:
 - fix control flow in bsg_transport_complete_rq (v1 had a bug there)
 - extract bsg part, since sg part has already landed separately
   (Christoph Hellwig)
 - put deprecation warning in read/write handlers, similar to Linus'
   suggested patch for sg

 block/bsg-lib.c     |  7 +++++--
 block/bsg.c         | 43 ++++++++++++++++++++++++++++++++++---------
 include/linux/bsg.h |  3 ++-
 3 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 9419def8c017..e21f246526e2 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -53,7 +53,8 @@ static int bsg_transport_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
 	return 0;
 }
 
-static int bsg_transport_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
+static int bsg_transport_complete_rq(struct request *rq, struct sg_io_v4 *hdr,
+				     bool cleaning_up)
 {
 	struct bsg_job *job = blk_mq_rq_to_pdu(rq);
 	int ret = 0;
@@ -79,7 +80,9 @@ static int bsg_transport_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
 	if (job->reply_len && hdr->response) {
 		int len = min(hdr->max_response_len, job->reply_len);
 
-		if (copy_to_user(uptr64(hdr->response), job->reply, len))
+		if (cleaning_up)
+			ret = -EINVAL;
+		else if (copy_to_user(uptr64(hdr->response), job->reply, len))
 			ret = -EFAULT;
 		else
 			hdr->response_len = len;
diff --git a/block/bsg.c b/block/bsg.c
index 3da540faf673..deedce8c9ec2 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -21,6 +21,7 @@
 #include <linux/idr.h>
 #include <linux/bsg.h>
 #include <linux/slab.h>
+#include <linux/cred.h> /* for bsg_check_file_access() */
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
@@ -159,7 +160,8 @@ static int bsg_scsi_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
 	return 0;
 }
 
-static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
+static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr,
+				bool cleaning_up)
 {
 	struct scsi_request *sreq = scsi_req(rq);
 	int ret = 0;
@@ -179,7 +181,9 @@ static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
 		int len = min_t(unsigned int, hdr->max_response_len,
 					sreq->sense_len);
 
-		if (copy_to_user(uptr64(hdr->response), sreq->sense, len))
+		if (cleaning_up)
+			ret = -EINVAL;
+		else if (copy_to_user(uptr64(hdr->response), sreq->sense, len))
 			ret = -EFAULT;
 		else
 			hdr->response_len = len;
@@ -381,11 +385,12 @@ static struct bsg_command *bsg_get_done_cmd(struct bsg_device *bd)
 }
 
 static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
-				    struct bio *bio, struct bio *bidi_bio)
+				    struct bio *bio, struct bio *bidi_bio,
+				    bool cleaning_up)
 {
 	int ret;
 
-	ret = rq->q->bsg_dev.ops->complete_rq(rq, hdr);
+	ret = rq->q->bsg_dev.ops->complete_rq(rq, hdr, cleaning_up);
 
 	if (rq->next_rq) {
 		blk_rq_unmap_user(bidi_bio);
@@ -451,7 +456,7 @@ static int bsg_complete_all_commands(struct bsg_device *bd)
 			break;
 
 		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-						bc->bidi_bio);
+						bc->bidi_bio, true);
 		if (!ret)
 			ret = tret;
 
@@ -486,7 +491,7 @@ __bsg_read(char __user *buf, size_t count, struct bsg_device *bd,
 		 * bsg_complete_work() cannot do that for us
 		 */
 		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-					       bc->bidi_bio);
+					       bc->bidi_bio, false);
 
 		if (copy_to_user(buf, &bc->hdr, sizeof(bc->hdr)))
 			ret = -EFAULT;
@@ -523,6 +528,15 @@ static inline int err_block_err(int ret)
 	return 0;
 }
 
+static int bsg_check_file_access(struct file *file, const char *caller)
+{
+	if (file->f_cred != current_real_cred())
+		return -EPERM;
+	if (uaccess_kernel())
+		return -EACCES;
+	return 0;
+}
+
 static ssize_t
 bsg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
@@ -532,6 +546,13 @@ bsg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	bsg_dbg(bd, "read %zd bytes\n", count);
 
+	pr_err_once("process %d (%s) does direct read on /dev/bsg/*\n",
+		task_tgid_vnr(current), current->comm);
+
+	ret = bsg_check_file_access(file, __func__);
+	if (ret)
+		return ret;
+
 	bsg_set_block(bd, file);
 
 	bytes_read = 0;
@@ -606,8 +627,12 @@ bsg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 
 	bsg_dbg(bd, "write %zd bytes\n", count);
 
-	if (unlikely(uaccess_kernel()))
-		return -EINVAL;
+	pr_err_once("process %d (%s) does direct write on /dev/bsg/*\n",
+		task_tgid_vnr(current), current->comm);
+
+	ret = bsg_check_file_access(file, __func__);
+	if (ret)
+		return ret;
 
 	bsg_set_block(bd, file);
 
@@ -857,7 +882,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		at_head = (0 == (hdr.flags & BSG_FLAG_Q_AT_TAIL));
 		blk_execute_rq(bd->queue, NULL, rq, at_head);
-		ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
+		ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio, false);
 
 		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
 			return -EFAULT;
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index dac37b6e00ec..c22bc359552a 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -11,7 +11,8 @@ struct bsg_ops {
 	int	(*check_proto)(struct sg_io_v4 *hdr);
 	int	(*fill_hdr)(struct request *rq, struct sg_io_v4 *hdr,
 				fmode_t mode);
-	int	(*complete_rq)(struct request *rq, struct sg_io_v4 *hdr);
+	int	(*complete_rq)(struct request *rq, struct sg_io_v4 *hdr,
+				bool cleaning_up);
 	void	(*free_rq)(struct request *rq);
 };
 
-- 
2.18.0.203.gfac676dfb9-goog
