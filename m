From: "Guy" <bugzilla@watkins-home.com>
Subject: cpio problems with SCSI tape drive
Date: Thu, 27 May 2004 02:17:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200405270617.i4R6HBB08441@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([216.148.227.85]:13440 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S261451AbUE0GRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 02:17:13 -0400
Received: from astroboy (astroboy.watkins-home.com [192.168.0.8])
	by www.watkins-home.com (8.11.6/8.11.6) with ESMTP id i4R6HBB08441
	for <linux-scsi@vger.kernel.org>; Thu, 27 May 2004 02:17:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I think this is the wrong place to ask.
If someone could direct me to the correct place, thanks.

Anyway, it is a SCSI tape drive! :)

I am doing a cpio backup.  I get end of tape.  I knew the data would not fit
on 1 tape.
It takes 2-4 hours before EOT.
This is what happens:
================================================
Found end of tape.  To continue, type device/file name when ready.
/dev/nst0
To continue, type device/file name when ready.
/dev/nst0
To continue, type device/file name when ready.
nst0
Found end of tape.  To continue, type device/file name when ready.
================================================

It ejected the full tape.
I gave it another tape before I typed /dev/nst0
The tape is good, I have been trying different things using 3 different
tapes.
I can read the first tape, so I think everything went well until after end
of tape.
I have tried:
/dev/st0
st0
/dev/nst0
nst0

I have also just typed enter without a device/file name.  cpio just
exits/aborts.
When I typed "nst0" I got a 2 Gig file named "/nst0".
So, it seems the problem is re-using the tape drive.
I typed "nst1" and got another 2 Gig file.

Maybe a clue:  While cpio is waiting for me to type the "device/file name"
the tape drive is busy.  From another shell/window I tried to list the
contents of another tape.  I could not, I got this error: "/dev/nst0: Device
or resource busy".  Maybe cpio gets the same error (without reporting it)
and just prompts for another tape.  Maybe cpio needs to close the tape
before asking for another?  Even after cpio writes to the files "/nst0" and
"/nst1" the tape drive is still busy!  The 2 files "/nst0" and "/nst1" are
not locked.  I have overwritten and deleted them.  The disk space has been
freed.

This happens every time.  But takes 2-4 hours to re-produce.
This is part of the script:
TAPE=/dev/nst0
mt -f $TAPE rewind
cd /
find root BigFS -depth| cpio -o --format=newc --block-size=128 > $TAPE
mt -f $TAPE eject

This is a RedHat 9 system.  Up to date confirmed 1-2 days ago using:
apt-get update
apt-get upgrade
apt-get dist-upgrade

No updates were needed.

Kernel 2.4.20-8smp
GNU cpio version 2.5

Any ideas?

Thanks,
Guy


