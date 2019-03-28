From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [Qemu-devel] megasas: Unexpected response from lun
 1 while scanning, scan aborted
Date: Thu, 28 Mar 2019 08:47:13 +0800
Message-ID: <442316ee-8800-275c-85e9-a5d054a28e63@oracle.com>
References: <9c3849cf-86c6-4568-bff5-1050b445322d@default>
	<c3a8f877-82bc-44ab-72e8-51f62c0a65ed@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-block-bounces+gceqb-qemu-block=m.gmane.org@nongnu.org>
In-Reply-To: <c3a8f877-82bc-44ab-72e8-51f62c0a65ed@suse.de>
Content-Language: en-US
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-block>,
	<mailto:qemu-block-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-block/>
List-Post: <mailto:qemu-block@nongnu.org>
List-Help: <mailto:qemu-block-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-block>,
	<mailto:qemu-block-request@nongnu.org?subject=subscribe>
Errors-To: qemu-block-bounces+gceqb-qemu-block=m.gmane.org@nongnu.org
Sender: "Qemu-block"
	<qemu-block-bounces+gceqb-qemu-block=m.gmane.org@nongnu.org>
To: Hannes Reinecke <hare@suse.de>
Cc: qemu-devel@nongnu.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, qemu-block@nongnu.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 3/27/19 7:31 PM, Hannes Reinecke wrote:
> On 3/26/19 5:47 PM, Dongli Zhang wrote:
>> I am reporting an error that the scsi lun cannot initialize successful=
ly when I
>> am emulating megasas scsi controller with qemu.
>>
>> I am not sure if this is issue in qemu or linux kernel.
>>
>> When 'lun=3D1' is specified, there is "Unexpected response from lun 1 =
while
>> scanning, scan aborted".
>>
>> Everything works well if 'lun=3D0' is specified.
>>
>>
>> Below is the qemu cmdline involved:
>>
>> -device megasas,id=3Dscsi0 \
>> -device scsi-hd,drive=3Ddrive0,bus=3Dscsi0.0,lun=3D1 \
>> -drive file=3D/home/zhang/img/test.img,if=3Dnone,id=3Ddrive0,format=3D=
raw
>>
>>
>> Below is the syslog related to 'scsi|SCSI'
>>
>> # dmesg | grep SCSI
>> [=C2=A0=C2=A0=C2=A0 0.392494] SCSI subsystem initialized
>> [=C2=A0=C2=A0=C2=A0 0.460666] Block layer SCSI generic (bsg) driver ve=
rsion 0.4 loaded (major
>> 251)
>> [=C2=A0=C2=A0=C2=A0 0.706788] sd 1:0:0:0: [sda] Attached SCSI disk
>> # dmesg | grep scsi
>> [=C2=A0=C2=A0=C2=A0 0.511643] scsi host0: Avago SAS based MegaRAID dri=
ver
>> [=C2=A0=C2=A0=C2=A0 0.523302] scsi 0:2:0:0: Unexpected response from l=
un 1 while scanning,
>> scan aborted
>> [=C2=A0=C2=A0=C2=A0 0.540364] scsi host1: ata_piix
>> [=C2=A0=C2=A0=C2=A0 0.540780] scsi host2: ata_piix
>> [=C2=A0=C2=A0=C2=A0 0.702396] scsi 1:0:0:0: Direct-Access=C2=A0=C2=A0=C2=
=A0=C2=A0 ATA=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 QEMU HARDDISK=C2=A0=C2=A0=C2=A0=
 2.5+
>> PQ: 0 ANSI: 5
>>
>> When 'lun=3D1' is changed to 'lun=3D0', there is no issue.
>>
>> Thank you very much!
>>
> That's an artifact from the megasas emulation in quemu.
> Megasas (internally) can't handle LUN numbers (the RAID part only knows=
 about
> 'disks'), so I took the decision to not expose devices with LUN !=3D 0.
> Please use a different SCSI target number, not a non-zero LUN number.

The guest kernel is able to detect the disk if lun is always 0, while tar=
get
number is changed:

-device scsi-hd,drive=3Ddrive0,bus=3Dscsi0.0,channel=3D0,scsi-id=3D0,lun=3D=
0
-device scsi-hd,drive=3Ddrive1,bus=3Dscsi0.0,channel=3D0,scsi-id=3D1,lun=3D=
0

# dmesg | grep scsi
[    0.935999] scsi host0: ata_piix
[    0.936401] scsi host1: ata_piix
[    1.100945] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    =
2.5+
PQ: 0 ANSI: 5
[    1.102409] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.672952] scsi host2: Avago SAS based MegaRAID driver
[    1.683886] scsi 2:2:0:0: Direct-Access     QEMU     QEMU HARDDISK    =
2.5+
PQ: 0 ANSI: 5
[    1.684915] scsi 2:2:1:0: Direct-Access     QEMU     QEMU HARDDISK    =
2.5+
PQ: 0 ANSI: 5
[    1.701529] sd 2:2:0:0: Attached scsi generic sg1 type 0
[    1.704795] sd 2:2:1:0: Attached scsi generic sg2 type 0
# dmesg | grep SCSI
[    0.111015] SCSI subsystem initialized
[    0.904712] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 246)
[    1.121174] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.703739] sd 2:2:0:0: [sdb] Attached SCSI disk
[    1.706964] sd 2:2:1:0: [sdc] Attached SCSI disk



If device with LUN !=3D 0 will not be exposed, why not set max_lun =3D 0 =
as what
qemu lsi is doing?

diff --git a/hw/scsi/megasas.c b/hw/scsi/megasas.c
index a56317e..c966ee0 100644
--- a/hw/scsi/megasas.c
+++ b/hw/scsi/megasas.c
@@ -2298,7 +2298,7 @@ static void megasas_scsi_uninit(PCIDevice *d)
 static const struct SCSIBusInfo megasas_scsi_info =3D {
     .tcq =3D true,
     .max_target =3D MFI_MAX_LD,
-    .max_lun =3D 255,
+    .max_lun =3D 0,

     .transfer_data =3D megasas_xfer_complete,
     .get_sg_list =3D megasas_get_sg_list,


Thank you very much!

Dongli Zhang
