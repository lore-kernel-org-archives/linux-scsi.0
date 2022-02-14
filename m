Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CADC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239343AbiBNCUt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiBNCUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:18 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32715549F
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805209; x=1676341209;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=qwDTp6rN52yV/KIse7C9lh1flvowDd5YOIYkfLFbqdc=;
  b=BoWRFG+FihcrDpZ0htI5AJu7pfQKQwX4nhLF/AR6mkv+yJr3alxLJvm1
   /kyBDSod3MLVigWuXyTuXzEtT+a7WWhVLNf34Dy/489Iwe1FQ14IJwCjo
   N0AzYNINu+CiC9Fsl0GHxGzyZtOuejel/iTquQZl1mrJzT7dTMLdTBSkd
   46bDL7FIHK3wPkZiSZsg/kZAkN3Ks23GoH/5Xca96qxPlwvVbg//T+vhh
   YylK3ppwY1MU3lpPi1oPxR3gNm65yrSONB+YUANQHPnNEY7YFS3HW7pvJ
   MK27e7WxGbW/0QZ3ONoxuhoTF2hkLuu2Jc0d3/Oe/1rl/sddhMRCxTapm
   w==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819839"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:20:09 +0800
IronPort-SDR: DYOYmdQln4EgNV8p45KHw9eGUm8mMQLEJZEIWAxLfnybQaCBXKdDdbMrZgvlbli0sIL7ZPOj9s
 e9mKT32V3nbSg0U8TUO2b2th50qLm1XntCs6pdo9YieZNTNsCMDMgyCCWxU/mnUgTGh1mmIuRr
 DFcqZ6LqHW95eztCI5KydT8lN+Idg82R3EsRUTmUhbOl4V78cxIs9GRZziMVrLoJ4NXONFK7jJ
 4i5mBYqShV0oaHeciAMrzp+4/ROqjecbn8pN3awDxfMsiP+BARWYgw0pgu3B/uRdAUcs7oxmGJ
 MpzwxnM19MIj308BYpxTynDq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:53:01 -0800
IronPort-SDR: o5fGVf9rr2cY6ewVMGijS6j43HSmS3GXoD0Li/0Gghwa3mHOLpj4FIiO+nmV8BzUkeC4Htcnbo
 XfX5eM7j6FAq+9WQfT+wJY8FwrAZj0xCO3hqDCI9zI+QTwWgk+Zs2nxsEmiLOHkEHexAGhO8ny
 XF5OyFJ0poRcqDMQhabH3uEtJJ8Ib3n9XUnRuzBXXHA7I2g1ENJsxYx3kadJaUzZjkRhHmp0v7
 saQuK329ZrO+HXzplKbX6rybl6mk8UazOZrzcWRDjMcPxaGNQiN8q3rH7TAxb/bIzmw+71g15n
 VKQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:20:10 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JxnxP5LnQz1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:09 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805207; x=1647397208; bh=qwDTp6rN52yV/KIse7
        C9lh1flvowDd5YOIYkfLFbqdc=; b=KA8nqhBl0TB7bG4TyIpSmxF84Cn81wrKEI
        BYJ16hSVXOylyn2hTjnzy3+aHt/fWcrSifNq4w5Xli9hwm0MqukYxaouNK9aW0uQ
        mt/TAxATyp3XWIpAQAmwcAWIwk0wBrYs4wj67vZ1cw5bIWjwXxI/d+cfddKY4ROf
        HauhEq6qxRJkAxQlP7668xPDZFSNR+FMHd3Qg9PCtEHe6O2I7AN5g4VKcnaV3zHM
        /kWELGksi8eJBq/l2+8/Tc8n3YcIZmJmKVt2kG6Vvi4Pzs+rZGv0E1HDJk3XAVY9
        zl0A8531nDomHiRUG/EzN1YHgIB1Y/UZ4eO1jHozl8ppgQ56PbGw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id M3oWylkTyJGx for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:20:07 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JxnxL21zRz1Rwrw;
        Sun, 13 Feb 2022 18:20:06 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 29/31] scsi: pm8001: Simplify pm8001_mpi_build_cmd() interface
Date:   Mon, 14 Feb 2022 11:17:45 +0900
Message-Id: <20220214021747.4976-30-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need to pass a pointer to a struct inbound_queue_table to
pm8001_mpi_build_cmd(). Passing the start index in the inbound queue
table of the adapter is enough. This change allows avoiding the
declaration of a struct inbound_queue_table pointer (circularQ
variables) in many functions, simplifying the code.

