From: Ilias Tsitsimpis <iliastsi@arrikto.com>
Subject: Re: [PATCH 0/2] target: Fixes for AllRegistrants reservation handling
Date: Thu, 18 Dec 2014 16:54:01 +0200
Message-ID: <20141218145401.GD2476@iliastsi-m.arr>
References: <1418688544-18825-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1418688544-18825-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2014 at 12:09AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> Hi all,
>=20
> This series addresses two issues raised recently by Ilias wrt
> AllRegistrants reservation handling in target code that does not
> adhere to SPC-4 specification requirements.
>=20
> This first is a informational change to PR-IN READ_FULL_STATUS,
> that when an AllRegistrants reservation is in place, all active
> registrations should be setting R_HOLDER=3D1 within their respective
> descriptors.
>=20
> The second is a functional change to PR-OUT REGISTER w/ SARK=3D0
> operation, to avoid dropping the AllRegistrants reservation until
> the last registered I_T nexus has been released.  It also ensures
> that the correct reservation type + scope is retained when the
> new reservation is set within __core_scsi3_complete_pro_release()
> for this AllRegistrants special case.
>=20
> Also, thanks to James for the extra SPC-4 clarifications.
>=20
> Please review.

Hi Nicholas,

Thanks for the quick fix. These patches address the two issues that I
raised in my previous email but they don't seem to fix all the problems
with AllRegistrants reservation handling in target code. Please see my
example below.

I have set up an iSCSI target, using the Linux SCSI Target
implementation with your patches applied, and I am connecting to it from
two different nodes using the open-iscsi project.

    root@node1:~# sg_inq /dev/sdc
    standard INQUIRY:
      PQual=3D0  Device_type=3D0  RMB=3D0  version=3D0x05  [SPC-3]
      [AERC=3D0]  [TrmTsk=3D0]  NormACA=3D0  HiSUP=3D0  Resp_data_format=3D2
      SCCS=3D1  ACC=3D0  TPGS=3D3  3PC=3D1  Protect=3D0  BQue=3D0
      EncServ=3D0  MultiP=3D0  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=3D0
      [RelAdr=3D0]  WBus16=3D0  Sync=3D0  Linked=3D0  [TranDis=3D0]  CmdQue=
=3D1
        length=3D36 (0x24)   Peripheral device type: disk
     Vendor identification: LIO-ORG=20
     Product identification: FILEIO         =20
     Product revision level: 4.0
     Unit serial number: 853ea439-7fcf-4aaa-9de2-1399e06b45be

    root@node2:~# sg_inq /dev/sdc
    standard INQUIRY:
      PQual=3D0  Device_type=3D0  RMB=3D0  version=3D0x05  [SPC-3]
      [AERC=3D0]  [TrmTsk=3D0]  NormACA=3D0  HiSUP=3D0  Resp_data_format=3D2
      SCCS=3D1  ACC=3D0  TPGS=3D3  3PC=3D1  Protect=3D0  BQue=3D0
      EncServ=3D0  MultiP=3D0  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=3D0
      [RelAdr=3D0]  WBus16=3D0  Sync=3D0  Linked=3D0  [TranDis=3D0]  CmdQue=
=3D1
        length=3D36 (0x24)   Peripheral device type: disk
     Vendor identification: LIO-ORG=20
     Product identification: FILEIO         =20
     Product revision level: 4.0
     Unit serial number: 853ea439-7fcf-4aaa-9de2-1399e06b45be

I register both of the I_T nexuses with the target.

    root@node1:~# sg_persist --out --register --param-sark 0x1 /dev/sdc

    root@node2:~# sg_persist --out --register --param-sark 0x2 /dev/sdc

    root@node1:~# sg_persist --in --read-full-status /dev/sdc
      LIO-ORG   FILEIO            4.0
      Peripheral device type: disk
      PR generation=3D0x17
        Key=3D0x1
          All target ports bit clear
          Relative port address: 0x5
          not reservation holder
          Transport Id of initiator:
            iSCSI name and session id: iqn.1993-08.org.debian:01:node1
        Key=3D0x2
          All target ports bit clear
          Relative port address: 0x5
          not reservation holder
          Transport Id of initiator:
            iSCSI name and session id: iqn.1993-08.org.debian:01:node2

