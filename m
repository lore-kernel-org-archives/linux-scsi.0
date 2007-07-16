From: Andrew Morton <akpm@linux-foundation.org>
Subject: block/bsg.c
Date: Mon, 16 Jul 2007 16:57:06 -0700
Message-ID: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756411AbXGPX5z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 19:57:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


A belated review (I've never seen this before and there it is in mainline)

> static char bsg_version[] = "block layer sg (bsg) 0.4";

`const' would be better.  That moves it into a write-protected memory section.

> struct bsg_device {
> 	request_queue_t *queue;
> 	spinlock_t lock;
> 	struct list_head busy_list;
> 	struct list_head done_list;
> 	struct hlist_node dev_list;
> 	atomic_t ref_count;
> 	int minor;
> 	int queued_cmds;
> 	int done_cmds;
> 	wait_queue_head_t wq_done;
> 	wait_queue_head_t wq_free;
> 	char name[BUS_ID_SIZE];
> 	int max_queue;
> 	unsigned long flags;
> };

Please try to comment your data structures.  This is key to allowing others
to understand your code.

> #undef BSG_DEBUG
> 
> #ifdef BSG_DEBUG
> #define dprintk(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ##args)
> #else
> #define dprintk(fmt, args...)
> #endif

hm, that seems to be out 187th implementation of dprintk().

> #define list_entry_bc(entry)	list_entry((entry), struct bsg_command, list)

This makes the code easier to write but harder to read.  We should optimise
for readers.  Please open-code this at callsites.

Or at least convert it into a (commented) (possibly inlined) C function.

> /*
>  * just for testing
>  */
> #define BSG_MAJOR	(240)

What's this doing in mainline?  240 is a "reserved for local use" major. 
This will cause collisions.  This code should be using dynamic major
assignment.

> static DEFINE_MUTEX(bsg_mutex);
> static int bsg_device_nr, bsg_minor_idx;
> 
> #define BSG_LIST_SIZE	(8)

afacit this isn't really the size of a list.  It has something to do with
the number of minors which are attached to that illegitimate major?  A
comment here would help.  Perhaps this name is poorly chosen.

> #define bsg_list_idx(minor)	((minor) & (BSG_LIST_SIZE - 1))

Please prefer to write code in C, not in cpp.

> static struct hlist_head bsg_device_list[BSG_LIST_SIZE];

That is an array, not a list.

> static struct class *bsg_class;
> static LIST_HEAD(bsg_class_list);
> 
> static struct kmem_cache *bsg_cmd_cachep;

How many of these items do we expect to be simultaneously allocated?  If
that number is small then a custom kmem_cache is probably not warranted.

> /*
>  * our internal command type
>  */
> struct bsg_command {
> 	struct bsg_device *bd;
> 	struct list_head list;
> 	struct request *rq;
> 	struct bio *bio;
> 	struct bio *bidi_bio;
> 	int err;
> 	struct sg_io_v4 hdr;
> 	struct sg_io_v4 __user *uhdr;
> 	char sense[SCSI_SENSE_BUFFERSIZE];
> };

Comments here, please.

> static void bsg_free_command(struct bsg_command *bc)
> {
> 	struct bsg_device *bd = bc->bd;
> 	unsigned long flags;
> 
> 	kmem_cache_free(bsg_cmd_cachep, bc);
> 
> 	spin_lock_irqsave(&bd->lock, flags);
> 	bd->queued_cmds--;
> 	spin_unlock_irqrestore(&bd->lock, flags);
> 
> 	wake_up(&bd->wq_free);
> }
> 
> static struct bsg_command *bsg_alloc_command(struct bsg_device *bd)
> {
> 	struct bsg_command *bc = ERR_PTR(-EINVAL);
> 
> 	spin_lock_irq(&bd->lock);
> 
> 	if (bd->queued_cmds >= bd->max_queue)
> 		goto out;
> 
> 	bd->queued_cmds++;
> 	spin_unlock_irq(&bd->lock);
> 
> 	bc = kmem_cache_alloc(bsg_cmd_cachep, GFP_USER);

This should be GFP_KERNEL.

> 	if (unlikely(!bc)) {
> 		spin_lock_irq(&bd->lock);
> 		bd->queued_cmds--;
> 		bc = ERR_PTR(-ENOMEM);
> 		goto out;
> 	}
> 
> 	memset(bc, 0, sizeof(*bc));

Use kmem_cache_zalloc() above, remove this.

> 	bc->bd = bd;
> 	INIT_LIST_HEAD(&bc->list);
> 	dprintk("%s: returning free cmd %p\n", bd->name, bc);
> 	return bc;
> out:
> 	spin_unlock_irq(&bd->lock);
> 	return bc;
> }
> 
> static inline void
> bsg_del_done_cmd(struct bsg_device *bd, struct bsg_command *bc)
> {
> 	bd->done_cmds--;
> 	list_del(&bc->list);
> }

This only has a single caller.  It would be clearer to move this code into
that caller.

> static inline void
> bsg_add_done_cmd(struct bsg_device *bd, struct bsg_command *bc)
> {
> 	bd->done_cmds++;
> 	list_add_tail(&bc->list, &bd->done_list);
> 	wake_up(&bd->wq_done);
> }

Ditto.  Once this has been moved into the caller, that caller can then use
the neater list_move().

> static inline int bsg_io_schedule(struct bsg_device *bd, int state)

This is too large to inline.

> {
> 	DEFINE_WAIT(wait);
> 	int ret = 0;
> 
> 	spin_lock_irq(&bd->lock);
> 
> 	BUG_ON(bd->done_cmds > bd->queued_cmds);
> 
> 	/*
> 	 * -ENOSPC or -ENODATA?  I'm going for -ENODATA, meaning "I have no
> 	 * work to do", even though we return -ENOSPC after this same test
> 	 * during bsg_write() -- there, it means our buffer can't have more
> 	 * bsg_commands added to it, thus has no space left.
> 	 */
> 	if (bd->done_cmds == bd->queued_cmds) {
> 		ret = -ENODATA;
> 		goto unlock;
> 	}
> 
> 	if (!test_bit(BSG_F_BLOCK, &bd->flags)) {
> 		ret = -EAGAIN;
> 		goto unlock;
> 	}
> 
> 	prepare_to_wait(&bd->wq_done, &wait, state);
> 	spin_unlock_irq(&bd->lock);
> 	io_schedule();
> 	finish_wait(&bd->wq_done, &wait);

No, io_schedule() _must_ be called in state TASK_UNINTERRUPTIBLE.  If it
gets called in state TASK_INTERRUPTIBLE then all the accounting which it
does becomes wrong.

Fortunately the sole caller of this function _does_ use
TASK_UNINTERRUPTIBLE.  The `state' arg to this function should be removed.

> 	if ((state == TASK_INTERRUPTIBLE) && signal_pending(current))
> 		ret = -ERESTARTSYS;

And this code should be deleted.

> 	return ret;
> unlock:
> 	spin_unlock_irq(&bd->lock);
> 	return ret;
> }
> 
> static int blk_fill_sgv4_hdr_rq(request_queue_t *q, struct request *rq,
> 				struct sg_io_v4 *hdr, int has_write_perm)
> {
> 	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
> 
> 	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
> 			   hdr->request_len))
> 		return -EFAULT;
> 
> 	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
> 		if (blk_verify_command(rq->cmd, has_write_perm))
> 			return -EPERM;
> 	} else if (!capable(CAP_SYS_RAWIO))
> 		return -EPERM;

