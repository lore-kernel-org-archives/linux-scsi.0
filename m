From: Michel Briand <michelbriand@free.fr>
Subject: ide cd writer problem with sg
Date: Mon, 29 Jul 2002 00:55:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40876.784551847$1027898925@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mel-rta7.wanadoo.fr (193.252.19.61) by mel-rto3.wanadoo.fr (6.5.007)
        id 3D1848E60114E49E for linux-scsi@vger.kernel.org; Mon, 29 Jul 2002 01:28:56 +0200
Received: from bubus.kheb (80.14.160.223) by mel-rta7.wanadoo.fr (6.5.007)
        id 3D2A78FA008DF87E for linux-scsi@vger.kernel.org; Mon, 29 Jul 2002 01:28:56 +0200
Received: from localhost. (localhost [127.0.0.1])
	by bubus.kheb (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id g6SMtq88005694
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2002 00:55:52 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hello,
i use an IDE cdwrite with sg, and when thoses modules are loaded,=20
cdrecord -scanbus works :
sg                     24036   0  (autoclean)
ide-scsi                7648   0  (autoclean)
scsi_mod               49804   2  (autoclean) [sg ide-scsi]
which produces :
Cdrecord 1.11a19 (i686-suse-linux) Copyright (C) 1995-2002 J=F6rg Schil=
ling
Linux sg driver version: 3.1.22
Using libscg version 'schily-0.6'
scsibus0:
        0,0,0     0) 'LITE-ON ' 'LTR-16102B      ' 'OS0E' Removable CD-=
ROM
        0,1,0     1) *
        0,2,0     2) *
        0,3,0     3) *
        0,4,0     4) *
        0,5,0     5) *
        0,6,0     6) *
        0,7,0     7) *
Nice.
But to mount the cdrom i experience some problems. Note that i have :
- kernel 2.4.18
- cd support compiled as modules : scsi_mod, ide-scsi, sg, sr_mod,=20
ide-cd, cdrom (all modules)
- only one cdwriter, no cdrom : /dev/hdc and no /dev/hdd

i.e. with find /proc/ide -type d -ls :
4307    0 dr-xr-xr-x   4 root     root            0 jui 29 00:51 /proc/=
ide/
4327    0 dr-xr-xr-x   3 root     root            0 jui 29 00:51=20
/proc/ide/ide1
4332    0 dr-xr-xr-x   2 root     root            0 jui 29 00:51=20
/proc/ide/ide1/hdc
4308    0 dr-xr-xr-x   4 root     root            0 jui 29 00:51=20
/proc/ide/ide0
4320    0 dr-xr-xr-x   2 root     root            0 jui 29 00:51=20
/proc/ide/ide0/hdb
4313    0 dr-xr-xr-x   2 root     root            0 jui 29 00:51=20
/proc/ide/ide0/hda

and when i issue this command, i get an error :
bubus:/media # modprobe sr_mod
bubus:/media # mount /dev/cdrom /media/cdrom -t iso9660
mount : P=E9riph=E9rique de bloc/dev/cdrom est prot=E9g=E9 en =E9critur=
e. Montage=20
en lecture seule.
mount: N'est pas un r=E9pertoire
bubus:/media # lsmod
Module                  Size  Used by    Tainted: P=20
nls_iso8859-1           2880   0  (autoclean)
sr_mod                 11800   0
cdrom                  28736   0  [sr_mod]
vfat                    9436   0  (autoclean)
fat                    29400   0  (autoclean) [vfat]
=2E...

N'est pas un r=E9pertoire =3D Not a directory, in english
??? This trouble my knowledge of what's happening inside ;-(

I would like to understand ! Please help !
Thanks

    Michel




-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
