Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D27C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 20:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB3560F5E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 20:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhG2UUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 16:20:36 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:43104 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232932AbhG2UUf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jul 2021 16:20:35 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 51FAC49DDF;
        Thu, 29 Jul 2021 20:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1627590028; x=1629404429; bh=H73jFoYez2LhXA71p2ROD00NUkuXgm2MFeH
        gjoDSzTc=; b=fi2bLzuPjOLYP9h0UghPyCWKqrZAwOYrmj0DPRGOyK5jgScKYt0
        IvEaAhS2CInOEhB4uwynkZji7VSUXzVhCuWtM9R4gfa4hqQJ8HwZA5GQgj+NBphJ
        gcaCa1uyyIYuNH0WuwK365jr+yTz4XlMUdesfro+dOutweHmcEnWqOg4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id adDz9rg-K4tz; Thu, 29 Jul 2021 23:20:28 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9041249DD9;
        Thu, 29 Jul 2021 23:20:28 +0300 (MSK)
Received: from yadro.com (10.199.0.12) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 29
 Jul 2021 23:20:27 +0300
From:   Sergey Samoylenko <s.samoylenko@yadro.com>
To:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <ddiss@suse.de>, <bvanassche@acm.org>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Sergey Samoylenko <s.samoylenko@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>
Subject: [PATCH 1/1] scsi: target: core: Add 8Fh VPD page
Date:   Thu, 29 Jul 2021 23:19:43 +0300
Message-ID: <20210729201943.40222-2-s.samoylenko@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729201943.40222-1-s.samoylenko@yadro.com>
References: <20210729201943.40222-1-s.samoylenko@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.12]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 8Fh VPD page announces the capabilities supported by
the TCM XCOPY manager. It helps to expand the coverage of
the third-party copy manager with SCSI testing utilities.

Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Reviewed-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
---
 drivers/target/target_core_spc.c | 230 ++++++++++++++++++++++++++++++-
 1 file changed, 226 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 22703a0dbd07..169341712b10 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -506,6 +506,217 @@ spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 	return 0;
 }
 
