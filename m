From: Fabien Salvi <fabien@cri74.org>
Subject: Re: qlogic QLA2200F/66 with Compaq HSG80?
Date: Tue, 10 Sep 2002 16:07:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D7DFCAE.B86BED9E@cri74.org>
References: <m3it1fzf1o.fsf@Janik.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Pavel =?iso-8859-1?Q?Jan=EDk?= <Pavel@Janik.cz>
Cc: linux-scsi@vger.kernel.org

Pavel Jan=EDk wrote:
>=20
> Hi,
>=20
> this is a copy of an e-mail I sent to lkml last week. Can you please =
help
> he with this issue? Please keep me in CC: I'm not subscribed here.
>=20
> we have Compaq Proliant DL380 with two FC cards Qlogic ISP2200A in 64=
bit
> PCI bus.
>=20
> [...]
>=20
> We have it running with 2.2.19 with qla driver version 4.46.12b. All
> devices on FC switch are visible (on both cards):
>=20
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: DEC      Model: HSG80CCL         Rev: V86F
>   Type:   Unknown                          ANSI SCSI revision: 02
>
> [...]
>=20
> We would like to upgrade the system to 2.4.19 with the latest qlogic'=
s
> driver 6.1b5. We have succeeded, but HSG80s are no more visible...:
>=20
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: DEC      Model: HSG80CCL         Rev: V86F
>   Type:   Unknown                          ANSI SCSI revision: 02

> [...]

>=20
> We have tried both SMP and NOSMP build, the result is the same (ie. a=
ll
> device except HSG80s ae visible).
>=20
> We have also tried to use kernel's qlogicfc:
>=20
> Sep  7 01:37:37 intranet kernel: qlogicfc0 : Loop Reinitialized
> Sep  7 01:37:43 intranet kernel: scsi: unknown type 31
> Sep  7 01:37:43 intranet kernel:   Vendor: DEC       Model: HSG80    =
         Rev: V86F
> Sep  7 01:37:43 intranet kernel:   Type:   Unknown                   =
         ANSI SCSI revision: 02
> Sep  7 01:37:43 intranet kernel: Attached scsi disk sda at scsi0, cha=
nnel 0, id 2, lun 4
> Sep  7 01:37:43 intranet kernel: Attached scsi disk sdb at scsi1, cha=
nnel 0, id 1, lun 4
> Sep  7 01:37:43 intranet kernel: resize_dma_pool: unknown device type=
 12
> Sep  7 01:37:43 intranet kernel: resize_dma_pool: unknown device type=
 31
> Sep  7 01:37:43 intranet last message repeated 5 times
> Sep  7 01:37:43 intranet kernel: resize_dma_pool: unknown device type=
 12
> Sep  7 01:37:43 intranet kernel: resize_dma_pool: unknown device type=
 31
> Sep  7 01:37:43 intranet last message repeated 5 times
> Sep  7 01:37:43 intranet kernel: SCSI device sda: 71114623 512-byte h=
dwr sectors (36411 MB)
> Sep  7 01:37:43 intranet kernel:  sda: sda1 sda3
> Sep  7 01:37:43 intranet kernel: SCSI device sdb: 71114623 512-byte h=
dwr sectors (36411 MB)
> Sep  7 01:37:43 intranet kernel:  sdb: sdb1 sdb3
>=20

Hello,

I think it's a problem about lun scaning...
Your SCSI disks are using luns > 0 and they are not contiguous.

Try using this script (Rescan SCSI bus) :
http://www.garloff.de/kurt/linux/rescan-scsi-bus.sh

from Kurt Garloff page :
http://www.garloff.de/kurt/linux/

You should see something like this :

# ./rescan-scsi-bus.sh -l
Host adapter 0 (gdth) found.
Host adapter 1 (qla2200) found.
Scanning for device 0 0 0 0 ...
OLD: Host: scsi0 Channel: 00 Id: 00 Lun: 00
      Vendor: ICP      Model: Host Drive  #00  Rev:    =20
      Type:   Direct-Access                    ANSI SCSI revision: 02
Scanning for device 0 0 4 0 ....
OLD: Host: scsi0 Channel: 00 Id: 04 Lun: 00
      Vendor: ICP      Model: Host Drive  #04  Rev:    =20
      Type:   Direct-Access                    ANSI SCSI revision: 02
Scanning for device 1 0 0 0 ....
OLD: Host: scsi1 Channel: 00 Id: 00 Lun: 00
      Vendor: CMD      Model: CRD-7240         Rev: 4103
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 1 0 0 6 ...
NEW: Host: scsi1 Channel: 00 Id: 00 Lun: 06
      Vendor: CMD      Model: CRD-7240         Rev: 4103
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 1 0 1 0 ....
OLD: Host: scsi1 Channel: 00 Id: 01 Lun: 00
      Vendor: CMD      Model: CRD-7240         Rev: 4103
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 1 0 1 3 ...
NEW: Host: scsi1 Channel: 00 Id: 01 Lun: 03
      Vendor: CMD      Model: CRD-7240         Rev: 4103
      Type:   Direct-Access                    ANSI SCSI revision: 04
2 new device(s) found.              =20
0 device(s) removed.                =20

[Off topic : it's a bit strange to have ANSI revision 4, isn't it ?]


Look at SCSI-2.4 howto :
http://www.tldp.org/HOWTO/SCSI-2.4-HOWTO/index.html

especially this page :
http://www.tldp.org/HOWTO/SCSI-2.4-HOWTO/mlproc.html

B.R.

-------------
=46abien SALVI      Centre de Ressources Informatiques
                  Archamps, France -- http://www.cri74.org
                  PingOO GNU/linux distribution : http://www.pingoo.org
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
