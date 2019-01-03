From: <Don.Brace@microchip.com>
Subject: RE: [PATCH] scsi: smartpqi_init: fix boolean expression in
 pqi_device_remove_start
Date: Thu, 3 Jan 2019 17:23:02 +0000
Message-ID: <BYAPR11MB2855EB0DA808D21EFE6C6A24E18D0@BYAPR11MB2855.namprd11.prod.outlook.com>
References: <20190103164744.GA16360@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190103164744.GA16360@embeddedor>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: gustavo@embeddedor.com, mahesh.rajashekhara@microsemi.com, don.brace@microsemi.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Gustavo A. R. Silva [mailto:gustavo@embeddedor.com]=20
Sent: Thursday, January 3, 2019 10:48 AM
To: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>; Don Brace <don=
.brace@microsemi.com>; James E.J. Bottomley <jejb@linux.ibm.com>; Martin K.=
 Petersen <martin.petersen@oracle.com>
Cc: esc.storagedev@microsemi.com; linux-scsi@vger.kernel.org; linux-kernel@=
vger.kernel.org; Gustavo A. R. Silva <gustavo@embeddedor.com>
Subject: [PATCH] scsi: smartpqi_init: fix boolean expression in pqi_device_=
remove_start

EXTERNAL EMAIL


Fix boolean expression by using logical AND operator '&&'
instead of bitwise operator '&'.

This issue was detected with the help of Coccinelle.

Fixes: 1e46731efd9c ("scsi: smartpqi: check for null device pointers")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Thanks for the update.
Acked-by: Don Brace <don.brace@microsemi.com>

---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c
index e2fa3f476227..40f58238ce4a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -323,7 +323,7 @@ static inline void pqi_device_remove_start(struct pqi_s=
csi_dev *device)  static inline bool pqi_device_in_remove(struct pqi_ctrl_i=
nfo *ctrl_info,
                                        struct pqi_scsi_dev *device)  {
-       return device->in_remove & !ctrl_info->in_shutdown;
+       return device->in_remove && !ctrl_info->in_shutdown;
 }

 static inline void pqi_schedule_rescan_worker_with_delay(
--
2.20.1
