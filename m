From: Andries.Brouwer@cwi.nl
Subject: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 00:39:28 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:32738 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S264286AbTDWW2B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2003 18:28:01 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com

Yesterday or so we discussed three people's problems with USB devices.
Today a fourth very similar complaint was reported.

I asked

> Could you try this patch of drivers/scsi/sd.c?
>
> --- sd.c~       Sun Apr 20 12:59:32 2003
> +++ sd.c        Wed Apr 23 21:45:10 2003
> @@ -1079,6 +1079,9 @@
>                   int dbd, int modepage, unsigned char *buffer, int len) {
>         unsigned char cmd[8];
>
> +       if (len < 8)
> +               len = 8;
> +
>         memset((void *) &cmd[0], 0, 8);
>         cmd[0] = MODE_SENSE;
>         cmd[1] = dbd;

and got the reply

#
# Wohoo! Patch worked like a charm. Thanks Andries!
#

So, for the time being I assume we know what is causing
these problems. It would be nice if the other three
(afafc@rnl.ist.utl.pt, mike@hingston.demon.co.uk, stelian@popies.net)
could report on their experiences with the above patch.

The next question is whether this is a bug in these devices
or a bug in the usb-storage code.

As Alan remarked, drivers/usb/storage/protocol.c contains
the fragment

        case MODE_SENSE:
                srb->cmnd[8] = 8;

But that is in usb_stor_ufi_command(), and
usb_stor_transparent_scsi_command() doesn't do this.
Nevertheless, MODE_SENSE has minimum length 4, and
MODE_SENSE_10 has minum length 8 for its reply.
So, possibly the latter routine should do something
similar. For example

--- protocol.c~ Fri Nov 22 22:40:13 2002
+++ protocol.c  Thu Apr 24 00:38:31 2003
@@ -366,6 +366,8 @@
                        srb->cmnd[2] = srb->cmnd[2];
                        srb->cmnd[1] = srb->cmnd[1];
                        srb->cmnd[0] = srb->cmnd[0] | 0x40;
+                       if (srb->cmnd[8] < 8)
+                               srb->cmnd[8] = 8;
                        break;
                } /* switch (srb->cmnd[0]) */
        } /* if (us->flags & US_FL_MODE_XLATE) */

(yes, ugly, no guarantee that the buffer is large enough).

Comments?

Andries
