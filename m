From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: megasas: Unexpected response from lun 1 while scanning, scan aborted
Date: Tue, 26 Mar 2019 09:47:50 -0700 (PDT)
Message-ID: <9c3849cf-86c6-4568-bff5-1050b445322d@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: qemu-block@nongnu.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
List-Id: linux-scsi@vger.kernel.org

I am reporting an error that the scsi lun cannot initialize successfully wh=
en I
am emulating megasas scsi controller with qemu.

I am not sure if this is issue in qemu or linux kernel.

When 'lun=3D1' is specified, there is "Unexpected response from lun 1 while
scanning, scan aborted".

Everything works well if 'lun=3D0' is specified.


Below is the qemu cmdline involved:

-device megasas,id=3Dscsi0 \
-device scsi-hd,drive=3Ddrive0,bus=3Dscsi0.0,lun=3D1 \
-drive file=3D/home/zhang/img/test.img,if=3Dnone,id=3Ddrive0,format=3Draw


Below is the syslog related to 'scsi|SCSI'

# dmesg | grep SCSI
[    0.392494] SCSI subsystem initialized
[    0.460666] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    0.706788] sd 1:0:0:0: [sda] Attached SCSI disk
# dmesg | grep scsi
[    0.511643] scsi host0: Avago SAS based MegaRAID driver
[    0.523302] scsi 0:2:0:0: Unexpected response from lun 1 while scanning,=
 scan aborted
[    0.540364] scsi host1: ata_piix
[    0.540780] scsi host2: ata_piix
[    0.702396] scsi 1:0:0:0: Direct-Access     ATA      QEMU HARDDISK    2.=
5+ PQ: 0 ANSI: 5

When 'lun=3D1' is changed to 'lun=3D0', there is no issue.

Thank you very much!

Dongli Zhang
