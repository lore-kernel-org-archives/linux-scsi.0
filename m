From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH 2.6 ] MPT Fusion driver 3.01.07 update
Date: Mon, 24 May 2004 19:25:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57047960FA@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C441E6.65C2DF50"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:59622 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263939AbUEXXdf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 May 2004 19:33:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, hch@infradead.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C441E6.65C2DF50
Content-Type: text/plain;
	charset="iso-8859-1"

This is an update for the MPT Fusion drivers 2.6 kernel.

This is mpt version is 3.01.07  The attached patch is made
against 3.01.06 driver.

Changelog: Clean up backword compatibility with 2.4 kernel and older. Patch
provided by Christoph Hellwig<hch@lst.de,hch@infradead.org>


You can download full source as well as the patches for this 
driver at:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.01.07

Eric Moore
Staff Engineer
Standard Storage Products Division
LSI Logic Corporation
4420 Arrowswest Drive
Colorado Springs, CO 80907
Email: emoore@lsil.com
Web: http://www.lsilogic.com/




------_=_NextPart_000_01C441E6.65C2DF50
Content-Type: application/octet-stream;
	name="mptlinux-3.01.07.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.01.07.patch"

diff -uarN b/drivers/message/fusion/isense.c =
a/drivers/message/fusion/isense.c=0A=
--- b/drivers/message/fusion/isense.c	2004-05-17 16:04:00.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/isense.c	2004-05-17 16:04:13.000000000 =
-0600=0A=
@@ -56,14 +56,6 @@=0A=
 #include <linux/errno.h>=0A=
 #include <linux/init.h>=0A=
 #include <asm/io.h>=0A=
-#if defined (__sparc__)=0A=
-#include <linux/timer.h>=0A=
-#endif=0A=
-=0A=
-/* Hmmm, avoid undefined spinlock_t on lk-2.2.14-5.0 */=0A=
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0)=0A=
-#include <asm/spinlock.h>=0A=
-#endif=0A=
 =0A=
 #define MODULEAUTHOR "Steven J. Ralston"=0A=
 #define COPYRIGHT "Copyright (c) 2001-2004 " MODULEAUTHOR=0A=
diff -uarN b/drivers/message/fusion/linux_compat.h =
a/drivers/message/fusion/linux_compat.h=0A=
--- b/drivers/message/fusion/linux_compat.h	2004-05-17 =
16:04:00.000000000 -0600=0A=
+++ a/drivers/message/fusion/linux_compat.h	2004-05-17 =
16:11:17.000000000 -0600=0A=
@@ -2,196 +2,7 @@=0A=
 =0A=
 #ifndef FUSION_LINUX_COMPAT_H=0A=
 #define FUSION_LINUX_COMPAT_H=0A=
