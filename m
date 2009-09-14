From: Tejun Heo <teheo@suse.de>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 14 Sep 2009 23:34:35 +0900
Message-ID: <4AAE547B.9000405@suse.de>
References: <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de> <20090914131114.GA32253@khazad-dum.debian.net> <4AAE4422.4040801@suse.de> <20090914140226.GD32253@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755579AbZINOeq@vger.kernel.org>
In-Reply-To: <20090914140226.GD32253@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

Henrique de Moraes Holschuh wrote:
>>> This is the kind of stuff that userspace should NOT have to worry about
>>> (because it will get it wrong and cause data corruption eventually).
>> If this indeed is the case (As Mark pointed out, there hasn't been any
>> precedence involving IDENTIFY but it's also the first time I see
>> IDENTIFY timeouts which are issued from userland), this is the kind
>> that userspace shouldn't do to begin with.
> 
> There are many reasons why userspace would issue identify (note: I didn't
> say they are good reasons), and off the hand I recall hddtemp as a likely
> culprit.  Also, sometimes the local admin does hdparm -I for whatever
> reason.  So, I am not surprised someone found a way to cause many IDENTIFY
> commands to be issued.

Heh... and there have been plenty of IO errors and timeouts coming
from hddtemp.  :-)

> Other SMART-maintenance utilities might issue IDENTIFY as well.  And if this
> is an issue with SMART in general, smartd issues SMART commands (I don't
> know if it uses IDENTIFY) once per hour to check attributes, and can be
> configured to fire off SMART short/long/offline tests automatically.  The
> local admin sends SMART commands (through smartctl) with the disks hot to
> check the error log after EH, etc.
> 
> IMHO, the kernel really should be protecting userland against data
> corruption here, even if it means a massive hit on disk performance while
> the SMART commands are being processed.

I don't know.  The problem is with test coverage.  As those aren't
used too often, they don't get tested too much so the coverage of the
blacklist wouldn't be too good and so on and there's very good reason
why those aren't used too often.  They're not all that useful for most
people.

>> There was another similar problem.  Some acpi package in ubuntu issues
>> APM adjustment commands whenever power related stuff changes.  The
> 
> Yes.  If you fail to do this on ThinkPads (many models, but probably not
> all), your disk will break in 1-2yr maximum, and THAT assumes you have
> Hitachi notebook HDs that are supposed to take 600k head unloads before
> croaking...  most other vendors say thay can only do 300k head unloads in
> their datasheets (if you can find a datasheet at all).  If you need a reason
> to buy Hitachi HDs, this is it: they give you full, proper datasheets.

There are plenty drives and configurations like that and different
drives need different APM value to function properly.  storage-fixup
deals exactly with the problem.

 http://git.kernel.org/?p=linux/kernel/git/tj/storage-fixup.git;a=summary

But please note that it's only done once during boot and resume on
machines which are known to specifically need it and with values
reported to work.

> The *firmware* of these laptops will issue these annoying APM commands by
> itself when power state changes, and not even setting the BIOS to
> "performance" mode makes it stop with the destructive behaviour.  So any
> disk that cannot take receiving APM commands many times per day on such
> laptops will cause problems.

Yeap, well, that's what vendors do.  They put together specific subset
of components and try to figure out configurations which work.  If you
replace components on your own, they won't guarantee it will work.
Sucky but that's the way it is.

> Now, why Ubuntu would do this outside of the ThinkPads, or target anything
> other than magnetic disk media, I don't know.  Maybe other laptop vendors
> also had the same idea.  Maybe Ubuntu was simplistic on their approach when
> they added this defensive feature.  Maybe it was considered a PM feature and
> it is not even related to the ThinkPad APM annoyance.  You'd have to ask
> them.

The feature probabaly doesn't have much to do with the frequent head
unload problem.  Unplugging or pluggin in the AC cord also triggered
APM commands to be issued so it's more likely they were trying to
optimize performance / power balance.  The only problem is that APM
setting values aren't clearly defined and just are not too well
tested.

>> firmware on the drive which shipped on Samsung NC10 for some reason
>> locks up after being hit with enough of those commands.  It's just not
>> safe to assume these kind of stuff would reliably work.  If you're
> 
> Maybe we can blacklist such commands on drives known to mismimplement them?

Yes, a possibility but we're unlikely to build meaningful coverage and
likely to prevent valid usages too.  ie. A firmware might lock up when
APM settings are adjusted continuously while setting it once after
booting is fine.  I really want to avoid implementing such logics for
different drives in kernel.

>> ready to do some research and experiments, it's fine.  If you're doing
>> OEM customization with specific hardware and QA, sure, why not (this
>> is basically what windows OEMs do too).  But, doing things which
>> aren't _usually_ used that way repeatedly _by default_ is asking for
>> trouble.  There's a reason why these operations are root only.  :-)
> 
> There are real user cases for APM commands, and for SMART commands...

Yeap, sure, but it just doesn't work very well, not yet at least.
SMART is usually better tested than APM but given the number of
reports I've seen from hddtemp users, certain aspects of it are broken
on many drives.  There isn't a clear answer.  For usual parts of
SMART, it's probably pretty safe but then again don't go too far with
it.  Do it every several hours or every day not every ten secs.  APM
is way more dangerous, if your machine needs it use it minimally.  If
certain combination of values are known to work for the particular
configuration, go ahead and use it.  In other cases, just stay away
from it.

What people use often get tested and verified by vendors and promptly
fixed.  What people don't use often won't be and will be unreliable.
If you want to do things people usually don't do, it's your
responsibility to ensure it actually works.

Thanks.

-- 
tejun
