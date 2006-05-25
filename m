From: Limin Wang <lance.lmwang@gmail.com>
Subject: Re: resizing LUN (not file system) while the file system (ext3) is online
Date: Thu, 25 May 2006 13:40:27 +0800
Message-ID: <20060525054027.GA6905@laptop.exavio.cn>
References: <043001c67fba$5ff05b70$6400a8c0@andreyT43>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:5242 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S965037AbWEYFko (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 01:40:44 -0400
Received: by py-out-1112.google.com with SMTP id b36so2236284pyb
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2006 22:40:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <043001c67fba$5ff05b70$6400a8c0@andreyT43>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Try with LVM, resize can be done online, without disrupting user service.


Regards,
Limin

* Andrey Dmitriev <admitriev@mentora.com> [2006-05-25 01:16:27 -0400]:

> Dear List,
>=20
> Both EMC and NetApp claim that the file system needs to be unmounted while
> the LUN is being resized (migrated and resized in our case).=20
>=20
> I understand that ext3 doesn't support online expansion (not in RedHat ES=
/AS
> at least), however, does it really matter what you're doing to the actual
> LUN in the background (as long as you're not reducing the LUN size)? The
> operating system won't know the partitioning changed until you tell it to
> reread the partition table.=20
>=20
> Not following EMC/NetApp 'overcautious' instructions could save a tremend=
ous
> amount of time during a LUN migration (instead of waiting for a LUN to
> migrate while the file system is online, the only wait you really sustain=
 is
> how fast you type and re-partition)
>=20
> I have just tried this with ext3 file system online, and it worked like I
> expected it to work.
>=20
> EMC specifically states in the emc122304 (from their knowledge base):=20
> " Step 3: Increase the size of the LUN using the backend array tools. In
> some cases, like with CLARiiON MetaLUN, this can actually be performed
> "online" in order to decrease the time that the file system is unavailabl=
e.
> However, just because the disk array can be done online that does not mean
> the application layer can handle online expansion (some file systems can
> handle online expansion, currently ext3 cannot)."
>=20
> Yeah, file system can't expand.. but I am resizing the file system offlin=
e,
> why can't I resize the LUN online?
>=20
> Am I missing something?
>=20
> Below are my results.. I tried doing IO while migrating (and resizing) the
> LUN, but I think IO seized before migration was complete. Also, the major=
ity
> of LUNs that usually need resizing are near capacity, mine obviously wasn=
't
>=20
> B4 migration/growth
>=20
> [root@ad-nfs1 kerberos]# df -k
> /dev/emcpowerc1       20642412   5030932  14562908  26% /emc1
>=20
> --after growth while the system was online
>=20
> fdisk /dev/emcpowerc
> Disk /dev/emcpowerc: 21.4 GB, 21474836480 bytes
> 64 heads, 32 sectors/track, 20480 cylinders
> Units =3D cylinders of 2048 * 512 =3D 1048576 bytes
>=20
>          Device Boot      Start         End      Blocks   Id  System
> /dev/emcpowerc1               1       20480    20971504   83  Linux
>=20
> Command (m for help): q
>=20
> [root@ad-nfs1 kerberos]# sfdisk -R /dev/emcpowerc
> [root@ad-nfs1 kerberos]# fdisk /dev/emcpowerc
>=20
> The number of cylinders for this disk is set to 30720.
> There is nothing wrong with that, but this is larger than 1024,
> and could in certain setups cause problems with:
> 1) software that runs at boot time (e.g., old versions of LILO)
> 2) booting and partitioning software from other OSs
>    (e.g., DOS FDISK, OS/2 FDISK)
>=20
> Command (m for help): p
>=20
> Disk /dev/emcpowerc: 32.2 GB, 32212254720 bytes
> 64 heads, 32 sectors/track, 30720 cylinders
> Units =3D cylinders of 2048 * 512 =3D 1048576 bytes
>=20
>          Device Boot      Start         End      Blocks   Id  System
> /dev/emcpowerc1               1       20480    20971504   83  Linux
>=20
>=20
> [root@ad-nfs1 kerberos]# fdisk /dev/emcpowerc
>=20
> The number of cylinders for this disk is set to 30720.
> There is nothing wrong with that, but this is larger than 1024,
> and could in certain setups cause problems with:
> 1) software that runs at boot time (e.g., old versions of LILO)
> 2) booting and partitioning software from other OSs
>    (e.g., DOS FDISK, OS/2 FDISK)
>=20
> Command (m for help): p
>=20
> Disk /dev/emcpowerc: 32.2 GB, 32212254720 bytes
> 64 heads, 32 sectors/track, 30720 cylinders
> Units =3D cylinders of 2048 * 512 =3D 1048576 bytes
>=20
>          Device Boot      Start         End      Blocks   Id  System
> /dev/emcpowerc1               1       20480    20971504   83  Linux
>=20
> Command (m for help): d
> Selected partition 1
>=20
> Command (m for help): p
>=20
> Disk /dev/emcpowerc: 32.2 GB, 32212254720 bytes
> 64 heads, 32 sectors/track, 30720 cylinders
> Units =3D cylinders of 2048 * 512 =3D 1048576 bytes
>=20
>          Device Boot      Start         End      Blocks   Id  System
>=20
> Command (m for help): n
> Command action
>    e   extended
>    p   primary partition (1-4)
> 1
> Invalid partition number for type `1'
> Command action
>    e   extended
>    p   primary partition (1-4)
> p
> Partition number (1-4): 1
> First cylinder (1-30720, default 1):
> Using default value 1
> Last cylinder or +size or +sizeM or +sizeK (1-30720, default 30720):
> Using default value 30720
>=20
> Command (m for help): w
> The partition table has been altered!
>=20
> Calling ioctl() to re-read partition table.
> Syncing disks.
> [root@ad-nfs1 kerberos]# fdisk -l /dev/emcpowerc
>=20
> Disk /dev/emcpowerc: 32.2 GB, 32212254720 bytes
> 64 heads, 32 sectors/track, 30720 cylinders
> Units =3D cylinders of 2048 * 512 =3D 1048576 bytes
>=20
>          Device Boot      Start         End      Blocks   Id  System
> /dev/emcpowerc1               1       30720    31457264   83  Linux
>=20
>=20
> -- notice, w/o fsck it'll not resize.. w/o -f option
>=20
> [root@ad-nfs1 kerberos]# time fsck -f /dev/emcpowerc1
> fsck 1.35 (28-Feb-2004)
> e2fsck 1.35 (28-Feb-2004)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/emcpowerc1: 254481/2621440 files (0.8% non-contiguous), 1410133/5242=
876
> blocks
>=20
> real    1m4.984s
> user    0m1.348s
> sys     0m1.617s
> [root@ad-nfs1 kerberos]# resize2fs /dev/emcpowerc1
> resize2fs 1.35 (28-Feb-2004)
> Resizing the filesystem on /dev/emcpowerc1 to 7864316 (4k) blocks.
> The filesystem on /dev/emcpowerc1 is now 7864316 blocks long.
>=20
> [root@ad-nfs1 kerberos]# mount /dev/emcpowerc1 /emc1/
> [root@ad-nfs1 kerberos]# df -k|grep emc
> /dev/emcpowerc1       30963692   5311440  24393964  18% /emc1
>=20
>=20
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iQEVAwUBRHVDSzS5KN/wlg3IAQL8XwgAvleUcmHZfQANA9juceKaHj7wZar+CMb9
5WpFhVDGfeqGR3vvlLGlRF3N3qytxD2Bb4NKDnUU8pxLbZ0dqc+89NK3UYOA0ijf
YhK9vsbNecrnOIftEpJULQVVMezA4Kxn+M9yl96+uP4tCmfSeAW/1jNNjQt5KfWE
pPZKEnlRBrtKxpphT1IAG5vG+j3MM/W2ovDBm5Ux7mfAqdvyBF7NeZDCfMiQQqBr
IQbhHdIswYcSYNl75ZfJpZsktUcN2fIkct9KjPz9D7fBf72Z0HwyS0vwKfHN7WJC
mQiTMV8F7aT+XGgTjtuTPqYop0voZDVRRlMSHgD88Rzvm6uliKeFJA==
=js6N
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
