Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9941EC43217
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347735AbiBKHiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:38:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347717AbiBKHhk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:40 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CC9113A
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565056; x=1676101056;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=hXPqmIXiC6fp3v8P+yy+phH6B+zb+6qWEioSWfTUL7U=;
  b=oTscMybZUqJNc52JUkNl1/hJqUjc1lHAPcy2UDiBBDgqA2nrgyqKVrP5
   +QX1MgQqY+HuBPG1V7xrIfRR34Cfw/NOLc+t/XATuxhLKQhDHAFXubKa8
   ik++yM3ktXXwmERExNfMgimRGCWtzUNPyidmMJ8lBFQkvutu/9dV5N6kH
   gYGQg5VO5ggdKqGTzPJ+coKkx3NVBpbSunSl1S7yXgRfU2JLqjCRNSqq0
   HZO3Lw+lh/wT1+LsLDlvC0pXgqsHWU6QCOkSOX6vuo2/wIAvRih/VtKda
   gin67FjFiV+hxSb+hYgyNPPFogslIBOGDBWGAVputMr56bmuhg25cxFVu
   A==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675162"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:36 +0800
IronPort-SDR: nAf+INTGOvVjljP7ZoaWA02uNeqJ2AwUYkA2bNC9hjiOL/59C7uN1PZo9G4wC49jxrXgA8nsqn
 6MP7fX57exkWfUQGWA/eHBdCoOOoG3qXjTYGnvSyJFfBRWIrQlXdaIwf1Xv7qvNg+Dixq6Mcnb
 SdPUcdesVKG8f3w9p2wIsCHHYhPv1ruaL0lgEm5RfofvyDpLH/3FDvTr77qp2wDkjYfKMR0cS9
 BtHyEqHtAGNK1kPVlFYnRKNDhCDgJFi7KDvAWuM4g4VpKk9ozxkGSSSsq5QQNasqpPw8ssG5h2
 KUxtycd8SyJJoUssm7FIBenI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:25 -0800
IronPort-SDR: xwRzl1953XEQZb+/9+X48oGjvSnRk1jQciztWR9sipM4YhDqWESQJ9+uTFr2B6Zp/5qfpb3IkT
 cctRc6Lg/iUDK/359lEZaeQa96qm80FoojF8SEPL+sT+v5kKv8GWiK4x4fyoateUySaAmeesZr
 Qt6mZ2NJrngixbh3Xc9w66GeyihvBjDwhSMvyLDVYxd8HoE8AXX6DHtdfbfl8yNzajis6usjQv
 vGV2UUHZqhVeCBVi10jT5TevAfciIKZfI7LYsoNLJ0pyeOgvJ/XesJau349jc7JswMv8EpYzrl
 Ls4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw5752JcNz1SHwl
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:37 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565055; x=1647157056; bh=hXPqmIXiC6fp3v8P+y
        y+phH6B+zb+6qWEioSWfTUL7U=; b=fq1+iyegpJ5Mp9L8r2g7xPxirBjvpfKdUv
        7+p9X7sbsU/gRnLSR27cxLObj2nt6a8zw/XEJ5uUoRiNYAjFPesagb72+sklNqii
        HGzh5vpe4pYJwm/X74Co18PWowXsQJ10brMxIhmNEnIoceiR45b+1t8xzvhjnNHP
        lsA4ZdGQOpEoV2/GJBLEE3Y7GD8Qpu15sFBrX9ToF5oIdMImnhEWP92M+7pWc87A
        IbkMyQ2TiDS5c0rbLP5+gmZr3gqciiOxdgzVMJm5mUpkI8b4xu8yJMzyM8zSAnhF
        5KZ4or946FFYzScUfXbtJo1slSlv+1dekuxxbak7hVwqUFgGFHDQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bpHYRdkLNKKC for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:35 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw5725HHXz1SVp0;
        Thu, 10 Feb 2022 23:37:34 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 23/24] scsi: pm8001: Introduce ccb alloc/free helpers
