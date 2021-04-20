Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B01C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 19:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A3F0613C9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 19:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhDTTAu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 15:00:50 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:52986 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233509AbhDTTAk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 15:00:40 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 6E76A41399;
        Tue, 20 Apr 2021 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1618945206; x=1620759607; bh=xpo6q+gG4OET66ikBrty6MRwlRymz6Dolhc
        tB0Re6Rs=; b=ZqihTaJu6U7G7GLuBr/wy8ng4J/0tvVqxtv/VKq0zcEoYi2zUWX
        4IkjxUf9v67FjW0OpYMyj58kgQ0ExQdB1PLnw5f7DbRZFBnhLLVwsR1gy+rozkQe
        j77iE2Ic4Alf2p5B9g8dYCcKogNXZ1u+C+5iTdOMUVsTXs+3A1XhAOQ4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SF1zIEabhRVd; Tue, 20 Apr 2021 22:00:06 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 243A641318;
        Tue, 20 Apr 2021 22:00:06 +0300 (MSK)
Received: from yadro.com (10.199.0.227) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 20
 Apr 2021 22:00:05 +0300
From:   Sergey Samoylenko <s.samoylenko@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     David Disseldorp <ddiss@suse.de>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Sergey Samoylenko <s.samoylenko@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH RESEND 1/2] scsi: target: core: Unify NAA identifer generation
Date:   Tue, 20 Apr 2021 21:59:19 +0300
Message-ID: <20210420185920.42431-2-s.samoylenko@yadro.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210420185920.42431-1-s.samoylenko@yadro.com>
References: <20210420185920.42431-1-s.samoylenko@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.227]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

INQUIRY and XCOPY commands contain duplicate code paths with hardcoded
OpenFabrics Company ID for NAA designator.

Also, the two existing functions are somewhat poorly named:

 - spc_parse_naa_6h_vendor_specific()
 - target_xcopy_gen_naa_ieee()

The replacement function combines the names and hopefully better
reflects its meaning of *producing* NAA 6 designator:

 - spc_gen_naa_6h_vendor_specific()

Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_pr.h    |  2 +-
 drivers/target/target_core_spc.c   | 47 +++++++++++++++---------------
 drivers/target/target_core_xcopy.c | 17 ++---------
 3 files changed, 26 insertions(+), 40 deletions(-)

diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index a31c93e4e19c..b793c99637ab 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -52,7 +52,7 @@
 /*
  *  Function defined in target_core_spc.c
  */
-void spc_parse_naa_6h_vendor_specific(struct se_device *, unsigned char *);
+void spc_gen_naa_6h_vendor_specific(struct se_device *, unsigned char *);
 
 extern struct kmem_cache *t10_pr_reg_cache;
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 70a661801cb9..b2d19493a994 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -129,13 +129,28 @@ spc_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
 	return 0;
 }
 
-void spc_parse_naa_6h_vendor_specific(struct se_device *dev,
-				      unsigned char *buf)
+/*
+ * Generate NAA IEEE Registered Extended designator
+ */
+void spc_gen_naa_6h_vendor_specific(struct se_device *dev,
+				    unsigned char *buf)
 {
 	unsigned char *p = &dev->t10_wwn.unit_serial[0];
-	int cnt;
+	int cnt, off = 0;
 	bool next = true;
 
+	/*
+	 * Start NAA IEEE Registered Extended Identifier/Designator
+	 */
+	buf[off++] = 0x6 << 4;
+
+	/*
+	 * Use OpenFabrics IEEE Company ID: 00 14 05
+	 */
+	buf[off++] = 0x01;
+	buf[off++] = 0x40;
+	buf[off] = (0x5 << 4);
+
 	/*
 	 * Generate up to 36 bits of VENDOR SPECIFIC IDENTIFIER starting on
 	 * byte 3 bit 3-0 for NAA IEEE Registered Extended DESIGNATOR field
@@ -144,7 +159,7 @@ void spc_parse_naa_6h_vendor_specific(struct se_device *dev,
 	 * NUMBER set via vpd_unit_serial in target_core_configfs.c to ensure
 	 * per device uniqeness.
 	 */
-	for (cnt = 0; *p && cnt < 13; p++) {
+	for (cnt = off + 13; *p && off < cnt; p++) {
 		int val = hex_to_bin(*p);
 
 		if (val < 0)
@@ -152,10 +167,10 @@ void spc_parse_naa_6h_vendor_specific(struct se_device *dev,
 
 		if (next) {
 			next = false;
-			buf[cnt++] |= val;
+			buf[off++] |= val;
 		} else {
 			next = true;
-			buf[cnt] = val << 4;
+			buf[off] = val << 4;
 		}
 	}
 }
@@ -203,24 +218,8 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	/* Identifier/Designator length */
 	buf[off++] = 0x10;
 
-	/*
-	 * Start NAA IEEE Registered Extended Identifier/Designator
-	 */
-	buf[off++] = (0x6 << 4);
-
-	/*
-	 * Use OpenFabrics IEEE Company ID: 00 14 05
-	 */
-	buf[off++] = 0x01;
-	buf[off++] = 0x40;
-	buf[off] = (0x5 << 4);
-
-	/*
-	 * Return ConfigFS Unit Serial Number information for
-	 * VENDOR_SPECIFIC_IDENTIFIER and
-	 * VENDOR_SPECIFIC_IDENTIFIER_EXTENTION
-	 */
-	spc_parse_naa_6h_vendor_specific(dev, &buf[off]);
+	/* NAA IEEE Registered Extended designator */
+	spc_gen_naa_6h_vendor_specific(dev, &buf[off]);
 
 	len = 20;
 	off = (len + 4);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index d31ed071cb08..2e7ce661ef32 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -33,19 +33,6 @@ static struct workqueue_struct *xcopy_wq = NULL;
 
 static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop);
 
-static int target_xcopy_gen_naa_ieee(struct se_device *dev, unsigned char *buf)
-{
-	int off = 0;
-
-	buf[off++] = (0x6 << 4);
-	buf[off++] = 0x01;
-	buf[off++] = 0x40;
-	buf[off] = (0x5 << 4);
-
-	spc_parse_naa_6h_vendor_specific(dev, &buf[off]);
-	return 0;
-}
-
 /**
  * target_xcopy_locate_se_dev_e4_iter - compare XCOPY NAA device identifiers
  *
@@ -65,7 +52,7 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
 	}
 
 	memset(&tmp_dev_wwn[0], 0, XCOPY_NAA_IEEE_REGEX_LEN);
-	target_xcopy_gen_naa_ieee(se_dev, &tmp_dev_wwn[0]);
+	spc_gen_naa_6h_vendor_specific(se_dev, &tmp_dev_wwn[0]);
 
 	rc = memcmp(&tmp_dev_wwn[0], dev_wwn, XCOPY_NAA_IEEE_REGEX_LEN);
 	if (rc != 0) {
@@ -241,7 +228,7 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 	 * se_device the XCOPY was received upon..
 	 */
 	memset(&xop->local_dev_wwn[0], 0, XCOPY_NAA_IEEE_REGEX_LEN);
-	target_xcopy_gen_naa_ieee(local_dev, &xop->local_dev_wwn[0]);
+	spc_gen_naa_6h_vendor_specific(local_dev, &xop->local_dev_wwn[0]);
 
 	while (start < tdll) {
 		/*
-- 
2.27.0