-/*{-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 =0A=
-#include <linux/version.h>=0A=
-#include <linux/config.h>=0A=
-#include <linux/kernel.h>=0A=
-#include <linux/pci.h>=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-=0A=
-#ifndef rwlock_init=0A=
-#define rwlock_init(x) do { *(x) =3D RW_LOCK_UNLOCKED; } while(0)=0A=
-#endif=0A=
-=0A=
-#define SET_NICE(current,x) do {(current)->nice =3D (x);} while (0)=0A=
-=0A=
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0)=0A=
-#	if LINUX_VERSION_CODE < KERNEL_VERSION(2,2,18)=0A=
-		typedef unsigned int dma_addr_t;=0A=
-#	endif=0A=
-#else=0A=
-#	if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,42)=0A=
-		typedef unsigned int dma_addr_t;=0A=
-#	endif=0A=
-#endif=0A=
-=0A=
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,2,18)=0A=
-/*{-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-=0A=
-/* This block snipped from lk-2.2.18/include/linux/init.h { */=0A=
-/*=0A=
- * Used for initialization calls..=0A=
- */=0A=
-typedef int (*initcall_t)(void);=0A=
-typedef void (*exitcall_t)(void);=0A=
-=0A=
-#define __init_call	__attribute__ ((unused,__section__ =
(".initcall.init")))=0A=
-#define __exit_call	__attribute__ ((unused,__section__ =
(".exitcall.exit")))=0A=
-=0A=
-extern initcall_t __initcall_start, __initcall_end;=0A=
-=0A=
-#define __initcall(fn)								\=0A=
-	static initcall_t __initcall_##fn __init_call =3D fn=0A=
-#define __exitcall(fn)								\=0A=
-	static exitcall_t __exitcall_##fn __exit_call =3D fn=0A=
-=0A=
-#ifdef MODULE=0A=
-/* These macros create a dummy inline: gcc 2.9x does not count =
alias=0A=
- as usage, hence the `unused function' warning when __init =
functions=0A=
- are declared static. We use the dummy __*_module_inline functions=0A=
- both to kill the warning and check the type of the init/cleanup=0A=
- function. */=0A=
-typedef int (*__init_module_func_t)(void);=0A=
-typedef void (*__cleanup_module_func_t)(void);=0A=
-#define module_init(x) \=0A=
-	int init_module(void) __attribute__((alias(#x))); \=0A=
-	static inline __init_module_func_t __init_module_inline(void) \=0A=
-	{ return x; }=0A=
-#define module_exit(x) \=0A=
-	void cleanup_module(void) __attribute__((alias(#x))); \=0A=
-	static inline __cleanup_module_func_t __cleanup_module_inline(void) =
\=0A=
-	{ return x; }=0A=
-=0A=
-#else=0A=
-#define module_init(x)	__initcall(x);=0A=
-#define module_exit(x)	__exitcall(x);=0A=
-#endif=0A=
-/* } block snipped from lk-2.2.18/include/linux/init.h */=0A=
-=0A=
-/* This block snipped from lk-2.2.18/include/linux/sched.h { */=0A=
-/*=0A=
- * Used prior to schedule_timeout calls..=0A=
- */=0A=
-#define __set_current_state(state_value)	do { current->state =3D =
state_value; } while (0)=0A=
-#ifdef CONFIG_SMP=0A=
-#define set_current_state(state_value)		do { =
__set_current_state(state_value); mb(); } while (0)=0A=
-#else=0A=
-#define set_current_state(state_value)		=
__set_current_state(state_value)=0A=
-#endif=0A=
-/* } block snipped from lk-2.2.18/include/linux/sched.h */=0A=
-=0A=
-/* procfs compat stuff... */=0A=
-#define proc_mkdir(x,y)			create_proc_entry(x, S_IFDIR, y)=0A=
-=0A=
-/* MUTEX compat stuff... */=0A=
-#define DECLARE_MUTEX(name)		struct semaphore name=3DMUTEX=0A=
-#define DECLARE_MUTEX_LOCKED(name)	struct semaphore =
name=3DMUTEX_LOCKED=0A=
-#define init_MUTEX(x)			*(x)=3DMUTEX=0A=
-#define init_MUTEX_LOCKED(x)		*(x)=3DMUTEX_LOCKED=0A=
-=0A=
-/* Wait queues. */=0A=
-#define DECLARE_WAIT_QUEUE_HEAD(name)	\=0A=
-	struct wait_queue * (name) =3D NULL=0A=
-#define DECLARE_WAITQUEUE(name, task)	\=0A=
-	struct wait_queue (name) =3D { (task), NULL }=0A=
-=0A=
-#if defined(__sparc__) && defined(__sparc_v9__)=0A=
-/* The sparc64 ioremap implementation is wrong in 2.2.x,=0A=
- * but fixing it would break all of the drivers which=0A=
- * workaround it.  Fixed in 2.3.x onward. -DaveM=0A=
- */=0A=
-#define ARCH_IOREMAP(base)	((unsigned long) (base))=0A=
-#else=0A=
-#define ARCH_IOREMAP(base)	ioremap(base)=0A=
-#endif=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D*/=0A=
-#else		/* LINUX_VERSION_CODE must be >=3D KERNEL_VERSION(2,2,18) */=0A=
-=0A=
-/* No ioremap bugs in >2.3.x kernels. */=0A=
-#define ARCH_IOREMAP(base)	ioremap(base)=0A=
-=0A=
-/*}-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-#endif		/* LINUX_VERSION_CODE < KERNEL_VERSION(2,2,18) */=0A=
-=0A=
-=0A=
-/*=0A=
- * Inclined to use:=0A=
- *   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,10)=0A=
- * here, but MODULE_LICENSE defined in 2.4.9-6 and 2.4.9-13=0A=
- * breaks the rule:-(=0A=
- */=0A=
-#ifndef MODULE_LICENSE=0A=
-#define MODULE_LICENSE(license)=0A=
-#endif=0A=
-=0A=
-=0A=
-/* PCI/driver subsystem { */=0A=
-#define PCI_BASEADDR_FLAGS(idx)         resource[idx].flags=0A=
-#define PCI_BASEADDR_START(idx)         resource[idx].start=0A=
-#define PCI_BASEADDR_SIZE(dev,idx)      (dev)->resource[idx].end - =
(dev)->resource[idx].start + 1=0A=
-=0A=
-/* Compatability for the 2.3.x PCI DMA API. */=0A=
-#ifndef PCI_DMA_BIDIRECTIONAL=0A=
-/*{-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D*/=0A=
-=0A=
-#define PCI_DMA_BIDIRECTIONAL	0=0A=
-#define PCI_DMA_TODEVICE	1=0A=
-#define PCI_DMA_FROMDEVICE	2=0A=
-#define PCI_DMA_NONE		3=0A=
-=0A=
-#ifdef __KERNEL__=0A=
-#include <asm/page.h>=0A=
-/* Pure 2^n version of get_order */=0A=
-static __inline__ int __get_order(unsigned long size)=0A=
-{=0A=
-	int order;=0A=
-=0A=
-	size =3D (size-1) >> (PAGE_SHIFT-1);=0A=
-	order =3D -1;=0A=
-	do {=0A=
-		size >>=3D 1;=0A=
-		order++;=0A=
-	} while (size);=0A=
-	return order;=0A=
-}=0A=
-#endif=0A=
-=0A=
-#define pci_alloc_consistent(hwdev, size, dma_handle) \=0A=
-({	void *__ret =3D (void *)__get_free_pages(GFP_ATOMIC, =
__get_order(size)); \=0A=
-	if (__ret !=3D NULL) { \=0A=
-		memset(__ret, 0, size); \=0A=
-		*(dma_handle) =3D virt_to_bus(__ret); \=0A=
-	} \=0A=
-	__ret; \=0A=
-})=0A=
-=0A=
-#define pci_free_consistent(hwdev, size, vaddr, dma_handle) \=0A=
-	free_pages((unsigned long)vaddr, __get_order(size))=0A=
-=0A=
-#define pci_map_single(hwdev, ptr, size, direction) \=0A=
-	virt_to_bus(ptr);=0A=
-=0A=
-#define pci_unmap_single(hwdev, dma_addr, size, direction) \=0A=
-	do { /* Nothing to do */ } while (0)=0A=
-=0A=
-#define pci_map_sg(hwdev, sg, nents, direction)	(nents)=0A=
-#define pci_unmap_sg(hwdev, sg, nents, direction) \=0A=
-	do { /* Nothing to do */ } while(0)=0A=
-=0A=
-#define sg_dma_address(sg)	(virt_to_bus((sg)->address))=0A=
-#define sg_dma_len(sg)		((sg)->length)=0A=
-=0A=
-/*}-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D*/=0A=
-#endif /* PCI_DMA_BIDIRECTIONAL */=0A=
-=0A=
-=0A=
-#define mpt_work_struct work_struct=0A=
-#define MPT_INIT_WORK(_task, _func, _data) INIT_WORK(_task, _func, =
_data)=0A=
-#define mpt_sync_irq(_irq) synchronize_irq(_irq)=0A=
 =0A=
 =
/*}-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D*/=0A=
 #endif /* _LINUX_COMPAT_H */=0A=
-=0A=
diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2004-05-17 16:04:00.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2004-05-24 09:29:39.000000000 =
-0600=0A=
@@ -1311,14 +1311,14 @@=0A=
 	mem_phys =3D msize =3D 0;=0A=
 	port =3D psize =3D 0;=0A=
 	for (ii=3D0; ii < DEVICE_COUNT_RESOURCE; ii++) {=0A=
-		if (pdev->PCI_BASEADDR_FLAGS(ii) & PCI_BASE_ADDRESS_SPACE_IO) {=0A=
+		if (pci_resource_flags(pdev, ii) & PCI_BASE_ADDRESS_SPACE_IO) {=0A=
 			/* Get I/O space! */=0A=
-			port =3D pdev->PCI_BASEADDR_START(ii);=0A=
-			psize =3D PCI_BASEADDR_SIZE(pdev,ii);=0A=
+			port =3D pci_resource_start(pdev, ii);=0A=
+			psize =3D pci_resource_len(pdev,ii);=0A=
 		} else {=0A=
 			/* Get memmap */=0A=
-			mem_phys =3D pdev->PCI_BASEADDR_START(ii);=0A=
-			msize =3D PCI_BASEADDR_SIZE(pdev,ii);=0A=
+			mem_phys =3D pci_resource_start(pdev, ii);=0A=
+			msize =3D pci_resource_len(pdev,ii);=0A=
 			break;=0A=
 		}=0A=
 	}=0A=
@@ -1524,7 +1524,7 @@=0A=
 	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);=0A=
 =0A=
 	ioc->active =3D 0;=0A=
-	mpt_sync_irq(pdev->irq);=0A=
+	synchronize_irq(pdev->irq);=0A=
 =0A=
 	/* Clear any lingering interrupt */=0A=
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);=0A=
@@ -3799,7 +3799,8 @@=0A=
 =0A=
 		/*  Prime reply FIFO...  */=0A=
 		dprintk((KERN_INFO MYNAM ": %s.reply_alloc  @ %p[%p], sz=3D%d =
bytes\n",=0A=
-			 	ioc->name, mem, (void *)(ulong)ioc->reply_alloc_dma, =
reply_buffer_sz));=0A=
+			ioc->name, ioc->reply_alloc, =0A=
+			(void *)(ulong)ioc->reply_alloc_dma, reply_buffer_sz));=0A=
 =0A=
 		b =3D (unsigned long) ioc->reply_alloc;=0A=
 		b =3D (b + (0x80UL - 1UL)) & ~(0x80UL - 1UL); /* round up to =
128-byte boundary */=0A=
@@ -3812,7 +3813,8 @@=0A=
 	=0A=
 		/*  Request FIFO - WE manage this!  */=0A=
 		dprintk((KERN_INFO MYNAM ": %s.req_alloc    @ %p[%p], sz=3D%d =
bytes\n",=0A=
-			 	ioc->name, mem, (void *)(ulong)ioc->req_alloc_dma, =
request_buffer_sz));=0A=
+			ioc->name, ioc->req_alloc,=0A=
+			(void *)(ulong)ioc->req_alloc_dma, request_buffer_sz));=0A=
 =0A=
 		b =3D (unsigned long) ioc->req_alloc;=0A=
 		b =3D (b + (0x80UL - 1UL)) & ~(0x80UL - 1UL); /* round up to =
128-byte boundary */=0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2004-05-17 16:04:00.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2004-05-17 16:11:41.000000000 =
-0600=0A=
@@ -55,7 +55,11 @@=0A=
 #define MPTBASE_H_INCLUDED=0A=
 =
