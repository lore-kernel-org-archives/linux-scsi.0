From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 3/9] pm8001: fix endian issues
Date: Mon, 7 Dec 2009 17:22:47 +0800
Message-ID: <CCD798DF612547B0B31C21D69F5591BD@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0023_01CA7761.E55C87A0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53051 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759296AbZLGJWm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:22:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_0023_01CA7761.E55C87A0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

This patch will fix endian issues.

Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    7 ++++---
 drivers/scsi/pm8001/pm8001_hwi.h |    3 +--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index 3a121fb..b4426b5 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3823,7 +3823,8 @@ static int pm8001_chip_ssp_io_req(struct
pm8001_hba_info *pm8001_ha,
 	u32 opc = OPC_INB_SSPINIIOSTART;
 	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
 	memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);
-	ssp_cmd.dir_m_tlr = data_dir_flags[task->data_dir] << 8 | 0x0;/*0
for
+	ssp_cmd.dir_m_tlr =
+		cpu_to_le32(data_dir_flags[task->data_dir] << 8 | 0x0);/*0
for
 	SAS 1.1 compatible TLR*/
 	ssp_cmd.data_len = cpu_to_le32(task->total_xfer_len);
 	ssp_cmd.device_id = cpu_to_le32(pm8001_dev->device_id);
@@ -3894,7 +3895,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info
*pm8001_ha,
 		}
 	}
 	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag))
-		ncg_tag = cpu_to_le32(hdr_tag);
+		ncg_tag = hdr_tag;
 	dir = data_dir_flags[task->data_dir] << 8;
 	sata_cmd.tag = cpu_to_le32(tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
@@ -4039,7 +4040,7 @@ static int pm8001_chip_reg_dev_req(struct
pm8001_hba_info *pm8001_ha,
 		((stp_sspsmp_sata & 0x03) * 0x10000000));
 	payload.firstburstsize_ITNexustimeout =
 		cpu_to_le32(ITNT | (firstBurstSize * 0x10000));
-	memcpy(&payload.sas_addr_hi, pm8001_dev->sas_device->sas_addr,
+	memcpy(payload.sas_addr, pm8001_dev->sas_device->sas_addr,
 		SAS_ADDR_SIZE);
 	rc = mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);
 	return rc;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h
b/drivers/scsi/pm8001/pm8001_hwi.h
index 96e4daa..833a520 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -242,8 +242,7 @@ struct reg_dev_req {
 	__le32	phyid_portid;
 	__le32	dtype_dlr_retry;
 	__le32	firstburstsize_ITNexustimeout;
-	u32	sas_addr_hi;
-	u32	sas_addr_low;
+	u8	sas_addr[SAS_ADDR_SIZE];
 	__le32	upper_device_id;
 	u32	reserved[8];
 } __attribute__((packed, aligned(4)));
-- 
1.6.5.1.1367.gcd48


------=_NextPart_000_0023_01CA7761.E55C87A0
Content-Type: application/octet-stream;
	name="0003-fix-endian-issues.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0003-fix-endian-issues.patch"

>From 1885b65cac3c291d279c83c77de457a79364dce9 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Mon, 7 Dec 2009 15:33:23 +0800=0A=
Subject: [PATCH 3/9] fix endian issues=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_hwi.c |    7 ++++---=0A=
 drivers/scsi/pm8001/pm8001_hwi.h |    3 +--=0A=
 2 files changed, 5 insertions(+), 5 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c =
b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
index 3a121fb..b4426b5 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_hwi.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
@@ -3823,7 +3823,8 @@ static int pm8001_chip_ssp_io_req(struct =
pm8001_hba_info *pm8001_ha,=0A=
 	u32 opc =3D OPC_INB_SSPINIIOSTART;=0A=
 	memset(&ssp_cmd, 0, sizeof(ssp_cmd));=0A=
 	memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);=0A=
-	ssp_cmd.dir_m_tlr =3D data_dir_flags[task->data_dir] << 8 | 0x0;/*0 for=0A=
+	ssp_cmd.dir_m_tlr =3D=0A=
+		cpu_to_le32(data_dir_flags[task->data_dir] << 8 | 0x0);/*0 for=0A=
 	SAS 1.1 compatible TLR*/=0A=
 	ssp_cmd.data_len =3D cpu_to_le32(task->total_xfer_len);=0A=
 	ssp_cmd.device_id =3D cpu_to_le32(pm8001_dev->device_id);=0A=
@@ -3894,7 +3895,7 @@ static int pm8001_chip_sata_req(struct =
pm8001_hba_info *pm8001_ha,=0A=
 		}=0A=
 	}=0A=
 	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag))=0A=
-		ncg_tag =3D cpu_to_le32(hdr_tag);=0A=
+		ncg_tag =3D hdr_tag;=0A=
 	dir =3D data_dir_flags[task->data_dir] << 8;=0A=
 	sata_cmd.tag =3D cpu_to_le32(tag);=0A=
 	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);=0A=
@@ -4039,7 +4040,7 @@ static int pm8001_chip_reg_dev_req(struct =
pm8001_hba_info *pm8001_ha,=0A=
 		((stp_sspsmp_sata & 0x03) * 0x10000000));=0A=
 	payload.firstburstsize_ITNexustimeout =3D=0A=
 		cpu_to_le32(ITNT | (firstBurstSize * 0x10000));=0A=
-	memcpy(&payload.sas_addr_hi, pm8001_dev->sas_device->sas_addr,=0A=
+	memcpy(payload.sas_addr, pm8001_dev->sas_device->sas_addr,=0A=
 		SAS_ADDR_SIZE);=0A=
 	rc =3D mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);=0A=
 	return rc;=0A=
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h =
b/drivers/scsi/pm8001/pm8001_hwi.h=0A=
index 96e4daa..833a520 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_hwi.h=0A=
+++ b/drivers/scsi/pm8001/pm8001_hwi.h=0A=
@@ -242,8 +242,7 @@ struct reg_dev_req {=0A=
 	__le32	phyid_portid;=0A=
 	__le32	dtype_dlr_retry;=0A=
 	__le32	firstburstsize_ITNexustimeout;=0A=
-	u32	sas_addr_hi;=0A=
-	u32	sas_addr_low;=0A=
+	u8	sas_addr[SAS_ADDR_SIZE];=0A=
 	__le32	upper_device_id;=0A=
 	u32	reserved[8];=0A=
 } __attribute__((packed, aligned(4)));=0A=
-- =0A=
1.6.5.1.1367.gcd48=0A=
=0A=

------=_NextPart_000_0023_01CA7761.E55C87A0--

