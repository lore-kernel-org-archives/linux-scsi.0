From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: ARECA 'arcmsr' new Linux SCSI RAID driver version 1.20.00.10
Date: Mon, 26 Sep 2005 12:51:54 +0200
Message-ID: <1127731914.16288.17.camel@laptopd505.fenrus.org>
References: <001a01c5c286$333a9290$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36585 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750804AbVIZKwE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Sep 2005 06:52:04 -0400
In-Reply-To: <001a01c5c286$333a9290$9300a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: Linux Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Linux Matt Dainty <matt@bodgit-n-scarper.com>, Linux Kornel Wieliczek <e0815w@onlinehome.de>, Linux James Bottomley <James.Bottomley@SteelEye.com>, Linux Christoph Hellwig <hch@infradead.org>, Linux Adrian Bunk <bunk@stusta.de>

On Mon, 2005-09-26 at 18:36 +0800, erich wrote:
> Hi Dear All,
> 
> I have add some sysfs function at arcmsr.
> increase some ioctl function for the request of Linux forums and areca
> customer.

+#ifdef MODULE_LICENSE
+MODULE_LICENSE("Dual BSD/GPL");
+#endif

that ifdef is not needed and should go away!

+#ifndef msleep
+#define arc_mdelay(msec)         mdelay(msec)
+#define arc_mdelay_int(msec)     mdelay(msec)
+#else
+#define arc_mdelay(msec)         msleep(msec)
+#define arc_mdelay_int(msec)     msleep_interruptible(msec)
+#endif

please don't do a pointless abstraction like this. If you want to
protect against ancient kernel versions, you should provide an msleep()
emulation in some compat header. Not define a new name!
(and your emulation is really bad as well in this case and very broken)


+       if (sizeof(dma_addr_t) > 4) {
+               if (!pci_set_dma_mask(pPCI_DEV, DMA_64BIT_MASK))
{      /*64bit */
+                       printk
+                           ("ARECA RAID: 64BITS PCI BUS DMA ADDRESSING
SUPPORTED 'USING DAC'\n");
+               } else {
+                       printk
+                           ("ARECA RAID: 32BITS PCI BUS DMA ADDRESSING
'DAC DISABLE'\n");
+                       pci_set_dma_mask(pPCI_DEV, DMA_32BIT_MASK);
+               }
+       } else {
+               pci_set_dma_mask(pPCI_DEV, DMA_32BIT_MASK);
+       }


this code makes no sense; at least the if (sizeof()) doesn't


there are also many coding style issues making it hard to review this
driver ;(



