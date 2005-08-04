From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] aic79xx: fix up transport settings
Date: Thu, 04 Aug 2005 08:58:14 +0200
Message-ID: <42F1BC86.8070204@suse.de>
References: <1123093511.5019.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:25060 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S261903AbVHDG6T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 02:58:19 -0400
In-Reply-To: <1123093511.5019.17.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> There's a slight problem in the way you've done the transport
> parameters; reading from the variables actually produces the current
> settings, not the ones you just set (and there's usually a lag becaus=
e
> devices don't renegotiate until the next command goes over the bus). =
 If
> you set the bit immediately, you get into the situation where the
> transport parameters report something as being set even if the drive
> cannot support it.
>=20
Well, as usual you're correct. I wasn't quite sure as to _when_ the
transport class parameter will be set, as they appearently haven't been
set correctly (this was whilst chasing down the ST/DT setting issue).
But yours if of course the correct way of doing things.

> I patched the driver to do it this way and also corrected a panic in =
the
> proc routines.
>=20
THX. Didn't even know there was a proc panic :-).

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