/*{-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D*/=0A=
 =0A=
-#include "linux_compat.h"	/* linux-2.2.x (vs. -2.4.x) tweaks */=0A=
+#include <linux/version.h>=0A=
+#include <linux/config.h>=0A=
+#include <linux/kernel.h>=0A=
+#include <linux/pci.h>=0A=
+=0A=
 #include "scsi3.h"		/* SCSI defines */=0A=
 =0A=
 #include "lsi/mpi_type.h"=0A=
@@ -81,8 +85,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.01.06"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.06"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.01.07"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.07"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
diff -uarN b/drivers/message/fusion/mptctl.c =
a/drivers/message/fusion/mptctl.c=0A=
--- b/drivers/message/fusion/mptctl.c	2004-05-17 16:04:00.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptctl.c	2004-05-17 16:04:13.000000000 =
-0600=0A=
@@ -102,9 +102,6 @@=0A=
 #define my_VERSION	MPT_LINUX_VERSION_COMMON=0A=
 #define MYNAM		"mptctl"=0A=
 =0A=
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,62)=0A=
-EXPORT_NO_SYMBOLS;=0A=
-#endif=0A=
 MODULE_AUTHOR(MODULEAUTHOR);=0A=
 MODULE_DESCRIPTION(my_NAME);=0A=
 MODULE_LICENSE("GPL");=0A=
