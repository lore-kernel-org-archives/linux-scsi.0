From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Add udev-md-raid-safe-timeouts.rules
Date: Mon, 16 Apr 2018 13:33:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1804161326480.1398-100000@iolanthe.rowland.org>
References: <CAJCQCtRzmBys+eYsd=zsAK1deYQt47nysHQBdn3CreOmObz59g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtRzmBys+eYsd=zsAK1deYQt47nysHQBdn3CreOmObz59g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, linux-lvm@redhat.com, Linux-RAID <linux-raid@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 16 Apr 2018, Chris Murphy wrote:

> Adding linux-usb@ and linux-scsi@
> (This email does contain the thread initiating email, but some replies
> are on the other lists.)
> 
> On Mon, Apr 16, 2018 at 5:43 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> > On 2018-04-15 21:04, Chris Murphy wrote:
> >>
> >> I just ran into this:
> >>
> >> https://github.com/neilbrown/mdadm/pull/32/commits/af1ddca7d5311dfc9ed60a5eb6497db1296f1bec
> >>
> >> This solution is inadequate, can it be made more generic? This isn't
> >> an md specific problem, it affects Btrfs and LVM as well. And in fact
> >> raid0, and even none raid setups.
> >>
> >> There is no good reason to prevent deep recovery, which is what
> >> happens with the default command timer of 30 seconds, with this class
> >> of drive. Basically that value is going to cause data loss for the
> >> single device and also raid0 case, where the reset happens before deep
> >> recovery has a chance. And even if deep recovery fails to return user
> >> data, what we need to see is the proper error message: read error UNC,
> >> rather than a link reset message which just obfuscates the problem.
> >
> >
> > This has been discussed at least once here before (probably more times, hard
> > to be sure since it usually comes up as a side discussion in an only
> > marginally related thread).  Last I knew, the consensus here was that it
> > needs to be changed upstream in the kernel, not by adding a udev rule
> > because while the value is technically system policy, the default policy is
> > brain-dead for anything but the original disks it was i9ntended for (30
> > seconds works perfectly fine for actual SCSI devices because they behave
> > sanely in the face of media errors, but it's horribly inadequate for ATA
> > devices).
> >
> > To re-iterate what I've said before on the subject:
> >
> > For ATA drives it should probably be 150 seconds.  That's 30 seconds beyond
> > the typical amount of time most consumer drives will keep retrying a sector,
> > so even if it goes the full time to try and recover a sector this shouldn't
> > trigger.  The only people this change should negatively impact are those who
> > have failing drives which support SCT ERC and have it enabled, but aren't
> > already adjusting this timeout.
> >
> > For physical SCSI devices, it should continue to be 30 seconds.  SCSI disks
> > are sensible here and don't waste your time trying to recover a sector.  For
> > PV-SCSI devices, it should probably be adjusted too, but I don't know what a
> > reasonable value is.
> >
> > For USB devices it should probably be higher than 30 seconds, but again I
> > have no idea what a reasonable value is.
> 
> I don't know how all of this is designed but it seems like there's
> only one location for the command timer, and the SCSI driver owns it,
> and then everyone else (ATA and USB and for all I know SAN) are on top
> of that and lack any ability to have separate timeouts.

As far as mass-storage is concerned, USB is merely a transport.  It 
doesn't impose any timeout rules; the appropriate timeout value is 
whatever the device at the end of the USB link needs.  Thus, a SCSI 
drive connected over USB could use a 30-second timeout, an ATA drive 
could use 150 seconds, and so on.

Unfortunately, the only way to tell what sort of drive you've got is by
looking at the Vendor/Product IDs or other information provided by the
drive itself.  You can't tell anything just from knowing what sort of
bus it's on.

Alan Stern

> The nice thing about the udev rule is that it tests for SCT ERC before
> making a change. There certainly are enterprise and almost enterprise
> "NAS" SATA drives that have short SCT ERC times enabled out of the box
> - and the udev method makes them immune to the change.

