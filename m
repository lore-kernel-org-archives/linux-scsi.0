From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Thu, 01 Jun 2006 16:00:26 +0200
Message-ID: <1149170426.3115.57.camel@laptopd505.fenrus.org>
References: <20060511143352.GI12272@parisc-linux.org>
	 <20060518172258.GL1604@parisc-linux.org>
	 <20060529031915.GB23405@parisc-linux.org>
	 <447AB2F5.2000700@s5r6.in-berlin.de>
	 <20060529130515.GE23405@parisc-linux.org>
	 <20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	 <20060601132315.GD32143@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:2989 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965127AbWFAOAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jun 2006 10:00:32 -0400
In-Reply-To: <20060601132315.GD32143@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-hotplug-devel@lists.sourceforge.net, Patrick Mansfield <patmans@us.ibm.com>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>

On Thu, 2006-06-01 at 07:23 -0600, Matthew Wilcox wrote:
> On Thu, Jun 01, 2006 at 07:14:05PM +0600, Alexander E. Patrakov wrote:
> > Patrick Mansfield wrote:
> > >>That's what scsi_complete_async_scans() is for.  If you have a built-in
> > >>module, it will wait for the async scans to finish before we get as far
> > >>as trying to mount root.  It does change observable behaviour in that
> > >>sys_module_init() will return before scans are complete.
> > 
> > What are the expected interactions of this code with early userspace aka 
> > "kinit" that comes with (soon to be merged) klibc? Does this 
> > scsi_complete_async_scans() function get called at all if such "default" 
> > initramfs with kinit is used?
> 
> It gets called as a late_initcall -- before initramfs gets started.  The
> problem comes when you load your scsi driver as a module.
> 
> There's a potential solution to this.  If we add a hook to sys_module_init
> such that it'll call a specified function before returning, we can make
> it wait until all scans are done.  This way, userspace never sees the
> asynchronous scanning behaviour.  But if you have devices of different
> types, you won't get the overlapping scans.

alternative is a syscall/ioctl/sysfs thing that userland can trigger to
cause this wait to happen... would be nice I suppose as a general
option.....

