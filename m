From: Karl Hammar <karl@kalle.csb.ki.se>
Subject: Re: Tekram DC-390U3W
Date: Tue, 16 Jul 2002 13:00:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207161100.g6GB0YkR004419@opal.aspo.lcl>
References: <OF103B9A14.FD1B203D-ON4A256BF8.001E9874@ussbris>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Message from MarshallJ@switch.aust.com
   of "Tue, 16 Jul 2002 15:36:26 +1000." <OF103B9A14.FD1B203D-ON4A256BF8.001E9874@ussbris>
List-Id: linux-scsi@vger.kernel.org
To: MarshallJ@switch.aust.com
Cc: linux-scsi@vger.kernel.org

=2E..
> I'm considering purchasing a Tekram DC-390U3W but am not sure if it's=
=20
> supported by the kernel. I am using 2.4.18 and am happy to patch the=20
> kernel. I noticed in the sym53c8xx_comm.h file, the SYM53C1010 chip i=
s=20
> stated as being not supported.
=2E..
> Regards,
> Josh Marshall.
=2E..

  1,
I use the DC-390U3W without any problems,
strapped to 32bit bus width on a std. motherboard.
Se below for /proc info.

  2, re: sym53c8xx_comm.h file:


The ncr53c8xx driver don't support the 1010 chip.
Use the sym53c8xx driver instead, se discussion below.

Regards,
/Karl

-----------------------------------------------------------------------
Karl Hammar                    Asp=F6 Data           karl@kalle.csb.ki.=
se
Lilla Asp=F6 2340             +46  173 140 57                    Networ=
ks
S-742 94 =D6sthammar          +46 18 26 09 00                   Compute=
rs
Sweden                     +46  10 270 26 67                 Consulting
-----------------------------------------------------------------------

  1,

$ for i in `find /proc/scsi/ -type f`; do echo "*****" $i:; cat $i; don=
e
***** /proc/scsi/sym53c8xx/1:
General information:
  Chip sym53c1010-33, device id 0x20, revision id 0x1
  On PCI bus 0, device 9, function 1, IRQ 11
  Synchronous period factor 9, max commands per lun 4
***** /proc/scsi/sym53c8xx/0:
General information:
  Chip sym53c1010-33, device id 0x20, revision id 0x1
  On PCI bus 0, device 9, function 0, IRQ 11
  Synchronous period factor 9, max commands per lun 4
***** /proc/scsi/scsi:
Attached devices:=20
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: DMVS09D          Rev: 02B0
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: IBM      Model: DDYS-T36950M     Rev: S80D
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: SEAGATE  Model: ST373405LC       Rev: 0002
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 14 Lun: 00
  Vendor: TANDBERG Model: MLR3             Rev: 0404
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 05 Lun: 00
  Vendor: PLEXTOR  Model: CD-R   PX-W124TS Rev: 1.05
  Type:   CD-ROM                           ANSI SCSI revision: 02
$ grep SCSI -B1 -A5 /proc/pci=20
  Bus  0, device   9, function  1:
    SCSI storage controller: LSI Logic / Symbios Logic (formerly NCR) 5=
