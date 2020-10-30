Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38F3C00A89
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 05:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6825E22202
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 05:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgJ3F7V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 01:59:21 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:42142 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3F7U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 01:59:20 -0400
IronPort-SDR: ocrNHm4SbJ2IqwXQkhY/j5RtEHJ7cCKva37ZQmsB9khhwMSQRYEcaQMwU03EXHwpn58cwrbj8o
 jPMXWB05RNNVgrgDlGdIWC0IoJLkkaKkBq8UVSE6Ukw1rWIH5hoQh38XAaNOIY9OqYFI7WCpoc
 elfXTPBHvEsKGCQImmzswYjsOdUz7VL+qYBvXhcXAPsBxabLLpj8Bl2n86qTQoSjU16QTK3Tki
 RYROSgbobnVlpCMuAfbi4j7C0iCUtIXuT++WmRlN9wqNmQSw1iKNxcAVt2bsPn/DxFDey1malF
 tQg=
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="91921129"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Oct 2020 22:59:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 22:59:17 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 29 Oct 2020 22:59:17 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <jinpu.wang@cloud.ionos.com>
Subject: [PATCH V2 1/4] pm80xx: make mpi_build_cmd locking consistent
Date:   Fri, 30 Oct 2020 11:39:10 +0530
Message-ID: <20201030060913.14886-2-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201030060913.14886-1-Viswas.G@microchip.com.com>
References: <20201030060913.14886-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: peter chang <dpf@google.com>

Driver submit all internal requests (like abort_task, event
acknowledgment etc.) through inbound queue 0. While submitting those,
driver does not acquire any lock and it may lead to a race when there 
is an IO request coming in CPU0 and submitted through inbound queue 0. 
To avoid this, lock acquisition has been moved to pm8001_mpi_build_cmd().
All command submission will go through this path.

Signed-off-by: peter chang <dpf@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 21 +++++++++++++++------
 drivers/scsi/pm8001/pm80xx_hwi.c |  8 --------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2b7b2954ec31..597d7a096a97 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1356,12 +1356,19 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 {
 	u32 Header = 0, hpriority = 0, bc = 1, category = 0x02;
 	void *pMessage;
-
-	if (pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
-		&pMessage) < 0) {
+	unsigned long flags;
+	int q_index = circularQ - pm8001_ha->inbnd_q_tbl;
+	int rv = -1;
+
+	WARN_ON(q_index >= PM8001_MAX_INB_NUM);
+	spin_lock_irqsave(&circularQ->iq_lock, flags);
+	rv = pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
+			&pMessage);
+	if (rv < 0) {
 		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("No free mpi buffer\n"));
-		return -ENOMEM;
+			      pm8001_printk("No free mpi buffer\n"));
+		rv = -ENOMEM;
+		goto done;
 	}
 
 	if (nb > (pm8001_ha->iomb_size - sizeof(struct mpi_msg_hdr)))
@@ -1384,7 +1391,9 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 		pm8001_printk("INB Q %x OPCODE:%x , UPDATED PI=%d CI=%d\n",
 			responseQueue, opCode, circularQ->producer_idx,
 			circularQ->consumer_index));
-	return 0;
+done:
+	spin_unlock_irqrestore(&circularQ->iq_lock, flags);
+	return rv;
 }
 
 u32 pm8001_mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha, void *pMsg,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 7593f248afb2..5fe50e0effcd 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4281,7 +4281,6 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 	char *preq_dma_addr = NULL;
 	__le64 tmp_addr;
 	u32 i, length;
-	unsigned long flags;
 
 	memset(&smp_cmd, 0, sizeof(smp_cmd));
 	/*
@@ -4377,10 +4376,8 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag,
 				&smp_cmd, pm8001_ha->smp_exp_mode, length);
-	spin_lock_irqsave(&circularQ->iq_lock, flags);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &smp_cmd,
 			sizeof(smp_cmd), 0);
-	spin_unlock_irqrestore(&circularQ->iq_lock, flags);
 	if (rc)
 		goto err_out_2;
 	return 0;
@@ -4444,7 +4441,6 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	u64 phys_addr, start_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	struct inbound_queue_table *circularQ;
-	unsigned long flags;
 	u32 q_index, cpu_id;
 	u32 opc = OPC_INB_SSPINIIOSTART;
 	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
@@ -4582,10 +4578,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 			ssp_cmd.esgl = 0;
 		}
 	}
-	spin_lock_irqsave(&circularQ->iq_lock, flags);
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
 			&ssp_cmd, sizeof(ssp_cmd), q_index);
-	spin_unlock_irqrestore(&circularQ->iq_lock, flags);
 	return ret;
 }
 
@@ -4819,10 +4813,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			}
 		}
 	}
-	spin_lock_irqsave(&circularQ->iq_lock, flags);
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
 			&sata_cmd, sizeof(sata_cmd), q_index);
-	spin_unlock_irqrestore(&circularQ->iq_lock, flags);
 	return ret;
 }
 
-- 
2.16.3

