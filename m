From: Andries.Brouwer@cwi.nl
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sat, 26 Apr 2003 23:44:10 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:33670 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263082AbTDZVcO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 17:32:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: mdharm-scsi@one-eyed-alien.net
Cc: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

[[problem solved, we understand the hardware, it seems,
now wish to find an elegant way of doing what is required
(and only what is required) in the scsi and/or usb storage code]]

(1) usb-storage is broken in the sense that it uses sr_bufflen
for the transfer size instead of the buffer length, then fudges
commands to make them transfer a different length, but without
updating sr_bufflen.

(1A)
Of course it is bad when variables have a function that differs
from what is suggested by their name. So, sr_bufflen must be
the length of the buffer and nothing else. If the length of
the transfer is needed, there must be a field sr_xferlen or so.

(1B)
Of course it is bad when usb-storage fudges commands.

(2) Also other parts of the kernel do this translation,
so there is a lot of duplication; see for example
the idescsi_transform code in ide-scsi.c.

Lazy as I am I had hoped that I would find the right setup
in my mailbox. But upon returning I see essentially two replies:

(a) Matt tells about sr_bufflen.
(b) Alan says that changing must be avoided when possible.
Of course I agree. (By the way, he says among other things
"The SCSI midlayer could try multiple forms of MODE_SENSE", but
that happens already.)

So I made a patch, but will only describe it since it is long,
and I am not quite happy yet, as you will see below.

The first part, in drivers/usb/storage/scsiglue.c is very
satisfactory:

-
-#define USB_STOR_SCSI_SENSE_HDRSZ 4
-#define USB_STOR_SCSI_SENSE_10_HDRSZ 8
-
-struct usb_stor_scsi_sense_hdr
-{
-  __u8* dataLength;
-  __u8* mediumType;
...
-       }
-    }
-
-  /* Set value of length passed in */
-  *length_p = length;
-}
-

(496 lines deleted). That is a good start.
If we do not fudge commands in usb-storage, then a lot of fudging code
can go.

The next part, in drivers/usb/storage/protocol.c, is almost
as satisfactory:

...
-       /* determine the correct (or minimum) data length for these commands */
-       switch (srb->cmnd[0]) {
-
-               /* change MODE_SENSE/MODE_SELECT from 6 to 10 byte commands */
-       case MODE_SENSE:
-       case MODE_SELECT:
-               /* save the command so we can tell what it was */
-               old_cmnd = srb->cmnd[0];
...
-               /* change READ_6/WRITE_6 to READ_10/WRITE_10, which
-                * are ATAPI commands */
-       case WRITE_6:
-       case READ_6:
-               srb->cmnd[11] = 0;
-               srb->cmnd[10] = 0;
...

(deleted some 200 lines changing READ_6 into READ_10, etc.)

These lines can be deleted because the SCSI layer does not send
such commands. (What about sg you ask? I don't care. People who
send commands "by hand" are responsible themselves. Moreover, it
is really bad when these handcrafted commands are changed by the
driver - probably they were intended precisely as written.)

Why doesnt SCSI send READ_6/WRITE_6? Because there is a field "ten"
that is initially 1 and says that READ_10 must be used. It will be
cleared only when the device returns ILLEGAL_REQUEST.

I dislike the choice of identifier "ten" - it is difficult to grep for,
and I changed it into use_10_for_rw, with the same function as before.
Added a field use_10_for_ms. Thus, in scsi.h:

+       unsigned use_10_for_rw:1; /* first try 10-byte read / write */
+       unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */

in the declaration of struct scsi_device.

Now sd_do_mode_sense6() becomes sd_do_mode_sense() and does

+       if (SRpnt->sr_device->use_10_for_ms) {
+               if (len < 8)
+                       len = 8;
+
+               cmd[0] = MODE_SENSE_10;
+               cmd[8] = len;
+       } else {
+               if (len < 4)
+                       len = 4;
+
+               cmd[0] = MODE_SENSE;
+               cmd[4] = len;
+       }

(and its first parameter can go).

All this is nice and well. Remains the question how usb-storage
makes sure that the use_10_for_rw and use_10_for_ms flags are set
for its devices.

Tonight I kludged this by setting this (in protocol.c) at the moment
the first INQUIRY is done. But that is terribly ugly.
Did I overlook some obvious means of communication?

Comments?

Andries