+/* Third-party copy descriptor length is a multiple of four */
+static u16 __spc_evpd_8f_desc_calc_padding(u16 len)
+{
+	return (4 - (len & 3)) & 3;
+}
+
+/* Supported Commands third-party copy descriptor, spc4 7.8.17.4 */
+static int spc_evpd_8f_encode_supp_cmds(unsigned char *buf)
+{
+	u16 off = 0;
+
+	/*
+	 * TCM supports only two Third-party copy commands:
+	 *   83h/00h - EXTENDED COPY(LID1)
+	 *   84h/03h - RECEIVE COPY OPERATING PARAMETERS
+	 */
+
+	/* Set THIRD-PARTY COPY DESCRIPTOR TYPE (0001h) */
+	put_unaligned_be16(0x0001, &buf[off]);
+	off += 2;
+	/* Skip THIRD-PARTY COPY DESCRIPTOR LENGTH */
+	off += 2;
+	/* Set COMMANDS SUPPORTED LIST LENGTH for two codes */
+	buf[off++] = 6;
+	/* First command support descriptor (EXTENDED COPY(LID1)) */
+	buf[off++] = EXTENDED_COPY; /* operation code */
+	buf[off++] = 1; /* action list length */
+	buf[off++] = 0; /* service action */
+	/* Second descriptor (RECEIVE COPY OPERATING PARAMETERS) */
+	buf[off++] = RECEIVE_COPY_RESULTS;
+	buf[off++] = 1;
+	buf[off++] = RCR_SA_OPERATING_PARAMETERS;
+	/* Descriptor pad */
+	off += __spc_evpd_8f_desc_calc_padding(off);
+
+	/* Set THIRD-PARTY COPY DESCRIPTOR LENGTH */
+	put_unaligned_be16(off - 4, &buf[2]);
+
+	return off;
+}
+
+/* Parameter Data third-party copy descriptor, spc4 7.8.17.5 */
+static int spc_evpd_8f_encode_param_data(unsigned char *buf)
+{
+	u16 off = 0;
+
+	/* Set THIRD-PARTY COPY DESCRIPTOR TYPE (0004h) */
+	put_unaligned_be16(0x0004, &buf[off]);
+	off += 2;
+	/* Set THIRD-PARTY COPY DESCRIPTOR LENGTH (001Ch) */
+	put_unaligned_be16(0x001c, &buf[off]);
+	off += 2;
+	/* Skip over Reserved */
+	off += 4;
+	/* Set MAXIMUM CSCD DESCRIPTOR COUNT */
+	put_unaligned_be16(RCR_OP_MAX_TARGET_DESC_COUNT, &buf[off]);
+	off += 2;
+	/* Set MAXIMUM SEGMENT DESCRIPTOR COUNT */
+	put_unaligned_be16(RCR_OP_MAX_SG_DESC_COUNT, &buf[off]);
+	off += 2;
+	/* Set MAXIMUM DESCRIPTOR LIST LENGTH */
+	put_unaligned_be32(RCR_OP_MAX_DESC_LIST_LEN, &buf[off]);
+	off += 4;
+	/*
+	 * The MAXIMUM INLINE DATA LENGTH field should be set to ZERO
+	 * if the copy manager does not support segment descriptor
+	 * type code 04h.
+	 */
+	off += 4;
+	/* Skip over Reserved */
+	off += 12;
+
+	return off;
+}
+
+/* Supported Descriptors third-party copy descriptor, spc4 7.8.17.6 */
+static int spc_evpd_8f_encode_supp_descrs(unsigned char *buf)
+{
+	u16 off = 0;
+
+	/*
+	 * List of supported descriptor type codes:
+	 *   02h - Copy from block device to block device segment descriptor
+	 *   E4h - Identification Descriptor CSCD descriptor
+	 */
+
+	/* Set THIRD-PARTY COPY DESCRIPTOR TYPE (0008h) */
+	put_unaligned_be16(0x0008, &buf[off]);
+	off += 2;
+	/* Skip THIRD-PARTY COPY DESCRIPTOR LENGTH */
+	off += 2;
+	/* Set SUPPORTED DESCRIPTOR LIST LENGTH */
+	buf[off++] = 2;
+	/* List of supported descriptor type codes */
+	buf[off++] = 0x02;
+	buf[off++] = 0xe4;
+	/* Descriptor pad */
+	off += __spc_evpd_8f_desc_calc_padding(off);
+
+	/* Set THIRD-PARTY COPY DESCRIPTOR LENGTH */
+	put_unaligned_be16(off - 4, &buf[2]);
+
+	return off;
+}
+
+/* Supported CSCD Descriptor IDs third-party copy descriptor, spc4 7.8.17.7 */
+static int spc_evpd_8f_encode_supp_cscd_descr_id(unsigned char *buf)
+{
+	u16 off = 0;
+
+	/*
+	 * The TCM copy manager doesn't support CSCD Descriptod IDs other
+	 * than 0000h and therefore IDs List should be zero length.
+	 */
+
+	/* Set THIRD-PARTY COPY DESCRIPTOR TYPE (000Ch) */
+	put_unaligned_be16(0x000c, &buf[off]);
+	off += 2;
+	/* Skip THIRD-PARTY COPY DESCRIPTOR LENGTH */
+	off += 2;
+	/* Set SUPPORTED CSCD DESCRIPTOR IDS LIST LENGTH to ZERO */
+	off += 2;
+	/* Descriptor pad */
+	off += __spc_evpd_8f_desc_calc_padding(off);
+
+	/* Set THIRD-PARTY COPY DESCRIPTOR LENGTH */
+	put_unaligned_be16(off - 4, &buf[2]);
+
+	return off;
+}
+
+/* General Copy Operations third-party copy descriptor, spc4 7.8.17.10 */
+static int spc_evpd_8f_encode_general_copy_ops(unsigned char *buf)
+{
+	u16 off = 0;
+
+	/* Set THIRD-PARTY COPY DESCRIPTOR TYPE (8001h) */
+	put_unaligned_be16(0x8001, &buf[off]);
+	off += 2;
+	/* Set THIRD-PARTY COPY DESCRIPTOR LENGTH (0020h) */
+	put_unaligned_be16(0x0020, &buf[off]);
+	off += 2;
+	/* Set TOTAL CONCURRENT COPIES */
+	put_unaligned_be32(RCR_OP_TOTAL_CONCURR_COPIES, &buf[off]);
+	off += 4;
+	/* Set MAXIMUM IDENTIFIED CONCURRENT COPIES */
+	put_unaligned_be32(RCR_OP_MAX_CONCURR_COPIES, &buf[off]);
+	off += 4;
+	/* Set MAXIMUM SEGMENT LENGTH */
+	put_unaligned_be32(RCR_OP_MAX_SEGMENT_LEN, &buf[off]);
+	off += 4;
+	/* Set DATA SEGMENT GRANULARITY (log 2) */
+	buf[off++] = RCR_OP_DATA_SEG_GRAN_LOG2;
+	/*
+	 * Set INLINE DATA GRANULARITY (log 2) to ZERO.
+	 * TCM XCOPY manager does not support 04h (copy
+	 * inline data to stream device) descriptor type.
+	 */
+	off += 1;
+	/* Reserved */
+	off += 18;
+
+	return off;
+}
+
+/* Third-party Copy VPD page */
+static sense_reason_t
+spc_emulate_evpd_8f(struct se_cmd *cmd, unsigned char *buf)
+{
+	struct se_device *dev = cmd->se_dev;
+	int off;
+	u16 page_len;
+
+	if (!dev->dev_attrib.emulate_3pc)
+		return TCM_INVALID_CDB_FIELD;
+
+	/*
+	 * Since the Third-party copy manager in TCM is quite simple
+	 * and supports only two commands, the function sets
+	 * many descriptor parameters as constants.
+	 *
+	 * As the Copy manager supports the EXTENDED COPY(LID1) command,
+	 * the Third-party Copy VPD page should include five mandatory
+	 * Third-party copy descriptors. Its are:
+	 *   0001h - Supported Commands
+	 *   0004h - Parameter Data
+	 *   0008h - Supported Descriptors
+	 *   000Ch - Supported CSCD Descriptor IDs
+	 *   8001h - General Copy Operations
+	 *
+	 * See spc4 section 7.8.17
+	 */
+
+	off = 4;
+
+	/* fill descriptors */
+	off += spc_evpd_8f_encode_supp_cmds(&buf[off]);
+	off += spc_evpd_8f_encode_param_data(&buf[off]);
+	off += spc_evpd_8f_encode_supp_descrs(&buf[off]);
+	off += spc_evpd_8f_encode_supp_cscd_descr_id(&buf[off]);
+	off += spc_evpd_8f_encode_general_copy_ops(&buf[off]);
+
+	/*
+	 * Page Length for VPD 0x8f
+	 */
+	page_len = &buf[off] - &buf[0] - 4;
+	put_unaligned_be16(page_len, &buf[2]);
+
+	return 0;
+}
+
 /* Block Limits VPD page */
 static sense_reason_t
 spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
