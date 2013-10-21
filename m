From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] [SCSI] sg: late O_EXCL fix for lk 3.12-rc
Date: Mon, 21 Oct 2013 12:26:39 -0400
Message-ID: <526555BF.90909@interlog.com>
References: <52640025.60709@interlog.com> <52641389.6090604@acm.org> <526460A0.3000807@interlog.com> <5265037B.4050108@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090706090307050205090206"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5265037B.4050108@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>, Madper Xie <cxie@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090706090307050205090206
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13-10-21 06:35 AM, Vaughan Cao wrote:
>
> On 2013年10月21日 07:00, Douglas Gilbert wrote:
>> On 13-10-20 01:31 PM, Bart Van Assche wrote:
>>> On 10/20/13 18:09, Douglas Gilbert wrote:
>>>> Given that lk 3.12.0 release is not far away, the safest path
>>>> may still be to revert Vaughan Cao's patch. I'll leave that
>>>> decision to the maintainers.
>>>
>>> Hello Doug,
>>>
>>> Thanks for looking into this. But I would appreciate it if you could address the
>>> whitespace errors reported by checkpatch:

<snip>

>> I'd prefer people to test the patch or find logical flaws.
>>
>> Doug Gilbert
>>
> Hi Doug,
>
> Will the lines below conflict with the meaning of NONBLOCK?
>  >+ down(&sdp->or_sem);
>  >+ alone = sfds_list_empty(sdp);
>  > if (!((flags & O_NONBLOCK) ||
>  > scsi_block_when_processing_errors(sdp->device))) {
>
> Assume one thread holds the or_sem and waiting in
> scsi_block_when_processing_errors for the underlying scsi device to complete
> error recovery,
> another thread with O_NONBLOCK call sg_open().

Indeed. New (replacement) patch attached, moving the
down() below that check.

> I'm also curious why we can skip checking _processing_errors() when called with
> O_NONBLOCK?...Though it has been there from the very beginning.

.. very beginning?? The world did not start with git.
If memory serves: blame->jeb for that logic. And it
does a non-interruptible wait_event(), grrr. 'git
blame' is still interesting, I notice even the LWN
editor has visited.

> In other words, since scsi device may go into a error recovery state at random
> time, why we only check here?

There are scsi_block_when_processing_errors() calls
sprinkled all over the place. Too many is never enough.
And why are they bypassed in the sg driver when
O_NOBLOCK is given? Because clearing the error condition
on the device may need a SCSI command injected from the
user space. Pass-through, pass-by ...

Testing in this area can be real fun:
   - generate a stream of SCSI command sequences, fired
     from multiple threads/processes and vary the open
     O_NONBLOCK and O_EXCL flags
   - fire off signals to those processes and threads at
     random times
   - detach the underlying device(s) at random times
   - and set the "processing_errors" state on the device
     for variable amounts of time, once in a while

For bonus points make those SCSI devices send back
interesting UNIT ATTENTIONs from time to time and/or
trigger timeouts by not reponding in time.


This is a proposed patch over Vaughan Cao's patch currently
in the lk 3.12.0-rc series. It replaces his per-device
read-write semaphore with:
   - a normal semaphore (or_sem) to stop co-incident open()s
     and release()s on the same device treading on the same
     data.
   - a wait_queue (open_wait) to handle wait on open() which is
     associated with the use of O_EXCL (when O_NONBLOCK is not
     given). The two wait_event_interruptible() calls are in a
     loop because multiple open()s could be waiting on either
     case. All get woken up but only one will get the down() at
     the bottom of the loop and proceed to complete the open(),
     potentially leaving the other candidates to continue waiting
     until it releases.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


--------------090706090307050205090206
Content-Type: text/x-patch;
 name="sg_7vc_dg2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg_7vc_dg2.diff"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5cbc4bb..252d15ba 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -170,7 +170,8 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 	u32 index;		/* device index number */
 	spinlock_t sfd_lock;	/* protect file descriptor list for device */
 	struct list_head sfds;
-	struct rw_semaphore o_sem;	/* exclude open should hold this rwsem */
+	struct semaphore or_sem;  /* protect co-incidental opens and releases */
+	wait_queue_head_t open_wait;	/* waits associated with O_EXCL */
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
 	char exclude;		/* opened for exclusive access */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
@@ -232,6 +233,16 @@ static int sfds_list_empty(Sg_device *sdp)
 }
 
 static int
