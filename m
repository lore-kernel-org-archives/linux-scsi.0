From: Andries.Brouwer@cwi.nl
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 20:44:23 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304221844.h3MIiNX18598.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:39864 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263336AbTDVSci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 14:32:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, stern@rowland.harvard.edu
Cc: James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, torvalds@transmeta.com, usb-storage@one-eyed-alien.net

> I believe a recent patch addressed this problem.
> the patch is documented as fixing bug #510

Very good. And see, I had no time to look at all of these
Bugzilla texts, but now that I am back and look at the sequel
for this bug #510 it turns out that it was semi-fixed.
However, the author complains

=====
I confirm that your patch makes my memory stick reader work again.

However, the usb-storage module initialisation is still slow. See the attached
traces: I modprobe usb-storage at 08:50:16, and the initialisation was not
ended until 08:50:53. Under 2.4 it takes only a few (2-3) seconds to do this...
=====

and the trace shows

=====
Apr  8 11:46:10 crusoe: usb-storage: Command MODE_SENSE (6 bytes)
Apr  8 11:46:10 crusoe: usb-storage:  1a 00 3f 00 04 00
Apr  8 11:46:10 crusoe: usb-storage: usb_stor_ctrl_transfer(): rq=00 rqtype=21 value=0000 index=00 len=12
Apr  8 11:46:10 crusoe: usb-storage: Status code 0; transferred 12/12
Apr  8 11:46:10 crusoe: usb-storage: -- transfer complete
Apr  8 11:46:10 crusoe: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Apr  8 11:46:11 crusoe: usb-storage: usb_stor_bulk_transfer_buf(): xfer 4 bytes
Apr  8 11:46:11 crusoe: usb-storage: Status code -75; transferred 4/4
Apr  8 11:46:11 crusoe: usb-storage: -- unknown error
Apr  8 11:46:11 crusoe: usb-storage: CB data stage result is 0x3
Apr  8 11:46:11 crusoe: usb-storage: -- transport indicates error, resetting
Apr  8 11:46:11 crusoe: usb-storage: CB_reset() called
=====

That is, now all three bug reports talk about the same problem.

OK. Something is wrong with MODE_SENSE, that was not yet wrong
in 2.4. If we fix that, then all bug reports mentioned so far
are covered.

[James, I saw your mail, but have not yet looked at the code.]

Andries
