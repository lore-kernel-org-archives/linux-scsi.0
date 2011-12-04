From: Stratos Psomadakis <psomas@gentoo.org>
Subject: Re: [SCSI] NULL pointer dereference in sym53c8xx (bisected)
Date: Sun, 04 Dec 2011 19:36:25 +0200
Message-ID: <4EDBAF99.6010904@gentoo.org>
References: <4ED8EE1C.4090404@gentoo.org> <4EDA8FA9.8020004@linux.vnet.ibm.com> <4EDABAB5.10104@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig86D68756C7202DB4D1D5E0E5"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EDABAB5.10104@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, stable@vger.kernel.org, gregkh@suse.de, linux-scsi@vger.kernel.org, JBottomley@parallels.com, matthew@wil.cx, Martin.vGagern@gmx.net, kernel@gentoo.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig86D68756C7202DB4D1D5E0E5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/04/2011 02:11 AM, Stratos Psomadakis wrote:
> On 12/03/2011 11:07 PM, Steffen Maier wrote:
>> On 12/02/2011 04:26 PM, Stratos Psomadakis wrote:
>>> After upstream commit 4e6c82b3614a18740ef63109d58743a359266daf ([SCSI=
]
>>> fix WARNING: at drivers/scsi/scsi_lib.c:1704), which is also included=
 in
>>> 3.0-stable and 3.1-stable kernels, the kernel fails to boot (NULL
>>> pointer dereference in sym53c8xx_slave_destroy).
>>>
>>> Bug report at the Gentoo Bugzilla (reported and bisected by Martin vo=
n
>>> Gagern). [1]  (stack trace [2])
>>>
>>> I think that the problem is that (after commit 4e6c82b)
>>> __scsi_remove_device() is called if slave_alloc() in scsi_alloc_sdev(=
)
>>> fails. But __scsi_remove_device() calls slave_destroy(), which (I thi=
nk)
>>> doesn't make much sense (ie to call slave_destroy() when slave_alloc(=
)
>>> fails).
>>>
>>> For sym53c8xx, this results in a NULL pointer dereference (struct
>>> sym_lcb pointer) in slave_destroy().
>>>
>>> [1] https://bugs.gentoo.org/show_bug.cgi?id=3D392567
>>> [2] https://392567.bugs.gentoo.org/attachment.cgi?id=3D294381
>> To me this looks like the same thing we encountered in the zfcp LLD:
>> http://www.spinics.net/lists/linux-scsi/msg55575.html
>> James explained the pairing of slave_alloc and slave_destroy even if
>> slave_alloc returned early in which case slave_destroy needs to cope
>> with that:
>> http://www.spinics.net/lists/linux-scsi/msg55449.html
>>
> Indeed.
>
> I'll follow-up with a patch similar to the one you sent for zfcp. I
> think that returning if sym_lcb is NULL should be ok.
I forgot to chain the patch email in this thread, so here's the link:
http://marc.info/?l=3Dlinux-scsi&m=3D132295936832641&w=3D2

>> HTH
>> Steffen
>>
>> Linux on System z Development
>>
>> IBM Deutschland Research & Development GmbH
>> Vorsitzender des Aufsichtsrats: Martin Jetter
>> Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
>> Sitz der Gesellschaft: B=C3=B6blingen
>> Registergericht: Amtsgericht Stuttgart, HRB 243294
>>
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
--=20
Stratos Psomadakis
<psomas@gentoo.org>



--------------enig86D68756C7202DB4D1D5E0E5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7br54ACgkQid1lVeNDMmCanACeIgbWzHsX1aif1O/J7ayHT7CF
V3UAn3pjstowPqmpvZa+DlRDccw4K7U5
=tR1T
-----END PGP SIGNATURE-----

--------------enig86D68756C7202DB4D1D5E0E5--