+open_wait_event(Sg_device *sdp, int excl_case)
+{
+	int retval;
+
+	retval = wait_event_interruptible(sdp->open_wait, (sdp->detached ||
+		    (excl_case ? (!sdp->exclude) : sfds_list_empty(sdp))));
+	return sdp->detached ? -ENODEV : retval;
+}
+
+static int
 sg_open(struct inode *inode, struct file *filp)
 {
 	int dev = iminor(inode);
@@ -239,7 +250,7 @@ sg_open(struct inode *inode, struct file *filp)
 	struct request_queue *q;
 	Sg_device *sdp;
 	Sg_fd *sfp;
-	int retval;
+	int alone, retval;
 
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
@@ -260,59 +271,81 @@ sg_open(struct inode *inode, struct file *filp)
 	if (retval)
 		goto sdp_put;
 
+	/* scsi_block_when_processing_errors() may block so bypass
+	 * check if O_NONBLOCK. Permits SCSI commands to be issued
+	 * during error recovery. Tread carefully. */
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
 		/* we are in error recovery for this device */
-		goto error_out;
+		goto error_upped;
 	}
 
+	down(&sdp->or_sem);
+	alone = sfds_list_empty(sdp);
 	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE))) {
 		retval = -EPERM; /* Can't lock it with read only access */
 		goto error_out;
 	}
 	if (flags & O_NONBLOCK) {
 		if (flags & O_EXCL) {
-			if (!down_write_trylock(&sdp->o_sem)) {
+			if (!alone) {
 				retval = -EBUSY;
 				goto error_out;
 			}
 		} else {
-			if (!down_read_trylock(&sdp->o_sem)) {
+			if (sdp->exclude) {
 				retval = -EBUSY;
 				goto error_out;
 			}
 		}
 	} else {
-		if (flags & O_EXCL)
-			down_write(&sdp->o_sem);
-		else
-			down_read(&sdp->o_sem);
+		if (flags & O_EXCL) {
+			while (!alone) {
+				up(&sdp->or_sem);
+				retval = open_wait_event(sdp, 0);
+				if (retval) /* -ERESTARTSYS or -ENODEV */
+					goto error_upped;
+				down(&sdp->or_sem);
+				alone = sfds_list_empty(sdp);
+			}
+		} else {
+			while (sdp->exclude) {
+				up(&sdp->or_sem);
+				retval = open_wait_event(sdp, 1);
+				if (retval) /* -ERESTARTSYS or -ENODEV */
+					goto error_upped;
+				down(&sdp->or_sem);
+				alone = sfds_list_empty(sdp);
+			}
+		}
 	}
 	/* Since write lock is held, no need to check sfd_list */
 	if (flags & O_EXCL)
 		sdp->exclude = 1;	/* used by release lock */
 
-	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
+	if (alone) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = queue_max_segments(q);
 	}
 	sfp = sg_add_sfp(sdp, dev);
-	if (!IS_ERR(sfp))
+	if (!IS_ERR(sfp)) {
 		filp->private_data = sfp;
 		/* retval is already provably zero at this point because of the
 		 * check after retval = scsi_autopm_get_device(sdp->device))
 		 */
-	else {
+		up(&sdp->or_sem);
+	} else {
 		retval = PTR_ERR(sfp);
 
 		if (flags & O_EXCL) {
 			sdp->exclude = 0;	/* undo if error */
-			up_write(&sdp->o_sem);
-		} else
-			up_read(&sdp->o_sem);
+			wake_up_interruptible(&sdp->open_wait);
+		}
 error_out:
+		up(&sdp->or_sem);
+error_upped:
 		scsi_autopm_put_device(sdp->device);
 sdp_put:
 		scsi_device_put(sdp->device);
@@ -333,17 +366,18 @@ sg_release(struct inode *inode, struct file *filp)
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
+	down(&sdp->or_sem);
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
 	excl = sdp->exclude;
-	sdp->exclude = 0;
 	if (excl)
-		up_write(&sdp->o_sem);
-	else
-		up_read(&sdp->o_sem);
+		sdp->exclude = 0;
 
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
+	if (excl || sfds_list_empty(sdp))
+		wake_up_interruptible(&sdp->open_wait);
+	up(&sdp->or_sem);
 	return 0;
 }
 
@@ -1393,7 +1427,8 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	sdp->device = scsidp;
 	spin_lock_init(&sdp->sfd_lock);
 	INIT_LIST_HEAD(&sdp->sfds);
-	init_rwsem(&sdp->o_sem);
+	sema_init(&sdp->or_sem, 1);
+	init_waitqueue_head(&sdp->open_wait);
 	sdp->sg_tablesize = queue_max_segments(q);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);

--------------090706090307050205090206--
