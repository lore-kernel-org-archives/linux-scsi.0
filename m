From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Trying to troubleshoot ornery Phison usb-storage
Date: Fri, 14 Mar 2003 12:24:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030314122408.B32112@one-eyed-alien.net>
References: <m34r65lrmq.fsf@bfnet.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <m34r65lrmq.fsf@bfnet.com>; from dave-gnus@bfnet.com on Fri, Mar 14, 2003 at 10:39:25AM -0800
List-Id: linux-scsi@vger.kernel.org
To: David Wuertele <dave-gnus@bfnet.com>
Cc: linux-scsi@vger.kernel.org, linux-usb-users@lists.sourceforge.net


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Have you tried USB Storage Verbose Debugging?

Matt

On Fri, Mar 14, 2003 at 10:39:25AM -0800, David Wuertele wrote:
> I've got a board with a phison flash-card reader chip on it, and I
> don't seem to be able to get any of the usb-storage features to work.
> I'm looking for troubleshooting tips.
>=20
> I'm using linux version 2.4.18 on a mipsel architecture.  I get the
> same negative results whether or not I'm using the phison patch from
> http://www.fuw.edu.pl/~pliszka/linux-USB/Phison.tgz. When I try to
> fdisk a card inserted in the slot, I get:
>=20
>   # fdisk /dev/scsi/host0/bus0/target0/lun1/disc
>   Device contains neither a valid DOS partition table, nor Sun, SGI or OS=
F disklabel
>   Building a new DOS disklabel. Changes will remain in memory only,
>   until you decide to write them. After that, of course, the previous
>   content won't be recoverable.
>=20
> The console always prints:
>=20
>   SCSI error: host 0 id 0 lun 1 return code =3D 8000002
>         Sense class 7, sense error 0, extended sense 7
>=20
> I try to create a new Linux partion, which appears to work at first:
>=20
>   Disk /dev/scsi/host0/bus0/target0/lun1/disc: 34 heads, 61 sectors, 1011=
 cylinders
>   Units =3D cylinders of 2074 * 512 bytes
>=20
>                                    Device Boot    Start       End    Bloc=
ks   Id  System
>   /dev/scsi/host0/bus0/target0/lun1/part1             1      1011   10483=
76+  83  Linux
>=20
>   Command (m for help): w
>   The partition table has been altered!
>=20
>   Calling ioctl() to re-read partition table.
>=20
>   WARNING: If you have created or modified any DOS 6.x
>   partitions, please see the fdisk manual page for additional
>   information.
>   Syncing disks.
>   #
>=20
> The console at this point has printed:
>=20
>   sdb : READ CAPACITY failed.
>   sdb : status =3D 1, message =3D 00, host =3D 0, driver =3D 08=20
>   Current sd00:00: sns =3D 70  7
>   ASC=3D27 ASCQ=3D 0
>   Raw sense data:0x70 0x00 0x07 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0=
x00 0x27 0x00 0x00 0x00 0x00 0x00=20
>   sdb : block size assumed to be 512 bytes, disk size 1GB. =20
>   sdb: Write Protect is off
>    p1
>   sdb : READ CAPACITY failed.
>   sdb : status =3D 1, message =3D 00, host =3D 0, driver =3D 08=20
>   Current sd00:00: sns =3D 70  7
>   ASC=3D27 ASCQ=3D 0
>   Raw sense data:0x70 0x00 0x07 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0=
x00 0x27 0x00 0x00 0x00 0x00 0x00=20
>   sdb : block size assumed to be 512 bytes, disk size 1GB. =20
>   sdb: Write Protect is off
>    p1
>=20
> So I try to make a filesystem and mount:
>=20
>   mkfs /dev/scsi/host0/bus0/target0/lun1/part1
>   mke2fs 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
>   Filesystem label=3D
>   OS type: Linux
>   Block size=3D4096 (log=3D2)
>   Fragment size=3D4096 (log=3D2)
>   131072 inodes, 262094 blocks
>   13104 blocks (5.00%) reserved for the super user
>   First data block=3D0
>   8 block groups
>   32768 blocks per group, 32768 fragments per group
>   16384 inodes per group
>   Superblock backups stored on blocks:=20
>           32768, 98304, 163840, 229376
>=20
>   Writing inode tables: 0/8=08=08=081/8=08=08=082/8=08=08=083/8=08=08=084=
/8=08=08=085/8=08=08=086/8=08=08=087/8=08=08=08done                        =
   =20
>   Writing superblocks and filesystem accounting information: done
>=20
>   This filesystem will be automatically checked every 20 mounts or
>   180 days, whichever comes first.  Use tune2fs -c or -i to override.
>   # mount /dev/scsi/host0/bus0/target0/lun1/part1 /mnt/test
>   mount: Mounting /dev/scsi/host0/bus0/target0/lun1/part1 on /mnt/test fa=
iled: Invalid argument
>   #=20
>=20
> The console now prints:
>=20
>   SCSI error: host 0 id 0 lun 1 return code =3D 8000002
>           Sense class 7, sense error 0, extended sense 7
>   SCSI error: host 0 id 0 lun 1 return code =3D 8000002
>           Sense class 7, sense error 0, extended sense 7
>   SCSI error: host 0 id 0 lun 1 return code =3D 8000002
>           Sense class 7, sense error 0, extended sense 7
>   VFS: Can't find ext2 filesystem on dev sd(8,17).
>   SCSI error: host 0 id 0 lun 1 return code =3D 8000002
>           Sense class 7, sense error 0, extended sense 7
>   FAT: bogus logical sector size 0
>   VFS: Can't find a valid FAT filesystem on dev 08:11.
>   SCSI error: host 0 id 0 lun 1 return code =3D 8000002
>           Sense class 7, sense error 0, extended sense 7
>   SCSI error: host 0 id 0 lun 1 return code =3D 8000002
>           Sense class 7, sense error 0, extended sense 7
>=20
> Now when I try to fdisk the same card, it has forgotten the partition:
>=20
>   # fdisk /dev/scsi/host0/bus0/target0/lun1/disc
>   Device contains neither a valid DOS partition table, nor Sun, SGI or OS=
F disklabel
>   Building a new DOS disklabel. Changes will remain in memory only,
>   until you decide to write them. After that, of course, the previous
>   content won't be recoverable.
>=20
>=20
>   Command (m for help): p
>=20
>   Disk /dev/scsi/host0/bus0/target0/lun1/disc: 34 heads, 61 sectors, 1011=
 cylinders
>   Units =3D cylinders of 2074 * 512 bytes
>=20
>                                    Device Boot    Start       End    Bloc=
ks   Id  System
>=20
>   Command (m for help):=20
>=20
> Any suggestions on how to troubleshoot this?  I've posted a more
> verbose console output at http://www.rokulabs.com/phison-console.txt
> and the shell that goes with it at http://www.rokulabs.com/phison-shell.t=
xt.
>=20
> Thanks,
> Dave
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I could always suspend a few hundred accounts and watch what happens.
					-- Tanya
User Friendly, 7/31/1998

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+cjpoIjReC7bSPZARAnrZAKCaEbxNRQ9GCJWQwoRSWvQjqm+LugCdHc9E
A1xwmE6iCgE1WYPPbt8zFg0=
=toUu
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
