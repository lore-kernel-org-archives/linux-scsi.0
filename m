From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: 26 Apr 2003 17:29:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051396197.1768.81.camel@mulgrave>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:13830 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263104AbTDZWSD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 18:18:03 -0400
In-Reply-To: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: mdharm-scsi@one-eyed-alien.net, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net

On Sat, 2003-04-26 at 16:44, Andries.Brouwer@cwi.nl wrote:
> [[problem solved, we understand the hardware, it seems,
> now wish to find an elegant way of doing what is required
> (and only what is required) in the scsi and/or usb storage code]]
> 
> (1) usb-storage is broken in the sense that it uses sr_bufflen
> for the transfer size instead of the buffer length, then fudges
> commands to make them transfer a different length, but without
> updating sr_bufflen.

definitely agreed.

> (1A)
> Of course it is bad when variables have a function that differs
> from what is suggested by their name. So, sr_bufflen must be
> the length of the buffer and nothing else. If the length of
> the transfer is needed, there must be a field sr_xferlen or so.

This looks fine to me.  Originally, sr_bufflen was exactly that (because
all SCSI LLDs have to be prepared to transfer fewer than the specified
number of bytes anyway, since that's required by the spec).  I believe
only USB needs this to be set to the actual command length (and further
require that we ensure that the device *will* transfer exactly
this...that's to some extent the origin of the INQUIRY problems), so the
change should be small.

[...]

> I dislike the choice of identifier "ten" - it is difficult to grep for,

agreed.

> and I changed it into use_10_for_rw, with the same function as before.
> Added a field use_10_for_ms. Thus, in scsi.h:
> 
> +       unsigned use_10_for_rw:1; /* first try 10-byte read / write */
> +       unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
> 
> in the declaration of struct scsi_device.
> 
> Now sd_do_mode_sense6() becomes sd_do_mode_sense() and does

This looks good (probably this should go in scsi_lib.c and sr should
start using it for consistency).

> All this is nice and well. Remains the question how usb-storage
> makes sure that the use_10_for_rw and use_10_for_ms flags are set
> for its devices.

Well, this should be done in the USB storage slave_configure...that's
almost exactly what the interface is designed for (altering scsi_device
parameters before the SCSI subsystem starts using it).

> Tonight I kludged this by setting this (in protocol.c) at the moment
> the first INQUIRY is done. But that is terribly ugly.
> Did I overlook some obvious means of communication?
> 
> Comments?

This sounds to be exactly the right approach (other than the missing
slave_configure).

James


