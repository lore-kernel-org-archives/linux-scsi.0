From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH 2.6 ] MPT Fusion driver 3.01.02 update
Date: Wed, 17 Mar 2004 17:02:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57040DB2A7@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:1175 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262110AbUCQWEm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 17:04:42 -0500
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, ak@suse.de, Alexander.Stohr@gmx.de, rddunlap@osdl.org

The wrappers are there because the system
interface registers could be memory or IO mapped
registers depending on the pci device.  The PIO 
wrappers could be removed, but I think its there 
to be uniform with the other wrappers.  The PIO 
wrappers there for firmware download which 
always using IO registers. Id would rather not
remove the volatile since the registers could
be memory mapped, and may break things when
driver compiled with optimized kernel.

Eric


On Wednesday, March 17, 2004 1:21 PM, Jeff Garzik wrote:

> 
> 
> Moore, Eric Dean wrote:
> > This is an update for the MPT Fusion drivers 2.6 kernel.
> > Version 3.01.02.
> > 
> > Changelog:
> > 
> > (1) Andi Kleen[ak@suse.de]
> > put warning "Device (0:0:0) reported QUEUE_FULL!" into 
> debug messages
> > 
> > (2) Alexander Stohr[Alexander.Stohr@gmx.de]
> > fix warnings from mptscsih_setup when driver isn't compiled 
> as module
> > 
> > (3) Randy.Dunlap[rddunlap@osdl.org]
> > Remove unnecessary min/max macros and change calls to 
> > use kernel.h macros instead.
> 
> Here are some wrappers to remove:
> 
> static inline void CHIPREG_PIO_WRITE32(volatile u32 *a, u32 v)
> {
>          outl(v, (unsigned long)a);
> }
> 
> static inline u32 CHIPREG_PIO_READ32(volatile u32 *a)
> {
>          return inl((unsigned long)a);
> }
> 
> 
> Also, I'm not sure about these wrappers, but it's mainly as 
> style issue 
> due to the "if (PortIo)" test.  You should remove the 'volatile' 
> markers, at least.
> 
> 
> static inline u32 CHIPREG_READ32(volatile u32 *a)
> {
>          if (PortIo)
>                  return inl((unsigned long)a);
>          else
>                  return readl(a);
> }
> 
> static inline void CHIPREG_WRITE32(volatile u32 *a, u32 v)
> {
>          if (PortIo)
>                  outl(v, (unsigned long)a);
>          else
>                  writel(v, a);
> }
> 
> 
