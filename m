From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 14 Sep 2009 11:02:26 -0300
Message-ID: <20090914140226.GD32253@khazad-dum.debian.net>
References: <4A9B8583.9050601@kernel.org>
 <4A9BBC4A.6070708@redhat.com>
 <4A9BC023.10903@kernel.org>
 <20090907114442.GG18831@arachsys.com>
 <20090907115927.GU8710@arachsys.com>
 <20090909120218.GB21829@arachsys.com>
 <4AADF3C4.5060004@kernel.org>
 <4AADF471.2020801@suse.de>
 <20090914131114.GA32253@khazad-dum.debian.net>
 <4AAE4422.4040801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755284AbZINOC2@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AAE4422.4040801@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <teheo@suse.de>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 14 Sep 2009, Tejun Heo wrote:
> Henrique de Moraes Holschuh wrote:
> > On Mon, 14 Sep 2009, Tejun Heo wrote:
> >> Oooh, another possibility is the above continuous IDENTIFY tries.
> >> Doing things like that generally isn't a good idea because vendors
> >> don't expect IDENTIFY to be mixed regularly with normal IOs and
> > 
> > IMHO that means the kernel should be special-casing such commands, then (i.e
> > quiesce drive, do command, quiesce driver, start IO again), probably
> > rate-limiting it for good effect.
> > 
> > This is the kind of stuff that userspace should NOT have to worry about
> > (because it will get it wrong and cause data corruption eventually).
> 
> If this indeed is the case (As Mark pointed out, there hasn't been any
> precedence involving IDENTIFY but it's also the first time I see
> IDENTIFY timeouts which are issued from userland), this is the kind
> that userspace shouldn't do to begin with.

There are many reasons why userspace would issue identify (note: I didn't
say they are good reasons), and off the hand I recall hddtemp as a likely
culprit.  Also, sometimes the local admin does hdparm -I for whatever
reason.  So, I am not surprised someone found a way to cause many IDENTIFY
commands to be issued.

Other SMART-maintenance utilities might issue IDENTIFY as well.  And if this
is an issue with SMART in general, smartd issues SMART commands (I don't
know if it uses IDENTIFY) once per hour to check attributes, and can be
configured to fire off SMART short/long/offline tests automatically.  The
local admin sends SMART commands (through smartctl) with the disks hot to
check the error log after EH, etc.

IMHO, the kernel really should be protecting userland against data
corruption here, even if it means a massive hit on disk performance while
the SMART commands are being processed.

> There was another similar problem.  Some acpi package in ubuntu issues
> APM adjustment commands whenever power related stuff changes.  The

Yes.  If you fail to do this on ThinkPads (many models, but probably not
all), your disk will break in 1-2yr maximum, and THAT assumes you have
Hitachi notebook HDs that are supposed to take 600k head unloads before
croaking...  most other vendors say thay can only do 300k head unloads in
their datasheets (if you can find a datasheet at all).  If you need a reason
to buy Hitachi HDs, this is it: they give you full, proper datasheets.

The *firmware* of these laptops will issue these annoying APM commands by
itself when power state changes, and not even setting the BIOS to
"performance" mode makes it stop with the destructive behaviour.  So any
disk that cannot take receiving APM commands many times per day on such
laptops will cause problems.

Now, why Ubuntu would do this outside of the ThinkPads, or target anything
other than magnetic disk media, I don't know.  Maybe other laptop vendors
also had the same idea.  Maybe Ubuntu was simplistic on their approach when
they added this defensive feature.  Maybe it was considered a PM feature and
it is not even related to the ThinkPad APM annoyance.  You'd have to ask
them.

> firmware on the drive which shipped on Samsung NC10 for some reason
> locks up after being hit with enough of those commands.  It's just not
> safe to assume these kind of stuff would reliably work.  If you're

Maybe we can blacklist such commands on drives known to mismimplement them?

> ready to do some research and experiments, it's fine.  If you're doing
> OEM customization with specific hardware and QA, sure, why not (this
> is basically what windows OEMs do too).  But, doing things which
> aren't _usually_ used that way repeatedly _by default_ is asking for
> trouble.  There's a reason why these operations are root only.  :-)

There are real user cases for APM commands, and for SMART commands...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