@@ -547,38 +544,6 @@=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
- *  struct file_operations functionality.=0A=
- *  Members:=0A=
- *	llseek, write, read, ioctl, open, release=0A=
- */=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,9)=0A=
-static loff_t=0A=
-mptctl_llseek(struct file *file, loff_t offset, int origin)=0A=
-{=0A=
-	return -ESPIPE;=0A=
-}=0A=
-#define no_llseek mptctl_llseek=0A=
-#endif=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-static ssize_t=0A=
-mptctl_write(struct file *file, const char *buf, size_t count, loff_t =
*ppos)=0A=
-{=0A=
-	printk(KERN_ERR MYNAM ": ioctl WRITE not yet supported\n");=0A=
-	return 0;=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-static ssize_t=0A=
-mptctl_read(struct file *file, char *buf, size_t count, loff_t =
*ptr)=0A=
-{=0A=
-	printk(KERN_ERR MYNAM ": ioctl READ not yet supported\n");=0A=
-	return 0;=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/*=0A=
  *  MPT ioctl handler=0A=
  *  cmd - specify the particular IOCTL command to be issued=0A=
  *  arg - data specific to the command. Must not be null.=0A=
@@ -700,21 +665,6 @@=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-static int mptctl_open(struct inode *inode, struct file *file)=0A=
-{=0A=
-	/*=0A=
-	 * Should support multiple management users=0A=
-	 */=0A=
-	return 0;=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-static int mptctl_release(struct inode *inode, struct file *file)=0A=
-{=0A=
-	return 0;=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  * MPT FW download function.  Cast the arg into the mpt_fw_xfer =
structure.=0A=
  * This structure contains: iocnum, firmware length (bytes),=0A=
@@ -1278,10 +1228,8 @@=0A=
 	karg->pciId =3D pdev->device;=0A=
 	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);=0A=
 	karg->hwRev =3D revision;=0A=
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,0)=0A=
 	karg->subSystemDevice =3D pdev->subsystem_device;=0A=
 	karg->subSystemVendor =3D pdev->subsystem_vendor;=0A=
-#endif=0A=
 =0A=
 	if (cim_rev =3D=3D 1) {=0A=
 		/* Get the PCI bus, device, and function numbers for the IOC=0A=
@@ -2455,10 +2403,8 @@=0A=
 =0A=
 	karg.vendor =3D pdev->vendor;=0A=
 	karg.device =3D pdev->device;=0A=
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,0)=0A=
 	karg.subsystem_id =3D pdev->subsystem_device;=0A=
 	karg.subsystem_vendor =3D pdev->subsystem_vendor;=0A=
-#endif=0A=
 	karg.devfn =3D pdev->devfn;=0A=
 	karg.bus =3D pdev->bus->number;=0A=
 =0A=
@@ -2540,7 +2486,7 @@=0A=
 		break;=0A=
 	}=0A=
 =0A=
-	karg.base_io_addr =3D pdev->PCI_BASEADDR_START(0);=0A=
+	karg.base_io_addr =3D pci_resource_start(pdev, 0);=0A=
 =0A=
 	if ((int)ioc->chip_type <=3D (int) FC929)=0A=
 		karg.bus_phys_width =3D HP_BUS_WIDTH_UNK;=0A=
@@ -2739,20 +2685,10 @@=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 =0A=
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,3,51)=0A=
-#define	owner_THIS_MODULE  .owner =3D THIS_MODULE,=0A=
-#else=0A=
-#define	owner_THIS_MODULE=0A=
-#endif=0A=
-=0A=
 static struct file_operations mptctl_fops =3D {=0A=
-	owner_THIS_MODULE=0A=
+	.owner =3D	THIS_MODULE,=0A=
 	.llseek =3D	no_llseek,=0A=
-	.read =3D		mptctl_read,=0A=
-	.write =3D	mptctl_write,=0A=
 	.ioctl =3D	mptctl_ioctl,=0A=
-	.open =3D		mptctl_open,=0A=
-	.release =3D	mptctl_release,=0A=
 };=0A=
 =0A=
 static struct miscdevice mptctl_miscdev =3D {=0A=
diff -uarN b/drivers/message/fusion/mptlan.c =
a/drivers/message/fusion/mptlan.c=0A=
--- b/drivers/message/fusion/mptlan.c	2004-05-17 16:04:00.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptlan.c	2004-05-17 16:04:13.000000000 =
-0600=0A=
@@ -133,7 +133,7 @@=0A=
 	u32 total_received;=0A=
 	struct net_device_stats stats;	/* Per device statistics */=0A=
 =0A=
-	struct mpt_work_struct post_buckets_task;=0A=
+	struct work_struct post_buckets_task;=0A=
 	unsigned long post_buckets_active;=0A=
 };=0A=
 =0A=
@@ -880,18 +880,9 @@=0A=
 	=0A=
 	if (test_and_set_bit(0, &priv->post_buckets_active) =3D=3D 0) {=0A=
 		if (priority) {=0A=
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,5,41)=0A=
 			schedule_work(&priv->post_buckets_task);=0A=
-#else=0A=
-			queue_task(&priv->post_buckets_task, &tq_immediate);=0A=
-			mark_bh(IMMEDIATE_BH);=0A=
-#endif=0A=
 		} else {=0A=
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,5,41)=0A=
 			schedule_delayed_work(&priv->post_buckets_task, 1);=0A=
-#else=0A=
-			queue_task(&priv->post_buckets_task, &tq_timer);=0A=
-#endif=0A=
 			dioprintk((KERN_INFO MYNAM ": post_buckets queued on "=0A=
 				   "timer.\n"));=0A=
 		}=0A=
