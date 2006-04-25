From: Gustavo Guillermo =?iso-8859-1?q?P=E9rez?=
	<gustavo@compunauta.com>
Subject: Re: SCSI trow USB-STORAGE or SBP2 Debug for buggy device Kernels 2.6.X
Date: Tue, 25 Apr 2006 16:41:53 -0500
Message-ID: <200604251641.54084.gustavo@compunauta.com>
References: <200604241029.14932.gustavo@compunauta.com> <200604241712.26445.gustavo@compunauta.com> <444DBD0D.9010309@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from compunauta.com ([69.36.170.169]:14509 "EHLO compunauta.com")
	by vger.kernel.org with ESMTP id S1751625AbWDYVmF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 17:42:05 -0400
In-Reply-To: <444DBD0D.9010309@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

El Martes, 25 de Abril de 2006 01:09, escribi=F3:
> Gustavo Guillermo P=E9rez wrote:
> > El Lunes, 24 de Abril de 2006 17:02, James Bottomley escribi=F3:
> >>So, I could change the long write in progress to a retry.  However,=
 I
> >>suspect the reason we got that return is because this device is unt=
agged
> >>(doesn't accept multiple commands at once) and perhaps a better fix
> >>might be to reduce the queue depth down to one to prevent more than=
 one
> >>command being outstanding at any one time.
> >
> > It would not be better to include some handling on the black list? =
it
> > means doing a new BLACK_CONST to handle just this special case?.
>
> For now you can and should test a queue depth of one via sbp2:
> # modprobe sbp2 serialize_io=3D1
>
> But isn't usb-storage's queue depth already 1?
Yes, I was tested it cause driver said something about this option, the=
n I was=20
checked the option 1 or 0, same result.
> Dou you use all the different Pioneer drives with the same
> IDE/USB+FireWire bridge or do you have different bridges?
Yes I have 3 diferent bridges, with 5 diferent DVDRW from pioneer other=
 Drives=20
I've tested with this same USB-IDE Bridges works without this problem.
I've tried the flag BLACK_XXX for non tagged queue for this drive but w=
ith no=20
results.

{"PIONEER", "DVD-RW  DVR-110D", NULL, BLIST_RETRY_HWERROR | BLIST_NOTQ}

:S
--=20
Gustavo Guillermo P=E9rez
Compunauta uLinux
www.compunauta.com
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