While at it, blank lines are added i(e.g. after local variable
declarations) to make the code more readable.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 154 +++++++++++--------------------
 drivers/scsi/pm8001/pm8001_sas.h |   3 +-
 drivers/scsi/pm8001/pm80xx_hwi.c |  98 +++++++-------------
 3 files changed, 89 insertions(+), 166 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 9018c7140d71..726421311543 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1309,21 +1309,20 @@ int pm8001_mpi_msg_free_get(struct inbound_queue_=
table *circularQ,
  * pm8001_mpi_build_cmd- build the message queue for transfer, update th=
e PI to
  * FW to tell the fw to get this message from IOMB.
  * @pm8001_ha: our hba card information
- * @circularQ: the inbound queue we want to transfer to HBA.
+ * @q_index: the index in the inbound queue we want to transfer to HBA.
  * @opCode: the operation code represents commands which LLDD and fw rec=
ognized.
  * @payload: the command payload of each operation command.
  * @nb: size in bytes of the command payload
  * @responseQueue: queue to interrupt on w/ command response (if any)
  */
 int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
-			 struct inbound_queue_table *circularQ,
-			 u32 opCode, void *payload, size_t nb,
+			 u32 q_index, u32 opCode, void *payload, size_t nb,
 			 u32 responseQueue)
 {
 	u32 Header =3D 0, hpriority =3D 0, bc =3D 1, category =3D 0x02;
 	void *pMessage;
 	unsigned long flags;
-	int q_index =3D circularQ - pm8001_ha->inbnd_q_tbl;
+	struct inbound_queue_table *circularQ =3D &pm8001_ha->inbnd_q_tbl[q_ind=
ex];
 	int rv;
 	u32 htag =3D le32_to_cpu(*(__le32 *)payload);
=20
@@ -1752,7 +1751,6 @@ static void pm8001_send_abort_all(struct pm8001_hba=
_info *pm8001_ha,
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task =3D NULL;
 	struct task_abort_req task_abort;
-	struct inbound_queue_table *circularQ;
 	u32 opc =3D OPC_INB_SATA_ABORT;
 	int ret;
=20
@@ -1775,15 +1773,13 @@ static void pm8001_send_abort_all(struct pm8001_h=
ba_info *pm8001_ha,
 		return;
 	}
=20
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
-
 	memset(&task_abort, 0, sizeof(task_abort));
 	task_abort.abort_all =3D cpu_to_le32(1);
 	task_abort.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
 	task_abort.tag =3D cpu_to_le32(ccb->ccb_tag);
=20
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
-			sizeof(task_abort), 0);
+	ret =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &task_abort,
+				   sizeof(task_abort), 0);
 	if (ret) {
 		sas_free_task(task);
 		pm8001_ccb_free(pm8001_ha, ccb);
@@ -1799,11 +1795,9 @@ static void pm8001_send_read_log(struct pm8001_hba=
_info *pm8001_ha,
 	struct sas_task *task =3D NULL;
 	struct host_to_dev_fis fis;
 	struct domain_device *dev;
-	struct inbound_queue_table *circularQ;
 	u32 opc =3D OPC_INB_SATA_HOST_OPSTART;
=20
 	task =3D sas_alloc_slow_task(GFP_ATOMIC);
-
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task !!!\n");
 		return;
@@ -1834,9 +1828,6 @@ static void pm8001_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
 	pm8001_ha_dev->id |=3D NCQ_READ_LOG_FLAG;
 	pm8001_ha_dev->id |=3D NCQ_2ND_RLE_FLAG;
=20
-	memset(&sata_cmd, 0, sizeof(sata_cmd));
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
-
 	/* construct read log FIS */
 	memset(&fis, 0, sizeof(struct host_to_dev_fis));
 	fis.fis_type =3D 0x27;
@@ -1845,13 +1836,14 @@ static void pm8001_send_read_log(struct pm8001_hb=
a_info *pm8001_ha,
 	fis.lbal =3D 0x10;
 	fis.sector_count =3D 0x1;
=20
+	memset(&sata_cmd, 0, sizeof(sata_cmd));
 	sata_cmd.tag =3D cpu_to_le32(ccb->ccb_tag);
 	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
 	sata_cmd.ncqtag_atap_dir_m =3D cpu_to_le32((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
=20
-	res =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
-			sizeof(sata_cmd), 0);
+	res =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &sata_cmd,
+				   sizeof(sata_cmd), 0);
 	if (res) {
 		sas_free_task(task);
 		pm8001_ccb_free(pm8001_ha, ccb);
@@ -3278,17 +3270,14 @@ static void pm8001_hw_event_ack_req(struct pm8001=
_hba_info *pm8001_ha,
 	struct hw_event_ack_req	 payload;
 	u32 opc =3D OPC_INB_SAS_HW_EVENT_ACK;
=20
-	struct inbound_queue_table *circularQ;
-
 	memset((u8 *)&payload, 0, sizeof(payload));
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[Qnum];
 	payload.tag =3D cpu_to_le32(1);
 	payload.sea_phyid_portid =3D cpu_to_le32(((SEA & 0xFFFF) << 8) |
 		((phyId & 0x0F) << 4) | (port_id & 0x0F));
 	payload.param0 =3D cpu_to_le32(param0);
 	payload.param1 =3D cpu_to_le32(param1);
-	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+
+	pm8001_mpi_build_cmd(pm8001_ha, Qnum, opc, &payload, sizeof(payload), 0=
);
 }
=20
 static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
@@ -4120,7 +4109,6 @@ static int pm8001_chip_smp_req(struct pm8001_hba_in=
fo *pm8001_ha,
 	u32 req_len, resp_len;
 	struct smp_req smp_cmd;
 	u32 opc;
-	struct inbound_queue_table *circularQ;
=20
 	memset(&smp_cmd, 0, sizeof(smp_cmd));
 	/*
@@ -4146,7 +4134,6 @@ static int pm8001_chip_smp_req(struct pm8001_hba_in=
fo *pm8001_ha,
 	}
=20
 	opc =3D OPC_INB_SMP_REQUEST;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	smp_cmd.tag =3D cpu_to_le32(ccb->ccb_tag);
 	smp_cmd.long_smp_req.long_req_addr =3D
 		cpu_to_le64((u64)sg_dma_address(&task->smp_task.smp_req));
@@ -4157,8 +4144,8 @@ static int pm8001_chip_smp_req(struct pm8001_hba_in=
fo *pm8001_ha,
 	smp_cmd.long_smp_req.long_resp_size =3D
 		cpu_to_le32((u32)sg_dma_len(&task->smp_task.smp_resp)-4);
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag, &smp_cmd);
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
-			&smp_cmd, sizeof(smp_cmd), 0);
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc,
+				  &smp_cmd, sizeof(smp_cmd), 0);
 	if (rc)
 		goto err_out_2;
=20
@@ -4186,9 +4173,7 @@ static int pm8001_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;
 	struct ssp_ini_io_start_req ssp_cmd;
 	u32 tag =3D ccb->ccb_tag;
-	int ret;
 	u64 phys_addr;
-	struct inbound_queue_table *circularQ;
 	u32 opc =3D OPC_INB_SSPINIIOSTART;
 	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
 	memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);
@@ -4204,7 +4189,6 @@ static int pm8001_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_attr & 7);
 	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
 	       task->ssp_task.cmd->cmd_len);
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
 	/* fill in PRD (scatter/gather) table, if any */
 	if (task->num_scatter > 1) {
@@ -4225,9 +4209,9 @@ static int pm8001_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 		ssp_cmd.len =3D cpu_to_le32(task->total_xfer_len);
 		ssp_cmd.esgl =3D 0;
 	}
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &ssp_cmd,
-			sizeof(ssp_cmd), 0);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &ssp_cmd,
+				    sizeof(ssp_cmd), 0);
 }
=20
 static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
@@ -4237,17 +4221,15 @@ static int pm8001_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
 	struct domain_device *dev =3D task->dev;
 	struct pm8001_device *pm8001_ha_dev =3D dev->lldd_dev;
 	u32 tag =3D ccb->ccb_tag;
-	int ret;
 	struct sata_start_req sata_cmd;
 	u32 hdr_tag, ncg_tag =3D 0;
 	u64 phys_addr;
 	u32 ATAP =3D 0x0;
 	u32 dir;
-	struct inbound_queue_table *circularQ;
 	unsigned long flags;
 	u32  opc =3D OPC_INB_SATA_HOST_OPSTART;
+
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
 	if (task->data_dir =3D=3D DMA_NONE && !task->ata_task.use_ncq) {
 		ATAP =3D 0x04;  /* no data*/
@@ -4333,9 +4315,8 @@ static int pm8001_chip_sata_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 		}
 	}
=20
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
-			sizeof(sata_cmd), 0);
-	return ret;
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &sata_cmd,
+				    sizeof(sata_cmd), 0);
 }
