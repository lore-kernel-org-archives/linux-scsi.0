From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdMOp?= <emmanuel.fuste@laposte.net>
Subject: Re: [PATCH, RFC] aic7xxx: semaphore to completion conversion
Date: Mon,  6 Feb 2006 19:54:18 +0100
Message-ID: <IUA4II$3F4AAED9C5EA841518A976F4A94EBADF@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:20106 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S932183AbWBFSze convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 13:55:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch <hch@lst.de>
Cc: jejb <jejb@steeleye.com>, hare <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, "emmanuel.fuste" <emmanuel.fuste@laposte.net>

> On Tue, Jan 31, 2006 at 06:20:18PM +0100, Christoph Hellwig
wrote:
> > switch eh_sem to a completion.  due to
wait_for_completion_timeout this
> > also nicely simplifies the code.  Unfortunately it's
untested, so if
> > someone with the hardware could give it a try that would
be nice.  Once
> > it works the same thing can be applied to aic79xx.
>=20
> New version that switches to the common onstack completion
and just a
> pointer in the platform_data struct idiom.  This gets rid of
all the
> flags fiddling.
>=20
>=20
Tested and work.
But now (with this patch or the previous one) if I apply the
'Overlapped command error handling' fix, the kernel never
recover and a few second later completely freeze (keyboard
led, network activity ...).
It's like that with a queue depth of 2, one slot is stuck and
the driver continue to work with the second one (with big
delays like timeouts).
Will retry in console mode to try to catch somme messages.

Emmanuel.

Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