Date:   Fri, 11 Feb 2022 16:37:03 +0900
Message-Id: <20220211073704.963993-24-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the pm8001_ccb_alloc() and pm8001_ccb_free() helpers to
replace the typical code pattern:

	res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
	...
	ccb =3D &pm8001_ha->ccb_info[ccb_tag];
	ccb->device =3D pm8001_ha_dev;
	ccb->ccb_tag =3D ccb_tag;
	ccb->task =3D task;
	ccb->n_elem =3D 0;

With a simpler single function call:

	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);

The pm8001_ccb_alloc() helper ensures that all fields of the ccb info
structure for the newly allocated tag are all initialized, except the
buf_prd field. All call site of the pm8001_tag_alloc() function that
use the ccb info associated with the allocated tag are converted to use
the new helpers.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 153 ++++++++++++++-----------------
 drivers/scsi/pm8001/pm8001_sas.c |  37 +++-----
 drivers/scsi/pm8001/pm8001_sas.h |  33 +++++++
 drivers/scsi/pm8001/pm80xx_hwi.c |  66 ++++++-------
 4 files changed, 141 insertions(+), 148 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index d853e8d0195a..8c4cf4e254ba 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1757,8 +1757,6 @@ int pm8001_handle_event(struct pm8001_hba_info *pm8=
001_ha, void *data,
 static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 		struct pm8001_device *pm8001_ha_dev)
 {
-	int res;
-	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task =3D NULL;
 	struct task_abort_req task_abort;
@@ -1780,28 +1778,26 @@ static void pm8001_send_abort_all(struct pm8001_h=
ba_info *pm8001_ha,
=20
 	task->task_done =3D pm8001_task_done;
=20
-	res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res)
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
+	if (!ccb) {
+		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
+		sas_free_task(task);
 		return;
-
-	ccb =3D &pm8001_ha->ccb_info[ccb_tag];
-	ccb->device =3D pm8001_ha_dev;
-	ccb->ccb_tag =3D ccb_tag;
-	ccb->task =3D task;
-	ccb->n_elem =3D 0;
+	}
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
 	memset(&task_abort, 0, sizeof(task_abort));
 	task_abort.abort_all =3D cpu_to_le32(1);
 	task_abort.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
-	task_abort.tag =3D cpu_to_le32(ccb_tag);
+	task_abort.tag =3D cpu_to_le32(ccb->ccb_tag);
=20
 	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
 			sizeof(task_abort), 0);
-	if (ret)
-		pm8001_tag_free(pm8001_ha, ccb_tag);
-
+	if (ret) {
+		sas_free_task(task);
+		pm8001_ccb_free(pm8001_ha, ccb);
+	}
 }
=20
 static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
@@ -1809,7 +1805,6 @@ static void pm8001_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
 {
 	struct sata_start_req sata_cmd;
 	int res;
-	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task =3D NULL;
 	struct host_to_dev_fis fis;
@@ -1825,20 +1820,13 @@ static void pm8001_send_read_log(struct pm8001_hb=
a_info *pm8001_ha,
 	}
 	task->task_done =3D pm8001_task_done;
=20
-	res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res) {
-		sas_free_task(task);
-		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
-		return;
-	}
-
-	/* allocate domain device by ourselves as libsas
-	 * is not going to provide any
-	*/
+	/*
+	 * Allocate domain device by ourselves as libsas is not going to
+	 * provide any.
+	 */
 	dev =3D kzalloc(sizeof(struct domain_device), GFP_ATOMIC);
 	if (!dev) {
 		sas_free_task(task);
-		pm8001_tag_free(pm8001_ha, ccb_tag);
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "Domain device cannot be allocated\n");
 		return;
