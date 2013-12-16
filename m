From: =?Windows-1252?Q?Str=F6sser=2C_Bodo?=
	<bodo.stroesser@ts.fujitsu.com>
Subject: RE: [PATCH 3/3] st.ko: change enlarge_buffer result
Date: Mon, 16 Dec 2013 20:20:00 +0100
Message-ID: <8B06D1E6480A6747B23FEC34909D2B5E96D3F453BE@ABGEX70E.FSC.NET>
References: <61eb00$4eu08n@dgate20u.abg.fsc.net>
 <E0B3592D-FAC1-4830-AFC3-9643F27CA9DF@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:60488 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3LPTbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 14:31:11 -0500
In-Reply-To: <E0B3592D-FAC1-4830-AFC3-9643F27CA9DF@kolumbus.fi>
Content-Language: de-DE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: "Kai M=E4kisara (Kolumbus)" [mailto:kai.makisara@kolumbus.fi]
> Sent: Monday, December 16, 2013 7:49 PM
> To: Str=F6sser, Bodo
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 3/3] st.ko: change enlarge_buffer result
>=20
>=20
> On 2.12.2013, at 21.00, Bodo Stroesser <bstroesser@ts.fujitsu.com> wr=
ote:
>=20
> > From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> > Date: Mon, 2 Dec 2013 18:52:10 +0100
> > Subject: [PATCH 3/3] st.ko: change enlarge_buffer result
> >
> > enlarge_buffer() just returns 1 or 0 if it could or could
> > not allocate the requested buffer.
> >
> > In case of result 0, the callers always set the error to
> > EOVERFLOW. I think, this is not a good errno for those
> > cases, where enlarge_buffer() could not allocate the pages
> > it needed.
> >
> > So I changed enlarge_buffer() to return a meaningful
> > result (-ENOMEM or -EOVERFLOW in case of error, 0 in case of
> > success) and the callers to use this result.
> >
> ENOMEM is used for telling the user that, in variable block mode, the=
 byte count in read()
> is smaller than the next block. This may not sound like proper use of=
 this code but this
> is how the tape drivers have done.

Oops, sorry, I missed that. So I agree fully, that the patch does not
make sense.

Thank you,
Bodo

> When ENOMEM is not used, the patch would be only cosmetic.

>=20
> Thanks,
> Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
