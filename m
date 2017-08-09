From: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC PATCH 1/6] bsg: fix kernel panic resulting from missing allocation of a reply-buffer
Date: Wed,  9 Aug 2017 16:11:15 +0200
Message-ID: <9e67ce3fc2f3cd42e9e05b2753b00d6676f46ee1.1502120928.git.bblock@linux.vnet.ibm.com>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCLYZUM5WUFRBNVQVTGAKGQEWQZHQWY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <cover.1502120928.git.bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
In-Reply-To: <cover.1502120928.git.bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
References: <cover.1502120928.git.bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

In contrast to the normal SCSI-lib, the BSG block-queue doesn't make use of
any extra init_rq_fn() to make additional allocations during
request-creation, and the request sense-pointer is not used to transport
SCSI sense data, but is used as backing for the bsg_job->reply pointer;
that in turn is used in the LLDs to store protocol IUs or similar stuff.
This 're-purposing' of the sense-pointer is done in the BSG blk-lib
(bsg_create_job()), during the queue-processing.

Failing to allocate/assign it results in illegal dereferences because LLDs
use this pointer unquestioned, as can be seen in the various
BSG-implementations:

drivers/scsi/libfc/fc_lport.c:  fc_lport_bsg_request()
drivers/scsi/qla2xxx/qla_bsg.c: qla24xx_bsg_request()
drivers/scsi/qla4xxx/ql4_bsg.c: qla4xxx_process_vendor_specific()
drivers/s390/scsi/zfcp_fc.c:    zfcp_fc_ct_els_job_handler()
...

An example panic on s390x, using the zFCP driver, looks like this (I had
debugging on, otherwise NULL-pointer dereferences wouldn't even panic on
s390x):

Unable to handle kernel pointer dereference in virtual kernel address space
Failing address: 6b6b6b6b6b6b6000 TEID: 6b6b6b6b6b6b6403
Fault in home space mode while using kernel ASCE.
AS:0000000001590007 R3:0000000000000024
Oops: 0038 ilc:2 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: <Long List>
CPU: 2 PID: 0 Comm: swapper/2 Not tainted 4.12.0-bsg-regression+ #3
Hardware name: IBM 2964 N96 702 (z/VM 6.4.0)
task: 0000000065cb0100 task.stack: 0000000065cb4000
Krnl PSW : 0704e00180000000 000003ff801e4156 (zfcp_fc_ct_els_job_handler+0x16/0x58 [zfcp])
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
Krnl GPRS: 0000000000000001 000000005fa9d0d0 000000005fa9d078 0000000000e16866
           000003ff00000290 6b6b6b6b6b6b6b6b 0000000059f78f00 000000000000000f
           00000000593a0958 00000000593a0958 0000000060d88800 000000005ddd4c38
           0000000058b50100 07000000659cba08 000003ff801e8556 00000000659cb9a8
Krnl Code: 000003ff801e4146: e31020500004        lg      %r1,80(%r2)
           000003ff801e414c: 58402040           l       %r4,64(%r2)
          #000003ff801e4150: e35020200004       lg      %r5,32(%r2)
          >000003ff801e4156: 50405004           st      %r4,4(%r5)
           000003ff801e415a: e54c50080000       mvhi    8(%r5),0
           000003ff801e4160: e33010280012       lt      %r3,40(%r1)
           000003ff801e4166: a718fffb           lhi     %r1,-5
           000003ff801e416a: 1803               lr      %r0,%r3
Call Trace:
([<000003ff801e8556>] zfcp_fsf_req_complete+0x726/0x768 [zfcp])
 [<000003ff801ea82a>] zfcp_fsf_reqid_check+0x102/0x180 [zfcp]
 [<000003ff801eb980>] zfcp_qdio_int_resp+0x230/0x278 [zfcp]
 [<00000000009b91b6>] qdio_kick_handler+0x2ae/0x2c8
 [<00000000009b9e3e>] __tiqdio_inbound_processing+0x406/0xc10
 [<00000000001684c2>] tasklet_action+0x15a/0x1d8
 [<0000000000bd28ec>] __do_softirq+0x3ec/0x848
 [<00000000001675a4>] irq_exit+0x74/0xf8
 [<000000000010dd6a>] do_IRQ+0xba/0xf0
 [<0000000000bd19e8>] io_int_handler+0x104/0x2d4
 [<00000000001033b6>] enabled_wait+0xb6/0x188
