Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926C7C433E5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E1CE61A17
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbhCXQyg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:54:36 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35713 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbhCXQyc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 12:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616604872; x=1648140872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=LNl35VTJtEBNoBz192iHt+t3NKyIkV3J4HMxtpymTpE=;
  b=gTwjMD0mFIwrhPjoTNg4i6rLLHdklzFMGNVxO8TcxJ5XClCneqd2RgZB
   heDWpVPbwG6HpHvv5J9caHcGygsyIij7pteRbyPr4q1g7/SMiK47+aI2Q
   lOdC9CBqjfgXo4UDe3C0qdYt4B3qE/bOuB8Hks0PYwlmknGstkZkOMwlN
   atduyfGMK56peenj7FfUnrUjxI6HLTvZjlFQ4rvTNC3fSP7R6zC6NNl+U
   VhBhjKQfeqCGyxaOgMfvnpkyktyymQl5GCmFXKmS8v5bZjdIuscC6hE0j
   8tzPVaW5GiyiLbqi2UNCDZo4mEV02e0ioyZU2G5QFbi+hM6rUGHkgEyOm
   A==;
IronPort-SDR: m4f7q7LEdNmWugWxD1J94nMyVyeWa9YnwJHYoklRhAumhsp3ByewDAo97UOE5E2cJy8AC4qNT3
 bYeANriWPg+XctSome23TVglKaYUlft5bIU+Ps6PfxnC92B3oGSAK2RzL0/wGJQu/RA42vvQ81
 BYv6Epyp6kCgKDhrcMBEnAz9Gt5z26XUe5ZmloN7AEk04o8YndN4yfg7rOU+vf5vlsxVVJPjmF
 VQAKQXOXj5jap7HmN3qTyPbYdm9/XUMjYQUSaOPy1E5owwlmznQL0gi4txuJKVmWsc6v/tIhrO
 REM=
X-IronPort-AV: E=Sophos;i="5.81,275,1610434800"; 
   d="scan'208";a="120297812"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2021 09:54:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 09:54:31 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 24 Mar 2021 09:54:30 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 7/7] pm80xx: remove global lock from outbound queue processing
Date:   Wed, 24 Mar 2021 22:33:57 +0530
Message-ID: <20210324170357.9765-8-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210324170357.9765-1-Viswas.G@microchip.com>
References: <20210324170357.9765-1-Viswas.G@microchip.com>
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

