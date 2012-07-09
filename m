From: NeilBrown <neilb@suse.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Tue, 10 Jul 2012 08:08:31 +1000
Message-ID: <20120710080831.1bb616fb@notabene.brown>
References: <4FE454CA.6080007@matthiasprager.de>
	<4FFAED4F.3080100@matthiasprager.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2Poz1k3K8_RW8j/FgSpk.V4"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab2GIWIf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jul 2012 18:08:35 -0400
In-Reply-To: <4FFAED4F.3080100@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org

--Sig_/2Poz1k3K8_RW8j/FgSpk.V4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Jul 2012 16:40:15 +0200 Matthias Prager <linux@matthiasprager.de>
wrote:

> Hello linux-scsi and linux-raid,
>=20
> I did some further research regarding my problem.
> It appears to me the fault does not lie with the mpt2sas driver (not
> that I can definitely exclude it), but with the md implementation.
>=20
> I reproduced what I think is the same issue on a different machine (also
> running Vmware ESXi 5 and an LSI 9211-8i in IR mode) with a different
> set of hard-drives of the same model. Using systemrescuecd
> (2.8.1-beta003) and booting the 64bit 3.4.4 kernel, I issued the
> following commands:
>=20
> 1) 'hdparm -y /dev/sda' (to put the hard-drive to sleep)
> 2) 'mdadm --create /dev/md1 --metadata 1.2 --level=3Dmirror
> --raid-devices=3D2 --name=3Dtest1 /dev/sda missing'
> 3) 'fdisk -l /dev/md127' (for some reason /proc/mdstat indicates the md
> is being created as md127)
>=20
> 2) gave me this feedback:
> ------
> mdadm: super1.x cannot open /dev/sda: Device or resource busy
> mdadm: /dev/sda is not suitable for this array.
> mdadm: create aborted
> -------
> Even though it says creating aborted it still created md127.

One of my pet peeves in when people interpret the observations wrongly and
then report their interpretation instead of their observation.  However
sometimes it is very hard to separate the two.  You comment above looks
perfectly reasonable and looks like a clean observation and not and
interpretation.  Yet it is an interpretation :-)

The observation would be
   "Even though it says creating abort, md127 was still created".

You see, it wasn't this mdadm that created md127 - it certainly shouldn't
have as you asked it to create md1.

I don't know the exact sequence of events, but something - possibly relating
to the error messages reported below - caused udev to notice /dev/sda.
udev then ran "mdadm -I /dev/sda" and as it had some metadata on it, it
created an array with it.  As the name information in that metadata was
probably "test1" or similar, rather than "1", mdadm didn't know what number
was wanted for the array, so it chose a free high number - 127.

This metadata must have been left over from an earlier experiment.

So it might have been something like.

- you run mdadm (call this mdadm-1).
- mdadm tries to open sda
- driver notices that device is asleep, and wakes it up
- the waking up of the device causes a CHANGE uevent to udev
- this cause udev to run a new mdadm - mdadm-2
- mdadm-2 reads the metadata, sees old metadata, assembled sda in a new md1=
27
- mdadm-1 gets scheduled again, tries to get O_EXCL access to sda and fails=
,=20
  because sda is now part of md127

Clearly undesirable behaviour.  I'm not sure which bit is "wrong".

NeilBrown


