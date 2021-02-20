Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711AFC433E9
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BBDA64ED5
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhBTViy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:38:54 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:7788 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhBTViy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:38:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857133; x=1645393133;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JDU7SDCm01NsXllctHlPOh96jdpRImezuze/IxEVfk8=;
  b=X5ZIpIqG9mjrd3RUR8XDy6OsJypOQAkDLPuEwZ5utIIDOfGVsQ43QUrr
   T0B/pugjk89RitfrUKtKnRRgf2gRhcufTOeEdnP8QJXHw+IypUSzEuWaH
   iiR/AdiF+2ZAc28zaSGLDYIkVms0VlpnClaBXJNsFUFNLLKfiDlIpkm1c
   CYj4sNK+jnThHGkIKc5dMb78fzpZtPv9GifKGR03bM/Wm2dTRaZwtE07w
   SxIbcZOsvsfOXie5HHOvchZKTIg6dVOx/kyC9WLMwZU00zguNvXe8ah8Z
   IANdhWNOrdxeWLDL+jDiR7mgvGjlD0qe0eFGIootADAIYApAjJGcnuI9o
   g==;
IronPort-SDR: +1Ejoi5aMwI8ogk1lL+cyMrA1RFdsVt8N+J2KJOxKxP3AHHDnN3aLXUmm7dDYq/8KX2pfLNXIa
 0IHzR5RFC9PuggFamjNk/MYaMY3o1AN+/yZUoSlhMDui1nv2XGFwvWPpMm48IjxK2Oi06z1NMn
 KaBKQVMcETlDIZPBGDqc1neHBjg5fjno4hwFhebitmnkY7afWKihOqGEc5HejJWEk9QNlKTCw0
 0y9cu+iHXZVgneDWeTRKZspI9QgTeqNM9zUTsxzJRxwdYqSgGNSO1fWQUHZ47CTNaJ01x3I+Ci
 Zd0=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="160432904"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:37:48 +0800
IronPort-SDR: KtRsDXXQ+llD5icXc0g39G2pXy65BjHFSCeQgfVbbI0bbyNUgqZRIl7A+wDIoiZXn5ExnHZOMl
 uDOg6cT7PI4O2OevisxJO/hYvLinQId2QXNxGrCCxf7XaXZCMZLRCqQylXm7hrMGvnLDR9hLqV
 k12afV3h+EbsqiTtT6efWpHjH7itV67050xb+TFhLyjJ4rUZSc0fzw0grrYi9k86Th+TsAWjRi
 RHnstOSiUNMgkwiTxp43DSkWGJe6keFZaSzJE7nrNSgfB0Vel5fkyMH68n20iEmfX3A2vVdBYA
 6j8U1GiYDt37M8RRyczN3pZd
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:19:22 -0800
IronPort-SDR: QqPMlDXQTqKIryP6MnUj35pcgu+i5mg24OhnQfSS/xKAQSWC8xFNYoyXbzFR6QM1x30Wyaxw40
 yewt/DEptp3lb+2ron2KbM70/hxtbAYXiApHxkqzzQ9+bjIt13xyNb0+CKqsu+TferWXwCMb4F
 34ElktrunTqZ4tyn1TvqUa7o4aVdOm8G8zuoJwvym9E+5Zp8pnDbdi/PCyFn7tkMQ4iahcIViQ
 NKX91oRVKMgW/rec924UnUCwcc1hulIaNgrCqaHY/uTl7swN8feSFsihc+KzPiyAjgJxHRXOWm
 64U=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:37:48 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 05/24] target/sbc: get rid of the warning in cmp & write
Date:   Sat, 20 Feb 2021 13:37:47 -0800
Message-Id: <20210220213747.6533-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename the i->sg_cnt so we can get rid of the shadow variable warning.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_sbc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index f7c527a826fd..7b07e557dc8d 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -448,7 +448,7 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 	sense_reason_t ret;
 	unsigned int offset;
 	size_t rc;
-	int i;
+	int sg_cnt;
 
 	buf = kzalloc(cmp_len, GFP_KERNEL);
 	if (!buf) {
@@ -467,7 +467,7 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 	 */
 	offset = 0;
 	ret = TCM_NO_SENSE;
-	for_each_sg(read_sgl, sg, read_nents, i) {
+	for_each_sg(read_sgl, sg, read_nents, sg_cnt) {
 		unsigned int len = min(sg->length, cmp_len);
 		unsigned char *addr = kmap_atomic(sg_page(sg));
 
-- 
2.22.1

