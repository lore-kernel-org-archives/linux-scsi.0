From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 3/5] pm8001: fix endian issues
Date: Wed, 18 Nov 2009 17:17:55 +0800
Message-ID: <63A9B76283D3486F92CFEBA73A036110@usish.com.cn>
References: <20091118004303.GA10326@serverengines.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0024_01CA6873.11886680"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:49392 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbZKRJRv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 04:17:51 -0500
In-Reply-To: <20091118004303.GA10326@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_0024_01CA6873.11886680
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

     This patch will fix endian issues.

------=_NextPart_000_0024_01CA6873.11886680
Content-Type: application/octet-stream;
	name="0003-fix-endian-issues.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0003-fix-endian-issues.patch"

>From e56479984831f76c0139418d7cef427e4bd331dd Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Wed, 18 Nov 2009 15:40:38 +0800=0A=
Subject: [PATCH 3/4] fix endian issues=0A=
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

------=_NextPart_000_0024_01CA6873.11886680--

