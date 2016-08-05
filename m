From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: [PATCH] mpt3sas: Ensure the connector_name string is NUL-terminated
Date: Fri, 5 Aug 2016 12:18:05 +0530
Message-ID: <866595a5d5bb579de68d0c3f06bdc43c@mail.gmail.com>
References: <8b53a29b3ec90c9a7030e8fa3e1555ad5802dce9.1469680625.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8b53a29b3ec90c9a7030e8fa3e1555ad5802dce9.1469680625.git.calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

Hi,
 Please consider this patch as Acked-by: Chaitra P B
<chaitra.basappa@broadcom.com>


Thanks,
 Chaitra

-----Original Message-----
From: Calvin Owens [mailto:calvinowens@fb.com]
Sent: Thursday, July 28, 2016 10:16 AM
To: Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; James E.J.
Bottomley; Martin K. Petersen
Cc: MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; kernel-team@fb.com; Calvin Owens
Subject: [PATCH] mpt3sas: Ensure the connector_name string is
NUL-terminated

We blindly trust the hardware to give us NUL-terminated strings, which is
a bad idea because it doesn't always do that. For example:

  [  481.184784] mpt3sas_cm0: 	enclosure level(0x0000), connector name(
\x3)

In this case, connector_name is four spaces. We got lucky here because the
2nd byte beyond our character array happens to be a NUL. Fix this by
explicitly writing '\0' to the end of the string to ensure we don't run
off the edge of the world in printk().

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +-
drivers/scsi/mpt3sas/mpt3sas_scsih.c | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h
b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 892c9be..eb7f5b0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -478,7 +478,7 @@ struct _sas_device {
 	u8	pfa_led_on;
 	u8	pend_sas_rphy_add;
 	u8	enclosure_level;
-	u8	connector_name[4];
+	u8	connector_name[5];
 	struct kref refcount;
 };

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index cd91a68..acabe48 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5380,8 +5380,9 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 		     MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
 			sas_device->enclosure_level =

le16_to_cpu(sas_device_pg0.EnclosureLevel);
-			memcpy(&sas_device->connector_name[0],
-				&sas_device_pg0.ConnectorName[0], 4);
+			memcpy(sas_device->connector_name,
+				sas_device_pg0.ConnectorName, 4);
+			sas_device->connector_name[4] = '\0';
 		} else {
 			sas_device->enclosure_level = 0;
 			sas_device->connector_name[0] = '\0'; @@ -5508,8
+5509,9 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8
phy_num,
 	if (sas_device_pg0.Flags &
MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
 		sas_device->enclosure_level =
 			le16_to_cpu(sas_device_pg0.EnclosureLevel);
-		memcpy(&sas_device->connector_name[0],
-			&sas_device_pg0.ConnectorName[0], 4);
+		memcpy(sas_device->connector_name,
+			sas_device_pg0.ConnectorName, 4);
+		sas_device->connector_name[4] = '\0';
 	} else {
 		sas_device->enclosure_level = 0;
 		sas_device->connector_name[0] = '\0';
--
2.8.0.rc2