@@ -1846,11 +1834,14 @@ static void pm8001_send_read_log(struct pm8001_hb=
a_info *pm8001_ha,
 	task->dev =3D dev;
 	task->dev->lldd_dev =3D pm8001_ha_dev;
=20
-	ccb =3D &pm8001_ha->ccb_info[ccb_tag];
-	ccb->device =3D pm8001_ha_dev;
-	ccb->ccb_tag =3D ccb_tag;
-	ccb->task =3D task;
-	ccb->n_elem =3D 0;
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
+	if (!ccb) {
+		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
+		sas_free_task(task);
+		kfree(dev);
+		return;
+	}
+
 	pm8001_ha_dev->id |=3D NCQ_READ_LOG_FLAG;
 	pm8001_ha_dev->id |=3D NCQ_2ND_RLE_FLAG;
=20
@@ -1865,7 +1856,7 @@ static void pm8001_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
 	fis.lbal =3D 0x10;
 	fis.sector_count =3D 0x1;
=20
-	sata_cmd.tag =3D cpu_to_le32(ccb_tag);
+	sata_cmd.tag =3D cpu_to_le32(ccb->ccb_tag);
 	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
 	sata_cmd.ncqtag_atap_dir_m =3D cpu_to_le32((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
@@ -1874,7 +1865,7 @@ static void pm8001_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
 			sizeof(sata_cmd), 0);
 	if (res) {
 		sas_free_task(task);
-		pm8001_tag_free(pm8001_ha, ccb_tag);
+		pm8001_ccb_free(pm8001_ha, ccb);
 		kfree(dev);
 	}
 }
@@ -4433,7 +4424,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
 	u32 stp_sspsmp_sata =3D 0x4;
 	struct inbound_queue_table *circularQ;
 	u32 linkrate, phy_id;
-	int rc, tag =3D 0xdeadbeef;
+	int rc;
 	struct pm8001_ccb_info *ccb;
 	u8 retryFlag =3D 0x1;
 	u16 firstBurstSize =3D 0;
@@ -4444,13 +4435,11 @@ static int pm8001_chip_reg_dev_req(struct pm8001_=
hba_info *pm8001_ha,
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
 	memset(&payload, 0, sizeof(payload));
-	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
-		return rc;
-	ccb =3D &pm8001_ha->ccb_info[tag];
-	ccb->device =3D pm8001_dev;
-	ccb->ccb_tag =3D tag;
-	payload.tag =3D cpu_to_le32(tag);
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, NULL);
+	if (!ccb)
+		return SAS_QUEUE_FULL;
+
+	payload.tag =3D cpu_to_le32(ccb->ccb_tag);
 	if (flag =3D=3D 1)
 		stp_sspsmp_sata =3D 0x02; /*direct attached sata */
 	else {
@@ -4642,7 +4631,6 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info=
 *pm8001_ha,
 	u32 opc =3D OPC_INB_GET_NVMD_DATA;
 	u32 nvmd_type;
 	int rc;
-	u32 tag;
 	struct pm8001_ccb_info *ccb;
 	struct inbound_queue_table *circularQ;
 	struct get_nvm_data_req nvmd_req;
@@ -4657,15 +4645,15 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_in=
fo *pm8001_ha,
 	fw_control_context->len =3D ioctl_payload->rd_length;
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
-	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc) {
+
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, NULL, NULL);
+	if (!ccb) {
 		kfree(fw_control_context);
-		return rc;
+		return -EBUSY;
 	}
-	ccb =3D &pm8001_ha->ccb_info[tag];
-	ccb->ccb_tag =3D tag;
 	ccb->fw_control_context =3D fw_control_context;
-	nvmd_req.tag =3D cpu_to_le32(tag);
+
+	nvmd_req.tag =3D cpu_to_le32(ccb->ccb_tag);
=20
 	switch (nvmd_type) {
 	case TWI_DEVICE: {
@@ -4726,7 +4714,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info=
 *pm8001_ha,
 			sizeof(nvmd_req), 0);
 	if (rc) {
 		kfree(fw_control_context);
-		pm8001_tag_free(pm8001_ha, tag);
+		pm8001_ccb_free(pm8001_ha, ccb);
 	}
 	return rc;
 }
@@ -4737,7 +4725,6 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info=
 *pm8001_ha,
 	u32 opc =3D OPC_INB_SET_NVMD_DATA;
 	u32 nvmd_type;
 	int rc;
-	u32 tag;
 	struct pm8001_ccb_info *ccb;
 	struct inbound_queue_table *circularQ;
 	struct set_nvm_data_req nvmd_req;
@@ -4753,15 +4740,15 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_in=
fo *pm8001_ha,
 		&ioctl_payload->func_specific,
 		ioctl_payload->wr_length);
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
-	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc) {
+
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, NULL, NULL);
+	if (!ccb) {
 		kfree(fw_control_context);
 		return -EBUSY;
 	}