3c1010=20
Ultra3 SCSI Adapter (#2) (rev 1).
      IRQ 11.
      Master Capable.  Latency=3D72.  Min Gnt=3D17.Max Lat=3D18.
      I/O at 0xd800 [0xd8ff].
      Non-prefetchable 64 bit memory at 0xeffffc00 [0xefffffff].
      Non-prefetchable 64 bit memory at 0xefffc000 [0xefffdfff].
  Bus  0, device   9, function  0:
    SCSI storage controller: LSI Logic / Symbios Logic (formerly NCR) 5=
3c1010=20
Ultra3 SCSI Adapter (rev 1).
      IRQ 11.
      Master Capable.  Latency=3D72.  Min Gnt=3D17.Max Lat=3D18.
      I/O at 0xc800 [0xc8ff].
      Non-prefetchable 64 bit memory at 0xeffff400 [0xeffff7ff].
      Non-prefetchable 64 bit memory at 0xefffa000 [0xefffbfff].
$ cat /proc/version=20
Linux version 2.4.18-k7 (herbert@gondolin) (gcc version 2.95.4 20011002=
=20
(Debian prerelease)) #1 Sun Apr 14 13:19:11 EST 2002
$=20


  2,

Given:

$ pwd
/usr/src/kernel-source-2.4.18

$ grep PCI_DEVICE_ID_LSI_53C1010 -C3 drivers/scsi/sym53c8xx_comm.h=20
        /*
        **    Check if the chip is supported
        */
        if ((device_id =3D=3D PCI_DEVICE_ID_LSI_53C1010) ||
                        (device_id =3D=3D PCI_DEVICE_ID_LSI_53C1010_66)=
){
                printk(NAME53C8XX ": not initializing, device not=20
supported\n");
                return -1;
        }


$ find . -type f -name \*.h | xargs grep PCI_DEVICE_ID_LSI_53C1010
=2E/drivers/scsi/sym53c8xx_comm.h:        if ((device_id =3D=3D=20
PCI_DEVICE_ID_LSI_53C1010) ||
=2E/drivers/scsi/sym53c8xx_comm.h:                        (device_id =3D=
=3D=20
PCI_DEVICE_ID_LSI_53C1010_66)){
=2E/drivers/scsi/sym53c8xx_defs.h:#ifndef PCI_DEVICE_ID_LSI_53C1010
=2E/drivers/scsi/sym53c8xx_defs.h:#define PCI_DEVICE_ID_LSI_53C1010 0x2=
0
=2E/drivers/scsi/sym53c8xx_defs.h:#ifndef PCI_DEVICE_ID_LSI_53C1010_66
=2E/drivers/scsi/sym53c8xx_defs.h:#define PCI_DEVICE_ID_LSI_53C1010_66 =
0x21
=2E/drivers/scsi/sym53c8xx_defs.h: {PCI_DEVICE_ID_LSI_53C1010, 0xff, "1=
010-33", =20
6, 62, 7,                \
=2E/drivers/scsi/sym53c8xx_defs.h: {PCI_DEVICE_ID_LSI_53C1010_66, 0xff,=
=20
"1010-66",  6, 62, 7,             \
=2E/drivers/scsi/sym53c8xx_defs.h:        PCI_DEVICE_ID_LSI_53C1010,   =
   \
=2E/drivers/scsi/sym53c8xx_defs.h:        PCI_DEVICE_ID_LSI_53C1010_66 =
   \
=2E/include/linux/pci_ids.h:#define PCI_DEVICE_ID_LSI_53C1010_33  0x002=
0
=2E/include/linux/pci_ids.h:#define PCI_DEVICE_ID_LSI_53C1010_66  0x002=
1

$ lspci -d "*:0020"
00:09.0 SCSI storage controller: LSI Logic / Symbios Logic (formerly NC=
R)=20
53c1010 Ultra3 SCSI Adapter (rev 01)
00:09.1 SCSI storage controller: LSI Logic / Symbios Logic (formerly NC=
R)=20
53c1010 Ultra3 SCSI Adapter (rev 01)

It seems that the code in the sym53c8xx_comm.h does not execute.
Looking through the code:

$ find . -type f | xargs grep sym53c8xx_comm.h
=2E/drivers/scsi/ChangeLog.ncr53c8xx:       to the driver (change to=20
sym53c8xx_comm.h).
=2E/drivers/scsi/ChangeLog.ncr53c8xx:     - Add the file sym53c8xx_comm=
=2Eh that=20
collects code that should
=2E/drivers/scsi/ChangeLog.ncr53c8xx:        - Add the file sym53c8xx_c=
omm.h=20
that collects code that should
=2E/drivers/scsi/ncr53c8xx.c:#include "sym53c8xx_comm.h"
=2E/drivers/scsi/.depend:   sym53c8xx_comm.h \
=2E/drivers/scsi/.depend:sym53c8xx_comm.h: \
=2E/drivers/scsi/.depend: @touch sym53c8xx_comm.h
=2E/drivers/scsi/.depend: sym53c8xx_comm.h \

$ grep -C3  sym53c8xx_comm.h drivers/scsi/ChangeLog.ncr53c8xx
Thu Mar 16   9:30 2000 Pam Delaney (pam.delaney@lsil.com)
        * revision 3.3b-3
        - Added exclusion for the 53C1010 and 53C1010_66 chips
          to the driver (change to sym53c8xx_comm.h).

Mon March 6  23:15 2000 Gerard Roudier (groudier@club-internet.fr)
        * revision 3.2g
        - Add the file sym53c8xx_comm.h that collects code that should=20
          be shared by sym53c8xx and ncr53c8xx drivers. For now, it is =
=20
          a header file that is only included by the ncr53c8xx driver,=20
          but things will be cleaned up later. This code addresses=20
--

Mon March 6  23:15 2000 Gerard Roudier (groudier@club-internet.fr)
        * revision 3.2g$ ls -l drivers/scsi/sym53c8xx.c=20

        - Add the file sym53c8xx_comm.h that collects code that should
          be shared by sym53c8xx and ncr53c8xx drivers. For now, it is
          a header file that is only included by the ncr53c8xx driver,
          but things will be cleaned up later. This code addresses

$ ls -l drivers/scsi/sym53c8xx.c=20
-rw-r--r--    1 root     root       376808 21 dec  2001=20
drivers/scsi/sym53c8xx.c

One sees that the ncr53c8xx driver contain the code fragment,
but not the sym53c8xx driver.


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
