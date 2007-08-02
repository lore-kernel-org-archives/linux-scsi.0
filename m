From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 3/4] Enable link power management for ata drivers
Date: Thu, 02 Aug 2007 14:27:34 +0900
Message-ID: <46B16B46.4020108@gmail.com>
References: <20070705194909.337398431@intel.com>	<20070705130530.5873afeb.kristen.c.accardi@intel.com>	<46B043FB.5090005@gmail.com> <20070801141154.3246a20d.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070801141154.3246a20d.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Wed, 01 Aug 2007 17:27:39 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Kristen Carlson Accardi wrote:
> <snippy>
>> Is it safe to use ALPM on a device which only claims to support DIPM?
> 
> Yes - I doubled checked this with the AHCI people - and of course you
> have Edvin's testing to prove it does fine.

Alright.

> As far as moving the enable/disable_pm calls to EH - can you take
> a look at the other patch I sent which implements the shost_attrs
> to see if I still need to do this?  I really don't know much about
> the EH stuff - can you explain why we need to use it to set the
> link pm?

Unfortunately, yes, you still need to.  Only two threads of execution
(one is not a real thread tho) are allowed to access a libata port -
command execution and EH, and the two are mutually exclusive.  Invoking
something from the outside is done by doing the following.

1. recording what to do in ehi->[dev_]action, ap->pflags or dev->flags

2. schedule EH by calling either ata_port_schedule_eh(),
ata_port_abort() or ata_port_freeze().  The first one waits for the
currently in-flight commands to finish before entering EH.  The second
one aborts all in-flight commands and enters EH.  The third one aborts
all commands and freezes the port and enters EH.

3. wait for EH to finish by calling ata_port_wait_eh().

This achieves correct synchronization and other EH functionalities can
be easily used.  e.g. Resuming requires resetting the bus and
revalidating the attached devices, so the resume handler can just
request such actions together.  For link PS, I think it would probably
be a good idea to revalidate after mode change to make sure the device
works in the new mode.  If revalidation fails, it can reset and back off.

EH is done in three large steps - autopsy, report and recover.  To
implement an action, the 'recover' stage needs to be extended.  It
basically comes down to hooking the enable/disable functions into the
right places in ata_eh_recover().  Unconditionally disabling link PS
prior to reset and enabling it back again before revalidation would be a
pretty good choice, but haven't thought about it too hard so take it
with a grain of salt.

I'm not sure whether it would be necessary now but it would be nice to
have a proper recovery logic later.  e.g. If more than certain number of
ATA bus occurs in certain mount of time, disable link PS.  This kind of
logic is used during autopsy to determine whether stepping down
link/transfer speed is needed.  Please take a look at
ata_eh_speed_down().  It might be enough to piggy back on
ata_eh_speed_down() tho such that the first step of speeding down is
turning off link PS.

Hope the brief introduction to libata-EH-hacking helps.

-- 
tejun
