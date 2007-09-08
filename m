From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-storage and Motorola Z6
Date: Sat, 8 Sep 2007 16:32:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709081617201.4819-100000@netrider.rowland.org>
References: <46E2C8FB.4090003@udgaard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
In-Reply-To: <46E2C8FB.4090003@udgaard.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: Peter Rasmussen <plr@udgaard.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB users list <linux-usb-users@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Sat, 8 Sep 2007, Peter Rasmussen wrote:

> > In fact there was another patch from earlier in the email thread, which 
> > was needed to work around the PQ = 1 problem.  Since you didn't apply 
> > that patch, the SCSI disk driver wasn't bound to your Z6.
> >
> >   
> Now I applied that patch, too, and it did make a difference, in drivers/scsi/scsi_sysfs.c I have:
> 
> static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
> {
>         struct scsi_device *sdp = to_scsi_device(dev);
>         if (sdp->no_uld_attach)
>                 return 0;
>         return 1;
> //      return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
> }

Did you also make the change to usb-storage for ignoring wrong Tag 
values?

> Before posting a lot of USB debug output, I'll explain a shorter version :-)
> 
> 1.After reboot I connected the Z6 (incl. a micro-SD card) and got
> what looked good, if not the usual output from dmesg:
> 
> <snip>
> scsi 0:0:0:0: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
> <snip>
> sd 0:0:0:0: [sda] Attached SCSI removable disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> <snip>
> scsi 0:0:0:1: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
> <snip>
> sd 0:0:0:1: [sdb] Attached SCSI removable disk
> sd 0:0:0:1: Attached scsi generic sg1 type 0
> <snip>

Evidently the phone didn't report that the micro-SD card was present.  
Otherwise you would have seen log entries describing the number of
sectors and the write-protect status.

> 2.I could then mount the SCSI devices like this:
> 
> # mount /dev/sda /mnt/usb
> # mount /dev/sdb /mnt/usb2
> 
> When I normally with a USB mass storage device do, eg.:
> 
> # mount /dev/sda1 /mnt/usb
> 
> 3.I couldn't however, always mount the mentioned devices as I would
> sometimes get a 'mount: No medium found' error, and a message on the
> mobile will sometimes show "USB connected" and sometimes "USB
> disconnected" even though it didn't seem to correlate to successful
> connection between my PC and the Z6.
> 
> 4.So, something seems to be inconsistent. I have tried it with a few
> different cables and I can't detect a difference.
> 
> 5.Should I post a full log of eg. connecting the Z6, mounting it and the SD card, accessing it and then unmounting? 
>   A full log may then include failed attempts, which will perhaps give some hints at what is wrong?
>   Or do you already have a pretty good idea as to what is wrong, and find that such an exercise is not really useful?

If you want to post a log, include only the initial connection and one 
failed mount attempt.  Also, you can remove linux-scsi from the CC: 
list above, since this bug no longer involves any SCSI-level issues.

> > :-)  There's no necessary relation between the OS running on a device
> > like your phone and its interoperability with computers running the
> > same OS.
> >
> >   
> Well, I would have expected that they have similar methods to
> connect, even though different Linux kernel version of course may
> have introduced some differences. My A780 has a 2.4.20 kernel and I
> wouldn't be surprised if other Motorola mobiles also use the 2.4.*
> series of Linux kernels.

Not at all -- the methods used for connecting are _completely_
different, because the phone connects as a peripheral whereas the
kernel expects to connect as a host.

> >> And you say that this seems to be a more widespread problem with 
> >> Motorola devices? Do you remember which ones, and do they run Linux as well?
> >>     
> >
> > There were two problems.  First was the PQ = 1 problem; I have never
> > seen it before now (so only on the Z6).  The other problem was the
> > capacity, or last sector number; we know that the RAZR V3i and V3x both
> > suffer from it as well.  (I have no idea whether they run Linux.)  
> > Possibly other devices do too, and we just don't know about them.

Plus the third (incorrect Tags) problem, which I forgot to mention
earlier.

> I know that those two don't run Linux, but can they connect to a
> Linux host, or do they also have problems?

They can connect to a Linux host with no problem, now that the 
appropriate quirks entries have been created.

Alan Stern


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