=20
 /**
@@ -4347,11 +4328,9 @@ static int
 pm8001_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 {
 	struct phy_start_req payload;
-	struct inbound_queue_table *circularQ;
-	int ret;
 	u32 tag =3D 0x01;
 	u32 opcode =3D OPC_INB_PHYSTART;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
+
 	memset(&payload, 0, sizeof(payload));
 	payload.tag =3D cpu_to_le32(tag);
 	/*
@@ -4368,9 +4347,9 @@ pm8001_chip_phy_start_req(struct pm8001_hba_info *p=
m8001_ha, u8 phy_id)
 	memcpy(payload.sas_identify.sas_addr,
 		pm8001_ha->sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id =3D phy_id;
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
-			sizeof(payload), 0);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+				    sizeof(payload), 0);
 }
=20
 /**
@@ -4382,17 +4361,15 @@ static int pm8001_chip_phy_stop_req(struct pm8001=
_hba_info *pm8001_ha,
 				    u8 phy_id)
 {
 	struct phy_stop_req payload;
-	struct inbound_queue_table *circularQ;
-	int ret;
 	u32 tag =3D 0x01;
 	u32 opcode =3D OPC_INB_PHYSTOP;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
+
 	memset(&payload, 0, sizeof(payload));
 	payload.tag =3D cpu_to_le32(tag);
 	payload.phy_id =3D cpu_to_le32(phy_id);
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
-			sizeof(payload), 0);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+				    sizeof(payload), 0);
 }
=20
 /*
@@ -4404,7 +4381,6 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
 	struct reg_dev_req payload;
 	u32	opc;
 	u32 stp_sspsmp_sata =3D 0x4;
-	struct inbound_queue_table *circularQ;
 	u32 linkrate, phy_id;
 	int rc;
 	struct pm8001_ccb_info *ccb;
@@ -4414,7 +4390,6 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
 	struct domain_device *dev =3D pm8001_dev->sas_device;
 	struct domain_device *parent_dev =3D dev->parent;
 	struct pm8001_port *port =3D dev->port->lldd_port;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
 	memset(&payload, 0, sizeof(payload));
 	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, NULL);
@@ -4448,8 +4423,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
 		cpu_to_le32(ITNT | (firstBurstSize * 0x10000));
 	memcpy(payload.sas_addr, pm8001_dev->sas_device->sas_addr,
 		SAS_ADDR_SIZE);
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
+				  sizeof(payload), 0);
 	if (rc)
 		pm8001_ccb_free(pm8001_ha, ccb);
=20
@@ -4464,18 +4440,15 @@ int pm8001_chip_dereg_dev_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 {
 	struct dereg_dev_req payload;
 	u32 opc =3D OPC_INB_DEREG_DEV_HANDLE;
-	int ret;
-	struct inbound_queue_table *circularQ;
=20
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	memset(&payload, 0, sizeof(payload));
 	payload.tag =3D cpu_to_le32(1);
 	payload.device_id =3D cpu_to_le32(device_id);
 	pm8001_dbg(pm8001_ha, MSG, "unregister device device_id =3D %d\n",
 		   device_id);
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
+				    sizeof(payload), 0);
 }
=20
 /**
@@ -4488,17 +4461,15 @@ static int pm8001_chip_phy_ctl_req(struct pm8001_=
hba_info *pm8001_ha,
 	u32 phyId, u32 phy_op)
 {
 	struct local_phy_ctl_req payload;
-	struct inbound_queue_table *circularQ;
-	int ret;
 	u32 opc =3D OPC_INB_LOCAL_PHY_CONTROL;
+
 	memset(&payload, 0, sizeof(payload));
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(1);
 	payload.phyop_phyid =3D
 		cpu_to_le32(((phy_op & 0xff) << 8) | (phyId & 0x0F));
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
+				    sizeof(payload), 0);
 }
=20
 static u32 pm8001_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_h=
a)
@@ -4536,9 +4507,7 @@ static int send_task_abort(struct pm8001_hba_info *=
pm8001_ha, u32 opc,
 	u32 dev_id, u8 flag, u32 task_tag, u32 cmd_tag)
 {
 	struct task_abort_req task_abort;
-	struct inbound_queue_table *circularQ;
-	int ret;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
+
 	memset(&task_abort, 0, sizeof(task_abort));
 	if (ABORT_SINGLE =3D=3D (flag & ABORT_MASK)) {
 		task_abort.abort_all =3D 0;
@@ -4550,9 +4519,9 @@ static int send_task_abort(struct pm8001_hba_info *=
pm8001_ha, u32 opc,
 		task_abort.device_id =3D cpu_to_le32(dev_id);
 		task_abort.tag =3D cpu_to_le32(cmd_tag);
 	}
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
-			sizeof(task_abort), 0);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &task_abort,
+				    sizeof(task_abort), 0);
 }
=20
 /*
@@ -4592,9 +4561,7 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *=
pm8001_ha,
 	struct domain_device *dev =3D task->dev;
 	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;
 	u32 opc =3D OPC_INB_SSPINITMSTART;
-	struct inbound_queue_table *circularQ;
 	struct ssp_ini_tm_start_req sspTMCmd;
-	int ret;
=20
 	memset(&sspTMCmd, 0, sizeof(sspTMCmd));
 	sspTMCmd.device_id =3D cpu_to_le32(pm8001_dev->device_id);
@@ -4604,10 +4571,9 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info =
*pm8001_ha,
 	sspTMCmd.tag =3D cpu_to_le32(ccb->ccb_tag);
 	if (pm8001_ha->chip_id !=3D chip_8001)
 		sspTMCmd.ds_ads_m =3D cpu_to_le32(0x08);
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd,
-			sizeof(sspTMCmd), 0);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &sspTMCmd,
+				    sizeof(sspTMCmd), 0);
 }
=20
 int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
@@ -4617,7 +4583,6 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info=
 *pm8001_ha,
 	u32 nvmd_type;
 	int rc;
 	struct pm8001_ccb_info *ccb;
-	struct inbound_queue_table *circularQ;
 	struct get_nvm_data_req nvmd_req;
 	struct fw_control_ex *fw_control_context;
 	struct pm8001_ioctl_payload *ioctl_payload =3D payload;
@@ -4628,7 +4593,6 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info=
 *pm8001_ha,
 		return -ENOMEM;
 	fw_control_context->usrAddr =3D (u8 *)ioctl_payload->func_specific;
 	fw_control_context->len =3D ioctl_payload->rd_length;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
=20
 	ccb =3D pm8001_ccb_alloc(pm8001_ha, NULL, NULL);
@@ -4695,8 +4659,9 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info=
 *pm8001_ha,
 	default:
 		break;
 	}
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req,
-			sizeof(nvmd_req), 0);
+
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &nvmd_req,
+				  sizeof(nvmd_req), 0);
 	if (rc) {
 		kfree(fw_control_context);
 		pm8001_ccb_free(pm8001_ha, ccb);
@@ -4711,7 +4676,6 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info=
 *pm8001_ha,
 	u32 nvmd_type;
 	int rc;
 	struct pm8001_ccb_info *ccb;
-	struct inbound_queue_table *circularQ;
 	struct set_nvm_data_req nvmd_req;
 	struct fw_control_ex *fw_control_context;
 	struct pm8001_ioctl_payload *ioctl_payload =3D payload;
@@ -4720,7 +4684,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info=
 *pm8001_ha,
 	fw_control_context =3D kzalloc(sizeof(struct fw_control_ex), GFP_KERNEL=
);
 	if (!fw_control_context)
 		return -ENOMEM;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
+
 	memcpy(pm8001_ha->memoryMap.region[NVMD].virt_ptr,
 		&ioctl_payload->func_specific,
 		ioctl_payload->wr_length);
@@ -4779,7 +4743,8 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info=
 *pm8001_ha,
 	default:
 		break;
 	}
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req,
+
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &nvmd_req,
 			sizeof(nvmd_req), 0);
 	if (rc) {
 		kfree(fw_control_context);
@@ -4800,12 +4765,9 @@ pm8001_chip_fw_flash_update_build(struct pm8001_hb=
a_info *pm8001_ha,
 {
 	struct fw_flash_Update_req payload;
 	struct fw_flash_updata_info *info;
-	struct inbound_queue_table *circularQ;
-	int ret;
 	u32 opc =3D OPC_INB_FW_FLASH_UPDATE;
=20
 	memset(&payload, 0, sizeof(struct fw_flash_Update_req));
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	info =3D fw_flash_updata_info;
 	payload.tag =3D cpu_to_le32(tag);
 	payload.cur_image_len =3D cpu_to_le32(info->cur_image_len);
@@ -4816,9 +4778,9 @@ pm8001_chip_fw_flash_update_build(struct pm8001_hba=
_info *pm8001_ha,
 		cpu_to_le32(lower_32_bits(le64_to_cpu(info->sgl.addr)));
 	payload.sgl_addr_hi =3D
 		cpu_to_le32(upper_32_bits(le64_to_cpu(info->sgl.addr)));
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
+				    sizeof(payload), 0);
 }
=20
 int
@@ -4953,7 +4915,6 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_inf=
o *pm8001_ha,
 	struct pm8001_device *pm8001_dev, u32 state)
 {
 	struct set_dev_state_req payload;
-	struct inbound_queue_table *circularQ;
 	struct pm8001_ccb_info *ccb;
 	int rc;
 	u32 opc =3D OPC_INB_SET_DEVICE_STATE;
@@ -4964,13 +4925,12 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 	if (!ccb)
 		return -SAS_QUEUE_FULL;
=20
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(ccb->ccb_tag);
 	payload.device_id =3D cpu_to_le32(pm8001_dev->device_id);
 	payload.nds =3D cpu_to_le32(state);
=20
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
+				  sizeof(payload), 0);
 	if (rc)
 		pm8001_ccb_free(pm8001_ha, ccb);
=20
@@ -4981,7 +4941,6 @@ static int
 pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
 {
 	struct sas_re_initialization_req payload;
-	struct inbound_queue_table *circularQ;
 	struct pm8001_ccb_info *ccb;
 	int rc;
 	u32 opc =3D OPC_INB_SAS_RE_INITIALIZE;
@@ -4992,14 +4951,13 @@ pm8001_chip_sas_re_initialization(struct pm8001_h=
ba_info *pm8001_ha)
 	if (!ccb)
 		return -SAS_QUEUE_FULL;
=20
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(ccb->ccb_tag);
 	payload.SSAHOLT =3D cpu_to_le32(0xd << 25);
 	payload.sata_hol_tmo =3D cpu_to_le32(80);
 	payload.open_reject_cmdretries_data_retries =3D cpu_to_le32(0xff00ff);
=20
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
+				  sizeof(payload), 0);
 	if (rc)
 		pm8001_ccb_free(pm8001_ha, ccb);
=20
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm800=
1_sas.h
index 824ada7f6a3f..aec4572906cf 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -668,8 +668,7 @@ int pm8001_mem_alloc(struct pci_dev *pdev, void **vir=
t_addr,
=20
 void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha);
 int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
-			struct inbound_queue_table *circularQ,
-			u32 opCode, void *payload, size_t nb,
+			u32 q_index, u32 opCode, void *payload, size_t nb,
 			u32 responseQueue);
 int pm8001_mpi_msg_free_get(struct inbound_queue_table *circularQ,
 				u16 messageSize, void **messagePtr);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 5a65d4406c94..c25d2c435f6a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1182,7 +1182,6 @@ int
 pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
 {
 	struct set_ctrl_cfg_req payload;
-	struct inbound_queue_table *circularQ;
 	int rc;
 	u32 tag;
 	u32 opc =3D OPC_INB_SET_CONTROLLER_CONFIG;
@@ -1193,7 +1192,6 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *p=
m8001_ha)
 	if (rc)
 		return rc;
=20
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
=20
 	if (IS_SPCV_12G(pm8001_ha->pdev))
@@ -1211,7 +1209,7 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *p=
m8001_ha)
 		   "Setting up thermal config. cfg_pg 0 0x%x cfg_pg 1 0x%x\n",
 		   payload.cfg_pg[0], payload.cfg_pg[1]);
=20
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
 			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
@@ -1228,7 +1226,6 @@ static int
 pm80xx_set_sas_protocol_timer_config(struct pm8001_hba_info *pm8001_ha)
 {
 	struct set_ctrl_cfg_req payload;
-	struct inbound_queue_table *circularQ;
 	SASProtocolTimerConfig_t SASConfigPage;
 	int rc;
 	u32 tag;
@@ -1238,11 +1235,9 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001=
_hba_info *pm8001_ha)
 	memset(&SASConfigPage, 0, sizeof(SASProtocolTimerConfig_t));
=20
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-
 	if (rc)
 		return rc;
=20
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
=20
 	SASConfigPage.pageCode =3D cpu_to_le32(SAS_PROTOCOL_TIMER_CONFIG_PAGE);
@@ -1284,7 +1279,7 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_=
hba_info *pm8001_ha)
 	memcpy(&payload.cfg_pg, &SASConfigPage,
 			 sizeof(SASProtocolTimerConfig_t));
=20
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
 			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
@@ -1390,7 +1385,6 @@ pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8=
001_ha)
 static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
 {
 	struct kek_mgmt_req payload;
-	struct inbound_queue_table *circularQ;
 	int rc;
 	u32 tag;
 	u32 opc =3D OPC_INB_KEK_MANAGEMENT;
@@ -1400,7 +1394,6 @@ static int pm80xx_encrypt_update(struct pm8001_hba_=
info *pm8001_ha)
 	if (rc)
 		return rc;
=20
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
 	/* Currently only one key is used. New KEK index is 1.
 	 * Current KEK index is 1. Store KEK to NVRAM is 1.
@@ -1413,7 +1406,7 @@ static int pm80xx_encrypt_update(struct pm8001_hba_=
info *pm8001_ha)
 		   "Saving Encryption info to flash. payload 0x%x\n",
 		   le32_to_cpu(payload.new_curidx_ksop));
=20
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
 			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
@@ -1770,7 +1763,6 @@ static void pm80xx_send_abort_all(struct pm8001_hba=
_info *pm8001_ha,
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task =3D NULL;
 	struct task_abort_req task_abort;
-	struct inbound_queue_table *circularQ;
 	u32 opc =3D OPC_INB_SATA_ABORT;
 	int ret;
=20
@@ -1794,15 +1786,13 @@ static void pm80xx_send_abort_all(struct pm8001_h=
ba_info *pm8001_ha,
 		return;
 	}
=20
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
-
 	memset(&task_abort, 0, sizeof(task_abort));
 	task_abort.abort_all =3D cpu_to_le32(1);
 	task_abort.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
 	task_abort.tag =3D cpu_to_le32(ccb->ccb_tag);
=20
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
-			sizeof(task_abort), 0);
+	ret =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &task_abort,
+				   sizeof(task_abort), 0);
 	pm8001_dbg(pm8001_ha, FAIL, "Executing abort task end\n");
 	if (ret) {
 		sas_free_task(task);
@@ -1819,11 +1809,9 @@ static void pm80xx_send_read_log(struct pm8001_hba=
_info *pm8001_ha,
 	struct sas_task *task =3D NULL;
 	struct host_to_dev_fis fis;
 	struct domain_device *dev;
-	struct inbound_queue_table *circularQ;
 	u32 opc =3D OPC_INB_SATA_HOST_OPSTART;
=20
 	task =3D sas_alloc_slow_task(GFP_ATOMIC);
-
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task !!!\n");
 		return;
@@ -1856,7 +1844,6 @@ static void pm80xx_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
 	pm8001_ha_dev->id |=3D NCQ_2ND_RLE_FLAG;
=20
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
 	/* construct read log FIS */
 	memset(&fis, 0, sizeof(struct host_to_dev_fis));
