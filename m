From: Andries.Brouwer@cwi.nl
Subject: Re: [usb-storage] Re: 2 PATCHES: fix request_tranferlength
Date: Sun, 28 Jul 2002 00:48:03 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200207272248.g6RMm3h14110.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mdharm-scsi@one-eyed-alien.net, usb-storage@one-eyed-alien.net

    I haven't seen these patches integrated into a kernel yet... have I just
    missed them, or is there some reason they have been rejected?

    > +++ b/drivers/scsi/scsi_scan.c    Sun Jul 21 00:55:37 2002
    > -              256, SCSI_TIMEOUT+4*HZ, 3);
    > +              scsi_cmd[4], SCSI_TIMEOUT+4*HZ, 3);

    > +++ b/drivers/scsi/sd.c    Sun Jul 21 00:55:44 2002
    > -              512, SD_TIMEOUT, MAX_RETRIES);
    > +              255, SD_TIMEOUT, MAX_RETRIES);

There are many more possibilities.
Since the number of hours in a day is very finite, Linus cannot
look at everything, so even if the patch is perfect it can be ignored.

There is not really a SCSI maintainer, but there are people that are
well-known as active in the SCSI area. You may try to submit via
one of them.

But then the question is whether these are good patches.

I booted 2.5.29 earlier this evening and was greeted by
kernel BUG at transport.c: 351 and
kernel BUG at scsiglue.c: 150.
(And the usb-storage module now hangs initializing; rmmod fails,
reboot is necessary.)

The former BUG_ON wants to have len == srb->request_bufflen.
But I don't know whether that is wise. It is less confusing
when bufflen indicates the size of the buffer available,
rather than the number of bytes you expect to move.
It is not unusual to get one byte more than you asked for,
in case you ask for an odd number of bytes.

So, maybe these patches aren't clear improvements.

Andries