@@ -1391,8 +1382,8 @@=0A=
 	priv->mpt_dev =3D mpt_dev;=0A=
 	priv->pnum =3D pnum;=0A=
 =0A=
-	memset(&priv->post_buckets_task, 0, sizeof(struct =
mpt_work_struct));=0A=
-	MPT_INIT_WORK(&priv->post_buckets_task, mpt_lan_post_receive_buckets, =
dev);=0A=
+	memset(&priv->post_buckets_task, 0, sizeof(struct work_struct));=0A=
+	INIT_WORK(&priv->post_buckets_task, mpt_lan_post_receive_buckets, =
dev);=0A=
 	priv->post_buckets_active =3D 0;=0A=
 =0A=
 	dlprintk((KERN_INFO MYNAM "@%d: bucketlen =3D %d\n",=0A=
@@ -1566,10 +1557,6 @@=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,59)=0A=
-MODULE_PARM(tx_max_out_p, "i");=0A=
-MODULE_PARM(max_buckets_out, "i"); // Debug stuff. FIXME!=0A=
-#endif=0A=
 =0A=
 module_init(mpt_lan_init);=0A=
 module_exit(mpt_lan_exit);=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-05-17 16:04:00.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-05-24 09:36:29.000000000 =
-0600=0A=
@@ -74,6 +74,8 @@=0A=
 #include <linux/delay.h>	/* for mdelay */=0A=
 #include <linux/interrupt.h>	/* needed for in_interrupt() proto */=0A=
 #include <linux/reboot.h>	/* notifier code */=0A=
+#include <linux/sched.h>=0A=
+#include <linux/workqueue.h>=0A=
 #include "../../scsi/scsi.h"=0A=
 #include <scsi/scsi_host.h>=0A=
 =0A=
@@ -185,7 +187,7 @@=0A=
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);=0A=
 static int	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int =