As a reader of this code I'm wondering "hm, why is
BSG_SUB_PROTOCOL_SCSI_CMD unprivileged, while other modes require
CAP_SYS_RAWIO"?.

This design/policy decision maybe was discussed on a mailing list
somewhere, or even perhaps in a changelog (although I can't find it).  But
it is so important, and is so unobvious from a reading of the code that I'd
suggest that it is worth some discussion right here, in a code comment.

> 	/*
> 	 * fill in request structure
> 	 */
> 	rq->cmd_len = hdr->request_len;
> 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
> 
> 	rq->timeout = (hdr->timeout * HZ) / 1000;
> 	if (!rq->timeout)
> 		rq->timeout = q->sg_timeout;
> 	if (!rq->timeout)
> 		rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
> 
> 	return 0;
> }
> 
> /*
>  * Check if sg_io_v4 from user is allowed and valid
>  */
> static int
> bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
> {
> 	int ret = 0;
> 
> 	if (hdr->guard != 'Q')
> 		return -EINVAL;

hm, "Q".  What is the user interface to this new stuff?

What does the code in bsg.c _do_, anyway??  Ho hum.

> 	if (hdr->request_len > BLK_MAX_CDB)
> 		return -EINVAL;
> 	if (hdr->dout_xfer_len > (q->max_sectors << 9) ||
> 	    hdr->din_xfer_len > (q->max_sectors << 9))

Are we sure that nothing here can exceed 4GB now and in the future?

> 		return -EIO;
> 
> 	switch (hdr->protocol) {
> 	case BSG_PROTOCOL_SCSI:
> 		switch (hdr->subprotocol) {
> 		case BSG_SUB_PROTOCOL_SCSI_CMD:
> 		case BSG_SUB_PROTOCOL_SCSI_TRANSPORT:
> 			break;
> 		default:
> 			ret = -EINVAL;
> 		}
> 		break;
> 	default:
> 		ret = -EINVAL;
> 	}
> 
> 	*rw = hdr->dout_xfer_len ? WRITE : READ;
> 	return ret;
> }
> 
> /*
>  * map sg_io_v4 to a request.
>  */
> static struct request *
> bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
> {
> 	request_queue_t *q = bd->queue;
> 	struct request *rq, *next_rq = NULL;
> 	int ret, rw = 0; /* shut up gcc */

The modern way of shutting up gcc is uninitialized_var().

> 	unsigned int dxfer_len;
> 	void *dxferp = NULL;
> 
> 	dprintk("map hdr %llx/%u %llx/%u\n", (unsigned long long) hdr->dout_xferp,
> 		hdr->dout_xfer_len, (unsigned long long) hdr->din_xferp,
> 		hdr->din_xfer_len);
> 
> 	ret = bsg_validate_sgv4_hdr(q, hdr, &rw);
> 	if (ret)
> 		return ERR_PTR(ret);
> 
> 	/*
> 	 * map scatter-gather elements seperately and string them to request
> 	 */
> 	rq = blk_get_request(q, rw, GFP_KERNEL);
> 	if (!rq)
> 		return ERR_PTR(-ENOMEM);
> 	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, test_bit(BSG_F_WRITE_PERM,
> 						       &bd->flags));
> 	if (ret)
> 		goto out;
> 
> 	if (rw == WRITE && hdr->din_xfer_len) {
> 		if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
> 			ret = -EOPNOTSUPP;
> 			goto out;
> 		}
> 
> 		next_rq = blk_get_request(q, READ, GFP_KERNEL);
> 		if (!next_rq) {
> 			ret = -ENOMEM;
> 			goto out;
> 		}
> 		rq->next_rq = next_rq;
> 
> 		dxferp = (void*)(unsigned long)hdr->din_xferp;

