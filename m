From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [RFC v3 PATCH 1/2] bsg: Add infrastructure to send in kernel bsg
 commands.
Date: Thu, 16 Jun 2011 08:36:19 -0400
Message-ID: <alpine.LFD.2.02.1106160825540.2424@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:54762
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750695Ab1FPMgd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 08:36:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

This is version 3 of this patch which is based on review comments here:
http://marc.info/?l=linux-scsi&m=130590738308822&w=2

Essentially, the code was refactored to reduce code duplication.

From: Chad Dupuis <chad.dupuis@qlogic.com>

This patch adds a new exported function, bsg_private_command() that allows a
device driver or other kernel code to be able to send bsg commands from within
the kernel using sg_io_v4.  The private command infrastructure mimics the ioctl
interface except that the bsg request queue needs to be explicitly passed in.

bsg_map_hdr() and blk_fill_sgv4_hdr_rq() needed to be refactored slightly as
well to allow for both user and kernel buffers.  Two helper functions were
created as a front-end to bsg_map_hdr() so as to call bsg_map_hdr() with the correct
semantics depending on the type of buffer that we're using.  bsg_map_hdr() and
blk_fill_sgv4_hdr_rq() also have an extra argument, is_user, to tell what type
of buffer is being used as well.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
  block/bsg.c         |  138 ++++++++++++++++++++++++++++++++++++++++-----------
  include/linux/bsg.h |    1 +
  2 files changed, 109 insertions(+), 30 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 0c8b64a..9babd96 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -74,6 +74,8 @@ static int bsg_major;

  static struct kmem_cache *bsg_cmd_cachep;

+static struct request *
+bsg_map_hdr(struct request_queue *, struct sg_io_v4 *, fmode_t, u8 *, int);
  /*
   * our internal command type
   */
@@ -173,8 +175,8 @@ unlock:
  }

  static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
-                               struct sg_io_v4 *hdr, struct bsg_device *bd,
-                               fmode_t has_write_perm)
+                               struct sg_io_v4 *hdr, fmode_t has_write_perm,
+                               int is_user)
  {
        if (hdr->request_len > BLK_MAX_CDB) {
                rq->cmd = kzalloc(hdr->request_len, GFP_KERNEL);
@@ -182,9 +184,14 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
                        return -ENOMEM;
        }

-       if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
-                          hdr->request_len))
-               return -EFAULT;
+       if (is_user) {
+               if (copy_from_user(rq->cmd,
+                   (void *)(unsigned long)hdr->request, hdr->request_len))
+                       return -EFAULT;
+       } else {
+               memcpy(rq->cmd, (void *)(unsigned long)hdr->request,
+                   hdr->request_len);
+       }

        if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
                if (blk_verify_command(rq->cmd, has_write_perm))
@@ -238,18 +245,13 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
        return ret;
  }

-/*
- * map sg_io_v4 to a request.
- */
+#define BSG_BUFFER_KERN                0
+#define BSG_BUFFER_USER                1
  static struct request *
-bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
-           u8 *sense)
+bsg_map_hdr_user(struct bsg_device *bd, struct sg_io_v4 *hdr,
+                fmode_t has_write_perm, u8 *sense)
  {
        struct request_queue *q = bd->queue;
-       struct request *rq, *next_rq = NULL;
-       int ret, rw;
-       unsigned int dxfer_len;
-       void *dxferp = NULL;
        struct bsg_class_device *bcd = &q->bsg_dev;

        /* if the LLD has been removed then the bsg_unregister_queue will
@@ -259,6 +261,28 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
        if (!bcd->class_dev)
                return ERR_PTR(-ENXIO);

+       return(bsg_map_hdr(q, hdr, has_write_perm, sense, BSG_BUFFER_USER));
+}
+
+static struct request *
+bsg_map_hdr_kern(struct request_queue *q, struct sg_io_v4 *hdr,
+                 fmode_t has_write_perm, u8 *sense)
+{
+       return(bsg_map_hdr(q, hdr, has_write_perm, sense, BSG_BUFFER_KERN));
+}
+
+/*
+ * map sg_io_v4 to a request.
+ */
+static struct request *
+bsg_map_hdr(struct request_queue *q, struct sg_io_v4 *hdr,
+           fmode_t has_write_perm, u8 *sense, int is_user)
+{
+       struct request *rq, *next_rq = NULL;
+       int ret, rw;
+       unsigned int dxfer_len;
+       void *dxferp = NULL;
+
        dprintk("map hdr %llx/%u %llx/%u\n", (unsigned long long) hdr->dout_xferp,
                hdr->dout_xfer_len, (unsigned long long) hdr->din_xferp,
                hdr->din_xfer_len);
@@ -273,7 +297,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
        rq = blk_get_request(q, rw, GFP_KERNEL);
        if (!rq)
                return ERR_PTR(-ENOMEM);
-       ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, has_write_perm);
+       ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, has_write_perm, is_user);
        if (ret)
                goto out;

@@ -292,8 +316,14 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
                next_rq->cmd_type = rq->cmd_type;

                dxferp = (void*)(unsigned long)hdr->din_xferp;
-               ret =  blk_rq_map_user(q, next_rq, NULL, dxferp,
-                                      hdr->din_xfer_len, GFP_KERNEL);
+
+               if (is_user)
+                       ret =  blk_rq_map_user(q, next_rq, NULL, dxferp,
+                                              hdr->din_xfer_len, GFP_KERNEL);
+               else
+                       ret =  blk_rq_map_kern(q, next_rq, dxferp,
+                                              hdr->din_xfer_len, GFP_KERNEL);
+
                if (ret)
                        goto out;
        }
@@ -308,8 +338,13 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
                dxfer_len = 0;

        if (dxfer_len) {
-               ret = blk_rq_map_user(q, rq, NULL, dxferp, dxfer_len,
-                                     GFP_KERNEL);
+               if (is_user)
+                       ret = blk_rq_map_user(q, rq, NULL, dxferp, dxfer_len,
+                                             GFP_KERNEL);
+               else
+                       ret = blk_rq_map_kern(q, rq, dxferp, dxfer_len,
+                                             GFP_KERNEL);
+
                if (ret)
                        goto out;
        }
@@ -323,7 +358,8 @@ out:
                kfree(rq->cmd);
        blk_put_request(rq);
        if (next_rq) {
-               blk_rq_unmap_user(next_rq->bio);
+               if (is_user)
+                       blk_rq_unmap_user(next_rq->bio);
                blk_put_request(next_rq);
        }
        return ERR_PTR(ret);
@@ -425,7 +461,8 @@ static struct bsg_command *bsg_get_done_cmd(struct bsg_device *bd)
  }

  static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
-                                   struct bio *bio, struct bio *bidi_bio)
+                                   struct bio *bio, struct bio *bidi_bio,
+                                   int is_user)
  {
        int ret = 0;

@@ -445,8 +482,13 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
                int len = min_t(unsigned int, hdr->max_response_len,
                                        rq->sense_len);

-               ret = copy_to_user((void*)(unsigned long)hdr->response,
-                                  rq->sense, len);
+               if (is_user)
+                       ret = copy_to_user((void*)(unsigned long)hdr->response,
+                                          rq->sense, len);
+               else
+                       memcpy((void*)(unsigned long)hdr->response, rq->sense,
+                              len);
+
                if (!ret)
                        hdr->response_len = len;
                else
@@ -456,7 +498,8 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
        if (rq->next_rq) {
                hdr->dout_resid = rq->resid_len;
                hdr->din_resid = rq->next_rq->resid_len;
-               blk_rq_unmap_user(bidi_bio);
+               if (is_user)
+                       blk_rq_unmap_user(bidi_bio);
                blk_put_request(rq->next_rq);
        } else if (rq_data_dir(rq) == READ)
                hdr->din_resid = rq->resid_len;
@@ -472,7 +515,8 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
        if (!ret && rq->errors < 0)
                ret = rq->errors;

-       blk_rq_unmap_user(bio);
+       if (is_user)
+               blk_rq_unmap_user(bio);
        if (rq->cmd != rq->__cmd)
                kfree(rq->cmd);
        blk_put_request(rq);
@@ -519,7 +563,7 @@ static int bsg_complete_all_commands(struct bsg_device *bd)
                        break;

                tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-                                               bc->bidi_bio);