@@ -1871,8 +1858,8 @@ static void pm80xx_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
 	sata_cmd.ncqtag_atap_dir_m_dad =3D cpu_to_le32(((0x1 << 7) | (0x5 << 9)=
));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
=20
-	res =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
-			sizeof(sata_cmd), 0);
+	res =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &sata_cmd,
+				   sizeof(sata_cmd), 0);
 	pm8001_dbg(pm8001_ha, FAIL, "Executing read log end\n");
 	if (res) {
 		sas_free_task(task);
@@ -3234,17 +3221,15 @@ static void pm80xx_hw_event_ack_req(struct pm8001=
_hba_info *pm8001_ha,
 	struct hw_event_ack_req	 payload;
 	u32 opc =3D OPC_INB_SAS_HW_EVENT_ACK;
=20
-	struct inbound_queue_table *circularQ;
-
 	memset((u8 *)&payload, 0, sizeof(payload));
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[Qnum];
 	payload.tag =3D cpu_to_le32(1);
 	payload.phyid_sea_portid =3D cpu_to_le32(((SEA & 0xFFFF) << 8) |
 		((phyId & 0xFF) << 24) | (port_id & 0xFF));
 	payload.param0 =3D cpu_to_le32(param0);
 	payload.param1 =3D cpu_to_le32(param1);
-	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+
+	pm8001_mpi_build_cmd(pm8001_ha, Qnum, opc, &payload,
+			     sizeof(payload), 0);
 }
=20
 static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
@@ -4211,7 +4196,6 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_in=
fo *pm8001_ha,
 	u32 req_len, resp_len;
 	struct smp_req smp_cmd;
 	u32 opc;
-	struct inbound_queue_table *circularQ;
 	u32 i, length;
 	u8 *payload;
 	u8 *to;
@@ -4240,7 +4224,6 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_in=
fo *pm8001_ha,
 	}
