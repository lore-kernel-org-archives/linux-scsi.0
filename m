From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: requesting advice: oops when doing sg_dd IO and device is removed
Date: Mon, 17 Oct 2005 09:33:56 -0400
Message-ID: <92952AEF1F064042B6EF2522E0EEF437024334E7@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub4.stratus.com ([134.111.1.17]:47330 "EHLO
	mailhub4.stratus.com") by vger.kernel.org with ESMTP
	id S1751320AbVJQNd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2005 09:33:58 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

Doug (and anyone else who might be interested), I'm looking for some
advice as to how best to fix a problem I hit in sg.

I was doing the following:

- start up several processes reading from an sg device with sg_dd
- every other iteration, kill the processes
- remove the device (echo 1 > /sys/bus/scsi/devices/1:0:1:0/delete)
- add the device (echo "0 1 0" > /sys/class/scsi_host/host1/scan)

This was on a 2.6.9 kernel, with a patch:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112749860222533&w=2

That I've submitted to the LSML... patch was intended to fix a different
oops when doing the above test.

Here's what I saw, after the device was removed:

Debug: sleeping function called from invalid context at
include/linux/rwsem.h:6in_atomic():1[expected: 0], irqs_disabled():0
 [<c011fcd1>] __might_sleep+0x7d/0x88
 [<c021cb5e>] device_del+0x1e/0x90
 [<f8840ccc>] scsi_device_dev_release+0xdf/0x13a [scsi_mod]
 [<c021c8e9>] device_release+0x11/0x40
 [<c01bf03f>] kobject_cleanup+0x40/0x60
 [<c01bf05f>] kobject_release+0x0/0x8
 [<c01bf305>] kref_put+0x42/0x45
 [<f883e61b>] scsi_next_command+0xc/0x14 [scsi_mod]
 [<f883a0a8>] scsi_release_request+0x8/0x10 [scsi_mod]
 [<f883ab15>] scsi_finish_command+0xad/0xb1 [scsi_mod]
 [<f883aa3a>] scsi_softirq+0xb6/0xbe [scsi_mod]
 [<c0126424>] __do_softirq+0x4c/0xb1
 [<c010812f>] do_softirq+0x4f/0x56
 =======================
 [<c0107a44>] do_IRQ+0x1a2/0x1ae
 [<c02d1a8c>] common_interrupt+0x18/0x20
 [<c0104018>] default_idle+0x0/0x2c
 [<c0104041>] default_idle+0x29/0x2c
 [<c010409d>] cpu_idle+0x26/0x3b
 [<c0390786>] start_kernel+0x199/0x19d

(It looks like a command comes back, we drop the last reference on the
device, the device is freed... because we're in softirq, and device_del
may eventually sleep (in this kernel version, anyway), we get this debug
message. I don't think this should normally happen when a command comes
back, for reasons I'll discuss below)

Continuing on...

Badness in kref_get at lib/kref.c:32
 [<c01bf2bb>] kref_get+0x24/0x2c
 [<c01beffb>] kobject_get+0xf/0x13
 [<c021cb32>] get_device+0xe/0x14
 [<f883ef34>] scsi_request_fn+0x19/0x319 [scsi_mod]
 [<c022213e>] blk_run_queue+0x20/0x2f
 [<f883a0a8>] scsi_release_request+0x8/0x10 [scsi_mod]
 [<f883ab15>] scsi_finish_command+0xad/0xb1 [scsi_mod]
 [<f883aa3a>] scsi_softirq+0xb6/0xbe [scsi_mod]
 [<c0126424>] __do_softirq+0x4c/0xb1
 [<c010812f>] do_softirq+0x4f/0x56
 =======================
 [<c0107a44>] do_IRQ+0x1a2/0x1ae
 [<c02d1a8c>] common_interrupt+0x18/0x20
 [<c0104018>] default_idle+0x0/0x2c
 [<c0104041>] default_idle+0x29/0x2c
 [<c010409d>] cpu_idle+0x26/0x3b
 [<c0390786>] start_kernel+0x199/0x19d

(So, there were more commands on the device's queue... presumably for
sg, since I wasn't doing any other IO to this disk. We're trying to get
a reference on the device, but the ref count has already gone to 0 so
this "Badness" message results.)

Continuing on...

Unable to handle kernel NULL pointer dereference at virtual address
00000008
 printing eip:
c0229678
*pde = 00004001
Oops: 0000 [#1]
SMP
Modules linked in: sg(U) parport_pc lp parport autofs4 nfs lockd sunrpc
md5
 ip)
CPU:  0
EIP:    0060:[<c0229678>]    Tainted: PF     VLI
EFLAGS: 00010046   (2.6.9-20.ELsmp)
EIP is at cfq_next_request+0x7/0x35
eax: f7b6f5e0   ebx: 00000000   ecx: c03249bc   edx: f243a594
esi: f7b6f5e0   edi: f7f5b000   ebp: f7b6f5e0   esp: c03c7f80
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, threadinfo=c03c7000 task=c031ea80)
Stack: f7b6f5e0 f7b6f5e0 c02209dc f7b6f5e0 f243a400 f7f5b000 f883ef51
f7b6f5e0
       00000246 f243a400 00000000 c022213e f7d62800 f3872800 f883a0a8
f7f5b000
       f883ab15 00002002 f3872800 c03c7fd4 f883aa3a c03c7fd4 c03c7fd4
00000003
Call Trace:
 [<c02209dc>] elv_next_request+0xbe/0xce
 [<f883ef51>] scsi_request_fn+0x36/0x319 [scsi_mod]
 [<c022213e>] blk_run_queue+0x20/0x2f
 [<f883a0a8>] scsi_release_request+0x8/0x10 [scsi_mod]
 [<f883ab15>] scsi_finish_command+0xad/0xb1 [scsi_mod]
 [<f883aa3a>] scsi_softirq+0xb6/0xbe [scsi_mod]
 [<c0126424>] __do_softirq+0x4c/0xb1
 [<c010812f>] do_softirq+0x4f/0x56
 =======================
 [<c0107a44>] do_IRQ+0x1a2/0x1ae
 [<c02d1a8c>] common_interrupt+0x18/0x20
 [<c0104018>] default_idle+0x0/0x2c
 [<c0104041>] default_idle+0x29/0x2c
 [<c010409d>] cpu_idle+0x26/0x3b
 [<c0390786>] start_kernel+0x199/0x19d
Code: 01 00 00 00 89 e8 eb b6 8b 04 24 3b 43 24 0f 92 c0 31 d2 85 ff 0f
95 c2

(It was inevitable that something bad would happen when trying to run
the queue on a device which had been freed)


My theory here is that sg should be holding a reference on the SCSI
device until all IO comes back. With or without the patch I mentioned
above, this is not the case. Although sg_release does take out an extra
reference if there's any IO still outstanding, if sg_remove is called,
this reference is dropped. So after sg_remove, there could still be IO
to the device outstanding, but no reference on the device (from sg).
This means the device could get freed even though there's still some sg
IO on the queue.

Does this analysis sound reasonable? I'm a bit puzzled by the fact that
sd (for example) doesn't appear to have this problem (maybe sd_release
just never gets called until all IO comes back?).


