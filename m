From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 8/9] pm8001: enable read HBA SAS address from VPD
Date: Mon, 7 Dec 2009 17:23:08 +0800
Message-ID: <34D5FDFC9B6D4A89A50C9A56448658E4@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_002C_01CA7761.F1DE6F20"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:46713 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759309AbZLGJXF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:23:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_002C_01CA7761.F1DE6F20
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit


Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_ctl.h  |   10 ----------
 drivers/scsi/pm8001/pm8001_init.c |   12 ++++++++----
 drivers/scsi/pm8001/pm8001_sas.h  |   24 ++++++++++++++++++------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.h
b/drivers/scsi/pm8001/pm8001_ctl.h
index 22644de..63ad4aa 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.h
+++ b/drivers/scsi/pm8001/pm8001_ctl.h
@@ -45,16 +45,6 @@
 #define HEADER_LEN			28
 #define SIZE_OFFSET			16
 
-struct pm8001_ioctl_payload {
-	u32	signature;
-	u16	major_function;
-	u16	minor_function;
-	u16	length;
-	u16	status;
-	u16	offset;
-	u16	id;
-	u8	func_specific[1];
-};
 
 #define FLASH_OK                        0x000000
 #define FAIL_OPEN_BIOS_FILE             0x000100
diff --git a/drivers/scsi/pm8001/pm8001_init.c
b/drivers/scsi/pm8001/pm8001_init.c
index fb6379a..c2f1032 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -516,19 +516,23 @@ static void pm8001_init_sas_add(struct pm8001_hba_info
*pm8001_ha)
 	u8 i;
 #ifdef PM8001_READ_VPD
 	DECLARE_COMPLETION_ONSTACK(completion);
+	struct pm8001_ioctl_payload payload;
 	pm8001_ha->nvmd_completion = &completion;
-	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, 0, 0);
+	payload.minor_function = 0;
+	payload.length = 128;
+	payload.func_specific = kzalloc(128, GFP_KERNEL);
+	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
 	wait_for_completion(&completion);
 	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
 		memcpy(&pm8001_ha->phy[i].dev_sas_addr, pm8001_ha->sas_addr,
 			SAS_ADDR_SIZE);
 		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("phy %d sas_addr = %x \n", i,
-			(u64)pm8001_ha->phy[i].dev_sas_addr));
+			pm8001_printk("phy %d sas_addr = %016llx \n", i,
+			pm8001_ha->phy[i].dev_sas_addr));
 	}
 #else
 	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
-		pm8001_ha->phy[i].dev_sas_addr = 0x500e004010000004ULL;
+		pm8001_ha->phy[i].dev_sas_addr = 0x50010c600047f9d0ULL;
 		pm8001_ha->phy[i].dev_sas_addr =
 			cpu_to_be64((u64)
 				(*(u64 *)&pm8001_ha->phy[i].dev_sas_addr));
