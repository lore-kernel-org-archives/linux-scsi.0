From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] generic ring buffer infrastructure
Date: Tue, 06 Feb 2007 08:54:06 +0900
Message-ID: <20070206085406E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:42945 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbXBEXxW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 18:53:22 -0500
Received: from mfs4.rdh.ecl.ntt.co.jp (mfs4.rdh.ecl.ntt.co.jp [129.60.39.113])
	by tama5.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l15NrKun019395
	for <linux-scsi@vger.kernel.org>; Tue, 6 Feb 2007 08:53:20 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp (nttmail3.ecl.ntt.co.jp [129.60.39.100])
	by mfs4.rdh.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l15NrJdg024241
	for <linux-scsi@vger.kernel.org>; Tue, 6 Feb 2007 08:53:19 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l15NrJcU029606
	for <linux-scsi@vger.kernel.org>; Tue, 6 Feb 2007 08:53:19 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is generic ring buffer code that might be useful for bsg, SCSI
target infrastructure, kevent, etc.

I named this event channel, however there should be more better names.

The user interface is pretty similar to kevent but there are some
differences:

- I added the sigmask parameter to a system call to wait events from
kernel (this has been one of the big topics in the kevent threads;
Ulrich wants it though Evgeniy doesn't).

- kevnets needs fake file descriptors to talk with user space while
bsg has its own character devices. So while sys_kevent_init creates a
file descriptor, sys_ec_init binds a file descriptor to ring buffers
(that is a process tells sys_ec_init to setup ring buffers for bind
this file descriptor).

- bsg and SCSI target infrastructure a bi-directional interface while
kevent only needs notification from kernel to user space. A process
can tell kernel to perform ready requests in a ring buffer via ec_send
system call.

I have not started to convert kevent to use this yet. It's doable
though lots of modifications are necessary. Surely it's tricky to do
it cleanly.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/asm-i386/unistd.h       |    6 +-
 include/asm-x86_64/unistd.h     |   12 +-
 include/linux/eventchannel.h    |   36 ++++
 include/linux/eventchannel_if.h |   15 ++
 include/linux/syscalls.h        |    5 +
 init/Kconfig                    |    7 +
 kernel/Makefile                 |    1 +
 kernel/eventchannel.c           |  387 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 466 insertions(+), 3 deletions(-)

diff --git a/include/asm-i386/unistd.h b/include/asm-i386/unistd.h
index 833fa17..32a0d4d 100644
--- a/include/asm-i386/unistd.h
+++ b/include/asm-i386/unistd.h
@@ -325,10 +325,14 @@ #define __NR_vmsplice		316
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_ec_wait		320
+#define __NR_ec_commit		321
+#define __NR_ec_send		322
+#define __NR_ec_init		323
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 324
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/asm-x86_64/unistd.h b/include/asm-x86_64/unistd.h
index c5f596e..8922da3 100644
--- a/include/asm-x86_64/unistd.h
+++ b/include/asm-x86_64/unistd.h
@@ -619,8 +619,16 @@ #define __NR_vmsplice		278
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
-
-#define __NR_syscall_max __NR_move_pages
+#define __NR_ec_wait		280
+__SYSCALL(__NR_ec_wait, sys_ec_wait)
+#define __NR_ec_commit		281
+__SYSCALL(__NR_ec_commit, sys_ec_commit)
+#define __NR_ec_send		282
+__SYSCALL(__NR_ec_send, sys_ec_send)
+#define __NR_ec_init		283
+__SYSCALL(__NR_ec_init, sys_ec_init)
+
+#define __NR_syscall_max __NR_ec_init
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/linux/eventchannel.h b/include/linux/eventchannel.h
new file mode 100644
index 0000000..e67b707
--- /dev/null
+++ b/include/linux/eventchannel.h
@@ -0,0 +1,36 @@
+#ifndef __EVENTCHANNEL_H
+#define __EVENTCHANNEL_H
+
+struct ec_ring_info {
+	struct mutex ring_lock;
+	unsigned int kidx, uidx, full, ring_size, ring_over;
+	struct ec_ring __user *pring;
+
+	wait_queue_head_t *wq;
+	int *nr_ready_event;
+};
+
+struct ec_info {
+	struct ec_ring_info kuring, ukring;
+};
+
+struct ec_operations {
+	int (*ec_init)(struct file *, struct ec_ring *, struct ec_ring *,
+		       unsigned int, unsigned int);
+	struct ec_info *(*file_to_ecinfo)(struct file *);
+	int (*prepare_send_event_to_user)(struct file *);
+	int (*send_event_to_user)(struct file *, char *);
+	int (*prepare_recv_event_from_user)(struct file *);
+	int (*recv_event_from_user)(struct file *, char *);
+};
+
+extern struct ec_info *
+ec_info_alloc(struct ec_ring __user *kupring, wait_queue_head_t *kuwq,
+	      int *nr_kuevent, struct ec_ring __user *ukpring,
+	      wait_queue_head_t *ukwq, int *nr_ukevent,
+	      unsigned int num, unsigned int flags);
+extern void ec_info_free(struct ec_info *eci);
+extern int ec_register(int type, int event_size, struct ec_operations *ec_op,
+		       struct file_operations *f_op);
+
+#endif
diff --git a/include/linux/eventchannel_if.h b/include/linux/eventchannel_if.h
new file mode 100644
index 0000000..ea00a18
--- /dev/null
+++ b/include/linux/eventchannel_if.h
@@ -0,0 +1,15 @@
+#ifndef __EVENTCHANNEL_IF_H
+#define __EVENTCHANNEL_IF_H
+
+#define EC_TYPE_BSG		0
+#define EC_TYPE_SCSI_TGT	1
+#define EC_TYPE_KEVENT		2
+#define EC_TYPE_MAX		EC_TYPE_KEVENT
+
+struct ec_ring {
+	unsigned int ring_kidx;
+	unsigned int ring_over;
+	unsigned long event[0];
+};
+
+#endif
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1912c6c..15567c3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -605,4 +605,9 @@ asmlinkage long sys_getcpu(unsigned __us
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage long sys_ec_wait(int efd, unsigned int num, unsigned int old_uidx,
+			    struct timespec __user *ts, struct siginfo __user *si,
+			    unsigned int flags);
+asmlinkage long sys_ec_commit(int efd, unsigned int new_uidx, unsigned int over);
+asmlinkage long sys_ec_send(int efd, unsigned int num, unsigned int over);
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index a3f83e2..cdddb18 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -437,6 +437,13 @@ config EPOLL
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.
 
+config EVENT_CHANNEL
+	bool "Enable event channel support"
+	default y
+	help
+	  Disabling this option will cause the kernel to be built without
+	  support for event channel family of system calls.
+
 config SHMEM
 	bool "Use full shmem filesystem" if EMBEDDED
 	default y
diff --git a/kernel/Makefile b/kernel/Makefile
index 14f4d45..ed577c5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_EVENT_CHANNEL) += eventchannel.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/eventchannel.c b/kernel/eventchannel.c
new file mode 100644
index 0000000..33f5741
--- /dev/null
+++ b/kernel/eventchannel.c
@@ -0,0 +1,387 @@
+/*
+ * Event Channel functions
+ *
+ * 2006 Copyright (c) Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ *
+ * Copyright (C) 2007 FUJITA Tomonori <tomof@acm.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/sched.h>
+#include <linux/eventchannel.h>
+#include <linux/eventchannel_if.h>
+#include <asm/uaccess.h>
+
+#undef EC_DEBUG
+
+#ifdef EC_DEBUG
+#define dprintk(fmt, args...) printk(KERN_ERR "%s %d: " fmt, __FUNCTION__, __LINE__, ##args)
+#else
+#define dprintk(fmt, args...)
+#endif
+
+struct ec_type_table {
+	int event_size;
+	struct ec_operations *ec_op;
+	struct file_operations *f_op;
+};
+
+struct ec_type_table ec_table[EC_TYPE_MAX];
+
+static int ec_ring_space(struct ec_ring_info *ri,
+			    unsigned int fore, unsigned int rear)
+{
+	if (ri->full)
+		return 0;
+
+	return (rear > fore) ?
+		rear - fore : ri->ring_size - (fore - rear);
+}
+
+static void ec_ring_idx_inc(unsigned int *idx, unsigned int size)
+{
+	if (++*idx >= size)
+		*idx = 0;
+}
+
+static struct file *ec_fget(int efd, int *type)
+{
+	int i;
+	struct file *file;
+
+	file = fget(efd);
+	if (!file)
+		return NULL;
+
+	for (i = 0; i <= EC_TYPE_MAX; i++) {
+		if (file->f_op == ec_table[i].f_op) {
+			*type = i;
+			return file;
+		}
+	}
+
+	dprintk("this descriptor is not event channel\n");
+	fput(file);
+	return NULL;
+}
+
+/* TODO: absolute timeout, signal, etc */
+asmlinkage long
+sys_ec_wait(int efd, unsigned int num, unsigned int old_uidx,
+	    struct timespec __user *ts, struct siginfo __user *si,
+	    unsigned int flags)
+{
+	int ret, count, type;
+	long timeout = MAX_SCHEDULE_TIMEOUT;
+	struct timespec t;
+	struct file *file;
+	struct ec_info *eci;
+	struct ec_ring_info *ri;
+	struct ec_operations *ec_op;
+
+	file = ec_fget(efd, &type);
+	if (!file)
+		return -EBADF;
+
+	ec_op = ec_table[type].ec_op;
+	eci = ec_op->file_to_ecinfo(file);
+	if (!eci) {
+		fput(file);
+		return -EINVAL;
+	}
+
+	ri = &eci->kuring;
+
+	if (ts) {
+		if (copy_from_user(&t, ts, sizeof(t))) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (!timespec_valid(&t)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		timeout = timespec_to_jiffies(&t);
+		ret = wait_event_interruptible_timeout(*ri->wq,
+						       (*ri->nr_ready_event &&
+							ec_ring_space(ri, ri->kidx, ri->uidx)),
+						       timeout);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (ec_op->prepare_send_event_to_user)
+		ec_op->prepare_send_event_to_user(file);
+
+	for (count = 0; count < num; count++) {
+		void *buf;
+
+		mutex_lock(&ri->ring_lock);
+
+		dprintk("%d %d %u %u\n", count, num, ri->kidx, ri->uidx);
+
+		ret = ec_ring_space(ri, ri->kidx, ri->uidx);
+		if (!ret) {
+			mutex_unlock(&ri->ring_lock);
+			break;
+		}
+
+		buf = ri->pring->event +
+			ri->kidx * ec_table[type].event_size;
+
+		ret = ec_op->send_event_to_user(file, buf);
+		if (ret) {
+			mutex_unlock(&ri->ring_lock);
+			break;
+		}
+
+		if (++ri->kidx == ri->ring_size)
+			ri->kidx = 0;
+
+		if (ri->kidx == ri->uidx)
+			ri->full = 1;
+
+		dprintk("%u %u %u\n", ri->kidx, ri->uidx, ri->full);
+
+		if (put_user(ri->kidx, &ri->pring->ring_kidx)) {
+			mutex_unlock(&ri->ring_lock);
+			ret = -EFAULT;
+			goto out;
+		}
+
+		mutex_unlock(&ri->ring_lock);
+	}
+	ret = count;
+out:
+	fput(file);
+	return ret;
+}
+
+asmlinkage long
+sys_ec_commit(int efd, unsigned int new_uidx, unsigned int over)
+{
+	int type, ret = -EINVAL;
+	struct file *file;
+	struct ec_info *eci;
+	struct ec_ring_info *ri;
+
+	file = ec_fget(efd, &type);
+	if (!file)
+		return -EBADF;
+
+	eci = ec_table[type].ec_op->file_to_ecinfo(file);
+	if (!eci) {
+		fput(file);
+		return -EINVAL;
+	}
+
+	ri = &eci->kuring;
+
+	mutex_lock(&ri->ring_lock);
+
+	dprintk("%u %u %u\n", new_uidx, ri->kidx, ri->uidx);
+
+	if (new_uidx >= ri->ring_size)
+		goto out;
+
+	if ((over != ri->ring_over - 1) && (over != ri->ring_over))
+		goto out;
+
+	if (ri->uidx < ri->kidx && ri->kidx < new_uidx)
+		goto out;
+
+	if (new_uidx > ri->uidx) {
+		if (over != ri->ring_over)
+			goto out;
+
+		ret = new_uidx - ri->uidx;
+		ri->uidx = new_uidx;
+		ri->full = 0;
+	} else if (new_uidx < ri->uidx) {
+		ret = ri->ring_size - (ri->uidx - new_uidx);
+		ri->uidx = new_uidx;
+		ri->ring_over++;
+		ri->full = 0;
+
+		if (put_user(ri->ring_over, &ri->pring->ring_over)) {
+			ret = -EFAULT;
+			goto out;
+		}
+	} else
+		ret = 0;
+
+out:
+	mutex_unlock(&ri->ring_lock);
+
+	fput(file);
+	return ret;
+}
+
+asmlinkage long
+sys_ec_send(int efd, unsigned int num, unsigned int over)
+{
+	int type, ret = -EINVAL, i;
+	struct file *file;
+	struct ec_info *eci;
+	struct ec_ring_info *ri;
+	struct ec_operations *ec_op;
+
+	file = ec_fget(efd, &type);
+	if (!file)
+		return -EBADF;
+
+	ec_op = ec_table[type].ec_op;
+	eci = ec_op->file_to_ecinfo(file);
+	if (!eci) {
+		fput(file);
+		return -EINVAL;
+	}
+
+	ri = &eci->ukring;
+
+	if (ec_op->prepare_recv_event_from_user)
+		ec_op->prepare_recv_event_from_user(file);
+
+	mutex_lock(&ri->ring_lock);
+
+	if (num > ri->ring_size)
+		goto out;
+
+	ret = ec_ring_space(ri, ri->uidx, ri->kidx);
+	if (!ret)
+		goto out;
+
+	if (num >= ret) {
+		num = ret;
+		ri->full = 1;
+	}
+
+	/*
+	 * TODO: kernel threads can work for some people (not bsg now)
+	 * However, we need poll for ukring for it.
+	 */
+
+	for (i = 0; i < num; i++) {
+		char *buf = (char *) ri->pring->event +
+			ri->kidx * ec_table[type].event_size;
+
+		dprintk("%u %u %u\n", num, ri->kidx, ri->uidx);
+		ret = ec_op->recv_event_from_user(file, buf);
+		if (ret)
+			break;
+		ec_ring_idx_inc(&ri->kidx, ri->ring_size);
+	}
+	ret = i;
+	ri->full = 0;
+
+	if (put_user(ri->kidx, &ri->pring->ring_kidx))
+		ret = -EFAULT;
+
+out:
+	mutex_unlock(&ri->ring_lock);
+
+	fput(file);
+	return ret;
+}
+
+static void ec_ring_init(struct ec_ring_info *ri, int num,
+			 struct ec_ring __user *pring, wait_queue_head_t *wq,
+			 int *nr_event)
+{
+	ri->wq = wq;
+	ri->nr_ready_event = nr_event;
+	mutex_init(&ri->ring_lock);
+	ri->ring_size = num;
+	ri->pring = pring;
+}
+
+struct ec_info *
+ec_info_alloc(struct ec_ring __user *kupring, wait_queue_head_t *kuwq,
+	      int *nr_kuevent, struct ec_ring __user *ukpring,
+	      wait_queue_head_t *ukwq, int *nr_ukevent,
+	      unsigned int num, unsigned int flags)
+{
+	struct ec_info *eci;
+
+	eci = kzalloc(sizeof(*eci), GFP_KERNEL);
+	if (!eci)
+		return NULL;
+
+	ec_ring_init(&eci->kuring, num, kupring, kuwq, nr_kuevent);
+	ec_ring_init(&eci->ukring, num, ukpring, ukwq, nr_ukevent);
+
+	return eci;
+}
+EXPORT_SYMBOL_GPL(ec_info_alloc);
+
+void ec_info_free(struct ec_info *eci)
+{
+	kfree(eci);
+}
+EXPORT_SYMBOL_GPL(ec_info_free);
+
+asmlinkage long
+sys_ec_init(int efd, int type, struct ec_ring __user *kupring,
+	    struct ec_ring __user *ukpring, unsigned int num, unsigned int flags)
+{
+	int ret;
+	struct file *file;
+
+	if (type > EC_TYPE_MAX)
+		return -EINVAL;
+
+	file = fget(efd);
+	if (!file)
+		return -EBADF;
+
+	ret = ec_table[type].ec_op->ec_init(file, kupring, ukpring, num, flags);
+
+	dprintk("%d %p %p %d\n", type, kupring, ukpring, num);
+
+	fput(file);
+
+	return ret;
+}
+
+int ec_register(int type, int event_size, struct ec_operations *ec_op,
+		struct file_operations *f_op)
+{
+	if (type > EC_TYPE_MAX)
+		return 1;
+
+	if (!ec_op || !f_op)
+		return 1;
+
+	if (ec_table[EC_TYPE_MAX].ec_op)
+		return 1;
+
+	ec_table[type].ec_op = ec_op;
+	ec_table[type].f_op = f_op;
+	ec_table[type].event_size = event_size;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ec_register);
-- 
1.4.3.2