So... sg_io_v4.din_xferp is a user virtual address?

And `struct sg_io_v4' has just become part of the kernel ABI?  Beware that
there is a move afoot to require test code, manpages and even LTP testcases
for new ABI extensions.  Is this interface documented anywhere?

> 		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
> 		if (ret)
> 			goto out;
> 	}
> 
> 	if (hdr->dout_xfer_len) {
> 		dxfer_len = hdr->dout_xfer_len;
> 		dxferp = (void*)(unsigned long)hdr->dout_xferp;
> 	} else if (hdr->din_xfer_len) {
> 		dxfer_len = hdr->din_xfer_len;
> 		dxferp = (void*)(unsigned long)hdr->din_xferp;
> 	} else
> 		dxfer_len = 0;
> 
> 	if (dxfer_len) {
> 		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
> 		if (ret)
> 			goto out;
> 	}
> 	return rq;
> out:
> 	blk_put_request(rq);
> 	if (next_rq) {
> 		blk_rq_unmap_user(next_rq->bio);
> 		blk_put_request(next_rq);
> 	}
> 	return ERR_PTR(ret);
> }
> 
> ...
> 
> static inline struct bsg_command *bsg_next_done_cmd(struct bsg_device *bd)
> {
> 	struct bsg_command *bc = NULL;
> 
> 	spin_lock_irq(&bd->lock);
> 	if (bd->done_cmds) {
> 		bc = list_entry_bc(bd->done_list.next);
> 		bsg_del_done_cmd(bd, bc);
> 	}
> 	spin_unlock_irq(&bd->lock);
> 
> 	return bc;
> }

This is too large to inline.

> static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
> 				    struct bio *bio, struct bio *bidi_bio)
> {
> 	int ret = 0;
> 
> 	dprintk("rq %p bio %p %u\n", rq, bio, rq->errors);
> 	/*
> 	 * fill in all the output members
> 	 */
> 	hdr->device_status = status_byte(rq->errors);
> 	hdr->transport_status = host_byte(rq->errors);
> 	hdr->driver_status = driver_byte(rq->errors);
> 	hdr->info = 0;
> 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
> 		hdr->info |= SG_INFO_CHECK;
> 	hdr->din_resid = rq->data_len;
> 	hdr->response_len = 0;
> 
> 	if (rq->sense_len && hdr->response) {
> 		int len = min((unsigned int) hdr->max_response_len,
> 			      rq->sense_len);

Use min_t here

> 		ret = copy_to_user((void*)(unsigned long)hdr->response,
> 				   rq->sense, len);
> 		if (!ret)
> 			hdr->response_len = len;
> 		else
> 			ret = -EFAULT;
> 	}
> 
> 	if (rq->next_rq) {
> 		blk_rq_unmap_user(bidi_bio);
> 		blk_put_request(rq->next_rq);
> 	}
> 
> 	blk_rq_unmap_user(bio);
> 	blk_put_request(rq);
> 
> 	return ret;
> }
> 
> ...
>
> static ssize_t
> __bsg_read(char __user *buf, size_t count, struct bsg_device *bd,
> 	   const struct iovec *iov, ssize_t *bytes_read)
> {
> 	struct bsg_command *bc;
> 	int nr_commands, ret;
> 
> 	if (count % sizeof(struct sg_io_v4))
> 		return -EINVAL;
> 
> 	ret = 0;
> 	nr_commands = count / sizeof(struct sg_io_v4);
> 	while (nr_commands) {
> 		bc = bsg_get_done_cmd(bd);
> 		if (IS_ERR(bc)) {
> 			ret = PTR_ERR(bc);
> 			break;
> 		}
> 
> 		/*
> 		 * this is the only case where we need to copy data back
> 		 * after completing the request. so do that here,
> 		 * bsg_complete_work() cannot do that for us
> 		 */
> 		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
> 					       bc->bidi_bio);
> 
> 		if (copy_to_user(buf, (char *) &bc->hdr, sizeof(bc->hdr)))
> 			ret = -EFAULT;

Unneeded cast.

> 		bsg_free_command(bc);
> 
> 		if (ret)
> 			break;
> 
> 		buf += sizeof(struct sg_io_v4);
> 		*bytes_read += sizeof(struct sg_io_v4);
> 		nr_commands--;
> 	}
> 
> 	return ret;
> }

This function returns zero or a negative errno (as should have been
explainined in its covering comment).  Hence its return type of ssize_t is
misleading.  It should return `int'.  Which is in fact the type of the
local variable which it returns.

