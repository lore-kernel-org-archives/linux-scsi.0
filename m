Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F0CC2FC27
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 13:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351345AbjHQNMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351402AbjHQNMf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 09:12:35 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDCB35BE
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 06:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692277931; x=1723813931;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LIrHF8Ca2xczEuweCBI0sDnC3kg0eMCQSoa62Z9LCUM=;
  b=RSPSkXpRTcZl55GGaN14awPU9bQXA5I9/cnvrefISKcn/hz4ET7vGlUB
   1TWqe+pMwtZE/uUnYGD5HKj7dsyoBZsAgg5NIzDXqdYyYRkzyj/c2+rbK
   mqR+/23osaT+3FgB+jZyawuy8KXmViCNqCE8V2icPnh89K7VuQAyOJAoC
   Rjzu6d1U6bDwbrNDCq4fXouFGrNFQUSS16lO+6A/2JvV6FuteNw8+fq9x
   IOVWSsvJafO6I0oRdU3TWMsu4c5CtdlOzTgySDYYzbN+sgcsbGr4o4P2B
   mXYxHFZA4LipfZs7SQXJttPmm1zTsnLngwwdcOx5+WjKzOm2tBzIAF15r
   w==;
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="225883243"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2023 06:11:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 17 Aug 2023 06:10:30 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 17 Aug 2023 06:10:29 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 3/9] smartpqi: refactor rename MACRO to clarify purpose
Date:   Thu, 17 Aug 2023 08:12:26 -0500
Message-ID: <20230817131232.86754-4-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0.rc2
In-Reply-To: <20230817131232.86754-1-don.brace@microchip.com>
References: <20230817131232.86754-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Rename SOP_RC_INCORRECT_LOGICAL_UNIT to SOP_TMF_INCORRECT_LOGICAL_UNIT
to clarify the intended purpose.

Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      | 2 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index e560d99efa95..041940183516 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -710,7 +710,7 @@ typedef u32 pqi_index_t;
 #define SOP_TMF_COMPLETE		0x0
 #define SOP_TMF_REJECTED		0x4
 #define SOP_TMF_FUNCTION_SUCCEEDED	0x8
-#define SOP_RC_INCORRECT_LOGICAL_UNIT	0x9
+#define SOP_TMF_INCORRECT_LOGICAL_UNIT	0x9
 
 /* additional CDB bytes usage field codes */
 #define SOP_ADDITIONAL_CDB_BYTES_0	0	/* 16-byte CDB */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ec36896eb08e..2d695e7cd83f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3308,7 +3308,7 @@ static int pqi_interpret_task_management_response(struct pqi_ctrl_info *ctrl_inf
 	case SOP_TMF_REJECTED:
 		rc = -EAGAIN;
 		break;
-	case SOP_RC_INCORRECT_LOGICAL_UNIT:
+	case SOP_TMF_INCORRECT_LOGICAL_UNIT:
 		rc = -ENODEV;
 		break;
 	default:
-- 
2.42.0.rc2