+                                               bc->bidi_bio, 1);
                if (!ret)
                        ret = tret;

@@ -554,7 +598,7 @@ __bsg_read(char __user *buf, size_t count, struct bsg_device *bd,
                 * bsg_complete_work() cannot do that for us
                 */
                ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-                                              bc->bidi_bio);
+                                              bc->bidi_bio, 1);

                if (copy_to_user(buf, &bc->hdr, sizeof(bc->hdr)))
                        ret = -EFAULT;
@@ -645,7 +689,7 @@ static int __bsg_write(struct bsg_device *bd, const char __user *buf,
                /*
                 * get a request, fill in the blanks, and add to request queue
                 */
-               rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm, bc->sense);
+               rq = bsg_map_hdr_user(bd, &bc->hdr, has_write_perm, bc->sense);
                if (IS_ERR(rq)) {
                        ret = PTR_ERR(rq);
                        rq = NULL;
@@ -936,7 +980,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
                if (copy_from_user(&hdr, uarg, sizeof(hdr)))
                        return -EFAULT;

-               rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE, sense);
+               rq = bsg_map_hdr_user(bd, &hdr, file->f_mode & FMODE_WRITE, sense);
                if (IS_ERR(rq))
                        return PTR_ERR(rq);

@@ -946,7 +990,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)

                at_head = (0 == (hdr.flags & BSG_FLAG_Q_AT_TAIL));
                blk_execute_rq(bd->queue, NULL, rq, at_head);
-               ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
+               ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio, 1);

                if (copy_to_user(uarg, &hdr, sizeof(hdr)))
                        return -EFAULT;
@@ -965,6 +1009,40 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
        }
  }

+int bsg_private_command (struct request_queue *q, struct sg_io_v4 *hdr)
+{
+       struct request *rq;
+       struct bio *bio, *bidi_bio = NULL;
+       int at_head;
+       u8 sense[SCSI_SENSE_BUFFERSIZE];
+       fmode_t has_write_perm = 0;
+       int ret;
+
+       if (!q)
+               return -ENXIO;
+
+       /* Fake that we have write permission */
+       has_write_perm |= FMODE_WRITE;
+
+       rq = bsg_map_hdr_kern(q, hdr, has_write_perm, sense);
+
+       if (IS_ERR(rq)) {
+               return PTR_ERR(rq);
+       }
+
+       bio = rq->bio;
+       if (rq->next_rq)
+               bidi_bio = rq->next_rq->bio;
+
+       at_head = (0 == (hdr->flags & BSG_FLAG_Q_AT_TAIL));
+
+       blk_execute_rq(q, NULL, rq, at_head);
+       ret = blk_complete_sgv4_hdr_rq(rq, hdr, bio, bidi_bio, 0);
+
+       return ret;
+}
+EXPORT_SYMBOL(bsg_private_command);
+
  static const struct file_operations bsg_fops = {
        .read           =       bsg_read,
        .write          =       bsg_write,
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index ecb4730..60adc01 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -77,6 +77,7 @@ extern int bsg_register_queue(struct request_queue *q,
                              struct device *parent, const char *name,
                              void (*release)(struct device *));
  extern void bsg_unregister_queue(struct request_queue *);
+extern int bsg_private_command (struct request_queue *, struct sg_io_v4 *);
  #else
  static inline int bsg_register_queue(struct request_queue *q,
                                     struct device *parent, const char *name,
--
1.7.0.31.g1df487

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

