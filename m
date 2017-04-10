From: Tejun Heo <tj@kernel.org>
Subject: Re: Race to power off harming SATA SSDs
Date: Tue, 11 Apr 2017 08:52:06 +0900
Message-ID: <20170410235206.GA28603@wtj.duckdns.org>
References: <20170410232118.GA4816@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:33783 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdDJXwT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 19:52:19 -0400
Content-Disposition: inline
In-Reply-To: <20170410232118.GA4816@khazad-dum.debian.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Hello,

On Mon, Apr 10, 2017 at 08:21:19PM -0300, Henrique de Moraes Holschuh wrote:
...
> Per spec (and device manuals), SCSI, SATA and ATA-attached SSDs must be
> informed of an imminent poweroff to checkpoing background tasks, flush
> RAM caches and close logs.  For SCSI SSDs, you must tissue a
> START_STOP_UNIT (stop) command.  For SATA, you must issue a STANDBY
> IMMEDIATE command.  I haven't checked ATA, but it should be the same as
> SATA.

Yeah, it's the same.  Even hard drives are expected to survive a lot
of unexpected power losses tho.  They have to do emergency head
unloads but they're designed to withstand a healthy number of them.

> In order to comply with this requirement, the Linux SCSI "sd" device
> driver issues a START_STOP_UNIT command when the device is shutdown[1].
> For SATA SSD devices, the SCSI START_STOP_UNIT command is properly
> translated by the kernel SAT layer to STANDBY IMMEDIATE for SSDs.
> 
> After issuing the command, the kernel properly waits for the device to
> report that the command has been completed before it proceeds.
> 
> However, *IN PRACTICE*, SATA STANDBY IMMEDIATE command completion
> [often?] only indicates that the device is now switching to the target
> power management state, not that it has reached the target state.  Any
> further device status inquires would return that it is in STANDBY mode,
> even if it is still entering that state.
> 
> The kernel then continues the shutdown path while the SSD is still
> preparing itself to be powered off, and it becomes a race.  When the
> kernel + firmware wins, platform power is cut before the SSD has
> finished (i.e. the SSD is subject to an unclean power-off).

At that point, the device is fully flushed and in terms of data
integrity should be fine with losing power at any point anyway.

> Evidently, how often the SSD will lose the race depends on a platform
> and SSD combination, and also on how often the system is powered off.
> A sluggish firmware that takes its time to cut power can save the day...
> 
> 
> Observing the effects:
> 
> An unclean SSD power-off will be signaled by the SSD device through an
> increase on a specific S.M.A.R.T attribute.  These SMART attributes can
> be read using the smartmontools package from www.smartmontools.org,
> which should be available in just about every Linux distro.
> 
> 	smartctl -A /dev/sd#
> 
> The SMART attribute related to unclean power-off is vendor-specific, so
> one might have to track down the SSD datasheet to know which attribute a
> particular SSD uses.  The naming of the attribute also varies.
> 
> For a Crucial M500 SSD with up-to-date firmware, this would be attribute
> 174 "Unexpect_Power_Loss_Ct", for example.
> 
> NOTE: unclean SSD power-offs are dangerous and may brick the device in
> the worst case, or otherwise harm it (reduce longevity, damage flash
> blocks).  It is also not impossible to get data corruption.

I get that the incrementing counters might not be pretty but I'm a bit
skeptical about this being an actual issue.  Because if that were
true, the device would be bricking itself from any sort of power
losses be that an actual power loss, battery rundown or hard power off
after crash.

> Testing, and working around the issue:
> 
> I've asked for several Debian developers to test a patch (attached) in
> any of their boxes that had SSDs complaining of unclean poweroffs.  This
> gave us a test corpus of Intel, Crucial and Samsung SSDs, on laptops,
> desktops, and a few workstations.
> 
> The proof-of-concept patch adds a delay of one second to the SD-device
> shutdown path.
> 
> Previously, the more sensitive devices/platforms in the test set would
> report at least one or two unclean SSD power-offs a month.  With the
> patch, there was NOT a single increase reported after several weeks of
> testing.
> 
> This is obviously not a test with 100% confidence, but it indicates very
> strongly that the above analysis was correct, and that an added delay
> was enough to work around the issue in the entire test set.
> 
> 
> 
> Fixing the issue properly:
> 
> The proof of concept patch works fine, but it "punishes" the system with
> too much delay.  Also, if sd device shutdown is serialized, it will
> punish systems with many /dev/sd devices severely.
> 
> 1. The delay needs to happen only once right before powering down for
>    hibernation/suspend/power-off.  There is no need to delay per-device
>    for platform power off/suspend/hibernate.
> 
> 2. A per-device delay needs to happen before signaling that a device
>    can be safely removed when doing controlled hotswap (e.g. when
>    deleting the SD device due to a sysfs command).
> 
> I am unsure how much *total* delay would be enough.  Two seconds seems
> like a safe bet.
> 
> Any comments?  Any clues on how to make the delay "smarter" to trigger
> only once during platform shutdown, but still trigger per-device when
> doing per-device hotswapping ?

So, if this is actually an issue, sure, we can try to work around;
however, can we first confirm that this has any other consequences
than a SMART counter being bumped up?  I'm not sure how meaningful
that is in itself.

Thanks.

-- 
tejun
