From: Andries.Brouwer@cwi.nl
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 17:21:07 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304241521.h3OFL7e14246.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:23285 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263761AbTDXPWd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 11:22:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, stern@rowland.harvard.edu
Cc: Andries.Brouwer@cwi.nl, afafc@rnl.ist.utl.pt, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, pwkpete@yahoo.com, stelian@popies.net

# the better solution might be to enforce a minimum transfer length

> You probably already know this, but I'll point it out anyway.  The 
> protocol.c file contains 4 different translation routines:
>
>        usb_stor_qic157_command(),
>        usb_stor_ATAPI_command(),
>        usb_stor_ufi_command(),
>        usb_stor_transparent_scsi_command().
>
> The third one already contains the 4->8 modification and your patch adds 
> it to the fourth.  But it's still missing from the first two.

Yes indeed. I am not yet so far as James - still want to
understand everything before discussing the correct patch.

My theory was: MODE_SENSE returns 4 bytes minimum, MODE_SENSE_10
returns 8 bytes minimum, devices start returning the header and then
look how much more is desired.

Thus, we should never ask for less than 4 bytes with MODE_SENSE,
and never for less than 8 bytes with MODE_SENSE_10.

Since usb-storage translates MODE_SENSE into MODE_SENSE_10
(and does not necessarily change the requested length)
it may be a good idea [for testing] not to ask for less than 8 bytes.

(On the other hand, there are many examples of devices that react badly
when asked for more than is available, so we should not ask for
8 bytes with untranslated MODE_SENSE.)

So far the theory. I asked people to try adding
	if (len < 8)
		len = 8;
in the scsi code, and everybody reported success.

That is good. But there is one point I do not understand.
Stelian Pop reports on two devices, both US_SC_UFI.
But usb_stor_ufi_command() already contained code to
make the length 8. How can it be that my sd.c change
improved things?

Can it be that earlier tests were for 2.5.67 and later tests
for 2.5.68, and Matt's improvements of the latter over the former
are the real reason of improved behaviour?

Andries

[In other words, afafc@rnl.ist.utl.pt, mike@hingston.demon.co.uk,
pwkpete@yahoo.com, stelian@popies.net: did you compare 2.5.68
without and with this "if (len < 8) len = 8" patch?]

