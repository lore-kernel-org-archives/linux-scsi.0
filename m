From: Andries.Brouwer@cwi.nl
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 21:30:59 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304221930.h3MJUxI21015.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:50115 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263397AbTDVTU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 15:20:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, stern@rowland.harvard.edu
Cc: Andries.Brouwer@cwi.nl, afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, mike@hingston.demon.co.uk, steliam@popies.net, torvalds@transmeta.com, usb-storage@one-eyed-alien.net

James writes:

> Why is a 10 byte command given a command length of 12?
> Could this be the root cause?

Alan S. answers:

> No, most likely it's not the cause.

And I agree - here 2.4 and 2.5 do not differ.

Alan continues:

> The error is -EOVERFLOW, which means that the device tried to send back
> more data than we were prepared to receive, i.e., more than 4 bytes.

And again I agree.

That is a pity, because my 4 was arrived at by careful experimentation.
It may mean that there is no uniform length that works.
And no amount of filtering will work, unless we decide
not to use MODE_SENSE at all.

But let us first confirm the theory.

In drivers/scsi/sd.c there is a routine sd_do_mode_sense6().
The theory is that calling that with length 4 causes problems
for some devices. So, could the people with problems try to
add

	if (len < 8)
		len = 8;

directly after

static int
sd_do_mode_sense6(struct scsi_device *sdp, struct scsi_request *SRpnt,
                  int dbd, int modepage, unsigned char *buffer, int len) {
        unsigned char cmd[8];

?

(Maybe try with very large values. like 255 instead of 8, in case
8 does not help.)

Andries
