From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Mon, 30 Aug 2004 11:30:07 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CC78EDC-FAAA-11D8-85F1-00039398BB5E@ieee.org>
References: <3DD91260-F839-11D8-A52F-00039398BB5E@ieee.org> <41300511.206030
	 3@torque.net> <Pine.LNX.4.58.0408280922540.7958@kai.makisara.local>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=ISO-8859-1;
	delsp=yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:20457 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S268646AbUH3RaO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 13:30:14 -0400
In-Reply-To: <Pine.LNX.4.58.0408280922540.7958@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

Kai M:

>>> A deferred error, in the context of sense data ((bytes[0] & x7F) !=3D=
 =20
>>> x70)
>>> is usually a purportedly rare and therefore interesting catastrophe=
 =20
>>> of
>>> some kind, yes?  A failure to write seen while flushing cache.  A
>>> failure to eject after obediently faking "immediate"ly good status.=
  =20
>>> Etc.
> ...
> The severity of deferred errors depends on the device.
> ...
> Streaming tape drives have to
> use largish internal buffers. This means that, for instance, write =20
> errors
> often are deferred errors. The possibilities to report this error to =
=20
> the
> user are limited but that is another thing (basically the driver can =
=20
> only
> suggest to the user that the tape head is in an uknown position).

Thanks for the tape perspective, most of my time I've spent with =20
removable discs.

> The tapes seem to again be an exception from the mainstream.

I'm not sure I understand why?

Are we saying, for tape, a failure to write seen while flushing cache =20
inside the device is normal and not catastrophic?  Are we saying tape =20
buffers are commonly significantly larger than DVD-RAM buffers?  Help?

Pat LaVarre

P.S.

> Block SG_IO seems to be a collection of serious bugs and/or
> misfeatures ;-)

http://www.google.com/search?q=3Dscsi+pass+thru+caveat
yields Doug G dated "04/09/2003":

---
The sg policy is basically "you want, you got it" **. Andre Hedrick =20
found out that in some dark corner of the ATA instruction set it was =20
possible to overspeed an ATA disk.  He proposed filtering out that =20
instruction but the linux-kernel list consensus was not to do that.
---

grepping my own blogs for "caveat" yields:

--- Subject:  scsi pass thru en fran=E7ais, en espa=F1ol
--- http://plavarre.blog-city.com/read/618280.htm
=2E..
Learning to use a tool like [SCSI pass thru] will probably remind you =20
of the need to backup often. If you won't enjoy that lesson, then =20
please don't pick up the tool. Potential side effects include kernel =20
panics, destroyed discs, destroyed devices, and even imperceptibly =20
subtle forms of data corruption. Storage devices differ from modems =20
first by being designed to record your mistakes permanently, and second=
 =20
by defining some commands or sequences of commands to mean =20
self-destruct.
=2E..
---
--- Subject:  tools that demo the need to backup often
--- http://linux-pel.blog-city.com/read/546745.htm
=2E.. Solaris
=2E.. man uscsi
=2E.. http://www.google.com/search?q=3Dsolaris+man+uscsi
=2E.. http://www.sunspot.noao.edu/cgi-bin-local/man-cgi?uscsi+7I
=2E.. http://www.google.com/search?q=3Dsys%2Fscsi%2Fimpl%2Fuscsi.h
=2E.. =20
http://developers.sun.com/solaris/developer/support/driver/wps/uscsi/=20
uscsi.html
=2E..
An unsupported, undocumented feature of Sun SCSI device drivers allows =
=20
users to issue SCSI requests directly to SCSI devices. This capability =
=20
is intended for driver prototyping and diagnostics; it allows the =20
developer to try out sequences of SCSI commands without recompiling and=
 =20
reloading a device driver. Users of this feature must be forewarned =20
that potential side effects include system panics and putting devices =20
into unusable states.
=2E..
---

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