=20
 	opc =3D OPC_INB_SMP_REQUEST;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	smp_cmd.tag =3D cpu_to_le32(ccb->ccb_tag);
=20
 	length =3D sg_req->length;
@@ -4308,8 +4291,8 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_in=
fo *pm8001_ha,
 	kunmap_atomic(to);
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag,
 				&smp_cmd, pm8001_ha->smp_exp_mode, length);
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &smp_cmd,
-			sizeof(smp_cmd), 0);
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &smp_cmd,
+				  sizeof(smp_cmd), 0);
 	if (rc)
 		goto err_out_2;
 	return 0;
@@ -4369,10 +4352,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hb=
a_info *pm8001_ha,
 	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;
 	struct ssp_ini_io_start_req ssp_cmd;
 	u32 tag =3D ccb->ccb_tag;
-	int ret;
 	u64 phys_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
-	struct inbound_queue_table *circularQ;
 	u32 q_index, cpu_id;
 	u32 opc =3D OPC_INB_SSPINIIOSTART;
=20
@@ -4396,7 +4377,6 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 		       task->ssp_task.cmd->cmd_len);
 	cpu_id =3D smp_processor_id();
 	q_index =3D (u32) (cpu_id) % (pm8001_ha->max_q_num);
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[q_index];
=20
 	/* Check if encryption is set */
 	if (pm8001_ha->chip->encrypt &&
@@ -4513,9 +4493,9 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 			ssp_cmd.esgl =3D 0;
 		}
 	}
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
-			&ssp_cmd, sizeof(ssp_cmd), q_index);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, q_index, opc, &ssp_cmd,
+				    sizeof(ssp_cmd), q_index);
 }
