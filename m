From: Rick Stevens <rstevens@vitalstream.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Tue, 09 Apr 2002 18:16:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CB39285.8000609@vitalstream.com>
References: <OF8B2F3581.590066BE-ONC1256B95.0068B28C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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

