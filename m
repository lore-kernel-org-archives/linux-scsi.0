Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C9AC48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 09:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6940361057
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 09:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhFPJ66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 05:58:58 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55570 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231686AbhFPJ65 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Jun 2021 05:58:57 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5548841283;
        Wed, 16 Jun 2021 09:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1623837409; x=
        1625651810; bh=+zQOLcrGUh4fPJOW6zKFZChRo/zCRAvrw4TJ0W0CTQU=; b=U
        8dbxdMW7reqPU2skEIzuPG3J3yRrsbjBc9YvNl4e7iKH08p1AieG3RgA8oprQxDf
        ecPO53CZ8y1kfEk1Ao5h+o+k3qdDSBG5EWAyp0VGMlgweMzafB+tYkaoRRW2IM1W
        cQFnpTDpN929eJmv//6E8C9mPCWeacmEhQ+kGMrmtM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tgsoqwpgQWGh; Wed, 16 Jun 2021 12:56:49 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0DCBA41278;
        Wed, 16 Jun 2021 12:56:48 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.174) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 16 Jun 2021 12:56:47 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH] scsi: target: fix prot handling in WRITE SAME 32
Date:   Wed, 16 Jun 2021 12:56:32 +0300
Message-ID: <20210616095632.16775-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.174]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

WRITE SAME 32 command handling reads WRPROTECT at the wrong offset
in 1st octet instead of 10th octet.

Fixes: afd73f1b60fc ("target: Perform PROTECT sanity checks for WRITE_SAME")
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_sbc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index f7c527a826fd..309aae33c358 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -286,7 +286,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	unsigned int sectors = sbc_get_write_same_sectors(cmd);
 	sense_reason_t ret;
 
-	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
+	if ((flags[1] & 0x04) || (flags[1] & 0x02)) {
 		pr_err("WRITE_SAME PBDATA and LBDATA"
 			" bits not supported for Block Discard"
 			" Emulation\n");
@@ -308,7 +308,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	}
 
 	/* We always have ANC_SUP == 0 so setting ANCHOR is always an error */
-	if (flags[0] & 0x10) {
+	if (flags[1] & 0x10) {
 		pr_warn("WRITE SAME with ANCHOR not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -316,7 +316,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
 	 * translated into block discard requests within backend code.
 	 */
-	if (flags[0] & 0x08) {
+	if (flags[1] & 0x08) {
 		if (!ops->execute_unmap)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
@@ -331,7 +331,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	if (!ops->execute_write_same)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 
-	ret = sbc_check_prot(dev, cmd, &cmd->t_task_cdb[0], sectors, true);
+	ret = sbc_check_prot(dev, cmd, flags, sectors, true);
 	if (ret)
 		return ret;
 
@@ -980,7 +980,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			size = sbc_get_size(cmd, 1);
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 
-			ret = sbc_setup_write_same(cmd, &cdb[10], ops);
+			ret = sbc_setup_write_same(cmd, &cdb[9], ops);
 			if (ret)
 				return ret;
 			break;
@@ -1079,7 +1079,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		size = sbc_get_size(cmd, 1);
 		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
 
-		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
+		ret = sbc_setup_write_same(cmd, cdb, ops);
 		if (ret)
 			return ret;
 		break;
-- 
2.25.1

