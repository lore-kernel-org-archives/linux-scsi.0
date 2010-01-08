From: Marc Bejarano <beej@beej.org>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
Date: Fri, 8 Jan 2010 22:21:09 +0000 (UTC)
Message-ID: <loom.20100108T231444-8@post.gmane.org>
References: <4B3BDB66.6000008@googlemail.com>  <4B4632BF.4070806@pobox.com> <1262964519.3025.614.camel@mulgrave.site> <4B4799FB.9030208@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34840 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab0AHWZI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jan 2010 17:25:08 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NTNGS-0004sQ-A6
	for linux-scsi@vger.kernel.org; Fri, 08 Jan 2010 23:25:04 +0100
Received: from 76-14-67-46.sf-cable.astound.net ([76-14-67-46.sf-cable.astound.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jan 2010 23:25:04 +0100
Received: from beej by 76-14-67-46.sf-cable.astound.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jan 2010 23:25:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Ren=C3=A9 Bolldorf <xsecute <at> googlemail.com> writes:
> On 01/08/10 16:28, James Bottomley wrote:
> > On Thu, 2010-01-07 at 14:15 -0500, Jeff Garzik wrote:
> >> On 12/30/2009 05:59 PM, Ren=C3=A9 Bolldorf wrote:
> >>> We don't need this .

> >>> - /* FIXME: is this needed? */
> >>> - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
> >>
> >> I need a little bit more detail than an unqualified statement...  =
Did
> >> you audit all paths leading to this code point?

> > But one also here:
> >
> > 		u8 *sense_buffer =3D dev->link->ap->sector_buf;
> > 		[...]
> > 		err_mask =3D atapi_eh_request_sense(dev, sense_buffer, sense_key)=
;
> >
> > Which doesn't look OK because it looks like the sector_buf isn't cl=
eared
> > (and it is reused).
> >
> > James
> >
> >
>=20
> Thank's, you're right. I have overseen this, sry for that.

Ren=C3=A9: perhaps you'd like to submit a patch that substitutes FIXME =
comment
for one that explains why the memset is needed, crediting James in the
description?  we may as well gain something permanent from this discuss=
ion
that you started :)

cheers,
marc

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
