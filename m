From: =?iso-8859-1?Q?Andr=E9_Cruz?= <afafc@rnl.ist.utl.pt>
Subject: RE: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 09:05:18 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <000001c30a38$3f5ece50$040000c0@giga>
References: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com
Cc: alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com
List-Id: linux-scsi@vger.kernel.org

It worked for me.
Great! :)
I was able to mount the CF card, list it's contents, etc.
You guys are on the right track. Keep up the good work.
cya

_________________________________________
Andr=E9 Cruz
ICQ#: 9519211
_________________________________________


-----Original Message-----
From: Andries.Brouwer@cwi.nl [mailto:Andries.Brouwer@cwi.nl]=20
Sent: quarta-feira, 23 de Abril de 2003 23:39
To: James.Bottomley@steeleye.com
Cc: afafc@rnl.ist.utl.pt; alan@lxorguk.ukuu.org.uk; greg@kroah.com;
linux-scsi@vger.kernel.org; linux-usb-devel@lists.sourceforge.net;
mike@hingston.demon.co.uk; stelian@popies.net; torvalds@transmeta.com
Subject: [example PATCH - not for applying] exclude certain commands


Yesterday or so we discussed three people's problems with USB devices.
Today a fourth very similar complaint was reported.

I asked

> Could you try this patch of drivers/scsi/sd.c?
>
> --- sd.c~       Sun Apr 20 12:59:32 2003
> +++ sd.c        Wed Apr 23 21:45:10 2003
> @@ -1079,6 +1079,9 @@
>                   int dbd, int modepage, unsigned char *buffer, int =
len) {
>         unsigned char cmd[8];
>
> +       if (len < 8)
> +               len =3D 8;
> +
>         memset((void *) &cmd[0], 0, 8);
>         cmd[0] =3D MODE_SENSE;
>         cmd[1] =3D dbd;

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
                srb->cmnd[8] =3D 8;

But that is in usb_stor_ufi_command(), and
usb_stor_transparent_scsi_command() doesn't do this.
Nevertheless, MODE_SENSE has minimum length 4, and
MODE_SENSE_10 has minum length 8 for its reply.
So, possibly the latter routine should do something
similar. For example

--- protocol.c~ Fri Nov 22 22:40:13 2002
+++ protocol.c  Thu Apr 24 00:38:31 2003
@@ -366,6 +366,8 @@
                        srb->cmnd[2] =3D srb->cmnd[2];
                        srb->cmnd[1] =3D srb->cmnd[1];
                        srb->cmnd[0] =3D srb->cmnd[0] | 0x40;
+                       if (srb->cmnd[8] < 8)
+                               srb->cmnd[8] =3D 8;
                        break;
                } /* switch (srb->cmnd[0]) */
        } /* if (us->flags & US_FL_MODE_XLATE) */

(yes, ugly, no guarantee that the buffer is large enough).

Comments?

Andries



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