=20
 static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
@@ -4526,7 +4506,6 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 	struct pm8001_device *pm8001_ha_dev =3D dev->lldd_dev;
 	struct ata_queued_cmd *qc =3D task->uldd_task;
 	u32 tag =3D ccb->ccb_tag;
-	int ret;
 	u32 q_index, cpu_id;
 	struct sata_start_req sata_cmd;
 	u32 hdr_tag, ncg_tag =3D 0;
@@ -4534,13 +4513,11 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
 	u32 end_addr_high, end_addr_low;
 	u32 ATAP =3D 0x0;
 	u32 dir;
-	struct inbound_queue_table *circularQ;
 	unsigned long flags;
 	u32 opc =3D OPC_INB_SATA_HOST_OPSTART;
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
 	cpu_id =3D smp_processor_id();
 	q_index =3D (u32) (cpu_id) % (pm8001_ha->max_q_num);
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[q_index];
=20
 	if (task->data_dir =3D=3D DMA_NONE && !task->ata_task.use_ncq) {
 		ATAP =3D 0x04; /* no data*/
@@ -4755,9 +4732,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 				ccb->ccb_tag, opc,
 				qc ? qc->tf.command : 0, // ata opcode
 				ccb->device ? atomic_read(&ccb->device->running_req) : 0);
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
-			&sata_cmd, sizeof(sata_cmd), q_index);
-	return ret;
+	return pm8001_mpi_build_cmd(pm8001_ha, q_index, opc, &sata_cmd,
+				    sizeof(sata_cmd), q_index);
 }
