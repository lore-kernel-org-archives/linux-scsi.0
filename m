From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Thu, 1 Jun 2006 07:23:15 -0600
Message-ID: <20060601132315.GD32143@parisc-linux.org>
References: <20060511143352.GI12272@parisc-linux.org> <20060518172258.GL1604@parisc-linux.org> <20060529031915.GB23405@parisc-linux.org> <447AB2F5.2000700@s5r6.in-berlin.de> <20060529130515.GE23405@parisc-linux.org> <20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53973 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S965101AbWFANXR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jun 2006 09:23:17 -0400
Content-Disposition: inline
In-Reply-To: <447EE81D.2050906@ums.usu.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-hotplug-devel@lists.sourceforge.net, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

On Thu, Jun 01, 2006 at 07:14:05PM +0600, Alexander E. Patrakov wrote:
> Patrick Mansfield wrote:
> >>That's what scsi_complete_async_scans() is for.  If you have a built-in
> >>module, it will wait for the async scans to finish before we get as far
> >>as trying to mount root.  It does change observable behaviour in that
> >>sys_module_init() will return before scans are complete.
> 
> What are the expected interactions of this code with early userspace aka 
> "kinit" that comes with (soon to be merged) klibc? Does this 
> scsi_complete_async_scans() function get called at all if such "default" 
> initramfs with kinit is used?

It gets called as a late_initcall -- before initramfs gets started.  The
problem comes when you load your scsi driver as a module.

There's a potential solution to this.  If we add a hook to sys_module_init
such that it'll call a specified function before returning, we can make
it wait until all scans are done.  This way, userspace never sees the
asynchronous scanning behaviour.  But if you have devices of different
types, you won't get the overlapping scans.
