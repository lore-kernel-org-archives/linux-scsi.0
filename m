From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ide cd writer problem with sg
Date: Sun, 28 Jul 2002 22:05:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D44A2E9.DB32586E@torque.net>
References: <3D447677.9070309@localhost.>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Michel Briand <michelbriand@free.fr>
Cc: linux-scsi@vger.kernel.org

Michel Briand wrote:
>=20
> hello,
> i use an IDE cdwrite with sg, and when thoses modules are loaded,
> cdrecord -scanbus works :
> sg                     24036   0  (autoclean)
> ide-scsi                7648   0  (autoclean)
> scsi_mod               49804   2  (autoclean) [sg ide-scsi]
> which produces :
> Cdrecord 1.11a19 (i686-suse-linux) Copyright (C) 1995-2002 J=F6rg Sch=
illing
> Linux sg driver version: 3.1.22
> Using libscg version 'schily-0.6'
> scsibus0:
>         0,0,0     0) 'LITE-ON ' 'LTR-16102B      ' 'OS0E' Removable C=
D-ROM
>         0,1,0     1) *
>         0,2,0     2) *
>         0,3,0     3) *
>         0,4,0     4) *
>         0,5,0     5) *
>         0,6,0     6) *
>         0,7,0     7) *
> Nice.
> But to mount the cdrom i experience some problems. Note that i have :
> - kernel 2.4.18
> - cd support compiled as modules : scsi_mod, ide-scsi, sg, sr_mod,
> ide-cd, cdrom (all modules)
> - only one cdwriter, no cdrom : /dev/hdc and no /dev/hdd
>=20
> i.e. with find /proc/ide -type d -ls :
> 4307    0 dr-xr-xr-x   4 root     root            0 jui 29 00:51 /pro=
c/ide/
> 4327    0 dr-xr-xr-x   3 root     root            0 jui 29 00:51
> /proc/ide/ide1
> 4332    0 dr-xr-xr-x   2 root     root            0 jui 29 00:51
> /proc/ide/ide1/hdc
> 4308    0 dr-xr-xr-x   4 root     root            0 jui 29 00:51
> /proc/ide/ide0
> 4320    0 dr-xr-xr-x   2 root     root            0 jui 29 00:51
> /proc/ide/ide0/hdb
> 4313    0 dr-xr-xr-x   2 root     root            0 jui 29 00:51
> /proc/ide/ide0/hda
>=20
> and when i issue this command, i get an error :
> bubus:/media # modprobe sr_mod
> bubus:/media # mount /dev/cdrom /media/cdrom -t iso9660
> mount : P=E9riph=E9rique de bloc/dev/cdrom est prot=E9g=E9 en =E9crit=
ure. Montage
> en lecture seule.
> mount: N'est pas un r=E9pertoire

Michel,
It seems to be saying that /media/cdrom is not a directory.
Perhaps you could show us "ls -l /media".

Also /dev/cdrom is probably a symlink to /dev/scd0, could
you confirm that?

cdrecord and the sg driver are finding the ATAPI writer ok
(as indicated by "cdrecord -scanbus") so I don't think=20
there is a problem with your cd writer or sg.

<snip/>

Doug Gilbert
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