-	ccb =3D &pm8001_ha->ccb_info[tag];
 	ccb->fw_control_context =3D fw_control_context;
-	ccb->ccb_tag =3D tag;
-	nvmd_req.tag =3D cpu_to_le32(tag);
+
+	nvmd_req.tag =3D cpu_to_le32(ccb->ccb_tag);
 	switch (nvmd_type) {
 	case TWI_DEVICE: {
 		u32 twi_addr, twi_page_size;
@@ -4811,7 +4798,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info=
 *pm8001_ha,
 			sizeof(nvmd_req), 0);
 	if (rc) {
 		kfree(fw_control_context);
-		pm8001_tag_free(pm8001_ha, tag);
+		pm8001_ccb_free(pm8001_ha, ccb);
 	}
 	return rc;
 }
@@ -4856,8 +4843,6 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 	struct fw_flash_updata_info flash_update_info;
 	struct fw_control_info *fw_control;
 	struct fw_control_ex *fw_control_context;
-	int rc;
-	u32 tag;
 	struct pm8001_ccb_info *ccb;
 	void *buffer =3D pm8001_ha->memoryMap.region[FW_FLASH].virt_ptr;
 	dma_addr_t phys_addr =3D pm8001_ha->memoryMap.region[FW_FLASH].phys_add=
r;
@@ -4881,17 +4866,16 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba=
_info *pm8001_ha,
 	fw_control_context->virtAddr =3D buffer;
 	fw_control_context->phys_addr =3D phys_addr;
 	fw_control_context->len =3D fw_control->len;
-	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc) {
+
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, NULL, NULL);
+	if (!ccb) {
 		kfree(fw_control_context);
 		return -EBUSY;
 	}
-	ccb =3D &pm8001_ha->ccb_info[tag];
 	ccb->fw_control_context =3D fw_control_context;
-	ccb->ccb_tag =3D tag;
-	rc =3D pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
-		tag);
-	return rc;
+
+	return pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
+						 ccb->ccb_tag);
 }
=20
 ssize_t
@@ -4979,24 +4963,21 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 	struct set_dev_state_req payload;
 	struct inbound_queue_table *circularQ;
 	struct pm8001_ccb_info *ccb;
-	int rc;
-	u32 tag;
 	u32 opc =3D OPC_INB_SET_DEVICE_STATE;
+
 	memset(&payload, 0, sizeof(payload));
-	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, NULL);
+	if (!ccb)
 		return -1;
-	ccb =3D &pm8001_ha->ccb_info[tag];
-	ccb->ccb_tag =3D tag;
-	ccb->device =3D pm8001_dev;
+
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
-	payload.tag =3D cpu_to_le32(tag);
+	payload.tag =3D cpu_to_le32(ccb->ccb_tag);
 	payload.device_id =3D cpu_to_le32(pm8001_dev->device_id);
 	payload.nds =3D cpu_to_le32(state);
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
-	return rc;
=20
+	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+				    sizeof(payload), 0);
 }
=20
 static int
@@ -5006,25 +4987,27 @@ pm8001_chip_sas_re_initialization(struct pm8001_h=
ba_info *pm8001_ha)
 	struct inbound_queue_table *circularQ;
 	struct pm8001_ccb_info *ccb;
 	int rc;
-	u32 tag;
 	u32 opc =3D OPC_INB_SAS_RE_INITIALIZE;
+
 	memset(&payload, 0, sizeof(payload));
-	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, NULL, NULL);
+	if (!ccb)
 		return -ENOMEM;
