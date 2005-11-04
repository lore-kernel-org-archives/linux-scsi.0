From: "Timothy Thelin" <Timothy.Thelin@wdc.com>
Subject: RE: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Fri, 4 Nov 2005 10:30:44 -0800
Message-ID: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wdscexfe02.sc.wdc.com ([129.253.170.52]:15025 "EHLO
	wdscexfe02.sc.wdc.com") by vger.kernel.org with ESMTP
	id S1750795AbVKDSau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2005 13:30:50 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

> 
> On Thu, Nov 03, 2005 at 11:08:07PM -0500, James Bottomley wrote:
> > On Wed, 2005-11-02 at 15:45 -0800, Matthew Dharm wrote:
> > > On Wed, Nov 02, 2005 at 02:18:52PM -0800, Timothy Thelin wrote:
> > > > 
> > > > If you had time to spare, instead of touching usb-storage,
> > > > it might be better spent resurecting SG_FLAG_LUN_INHIBIT to
> > > > stop the above behavior so that SG_IO cdbs can be passed
> > > > through untouched.
> > > > (SG_FLAG_FUN_INHIBIT was a flag SG_IO used to support a long
> > > > time ago, and I have no idea why it was dropped, but it was)
> > > 
> > > I didn't realize that had been removed.  Anyone that sends a
> > > vendor-specific command to a device needs this flag to 
> make sure it goes
> > > through unmangled.
> > > 
> > > Perhaps someone on linux-scsi can comment on why this was 
> removed and how
> > > we might get it back?
> > 
> > I've no distinct recollection of someone removing this, but if I
> > remember correctly what it used to do, it was a hack to stop us from
> > mangling SCSI-3 CDB's.  We fixed the mid-layer not to 
> require the hack
> > by only setting the CDB[1] lun field for SCSI-1 and SCSI-2 
> devices (as
> > the standards mandate).  What's the actual problem?  No 
> SCSI-1 or SCSI-2
> > device should have any vendor specific CDBs that uses these bits in
> > CDB[1].
> 
> Unfortunately, reality appears to disagree with the last 
> "should".  I've
> personally seen devices with vendor-specific commands that 
> want to control
> CDB[1] in SCSI-2.
> 
> I didn't know it was removed; I only know what Timothy Thelin 
> told me.  Can
> we get the feature back?
> 
> Matt

And for an even more concrete example:
The CY7C68300B cypress bridge board (has various siblings as well
on their site that act very similar) implements SCSI spec 0 (ie it
doesn't claim to support any scsi spec).  Now usb-storage sees
this in inquiry, and decides to export the device as a scsi2 device
since based on the usb-storage devs' experience most usb devices
really want scsi2 cdbs.  So SCSI core thinks this is a scsi2 device
and procedes to mangle the cdbs as they're going through.

The problem then is with vendor specific commands as SCSI core
mangles those as well.  The vendor specific command I had issues
with is the "ATACB" ATA passthru cdb that cypress boards understand.
CDB[1] is a signature byte that must be 0x24.  Needless to say,
that leading 2 gets masked off to a 0, and the drive aborts the
ATACB.  Now cypress could have been smarter about designing their
cdb, but they wern't, and so there really needs to be a way to tell
SCSI core "hands off the cdb".

This is also going to be an issue with USB devices that implement
SAT passthru but state they implement SCSI spec 0, as SAT passthru
CDB[1] can't afford to be mangled either.

I started this conversation a little over a month ago, but it died.
http://marc.theaimsgroup.com/?l=linux-scsi&m=112714917116713&w=2

Regards,
Tim Thelin