> static inline void bsg_set_block(struct bsg_device *bd, struct file *file)
> {
> 	if (file->f_flags & O_NONBLOCK)
> 		clear_bit(BSG_F_BLOCK, &bd->flags);
> 	else
> 		set_bit(BSG_F_BLOCK, &bd->flags);
> }
> 
> static inline void bsg_set_write_perm(struct bsg_device *bd, struct file *file)
> {
> 	if (file->f_mode & FMODE_WRITE)
> 		set_bit(BSG_F_WRITE_PERM, &bd->flags);
> 	else
> 		clear_bit(BSG_F_WRITE_PERM, &bd->flags);
> }

Still wondering what all this code does.  It _appears_ that the chosen user
interface is via some device-special file?  And that an O_NONBLOCK open of
that file has some special (undocumented?) significance?

> static inline int err_block_err(int ret)
> {
> 	if (ret && ret != -ENOSPC && ret != -ENODATA && ret != -EAGAIN)
> 		return 1;
> 
> 	return 0;
> }

What a strange function.  The name is fairly meaningless.  A little comment
would help decrease the mystery.

> static ssize_t
> bsg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> {
> 	struct bsg_device *bd = file->private_data;
> 	int ret;
> 	ssize_t bytes_read;
> 
> 	dprintk("%s: read %Zd bytes\n", bd->name, count);
> 
> 	bsg_set_block(bd, file);
> 	bytes_read = 0;
> 	ret = __bsg_read(buf, count, bd, NULL, &bytes_read);
> 	*ppos = bytes_read;
> 
> 	if (!bytes_read || (bytes_read && err_block_err(ret)))
> 		bytes_read = ret;
> 	return bytes_read;
> }
>
> static ssize_t __bsg_write(struct bsg_device *bd, const char __user *buf,
> 			   size_t count, ssize_t *bytes_read)
> {
> 	struct bsg_command *bc;
> 	struct request *rq;
> 	int ret, nr_commands;
> 
> 	if (count % sizeof(struct sg_io_v4))
> 		return -EINVAL;
> 
> 	nr_commands = count / sizeof(struct sg_io_v4);
> 	rq = NULL;
> 	bc = NULL;
> 	ret = 0;
> 	while (nr_commands) {
> 		request_queue_t *q = bd->queue;
> 
> 		bc = bsg_alloc_command(bd);
> 		if (IS_ERR(bc)) {
> 			ret = PTR_ERR(bc);
> 			bc = NULL;
> 			break;
> 		}
> 
> 		bc->uhdr = (struct sg_io_v4 __user *) buf;
> 		if (copy_from_user(&bc->hdr, buf, sizeof(bc->hdr))) {
> 			ret = -EFAULT;
> 			break;
> 		}
> 
> 		/*
> 		 * get a request, fill in the blanks, and add to request queue
> 		 */
> 		rq = bsg_map_hdr(bd, &bc->hdr);
> 		if (IS_ERR(rq)) {
> 			ret = PTR_ERR(rq);
> 			rq = NULL;
> 			break;
> 		}
> 
> 		bsg_add_command(bd, q, bc, rq);
> 		bc = NULL;
> 		rq = NULL;
> 		nr_commands--;
> 		buf += sizeof(struct sg_io_v4);
> 		*bytes_read += sizeof(struct sg_io_v4);
> 	}
> 
> 	if (bc)
> 		bsg_free_command(bc);
> 
> 	return ret;
> }

