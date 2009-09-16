From: Chris Webb <chris@arachsys.com>
Subject: Re: MD/RAID time out writing superblock
Date: Wed, 16 Sep 2009 23:28:42 +0100
Message-ID: <20090916222842.GB16053@arachsys.com>
References: <4AADF471.2020801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760207AbZIPWed@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AADF471.2020801@suse.de>
 <4AADF3C4.5060004@kernel.org>
 <4A9BC023.10903@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Hi Tejun. Thanks for following up to this. We've done some more experimentation
over the last couple of days based on your suggestions and thoughts.

Tejun Heo <tj@kernel.org> writes:
> Seriously, it's most likely a hardware malfunction although I can't tell
> where the problem is with the given data.  Get the hardware fixed.

We know this isn't caused by a single faulty piece of hardware, because we have
a cluster of identical machines and all have shown this behaviour. This doesn't
mean that there isn't a hardware problem, but if there is one, it's a design
problem or firmware bug affecting all of our hosts.

There have also been a few reports of problems which look very similar in this
thread from people with somewhat different hardware and drives to ours.

> The aboves are IDENTIFY.  Who's issuing IDENTIFY regularly?  It isn't
> from the regular IO paths or md.  It's probably being issued via SG_IO
> from userland.  These failures don't affect normal operation.
[...]
> Oooh, another possibility is the above continuous IDENTIFY tries.
> Doing things like that generally isn't a good idea because vendors
> don't expect IDENTIFY to be mixed regularly with normal IOs and
> firmwares aren't tested against that.  Even smart commands sometimes
> cause problems.  So, finding out the thing which is obsessed with the
> identity of the drive and stopping it might help.

We tracked this down to some (excessively frequent!) monitoring we were doing
using smartctl. Things were improved considerably by stopping smartd and
disabling all callers of smartctl, although it doesn't appear to have been a
cure. The frequency of these timeouts during resync seems to have gone from
about once every two hours to about once a day, which means we've been able to
complete some resyncs whereas we were unable to before.

What we still see are (fewer) 'frozen' exceptions leading to a drive reset and
an 'end_request: I/O error', such as [1]. The drive is then promptly kicked out
of the raid array.

Some of these timeouts also leave us with a completely dead drive, and we need
to reboot the machine before it can be accessed again. (Hot plugging it out and
back in again isn't sufficient to bring it back to life, so maybe a controller
problem, although other drives on the same controller stay alive?) An example
is [2].

There are two more symptoms we are seeing on the same which may be
connected, or may be separate bugs in their own right:

  - 'cat /proc/mdstat' sometimes hangs before returning during normal
    operation, although most of the time it is fine. We have seen hangs of
    up to 15-20 seconds during resync. Might this be a less severe example
    of the lock-up which causes a timeout and reset after 30 seconds?

  - We've also had a few occasions of O_SYNC writes to raid arrays (from
    qemu-kvm via LVM2) completely deadlocking against resync writes when the
    maximum md resync speed is set sufficiently high, even where the minimum
    md resync speed is set to zero (although this certainly helps). However,
    I suspect this is an unrelated issue as I've seen this on other hardware
    running other kernel configs.

For reference, we're using the ahci driver and deadline IO scheduler with the
default tuning parameters, our motherboards are SuperMicro X7DBN (Intel ESB2
SATA 3.0Gbps Controller) and we have six 750GB Seagate ST3750523AS drives
attached to each motherboard. Also, since first reporting this, I've managed
to reproduce the problem whilst running Linux 2.6.29.6, 2.6.30.5 and the
newly released 2.6.31.

What do you think are our next steps in tracking this one down should be? My
only ideas are:

  - We could experiment with NCQ settings. I've already briefly changed
    /sys/block/sd*/device/queue_depth down from 31 to 1. It didn't seem to stop
    delays in getting back info from /proc/mdstat, so put it back up again fearing
    that the performance hit would make the problem worse, but perhaps I should
    leave it off for a more extended period to verify that we still get timeouts
    long enough to leave slots without it?

  - We could try replacing the drives that are currently kicked out of one of the
    arrays with drives from another manufacturer to see if the drive model
    is implicated. Is the drive or the controller a more likely problem?

Any advice would be very gratefully received.

Cheers,

Chris.

[1] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
    ata5.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
            res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
    ata5.00: status: { DRDY }
    ata5: hard resetting link
    ata5: softreset failed (device not ready)
    ata5: hard resetting link
    ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
    ata5.00: configured for UDMA/133
    ata5: EH complete
    end_request: I/O error, dev sde, sector 1465147264
    md: super_written gets error=-5, uptodate=0
    raid10: Disk failure on sde3, disabling device.
    raid10: Operation continuing on 4 devices.

[2] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
    ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
             res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
    ata1.00: status: { DRDY }
    ata1: hard resetting link
    ata1: softreset failed (device not ready)
    ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
    ata1.00: qc timeout (cmd 0xec)
    ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
    ata1.00: revalidation failed (errno=-5)
    ata1: hard resetting link
    ata1: softreset failed (device not ready)
    ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
    ata1.00: qc timeout (cmd 0xec)
    ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
    ata1.00: revalidation failed (errno=-5)
    ata1: limiting SATA link speed to 1.5 Gbps
    ata1: hard resetting link
    ata1: softreset failed (device not ready)
    ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
    ata1.00: qc timeout (cmd 0xec)
    ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
    ata1.00: revalidation failed (errno=-5)
    ata1.00: disabled
    ata1: hard resetting link
    ata1: softreset failed (device not ready)
    ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
    ata1: EH complete
    sd 0:0:0:0: [sda] Unhandled error code
    sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
    end_request: I/O error, dev sda, sector 1465147272
    end_request: I/O error, dev sda, sector 1465147272
    md: super_written gets error=-5, uptodate=0
    raid10: Disk failure on sda3, disabling device.
    raid10: Operation continuing on 4 devices.
    sd 0:0:0:0: [sda] Unhandled error code
    sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
    end_request: I/O error, dev sda, sector 8396584
    end_request: I/O error, dev sda, sector 8396584
    md: super_written gets error=-5, uptodate=0
    raid1: Disk failure on sda1, disabling device.
    raid1: Operation continuing on 5 devices.
    sd 0:0:0:0: [sda] Unhandled error code
    sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
    end_request: I/O error, dev sda, sector 32
    raid1: sda1: rescheduling sector 0
    sd 0:0:0:0: [sda] Unhandled error code
    sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
    end_request: I/O error, dev sda, sector 8396800
    raid10: sda2: rescheduling sector 0
    sd 0:0:0:0: [sda] Unhandled error code
    sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
    end_request: I/O error, dev sda, sector 8396800
    sd 0:0:0:0: [sda] Unhandled error code
    sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
    end_request: I/O error, dev sda, sector 8396800
    raid10: Disk failure on sda2, disabling device.
    raid10: Operation continuing on 5 devices.