portnum);=0A=
 =0A=
-static struct mpt_work_struct   mptscsih_rstTask;=0A=
+static struct work_struct   mptscsih_rstTask;=0A=
 =0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
 static int	mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD =
*io);=0A=
@@ -231,7 +233,7 @@=0A=
 static spinlock_t dvtaskQ_lock =3D SPIN_LOCK_UNLOCKED;=0A=
 static int dvtaskQ_active =3D 0;=0A=
 static int dvtaskQ_release =3D 0;=0A=
-static struct mpt_work_struct	mptscsih_dvTask;=0A=
+static struct work_struct	mptscsih_dvTask;=0A=
 #endif=0A=
 =0A=
 /*=0A=
@@ -249,31 +251,7 @@=0A=
 static Scsi_Cmnd *foo_to[8];=0A=
 #endif=0A=
 =0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-=0A=
-/* see mptscsih.h */=0A=
-=0A=
-static struct scsi_host_template driver_template =3D {=0A=
-	.proc_name			=3D "mptscsih",=0A=
-	.proc_info			=3D x_scsi_proc_info,=0A=
-	.name				=3D "MPT SCSI Host",=0A=
-	.info				=3D x_scsi_info,=0A=
-	.queuecommand			=3D x_scsi_queuecommand,=0A=
-	.slave_alloc			=3D x_scsi_slave_alloc,=0A=
-	.slave_configure		=3D x_scsi_slave_configure,=0A=
-	.slave_destroy			=3D x_scsi_slave_destroy,=0A=
-	.eh_abort_handler		=3D x_scsi_abort,=0A=
-	.eh_device_reset_handler	=3D x_scsi_dev_reset,=0A=
-	.eh_bus_reset_handler		=3D x_scsi_bus_reset,=0A=
-	.eh_host_reset_handler		=3D x_scsi_host_reset,=0A=
-	.bios_param			=3D x_scsi_bios_param,=0A=
-	.can_queue			=3D MPT_SCSI_CAN_QUEUE,=0A=
-	.this_id			=3D -1,=0A=
-	.sg_tablesize			=3D MPT_SCSI_SG_DEPTH,=0A=
-	.max_sectors			=3D MPT_SCSI_MAX_SECTORS,=0A=
-	.cmd_per_lun			=3D MPT_SCSI_CMD_PER_LUN,=0A=
-	.use_clustering			=3D ENABLE_CLUSTERING,=0A=
-};=0A=
+static struct scsi_host_template driver_template;=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -1459,7 +1437,6 @@=0A=
 	}=0A=
 		=0A=
 	sh->max_lun =3D MPT_LAST_LUN + 1;=0A=
