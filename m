From: Gregoire Favre <Gregoire.Favre@freesurf.ch>
Subject: Re: 2.6.0-mm lost my CD-r (aic7xxx)
Date: Mon, 29 Dec 2003 12:06:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031229110632.GA26418@magma.epfl.ch>
References: <20031228110452.GA31088@magma.epfl.ch> <3719770000.1072666608@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.epfl.ch ([128.178.50.57]:37137 "HELO mail0.epfl.ch")
	by vger.kernel.org with SMTP id S263228AbTL2LGe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 06:06:34 -0500
Content-Disposition: inline
In-Reply-To: <3719770000.1072666608@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Dec 28, 2003 at 07:56:48PM -0700, Justin T. Gibbs wrote:

> [ Moved to linux-scsi since that is where SCSI issues belong ]

[Thank for the move ;-) ]

> the CDROM drive.  Most likely, the drive had a problem reading a part=
icular
> audio sector on the disk and failed to report status before the 30 se=
cond
> timeout in the sr driver expired.  Many of these drives will retry fo=
r a
> full minute or more before giving up on a bad sector.
>=20
> ...
>=20
> > Dec 28 11:52:40 greg kernel: aic7xxx_dev_reset returns 0x2003
> > Dec 28 11:52:40 greg kernel: Recovery SCB completes
> > Dec 28 11:52:50 greg kernel: scsi: Device offlined - not ready afte=
r error recovery: host 1 channel 0 id 2 lun 0
>=20
> The driver was asked to abort the command.  The CDROM drive accepted =
the
> abort request, but failed to go bus free.  The mid-layer asked for a =
BDR,
> but the driver was unable to deliver it (bus wasn't free to issue a n=
ew
> command).  Lastly, a bus reset was ordered which cleared the bus and =
allowed
> the timed-out command to complete.  Unfortunately, your cdrom drive w=
as
> taken offline since it failed two successive Test Unit Ready Attempts=
=2E
> This is not uncommon with removable media devices since they will oft=
en
> report two unit attentions back to back.  The first acknowledges the =
bus
> reset.  The second indicates that the media may have changed (many dr=
ives
> don't retain media information across bus resets).  Unfortunately, th=
e Linux
> mid-layer recovery code only tolerates one unit attention condition a=
fter a
> bus reset, so your cdrom drive was incorrectly taken offline.

Many thank for the explanation, I have tried to do the copy under
2.4.22-ac1 with exactly same result (well more or less, under 2.4.22-ac=
1
I loss my CD-R and all SCSI device attached to the same SCSI device...)=
=2E
I think I have to forget being able to listen to this "broken" CD...

Happy new year ;-)

	Gr=E9goire
_______________________________________________________________________=
_
http://magma.epfl.ch/greg ICQ:16624071 mailto:Gregoire.Favre@freesurf.c=
h
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