=20
 /**
@@ -4769,11 +4745,9 @@ static int
 pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 {
 	struct phy_start_req payload;
-	struct inbound_queue_table *circularQ;
-	int ret;
 	u32 tag =3D 0x01;
 	u32 opcode =3D OPC_INB_PHYSTART;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
+
 	memset(&payload, 0, sizeof(payload));
 	payload.tag =3D cpu_to_le32(tag);
=20
@@ -4795,9 +4769,9 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *p=
m8001_ha, u8 phy_id)
 	memcpy(payload.sas_identify.sas_addr,
 	  &pm8001_ha->sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id =3D phy_id;
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
-			sizeof(payload), 0);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+				    sizeof(payload), 0);
 }
=20
 /**
@@ -4809,17 +4783,15 @@ static int pm80xx_chip_phy_stop_req(struct pm8001=
_hba_info *pm8001_ha,
 	u8 phy_id)
 {
 	struct phy_stop_req payload;
-	struct inbound_queue_table *circularQ;
-	int ret;
 	u32 tag =3D 0x01;
 	u32 opcode =3D OPC_INB_PHYSTOP;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
+
 	memset(&payload, 0, sizeof(payload));
 	payload.tag =3D cpu_to_le32(tag);
 	payload.phy_id =3D cpu_to_le32(phy_id);
-	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
-			sizeof(payload), 0);
-	return ret;
+
+	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+				    sizeof(payload), 0);
 }
=20
 /*
@@ -4831,7 +4803,6 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
 	struct reg_dev_req payload;
 	u32	opc;
 	u32 stp_sspsmp_sata =3D 0x4;
-	struct inbound_queue_table *circularQ;
 	u32 linkrate, phy_id;
 	int rc;
 	struct pm8001_ccb_info *ccb;
@@ -4841,7 +4812,6 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
 	struct domain_device *dev =3D pm8001_dev->sas_device;
 	struct domain_device *parent_dev =3D dev->parent;
 	struct pm8001_port *port =3D dev->port->lldd_port;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
 	memset(&payload, 0, sizeof(payload));
 	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, NULL);
@@ -4882,7 +4852,7 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
 	memcpy(payload.sas_addr, pm8001_dev->sas_device->sas_addr,
 		SAS_ADDR_SIZE);
=20
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
 			sizeof(payload), 0);
 	if (rc)
 		pm8001_ccb_free(pm8001_ha, ccb);
@@ -4902,18 +4872,18 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_=
hba_info *pm8001_ha,
 	u32 tag;
 	int rc;
 	struct local_phy_ctl_req payload;
-	struct inbound_queue_table *circularQ;
 	u32 opc =3D OPC_INB_LOCAL_PHY_CONTROL;
+
 	memset(&payload, 0, sizeof(payload));
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc)
 		return rc;
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
+
 	payload.tag =3D cpu_to_le32(tag);
 	payload.phyop_phyid =3D
 		cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
=20
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
 				  sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
@@ -4959,7 +4929,6 @@ static void mpi_set_phy_profile_req(struct pm8001_h=
ba_info *pm8001_ha,
 	u32 tag, i, j =3D 0;
 	int rc;
 	struct set_phy_profile_req payload;
-	struct inbound_queue_table *circularQ;
 	u32 opc =3D OPC_INB_SET_PHY_PROFILE;
=20
 	memset(&payload, 0, sizeof(payload));
@@ -4969,7 +4938,6 @@ static void mpi_set_phy_profile_req(struct pm8001_h=
ba_info *pm8001_ha,
 		return;
 	}
=20
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
 	payload.ppc_phyid =3D
 		cpu_to_le32(((operation & 0xF) << 8) | (phyid  & 0xFF));
@@ -4980,8 +4948,8 @@ static void mpi_set_phy_profile_req(struct pm8001_h=
ba_info *pm8001_ha,
 		payload.reserved[j] =3D cpu_to_le32(*((u32 *)buf + i));
 		j++;
 	}
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
+				  sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
 }
@@ -5005,7 +4973,6 @@ void pm8001_set_phy_profile_single(struct pm8001_hb=
a_info *pm8001_ha,
 	u32 tag, opc;
 	int rc, i;
 	struct set_phy_profile_req payload;
-	struct inbound_queue_table *circularQ;
=20
 	memset(&payload, 0, sizeof(payload));
=20
@@ -5015,7 +4982,6 @@ void pm8001_set_phy_profile_single(struct pm8001_hb=
a_info *pm8001_ha,
 		return;
 	}
=20
-	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	opc =3D OPC_INB_SET_PHY_PROFILE;
=20
 	payload.tag =3D cpu_to_le32(tag);
@@ -5026,7 +4992,7 @@ void pm8001_set_phy_profile_single(struct pm8001_hb=
a_info *pm8001_ha,
 	for (i =3D 0; i < length; i++)
 		payload.reserved[i] =3D cpu_to_le32(*(buf + i));
=20
-	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
 			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
--=20
2.34.1