-	ccb =3D &pm8001_ha->ccb_info[tag];
-	ccb->ccb_tag =3D tag;
+
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
-	payload.tag =3D cpu_to_le32(tag);
+
+	payload.tag =3D cpu_to_le32(ccb->ccb_tag);
 	payload.SSAHOLT =3D cpu_to_le32(0xd << 25);
 	payload.sata_hol_tmo =3D cpu_to_le32(80);
 	payload.open_reject_cmdretries_data_retries =3D cpu_to_le32(0xff00ff);
+
 	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+				  sizeof(payload), 0);
 	if (rc)
-		pm8001_tag_free(pm8001_ha, tag);
-	return rc;
+		pm8001_ccb_free(pm8001_ha, ccb);
=20
+	return rc;
 }
=20
 const struct pm8001_dispatch pm8001_8001_dispatch =3D {
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 8cd7e7837f41..6b8843344893 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -74,7 +74,7 @@ void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha,=
 u32 tag)
   * @pm8001_ha: our hba struct
   * @tag_out: the found empty tag .
   */
-inline int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_=
out)
+int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
 {
 	unsigned int tag;
 	void *bitmap =3D pm8001_ha->tags;
@@ -383,7 +383,7 @@ static int pm8001_task_exec(struct sas_task *task,
 	struct sas_task *t =3D task;
 	struct task_status_struct *ts =3D &t->task_status;
 	struct pm8001_ccb_info *ccb;
-	u32 tag =3D 0xdeadbeef, rc =3D 0, n_elem;
+	u32 rc =3D 0, n_elem;
 	unsigned long flags =3D 0;
 	enum sas_protocol task_proto =3D t->task_proto;
=20
@@ -424,11 +424,11 @@ static int pm8001_task_exec(struct sas_task *task,
 			continue;
 		}
=20
-		rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-		if (rc)
+		ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, t);
+		if (!ccb) {
+			rc =3D -EBUSY;
 			goto err_out;
-
-		ccb =3D &pm8001_ha->ccb_info[tag];
+		}
=20
 		if (!sas_protocol_ata(task_proto)) {
 			if (t->num_scatter) {
@@ -438,7 +438,7 @@ static int pm8001_task_exec(struct sas_task *task,
 					t->data_dir);
 				if (!n_elem) {
 					rc =3D -ENOMEM;
-					goto err_out_tag;
+					goto err_out_ccb;
 				}
 			} else {
 				n_elem =3D 0;
@@ -449,9 +449,7 @@ static int pm8001_task_exec(struct sas_task *task,
=20
 		t->lldd_task =3D ccb;
 		ccb->n_elem =3D n_elem;
-		ccb->ccb_tag =3D tag;
-		ccb->task =3D t;
-		ccb->device =3D pm8001_dev;
+
 		switch (task_proto) {
 		case SAS_PROTOCOL_SMP:
 			atomic_inc(&pm8001_dev->running_req);
@@ -480,7 +478,7 @@ static int pm8001_task_exec(struct sas_task *task,
 		if (rc) {
 			pm8001_dbg(pm8001_ha, IO, "rc is %x\n", rc);
 			atomic_dec(&pm8001_dev->running_req);
-			goto err_out_tag;
+			goto err_out_ccb;
 		}
 		/* TODO: select normal or high priority */
 		spin_lock(&t->task_state_lock);
@@ -490,8 +488,8 @@ static int pm8001_task_exec(struct sas_task *task,
 	rc =3D 0;
 	goto out_done;
=20
-err_out_tag:
-	pm8001_tag_free(pm8001_ha, tag);
+err_out_ccb:
+	pm8001_ccb_free(pm8001_ha, ccb);
 err_out:
 	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
 	if (!sas_protocol_ata(task_proto))
@@ -816,7 +814,6 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_inf=
o *pm8001_ha,
 	u32 task_tag)
 {
 	int res, retry;
-	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task =3D NULL;
=20
@@ -832,18 +829,12 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_i=
nfo *pm8001_ha,
 		task->slow_task->timer.expires =3D jiffies + PM8001_TASK_TIMEOUT * HZ;
 		add_timer(&task->slow_task->timer);
=20
-		res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-		if (res)
+		ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, task);
+		if (!ccb)
 			goto ex_err;
-		ccb =3D &pm8001_ha->ccb_info[ccb_tag];
-		ccb->device =3D pm8001_dev;
-		ccb->ccb_tag =3D ccb_tag;
-		ccb->task =3D task;
-		ccb->n_elem =3D 0;
=20
 		res =3D PM8001_CHIP_DISP->task_abort(pm8001_ha,
-			pm8001_dev, flag, task_tag, ccb_tag);
-
+			pm8001_dev, flag, task_tag, ccb->ccb_tag);
 		if (res) {
 			del_timer(&task->slow_task->timer);
 			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm800=
1_sas.h
index a17da1cebce1..6aafa48bf235 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -738,6 +738,39 @@ void pm8001_free_dev(struct pm8001_device *pm8001_de=
v);
 /* ctl shared API */
 extern const struct attribute_group *pm8001_host_groups[];
=20
+/*
+ * Allocate a new tag and return the corresponding ccb after initializin=
g it.
+ */
+static inline struct pm8001_ccb_info *
+pm8001_ccb_alloc(struct pm8001_hba_info *pm8001_ha,
+		 struct pm8001_device *dev, struct sas_task *task)
+{
+	struct pm8001_ccb_info *ccb;
+	u32 tag;
+
+	if (pm8001_tag_alloc(pm8001_ha, &tag))
+		return NULL;
+
+	ccb =3D &pm8001_ha->ccb_info[tag];
+	ccb->task =3D task;
+	ccb->n_elem =3D 0;
+	ccb->ccb_tag =3D tag;
+	ccb->device =3D dev;
+	ccb->fw_control_context =3D NULL;
+	ccb->open_retry =3D 0;
+
+	return ccb;
+}
+
+/*
+ * Free the tag of an initialized ccb.
+ */
+static inline void pm8001_ccb_free(struct pm8001_hba_info *pm8001_ha,
+				   struct pm8001_ccb_info *ccb)
+{
+	pm8001_tag_free(pm8001_ha, ccb->ccb_tag);
+}
+
 static inline void
 pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
 			struct sas_task *task, struct pm8001_ccb_info *ccb,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index ce33d0e71076..eddaf2dff0e9 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1767,8 +1767,6 @@ pm80xx_chip_interrupt_disable(struct pm8001_hba_inf=
o *pm8001_ha, u8 vec)
 static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 		struct pm8001_device *pm8001_ha_dev)
 {
-	int res;
-	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task =3D NULL;
 	struct task_abort_req task_abort;
@@ -1790,31 +1788,26 @@ static void pm80xx_send_abort_all(struct pm8001_h=
ba_info *pm8001_ha,
=20
 	task->task_done =3D pm8001_task_done;
=20
-	res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res) {
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
+	if (!ccb) {
+		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
 		sas_free_task(task);
 		return;
 	}
=20
-	ccb =3D &pm8001_ha->ccb_info[ccb_tag];
-	ccb->device =3D pm8001_ha_dev;
-	ccb->ccb_tag =3D ccb_tag;
-	ccb->task =3D task;
-	ccb->n_elem =3D 0;
-
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
 	memset(&task_abort, 0, sizeof(task_abort));
 	task_abort.abort_all =3D cpu_to_le32(1);
 	task_abort.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
-	task_abort.tag =3D cpu_to_le32(ccb_tag);
+	task_abort.tag =3D cpu_to_le32(ccb->ccb_tag);
=20
 	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
 			sizeof(task_abort), 0);
 	pm8001_dbg(pm8001_ha, FAIL, "Executing abort task end\n");
 	if (ret) {
 		sas_free_task(task);
-		pm8001_tag_free(pm8001_ha, ccb_tag);
+		pm8001_ccb_free(pm8001_ha, ccb);
 	}
 }
=20
@@ -1823,7 +1816,6 @@ static void pm80xx_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
 {
 	struct sata_start_req sata_cmd;
 	int res;
-	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task =3D NULL;
 	struct host_to_dev_fis fis;
@@ -1839,20 +1831,13 @@ static void pm80xx_send_read_log(struct pm8001_hb=
a_info *pm8001_ha,
 	}
 	task->task_done =3D pm8001_task_done;
=20
-	res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res) {
-		sas_free_task(task);
-		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
-		return;
-	}
-
-	/* allocate domain device by ourselves as libsas
-	 * is not going to provide any
-	*/
+	/*
+	 * Allocate domain device by ourselves as libsas is not going to
+	 * provide any.
+	 */
 	dev =3D kzalloc(sizeof(struct domain_device), GFP_ATOMIC);
 	if (!dev) {
 		sas_free_task(task);
-		pm8001_tag_free(pm8001_ha, ccb_tag);
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "Domain device cannot be allocated\n");
 		return;
@@ -1861,11 +1846,14 @@ static void pm80xx_send_read_log(struct pm8001_hb=
a_info *pm8001_ha,
 	task->dev =3D dev;
 	task->dev->lldd_dev =3D pm8001_ha_dev;
=20
-	ccb =3D &pm8001_ha->ccb_info[ccb_tag];
-	ccb->device =3D pm8001_ha_dev;
-	ccb->ccb_tag =3D ccb_tag;
-	ccb->task =3D task;
-	ccb->n_elem =3D 0;
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
+	if (!ccb) {
+		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
+		sas_free_task(task);
+		kfree(dev);
+		return;
+	}
+
 	pm8001_ha_dev->id |=3D NCQ_READ_LOG_FLAG;
 	pm8001_ha_dev->id |=3D NCQ_2ND_RLE_FLAG;
=20
@@ -1880,7 +1868,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
 	fis.lbal =3D 0x10;
 	fis.sector_count =3D 0x1;
=20
-	sata_cmd.tag =3D cpu_to_le32(ccb_tag);
+	sata_cmd.tag =3D cpu_to_le32(ccb->ccb_tag);
 	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
 	sata_cmd.ncqtag_atap_dir_m_dad =3D cpu_to_le32(((0x1 << 7) | (0x5 << 9)=
));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
@@ -1890,7 +1878,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
 	pm8001_dbg(pm8001_ha, FAIL, "Executing read log end\n");
 	if (res) {
 		sas_free_task(task);
-		pm8001_tag_free(pm8001_ha, ccb_tag);
+		pm8001_ccb_free(pm8001_ha, ccb);
 		kfree(dev);
 	}
 }
@@ -4844,7 +4832,7 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
 	u32 stp_sspsmp_sata =3D 0x4;
 	struct inbound_queue_table *circularQ;
 	u32 linkrate, phy_id;
-	int rc, tag =3D 0xdeadbeef;
+	int rc;
 	struct pm8001_ccb_info *ccb;
 	u8 retryFlag =3D 0x1;
 	u16 firstBurstSize =3D 0;
@@ -4855,13 +4843,11 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_=
hba_info *pm8001_ha,
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
 	memset(&payload, 0, sizeof(payload));
-	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
-		return rc;
-	ccb =3D &pm8001_ha->ccb_info[tag];
-	ccb->device =3D pm8001_dev;
-	ccb->ccb_tag =3D tag;
-	payload.tag =3D cpu_to_le32(tag);
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, NULL);
+	if (!ccb)
+		return SAS_QUEUE_FULL;
+
+	payload.tag =3D cpu_to_le32(ccb->ccb_tag);
=20
 	if (flag =3D=3D 1) {
 		stp_sspsmp_sata =3D 0x02; /*direct attached sata */
@@ -4898,7 +4884,7 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
 	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
 	if (rc)
-		pm8001_tag_free(pm8001_ha, tag);
+		pm8001_ccb_free(pm8001_ha, ccb);
=20
 	return rc;
 }
--=20
2.34.1

