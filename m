From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [iscsi 2/2] iscsi-probe.c
Date: Tue, 23 Sep 2003 16:53:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030923165301.A18885@infradead.org>
References: <20030923152306.GA14522@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:35338 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261473AbTIWPxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 11:53:03 -0400
Content-Disposition: inline
In-Reply-To: <20030923152306.GA14522@gtf.org>; from jgarzik@pobox.com on Tue, Sep 23, 2003 at 11:23:06AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

> #include <linux/blk.h>

Okay, this is for review only, but only a 2.6 version would have the
slightest chance of getting merged some day..

> #include <endian.h>

Did you actually try to compile this?  This is a userspace header and
not available in a kernel uild.

> /* these are from $(TOPDIR)/drivers/scsi, not $(TOPDIR)/include */
> #include <scsi.h>
> #include <hosts.h>

We tend to use "" includes for these.  Also in 2.6 there's no need for
hosts.h anymore and soon scsi.h - use <scsi/*.h) instead.

> DECLARE_MUTEX(iscsi_lun_probe_mutex);
> spinlock_t iscsi_lun_probe_lock = SPIN_LOCK_UNLOCKED;
> static iscsi_session_t *iscsi_lun_probe_head = NULL;
> static iscsi_session_t *iscsi_lun_probe_tail = NULL;
> static iscsi_session_t *iscsi_currently_probing = NULL;
> static volatile int iscsi_next_probe = 0;
> volatile unsigned long iscsi_lun_probe_start = 0;

No need for initializers here, looks like someone didn't read the
basic docs.

> 
> /* we need to make some syscalls to create and destroy the device name tree. */
> static int errno = 0;

Umm...

> static inline _syscall2(long, mkdir, const char *, dir, int, mode);
> static inline _syscall1(long, unlink, const char *, path);
> static inline _syscall2(long, symlink, const char *, oldname, const char *,
> 			newname);
> static inline
> _syscall3(int, open, const char *, file, int, flag, int, mode)
> static inline
> _syscall1(int, close, int, fd)
> static inline
> _syscall1(long, rmdir, const char *, path);
> static inline
> _syscall3(int, getdents, uint, fd, struct dirent *, dirp, uint, count);

Even more umm...

> 	if (session->probe_next || session->probe_prev) {
> 		DEBUG_INIT
> 		    ("iSCSI: session for bus_id id %d target_id %d already queued for LUN probing\n",

Please linewrap after 80 chars.

> 	if (iscsi_lun_probe_head) {
> 		if (session->probe_order < iscsi_lun_probe_head->probe_order) {
> 			/* insert before the current head */
> 			session->probe_prev = NULL;
> 			session->probe_next = iscsi_lun_probe_head;
> 			iscsi_lun_probe_head->probe_prev = session;
> 			iscsi_lun_probe_head = session;

Don't you want list.h lists here? (And all over the driver)

> /* try to write to /proc/scsi/scsi */
> static int
> write_proc_scsi_scsi(iscsi_session_t * session, char *str)
> {
> 	struct file *filp = NULL;
> 	loff_t offset = 0;
> 	int rc = 0;
> 	mm_segment_t oldfs = get_fs();
> 
> 	set_fs(get_ds());
> 
> 	filp = filp_open("/proc/scsi/scsi", O_WRONLY, 0);
> 	if (IS_ERR(filp)) {
> 		printk
> 		    ("iSCSI: session (bus %d target %d)couldn't open /proc/scsi/scsi\n",
> 		     session->iscsi_bus, session->target_id);
> 		set_fs(oldfs);
> 		return -ENOENT;
> 	}
> 
> 	rc = filp->f_op->write(filp, str, strlen(str), &offset);
> 	filp_close(filp, 0);
> 	set_fs(oldfs);

Stop that crap.  Now.  I'm not going to review this any further until
all this asssumptions about random files in the namespace are fixed.

(the /dev messing below is even worse..)
