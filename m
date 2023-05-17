Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B16DC7EE2A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 14:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjEQOQB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 10:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjEQOP6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 10:15:58 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B833E61BE;
        Wed, 17 May 2023 07:15:56 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 234B034272D;
        Wed, 17 May 2023 17:15:55 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=azHwwpS+mv/wh7w6sx
        rtW3eoc7WWmsUJkvMAPTkVIJA=; b=MT4H6+F0i3qth+Ujt6Q6WYaOjlnaRF79lH
        WF6KgWm174toYK6R+uClfEAQ1WNSNXpSs8JOJ0+Xe3Rexq0+jspdQrEEvBP9C572
        IRhd4K5uUkxTnwgshG/kACztcE1h9ByxQnxPbJ0ALFhRzdJ2jop2qAaA65aIYUFc
        h8/hb2h+8=
Received: from T-EXCH-07.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 19D61342727;
        Wed, 17 May 2023 17:15:55 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-07.corp.yadro.com (172.17.11.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 17 May 2023 17:15:54 +0300
Received: from yadro.com (172.22.1.19) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 17 May
 2023 17:15:52 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>,
        "Dmitry Bogdanov" <d.bogdanov@yadro.com>
Subject: [PATCH 1/2] scsi: target: core: Add sense reason for space allocation errors
Date:   Wed, 17 May 2023 17:15:36 +0300
Message-ID: <20230517141537.80936-2-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517141537.80936-1-k.shelekhin@yadro.com>
References: <20230517141537.80936-1-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.22.1.19]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
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
index 86adff2a86ed..9b41d2d78e98 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2072,6 +2072,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_ALUA_TG_PT_UNAVAILABLE:
 	case TCM_ALUA_STATE_TRANSITION:
 	case TCM_ALUA_OFFLINE:
+	case TCM_SPACE_ALLOCATION_FAILED:
 		break;
 	case TCM_OUT_OF_RESOURCES:
 		cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
@@ -3474,6 +3475,11 @@ static const struct sense_detail sense_detail_table[] = {
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
index 5f8e96f1516f..aac475a9184e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -194,6 +194,7 @@ enum tcm_sense_reason_table {
 	TCM_ALUA_TG_PT_UNAVAILABLE		= R(0x21),
 	TCM_ALUA_STATE_TRANSITION		= R(0x22),
 	TCM_ALUA_OFFLINE			= R(0x23),
+	TCM_SPACE_ALLOCATION_FAILED		= R(0x24),
 #undef R
 };
 
-- 
2.40.1


