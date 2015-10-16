From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no
 management
Date: Fri, 16 Oct 2015 13:14:54 -0700
Message-ID: <20151016201454.GB5195@kroah.com>
References: <cover.1444241058.git.lduncan@suse.com>
 <f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
 <1444830904.2220.28.camel@HansenPartnership.com>
 <561EA018.7020700@suse.com>
 <1444848835.2220.50.camel@HansenPartnership.com>
 <5621581E.3000407@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5621581E.3000407@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-usb@vger.kernel.org, linux-hotplug@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 16, 2015 at 01:03:42PM -0700, Lee Duncan wrote:
> Adding linux-usb and linux-hotplug to cc list, in case they wish to comment.
> 
> Summary: I want to change SCSI host number so that it gets re-used, like
> disk index numbers, instead of always increasing.
> 
> Please see below.
> 
> On 10/14/2015 11:53 AM, James Bottomley wrote:
> > On Wed, 2015-10-14 at 11:34 -0700, Lee Duncan wrote:
> >> On 10/14/2015 06:55 AM, James Bottomley wrote:
> >>> On Wed, 2015-10-07 at 16:51 -0700, Lee Duncan wrote:
> >>>> Update the SCSI hosts module to use the ida_simple*() routines
> >>>> to manage its host_no index instead of an ATOMIC integer. This
> >>>> means that the SCSI host number will now be reclaimable.
> >>>
> >>> OK, but why would we want to do this?  We do it for sd because our minor
> >>> space for the device nodes is very constrained, so packing is essential.
> >>> For HBAs, there's no device space density to worry about, they're
> >>> largely statically allocated at boot time and not reusing the numbers
> >>> allows easy extraction of hotplug items for the logs (quite useful for
> >>> USB) because each separate hotplug has a separate and monotonically
> >>> increasing host number.
> >>>
> >>> James
> >>>
> >>
> >> Good question, James. Apologies for not making the need clear.
> >>
> >> The iSCSI subsystem uses a host structure for discovery, then throws it
> >> away. So each time it does discovery it gets a new host structure. With
> >> the current approach, that number is ever increasing. It's only a matter
> >> of time until some user with a hundreds of disks and perhaps thousands
> >> of LUNs, that likes to do periodic discovery (think super-computers)
> >> will run out of host numbers. Or, worse yet, get a negative number
> >> number (because the value is signed right now).
> >>
> >> And this use case is a real one right now, by the way.
> > 
> > Um, so even if you do discovery continuously, say one every second, it
> > still will take 68 years before we wrap the sign.
> > 
> >> As you can see from the patch, it's a small amount of code to ensure
> >> that the host number management is handled more cleanly.
> > 
> > Well, I'm a bit worried about the loss of a monotonically increasing
> > host number from the debugging perspective.  Right now, if you look at
> > any log, hostX always refers to one and only one incarnation throughout
> > the system lifetime for any given value of X.  With your patch, the
> > lowest host number gets continually reused ... probably for every hot
> > plug event.  If the USB and other hotplug system people don't mind this,
> > I suppose I can live with it, but I'd like to hear their view before
> > making this change.

USB "people" don't care about this, why would we?  You can plug and
unplug and plug devices in lots of times and they get the "old" names
all the time, this is something that tools have had to deal with for
well over a decade.

thanks,

greg k-h
