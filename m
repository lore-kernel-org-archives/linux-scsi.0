From: "Heinz, Michael" <mheinz@infiniconsys.com>
Subject: RE: Configuring the device_list in scsi_scan.c
Date: Thu, 30 May 2002 20:10:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <08628CA53C6CBA4ABAFB9E808A5214CB0C4D55@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: linux-scsi@vger.kernel.org

And I want to do that for each of, say, 128 devices, that may or may not
be plugged in that day? It would be better to get the midlayer to scan
for devices.

The correct fix is to have the mid layer support the REPORT_LUNS
command; but that's a major change - and probably wouldn't get into 2.4
as a patch - which is why I proposed this instead.

--
Michael Heinz
Infinicon Systems, Inc.
http://www.infiniconsys.com 

> -----Original Message-----
> From: Matthew Dharm [mailto:mdharm-scsi@one-eyed-alien.net]
> Sent: Thursday, May 30, 2002 5:48 PM
> To: Heinz, Michael
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: Configuring the device_list in scsi_scan.c
> 
> 
> Umm... doesn't this already exist?
> 
> echo 'scsi add-single-device <bus> <channel> <target> <lun>' 
> > /proc/scsi/scsi
> 
> Matt
> 
> On Thu, May 30, 2002 at 05:18:29PM -0400, Heinz, Michael wrote:
> > We just ran into an issue where the RAID array we purchased 
> didn't quite
> > work with Linux, because only the first LUN was visible (Red Hat
> > 2.4.7-10).
> > 
> > I patched the kernel by adding the array to the device_list in
> > scsi_scan.c, but that seems obnoxious. It occurs to me that 
> it would be
> > straight forward to modify scsi.c and scsi_scan.c so that you could
> > write to /proc/scsi/scsi and add new entries to the 
> device_list; and a
> > module parameter that would let you add a single new entry to the
> > device_list right at load time.
> > 
> > Before I start fighting with my boss over whether I have 
> time to write
> > patches for the linux kernel - does this fix make sense?
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Matthew Dharm                              Home: 
> mdharm-usb@one-eyed-alien.net 
> Maintainer, Linux USB Mass Storage Driver
> 
> A:  The most ironic oxymoron wins ...
> DP: "Microsoft Works"
> A:  Uh, okay, you win.
> 					-- A.J. & Dust Puppy
> User Friendly, 1/18/1998
> 