So, how to fix this?

The first thing I tried was adding a kref to the Sg_device struct,
patterned after the reference counting in sd, sr, st. In sg_release, I
would drop a reference only if there was no IO outstanding. If there
_was_ IO outstanding, I would drop the reference in sg_cmd_done when the
last IO came back. In theory, this would ensure that sg kept a reference
on the device until all IO came back.

First problem: I was protecting the kref with a mutex, as sd, sr, etc.
do. Trying to down the mutex from sg_cmd_done didn't work (as this is
done from softirq). Okay, so I took out the mutex, just to see how
things would work. Still there was a problem... doing the final
scsi_device_put in sg_cmd_done won't work, because
scsi_device_dev_release calls device_del, which may sleep (in this
kernel version, anyway... I think this has changed in later kernels). So
it seems trying to drop a reference when the last command comes back is
out of the question.

The next thing I tried was simply sleeping in sg_release until all
outstanding IO comes back (changing sg_remove_sfp to return a count of
outstanding IOs), and only then dropping the device reference (patch
below). This seems to be working fine. But I'm wondering if this is
really a good solution? I'm not sure I can think of anything else... any
ideas?

Thanks!

Nate Dailey
Stratus Technologies


Here's the "wait in sg_release" patch (which I think is still useful,
even if it's not strictly required). This is against a 2.6.9 kernel, but
I can resubmit a patch against a later kernel if desired...

