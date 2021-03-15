Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2D6C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 02:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16B1C64E46
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 02:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCOCQf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Mar 2021 22:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhCOCQ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Mar 2021 22:16:27 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B3CC061574;
        Sun, 14 Mar 2021 19:16:26 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id g185so30306019qkf.6;
        Sun, 14 Mar 2021 19:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W1CSVD6SxxfORRkmna+eezwASk1vHoR7ou0PeBM350M=;
        b=M9OOh0qhG+7jARz2l5DlLSdBE0ZEnwJe+wulrxv1p0c28l/61AelNvJIzCDje41cCQ
         CCKb9oBTeNmE/yPlzBNzTWDaUV/DOZlDMIMC5qmNEHlJ09tg9CQFxpyxDi/8Kvi43srW
         n6k1uYDVrs7UIGNju2+WiUZzHHz/oSDI78dIHp2tHb7Ryn3C3WmQzAitrlpOngz/U/H4
         388Rcju0j3kcplxR/olaPFd9ZdGQ1rV6POnbpJaE/XkVUU59urg0J9eP/e8Sl4kY/PlZ
         sejj0ufv1KubO8AMRvvfEuwDT6/naNXezQIqXVlvJTpOlH0jefTu7JEiUOamVkjfquUB
         zzSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W1CSVD6SxxfORRkmna+eezwASk1vHoR7ou0PeBM350M=;
        b=C/NovUXOq260IzSm4/FZNSSHUJpGuGyk0o/IeyUB5Y2ypfVjdBJVeis+UAr4cDzlXT
         Hz2bExevnjSPyMdx27ePVoWiiSVA2RSuHPks5qpukH7RKSFbaOXUeiElR/SV+Pmtd17+
         6r+JE54fXewZ9e58nYGBmmfjKpcFaJNbsVeGWbip/LLMeOuxlqQDR7w6PVXx04t3VVr9
         JNs960k4/gz1faj6R3g/ytkZO86zdDV7pWoZrPM2FIw0LalVKKSv+frqvhfmnoA0lvOl
         hl0kVcdlfSrLUxq9M/Uby5Eb0pAZqjW4pMRVA07FWUoEGk+sXBBEMrBXwDxiQPU79dko
         GeEA==
X-Gm-Message-State: AOAM530eFUmZ6rwT8ABB2WyX8QiFWv1pTo7+YjAov+eQt8pYiaE8hpnx
        EzY67z5PzBi3Z8J5p2ikcw4=
X-Google-Smtp-Source: ABdhPJxBYEj/AQAnVwLDVtshheZd1fPG5MR6o1CrjznMyROdhEiPzlUaXGORGs77QQe5hNlkTaviaQ==
X-Received: by 2002:a37:6888:: with SMTP id d130mr22835398qkc.368.1615774585850;
        Sun, 14 Mar 2021 19:16:25 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.69])
        by smtp.gmail.com with ESMTPSA id d14sm11091269qkg.33.2021.03.14.19.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 19:16:25 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     mdr@sgi.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] scsi: Mundane spelling fixes in the file qla1280.c
Date:   Mon, 15 Mar 2021 07:46:10 +0530
Message-Id: <20210315021610.2089087-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/quantites/quantities/
s/Unfortunely/Unfortunately/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/qla1280.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 46de2541af25..95008811b2d2 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -633,13 +633,13 @@ static int qla1280_read_nvram(struct scsi_qla_host *ha)
 	 * to be read a word (two bytes) at a time.
 	 *
 	 * The net result of this would be that the word (and
-	 * doubleword) quantites in the firmware would be correct, but
+	 * doubleword) quantities in the firmware would be correct, but
 	 * the bytes would be pairwise reversed.  Since most of the
-	 * firmware quantites are, in fact, bytes, we do an extra
+	 * firmware quantities are, in fact, bytes, we do an extra
 	 * le16_to_cpu() in the firmware read routine.
 	 *
 	 * The upshot of all this is that the bytes in the firmware
-	 * are in the correct places, but the 16 and 32 bit quantites
+	 * are in the correct places, but the 16 and 32 bit quantities
 	 * are still in little endian format.  We fix that up below by
 	 * doing extra reverses on them */
 	nv->isp_parameter = cpu_to_le16(nv->isp_parameter);
@@ -687,7 +687,7 @@ qla1280_info(struct Scsi_Host *host)
  * The mid-level driver tries to ensures that queuecommand never gets invoked
  * concurrently with itself or the interrupt handler (although the
  * interrupt handler may call this routine as part of request-completion
- * handling).   Unfortunely, it sometimes calls the scheduler in interrupt
+ * handling).   Unfortunately, it sometimes calls the scheduler in interrupt
  * context which is a big NO! NO!.
  **************************************************************************/
 static int
--
2.30.2

