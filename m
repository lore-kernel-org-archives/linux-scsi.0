Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B187AECAAD5
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Sep 2022 17:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbiIERkB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Sep 2022 13:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbiIERju (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Sep 2022 13:39:50 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EAA1A072;
        Mon,  5 Sep 2022 10:39:44 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id BD28643B04;
        Mon,  5 Sep 2022 17:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662399580; x=1664213981; bh=+aistd/cBMXI6QQrzHxU069vI
        Rx3DOzXlrt2ObK40Vc=; b=Kmm4SdTXK4vr6vjS2Fbfb+00IcvBMSnTarPBbRQMT
        MK2AIogKYjJmXHNnGR2wsiPutmMRcN37Oflm/EGf+DfChcOipVvg/93WaeNPA6id
        /mCdKbLFapVYKWy5lRCTjKEFQevteUtL3KDXTS5N0a3819tDXid1cA9mMeE0+n6b
        nM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ryNlJqxeCm9M; Mon,  5 Sep 2022 20:39:40 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E35BF43B58;
        Mon,  5 Sep 2022 20:38:49 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 5 Sep 2022 20:38:48 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 5 Sep 2022 20:38:47 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH v2 6/6] scsi: target: core: dynamicaly set dpofua in usage_bits
Date:   Mon, 26 Apr 2021 15:51:48 +0300
Message-ID: <20220905173837.2383-7-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905173837.2383-1-d.bogdanov@yadro.com>
References: <20220905173837.2383-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

libiscsi tests check the support of DPO & FUA bits in usage bits of RSOC
response.
This patch adds support of dynamic usage bits for each opcode.
Set support of DPO & FUA bits in usage_bits of RSOC response depending
on support DPOFUA in the backstore device.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_spc.c  | 34 +++++++++++++++++++++++++++++--
 include/target/target_core_base.h |  2 ++
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 828251163cf0..a97a2f43a061 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1308,6 +1308,22 @@ spc_emulate_testunitready(struct se_cmd *cmd)
 	return 0;
 }
 
+static void set_dpofua_usage_bits(u8 *usage_bits, struct se_device *dev)
+{
+	if (!target_check_fua(dev))
+		usage_bits[1] &= ~0x18;
+	else
+		usage_bits[1] |= 0x18;
+}
+
+static void set_dpofua_usage_bits32(u8 *usage_bits, struct se_device *dev)
+{
+	if (!target_check_fua(dev))
+		usage_bits[10] &= ~0x18;
+	else
+		usage_bits[10] |= 0x18;
+}
+
 static struct target_opcode_descriptor tcm_opcode_read6 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = READ_6,
