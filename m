From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Wed, 27 May 2009 16:01:34 +0000
Message-ID: <1243440094.6067.10.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905262214370.21274-100000@netrider.rowland.org>
	 <4A1D2583.8040803@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4A1D2583.8040803@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-05-27 at 13:35 +0200, Hannes Reinecke wrote:
> Hi all,
> 
> Alan Stern wrote:
> > On Wed, 27 May 2009, Kay Sievers wrote:
> > 
> >> On Wed, May 27, 2009 at 01:49, James Bottomley
> >> <James.Bottomley@hansenpartnership.com> wrote:
> >>
> >>> OK ... perhaps we have to wait a little harder: try this; it waits until
> >>> all the targets have disappeared from visibility via an event.
> >> That seems to work fine here.
> > 
> > It's good for a short-term fix.  For the longer term, I still think 
> > it's a mistake to wait for the sdevs to be released before deleting the 
> > target.  It gives user programs the ability to block the host-removal 
> > thread indefinitely.
> > 
> Quite so. We should rather see to have the reference counting fixed
> properly, than this would go away automatically.

Hardly ... our current refcounting is on destruction (releases).  This
problem is an instance of visibility (the del calls) we need the
visibility teardown to work nicely.  We currently have no refcounting on
the visibility.  Even if we did (and we could add a ref on when the
underlying device del calls are done), what happens if the target needs
to become visible again.  Apparently the generic device infrastructure
can't accept doing an add on a previously del'd device.

The most obvious way of fixing this is to have a special case for
targets of dying hosts ... they could call del early on the
understanding that they're never getting new underlying devices.  That
would allow the wait to trigger on the last target del, which is what is
optimal.

James


