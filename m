From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: AACRAID driver broken in 2.6.22.x (and beyond?) [WAS: Re: 2.6.22.16 MD raid1 doesn't mark removed disk faulty, MD thread goes UN]
Date: Wed, 23 Jan 2008 10:56:57 -0500
Message-ID: <170fa0d20801230756r2e74c7c1ke8202e0d02737a63@mail.gmail.com>
References: <170fa0d20801221609r2cb7b518r1d8dc24b7d655d17@mail.gmail.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4394BB4F0@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F4394BB4F0@ADPE2K703.adaptec.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "K. Tanaka" <k-tanaka@ce.jp.nec.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Jan 23, 2008 9:28 AM, Salyzyn, Mark <Mark_Salyzyn@adaptec.com> wrote:
> At which version of the kernel did the aacraid driver allegedly first go broken? At which version did it get fixed? (Since 1.1.5-2451 is older than latest represented on kernel.org)

snitzer:
I don't know where the kernel.org aacraid driver first allegedly broke
relative to this drive pull test.  All I know is 1.1.5-2451 enables
the driver and raid1 layer to behave as expected at the system level.
That is:
1) the aacraid driver enables the pulled scsi device to be offlined
2) the raid1 layer gets a write failure back from the pulled drive and
marks that raid1 member faulty

The demonstration of this is as follows:
aacraid: Host adapter abort request (0,0,27,0)
aacraid: Host adapter abort request (0,0,14,0)
aacraid: Host adapter abort request (0,0,21,0)
aacraid: Host adapter abort request (0,0,25,0)
aacraid: Host adapter abort request (0,0,18,0)
aacraid: Host adapter abort request (0,0,8,0)
aacraid: Host adapter abort request (0,0,23,0)
aacraid: Host adapter abort request (0,0,0,0)
aacraid: Host adapter abort request (0,0,5,0)
aacraid: Host adapter abort request (0,0,1,0)
aacraid: Host adapter abort request (0,0,17,0)
aacraid: Host adapter abort request (0,0,12,0)
aacraid: Host adapter abort request (0,0,3,0)
aacraid: Host adapter abort request (0,0,4,0)
aacraid: Host adapter abort request (0,0,22,0)
aacraid: Host adapter abort request (0,0,11,0)
aacraid: Host adapter abort request (0,0,26,0)
aacraid: Host adapter abort request (0,0,20,0)
aacraid: Host adapter abort request (0,0,2,0)
aacraid: Host adapter abort request (0,0,6,0)
aacraid: Host adapter reset request. SCSI hang ?
AAC: Host adapter BLINK LED 0x7
AAC0: adapter kernel panic'd 7.
AAC0: Non-DASD support enabled.
AAC0: 64 Bit DAC enabled
sd 0:0:27:0: scsi: Device offlined - not ready after error recovery
sd 0:0:27:0: rejecting I/O to offline device
md: super_written gets error=-5, uptodate=0
raid1: Disk failure on sdab1, disabling device.
        Operation continuing on 1 devices
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:1, o:0, dev:sdab1
 disk 1, wo:0, o:1, dev:nbd2
RAID1 conf printout:
 --- wd:1 rd:2
 disk 1, wo:0, o:1, dev:nbd2

Clearly the BlinkLED, firmware panic is _not_ good but in the end the
system stays alive and functions as expected.

> How is the SATA disk'd arrayed on the aacraid controller? The controller is limited to generating 24 arrays and since /dev/sdac is the 29th target, it would appear we need more details on your array's topology inside the aacraid controller. If you are using the driver with aacraid.physical=1 and thus using the physical drives directly (in the case of a SATA disk, a SATr0.9 translation in the Firmware), this is not a supported configuration and was added only to enable limited experimentation. If there is a problem in that path in the driver, I will glad to fix it, but still unsupported.

snitzer:
I'm using the 5.2-0 (15206) firmware that is not limited to 24 arrays;
it supports up to 30 AFAIK.  All disks are being exported to Linux as
a 'Simple Volume'.  I'm not playing games with aacraid.physical=1

Is the 5.2-0 (15206) firmware unsupported on the Adaptec 3085?

I can try the same test with the most current 5.2-0 (15333) firmware
to see if the drive pull behaves any differently with both the
1.1.5-2451 and 2.6.22.16's 1.1-5[2437]-mh4.

> You may need to acquire a diagnostic dump from the controller (Adaptec technical support can advise, it will depend on your application suite) and a report of any error recovery actions reported by the driver in the system log as initiated by the SCSI subsystem.

snitzer:
OK, I can engage Adaptec support on this.

