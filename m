From: "Knight, Frederick" <Frederick.Knight@netapp.com>
Subject: RE: [PATCH] scsi: relax PAGE LENGTH check for thin provisioning UNMAP support
Date: Thu, 6 May 2010 10:27:43 -0400
Message-ID: <AC32D7C72530234288643DD5F1435D5309994F2A@RTPMVEXC1-PRD.hq.netapp.com>
References: <1273096203-3164-1-git-send-email-snitzer@redhat.com> <yq1sk65ejs5.fsf@sermon.lab.mkp.net> <w2o170fa0d21005060424j912e21bev8dba13536d49ba41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:10112 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab0EFO1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2010 10:27:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <w2o170fa0d21005060424j912e21bev8dba13536d49ba41@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

In the early 90s, when the SCSI INQUIRY - ANSI Version field had only 2=
 values, I worked on a host that, because SCSI-1 and SCSI-2 were incomp=
atible, did the following:

If ( ANSI_VERSION =3D=3D 2 ) {use SCSI-2 protocol} else {use SCSI-1 pro=
tocol}

When the first SCSI-3 device came along, this host fell over dead becau=
se the SCSI-1 protocol did not work on that SCSI-3 device.  They had to=
 delay support for that device until they fixed their code (change =3D=3D=
 to >=3D), and they could NOT support that device in older versions, ev=
en thought it would have worked if not for the above "bug".

There are no guarantees about what the T10 committee will do to that pa=
ge in the draft, or in any future versions of SBC.

In reality, any value > 32 (20h) will mean that you probably have all t=
he data you want to look at today.  YES, any device that puts such a sm=
all value into the page length field is non-compliant (and therefore, t=
he contents of those fields may be non-compliant as well).  So, allowin=
g a value less than 3Ch would be risky.

But, a compliant SBC-4/5/... device might put 200 (or other > 3Ch value=
) into that field, while the existing values all still remain valid.  I=
t would be a shame to disable feature "A" just because a device added t=
he implementation of feature "X".

=46uture proofing is never guaranteed, but it is good to at least try.

	Fred

-----Original Message-----
=46rom: Mike Snitzer [mailto:snitzer@redhat.com]=20
Sent: Thursday, May 06, 2010 7:24 AM
To: Martin K. Petersen
Cc: linux-scsi@vger.kernel.org; Christoph Hellwig; Knight, Frederick
Subject: Re: [PATCH] scsi: relax PAGE LENGTH check for thin provisionin=
g UNMAP support

On Thu, May 6, 2010 at 12:28 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Mike" =3D=3D Mike Snitzer <snitzer@redhat.com> writes:
>
> Mike> Thin Provisioning fields are assumed available in the BLOCK LIM=
ITS
> Mike> VPD page if PAGE LENGTH is 0x3c. =A0The BLOCK LIMITS VPD page m=
ay be
> Mike> extended over time. =A0Allow for the possibility that the PAGE
> Mike> LENGTH exceeds 0x3c.
>
> SBC3 states that:
>
> "If the device server supports thin provisioning, then the device ser=
ver
> shall set the PAGE LENGTH field to 3Ch."
>
> That's a "shall". =A0That's a non-negotiable requirement in standards
> speak. =A0And besides, only half of that mandated page length is curr=
ently
> spoken for. =A0So I wonder what motivated your change? =A0Do you have=
 any
> examples of devices with a bigger page length?

I forgot to cc Fred Knight on my patch, but Fred was/is attending the
most recent T10.  Based on the discussions there, and me having shared
with him the PAGE LENGTH =3D=3D 0x3c constraint before, he sent me priv=
ate
mail sharing that SBC3 is not yet final nor approved.  And that at
this recent T10 meeting they were talking of extending the BLOCK
LIMITS VPD.  If not for SBC3 then for SBC4.

So coming full circle: why impose a precise PAGE LENGTH of 0x3c?
It'll only cause compatibility problems for us down the road when new
devices do come to market.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
