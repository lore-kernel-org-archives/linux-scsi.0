From: <random1@o-o.yi.org>
Subject: aic7xxx_core.c panic "Loop 1"
Date: 19 Jul 2002 15:40:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <uznwn33rq.fsf@o-o.yi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from list by main.gmane.org with local (Exim 3.33 #1 (Debian))
	id 17Vdbx-0001mq-00
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jul 2002 21:40:21 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I've seen this panic on occasion -- it happened several times in a row
trying to boot a rescue 2.4 kernel from floppy, in fact, after which I
just gave up and reinstalled on a new partition.  It seems to always
happen on boot.

Now I'm trying to get SCSI to play with ACPI and suspend-to-disk, and
this is happening during resume.  I'm perfectly willing to believe
that it is because of all the under-the-covers memory-munging that
suspend and resume do, but fixing it requires a *clue* about what it's
_supposed_ to do :)

in ahc_search_qinfifo() ..
	while (qinpos != qintail) {
		scb = ahc_lookup_scb(ahc, ahc->qinfifo[qinpos]);

        scb is NULL, and hence the driver panics.

I'm not sure what the underlying invariant is supposed to be, and
can't find that documented anywhere.  Pointers to TFM would be
appreciated.  As would tips on what might be going wrong and what to
look for.  I'm using a 2.5.24 kernel, though I don't think this code
has changed recently.

Thanks for any help you can provide.


