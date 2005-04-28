From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: latest mpt-fusion oopses
Date: Thu, 28 Apr 2005 16:14:58 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0225D198@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:12940 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262284AbVD1WPS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 18:15:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

On Thursday, April 28, 2005 3:43 PM, Andrew Morton wrote:
> "Moore, Eric Dean" <Eric.Moore@lsil.com> wrote:
> >
> > Ok - The problem is the module_init entry point for
> > mptbase.ko is not being called when the driver is statically
> > compiled into the kernel.
> 
> That doesn't sound right.  The kernel will call that 
> module_init() function
> for statically linked things.
> 
> This came out:
> 
> 	"Fusion MPT SPI Host driver 3.03.00"
> 
> So fusion_init() is being called.  Maybe the problem is that 
> fusion_init()
> is being called at the wrong time.

Look at the dsc02504.jpg you sent earlier today. Only mptspi_init was
called. Not fusion_init. 

When fusion_init() called, it would display 
"Fusion MPT base driver 3.03.00".  

The message "Fusion MPT SPI Host driver 3.03.00" came from mptspi_init.

Anyways, I have it solved.  A patch soon follows.

Eric Moore