-	sh->max_sectors =3D MPT_SCSI_MAX_SECTORS;=0A=
 	sh->max_channel =3D 0;=0A=
 	sh->this_id =3D ioc->pfacts[0].PortSCSIID;=0A=
 		=0A=
@@ -1800,8 +1777,8 @@=0A=
 		}=0A=
 =0A=
 		dprintk((MYIOC_s_INFO_FMT=0A=
-		  "Free'd ScsiLookup (%d), chain (%d) and Target (%d+%d) =
memory\n",=0A=
-		  hd->ioc->name, sz1, szchain, sz3, sztarget));=0A=
+		  "Free'd ScsiLookup (%d) Target (%d+%d) memory\n",=0A=
+		  hd->ioc->name, sz1, sz3, sztarget));=0A=
 		dprintk(("Free'd done and free Q (%d) memory\n", szQ));=0A=
 =0A=
 		/* NULL the Scsi_Host pointer=0A=
@@ -1879,9 +1856,9 @@=0A=
 	if (!dvtaskQ_active) {=0A=
 		dvtaskQ_active =3D 1;=0A=
 		spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
-		MPT_INIT_WORK(&mptscsih_dvTask,=0A=
+		INIT_WORK(&mptscsih_dvTask,=0A=
 		  mptscsih_domainValidation, (void *) hd);=0A=
-		SCHEDULE_TASK(&mptscsih_dvTask);=0A=
+		schedule_work(&mptscsih_dvTask);=0A=
 	} else {=0A=
 		spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
 	}=0A=
@@ -1902,7 +1879,6 @@=0A=
 #endif=0A=
 };=0A=
 =0A=
-=0A=
 /*  SCSI host fops start here...  */=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /**=0A=
@@ -2434,9 +2410,9 @@=0A=
 					if (!dvtaskQ_active) {=0A=
 						dvtaskQ_active =3D 1;=0A=
 						spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
-						MPT_INIT_WORK(&mptscsih_dvTask, mptscsih_domainValidation, (void =
*) hd);=0A=
+						INIT_WORK(&mptscsih_dvTask, mptscsih_domainValidation, (void *) =
hd);=0A=
 =0A=
-						SCHEDULE_TASK(&mptscsih_dvTask);=0A=
+						schedule_work(&mptscsih_dvTask);=0A=
 					} else {=0A=
 						spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
 					}=0A=
@@ -3905,6 +3881,29 @@=0A=
 	return 1;		/* currently means nothing really */=0A=
 }=0A=
 =0A=
+static struct scsi_host_template driver_template =3D {=0A=
+	.proc_name			=3D "mptscsih",=0A=
+	.proc_info			=3D mptscsih_proc_info,=0A=
+	.name				=3D "MPT SCSI Host",=0A=
+	.info				=3D mptscsih_info,=0A=
+	.queuecommand			=3D mptscsih_qcmd,=0A=
+	.slave_alloc			=3D mptscsih_slave_alloc,=0A=
+	.slave_configure		=3D mptscsih_slave_configure,=0A=
+	.slave_destroy			=3D mptscsih_slave_destroy,=0A=
+	.eh_abort_handler		=3D mptscsih_abort,=0A=
+	.eh_device_reset_handler	=3D mptscsih_dev_reset,=0A=
+	.eh_bus_reset_handler		=3D mptscsih_bus_reset,=0A=
+	.eh_host_reset_handler		=3D mptscsih_host_reset,=0A=
+	.bios_param			=3D mptscsih_bios_param,=0A=
+	.can_queue			=3D MPT_SCSI_CAN_QUEUE,=0A=
+	.this_id			=3D -1,=0A=
+	.sg_tablesize			=3D MPT_SCSI_SG_DEPTH,=0A=
+	.max_sectors			=3D 8192,=0A=
+	.cmd_per_lun			=3D 7,=0A=
+	.use_clustering			=3D ENABLE_CLUSTERING,=0A=
+};=0A=
+=0A=
+=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *  Private data...=0A=
@@ -4950,8 +4949,8 @@=0A=
 	/* Call the reset handler. Already had a TM request=0A=
 	 * timeout - so issue a diagnostic reset=0A=
 	 */=0A=
