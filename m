From: Christian Hesse <list@eworm.de>
Subject: iSCSI regression with linux 3.9 and 4.0
Date: Fri, 20 Mar 2015 13:57:42 +0100
Message-ID: <20150320135742.63df219b@leda.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/T51El1zgS9jqbGFlhz86f6u"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:50223 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbCTNDt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2015 09:03:49 -0400
Received: from leda.localdomain (unknown [10.10.1.2])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.mylinuxtime.de (Postfix) with ESMTPSA id F2BE7245F3
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2015 13:57:47 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--Sig_/T51El1zgS9jqbGFlhz86f6u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello everybody!

I reported this issue at LKML [0] but received no answer. Hopefully
linux-scsi is a better place...

Beginning with linux 3.19 I see an iSCSI regressen. This works perfectly wi=
th
linux 3.18.x (tested with 3.18.6) and before. Effected kernels I tested are
3.19.0, 3.19.2 and 4.0rc4.r199.gb314aca.

The logs tell the story:

Feb 19 11:26:49 thebe kernel: scsi host6: iSCSI Initiator over TCP/IP
Feb 19 11:26:49 thebe kernel: scsi 6:0:0:0: Direct-Access     QNAP     iSCS=
I Storage    4.0  PQ: 0 ANSI: 5
Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] 1073741824 512-byte logical=
 blocks: (549 GB/512 GiB)
Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Write Protect is off
Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Mode Sense: 2f 00 00 00
Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Write cache: disabled, read=
 cache: enabled, doesn't support DPO or FUA
Feb 19 11:26:49 thebe kernel:  sdb: unknown partition table
Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Attached SCSI disk
Feb 19 11:26:49 thebe iscsid[10804]: Connection1:0 to [target: iqn.2004-04.=
com.qnap:ts-859:iscsi.xxxxxxx.c40a18, portal: xx.xx.xx.xx,3260] through [if=
ace: default] is operational now
Feb 19 11:26:57 thebe kernel:  sdb: unknown partition table
Feb 19 11:28:20 thebe kernel: EXT4-fs (dm-8): mounting with "discard" optio=
n, but the device does not support discard
Feb 19 11:28:20 thebe kernel: EXT4-fs (dm-8): mounted filesystem with order=
ed data mode. Opts: (null)
Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] UNKNOWN Result: hostbyte=3D=
0x00 driverbyte=3D0x08
Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] Sense Key : 0x5 [current]
Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] ASC=3D0x24 ASCQ=3D0x0
Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] CDB:=20
Feb 19 11:28:24 thebe kernel: cdb[0]=3D0x2a: 2a 00 34 5b 07 ff 00 2f 88 00
Feb 19 11:28:24 thebe kernel: blk_update_request: critical target error, de=
v sdb, sector 878381055
Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:3=
17: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 s=
tarting block 108749056)
Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical bloc=
k 108749056
Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical bloc=
k 108749057
Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical bloc=
k 108749058
Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical bloc=
k 108749059
Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical bloc=
k 108749060
Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical bloc=
k 108749061
Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical bloc=
k 108749062
Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical bloc=
k 108749063
Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical bloc=
k 108749064
Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical bloc=
k 108749065
Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:3=
17: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 s=
tarting block 108749312)
Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:3=
17: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 s=
tarting block 108749568)
Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:3=
17: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 s=
tarting block 108749824)
Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:3=
17: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 s=
tarting block 108750080)
Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:3=
17: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 s=
tarting block 108750336)
Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb] UNKNOWN Result: hostbyte=3D=
0x00 driverbyte=3D0x08
Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb] Sense Key : 0x5 [current]
Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb] ASC=3D0x24 ASCQ=3D0x0
Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb] CDB:=20
Feb 19 11:29:10 thebe kernel: cdb[0]=3D0x2a: 2a 00 20 44 89 17 00 20 50 00
Feb 19 11:29:10 thebe kernel: blk_update_request: critical target error, de=
v sdb, sector 541362455
Feb 19 11:29:10 thebe kernel: Buffer I/O error on dev dm-8, logical block 6=
6621731, lost sync page write
Feb 19 11:29:10 thebe kernel: Aborting journal on device dm-8-8.
Feb 19 11:29:10 thebe kernel: EXT4-fs error (device dm-8): ext4_journal_che=
ck_start:56: Detected aborted journal
Feb 19 11:29:10 thebe kernel: EXT4-fs (dm-8): Remounting filesystem read-on=
ly
Feb 19 11:29:20 thebe kernel: EXT4-fs error (device dm-8): ext4_put_super:7=
80: Couldn't clean up the journal

[0] https://lkml.org/lkml/2015/2/19/91
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Chris           get my mail address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*               gcc -o sig sig.c && ./sig    */b/42*2-3)*42);}

--Sig_/T51El1zgS9jqbGFlhz86f6u
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVDBlGAAoJEIlFIdfMgPR2O0AH/RMCHdwn19XyiesDbTNx1IXg
q54g55818ZXSWkoXGYxUFOwwmzYT7ET1v21D5Gl4c9N8cGZQlXZqMaONGWHv2Tkc
KWXb9XibCyvK0ZBKBv9ciaycS1sJ+RtdQxn/4qmIjpkRHabrQxEhGFTzxawrRDY5
8NGI337JDqkQYOUXMwJLQRRroGEH3NTmsY51RLoOK7z1ENEjKkEXXgJg9vc0L0EU
TBtv1y9uYSEkBPATaf1p5kBO+9fQxIN1AS4EL2p+Pf0FGolgafdFQGHTFzwQNnHk
R0gqWGcavqPwp/x7TgFWlQpBBDZ46/AK83hdr5Z4Z/hc+6pXOXCRLnvpD0eYxAg=
=coAJ
-----END PGP SIGNATURE-----

--Sig_/T51El1zgS9jqbGFlhz86f6u--
