Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A19C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 07:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C95A61185
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 07:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhEFHjO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 03:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhEFHjO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 03:39:14 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4737AC061574
        for <linux-scsi@vger.kernel.org>; Thu,  6 May 2021 00:38:15 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id s82so2781427wmf.3
        for <linux-scsi@vger.kernel.org>; Thu, 06 May 2021 00:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BFSD4uGaE91vOCDyD3VHqMF98ejMiHJ+FiRdefnTj0g=;
        b=VBJeTd7HszUPNixsj9t36oyb5ZqEIj5qKC5tG0ZAClEBjco5Ju03rYdlNSEVSOspps
         29m816gL++zACGr6HQOp0SRh1pjEeGzP9qisBOKHXZc2rUXz2jU0X+sULRVkixzbB9o5
         DdPPv0fVW8Ppcnt72O8LvsBP5Fv+9qcQER1UaF3SYaNyEqhyosteYSLV4mnPt6ajY3Gj
         Xx5pW3xkgxcGJzK/ujaL0lDW/2fY+nBqj21S59nwmeQ86q6CwUr0i8GdWtmHQaYeNPsL
         mSVPGbdEZMJmWdadXTY01m4XBEDcrlbkHCdIuUG/VbcBijGRtmudgUlEk/mKBrHHk/H+
         Zlcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BFSD4uGaE91vOCDyD3VHqMF98ejMiHJ+FiRdefnTj0g=;
        b=mTkIsHJ2hqByY9vqTqIgz0V+Ah4kFua5/C9F4wSDSjxe5+0FrW6hV2qoPuWOBsDWK1
         FyhOgaCBDBRzJ+majb7kbWMQYi5Hp5mmqj4TcsiunexvK8sbVM0U7KImEtkmA5bT/HNp
         5OHsfUX+vhJr93wnZY/i5M/skAnxqYpOvTRiPUrVq4Tjrw06HvddrbjKLzqm8bffpV7B
         C7z39YHPKfzmqUpqTRVuN5IJZvb+lnLY/5HFHnNYOyb9Y4uOpO/G/0E6bnd0NM4mqRTQ
         fRZnEK+5epCM3/tVOBXLyjBaoRSh/iixfa5Oz77TxJh64ox/qxRAuy3kJ/dk0du/mRly
         x3GA==
X-Gm-Message-State: AOAM532I2H22nU9iXUjri2rSx1mCQ+RU3AYAeB4kLuLS0lsopJQ9tGA4
        Wc+1IPmvXmB6z4LsItoTOHk/Ycs4gRcFwey72uY=
X-Google-Smtp-Source: ABdhPJweCdyJcXFwXr1m+xV2IWUuo4EQUeSc0PhZURQ42/IYavPNONbljbeUDmDtJVa7QhK8hu8nHA==
X-Received: by 2002:a1c:b403:: with SMTP id d3mr2454314wmf.79.1620286694019;
        Thu, 06 May 2021 00:38:14 -0700 (PDT)
Received: from localhost.localdomain (30.34.155.90.in-addr.arpa. [90.155.34.30])
        by smtp.gmail.com with ESMTPSA id o82sm2184823wmo.36.2021.05.06.00.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 00:38:13 -0700 (PDT)
From:   Phillip Potter <phil@philpotter.co.uk>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: sd: skip checks when media is present if sd_read_capacity reports zero
Date:   Thu,  6 May 2021 08:36:10 +0100
Message-Id: <20210506073610.33867-1-phil@philpotter.co.uk>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In sd_revalidate_disk, if sdkp->media_present is set, then sdkp->capacity
should not be zero. Therefore, jump to end of if block and skip remaining
checks/calls. Fixes a KMSAN-found uninit-value bug reported by syzbot at:
https://syzkaller.appspot.com/bug?id=197c8a3a2de61720a9b500ad485a7aba0065c6af

Reported-by: syzbot+6b02c1da3865f750164a@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---
 drivers/scsi/sd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ed0b1bb99f08..a7fe53f492ae 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3201,6 +3201,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
+		if (!sdkp->capacity)
+			goto present_block_end;
 
 		/*
 		 * set the default to rotational.  All non-rotational devices
@@ -3226,6 +3228,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_write_same(sdkp, buffer);
 		sd_read_security(sdkp, buffer);
 	}
+present_block_end:
 
 	/*
 	 * We now have all cache related info, determine how we deal
-- 
2.30.2