-	MPT_INIT_WORK(&mptscsih_rstTask, mptscsih_schedule_reset, (void =
*)hd);=0A=
-	SCHEDULE_TASK(&mptscsih_rstTask);=0A=
+	INIT_WORK(&mptscsih_rstTask, mptscsih_schedule_reset, (void *)hd);=0A=
+	schedule_work(&mptscsih_rstTask);=0A=
 	return;=0A=
 }=0A=
 =0A=
diff -uarN b/drivers/message/fusion/mptscsih.h =
a/drivers/message/fusion/mptscsih.h=0A=
--- b/drivers/message/fusion/mptscsih.h	2004-05-17 16:04:00.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.h	2004-05-17 16:04:13.000000000 =
-0600=0A=
@@ -108,75 +108,4 @@=0A=
         MPTSCSIH_SAF_TE,                        \=0A=
 }=0A=
 =0A=
-=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/*=0A=
- *	Various bits and pieces broke within the lk-2.4.0-testN =
series:-(=0A=
- *	So here are various HACKS to work around them.=0A=
- */=0A=
-=0A=
-/*=0A=
- *	tq_scheduler disappeared @ lk-2.4.0-test12=0A=
- *	(right when <linux/sched.h> newly defined TQ_ACTIVE)=0A=
- *	tq_struct reworked in 2.5.41. Include workqueue.h.=0A=
- */=0A=
-#	include <linux/sched.h>=0A=
-#	include <linux/workqueue.h>=0A=
-#define SCHEDULE_TASK(x)		\=0A=
-	if (schedule_work(x) =3D=3D 0) {	\=0A=
-		/*MOD_DEC_USE_COUNT*/;	\=0A=
-	}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-=0A=
-#define x_scsi_info		mptscsih_info=0A=
-#define x_scsi_queuecommand	mptscsih_qcmd=0A=
-#define x_scsi_abort		mptscsih_abort=0A=
-#define x_scsi_bus_reset	mptscsih_bus_reset=0A=
-#define x_scsi_dev_reset	mptscsih_dev_reset=0A=
-#define x_scsi_host_reset	mptscsih_host_reset=0A=
-#define x_scsi_bios_param	mptscsih_bios_param=0A=
-=0A=
-#define x_scsi_slave_alloc	mptscsih_slave_alloc=0A=
-#define x_scsi_slave_configure	mptscsih_slave_configure=0A=
-#define x_scsi_slave_destroy	mptscsih_slave_destroy=0A=
-#define x_scsi_proc_info	mptscsih_proc_info=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/*=0A=
- *	MPT SCSI Host / Initiator decls...=0A=
- */=0A=
-extern	const char	*x_scsi_info(struct Scsi_Host *);=0A=
-extern	int		 x_scsi_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd =
*));=0A=
-extern	int		 x_scsi_abort(Scsi_Cmnd *);=0A=
-extern	int		 x_scsi_bus_reset(Scsi_Cmnd *);=0A=
-extern	int		 x_scsi_dev_reset(Scsi_Cmnd *);=0A=
-extern	int		 x_scsi_host_reset(Scsi_Cmnd *);=0A=
-extern int		 x_scsi_bios_param(struct scsi_device * sdev, struct =
block_device *bdev,=0A=
-				sector_t capacity, int geom[]);=0A=
-extern	int		 x_scsi_slave_alloc(Scsi_Device *);=0A=
-extern	int		 x_scsi_slave_configure(Scsi_Device *);=0A=
-extern	void		 x_scsi_slave_destroy(Scsi_Device *);=0A=
-extern	int		 x_scsi_proc_info(struct Scsi_Host *, char *, char **, =
off_t, int, int);=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-=0A=
-/*  include/scsi/scsi.h may not be quite complete...  */=0A=
-#ifndef RESERVE_10=0A=
-#define RESERVE_10		0x56=0A=
-#endif=0A=
-#ifndef RELEASE_10=0A=
-#define RELEASE_10		0x57=0A=
-#endif=0A=
-#ifndef PERSISTENT_RESERVE_IN=0A=
-#define PERSISTENT_RESERVE_IN	0x5e=0A=
-#endif=0A=
-#ifndef PERSISTENT_RESERVE_OUT=0A=
-#define PERSISTENT_RESERVE_OUT	0x5f=0A=
 #endif=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-=0A=
-#endif=0A=
-=0A=

------_=_NextPart_000_01C441E6.65C2DF50--