([<000000000010339e>] enabled_wait+0x9e/0x188)
 [<000000000010396a>] arch_cpu_idle+0x32/0x50
 [<0000000000bd0112>] default_idle_call+0x52/0x68
 [<00000000001cd0fa>] do_idle+0x102/0x188
 [<00000000001cd41e>] cpu_startup_entry+0x3e/0x48
 [<0000000000118c64>] smp_start_secondary+0x11c/0x130
 [<0000000000bd2016>] restart_int_handler+0x62/0x78
 [<0000000000000000>]           (null)
INFO: lockdep is turned off.
Last Breaking-Event-Address:
 [<000003ff801e41d6>] zfcp_fc_ct_job_handler+0x3e/0x48 [zfcp]

Kernel panic - not syncing: Fatal exception in interrupt

To prevent this, allocate a buffer when the BSG blk-request is setup, and
before it is queued for LLD processing.

Reported-by: Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Signed-off-by: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Fixes: 82ed4db499b8 ("block: split scsi_request out of struct request")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #4.11+
---
 block/bsg.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 37663b664666..285b1b8126c3 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -74,6 +74,8 @@ static int bsg_major;
 
 static struct kmem_cache *bsg_cmd_cachep;
 
+#define BSG_COMMAND_REPLY_BUFFERSIZE	SCSI_SENSE_BUFFERSIZE
+
 /*
  * our internal command type
  */
@@ -85,6 +87,7 @@ struct bsg_command {
 	struct bio *bidi_bio;
 	int err;
 	struct sg_io_v4 hdr;
+	u8 reply_buffer[BSG_COMMAND_REPLY_BUFFERSIZE];
 };
 
 static void bsg_free_command(struct bsg_command *bc)
@@ -137,7 +140,7 @@ static inline struct hlist_head *bsg_dev_idx_hash(int index)
 
 static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 				struct sg_io_v4 *hdr, struct bsg_device *bd,
-				fmode_t has_write_perm)
+				u8 *reply_buffer, fmode_t has_write_perm)
 {
 	struct scsi_request *req = scsi_req(rq);
 
@@ -162,6 +165,10 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 	 */
 	req->cmd_len = hdr->request_len;
 
+	/* this is later asigned to bsg_job as reply */
+	req->sense = reply_buffer;
+	req->sense_len = BSG_COMMAND_REPLY_BUFFERSIZE;
+
 	rq->timeout = msecs_to_jiffies(hdr->timeout);
 	if (!rq->timeout)
 		rq->timeout = q->sg_timeout;
@@ -206,7 +213,8 @@ bsg_validate_sgv4_hdr(struct sg_io_v4 *hdr, int *op)
  * map sg_io_v4 to a request.
  */
 static struct request *
-bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
+bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
+	    u8 *reply_buffer)
 {
 	struct request_queue *q = bd->queue;
 	struct request *rq, *next_rq = NULL;
@@ -237,7 +245,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
 	if (IS_ERR(rq))
 		return rq;
 
-	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, has_write_perm);
+	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, reply_buffer,
+				   has_write_perm);
 	if (ret)
 		goto out;
 
@@ -619,7 +628,8 @@ static int __bsg_write(struct bsg_device *bd, const char __user *buf,
 		/*
 		 * get a request, fill in the blanks, and add to request queue
 		 */
-		rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm);
+		rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm,
+				 bc->reply_buffer);
 		if (IS_ERR(rq)) {
 			ret = PTR_ERR(rq);
 			rq = NULL;
@@ -908,6 +918,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 	case SG_IO: {
 		struct request *rq;
+		u8 reply_buffer[BSG_COMMAND_REPLY_BUFFERSIZE] = { 0, };
 		struct bio *bio, *bidi_bio = NULL;
 		struct sg_io_v4 hdr;
 		int at_head;
@@ -915,7 +926,8 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
 			return -EFAULT;
 
-		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE);
+		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE,
+				 reply_buffer);
 		if (IS_ERR(rq))
 			return PTR_ERR(rq);
 
-- 
2.12.2

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
