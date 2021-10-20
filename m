Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF1A3C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 18:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93114610D0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 18:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhJTSpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 14:45:53 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36736 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230454AbhJTSpu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 14:45:50 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A7C6342B32;
        Wed, 20 Oct 2021 18:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1634755413; x=1636569814; bh=nEEAoGoH7zpsQTlmfRGy5u1FPEPCyGq5wh7
        Q6ifnxQk=; b=V72LjiVAWjudbZTjXy4z1zXqxp4pgRz40fDdnRPAlL0igCOEzVI
        eX1VuC1JIMCw2WoFKBcOvqOxpUrZ4QXMT8kYFw/Jb+vtZ78tyDo6P7TCFT8AkCwP
        EwI3CSWuStJ0PaJhdbEOSyCJwSat5uZQbFrk04vE/Ut49UJmWjhts5ao=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 07_yb0DwzFcu; Wed, 20 Oct 2021 21:43:33 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 927D742B2A;
        Wed, 20 Oct 2021 21:43:33 +0300 (MSK)
Received: from yadro.com (10.199.9.171) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 20
 Oct 2021 21:43:32 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 1/2] scsi: target: core: Add sense reason for space allocation errors
Date:   Wed, 20 Oct 2021 21:43:18 +0300
Message-ID: <20211020184319.588002-2-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211020184319.588002-1-k.shelekhin@yadro.com>
References: <20211020184319.588002-1-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.9.171]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to SBC-3 4.7.3.6 this sense reason shall be used in situations
where thin provisioned logical unit cannot satisfy the write request due
to the lack of free blocks.

Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_transport.c | 6 ++++++
 include/target/target_core_base.h      | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 14c6f2bb1b01..d8261bd1cb5c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2025,6 +2025,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_ALUA_TG_PT_UNAVAILABLE:
 	case TCM_ALUA_STATE_TRANSITION:
 	case TCM_ALUA_OFFLINE:
+	case TCM_SPACE_ALLOCATION_FAILED:
 		break;
 	case TCM_OUT_OF_RESOURCES:
 		cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
@@ -3369,6 +3370,11 @@ static const struct sense_detail sense_detail_table[] = {
 		.asc = 0x04,
 		.ascq = ASCQ_04H_ALUA_OFFLINE,
 	},
+	[TCM_SPACE_ALLOCATION_FAILED] = {
+		.key = DATA_PROTECT,
+		.asc = 0x27,
+		.ascq = 0x07, /* SPACE ALLOCATION FAILED WRITE PROTECT */
+	},
 };
 
 /**
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index fb11c7693b25..fe2f1c5bb1b8 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -192,6 +192,7 @@ enum tcm_sense_reason_table {
 	TCM_ALUA_TG_PT_UNAVAILABLE		= R(0x21),
 	TCM_ALUA_STATE_TRANSITION		= R(0x22),
 	TCM_ALUA_OFFLINE			= R(0x23),
+	TCM_SPACE_ALLOCATION_FAILED		= R(0x24),
 #undef R
 };
 
-- 
2.33.0