--- sg.c.orig   2005-10-13 16:50:00.806798387 -0400
+++ sg.c        2005-10-13 16:07:06.365733548 -0400
@@ -49,6 +49,7 @@ static int sg_version_num = 30531;    /* 2
 #include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/kref.h>

 #include "scsi.h"
 #include <scsi/scsi_host.h>
@@ -173,6 +174,7 @@ typedef struct sg_device { /* holds the
        char sgdebug;           /* 0->off, 1->sense, 9->dump dev, 10->
all devs */
        struct gendisk *disk;
        struct cdev * cdev;     /* char_dev [sysfs:
/sys/cdev/major/sg<n>] */
+       struct kref kref;
 } Sg_device;

 static int sg_fasync(int fd, struct file *filp, int mode);
@@ -218,11 +220,61 @@ static Sg_device **sg_dev_arr = NULL;
 static int sg_dev_max;
 static int sg_nr_dev;

+/* This semaphore is used to mediate the 0->1 reference get in the
+ * face of object destruction (i.e. we can't allow a get on an
+ * object after last put) */
+static DECLARE_MUTEX(sg_ref_sem);
+
+static void scsi_generic_release(struct kref *kref);
+#define to_scsi_generic(obj) container_of(obj,Sg_device,kref)
+
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
 #define SZ_SG_IOVEC sizeof(sg_iovec_t)
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)

+static Sg_device *scsi_generic_get(int dev)
+{
+       Sg_device *sdp = NULL;
+
+       down(&sg_ref_sem);
+
+       sdp = sg_get_dev (dev);
+       if (!sdp) goto out;
+
+       if (sdp->detached) {
+               sdp = NULL;
+               goto out;
+       }
+
+       kref_get(&sdp->kref);
+
+       if (!sdp->device)
+               goto out_put;
+
+       if (scsi_device_get(sdp->device))
+               goto out_put;
+
+       goto out;
+
+out_put:
+       kref_put(&sdp->kref, scsi_generic_release);
+       sdp = NULL;
+out:
+       up(&sg_ref_sem);
+       return sdp;
+}
+
+static void scsi_generic_put(Sg_device *sdp)
+{
+       struct scsi_device *sdev = sdp->device;
+
+       down(&sg_ref_sem);
+       kref_put(&sdp->kref, scsi_generic_release);
+       scsi_device_put(sdev);
+       up(&sg_ref_sem);
+}
+
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -235,17 +287,8 @@ sg_open(struct inode *inode, struct file

        nonseekable_open(inode, filp);
        SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev,
flags));
-       sdp = sg_get_dev(dev);
-       if ((!sdp) || (!sdp->device))
+       if (!(sdp = scsi_generic_get(dev)))
                return -ENXIO;
