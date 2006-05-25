From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] megaraid_mbox: fix section mismatch warnings
Date: Thu, 25 May 2006 14:54:01 -0700
Message-ID: <20060525145401.35e6bc56.rdunlap@xenotime.net>
References: <20060525094614.d2927f2a.rdunlap@xenotime.net>
	<20060525143950.3eef04fa.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:23263 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1030452AbWEYVv2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 17:51:28 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 14:51:26 -0700
In-Reply-To: <20060525143950.3eef04fa.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: ismail@pardus.org.tr, linux-scsi@vger.kernel.org, james.bottomley@steeleye.com, Neela.Kolli@engenio.com

On Thu, 25 May 2006 14:39:50 -0700 Andrew Morton wrote:

> "Randy.Dunlap" <rdunlap@xenotime.net> wrote:
> >
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Fix section warning:
> > WARNING: drivers/scsi/megaraid/megaraid_mbox.o - Section mismatch: reference to .init.text: from .text between 'megaraid_probe_one' (at offset 0x171e) and 'megaraid_queue_command'
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > ---
> >  drivers/scsi/megaraid/megaraid_mbox.c |    2 +-
> >  1 files changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-2617-rc5.orig/drivers/scsi/megaraid/megaraid_mbox.c
> > +++ linux-2617-rc5/drivers/scsi/megaraid/megaraid_mbox.c
> > @@ -714,7 +714,7 @@ megaraid_io_detach(adapter_t *adapter)
> >   * . Allocate memory required for all the commands
> >   * . Use internal library of FW routines, build up complete soft state
> >   */
> > -static int __init
> > +static int __devinit
> >  megaraid_init_mbox(adapter_t *adapter)
> >  {
> >  	struct pci_dev		*pdev;
> > 
> > 
> 
> <trying to get the old brain sorted out here>
> 
> This one's a bugfix, isn't it?  In the CONFIG_HOTPLUG kernel the __devinit
> megaraid_probe_one() resides in .text and calls the __init
> megaraid_init_mbox(), which isn't there any more.  So if this driver is
> statically linked into vmlinux and the kernel is hotplug-capable and if
> someone hotplugs one of these devices we go blam.
> 
> You agree with that analysis?
> 
> If so, I'll toss this onto the 2.6.17 pile, thanks.

Yes, agreed.

Thanks,
---
~Randy
