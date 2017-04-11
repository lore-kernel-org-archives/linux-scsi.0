From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 10 Apr 2017 22:26:12 -0300
Message-ID: <20170411012612.GC10185@khazad-dum.debian.net>
References: <20170410232118.GA4816@khazad-dum.debian.net>
 <20170410235206.GA28603@wtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170410235206.GA28603@wtj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 11 Apr 2017, Tejun Heo wrote:
> > The kernel then continues the shutdown path while the SSD is still
> > preparing itself to be powered off, and it becomes a race.  When the
> > kernel + firmware wins, platform power is cut before the SSD has
> > finished (i.e. the SSD is subject to an unclean power-off).
> 
> At that point, the device is fully flushed and in terms of data
> integrity should be fine with losing power at any point anyway.

All bets are off at this point, really.

We issued a command that explicitly orders the SSD to checkpoint and
stop all background tasks, and flush *everything* including invisible
state (device data, stats, logs, translation tables, flash metadata,
etc)...  and then cut its power before it finished.

> > NOTE: unclean SSD power-offs are dangerous and may brick the device in
> > the worst case, or otherwise harm it (reduce longevity, damage flash
> > blocks).  It is also not impossible to get data corruption.
> 
> I get that the incrementing counters might not be pretty but I'm a bit
> skeptical about this being an actual issue.  Because if that were

As an *example* I know of because I tracked it personally, Crucial SSDs
models from a few years ago were known to eventually brick on any
platforms where they were being subject to repeated unclean shutdowns,
*Windows included*.  There are some threads on their forums about it.
Firmware revisions made it harder to happen, but still...

> true, the device would be bricking itself from any sort of power
> losses be that an actual power loss, battery rundown or hard power off
> after crash.

Bricking is a worst-case, really.  I guess they learned to keep the
device always in a will-not-brick state using append-only logs for
critical state or something, so it really takes very nasty flash damage
to exactly the wrong place to render it unusable.

> > Fixing the issue properly:
> > 
> > The proof of concept patch works fine, but it "punishes" the system with
> > too much delay.  Also, if sd device shutdown is serialized, it will
> > punish systems with many /dev/sd devices severely.
> > 
> > 1. The delay needs to happen only once right before powering down for
> >    hibernation/suspend/power-off.  There is no need to delay per-device
> >    for platform power off/suspend/hibernate.
> > 
> > 2. A per-device delay needs to happen before signaling that a device
> >    can be safely removed when doing controlled hotswap (e.g. when
> >    deleting the SD device due to a sysfs command).
> > 
> > I am unsure how much *total* delay would be enough.  Two seconds seems
> > like a safe bet.
> > 
> > Any comments?  Any clues on how to make the delay "smarter" to trigger
> > only once during platform shutdown, but still trigger per-device when
> > doing per-device hotswapping ?
> 
> So, if this is actually an issue, sure, we can try to work around;
> however, can we first confirm that this has any other consequences
> than a SMART counter being bumped up?  I'm not sure how meaningful
> that is in itself.

I have no idea how to confirm an SSD is being either less, or more
damaged by the "STANDBY-IMMEDIATE and cut power too early", when
compared with "sudden power cut".  At least not without actually
damaging the SSDs using three groups (normal power cuts,
STANDBY-IMMEDIATE + power cut, control group).

A "SSD power cut test" search on duckduckgo shows several papers and
testing reports on the first results page.  I don't think there is any
doubt whatsoever that your typical consumer SSD *can* get damaged by a
"sudden power cut" so badly that it is actually noticed by the user.

That FLASH itself gets damaged or can have stored data corrupted by
power cuts at bad times is quite clear:

http://cseweb.ucsd.edu/users/swanson/papers/DAC2011PowerCut.pdf

SSDs do a lot of work to recover from that without data loss.  You won't
notice it easily unless that recovery work *fails*.

-- 
  Henrique Holschuh
