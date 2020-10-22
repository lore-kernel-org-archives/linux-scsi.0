Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219C8C56201
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 17:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B678B24650
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 17:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="k72lWWrK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900101AbgJVR3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 13:29:35 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:35592 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2899798AbgJVR3f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Oct 2020 13:29:35 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2020 13:29:34 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id CA66541383;
        Thu, 22 Oct 2020 17:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1603387241; x=1605201642; bh=US3Q9GEiSZiER9sFlOyJzTMp2kVYp3dzXJQ
        2iSrkMk8=; b=k72lWWrKGbzIPgl1dhqZQtUtGPaHucBwLMYYALKVFI9jlQbblPc
        I1r0Oeef9+q80vVc8Qw+Lf8l/dvEyLXRL1uaQC8ZiBlVdQra13N6zyXUcgTLJ1n7
        zznqEqNtdao77ebRwiHY95+BcCEWHj2gvDDGrRrUs9sTEypaKxZkfXVA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bn8tqel3mrwS; Thu, 22 Oct 2020 20:20:41 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7B1F6413A7;
        Thu, 22 Oct 2020 20:20:40 +0300 (MSK)
Received: from localhost (172.17.204.63) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 22
 Oct 2020 20:20:39 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Date:   Thu, 22 Oct 2020 20:20:11 +0300
Message-ID: <20201022172011.42367-4-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201022172011.42367-1-a.kovaleva@yadro.com>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.63]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to FCP-4 (9.4.2):

  If the command requested that data beyond the length specified by the
  FCP_DL field be transferred, then the device server shall set the
  FCP_RESID_OVER bit (see 9.5.8) to one in the FCP_RSP IU and:

  a) process the command normally except that data beyond the FCP_DL
  count shall not be requested or transferred;

  b) transfer no data and return CHECK CONDITION status with the sense
  key set to ILLEGAL REQUEST and the additional sense code set to INVALID
  FIELD IN COMMAND INFORMATION UNIT; or

  c) may transfer data and return CHECK CONDITION status with the sense
  key set to ABORTED COMMAND and the additional sense code set to
  INVALID FIELD IN COMMAND INFORMATION UNIT.

TCM follows b) and transfers no data for residual writes but returns
INVALID FIELD IN CDB instead of INVALID FIELD IN COMMAND INFORMATION
UNIT.

Change the ASCQ to INVALID FIELD IN COMMAND INFORMATION UNIT to meet the
standart.

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_transport.c | 8 +++++++-
 include/target/target_core_base.h      | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8cb3012721d8..b225dab4deb9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1331,7 +1331,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 			if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
 				pr_err_ratelimited("Rejecting underflow/overflow"
 						   " for WRITE data CDB\n");
-				return TCM_INVALID_CDB_FIELD;
+				return TCM_INVALID_FIELD_IN_COMMAND_IU;
 			}
 			/*
 			 * Some fabric drivers like iscsi-target still expect to
@@ -1904,6 +1904,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE:
 	case TCM_TOO_MANY_SEGMENT_DESCS:
 	case TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE:
+	case TCM_INVALID_FIELD_IN_COMMAND_IU:
 		break;
 	case TCM_OUT_OF_RESOURCES:
 		cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
@@ -3240,6 +3241,11 @@ static const struct sense_info sense_info_table[] = {
 		.asc = 0x55,
 		.ascq = 0x04, /* INSUFFICIENT REGISTRATION RESOURCES */
 	},
+	[TCM_INVALID_FIELD_IN_COMMAND_IU] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x0e,
+		.ascq = 0x03, /* INVALID FIELD IN COMMAND INFORMATION UNIT */
+	},
 };
 
 /**
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 549947d407cf..01296d62ba5e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -187,6 +187,7 @@ enum tcm_sense_reason_table {
 	TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE	= R(0x1c),
 	TCM_INSUFFICIENT_REGISTRATION_RESOURCES	= R(0x1d),
 	TCM_LUN_BUSY				= R(0x1e),
+	TCM_INVALID_FIELD_IN_COMMAND_IU         = R(0x1f),
 #undef R
 };
 
-- 
2.24.3 (Apple Git-128)

