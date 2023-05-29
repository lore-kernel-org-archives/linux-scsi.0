Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CBAC77B7A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjE2UWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjE2UWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:22:08 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B45BE;
        Mon, 29 May 2023 13:22:07 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-64d30ab1f89so2462506b3a.3;
        Mon, 29 May 2023 13:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685391727; x=1687983727;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MAnY68W9tQQFxirzvgmzIs7axxvCCPBIV4gB1cEwbKs=;
        b=OVhSoldwwqXhd0OC3l7Rd0s2eK1FHOsoUQKeRPo9c8hhS1+0ERgtA+nE4yjsp9Mjbv
         Xsf5z8tqzGzRAdFe/fe874pgsYR4ffUFPfkAEwK3wR4ltoDKqbi7mFQrdvWthkg1s4Rp
         eMVoGxRu4MxqNlSO/A+rPJ+dS97DFi3aduagLEgQONoBzDljTNcGUGZ9BS9YJIZlCJXP
         6oB4/2McrK8JMqR7p0Vpx/rsrdOQ6OZXWCg6XpILm2Tdrq1RV1qYfeXUMz3o991MHm0Q
         0ZLvoWHtdreYB5UV37SDvc/P8r2yZNlvca+1Rv28epms0hoa8zMPQkQmNeE9zM5Ki3lq
         Hs1w==
X-Gm-Message-State: AC+VfDzVgcScr0AXAo5mNF96osPDlX70++wg7hpNS3yqEncAEBmrU8M2
        E6daSarTyZcsLj2o7i/wLPs=
X-Google-Smtp-Source: ACHHUZ4kbOzbFQO2vJ+IW7zM+gyhgOYAWCSf/xu8KqGlSzzvfTH3lyUkKwk7AqESaXfvPmDj0c+4fQ==
X-Received: by 2002:a05:6a20:914e:b0:10a:e177:9e73 with SMTP id x14-20020a056a20914e00b0010ae1779e73mr67536pzc.46.1685391726540;
        Mon, 29 May 2023 13:22:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id b19-20020a639313000000b0051b0e564963sm7439342pge.49.2023.05.29.13.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:22:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: stex: Fix gcc 13 warnings
Date:   Mon, 29 May 2023 13:21:51 -0700
Message-Id: <20230529202157.11361-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

gcc 13 may assign another type to enumeration constants than gcc 12. Split
the large enum at the top of source file stex.c such that the type of the
constants used in time expressions is changed back to the same type chosen
by gcc 12. This patch suppresses compiler warnings like this one:

In file included from ./include/linux/bitops.h:7,
                 from ./include/linux/kernel.h:22,
                 from drivers/scsi/stex.c:13:
drivers/scsi/stex.c: In function ‘stex_common_handshake’:
./include/linux/typecheck.h:12:25: error: comparison of distinct pointer types lacks a cast [-Werror]
   12 |         (void)(&__dummy == &__dummy2); \
      |                         ^~
./include/linux/jiffies.h:106:10: note: in expansion of macro ‘typecheck’
  106 |          typecheck(unsigned long, b) && \
      |          ^~~~~~~~~
drivers/scsi/stex.c:1035:29: note: in expansion of macro ‘time_after’
 1035 |                         if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
      |                             ^~~~~~~~~~

See also https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107405.

Cc: stable@vger.kernel.org
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/stex.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 5b230e149c3d..8ffb75be99bc 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -109,7 +109,9 @@ enum {
 	TASK_ATTRIBUTE_HEADOFQUEUE		= 0x1,
 	TASK_ATTRIBUTE_ORDERED			= 0x2,
 	TASK_ATTRIBUTE_ACA			= 0x4,
+};
 
+enum {
 	SS_STS_NORMAL				= 0x80000000,
 	SS_STS_DONE				= 0x40000000,
 	SS_STS_HANDSHAKE			= 0x20000000,
@@ -121,7 +123,9 @@ enum {
 	SS_I2H_REQUEST_RESET			= 0x2000,
 
 	SS_MU_OPERATIONAL			= 0x80000000,
+};
 
+enum {
 	STEX_CDB_LENGTH				= 16,
 	STATUS_VAR_LEN				= 128,
 
