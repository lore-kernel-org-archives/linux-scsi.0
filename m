From: Laurence Oberman <loberman@redhat.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Mon, 1 Feb 2016 14:02:57 -0500 (EST)
Message-ID: <348338681.10695858.1454353377434.JavaMail.zimbra@redhat.com>
References: <20151218170644.24167419@harpe.intellique.com> <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net> <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net> <alpine.LSU.2.11.1601291915010.22105@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB4452416B@G9W0766.americas.hpqcorp.net> <5A3F5643-16A4-4010-B3D2-3F931B620128@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:52416 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbcBATDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 14:03:11 -0500
In-Reply-To: <5A3F5643-16A4-4010-B3D2-3F931B620128@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai =?utf-8?Q?M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: Shane M Seymour <shane.seymour@hpe.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, linux-scsi@vger.kernel.org

The new patch did not work for me, but I chatted with Shane and I have =
his mt version.=20
I will update my DAT to same firmware or newer than his and provide a s=
econd tested by.
I also expect my LTO5 to show up this week so will be ready for that.

Thanks everyone for keeping tapes alive

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
To: "Shane M Seymour" <shane.seymour@hpe.com>
Cc: "Laurence Oberman" <loberman@redhat.com>, "Emmanuel Florac" <eflora=
c@intellique.com>, "Laurence Oberman" <oberman.l@gmail.com>, linux-scsi=
@vger.kernel.org
Sent: Monday, February 1, 2016 1:43:26 PM
Subject: Re: What partition should the MTMKPART argument specify? Was: =
Re: st driver doesn't seem to grok LTO partitioning


> On 1.2.2016, at 8.31, Seymour, Shane M <shane.seymour@hpe.com> wrote:
>=20
> Hi Kai,
>=20
> Thanks for the changes the HPE DAT72 DDS5 drive now works as expected=
:
>=20
Good. Thanks for testing.

=2E..
>=20
> I'm asking around again one final time to see if I can lay my hands o=
n a LTO5 or greater drive so I can test LTO partitioning as well.
>=20
> The only other thing I can think of (I'm not sure if this is an impro=
vement or not) is if bp[pgo + PP_OFF_MAX_ADD_PARTS] + bp[pgo + PP_OFF_N=
BR_ADD_PARTS] (max.parts and nbr_parts in the debug message) is zero ju=
st return -EINVAL unless you know of any take drives that report them b=
oth as 0 but can be partitioned? That is after this:
>=20
>        DEBC_printk(STp, "psd_cnt %d, max.parts %d, nbr_parts %d\n",
>                    psd_cnt, bp[pgo + PP_OFF_MAX_ADD_PARTS],
>                    bp[pgo + PP_OFF_NBR_ADD_PARTS]);
>=20
> add (and also turn off the can-partitions option):
>=20
> 	if ((bp[pgo + PP_OFF_MAX_ADD_PARTS] + bp[pgo + PP_OFF_NBR_ADD_PARTS]=
) =3D=3D 0) {
> 		DEBC_printk(STp, "Drive not partitionable - max.parts+nbr_parts is =
0\n");
> 		STp->can_partitions =3D 0;
> 		return -EINVAL;
> 	}
>=20
> I'm not especially fussed if you don't want to add that though.
>=20
I thought about a test like this (only test maximum number) but decided=
 not to add it. The reason was that
I did not want to change anything that has worked before. I quite trust=
 that the current drives return sense
data instead of crashing and the end result for the user would be the s=
ame. However, one can argue that
returning EINVAL is better than EIO but does the user notice? If the co=
mmon opinion is that a test like this
should be added, I am not against it. It can be added to the code for S=
CSI >=3D3 where it does not risk
anything for the old drives.

IMHO, can_partitions should not be cleared based on the test. For examp=
le, trying to partition a LTO-4 tape
in a LTO-5 drive should not disable partitioning. (The mode page should=
 return zero as maximum number of
partitions when a LTO-4 tape is inserted.)

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