Then I get a persistent reservation with type 'Exclusive Access - All
Registrants' from node1.

    root@node1:~# sg_persist --out --reserve -T 8 --param-rk 0x1 /dev/sdc
    root@node1:~# sg_persist --in --read-full-status /dev/sdc
      LIO-ORG   FILEIO            4.0
      Peripheral device type: disk
      PR generation=3D0x17
        Key=3D0x1
          All target ports bit clear
          Relative port address: 0x5
          << Reservation holder >>
          scope: LU_SCOPE,  type: Exclusive Access, all registrants
          Transport Id of initiator:
            iSCSI name and session id: iqn.1993-08.org.debian:01:node1
        Key=3D0x2
          All target ports bit clear
          Relative port address: 0x5
          << Reservation holder >>
          scope: LU_SCOPE,  type: Exclusive Access, all registrants
          Transport Id of initiator:
            iSCSI name and session id: iqn.1993-08.org.debian:01:node2

As you can see both registrants are reported as reservations holders,
which is the right thing to do.

Now let's try to get a persistent reservation with the same type from
node2. SPC4r17 (par. 5.7.9 Reserving) states that:

    If the device server receives a PERSISTENT RESERVE OUT command with
    RESERVE service action where the TYPE field and the SCOPE field
    contain the same values as the existing type and scope from a
    persistent reservation holder, it shall not make any change to the
    existing persistent reservation and shall complete the command with
    GOOD status.

Node2 *is* a persistent reservation holder based on the wording of
SPC4r17 (par. 5.7.10 Persistent reservation holder).
But instead:

    root@node2:~# sg_persist --out --reserve -T 8 --param-rk 0x2 /dev/sdc
      LIO-ORG   FILEIO            4.0
      Peripheral device type: disk
    persistent reserve out: scsi status: Reservation Conflict
    PR out: command failed

and on the target machine I get:

    [95713.681066] SPC-3 PR: Attempted RESERVE from [iSCSI]:
    iqn.1993-08.org.debian:01:node2 while reservation already held by
    [iSCSI]: iqn.1993-08.org.debian:01:node1, returning
    RESERVATION_CONFLICT

If I try the same from node1, the target completes the command with GOOD
status.


It is clear that the target code still considers node1 as the (only)
reservation holder and only *reports* node2 as being a reservation
holder.

I believe we should fix the above errors by changing the
'pr_res_holder' inside the 't10_reservation' struct to be a list of
holders rather than trying to handle this implicitly. Having a single
holder in the code seems prone to more errors similar to this one.

Thanks,
Ilias

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUkuqEAAoJEFDGKLFobHg6wIsQAKFCB1ya56M5XJeAR3M1Acx7
x+MyzvwX6kEopizgiyB18iTnNhcwIhR7CeGW4gHlakiuyejWvBhvUgAeBQbFK9E+
6bSrdcpMIW2rjmWIvgBv7SDdEFGeQ33GWPkTdMJ/Hz4Ks5GpjnsjNdyOeoSMNp/y
F4SNtCd6INgyuk7HW+lKH78QwBp7V64BjmEwQc6moAWGGnn1XGSIcixDPANAkFDu
WjM4VGFg7n2LSATNhKpRgEJERReD7Kx0JxUeLQdPx00CGXLtSS71MV4pX1/1sv9A
lAuu24gLWDASgbuyPTcTz8V6sCxeb3wxKMic3jAnogmfTla9lDL+hjh3j8HHOuMx
s1HogiNuXryAgKEGsJJAYckeCnytfFPAsGEyqa142SBzinEgsazehNAMaHUv6FPM
kz8oTH+Cn/eZ7+gVfiDgWrJiwy8iwts32FPbSOsP23cjwvts3IHQnrQUNG0zR1Fk
nP+RNmneDlpgPxCWT+rTIeeLLSvY+jwthbVid9IQ1xRnGYT9R81MVH3DBUaQgvvl
WrfDxF1C+A4heVIgYSWC/or6V9u2LFFbTQTfqT4+mqk3xgjBFKxXWfmuxE1zW4aY
isU62tQkSseUtjaEy4mF0WI0Pcpi3svsSGtZoh4ZcIb1+aqfXaRiLTAD/I0Q/rXL
AjAcyKBFokGWzB1s/0f4
=u8Id
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