> There are no changes in the I/O path for the aacraid driver. Due to the simplicity of the I/O path to the processor based controller, it is unlikely to be an issue in this path. There have been several changes in the driver to deal with error recovery actions initiated by the SCSI subsystem. One likely candidate was to extend the default SCSI layer timeout because it was shorter than the adapter's firmware timeout. You can check if this is the issue by manually increasing the timeout for the target(s) via sysfs. There were recent patches to deal with orphaned commands resulting from devices being taken offline by the SCSI layer. There has been changes in the driver to reset the controller should it go into a BlinkLED (Firmware Assert) state. The symptom also acts like a condition in the 
 older drivers (pre 08/08/2006 on scsi-misc-2.6, showing up in 2.6.20.4) which did not reset the adapter when it entered the BlinkLED state and merely allowed the system to lock, but alas you are working with a driver with this reset fix in the version you report. A BlinkLED condition generally indicates a serious hardware problem or target incompatibility; and is generally rare as they are a result of corner case conditions within the Adapter Firmware. The diagnostic dump reported by the Adaptec utilities should be able to point to the fault you are experiencing if these appear to be the root causes.

snitzer:
It would seem that 1.1.5-2451 has the firmware reset support given the
log I provided above, no?   Anyway, with 2.6.22.16 when a drive is
pulled using the aacraid 1.1-5[2437]-mh4 there is absolutely no errors
from the aacraid driver; in fact the scsi layer doesn't see anything
until I force the issue with explicit reads/writes to the device that
was pulled.  It could be that on a drive pull the 1.1.5-2451 driver
results in a BlinkLED, resets the firmware, and continues.  Whereas
with the 1.1-5[2437]-mh4 I get no BlinkLED and as such Linux (both
scsi and raid1) is completely unaware of any disconnect of the
physical device.

thanks,
Mike

> > -----Original Message-----
> > From: Mike Snitzer [mailto:snitzer@gmail.com]
> > Sent: Tuesday, January 22, 2008 7:10 PM
> > To: linux-raid@vger.kernel.org; NeilBrown
> > Cc: linux-kernel@vger.kernel.org; K. Tanaka; AACRAID;
> > linux-scsi@vger.kernel.org
> > Subject: AACRAID driver broken in 2.6.22.x (and beyond?)
> > [WAS: Re: 2.6.22.16 MD raid1 doesn't mark removed disk
> > faulty, MD thread goes UN]
> >
>
> > On Jan 22, 2008 12:29 AM, Mike Snitzer <snitzer@gmail.com> wrote:
> > > cc'ing Tanaka-san given his recent raid1 BUG report:
> > > http://lkml.org/lkml/2008/1/14/515
> > >
> > >
> > > On Jan 21, 2008 6:04 PM, Mike Snitzer <snitzer@gmail.com> wrote:
> > > > Under 2.6.22.16, I physically pulled a SATA disk
> > (/dev/sdac, connected to
> > > > an aacraid controller) that was acting as the local raid1
> > member of
> > > > /dev/md30.
> > > >
> > > > Linux MD didn't see an /dev/sdac1 error until I tried
> > forcing the issue by
> > > > doing a read (with dd) from /dev/md30:
> > ....
> > > The raid1d thread is locked at line 720 in raid1.c
> > (raid1d+2437); aka
> > > freeze_array:
> > >
> > > (gdb) l *0x0000000000002539
> > > 0x2539 is in raid1d (drivers/md/raid1.c:720).
> > > 715              * wait until barrier+nr_pending match nr_queued+2
> > > 716              */
> > > 717             spin_lock_irq(&conf->resync_lock);
> > > 718             conf->barrier++;
> > > 719             conf->nr_waiting++;
> > > 720             wait_event_lock_irq(conf->wait_barrier,
> > > 721
> > conf->barrier+conf->nr_pending ==
> > > conf->nr_queued+2,
> > > 722                                 conf->resync_lock,
> > > 723
> > raid1_unplug(conf->mddev->queue));
> > > 724             spin_unlock_irq(&conf->resync_lock);
> > >
> > > Given Tanaka-san's report against 2.6.23 and me hitting
> > what seems to
> > > be the same deadlock in 2.6.22.16; it stands to reason this affects
> > > raid1 in 2.6.24-rcX too.
> >
> > Turns out that the aacraid driver in 2.6.22.x is HORRIBLY BROKEN (when
> > you pull a drive); it responds to MD's write requests with uptodate=1
> > (in raid1_end_write_request) for the drive that was pulled!  I've not
> > looked to see if aacraid has been fixed in newer kernels... are others
> > aware of any crucial aacraid fixes in 2.6.23.x or 2.6.24?
> >
> > After the drive was physically pulled, and small periodic writes
> > continued to the associated MD device, the raid1 MD driver did _NOT_
> > detect the pulled drive's writes as having failed (verified this with
> > systemtap).  MD happily thought the write completed to both members
> > (so MD had no reason to mark the pulled drive "faulty"; or mark the
> > raid "degraded").
> >
> > Installing an Adaptec-provided 1.1-5[2451] driver enabled raid1 to
> > work as expected.
> >
> > That said, I now have a recipe for hitting the raid1 deadlock that
> > Tanaka first reported over a week ago.  I'm still surprised that all
> > of this chatter about that BUG hasn't drawn interest/scrutiny from
> > others!?
> >
> > regards,
> > Mike
> >
>
