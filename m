From: <Don.Brace@microchip.com>
Subject: RE: [PATCH] scsi: smartpqi: call pqi_free_interrupts() in
 pqi_shutdown()
Date: Thu, 20 Dec 2018 21:21:08 +0000
Message-ID: <BYAPR11MB285583497B3E108B77267240E1BF0@BYAPR11MB2855.namprd11.prod.outlook.com>
References: <1545294755-29565-1-git-send-email-yanjiang.jin@hxt-semitech.com>
 <1545294755-29565-2-git-send-email-yanjiang.jin@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545294755-29565-2-git-send-email-yanjiang.jin@hxt-semitech.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: yanjiang.jin@hxt-semitech.com, don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: yu.zheng@hxt-semitech.com, jinyanjiang@gmail.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Yanjiang Jin [mailto:yanjiang.jin@hxt-semitech.com]=20
Sent: Thursday, December 20, 2018 2:33 AM
To: don.brace@microsemi.com; jejb@linux.vnet.ibm.com; martin.petersen@oracl=
e.com; yanjiang.jin@hxt-semitech.com
Cc: yu.zheng@hxt-semitech.com; jinyanjiang@gmail.com; esc.storagedev@micros=
emi.com; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: smartpqi: call pqi_free_interrupts() in pqi_shutdown=
()

We must free all irqs during shutdown, else kexec's 2nd kernel would hang i=
n pqi_wait_for_completion_io() as below:

Call trace:

 pqi_wait_for_completion_io
 pqi_submit_raid_request_


This happens only in the following combinations:

1. smartpqi is built as module, not built-in; 2. We have a disk connected t=
o smartpqi card; 3. Both kexec's 1st and 2nd kernels use this disk as Rootf=
s' mount point.

Signed-off-by: Yanjiang Jin <yanjiang.jin@hxt-semitech.com>

Thank-you for your patch.

Acked-by: Don Brace <don.brace@microsemi.com>

---
 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c
index a25a07a..55c1d82 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6670,6 +6670,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
         * storage.
         */
        rc =3D pqi_flush_cache(ctrl_info, SHUTDOWN);
+       pqi_free_interrupts(ctrl_info);
        pqi_reset(ctrl_info);
        if (rc =3D=3D 0)
                return;
--
1.8.3.1




This email is intended only for the named addressee. It may contain informa=
tion that is confidential/private, legally privileged, or copyright-protect=
ed, and you should handle it accordingly. If you are not the intended recip=
ient, you do not have legal rights to retain, copy, or distribute this emai=
l or its contents, and should promptly delete the email and all electronic =
copies in your system; do not retain copies in any media. If you have recei=
ved this email in error, please notify the sender promptly. Thank you.
