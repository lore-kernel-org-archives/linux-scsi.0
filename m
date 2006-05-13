From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] printks in print_inquiry
Date: Fri, 12 May 2006 23:00:59 -0600
Message-ID: <20060513050059.GR12272@parisc-linux.org>
References: <20060511150015.GJ12272@parisc-linux.org> <20060512170854.GA11215@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:9632 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932336AbWEMFA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 May 2006 01:00:59 -0400
Content-Disposition: inline
In-Reply-To: <20060512170854.GA11215@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Fri, May 12, 2006 at 10:08:54AM -0700, Patrick Mansfield wrote:
> Terser one line output would be nice (even for a few devices), with "scsi"
> and bus_id. We don't need "Type", like:
> 
> SCSI 2:0:0:0: Vendor: FOO      Model: BAR              Rev: 0.2 ANSI rev: 04
> 
> And maybe use printk("%-16s") formatting? But garbage might get printed
> for non-ASCII (though the SCSI specs say it is not allowed ...).

I'm certainly in favour of changing the formatting; possibly even
eliminating it.  It gets very tiresome on a large system.  But then it's
sometimes useful, particularly in bug reports.  So eliminating it may
be a step too far.

> > the function says we should be packaging all this up into a hotplug
> > event.  Is that still true?  If so, I can do that, and we can forget
> > about this patch.
> 
> There is already a hotplug event. 
> 
> But the timing and output of it won't match well with the other SCSI (sd)
> messages, they'll likely be output before hotplug handling for the event.
> 
> And then if relying on udev for the output: it replays hotplug events when
> it starts up, so (AFAICT) you'd get a flurry of output after all the other
> scsi kernel messages for no udev in initrd and for monolithic kernels
> (well any time udev is started after scsi discovery).

I wasn't thinking about relying on it for the output; more that if the
data's being parsed out of the inquiry string already, doing this second
conversion in print_inquiry is a bit daft.  And ugly.  It'd be better to
take the constructed hotplug event and print the relevant fields out of
that.  I'll fiddle with it some more.