-       if (sdp->detached)
-               return -ENODEV;
-
-       /* This driver's module count bumped by fops_get in <linux/fs.h>
*/
-       /* Prevent the device driver from vanishing while we sleep */
-       retval = scsi_device_get(sdp->device);
-       if (retval)
-               return retval;

        if (!((flags & O_NONBLOCK) ||
              scsi_block_when_processing_errors(sdp->device))) {
@@ -302,7 +345,7 @@ sg_open(struct inode *inode, struct file
        return 0;

       error_out:
-       scsi_device_put(sdp->device);
+       scsi_generic_put(sdp);
        return retval;
 }

@@ -317,13 +360,14 @@ sg_release(struct inode *inode, struct f
                return -ENXIO;
        SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n",
sdp->disk->disk_name));
        sg_fasync(-1, filp, 0); /* remove filp from async notification
list */
-       if (0 == sg_remove_sfp(sdp, sfp)) {     /* Returns 1 when sdp
gone */
-               if (!sdp->detached) {
-                       scsi_device_put(sdp->device);
-               }
-               sdp->exclude = 0;
-               wake_up_interruptible(&sdp->o_excl_wait);
-       }
+
+       /* Don't release the device until all IO comes back. */
+       while (sg_remove_sfp(sdp, sfp)){
+               msleep(10);
+       }
+       sdp->exclude = 0;
+       wake_up_interruptible(&sdp->o_excl_wait);
+       scsi_generic_put(sdp);
        return 0;
 }

@@ -1238,7 +1285,7 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
        sfp = srp->parentfp;
        if (sfp)
                sdp = sfp->parentdp;
