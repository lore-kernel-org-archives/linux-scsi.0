From: Andries.Brouwer@cwi.nl
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 11:08:12 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304240908.h3O98Cw29064.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:42737 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S261855AbTDXJAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 05:00:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, mdharm-scsi@one-eyed-alien.net
Cc: James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com

    From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>

    > Comments?

    My only comment is that your sample of failed cases primarily seems to
    address those devices that support some variant of MODE_SENSE -- there are
    lots of devices that don't support it at all, which is why I wanted to
    filter it with the (apparently) now-dead command filter concept.

Well, before we create a new infrastructure it is a good idea
to make sure that it is needed. James mentioned three cases
in Bugzilla and it looks like these are fixed by a small correction
to the MODE_SENSE to MODE_SENSE_10 translation.

You mention lots of devices that don't support MODE_SENSE at all.
Do you have Bugzilla or l-k / l-s / l-u refs?

(Smart Media and similar cards come with a write protect bit.
I would suppose reporting it is supported by most non-broken hardware.
We get it from the header of the MODE_SENSE return value.
So there is some reason to expect that MODE_SENSE[_10] is supported,
at least in the minimum form where no page but only the header
is returned. Closer investigation of other error cases might reveal
more usb-storage flaws.)

Andries
