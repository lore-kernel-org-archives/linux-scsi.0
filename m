From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 50] drivers/message/fusion/mptctl.c: mostly kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:54:26 +0200
Message-ID: <200707312054.27294.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, support@lsi.com, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch does kmalloc + memset conversion to kzalloc and simplifies mptctl_probe().

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/message/fusion/mptctl.c | 82092 -> 81884 (-208 bytes)
 drivers/message/fusion/mptctl.o | 201784 -> 200648 (-1136 bytes)

 drivers/message/fusion/mptctl.c |   36 ++++++++++--------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/message/fusion/mptctl.c	2007-07-26 13:07:44.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/message/fusion/mptctl.c	2007-07-31 18:02:38.000000000 +0200
@@ -963,10 +963,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
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
@@ -1363,13 +1362,12 @@ mptctl_gettargetinfo (unsigned long arg)
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
@@ -1551,12 +1549,11 @@ mptctl_eventenable (unsigned long arg)
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
@@ -2823,31 +2820,22 @@ static long compat_mpctl_ioctl(struct fi
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
