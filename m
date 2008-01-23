From: "Mike Snitzer" <snitzer@gmail.com>
Subject: AACRAID driver broken in 2.6.22.x (and beyond?) [WAS: Re: 2.6.22.16 MD raid1 doesn't mark removed disk faulty, MD thread goes UN]
Date: Tue, 22 Jan 2008 19:09:42 -0500
Message-ID: <170fa0d20801221609r2cb7b518r1d8dc24b7d655d17@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, "K. Tanaka" <k-tanaka@ce.jp.nec.com>, aacraid@adaptec.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Jan 22, 2008 12:29 AM, Mike Snitzer <snitzer@gmail.com> wrote:
> cc'ing Tanaka-san given his recent raid1 BUG report:
> http://lkml.org/lkml/2008/1/14/515
>
>
> On Jan 21, 2008 6:04 PM, Mike Snitzer <snitzer@gmail.com> wrote:
> > Under 2.6.22.16, I physically pulled a SATA disk (/dev/sdac, connected to
> > an aacraid controller) that was acting as the local raid1 member of
> > /dev/md30.
> >
> > Linux MD didn't see an /dev/sdac1 error until I tried forcing the issue by
> > doing a read (with dd) from /dev/md30:
....
> The raid1d thread is locked at line 720 in raid1.c (raid1d+2437); aka
> freeze_array:
>
> (gdb) l *0x0000000000002539
> 0x2539 is in raid1d (drivers/md/raid1.c:720).
> 715              * wait until barrier+nr_pending match nr_queued+2
> 716              */
> 717             spin_lock_irq(&conf->resync_lock);
> 718             conf->barrier++;
> 719             conf->nr_waiting++;
> 720             wait_event_lock_irq(conf->wait_barrier,
> 721                                 conf->barrier+conf->nr_pending ==
> conf->nr_queued+2,
> 722                                 conf->resync_lock,
> 723                                 raid1_unplug(conf->mddev->queue));
> 724             spin_unlock_irq(&conf->resync_lock);
>
> Given Tanaka-san's report against 2.6.23 and me hitting what seems to
> be the same deadlock in 2.6.22.16; it stands to reason this affects
> raid1 in 2.6.24-rcX too.

Turns out that the aacraid driver in 2.6.22.x is HORRIBLY BROKEN (when
you pull a drive); it responds to MD's write requests with uptodate=1
(in raid1_end_write_request) for the drive that was pulled!  I've not
looked to see if aacraid has been fixed in newer kernels... are others
aware of any crucial aacraid fixes in 2.6.23.x or 2.6.24?

After the drive was physically pulled, and small periodic writes
continued to the associated MD device, the raid1 MD driver did _NOT_
detect the pulled drive's writes as having failed (verified this with
systemtap).  MD happily thought the write completed to both members
(so MD had no reason to mark the pulled drive "faulty"; or mark the
raid "degraded").

Installing an Adaptec-provided 1.1-5[2451] driver enabled raid1 to
work as expected.

That said, I now have a recipe for hitting the raid1 deadlock that
Tanaka first reported over a week ago.  I'm still surprised that all
of this chatter about that BUG hasn't drawn interest/scrutiny from
others!?

regards,
Mike