-       if ((NULL == sdp) || sdp->detached) {
+       if (NULL == sdp) {
                printk(KERN_INFO "sg_cmd_done: device detached\n");
                scsi_release_request(SRpnt);
                return;
@@ -1292,18 +1339,8 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
        scsi_release_request(SRpnt);
        SRpnt = NULL;
-       if (sfp->closed) {      /* whoops this fd already released,
cleanup */
-               SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed,
freeing ...\n"));
-               sg_finish_rem_req(srp);
-               srp = NULL;
-               if (NULL == sfp->headrp) {
-                       SCSI_LOG_TIMEOUT(1, printk("sg...bh: already
closed, final cleanup\n"));
-                       if (0 == sg_remove_sfp(sdp, sfp)) {     /*
device still present */
-                               scsi_device_put(sdp->device);
-                       }
-                       sfp = NULL;
-               }
-       } else if (srp && srp->orphan) {
+
+       if (srp && srp->orphan) {
                if (sfp->keep_orphan)
                        srp->sg_io_owned = 0;
                else {
@@ -1441,6 +1478,7 @@ sg_add(struct class_device *cl_dev)
        }
        k = error;
        sdp = sg_dev_arr[k];
+       kref_init(&sdp->kref);

        devfs_mk_cdev(MKDEV(SCSI_GENERIC_MAJOR, k),
                        S_IFCHR | S_IRUSR | S_IWUSR | S_IRGRP,
@@ -1493,45 +1531,33 @@ sg_remove(struct class_device *cl_dev)
        unsigned long iflags;
        Sg_fd *sfp;
        Sg_fd *tsfp;
-       Sg_request *srp;
-       Sg_request *tsrp;
-       int k, delay;
+       int k;

        if (NULL == sg_dev_arr)
                return;
-       delay = 0;
        write_lock_irqsave(&sg_dev_arr_lock, iflags);
        for (k = 0; k < sg_dev_max; k++) {
-               sdp = sg_dev_arr[k];
-               if ((NULL == sdp) || (sdp->device != scsidp))
+               if ((NULL == sg_dev_arr[k]) ||
+                   (sg_dev_arr[k]->device != scsidp))
                        continue;       /* dirty but lowers nesting */
+               sdp = sg_dev_arr[k];
+               sdp->detached = 1;
+
                if (sdp->headfp) {
-                       sdp->detached = 1;
                        for (sfp = sdp->headfp; sfp; sfp = tsfp) {
                                tsfp = sfp->nextfp;
-                               for (srp = sfp->headrp; srp; srp = tsrp)
{
-                                       tsrp = srp->nextrp;
-                                       if (sfp->closed || (0 ==
sg_srp_done(srp, sfp)))
-                                               sg_finish_rem_req(srp);
-                               }
-                               if (sfp->closed) {
-                                       scsi_device_put(sdp->device);
-                                       __sg_remove_sfp(sdp, sfp);
-                               } else {
-                                       delay = 1;
+                               if (!(sfp->closed)) {
 
wake_up_interruptible(&sfp->read_wait);
                                        kill_fasync(&sfp->async_qp,
SIGPOLL,
                                                    POLL_HUP);
                                }
                        }
                        SCSI_LOG_TIMEOUT(3, printk("sg_detach: dev=%d,
dirty\n", k));
-                       if (NULL == sdp->headfp) {
-                               sg_dev_arr[k] = NULL;
-                       }
                } else {        /* nothing active, simple case */
                        SCSI_LOG_TIMEOUT(3, printk("sg_detach:
dev=%d\n", k));
-                       sg_dev_arr[k] = NULL;
                }
+
+               sg_dev_arr[k] = NULL;
                sg_nr_dev--;
                break;
        }
@@ -1543,14 +1569,32 @@ sg_remove(struct class_device *cl_dev)
                cdev_del(sdp->cdev);
                sdp->cdev = NULL;
                devfs_remove("%s/generic", scsidp->devfs_name);
-               put_disk(sdp->disk);
-               sdp->disk = NULL;
-               if (NULL == sdp->headfp)
-                       kfree((char *) sdp);
+
+               down(&sg_ref_sem);
+               kref_put(&sdp->kref, scsi_generic_release);
+               up(&sg_ref_sem);
        }
+}
+
+/**
+ *      scsi_generic_release - Called to free the Sg_device structure
+ *      @kref: pointer to embedded kref
+ *
+ *      sg_ref_sem must be held entering this routine.  Because it is
+ *      called on last put, you should always use the
scsi_generic_get()
+ *      and scsi_generic_put() helpers which manipulate the semaphore
+ *      directly and never do a direct kref_put().
+ **/
+static void scsi_generic_release(struct kref *kref)
+{
+       Sg_device *sdp = to_scsi_generic(kref);
+       struct gendisk *disk = sdp->disk;
+
+       disk->private_data = NULL;
+       put_disk(disk);

-       if (delay)
-               msleep(10);     /* dirty detach so delay device
destruction */
+       kfree((char *) sdp);
+       return;
 }

 /* Set 'perm' (4th argument) to 0 to disable module_param's definition
@@ -2484,14 +2528,13 @@ __sg_remove_sfp(Sg_device * sdp, Sg_fd *
        sg_page_free((char *) sfp, sizeof (Sg_fd));
 }

-/* Returns 0 in normal case, 1 when detached and sdp object removed */
+/* Returns a count of IOs still in progress. */
 static int
 sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp)
 {
        Sg_request *srp;
        Sg_request *tsrp;
        int dirty = 0;
-       int res = 0;

        for (srp = sfp->headrp; srp; srp = tsrp) {
                tsrp = srp->nextrp;
@@ -2505,30 +2548,16 @@ sg_remove_sfp(Sg_device * sdp, Sg_fd * s

                write_lock_irqsave(&sg_dev_arr_lock, iflags);
                __sg_remove_sfp(sdp, sfp);
-               if (sdp->detached && (NULL == sdp->headfp)) {
-                       int k, maxd;
-
-                       maxd = sg_dev_max;
-                       for (k = 0; k < maxd; ++k) {
-                               if (sdp == sg_dev_arr[k])
-                                       break;
-                       }
-                       if (k < maxd)
-                               sg_dev_arr[k] = NULL;
-                       kfree((char *) sdp);
-                       res = 1;
-               }
                write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
        } else {
-               /* MOD_INC's to inhibit unloading sg and associated
adapter driver */
-               /* only bump the access_count if we actually succeeded
in
-                * throwing another counter on the host module */
-               scsi_device_get(sdp->device);   /* XXX: retval ignored?
*/
+               /* The non-zero dirty count will be returned. This will
tell
+                  the caller not to drop the reference on this device.
*/
+
                sfp->closed = 1;        /* flag dirty state on this fd
*/
                SCSI_LOG_TIMEOUT(1, printk("sg_remove_sfp: worrisome, %d
writes pending\n",
                                  dirty));
        }
-       return res;
+       return dirty;
 }

 static int
