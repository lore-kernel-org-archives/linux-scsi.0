From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re: st driver doesn't seem to grok LTO partitioning
Date: Thu, 4 Feb 2016 19:54:55 +0200
Message-ID: <DA4D459C-6D64-4028-8D8D-6F266C77E036@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com> <20160106161049.34f29973@harpe.intellique.com> <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com> <20160106170720.61db9e86@harpe.intellique.com> <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com> <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net> <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net> <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net> <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net> <alpine.LSU.2.
 11.1601291915010.22105@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44525667@G9W0766.americas.hpqcorp.net> <alpine.LSU.2.11.1602032011230.2679@xnv.znxvfnen.cevingr> <DDB9C85B850785
 449757F9
 914A034FCB445262D4@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs14.mail.saunalahti.fi ([62.142.117.201]:40586 "EHLO
	vs14.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065AbcBDRzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 12:55:04 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB445262D4@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On 4.2.2016, at 3.43, Seymour, Shane M <shane.seymour@hpe.com> wrote:
>=20
> Hi Kai,
>=20
> Tested with patched kernel 4.5.0-rc2-next-20160202+. It's looking goo=
d everything partition related passed with DDS5 and LTO6. You can defin=
itely add me as a tested-by. I did find one issue below but it's not re=
lated to the partitioning changes.
>=20
Thanks for testing. It would be interesting to get confirmation from a =
LTO-5 user that partitioning
works. Even without that I will make the final patch within a few days =
(remove some debugging
and update the documentation).

=2E..
> I did find one issue in testing unrelated to the changes, the tell op=
tion didn't work with my LTO-6 drive:
>=20
> # ./mt -f /dev/st0 tell
> /dev/st0: Input/output error
>=20
> [ 2045.974642] st 3:0:0:0: [st0] Block limits 1 - 16777215 bytes.
> [ 2045.975221] st 3:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS=
 10, BLL 8
> [ 2045.975224] st 3:0:0:0: [st0] Density 5a, tape length: 0, drv buff=
er: 1
> [ 2045.975226] st 3:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 =
blocks).
> [ 2045.975718] st 3:0:0:0: [st0] Error: 8000002, cmd: 34 1 0 0 0 0
> [ 2045.975723] st 3:0:0:0: [st0] Sense Key : Illegal Request [current=
]
> [ 2045.975726] st 3:0:0:0: [st0] Add. Sense: Invalid field in cdb
> [ 2045.975729] st 3:0:0:0: [st0]  Can't read tape position.
> [ 2045.975857] st 3:0:0:0: [st0] Rewinding tape.
>=20
> I believe that in get_location() we're doing this:
>=20
> static int get_location(struct scsi_tape *STp, unsigned int *block, i=
nt *partition,
>                        int logical)
> {
>        int result;
>        unsigned char scmd[MAX_COMMAND_SIZE];
>        struct st_request *SRpnt;
>=20
>        if (STp->ready !=3D ST_READY)
>                return (-EIO);
>=20
>        memset(scmd, 0, MAX_COMMAND_SIZE);
>        if ((STp->device)->scsi_level < SCSI_2) {
>                scmd[0] =3D QFA_REQUEST_BLOCK;
>                scmd[4] =3D 3;
>        } else {
>                scmd[0] =3D READ_POSITION;
>                if (!logical && !STp->scsi2_logical)
>                        scmd[1] =3D 1; <<<<<<<<<<<<<<
>        }
>=20
> When called from the ioctl that the tell option uses the variable log=
ical is passed in as 0 (from what I could see everything else sets it t=
o 1). For a READ_POSITION the drive I'm using only supports 0, 6, or 8 =
in the service action field of the second byte:
>=20
I think you have not set the scsi2_logical option bit with mt or stinit=
 or some other tool.
The default of device-specific addresses is a historical mistake but we=
 have to live with
it. I don=E2=80=99t see this as a big problem because any user of curre=
nt drives should enable
some driver options anyway.

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
