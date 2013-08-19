From: Ben Collins <ben.c@servergy.com>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Mon, 19 Aug 2013 13:25:16 -0400
Message-ID: <3DA40821-A3AC-45CA-BD22-995EA256837A@servergy.com>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com> <yq1zjskgn1x.fsf@sermon.lab.mkp.net> <D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com> <yq1eh9wgiqo.fsf@sermon.lab.mkp.net> <FE68512D-F375-456B-948A-492634A02F0F@servergy.com> <yq1haeqcuce.fsf@sermon.lab.mkp.net> <088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:42113 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3HSRZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2013 13:25:18 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc17so5191995pbc.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2013 10:25:17 -0700 (PDT)
In-Reply-To: <088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "aradford@gmail.com" <aradford@gmail.com>

On Aug 19, 2013, at 7:16 AM, "Saxena, Sumit" <Sumit.Saxena@lsi.com> wro=
te:
> This patch: Big endian support for megaraid_sas driver is not complet=
e. In few areas, we need to do changes like this patch does not have ch=
anges for Thunderbolt/invader/Fury controllers(file: megaraid_sas_fusio=
n.c), and needs few changes in file: megaraid_sas_fp.c(while host reads=
 some member of raidmap, it needs endianness change there also)..
>=20
> LSI has megaraid_sas driver with big endian support for driver versio=
n "06.506.00.00". But to add big endian support for latest upstream meg=
araid_sas driver (06.600.18.00), we need to make some more changes.
> We will get back with big endian support patch on top of latest upstr=
eam megaraid_sas driver.
>=20

Is this work-in-progress available somewhere? What is the time frame yo=
u expect to have this supported by LSI directly? Based on the fact that=
 big-endian support in megaraid_sas is 8 years in the making, forgive m=
e if I'm a little skeptical of progress in the near term.

I realize that the big-endian patch from Martin isn't complete for fusi=
on, but it is for other cards. Given that our company has a POWER based=
 product using MegaRAID LSI SAS due on the market in a matter of months=
, I'd like to have stock kernels supporting it sooner rather than later=
=2E

Since this patch has zero effect on currently supported platforms (litt=
le-endian), I don't see the harm in letting it through, since it actual=
ly does work, and more importantly, works right now.

>> -----Original Message-----
>> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
>> Sent: Friday, August 16, 2013 6:42 AM
>> To: Ben Collins
>> Cc: Martin K. Petersen; DL-MegaRAID Linux; linux-scsi;
>> aradford@gmail.com
>> Subject: Re: State of big-endian for MegaRAID SAS driver
>>=20
>>>>>>> "Ben" =3D=3D Ben Collins <ben.c@servergy.com> writes:
>>=20
>> Ben,
>>=20
>> Ben> Considering your patch has had two success stories (I suspect y=
ours
>> Ben> was on SPARC, so that would even make two different platforms) =
and
>> Ben> low likelihood of regression on little endian, I think it's pre=
tty
>> Ben> safe.
>>=20
>> I ordered a MegaRAID card today so I can test on x86 just to be sure=
=2E
>>=20
>>=20
>> Ben> The only thing I think that could make it better is to annotate=
 the
>> Ben> structures in megaraid_sas.h as __le32 where applicable.
>>=20
>> I have an older patch that does just that. And another one that gets=
 rid
>> of the 32-bit DMA limitations on large systems. But I didn't want to
>> clutter the initial submission.
>>=20
>> --
>> Martin K. Petersen	Oracle Linux Engineering
>=20
>=20

--
Benjamin M. Collins | Principal Architect
Servergy, Inc. | Save Energy. Work Smart. =AE
m (757) 243-7557 | e ben.c@servergy.com
L LinkedIn | T twitter.com/Servergy
www.servergy.com

CONFIDENTIALITY NOTICE: This communication contains privileged and/or c=
onfidential information to be maintained with the strictest confidence.=
 It is intended solely for the use of the person or entity in which it =
is addressed. If you are not the intended recipient, you are STRICTLY P=
ROHIBITED from disclosing, copying, distributing or using any of this i=
nformation. If you received this communication in error, please contact=
 the sender immediately and destroy the material in its entirety, wheth=
er electronic or hard copy.  Email may contain forward looking comments=
 that are based on managements best-faith estimates which are subject t=
o change. For information only. Not an offer, or solicitation of any of=
fer to buy or sell any security, investment or other product.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
