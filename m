From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Configure NPIV fc_vport via
 tcm_qla2xxx_npiv_make_lport
Date: Thu, 16 Jan 2014 13:50:10 -0800
Message-ID: <1389909010.5567.685.camel@haakon3.risingtidesystems.com>
References: <1389764525-24453-1-git-send-email-nab@daterainc.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46CCE451@avmb2.qlogic.org>
	 <1389837925.5567.627.camel@haakon3.risingtidesystems.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46CCE9AA@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33523 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaAPVsP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 16:48:15 -0500
In-Reply-To: <504EB66DAC8D234EB8E8560985C2D7AD46CCE9AA@avmb2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Sawan Chandak <sawan.chandak@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Thu, 2014-01-16 at 20:54 +0000, Quinn Tran wrote:
> Nicholas,
>=20
> Comments inline. Thanks.
>=20
>=20
> <SNIP>
> >Bullet 3) Generating NPIV WWPN id:  Qlogic overall strategy for this
> >question is: Qla2xxx driver is a common driver being used by various
> >hardware vendors(HP, IBM, Dell, etc..).  Each vendors have a differe=
nt
> >scheme on how to generate the WWPN value.  QLogic's design decision =
is to
> >push that up to the user app to generate these values rather having
> >QLA2xxx generating it dynamically.
>=20
> So question here was not contents of the NPIV WWPN value, but rather =
if
> the NPIV WWPN and NPIV WWNN are always expected to have the same suff=
ix.
>=20
> Eg, is it safe to assume that the '21' and '20' prefixes for NPIV WWP=
N +
> NPIV WWNN are the only different part of the $NPIV_WWPN:$NPIV_WWNN tu=
ple
> passed into fc_vport_create()..?
>=20
> If so, I'd like to remove $NPIV_WWNN from being passed into configfs,
> and simply generate this value internally, eg:
>=20
>   /sys/kernel/config/target/qla2xxx_npiv/$PHYS_WWPN:$NPIV_WWPN
> <SNIP>
>=20
> QT> Mis-read this one.
>=20
> It's not safe to assume "21" & "20" as the standardize prefixes and t=
he
> rest of the $WWPN/$WWNN will be the same. While it is common to see "=
21" &
> "20" (i.e. Network Addr Authority/NAA 2 format) on a lot of adapters.=
  The
> common case that we see only cover 1 NAA format.  I've seen the NAA5
> format float around on different adapters.
>=20
> I don't want to paint us in to a corner, that will require future cod=
e
> change in this area.  The user that generate the $NPIV_WWPN + $NPIV_W=
WNN
> may decide to use another NAA format where it will not match this
> implementation.
>=20
> By collapsing the $NPIV_WWNN into the driver, its takes away the opti=
on
> for an administrator of a large SAN to assign/identify storage chassi=
s
> using $WWNN.  Even though it is clunky to carry around.
>=20

=46air enough.  I'm currently planning for targetcli to (by default)
generate $NPIV_WWPN + $NPIV_WWNN values for end users in NAA2 format.

Optionally, advanced versions will be able to provide their own
$NPIV_WWPN + $NPIV_WWNN values at port creation time if necessary.

> I prefer the format "$PHYS_WWPN@$NPIV_WWPN:$NPIV_WWNN" with the "@" k=
ey,
> for the case where the user download an older version of RSTLIB that =
still
> follow the older format/backward compatible.  The '@' key inside the
> driver provides the distinction of the new configfs format.  No prefe=
rence
> on $PHYS_WWPN appear at the front or back.
>=20

Note that rtslib/targetcli can always use 'free form' names, for which
user can pass any value into /sys/kernel/config/target/$FABRIC/$WWPN.

>=20
> Network address authority Format:
> NAA1 =3D10-00-vv-vv-vv-ss-ss-ss
> NAA2 =3D2x-xx-vv-vv-vv-ss-ss-ss
> NAA5 =3D5v-vv-vv-vs-ss-ss-ss-ss
> NAA6 =3D6?-=C5=A0 (16 bytes/32 hex digits, not applicable for HW adap=
ter)
>=20
> x=3Dvendor code (0-00=3Dwwnn 1-00=3Dwwpn)
> v=3Dvendor id
> s=3Dserial number (NAA5: user may decide to use WWPN=3DN & WWNN=3DN+1=
)
>=20

Ok, so we've been using NAA2 formatting for all FC/FCoE ports
represented in configfs thus far.

>=20
> ----
> <SNIP>
> >Bullet 4) VPD Page 83h, SCSI name string.  If you implying to use th=
e WWPN
> >as part of the "SCSI name string", the answer is the same as previou=
s
> >bullet.  In this case, the setup up script would have to extract the=
 data
> >from configfs in order to generate the "SCSI name string"
>=20
> This question was geared toward how SCSI name should be represented i=
n
> INQUIRY EVPD=3D0x83 for NPIV ports.
>=20
> For physical ports, this ends up being the 21:00:00:XX:XX:XX:XX:XX va=
lue
> matching what is passed to configfs.  For virtual ports the passed
> $NPIV_WWPN part would be here in similar format, but the question was=
 if
> the port_id should also be appended here similar to existing 'lsscsi
> --transport' output, eg:
>=20
> root@devstack:~# lsscsi --transport
> [0:0:0:0]    disk    ata:                            /dev/sda
> [91:0:0:0]   disk    fc:0x21111111222222220x610101   /dev/sdb
> <SNIP>
>=20
>=20
> SPC4 rev 36n, section 7.8.6.11 >
>                                         The SCSI NAME STRING field st=
arts with either:
>=20
> ...
> b) the four UTF-8 characters 'naa.' concatenated with 16 or 32 hexade=
cimal
> digits for an NAA identifier
> (see 7.8.6.6). The first hexadecimal digit shall be the most signific=
ant
> four bits of the first byte (i.e.,
> most significant byte) of the NAA identifier; or
> ...
> "If the ASSOCIATION field is set to 01b (i.e., target port), the SCSI=
 NAME
> STRING field ends with the five UTF-8
> characters ',t,0x' concatenated with two or more hexadecimal digits a=
s
> defined in the applicable SCSI
> transport protocol standard."
> ...
>=20
>=20
> QT> If I read SPC4 correctly, the format is as follow (minor tweak). =
 For
> FC, there is only 1 format (i.e. Association field =3D 1).  Correct t=
he
> format if you read it differently.
>=20
>=20
>=20
>=20
> [91:0:0:0] disk fc:naa.2111111122222222,t,0x610101  /dev/sdb
>=20
>=20
>=20
> Scsi name string =3D "naa.2111111122222222,t,0x610101"
>=20

Mmmm, so target core is exposing the SCSI name string prefix matching
what's in /sys/kernel/config/target/$FABRIC/WWPN.

=46or non NPIV qla2xxx + tcm_fc(FCoE), this ends up being:

    21:00:XX:XX:XX:XX:XX:XX,t,0x0001

So this will need to be changed for the FC/FCoE cases to follow the
'naa.' prefixed format mentioned above.  AFAIK this is only used for
information purposes, so it's fairly low priority atm.

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
