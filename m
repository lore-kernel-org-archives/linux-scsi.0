From: Greg KH <greg@kroah.com>
Subject: Re: [Bug 6009] tcpdump causes kernel panic
Date: Thu, 9 Feb 2006 22:18:12 -0800
Message-ID: <20060210061812.GB7939@kroah.com>
References: <200602042315.k14NFwuS006966@fire-2.osdl.org> <20060204153118.4b0270b4.akpm@osdl.org> <1139098731.2957.2.camel@mulgrave.il.steeleye.com> <20060204165156.6024702b.akpm@osdl.org> <1139162555.3017.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl093-040-174.pdx1.dsl.speakeasy.net ([66.93.40.174]:40354
	"EHLO aria.kroah.org") by vger.kernel.org with ESMTP
	id S1751129AbWBJGSU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 01:18:20 -0500
Content-Disposition: inline
In-Reply-To: <1139162555.3017.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Sun, Feb 05, 2006 at 12:02:35PM -0600, James Bottomley wrote:
> On Sat, 2006-02-04 at 16:51 -0800, Andrew Morton wrote:
> > in_interrupt() will return true in hard- or soft-irq context on all
> > architectures and all .configs - you can certainly use that.
> > 
> > What we cannot use is in_atomic() to detect whether we're inside spinlock -
> > that only works if CONFIG_PREEMPT.
> 
> OK, what do you think about this?  It introduces an extra api to ensure
> user context.  I suppose one think that could be done is to get the
> wrappers off a slab instead of using kmalloc, but that could be fixed up
> later.

This looks good to me, and odds are this function will come in handy for
other parts of the kernel.

thanks,

greg k-h
