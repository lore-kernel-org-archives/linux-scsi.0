Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0ADC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7346F613B0
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhDOKY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:24:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46140 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbhDOKY5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 06:24:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618482274; x=1650018274;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=LNl35VTJtEBNoBz192iHt+t3NKyIkV3J4HMxtpymTpE=;
  b=oSZ9OlGSYkRhHMRrsIw79JhyXQiPWrNkDGJWGHMo/9Rar4cUq26ELv5n
   18LbOVa/nMGMOJ93gpk/Pbi95ZC4TTx17ZoLJ2pLrSkTu1rxfSBTSVyFG
   1sqqOyFud3Z0R8YFGLfOdJTVbB+CEnMwzXeQR4iAyM1dvRylYjozQ6R6o
   6aZdNdbOU2TR0zz/SGAjH+pAZdzAUMdcKx4X3dmU8BVKDw5xrVxnPTP/N
   CQhGjnn/kpeM606Mko+ZVcSEB73tIk9XXI6q9pfO8HdqNY1W/SLnVadsg
   MED1PRVrGXHyAXBtf4Ls2RFXjLIjG2W0EjvvpjA10X6JV1zRX2EruBf0C
   Q==;
IronPort-SDR: +Xdn+T7ViZiWWEg+BjqnpYTJd9NPPcEpqCul4Z7LXCRxiIPoq10m8KflyYNQpsDKyNWu181zH0
 urdwXYV3yASXsLgLOmWWxQLGYrjL2Ey8ApLNZFCVclwFg6OMdKl0pVp161SaHQhX22i06gzDdX
 De+3FTFv/qXWZv2NjmGvyJA1mnTxqeOZLHkE0FM+Cefq+VhFvV3Z3HWDFO9DpI7gX3eLNOBZvE
 TRhvVMqYJX4Mi9wmaH06yjM1U7Z10mfPPrm5yweXEIZN1HwtYwBoIKK/glVbW6C+8nQUnRWmEc
 r50=
X-IronPort-AV: E=Sophos;i="5.82,223,1613458800"; 
   d="scan'208";a="51231528"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 03:24:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 03:24:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 03:24:33 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 8/8] pm80xx: remove global lock from outbound queue processing
Date:   Thu, 15 Apr 2021 16:03:52 +0530
Message-ID: <20210415103352.3580-9-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210415103352.3580-1-Viswas.G@microchip.com>
References: <20210415103352.3580-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduced spin lock for outbound queue. With this, driver need not
acquire hba global lock for outbound queue processing.

Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 9 ++++++---
 drivers/scsi/pm8001/pm8001_sas.h  | 1 +
 drivers/scsi/pm8001/pm80xx_hwi.c  | 4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index bd626ef876da..a3c8fb9a885f 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -267,7 +267,8 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 {
 	int i, count = 0, rc = 0;
 	u32 ci_offset, ib_offset, ob_offset, pi_offset;
-	struct inbound_queue_table *circularQ;
+	struct inbound_queue_table *ibq;
+	struct outbound_queue_table *obq;
 
 	spin_lock_init(&pm8001_ha->lock);
 	spin_lock_init(&pm8001_ha->bitmap_lock);
@@ -315,8 +316,8 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	pm8001_ha->memoryMap.region[IOP].alignment = 32;
 
 	for (i = 0; i < count; i++) {
-		circularQ = &pm8001_ha->inbnd_q_tbl[i];
-		spin_lock_init(&circularQ->iq_lock);
+		ibq = &pm8001_ha->inbnd_q_tbl[i];
+		spin_lock_init(&ibq->iq_lock);
 		/* MPI Memory region 3 for consumer Index of inbound queues */
 		pm8001_ha->memoryMap.region[ci_offset+i].num_elements = 1;
 		pm8001_ha->memoryMap.region[ci_offset+i].element_size = 4;
@@ -345,6 +346,8 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	}
 
 	for (i = 0; i < count; i++) {
+		obq = &pm8001_ha->outbnd_q_tbl[i];
+		spin_lock_init(&obq->oq_lock);
 		/* MPI Memory region 4 for producer Index of outbound queues */
 		pm8001_ha->memoryMap.region[pi_offset+i].num_elements = 1;
 		pm8001_ha->memoryMap.region[pi_offset+i].element_size = 4;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 36cd37c8c29a..f835557ee354 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -457,6 +457,7 @@ struct outbound_queue_table {
 	u32			dinterrup_to_pci_offset;
 	__le32			producer_index;
 	u32			consumer_idx;
+	spinlock_t		oq_lock;
 };
 struct pm8001_hba_memspace {
 	void __iomem  		*memvirtaddr;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 0f2c57e054ac..f1276baebe1d 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4133,8 +4133,8 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 			return ret;
 		}
 	}
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
 	circularQ = &pm8001_ha->outbnd_q_tbl[vec];
+	spin_lock_irqsave(&circularQ->oq_lock, flags);
 	do {
 		/* spurious interrupt during setup if kexec-ing and
 		 * driver doing a doorbell access w/ the pre-kexec oq
@@ -4160,7 +4160,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 				break;
 		}
 	} while (1);
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&circularQ->oq_lock, flags);
 	return ret;
 }
 
-- 
2.16.3