>=20
> And 3) lead to these lines in dmesg:
> -------
> [  604.838640] sd 2:0:0:0: [sda] Device not ready
> [  604.838645] sd 2:0:0:0: [sda]  Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE
> [  604.838655] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
> [  604.838663] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
> initializing command required
> [  604.838668] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 00 00 08 00 00 00
> 20 00
> [  604.838680] end_request: I/O error, dev sda, sector 2048
> [  604.838688] Buffer I/O error on device md127, logical block 0
> [  604.838695] Buffer I/O error on device md127, logical block 1
> [  604.838699] Buffer I/O error on device md127, logical block 2
> [  604.838702] Buffer I/O error on device md127, logical block 3
> [  604.838783] sd 2:0:0:0: [sda] Device not ready
> [  604.838785] sd 2:0:0:0: [sda]  Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE
> [  604.838789] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
> [  604.838793] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
> initializing command required
> [  604.838797] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 00 00 08 00 00 00
> 08 00
> [  604.838805] end_request: I/O error, dev sda, sector 2048
> [  604.838808] Buffer I/O error on device md127, logical block 0
> [  604.838983] sd 2:0:0:0: [sda] Device not ready
> [  604.838986] sd 2:0:0:0: [sda]  Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE
> [  604.838989] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
> [  604.838993] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
> initializing command required
> [  604.838998] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 57 54 65 d8 00 00
> 08 00
> [  604.839006] end_request: I/O error, dev sda, sector 1465148888
> [  604.839009] Buffer I/O error on device md127, logical block 183143355
> [  604.839087] sd 2:0:0:0: [sda] Device not ready
> [  604.839090] sd 2:0:0:0: [sda]  Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE
> [  604.839093] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
> [  604.839097] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
> initializing command required
> [  604.839102] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 57 54 65 d8 00 00
> 08 00
> [  604.839110] end_request: I/O error, dev sda, sector 1465148888
> [  604.839113] Buffer I/O error on device md127, logical block 183143355
> [  604.839271] sd 2:0:0:0: [sda] Device not ready
> [  604.839274] sd 2:0:0:0: [sda]  Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE
> [  604.839278] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
> [  604.839282] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
> initializing command required
> [  604.839286] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 00 00 08 00 00 00
> 20 00
> [  604.839321] end_request: I/O error, dev sda, sector 2048
> [  604.839324] Buffer I/O error on device md127, logical block 0
> [  604.839330] Buffer I/O error on device md127, logical block 1
> [  604.840494] sd 2:0:0:0: [sda] Device not ready
> [  604.840497] sd 2:0:0:0: [sda]  Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE
> [  604.840504] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
> [  604.840512] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
> initializing command required
> [  604.840516] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 00 00 08 00 00 00
> 08 00
> [  604.840526] end_request: I/O error, dev sda, sector 2048
> ------
>=20
> This excludes hardware-errors (different physical machine and devices)
> as cause and also ext4 which the other system was using as filesystem.
> Maybe Neil Brown (who scripts/get_maintainer.pl identified as the
> maintainer of the md-code) can make bits and pieces of this. It may well
> be this is the same problem but a different error-path - I don't know.
>=20
> I will try to make the scenario more generic, but I don't have a
> non-virtual machine to spare atm. Also please do let me know if I'm
> posting this to the wrong lists (linux-scsi and linux-raid) or if there
> is anything which might not be helpful with the way I'm reporting this.
>=20
> Regards,
> Matthias Prager
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/2Poz1k3K8_RW8j/FgSpk.V4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/tWXznsnt1WYoG5AQJxYhAAiBzVpXcH/Z9cRZISeJDZaVEQnZTR3NYK
8VeD/9PC0vdSA1P5KrZWTpQSQ2CA0ajhx5iW/sI53PnaxblP7vL5fnCtx9Iz1gB6
YHVPmaC26qTt8+HfztpTzHD39CtQ43TK4Vn6mGX6YhpnhNx/Vq3vaYWDldLmEi8K
InQMTLvVh8jE17IPK6JHkQHGhEKj+eqveb0e6Bi6OUNiO8f/Z2juPLlsWx9n+Zwr
xlqA1YfezBwthaB6cBWdvGh8Oq+Oyh+Oqnq05VwznR/9JNEMFSyLrcTZU1lvxrFA
PBtpjNa4xrsuN56J4TJxctbW8Szor4nXWktJlvARVUMm1VI9XNcGfpdQFp1fuBaC
Rf2b8nfsbS+xLNAm4XSjAEOJwZOFjAZlSmYVX+l42QxJyIV+8Rr1J9rB0PLjvVDz
/RkDOyK7SLZXu0PDe34av/IDD7jQWLzbXEa3NQ9QCkapIsa3fotxBkTJrEnWvJ++
zPiv1lFUZy5GRfYzAU8FsMRzUJYcrS8eqMZtYW5Vk+yzsyFVQt9W+IV/vq2LEeQ2
Qx+4+vh10k2cerah1hwENc3OsWeqmeOLTfDaQXixxdIQVAxiQi3jWGZEE8psO4ty
hxGvM41ZgpHFF/ZDjEoi00UUc17fVcG2i57bAcElamRaPPDIb8XKYpF8ROHWygH7
Ql6dg4mPy9k=
=jxYC
-----END PGP SIGNATURE-----

--Sig_/2Poz1k3K8_RW8j/FgSpk.V4--