@@ -1323,6 +1339,7 @@ static struct target_opcode_descriptor tcm_opcode_read10 = {
 	.usage_bits = {READ_10, 0xf8, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.update_usage_bits = set_dpofua_usage_bits,
 };
 
 static struct target_opcode_descriptor tcm_opcode_read12 = {
@@ -1332,6 +1349,7 @@ static struct target_opcode_descriptor tcm_opcode_read12 = {
 	.usage_bits = {READ_12, 0xf8, 0xff, 0xff,
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.update_usage_bits = set_dpofua_usage_bits,
 };
 
 static struct target_opcode_descriptor tcm_opcode_read16 = {
@@ -1342,6 +1360,7 @@ static struct target_opcode_descriptor tcm_opcode_read16 = {
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.update_usage_bits = set_dpofua_usage_bits,
 };
 
 static struct target_opcode_descriptor tcm_opcode_write6 = {
@@ -1359,6 +1378,7 @@ static struct target_opcode_descriptor tcm_opcode_write10 = {
 	.usage_bits = {WRITE_10, 0xf8, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.update_usage_bits = set_dpofua_usage_bits,
 };
 
 static struct target_opcode_descriptor tcm_opcode_write_verify10 = {
@@ -1368,6 +1388,7 @@ static struct target_opcode_descriptor tcm_opcode_write_verify10 = {
 	.usage_bits = {WRITE_VERIFY, 0xf0, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.update_usage_bits = set_dpofua_usage_bits,
 };
 
 static struct target_opcode_descriptor tcm_opcode_write12 = {
@@ -1377,6 +1398,7 @@ static struct target_opcode_descriptor tcm_opcode_write12 = {
 	.usage_bits = {WRITE_12, 0xf8, 0xff, 0xff,
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.update_usage_bits = set_dpofua_usage_bits,
 };
 
 static struct target_opcode_descriptor tcm_opcode_write16 = {
@@ -1387,6 +1409,7 @@ static struct target_opcode_descriptor tcm_opcode_write16 = {
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.update_usage_bits = set_dpofua_usage_bits,
 };
 
 static struct target_opcode_descriptor tcm_opcode_write_verify16 = {
@@ -1397,6 +1420,7 @@ static struct target_opcode_descriptor tcm_opcode_write_verify16 = {
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.update_usage_bits = set_dpofua_usage_bits,
 };
 
 static bool tcm_is_ws_enabled(struct se_cmd *cmd)
@@ -1423,6 +1447,7 @@ static struct target_opcode_descriptor tcm_opcode_write_same32 = {
 		       0x00, 0x00, 0x00, 0x00,
 		       0xff, 0xff, 0xff, 0xff},
 	.enabled = tcm_is_ws_enabled,
+	.update_usage_bits = set_dpofua_usage_bits32,
 };
 
 static bool tcm_is_caw_enabled(struct se_cmd *cmd)
@@ -1441,6 +1466,7 @@ static struct target_opcode_descriptor tcm_opcode_compare_write = {
 		       0xff, 0xff, 0x00, 0x00,
 		       0x00, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
 	.enabled = tcm_is_caw_enabled,
+	.update_usage_bits = set_dpofua_usage_bits,
 };
 
 static struct target_opcode_descriptor tcm_opcode_read_capacity = {
@@ -2027,7 +2053,8 @@ spc_rsoc_encode_command_descriptor(unsigned char *buf, u8 ctdp,
 
 static int
 spc_rsoc_encode_one_command_descriptor(unsigned char *buf, u8 ctdp,
-				       struct target_opcode_descriptor *descr)
+				       struct target_opcode_descriptor *descr,
+				       struct se_device *dev)
 {
 	int td_size = 0;
 
@@ -2039,6 +2066,8 @@ spc_rsoc_encode_one_command_descriptor(unsigned char *buf, u8 ctdp,
 	buf[1] = (ctdp << 7) | SCSI_SUPPORT_FULL;
 	put_unaligned_be16(descr->cdb_size, &buf[2]);
 	memcpy(&buf[4], descr->usage_bits, descr->cdb_size);
+	if (descr->update_usage_bits)
+		descr->update_usage_bits(&buf[4], dev);
 
 	td_size = spc_rsoc_encode_command_timeouts_descriptor(
 			&buf[4 + descr->cdb_size], ctdp, descr);
@@ -2181,7 +2210,8 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 		put_unaligned_be32(response_length - 3, buf);
 	} else {
 		response_length = spc_rsoc_encode_one_command_descriptor(
-				&buf[response_length], rctd, descr);
+				&buf[response_length], rctd, descr,
+				cmd->se_dev);
 	}
 
 	memcpy(rbuf, buf, min_t(u32, response_length, cmd->data_length));
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 062ee8b6c433..0c1e43980985 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -880,6 +880,8 @@ struct target_opcode_descriptor {
 	u16			nominal_timeout;
 	u16			recommended_timeout;
 	bool			(*enabled)(struct se_cmd *cmd);
+	void			(*update_usage_bits)(u8 *usage_bits,
+						     struct se_device *dev);
 	u8			usage_bits[];
 };
 
-- 
2.25.1