Return type should be `int'.

> static ssize_t
> bsg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
> {
> 	struct bsg_device *bd = file->private_data;
> 	ssize_t bytes_read;

This variable should be called bytes_written.

> 	int ret;
> 
> 	dprintk("%s: write %Zd bytes\n", bd->name, count);
> 
> 	bsg_set_block(bd, file);
> 	bsg_set_write_perm(bd, file);
> 
> 	bytes_read = 0;
> 	ret = __bsg_write(bd, buf, count, &bytes_read);
> 	*ppos = bytes_read;
> 
> 	/*
> 	 * return bytes written on non-fatal errors
> 	 */
> 	if (!bytes_read || (bytes_read && err_block_err(ret)))
> 		bytes_read = ret;
> 	dprintk("%s: returning %Zd\n", bd->name, bytes_read);
> 	return bytes_read;
> }
> 
> ...

> 
> static struct bsg_device *bsg_add_device(struct inode *inode,
> 					 struct request_queue *rq,
> 					 struct file *file)
> {
> 	struct bsg_device *bd = NULL;

Unneeded initialisation.

> #ifdef BSG_DEBUG
> 	unsigned char buf[32];
> #endif
> 
> 	bd = bsg_alloc_device();
> 	if (!bd)
> 		return ERR_PTR(-ENOMEM);
> 
> 	bd->queue = rq;
> 	kobject_get(&rq->kobj);
> 	bsg_set_block(bd, file);
> 
> 	atomic_set(&bd->ref_count, 1);
> 	bd->minor = iminor(inode);
> 	mutex_lock(&bsg_mutex);
> 	hlist_add_head(&bd->dev_list, &bsg_device_list[bsg_list_idx(bd->minor)]);
> 
> 	strncpy(bd->name, rq->bsg_dev.class_dev->class_id, sizeof(bd->name) - 1);
> 	dprintk("bound to <%s>, max queue %d\n",
> 		format_dev_t(buf, inode->i_rdev), bd->max_queue);
> 
> 	mutex_unlock(&bsg_mutex);
> 	return bd;
> }
> 
> ...
>
> static int
> bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> 	  unsigned long arg)

This is an file_operations.ioctl() method.  It should instead have been
implemented as an unlocked_ioctl handler.


> {
> 	struct bsg_device *bd = file->private_data;
> 	int __user *uarg = (int __user *) arg;
> 
> 	if (!bd)
> 		return -ENXIO;

This cannot happen, surely?

> 	switch (cmd) {
> 		/*
> 		 * our own ioctls
> 		 */
> 	case SG_GET_COMMAND_Q:
> 		return put_user(bd->max_queue, uarg);
> 	case SG_SET_COMMAND_Q: {
> 		int queue;
> 
> 		if (get_user(queue, uarg))
> 			return -EFAULT;
> 		if (queue < 1)
> 			return -EINVAL;
> 
> 		spin_lock_irq(&bd->lock);
> 		bd->max_queue = queue;
> 		spin_unlock_irq(&bd->lock);
> 		return 0;
> 	}
> 
> 	/*
> 	 * SCSI/sg ioctls
> 	 */
> 	case SG_GET_VERSION_NUM:
> 	case SCSI_IOCTL_GET_IDLUN:
> 	case SCSI_IOCTL_GET_BUS_NUMBER:
> 	case SG_SET_TIMEOUT:
> 	case SG_GET_TIMEOUT:
> 	case SG_GET_RESERVED_SIZE:
> 	case SG_SET_RESERVED_SIZE:
> 	case SG_EMULATED_HOST:
> 	case SCSI_IOCTL_SEND_COMMAND: {
> 		void __user *uarg = (void __user *) arg;
> 		return scsi_cmd_ioctl(file, bd->queue, NULL, cmd, uarg);
> 	}
> 	case SG_IO: {
> 		struct request *rq;
> 		struct bio *bio, *bidi_bio = NULL;
> 		struct sg_io_v4 hdr;
> 
> 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
> 			return -EFAULT;
> 
> 		rq = bsg_map_hdr(bd, &hdr);
> 		if (IS_ERR(rq))
> 			return PTR_ERR(rq);
> 
> 		bio = rq->bio;
> 		if (rq->next_rq)
> 			bidi_bio = rq->next_rq->bio;
> 		blk_execute_rq(bd->queue, NULL, rq, 0);
> 		blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
> 
> 		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
> 			return -EFAULT;
> 
> 		return 0;
> 	}
> 	/*
> 	 * block device ioctls
> 	 */
> 	default:
> #if 0
> 		return ioctl_by_bdev(bd->bdev, cmd, arg);
> #else
> 		return -ENOTTY;
> #endif
> 	}
> }

So we perform IO operations on this "device" by opening it and running
ioctls, the args to which point to fairly complex data structures which lie
in userspace and which contain addresses and lengths of userspace IO
buffers?

What did Christoph think of this? :)

> static struct file_operations bsg_fops = {
> 	.read		=	bsg_read,
> 	.write		=	bsg_write,
> 	.poll		=	bsg_poll,
> 	.open		=	bsg_open,
> 	.release	=	bsg_release,
> 	.ioctl		=	bsg_ioctl,

unlocked_ioctl, please.

> 	.owner		=	THIS_MODULE,
> };
> 
> void bsg_unregister_queue(struct request_queue *q)
> {
> 	struct bsg_class_device *bcd = &q->bsg_dev;
> 
> 	if (!bcd->class_dev)
> 		return;

Can this happen?

> 	mutex_lock(&bsg_mutex);
> 	sysfs_remove_link(&q->kobj, "bsg");
> 	class_device_destroy(bsg_class, MKDEV(BSG_MAJOR, bcd->minor));
> 	bcd->class_dev = NULL;
> 	list_del_init(&bcd->list);
> 	bsg_device_nr--;
> 	mutex_unlock(&bsg_mutex);
> }
> EXPORT_SYMBOL_GPL(bsg_unregister_queue);

<still wondering what all this code does>

Would I be correct in assuming that it offers services to device drivers,
which have yet to be hooked up?

> int bsg_register_queue(struct request_queue *q, const char *name)
> {
> 	struct bsg_class_device *bcd, *__bcd;
> 	dev_t dev;
> 	int ret = -EMFILE;
> 	struct class_device *class_dev = NULL;
> 
> 	/*
> 	 * we need a proper transport to send commands, not a stacked device
> 	 */
> 	if (!q->request_fn)
> 		return 0;
> 
> 	bcd = &q->bsg_dev;
> 	memset(bcd, 0, sizeof(*bcd));
> 	INIT_LIST_HEAD(&bcd->list);
> 
> 	mutex_lock(&bsg_mutex);
> 	if (bsg_device_nr == BSG_MAX_DEVS) {
> 		printk(KERN_ERR "bsg: too many bsg devices\n");

32768 is a lot of devices.  Why is there any limit at all?

> 		goto err;
> 	}
> 
> retry:
> 	list_for_each_entry(__bcd, &bsg_class_list, list) {
> 		if (__bcd->minor == bsg_minor_idx) {
> 			bsg_minor_idx++;
> 			if (bsg_minor_idx == BSG_MAX_DEVS)
> 				bsg_minor_idx = 0;
> 			goto retry;
> 		}
> 	}
> 
> 	bcd->minor = bsg_minor_idx++;
> 	if (bsg_minor_idx == BSG_MAX_DEVS)
> 		bsg_minor_idx = 0;

So what's happening here?  We're doing a linear, potentially O(n^2) search
for a unique minor number?

I expect that you'll find that lib/idr.c provides a more elegant solution. 
The tty code uses this, and there are other examples around the place.


> 	bcd->queue = q;
> 	dev = MKDEV(BSG_MAJOR, bcd->minor);
> 	class_dev = class_device_create(bsg_class, NULL, dev, bcd->dev, "%s", name);
> 	if (IS_ERR(class_dev)) {
> 		ret = PTR_ERR(class_dev);
> 		goto err;
> 	}
> 	bcd->class_dev = class_dev;
> 
> 	if (q->kobj.sd) {
> 		ret = sysfs_create_link(&q->kobj, &bcd->class_dev->kobj, "bsg");
> 		if (ret)
> 			goto err;
> 	}
> 
> 	list_add_tail(&bcd->list, &bsg_class_list);
> 	bsg_device_nr++;
> 
> 	mutex_unlock(&bsg_mutex);
> 	return 0;
> err:
> 	if (class_dev)
> 		class_device_destroy(bsg_class, MKDEV(BSG_MAJOR, bcd->minor));
> 	mutex_unlock(&bsg_mutex);
> 	return ret;
> }
> EXPORT_SYMBOL_GPL(bsg_register_queue);
> 
> ...
>


In terms of presentation: this code hit the tree as base patch plus what
appear to be 20 bugfixes, none of which are really interesting or relevant
to mainline.  Personally I think it would be nicer if all that out-of-tree
development work was cleaned up and the new code goes in as a single hit.

This makes it a lot easier to find out "wtf does this code all do".  One
finds the first commit and reads the changlog.  But this algorithm yields:

    bsg: support for full generic block layer SG v3

which is not helpful.

