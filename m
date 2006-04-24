From: Gustavo Guillermo =?utf-8?q?P=C3=A9rez?= <gustavo@compunauta.com>
Subject: Re: SCSI trow USB-STORAGE or SBP2 Debug for buggy device Kernels 2.6.X
Date: Mon, 24 Apr 2006 17:12:25 -0500
Message-ID: <200604241712.26445.gustavo@compunauta.com>
References: <200604241029.14932.gustavo@compunauta.com> <200604241630.07453.gustavo@compunauta.com> <1145916166.3528.48.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from compunauta.com ([69.36.170.169]:23500 "EHLO compunauta.com")
	by vger.kernel.org with ESMTP id S1751134AbWDXWMe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Apr 2006 18:12:34 -0400
In-Reply-To: <1145916166.3528.48.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

El Lunes, 24 de Abril de 2006 17:02, James Bottomley escribi=C3=B3:
> On Mon, 2006-04-24 at 16:30 -0500, Gustavo Guillermo P=C3=A9rez wrote=
:
> > Ok, this is what I've got.
>
> Thanks, this is interesting:
> > Apr 24 16:12:14 gusgus kernel: sr 1:0:0:0: Device not ready: <6>:
> > Current: sense key=3D0x2
> > Apr 24 16:12:14 gusgus kernel:     ASC=3D0x4 ASCQ=3D0x8
>
> That's "LU not ready; long write in progress"
>
> > This Other is cause I left the print outside the brackets, cause I =
want
> > to see on closing session.
> >
> > Apr 24 16:13:10 gusgus kernel: : Current: sense key=3D0x2
> > Apr 24 16:13:10 gusgus kernel:     ASC=3D0x3a ASCQ=3D0x0
>
> Yes, that's just medium not present.
>
> So, I could change the long write in progress to a retry.  However, I
> suspect the reason we got that return is because this device is untag=
ged
> (doesn't accept multiple commands at once) and perhaps a better fix
> might be to reduce the queue depth down to one to prevent more than o=
ne
> command being outstanding at any one time.
It would not be better to include some handling on the black list? it m=
eans=20
doing a new BLACK_CONST to handle just this special case?.


--=20
Gustavo Guillermo P=C3=A9rez
Compunauta uLinux
www.compunauta.com
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
