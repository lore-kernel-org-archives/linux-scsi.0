From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 18:51:05 +0100
Message-ID: <45770309.SQD5w0Pflctib/c7%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0612061207550.3298-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:40496 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936974AbWLFSAw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 13:00:52 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612061207550.3298-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, James.Bottomley@steeleye.com
Cc: schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

Alan Stern <stern@rowland.harvard.edu> wrote:

> It turns out that for block device files we don't need to change anyt=
hing.
> The BLKSECTGET ioctl already does almost exactly what we want:
>
> 	int n;
>
> 	if (ioctl(fd, BLKSECTGET, &n) =3D=3D 0)
> 		max_transfer_size =3D n * 512;
>
> So only the legacy sg character-device files need attention, which me=
ans=20
> that only the part of the patch affecting sg.c is necessary.  The new=
=20
> SG_GET_MAX_TRANSFER_LENGTH ioctl can remain unimplemented by the bloc=
k=20
> layer -- just as SG_[SG]ET_RESERVED_SIZE should be.
>
> How does that sound?

libscg needs a unique ioctl that works for all used filedescriptors tha=
t
may be a target for SG_IO.

J=F6rg

--=20
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) J=F6rg Schilling D-1335=
3 Berlin
       js@cs.tu-berlin.de                (uni) =20
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blo=
gspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub=
/schily
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