diff --git a/drivers/scsi/pm8001/pm8001_sas.h
b/drivers/scsi/pm8001/pm8001_sas.h
index c44a115..599601e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -100,6 +100,7 @@ do {						\
 
 #define PM8001_USE_TASKLET
 #define PM8001_USE_MSIX
+#define PM8001_READ_VPD
 
 
 #define DEV_IS_EXPANDER(type)	((type == EDGE_DEV) || (type == FANOUT_DEV))
@@ -111,7 +112,22 @@ extern const struct pm8001_dispatch
pm8001_8001_dispatch;
 struct pm8001_hba_info;
 struct pm8001_ccb_info;
 struct pm8001_device;
-struct pm8001_tmf_task;
+/* define task management IU */
+struct pm8001_tmf_task {
+	u8	tmf;
+	u32	tag_of_task_to_be_managed;
+};
+struct pm8001_ioctl_payload {
+	u32	signature;
+	u16	major_function;
+	u16	minor_function;
+	u16	length;
+	u16	status;
+	u16	offset;
+	u16	id;
+	u8	*func_specific;
+};
+
 struct pm8001_dispatch {
 	char *name;
 	int (*chip_init)(struct pm8001_hba_info *pm8001_ha);
@@ -390,11 +406,7 @@ struct pm8001_fw_image_header {
 	__be32 startup_entry;
 } __attribute__((packed, aligned(4)));
 
-/* define task management IU */
-struct pm8001_tmf_task {
-	u8	tmf;
-	u32	tag_of_task_to_be_managed;
-};
+
 /**
  * FW Flash Update status values
  */
-- 
1.6.5.1.1367.gcd48


------=_NextPart_000_002C_01CA7761.F1DE6F20
Content-Type: application/octet-stream;
	name="0008-enable-read-hba-sas-address-from-VPD.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0008-enable-read-hba-sas-address-from-VPD.patch"

>From 5904a322b2b45d247cab0b0b23fa7b7648a56fba Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Mon, 7 Dec 2009 15:55:23 +0800=0A=
Subject: [PATCH 8/9] enable read hba sas address from VPD=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_ctl.h  |   10 ----------=0A=
 drivers/scsi/pm8001/pm8001_init.c |   12 ++++++++----=0A=
 drivers/scsi/pm8001/pm8001_sas.h  |   24 ++++++++++++++++++------=0A=
 3 files changed, 26 insertions(+), 20 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_ctl.h =
b/drivers/scsi/pm8001/pm8001_ctl.h=0A=
index 22644de..63ad4aa 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_ctl.h=0A=
+++ b/drivers/scsi/pm8001/pm8001_ctl.h=0A=
@@ -45,16 +45,6 @@=0A=
 #define HEADER_LEN			28=0A=
 #define SIZE_OFFSET			16=0A=
 =0A=
-struct pm8001_ioctl_payload {=0A=
-	u32	signature;=0A=
-	u16	major_function;=0A=
-	u16	minor_function;=0A=
-	u16	length;=0A=
-	u16	status;=0A=
-	u16	offset;=0A=
-	u16	id;=0A=
-	u8	func_specific[1];=0A=
-};=0A=
 =0A=
 #define FLASH_OK                        0x000000=0A=
 #define FAIL_OPEN_BIOS_FILE             0x000100=0A=
diff --git a/drivers/scsi/pm8001/pm8001_init.c =
b/drivers/scsi/pm8001/pm8001_init.c=0A=
index fb6379a..c2f1032 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_init.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_init.c=0A=
@@ -516,19 +516,23 @@ static void pm8001_init_sas_add(struct =
pm8001_hba_info *pm8001_ha)=0A=
 	u8 i;=0A=
 #ifdef PM8001_READ_VPD=0A=
 	DECLARE_COMPLETION_ONSTACK(completion);=0A=
+	struct pm8001_ioctl_payload payload;=0A=
 	pm8001_ha->nvmd_completion =3D &completion;=0A=
-	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, 0, 0);=0A=
+	payload.minor_function =3D 0;=0A=
+	payload.length =3D 128;=0A=
+	payload.func_specific =3D kzalloc(128, GFP_KERNEL);=0A=
+	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);=0A=
 	wait_for_completion(&completion);=0A=
 	for (i =3D 0; i < pm8001_ha->chip->n_phy; i++) {=0A=
 		memcpy(&pm8001_ha->phy[i].dev_sas_addr, pm8001_ha->sas_addr,=0A=
 			SAS_ADDR_SIZE);=0A=
 		PM8001_INIT_DBG(pm8001_ha,=0A=
-			pm8001_printk("phy %d sas_addr =3D %x \n", i,=0A=
-			(u64)pm8001_ha->phy[i].dev_sas_addr));=0A=
+			pm8001_printk("phy %d sas_addr =3D %016llx \n", i,=0A=
+			pm8001_ha->phy[i].dev_sas_addr));=0A=
 	}=0A=
 #else=0A=
 	for (i =3D 0; i < pm8001_ha->chip->n_phy; i++) {=0A=
-		pm8001_ha->phy[i].dev_sas_addr =3D 0x500e004010000004ULL;=0A=
+		pm8001_ha->phy[i].dev_sas_addr =3D 0x50010c600047f9d0ULL;=0A=
 		pm8001_ha->phy[i].dev_sas_addr =3D=0A=
 			cpu_to_be64((u64)=0A=
 				(*(u64 *)&pm8001_ha->phy[i].dev_sas_addr));=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.h =
b/drivers/scsi/pm8001/pm8001_sas.h=0A=
index c44a115..599601e 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.h=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.h=0A=
@@ -100,6 +100,7 @@ do {						\=0A=
 =0A=
 #define PM8001_USE_TASKLET=0A=
 #define PM8001_USE_MSIX=0A=
+#define PM8001_READ_VPD=0A=
 =0A=
 =0A=
 #define DEV_IS_EXPANDER(type)	((type =3D=3D EDGE_DEV) || (type =3D=3D =
FANOUT_DEV))=0A=
@@ -111,7 +112,22 @@ extern const struct pm8001_dispatch =
pm8001_8001_dispatch;=0A=
 struct pm8001_hba_info;=0A=
 struct pm8001_ccb_info;=0A=
 struct pm8001_device;=0A=
-struct pm8001_tmf_task;=0A=
+/* define task management IU */=0A=
+struct pm8001_tmf_task {=0A=
+	u8	tmf;=0A=
+	u32	tag_of_task_to_be_managed;=0A=
+};=0A=
+struct pm8001_ioctl_payload {=0A=
+	u32	signature;=0A=
+	u16	major_function;=0A=
+	u16	minor_function;=0A=
+	u16	length;=0A=
+	u16	status;=0A=
+	u16	offset;=0A=
+	u16	id;=0A=
+	u8	*func_specific;=0A=
+};=0A=
+=0A=
 struct pm8001_dispatch {=0A=
 	char *name;=0A=
 	int (*chip_init)(struct pm8001_hba_info *pm8001_ha);=0A=
@@ -390,11 +406,7 @@ struct pm8001_fw_image_header {=0A=
 	__be32 startup_entry;=0A=
 } __attribute__((packed, aligned(4)));=0A=
 =0A=
-/* define task management IU */=0A=
-struct pm8001_tmf_task {=0A=
-	u8	tmf;=0A=
-	u32	tag_of_task_to_be_managed;=0A=
-};=0A=
+=0A=
 /**=0A=
  * FW Flash Update status values=0A=
  */=0A=
-- =0A=
1.6.5.1.1367.gcd48=0A=
=0A=

------=_NextPart_000_002C_01CA7761.F1DE6F20--

