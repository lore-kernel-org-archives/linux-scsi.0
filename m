From: Arnd Bergmann <arndb@de.ibm.com>
Subject: Re: [RFC][PATCH] move dma_mask into struct device
Date: Sat, 16 Nov 2002 18:23:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211161823.48018.arndb@de.ibm.com>
Reply-To: Arnd Bergmann <ibm.com@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux Scsi <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>

J.E.J. Bottomley [James.Bottomley@steeleye.com] wrote:

> Attached is a patch which moves dma_mask into struct device and cleans up the 
> scsi mid-layer to use it (instead of using struct pci_dev).  The advantage to 
> doing this is probably most apparent on non-pci bus architectures where 
> currently you have to construct a fake pci_dev just so you can get the bounce 
> buffers to work correctly.

That does not sound like the right way to me. If you need to have the dma_mask
for the Scsi_Host, you should store it in Scsi_Host itself. A struct device
must never know about obscure architecture specific stuff like dma.

	Arnd <><
