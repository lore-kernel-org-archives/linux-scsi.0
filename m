From: Michel Briand <michelbriand@free.fr>
Subject: Re: ide cd writer problem with sg
Date: Mon, 05 Aug 2002 13:53:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6841.11640225655$1028549301@news.gmane.org>
References: <3D447677.9070309@localhost.> <3D44A2E9.DB32586E@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

I run in a new test.
Excuses me, and thank you for your patience.

I've theses modules loaded :
sr_mod                 11800   0
sg                     24036   0  (autoclean)
sd_mod                  9980   0  (autoclean) (unused)
isofs                  24864   0  (autoclean)
inflate_fs             17984   0  (autoclean) [isofs]
vfat                    9436   0  (autoclean)
fat                    29400   0  (autoclean) [vfat]
cdrom                  28736   0  [sr_mod]
ide-scsi                7648   0
scsi_mod               49804   4  (autoclean) [sr_mod sg sd_mod ide-scs=
i]
via82cxxx_audio        18432   1  (autoclean)
ac97_codec              9632   0  (autoclean) [via82cxxx_audio]
uart401                 6144   0  (autoclean) [via82cxxx_audio]
sound                  53580   0  (autoclean) [via82cxxx_audio uart401]
soundcore               3364   5  (autoclean) [via82cxxx_audio sound]
n_hdlc                  6112   1  (autoclean)
ppp_synctty             4832   1  (autoclean)
NVdriver              821184  14  (autoclean)
joydev                  6816   0  (unused)
input                   3168   0  [joydev]
ipt_TCPMSS              2336   1  (autoclean)
ipt_TOS                 1024  22  (autoclean)
ipt_MASQUERADE          1216   1  (autoclean)
ipt_state                608  77  (autoclean)
ipt_LOG                 3136 127  (autoclean)
ip_nat_ftp              2944   0  (unused)
ip_conntrack_ftp        3200   0  (unused)
ppp_generic            15848   3  (autoclean) [ppp_synctty]
slhc                    4624   0  (autoclean) [ppp_generic]
ne2k-pci                5056   1
8390                    5952   0  [ne2k-pci]
ipt_REJECT              2880   3  (autoclean)
iptable_mangle          2144   1  (autoclean)
iptable_nat            12852   2  (autoclean) [ipt_MASQUERADE ip_nat_ft=
p]
ip_conntrack           13036   3  (autoclean) [ipt_MASQUERADE ipt_state=
=20
ip_nat_ftp ip_conntrack_ftp iptable_nat]
iptable_filter          1760   1  (autoclean)
ip_tables              10560  11  [ipt_TCPMSS ipt_TOS ipt_MASQUERADE=20
ipt_state ipt_LOG ipt_REJECT iptable_mangle iptable_nat iptable_filter]
usb-uhci               21508   0  (unused)
usbcore                48992   1  [usb-uhci]

And I run the command :
bubus:/media # mount /dev/scd0 /media/cdrom -t iso9660
mount : P=E9riph=E9rique de bloc/dev/scd0 est prot=E9g=E9 en =E9criture=
=2E Montage=20
en lecture seule.
mount: N'est pas un r=E9pertoire

And this is the output of tail -f /var/log/messages :
Aug  5 13:50:55 bubus kernel: SCSI cdrom error : host 0 channel 0 id 0=20
lun 0 return code =3D 28000000
Aug  5 13:50:55 bubus kernel: Current sd0b:00: sns =3D 70  4
Aug  5 13:50:55 bubus kernel: ASC=3D 8 ASCQ=3D 3
Aug  5 13:50:55 bubus kernel: Raw sense data:0x70 0x00 0x04 0x00 0x00=20
0x00 0x00 0x0a 0x00 0x00 0x00 0x00 0x08 0x03 0x00 0x00 0x00 0x00
Aug  5 13:50:55 bubus kernel:  I/O error: dev 0b:00, sector 80
Aug  5 13:50:55 bubus kernel: ISOFS: unable to read i-node block

Note that before I do a modprobe sr_mod I received another error=20
message, and when I loaded it, I see in logs :
Aug  5 13:38:34 bubus kernel: Attached scsi CD-ROM sr0 at scsi0, channe=
l=20
0, id 0, lun 0
Aug  5 13:38:34 bubus kernel: sr0: scsi3-mmc drive: 40x/40x writer cd/r=
w=20
xa/form2 cdda tray
Aug  5 13:38:34 bubus kernel: Uniform CD-ROM driver Revision: 3.12
Aug  5 13:38:42 bubus kernel: VFS: Disk change detected on device sr(11=
,0)

What do you think of this mess ?
Thank you for your help, again ;-)

Michel

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
