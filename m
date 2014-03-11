From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Tue, 11 Mar 2014 10:29:39 +0400
Message-ID: <1394519379.2142.13.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
	 <1394511589.2142.5.camel@dabdike.int.hansenpartnership.com>
	 <CAPcyv4gJssEE7hADEDXmi4ao031uSVjMenKk9AFcbTukm1MKNg@mail.gmail.com>
	 <1394515014.2142.11.camel@dabdike.int.hansenpartnership.com>
	 <CAPcyv4gLEQ9-e2GJpfbQQ+DN+nsv-90oFwXxh-_K_hU0z4U5YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gLEQ9-e2GJpfbQQ+DN+nsv-90oFwXxh-_K_hU0z4U5YQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <len.brown@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Phillip Susi <psusi@ubuntu.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, Todd Brandt <todd.e.brandt@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-03-10 at 22:26 -0700, Dan Williams wrote:
> On Mon, Mar 10, 2014 at 10:16 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Mon, 2014-03-10 at 21:47 -0700, Dan Williams wrote:
> >> On Mon, Mar 10, 2014 at 9:19 PM, James Bottomley
> >> <James.Bottomley@hansenpartnership.com> wrote:
> >> > On Mon, 2014-03-10 at 16:59 -0400, Alan Stern wrote:
> >> >> On Mon, 10 Mar 2014, Dan Williams wrote:
> >> >>
> >> >> > > The only thing which is a bit concerning is that this doesn't have any
> >> >> > > throttling mechanism for simultaneous wakeups.  Would this be able to
> >> >> > > blow up the PSU if used on a machine with a lot of spindles?
> >> >> >
> >> >> > Good point.  The primary benefit is completing userspace resume
> >> >> > without needlessly waiting for the disk.  For now I think it would be
> >> >> > enough to have a mutex to maintain one disk at a time.  We can follow
> >> >> > on later with something more complex to enable a max simultaneous
> >> >> > spin-up tunable.
> >> >>
> >> >> Why?  The existing code doesn't have anything like that.
> >> >
> >> > This only becomes a problem if enterprise class systems want to suspend
> >> > and resume.  Last I heard, this wasn't on the cards.
> >> >
> >> > We also don't usually need to bother with in-kernel staggered spin ups
> >> > because if the device can blow the PSU by doing simultaneous spinups,
> >> > staggering is usually hard jumpered in the system.  The main reason for
> >> > this is that there's no way for us to work out the PSU topology to do
> >> > the stagger in kernel, so the enterprise likes to be sure.
> >> >
> >>
> >> In that case shouldn't we limit it to a disk at a time?  Enterprise
> >> doesn't care and home brew folks that both put a lot of disks in a
> >> system and suspend/resume them are less likely to burn themselves.
> >
> > Where do you get that idea from?  the enterprise is amazingly sensitive
> > to system start times; they'd demand my head on a plate if we started a
> > disk at a time and their start times went up by 10x.  That's why we
> > leave it to hard wiring ... they can start in batches the maximum number
> > allowable and thus get the shortest start up times.
> 
> Just considering the dpm_resume path, not device discovery...

But the point is, it's the same.  Either the device was stopped in
suspend or it wasn't.  If it wasn't, the discussion is irrelevant and
there's nothing to wait for and if it was, we need to follow the same
start logic as we did in system bringup.

> > In the long game, though this whole debate is moot: setups with hard
> > wired start times adhere to them regardless of what the system does, so
> > they ignore start unit commands.  Systems without hard wired start times
> > can usually be started at once, so us introducing a delay is unnecessary
> > in either case.
> 
> Ok, then I'll let the patch stand as is.

Sounds good.

James


