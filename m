From: Jeff Garzik <jeff@garzik.org>
Subject: Port control interface (was Re: [PATCH] ata: ahci: power off unused
 ports)
Date: Fri, 09 May 2008 11:28:35 -0400
Message-ID: <48246DA3.9080307@garzik.org>
References: <20080508161008.59361de5@appleyard> <48246872.8000502@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48246872.8000502@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> And a more general note:  I still believe we should have a follow-up
> feature to this one, to enable polling for newly inserted drives.
> 
> That would allow powering down idle ports to save money/planet/whatever,
> but still with hotplug capability.  The polling interval should be
> tunable in /sys, with a default of, say, once every couple of seconds.
> 
> Thanks for working on this stuff.


In the grand open source tradition of "pass the buck", I've long been 
hoping that someone would take a few days, sit down, and hammer out the 
policy side of this.

We -don't- want to do hotplug-active all the time -- the current default 
in all drivers that support device hotplug -- because it needlessly 
keeps parts active that are unused 99.9% of the time [when they are empty].

Admins need a generic way to control SATA ports and links from 
userspace.  Within that, admins need to be able to set a link's hotplug 
state among three choices:  hotplug-active [when supported], 
hotplug-poll, and hotplug-never.  And of course, hotplug-poll's interval 
should be tunable.

And of course this control interface needs to be usable on SAS/SATA 
cards that will be common in the future (broadsas, mvsas are early 
examples).


This is why I look askance at an AHCI BIOS flag.  That's merely a hint, 
and potentially unreliable one at that.  It could just be describing 
what the BIOS writer felt were the ports that _should_ be hotpluggable 
-- i.e. not even describing what is _possible_ but someone's definition 
of "reasonable."  The BIOS flag might even be filled with fuzz (AHCI's 
BIOS-written registers have occasionally been shipped into the field 
uninitialized).

A better solution involves taking the BIOS flag and using that to set a 
default policy that an admin can easily override using the 
above-mentioned control interface.

Because in some cases, that BIOS flag might do the wrong thing, and we 
need to give the admin an ability to undo the damage.

	Jeff



