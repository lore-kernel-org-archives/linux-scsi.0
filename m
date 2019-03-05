From: <Don.Brace@microchip.com>
Subject: RE: [PATCH v3] scsi: smartpqi_init: Reporting 'logical unit failure'
Date: Tue, 5 Mar 2019 22:30:04 +0000
Message-ID: <SN6PR11MB27675810361CE0D169CAF97CE1720@SN6PR11MB2767.namprd11.prod.outlook.com>
References: <1551455797.3334.6.camel@linux.ibm.com>
 <20190301160806.16099-1-e.velu@criteo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190301160806.16099-1-e.velu@criteo.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: erwanaliasr1@gmail.com
Cc: e.velu@criteo.com, don.brace@microsemi.com, jejb@linux.ibm.com, martin.petersen@oracle.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Erwan Velu
Sent: Friday, March 1, 2019 10:08 AM
Cc: Erwan Velu <e.velu@criteo.com>; Don Brace <don.brace@microsemi.com>; Ja=
mes E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen <martin.peterse=
n@oracle.com>; open list:MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi) <=
esc.storagedev@microsemi.com>; open list:MICROSEMI SMART ARRAY SMARTPQI DRI=
VER (smartpqi) <linux-scsi@vger.kernel.org>; open list <linux-kernel@vger.k=
ernel.org>
Subject: [PATCH v3] scsi: smartpqi_init: Reporting 'logical unit failure'

When the HARDWARE_ERROR/0x3e/0x1 case is triggered, the logical volume is o=
fflined.
When reading the kernel log, the reason why the device got offlined isn't r=
eported to the user.
This situation makes difficult for admins to estimate the root cause of the=
 issue they analize.

Reading this part of the code makes clear this is because driver received a=
 HARDWARE_ERROR/0x3e/0x1 which is a 'logical unit failure'.
This patch is just about reporting the reason behind the offlining to ease =
the analyse.

Signed-off-by: Erwan Velu <e.velu@criteo.com>

Acked-by: Don Brace <don.brace@microsemi.com>

---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c
index f564af8949e8..adebafe56b5b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2764,6 +2764,12 @@ static void pqi_process_raid_io_error(struct pqi_io_=
request *io_request)
 				sshdr.sense_key =3D=3D HARDWARE_ERROR &&
 				sshdr.asc =3D=3D 0x3e &&
 				sshdr.ascq =3D=3D 0x1) {
+			struct pqi_ctrl_info *ctrl_info =3D shost_to_hba(scmd->device->host);
+			struct pqi_scsi_dev *device =3D scmd->device->hostdata;
+
+			if (printk_ratelimit())
+				scmd_printk(KERN_ERR, scmd, "received 'logical unit failure' from cont=
roller for scsi %d:%d:%d:%d\n",
+					ctrl_info->scsi_host->host_no, device->bus, device->target, device->l=
un);
 			pqi_take_device_offline(scmd->device, "RAID");
 			host_byte =3D DID_NO_CONNECT;
 		}
--=20
2.20.1
