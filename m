From: Fabien Salvi <fabien@cri74.org>
Subject: Re: hot scsi disk resize
Date: Tue, 04 Mar 2003 10:31:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E64727C.9040204@cri74.org>
References: <m3bs0s9xij.fsf@lexa.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alex Tomas <bzzz@tmi.comex.ru>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>



Alex Tomas a =E9crit:
> Hello!
>=20
> Here is patch to implement hot scsi resize function.
> Modern storage boxes support virtualization feature and
> may change logical volume size online. I think it would
> be great if linux supports such abilities. Look at
> this example:
>=20
> root@zefir:# dmesg | tail
> scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
> SCSI device sda: 2097152 512-byte hdwr sectors (1074 MB)
> SCSI device sda: drive cache: write through
>  sda: unknown partition table
> Attached scsi disk sda at scsi0, channel 0, id 1, lun 0
>=20
> root@zefir:# mount -treiserfs /dev/sda /mnt
>=20
> root@zefir:# df -Th
> Filesystem    Type    Size  Used Avail Use% Mounted on
> /dev/hda1     ext3    1.9G  1.8G  138M  93% /
> /dev/sda  reiserfs    1.0G   33M  991M   4% /mnt
>=20
> root@zefir:# echo 'scsi rescan 0 0 1 0' >/proc/scsi/scsi=20
> root@zefir:# dmesg|tail -n1
> SCSI device sda: 20971520 512-byte hdwr sectors (10737 MB)
> root@zefir:# resize_reiserfs /dev/sda=20
>=20
> <-------------resize_reiserfs, 2002------------->
> reiserfsprogs 3.6.4
>=20
> root@zefir:# df -Th
> Filesystem    Type    Size  Used Avail Use% Mounted on
> /dev/hda1     ext3    1.9G  1.8G  138M  93% /
> /dev/sda  reiserfs     10G   33M  9.9G   1% /mnt

Well, I also think it's a very important and needed feature for HA syst=
ems.
I'm very interested in such things...

But, I thought resize_reiserfs only resize *unmounted* filesystem :
http://www.reiserfs.org/resize_reiserfs.html

Will it work under IO load ?

Reiserfs has a way to do it dynamically while using it, with mount opti=
on :
http://www.reiserfs.org/mount-options.html

I've tested this without a lot of success (I encounter a lot of problem=
s).


I'm afraid that even if scsi subsystem support the resize option,=20
=46ileSystems won't support it correctly...
Maybe with LVM ?

Did someone test it ?

--=20
=46abien SALVI      Centre de Ressources Informatiques
                   Archamps, France -- http://www.cri74.org
                   PingOO GNU/linux distribution : http://www.pingoo.or=
g

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
