From: akpm@linux-foundation.org
Subject: [patch 26/30] drivers/message/fusion/mptctl.c: mostly kmalloc + memset conversion to kzalloc
Date: Fri, 10 Aug 2007 14:50:50 -0700
Message-ID: <200708102150.l7ALoo92011398@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761728AbXHJWCD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 18:02:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, m.kozlowski@tuxland.pl, Eric.Moore@lsil.com

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This patch does kmalloc + memset conversion to kzalloc anSigned-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
d simplifies mptctl_probe().

 drivers/message/fusion/mptctl.c | 82092 -> 81884 (-208 bytes)
 drivers/message/fusion/mptctl.o | 201784 -> 200648 (-1136 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptctl.c |   36 ++++++++++--------------------
 1 files changed, 12 insertions(+), 24 deletions(-)

diff -puN drivers/message/fusion/mptctl.c~drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc drivers/message/fusion/mptctl.c
--- a/drivers/message/fusion/mptctl.c~drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/message/fusion/mptctl.c
@@ -970,10 +970,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 	 * structures for the SG elements.
 	 */
 	i = MAX_SGL_BYTES / 8;
-	buflist = kmalloc(i, GFP_USER);
-	if (buflist == NULL)
+	buflist = kzalloc(i, GFP_USER);
+	if (!buflist)
 		return NULL;
-	memset(buflist, 0, i);
 	buflist_ent = 0;
 
 	/* Allocate a single block of memory to store the sg elements and
@@ -1372,13 +1371,12 @@ mptctl_gettargetinfo (unsigned long arg)
 	 *      15- 8: Bus Number
 	 *       7- 0: Target ID
 	 */
-	pmem = kmalloc(numBytes, GFP_KERNEL);
-	if (pmem == NULL) {
+	pmem = kzalloc(numBytes, GFP_KERNEL);
+	if (!pmem) {
 		printk(KERN_ERR "%s::mptctl_gettargetinfo() @%d - no memory available!\n",
 				__FILE__, __LINE__);
 		return -ENOMEM;
 	}
-	memset(pmem, 0, numBytes);
 	pdata =  (int *) pmem;
 
 	/* Get number of devices
@@ -1563,12 +1561,11 @@ mptctl_eventenable (unsigned long arg)
 		/* Have not yet allocated memory - do so now.
 		 */
 		int sz = MPTCTL_EVENT_LOG_SIZE * sizeof(MPT_IOCTL_EVENTS);
-		ioc->events = kmalloc(sz, GFP_KERNEL);
-		if (ioc->events == NULL) {
+		ioc->events = kzalloc(sz, GFP_KERNEL);
+		if (!ioc->events) {
 			printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 			return -ENOMEM;
 		}
-		memset(ioc->events, 0, sz);
 		ioc->alloc_total += sz;
 
 		ioc->eventContext = 0;
@@ -2853,31 +2850,22 @@ static long compat_mpctl_ioctl(struct fi
 static int
 mptctl_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int err;
-	int sz;
-	u8 *mem;
+	MPT_IOCTL *mem;
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 
 	/*
 	 * Allocate and inite a MPT_IOCTL structure
 	*/
-	sz = sizeof (MPT_IOCTL);
-	mem = kmalloc(sz, GFP_KERNEL);
-	if (mem == NULL) {
-		err = -ENOMEM;
-		goto out_fail;
+	mem = kzalloc(sizeof(MPT_IOCTL), GFP_KERNEL);
+	if (!mem) {
+		mptctl_remove(pdev);
+		return -ENOMEM;
 	}
 
-	memset(mem, 0, sz);
-	ioc->ioctl = (MPT_IOCTL *) mem;
+	ioc->ioctl = mem;
 	ioc->ioctl->ioc = ioc;
 	mutex_init(&ioc->ioctl->ioctl_mutex);
 	return 0;
-
-out_fail:
-
-	mptctl_remove(pdev);
-	return err;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
_
