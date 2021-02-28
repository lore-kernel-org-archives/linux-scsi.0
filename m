Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B9CC433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 081CA64E51
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhB1F7H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:59:07 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34894 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhB1F6w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:58:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492605; x=1646028605;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7kSYxKm8+KMkh8fgxhih+9JXrVQOWMzWTgb+Sd44LW4=;
  b=gr5m0zDXd5tGtuugI1GiLEHPzmYBxXq4wwM516e/AgwwV6totwb6DLsb
   RQHmqsC5vYaAv3fxTq4zpAfxCh3p2YJ6a/XE7xMab8J3SVmLG9LdY1JIn
   Vh2c/Ae1IHdCR75Q9V2hcYEUkx/z4g+mAoixpgVX/fq/2n6NxUQTp0a2i
   g5Sj0dCpCwBKJa1F73cdbHxPoT2PxqTDMgxrzjGKEUrnNLfd7dbYuEj/M
   hNisnXcF3bDipyrymfJif0VFixKmrxRB+wgKj53zVECmq2uH2EN/k4/Bz
   EIX/zfnAOQJ+ndclZmt3Hp0971z8NrxsWUqUykIq53ZiGCOs5uCb9xmjt
   w==;
IronPort-SDR: u9hISYfxlNQPeWnKFTC2Hze3tQBCynLFYfiYQVEyxYrbeFPMuJmKot2lY0RE7NnfGuwGOoYXJa
 m1icBkAcxYmDxcJZaVn9PoIWGI8nnWq196SfhX8j5QEsTRa1wrA2GC8HJ3njWnRd8HR+Ohfe+Q
 SLqCmADJn5c793pz0LQ5/otv3sP1dkDkPh4uXnHIMmDw/przo3JHVTlsRena4yczO5XeWc2B+e
 nVBWrnWrf+07AH46bKd+CJC85Maa76eZN8nCT22Wp6kg+/YgkoNa3UreJfECzwbqn1wSG3TfbQ
 unA=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="265236069"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 14:08:25 +0800
IronPort-SDR: tRiDzpDcaM/zQnYgH9FALCn0c/g+3x+jUpQJ7CLFSV1q3rgTUvB1uwgQ9l7WxXMkyrsOhOKBru
 OZD4vkte8fs3dmopYYsOnoQt/CxnwUUo/3JIPFKkk/JiOVbxs94ZsEhMhUwt3IGl5w3dynryc/
 LbX1F0V+axJZ/1LIqYKzjGyx2ilBjpDz7NF/iW7Nm6X6VjnM+VLAZxatKZuv/PvGCz8J8odEaG
 8/f0bBaCYgSOqS/X/5MAnffED8PyVa2YzEUIQUh75zI4UdakBosEfCs78Yeoj+PR9lJNLE5Hwb
 x1x9zqbI4gXuQDVorWh1yGjL
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:39:04 -0800
IronPort-SDR: eGGCpVsT61EQctc8HcH2EA0W4n2olUy+6TB5CstDgSTtVdhunrgtEaLj8ZHecB+WhQg+yGPZD6
 udQ9tsBikPmPhxW1V5OCCA8n+Qa0fyX3h1TgBoV5Kn7Sf1SB9n/m51FfzhM0NrQeHCyHeh0r6a
 eDDxLRWgMkiouH2cvUiVCUFP9ROFzyZXKS2giit8evSRTTjL+k6XFp3W6mrGuf3O62r+ei2Det
 Po0THPfFu+1N4172aRlkOgfX2+vdQVzs30mSvMJ4JYhI4TtdAZNfKHV1Fu0qihQFhiRZ5VcHPo
 z14=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:57:45 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 05/23] target/sbc: get rid of the warning in cmp & write
Date:   Sat, 27 Feb 2021 21:56:27 -0800
Message-Id: <20210228055645.22253-6-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename the function local variable i -> sg_cnt so we can get rid of the
shadow variable compilation warning:-

drivers/target//target_core_sbc.c: In function ‘compare_and_write_do_cmp’:
drivers/target//target_core_sbc.c:475:17: warning: declaration of ‘i’ shadows a previous local [-Wshadow]
    unsigned int i;
                 ^
drivers/target//target_core_sbc.c:451:6: note: shadowed declaration is here
  int i;
      ^
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

