From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: latest mpt-fusion oopses
Date: Thu, 28 Apr 2005 14:22:05 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0225D051@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:28158 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262127AbVD1UW1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 16:22:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Ok - The problem is the module_init entry point for
mptbase.ko is not being called when the driver is statically
compiled into the kernel.  Maybe when I moved registering
the pci ids to the scsi llds(e.g. mptspi and mptfc) that 
mptbase.ko doesn't have its module_init called. The panic
in mpt_interrupt occurs when the ISR is calling the callback
handlers when cb_idx is 0xFF, and MptCallbacks is pointing to NULL.
The cb_idx would of been initialized to something less than 0xFF had
the module_init entry point been called.

I guess I will have to have the scsi lld drivers registering the pci ids
call mptbase.c module_init function, and maintain a flag so
its not called more that once.

Eric Moore

On Thursday, April 28, 2005 3:21 AM, Andrew Morton wrote:
> 
> Andrew Morton <akpm@osdl.org> wrote:
> >
> > I guess I'll test this on x86 next.
> 
> It crashed, strangely.  See
> http://www.zip.com.au/~akpm/linux/patches/stuff/dsc02504.jpg.
> 
> It appears to have jumped directly to address zero from 
> handle_IRQ_event. 
> Disabling CONFIG_PM didn't help.  No shared IRQs on this box.
> 
> Config is at http://www.zip.com.au/~akpm/linux/patches/stuff/config
> 
