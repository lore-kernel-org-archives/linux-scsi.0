From: berthiaume_wayne@emc.com
Subject: RE: [RFC] Persistent naming of scsi devices
Date: Wed, 10 Apr 2002 10:28:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049BF8D0@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: rstevens@vitalstream.com
Cc: linux-scsi@vger.kernel.org

	Actually, it would be easier to control if it uses its actual PCI
slot number, for example c2 for the second slot, as opposed to c2 for the
second SCSI controller. This would be easier to implement and would be
"persistent" as long as the controller is not moved. Doing it in the manner
you suggest would not provide persistence but revert to the order of
discovery we already have with a different naming convention. Doesn't seem
like a wise alternative. The intention of the CTDL nomenclature is to
provide precise device targeting without the BS mapping to some arbitrarily
named device table. In DG/AViiON, more precisely DG/UX, it was CTDL based
but then mapped to a device mneumonic in the devtable. Devices were named in
the system config file by their long name (CTDL) and linked in the devtable
to its short name, for example /dev/pdsk/sd0 for the buffered SCSI disk and
/dev/rpdsk/sd0 for the raw SCSI disk. We used different SCSI controllers but
this didn't present a problem because, they were placed in the kernel config
file. If the Ciprico was in slot 0 and in the kernel's spec file, it's long
name was entered into the devtable and linked at boot to the short name
/dev/pdsk/sd0. Conversely, if the Adaptec was in slot 0 and configured into
the kernel spec file, its long name would be entered into the devtable and
linked to the /dev/pdsk/sd0 short name.
Wayne
EMC Corp
Centera Engineering
4400 Computer Drive
M/S F213
Westboro,  MA    01580

email:       Berthiaume_Wayne@emc.com

"One man can make a difference, and every man should try."  - JFK


-----Original Message-----
From: Rick Stevens [mailto:rstevens@vitalstream.com]
Sent: Tuesday, April 09, 2002 9:17 PM
To: linux-scsi@vger.kernel.org
Subject: Re: [RFC] Persistent naming of scsi devices


Martin Peschke3 wrote:

<much stuff snipped>

I'm going to wade in here.  Based on my experiences on many other
Unixish systems, wouldn't it be simply better to number the things
based on controller position, SCSI ID, LUN and partition?  This
has been called "CTL" format in various documents, and many systems
use this method such as Sun, DG AvIIons, DEC, HP and a host of others.

E.g. "/dev/dsk/c0t1d2s3" is controller 0 (first SCSI controller seen on
the bus), target ID 1, LUN 2, partition (slice) 3.  Simple, unambiguous
and repeatable.

I understand that other devices may be seen on the PCI if you add or
remove cards.  Under this scheme, controller 0 is the first (lowest
slot number) unit found.  The next one would be controller 1.  Even
if you were to stuff, say, a video card in there, these would _still_
be the first SCSI cards found.  The only time a change would occur
is if a SCSI card was installed in a lower slot number or between
other SCSI controllers (and only then if the original cards were
left in) or if the ORDER of the cards was changed in the bus.

As I said, other people smarter than I seem to think it makes sense.
Why not Linux?  It's silly to smush things together just to satisfy a
bizzare craving to have a list of devices with no "holes" in it.
Besides "fsck"ing or "mkfs"ing drives, how often do you refer to them
by their names in "/dev", anyway?

This would also work for tape drives.  However, they're rooted at
/dev/stape rather than /dev/dsk.

At boot, you could create more mnemonic names as symbolic links to the
CTL names if you wish (as is done with /dev/cdrom and such), but if
you absolutely want to talk to the SAME DEVICE, you use the CTL name.

Just adding my $0.02.  We now return you to your regularly scheduled
arguments.

----------------------------------------------------------------------
- Rick Stevens, SSE, VitalStream, Inc.      rstevens@vitalstream.com -
- 949-743-2010 (Voice)                    http://www.vitalstream.com -
-                                                                    -
-          su -; find / -name someone -exec touch \{\} \;            -
-                          - The UNIX way of touching someone        -
----------------------------------------------------------------------

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
