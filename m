From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: oops during scsi scanning disk setup
Date: Sat, 22 Aug 2009 09:56:05 -0500
Message-ID: <1250952965.18902.2.camel@mulgrave.site>
References: <20090820180549.GD7542@arachsys.com>
	 <1250807161.4302.167.camel@mulgrave.site>
	 <20090821081621.GB32115@arachsys.com> <20090821083356.GC32115@arachsys.com>
	 <20090821092326.GF32115@arachsys.com>
	 <1250863216.3844.1.camel@mulgrave.site>
	 <20090821145141.GR32115@arachsys.com>
	 <1250869674.7363.89.camel@mulgrave.site>
	 <20090822115535.GB1976@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49149 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbZHVO4K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Aug 2009 10:56:10 -0400
In-Reply-To: <20090822115535.GB1976@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 2009-08-22 at 12:55 +0100, Chris Webb wrote:
> James Bottomley <James.Bottomley@suse.de> writes:
> 
> > Can you try this as a partial fix?  (It should prevent the oops, but
> > you'll still lose the disk).
> 
> Hi James. Thanks for patch. I've applied this, although the context is quite
> a bit different in the released 2.6.30.x from your patch against head. (E.g.
> in sd_probe, there's no get_device(&sdp->sdev_gendev) at all before the
> async_schedule(). Instead that happens in sd_probe_async.)
> 
> I'm now seeing a warning backtrace for every scsi attach in the machine,
> including the main system hard drives, so I think something's not quite
> right. For instance, in my test virtual machine:

Oh, I'm afraid that won't work (as you found out).  For your kernel,
you'll need this patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=601e7638254c118fca135af9b1a9f35061420f62

Before you apply it.

Actually, if that works, I'll have the above backported as well.

James


