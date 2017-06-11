From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: arcmsr: abort device command message weirdness (LUN mismatch)
Date: Sun, 11 Jun 2017 15:40:02 -0400
Message-ID: <20170611154002.02c0dabb@Vantage.cJ>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw
List-Id: linux-scsi@vger.kernel.org

Hi Ching,


Context: when a drive finally failed in my JBOD array, I discovered that
the whole ARC1880X controller would timeout, disabling access to any drive,
which is kind of sad.
I've performed a firmware upgrade and added back the failing drive to see
what happens with a newer device firmware (to be continued).

While doing "cat /dev/${FAILING_DRIVE}", at some point the command fails
(as expected) and while looking at the system logs, I observed that there
were reports of 2 abort sequences initiated then completed, but the
completion message mentions a LUN that is not the one of the failing drive,
which is curious.

[  959.065760] arcmsr0: abort device command of scsi id =3D 0 lun =3D 4
[  961.804842] arcmsr0: abort device command of scsi id =3D 0 lun =3D 4

...

[  991.834471] arcmsr0: abort device command of scsi id =3D 0 lun =3D 0
[  991.840503] arcmsr0: scsi id =3D 0 lun =3D 0 ccb =3D '0xffff8808594a6b80=
' poll command abort successfully=20
[  991.849675] arcmsr0: scsi id =3D 0 lun =3D 4 ccb =3D '0xffff880859424600=
' poll command abort successfully=20
[  991.858869] arcmsr: executing bus reset eh.....num_resets =3D 0, num_abo=
rts =3D 3=20
[  991.866199] arcmsr0: executing hw bus reset .....
[ 1005.135825] Areca RAID Controller0: Model ARC-1880, F/W V1.54 2016-11-23
[ 1005.229790] arcmsr: scsi bus reset eh returns with success
[ 1019.145652] sd 0:0:0:4: [sdac] tag#0 FAILED Result: hostbyte=3DDID_OK dr=
iverbyte=3DDRIVER_SENSE
[ 1019.154095] sd 0:0:0:4: [sdac] tag#0 Sense Key : Medium Error [current]=
=20
[ 1019.160876] sd 0:0:0:4: [sdac] tag#0 Add. Sense: Unrecovered read error
[ 1019.167512] sd 0:0:0:4: [sdac] tag#0 CDB: Read(10) 28 00 00 04 36 00 00 =
02 00 00
[ 1019.174920] blk_update_request: I/O error, dev sdac, sector 275968

(kernel 4.12.0-rc4-00310-g6b7ed4588ce6).


Regards,

--=20
J=C3=A9r=C3=B4me
