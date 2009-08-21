From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: oops during scsi scanning disk setup
Date: Fri, 21 Aug 2009 18:39:42 -0500
Message-ID: <1250897982.7363.347.camel@mulgrave.site>
References: <20090820180549.GD7542@arachsys.com>
	 <1250807161.4302.167.camel@mulgrave.site>
	 <20090821081621.GB32115@arachsys.com> <20090821083356.GC32115@arachsys.com>
	 <20090821092326.GF32115@arachsys.com>
	 <1250863216.3844.1.camel@mulgrave.site>
	 <20090821145141.GR32115@arachsys.com>
	 <1250869674.7363.89.camel@mulgrave.site>
	 <20090821225950.GC10323@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673AbZHUXjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Aug 2009 19:39:52 -0400
In-Reply-To: <20090821225950.GC10323@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2009-08-21 at 23:59 +0100, Chris Webb wrote:
> James Bottomley <James.Bottomley@suse.de> writes:
> 
> > Can you try this as a partial fix?  (It should prevent the oops, but
> > you'll still lose the disk).
> 
> Hi James. Many thanks for this. Do you think it's worth adding a printk() to
> flag up when this happens so we can detect when this case happens and
> confirm the issue given how rare the crashes are, or is this difficult to
> arrange?

Well, it's only a theory, so we need confirmation that it actually fixes
the problem.

As for a printk, there's no real way to do that.  What I did was make
sure we take a reference to the scsi disk.  Holding that reference
should prevent us from losing the partition table ... but the issue
itself is legitimate (add racing with remove), and there's not really a
good way of detecting it.

James


