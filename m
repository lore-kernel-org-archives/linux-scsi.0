From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 22/82] remove linux/version.h from drivers/message/fus
	 ion
Date: Wed, 13 Jul 2005 09:11:26 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C03157442@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:29591 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262674AbVGMPMN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 11:12:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Matt Domsch <Matt_Domsch@dell.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Olaf Hering <olh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Wednesday, July 13, 2005 8:38 AM, Christoph Hellwig wrote:
> 
> > In general, this construct:
> > 
> > > > -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
> > > > -static int inline scsi_device_online(struct scsi_device *sdev)
> > > > -{
> > > > -	return sdev->online;
> > > > -}
> > > > -#endif
> > 
> > is better tested as:
> > 
> > #ifndef scsi_device_inline
> > static int inline scsi_device_online(struct scsi_device *sdev)
> > {
> >     return sdev->online;
> > }
> > #endif
> 
> Even better fusion should stop using this function because doing so
> is broken.. We tried that long ago but it got stuck somewhere.
>

Christoph - We have already fixed the problem long ago; e.g.
remember when you asked me to kill the timers from the eh threads.  
Thus in todays drivers you will not find scsi_device_online called anywhere
in 
the fusion drivers.

I only objected to killing the linux_compat.h file because its being used
in our internal supported drivers, and it makes it easier upgrade path
for maintaining mainstream drivers if that was left behind in the kernel
tree.
However everybody has ambushed me on this stance, so go ahead and kill it.
We'll manage fine without it.

Eric Moore