@@ -702,6 +913,7 @@ static struct {
 	{ .page = 0x80, .emulate = spc_emulate_evpd_80 },
 	{ .page = 0x83, .emulate = spc_emulate_evpd_83 },
 	{ .page = 0x86, .emulate = spc_emulate_evpd_86 },
+	{ .page = 0x8f, .emulate = spc_emulate_evpd_8f },
 	{ .page = 0xb0, .emulate = spc_emulate_evpd_b0 },
 	{ .page = 0xb1, .emulate = spc_emulate_evpd_b1 },
 	{ .page = 0xb2, .emulate = spc_emulate_evpd_b2 },
@@ -712,7 +924,9 @@ static struct {
 static sense_reason_t
 spc_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf)
 {
-	int p;
+	bool emulate_3pc = cmd->se_dev->dev_attrib.emulate_3pc;
+	int i, p;
+	uint8_t page;
 
 	/*
 	 * Only report the INQUIRY EVPD=1 pages after a valid NAA
@@ -720,9 +934,17 @@ spc_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf)
 	 * during device creation/restart.
 	 */
 	if (cmd->se_dev->dev_flags & DF_EMULATED_VPD_UNIT_SERIAL) {
-		buf[3] = ARRAY_SIZE(evpd_handlers);
-		for (p = 0; p < ARRAY_SIZE(evpd_handlers); ++p)
-			buf[p + 4] = evpd_handlers[p].page;
+		for (i = 0, p = 4; i < ARRAY_SIZE(evpd_handlers); ++i) {
+			page = evpd_handlers[i].page;
+			/*
+			 * The 8Fh VPD page is announced only if the copy
+			 * manager is activated.
+			 */
+			if ((page == 0x8f) && !emulate_3pc)
+				continue;
+			buf[p++] = page;
+		}
+		buf[3] = p - 4;
 	}
 
 	return 0;
-- 
2.25.1

