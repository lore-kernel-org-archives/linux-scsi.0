From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20072] tapeinfo reports MaxBlock: 16777215  but writes with
 blocksize >2M fail
Date: Wed, 13 Oct 2010 18:36:50 GMT
Message-ID: <201010131836.o9DIaojI009460@demeter2.kernel.org>
References: <bug-20072-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:49537 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab0JMSgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2010 14:36:50 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9DIao9X009461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2010 18:36:50 GMT
In-Reply-To: <bug-20072-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D20072





--- Comment #4 from Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>  2010-=
10-13 18:36:45 ---
On Wed, 13 Oct 2010, bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=3D20072
>=20
>=20
>=20
>=20
>=20
> --- Comment #2 from lkolbe@techfak.uni-bielefeld.de  2010-10-11 11:25=
:15 ---
> This is what dmesg has to say about the earlier tries to write to the=
 device
> with higher than 2MiB blocksizes:
>=20
> [92315.076956] st0: Block limits 1 - 16777215 bytes.
> [92445.438048] st0: Can't allocate 15728640 byte tape buffer.
> [92457.973733] st0: Can't allocate 16777215 byte tape buffer.
> [92460.990589] st0: Can't allocate 16777214 byte tape buffer.
>=20
> --- Comment #3 from lkolbe@techfak.uni-bielefeld.de  2010-10-13 09:50=
:22 ---
> When instructing bacula to use the advertised tape blocksize of 16M, =
we get the
> following errors everytime it tries to access the tape:
>=20
> 13-Oct 11:48 sd1.techfak JobId 2692: Error: block.c:1002 Read error o=
n fd=3D5 at
> file:blk 0:0 on device "drv2" (/dev/nst0). ERR=3DCannot allocate memo=
ry.
>=20
> Is there some limit/sysctl we might have to adapt to the native tape =
drive
> blocksize of 16M?
>=20
There is a limit that comes from physical constraints and memory=20
fragmentation. Because of fragmentation, it is often not possible to fi=
nd=20
larger chunks of free memory than one page (e.g., 4 kB). The SCSI HBA=20
supports often only a certain number of scatter/gather segments. Let's=20
assume that this limit is 256. This means that the largest possible SCS=
I=20
data buffer is 256 x 4 kB =3D 1 MB. This limits the possible block size=
=2E=20
Depending on the state of fragmentation, the actual limit may be larger=
=20
but this is the limit of the block size you can always use.

The st driver (with defaults) first tries to map the user buffer to the=
=20
number of available scatter/gather segments. If this fails, the driver=20
tries to allocate a local buffer using as large chunks of memory as it =
can=20
get. If this succeeds, the request may still fail because of SCSI midle=
vel=20
limits (I don't know what the limits currently are, but, if there are=20
limits, they are tunable).

I have been able to read and write 16MB-1 blocks with my system. What y=
ou=20
can actually reach depends on the things above.

Kai

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
