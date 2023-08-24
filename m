Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7518CC6FA8F
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 15:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbjHXP4W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 11:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237576AbjHXP4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 11:56:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82124198E
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692892576; x=1724428576;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PbC3HN7GFpqgtVwhGCHNk6y/pGyw4N5m0jMKDFzI+Tk=;
  b=ks4zg2liU4ZT+uE+6+IYs+5sDE+fkXxiBaTnQYwtApXB9/K8QSUhGq0F
   dg9jNEUUpGuYndY0iGlutcemQ5eRPRgURzCPmzbPCrhd8t+FxiLN7/0O/
   m6WZJVQe3JRW9s1CB8xHwCapbt9anHiOVDQ4mNxhO1a22oGtpnujTMhEM
   2mTa9jdy3v5KTa8oJ8Egn2jFWfr9sLXPRCEEKY5EYPpCMu1N7rFseSK8n
   ukpZMYYhCF0IHc+lhhpNPpBKz+TB8z3RYSzVJWslVlrsB1M7S0G9OUly5
   KvEpzCWD7x5RWttzaPN9DPJ2Gg/Ythhf9l5rmzVxNYuP0XjNXdUzQwAR8
   Q==;
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="1113980"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Aug 2023 08:56:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 24 Aug 2023 08:56:12 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 24 Aug 2023 08:56:12 -0700
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
Subject: [PATCH v2 2/8] smartpqi: refactor rename MACRO to clarify purpose
Date:   Thu, 24 Aug 2023 10:58:06 -0500
Message-ID: <20230824155812.789913-3-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824155812.789913-1-don.brace@microchip.com>
References: <20230824155812.789913-1-don.brace@microchip.com>
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
index 60cdc06ace61..97322ebd77cf 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3358,7 +3358,7 @@ static int pqi_interpret_task_management_response(struct pqi_ctrl_info *ctrl_inf
 	case SOP_TMF_REJECTED:
 		rc = -EAGAIN;
 		break;
-	case SOP_RC_INCORRECT_LOGICAL_UNIT:
+	case SOP_TMF_INCORRECT_LOGICAL_UNIT:
 		rc = -ENODEV;
 		break;
 	default:
-- 
2.42.0

