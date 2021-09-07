Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3AAC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 16:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCC52610A3
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 16:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345089AbhIGQxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 12:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344220AbhIGQxo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 12:53:44 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DBEC061575
        for <linux-scsi@vger.kernel.org>; Tue,  7 Sep 2021 09:52:37 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id q22so3844464pfu.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Sep 2021 09:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JCgI9ACGPpLbPaMUZfxqUD1Pqisa+ao6jkbuz8k++ek=;
        b=NfY2Hi2kOonFX4MfuZ1h4Tyre14yX0kLCOzaMXELyDN/2A35aA7U8LXx7UXUxclmdp
         nmRsbCdFVlpOFlTwZq47NMwOUp/mNiboBsSfMnaRTcMv7amjteuW/mE7GsZWg8l9dPa/
         PlWMryOdZOKfZzibR2PvuYdqZXPADMVaDbH4iANgmwND+prfbQaFLxDVkV+T+nUAh5wn
         PyECFR9PIHe7bg3xYNJvi6yK+eQ5DsMJi2QnUZc43qrg/GJJnanRwZJFt3hb8zJ9+eIh
         BiAlVMXZNJ8VUFhNNYzpeJsplhm7JXokDs7RdHiNAzqiZiUy2BGkPjdo52gzyX1fH7Tl
         PYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JCgI9ACGPpLbPaMUZfxqUD1Pqisa+ao6jkbuz8k++ek=;
        b=Z0O/rIByf1yZOmtInXtZYsVfzPThs3V9ZZ/Q9tnJfMhp9D3N/FvI39I+hnvxQBaG+x
         LVF4wv0/SQ+wZCEwAymlnaqb32YnGhYz5HoSuOLTkqi3ayXJq1vGY+p1q9KB2SqR3nF4
         7jx30AKqLnsmZ/VX6irdUOtbCXrqOdqrInyuHjlZxu33vZDPHmMkHyrIXti4cG9OAV5c
         n88PfehukiUappGb/4UlRtZwc2EJlZvWC9H30iUUZVr77qbZD80hTsEJe/SChigiASUD
         rxUgnko1AAo7Y0Ut6pGE43aoV8CawznH9GvmX2LwWhCpb3zHMLzNcBx+70ozVIEI7Tw2
         sciA==
X-Gm-Message-State: AOAM531cVaUn3f2U09JKbMQwy+8A8huLdXCS4ZCiT9XTGiT3KyWESZ/z
        xIT6zoHzOtmVt29DJwnTyzkLe4C9nAAzkA==
X-Google-Smtp-Source: ABdhPJwxcKj8a2KGl5Rn306IGZdtwcFtnuSkEQz8wRYW+gx+rZVhiYOBXEd+L4L9/+HEWoqNepneOg==
X-Received: by 2002:a63:1914:: with SMTP id z20mr17811839pgl.87.1631033557075;
        Tue, 07 Sep 2021 09:52:37 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k190sm11578997pfd.211.2021.09.07.09.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 09:52:36 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH] elx: efct: Do not hold lock while calling fc_vport_terminate
Date:   Tue,  7 Sep 2021 09:52:25 -0700
Message-Id: <20210907165225.10821-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Smatch checker reported the following error:
  drivers/base/power/sysfs.c:833 dpm_sysfs_remove()
  warn: sleeping in atomic context

With a calling sequence of:
efct_lio_npiv_drop_nport() <- disables preempt
-> fc_vport_terminate()
   -> device_del()
      -> dpm_sysfs_remove()

Issue is efct_lio_npiv_drop_nport() is making the fc_vport_terminate()
call while holding a lock w/ ipl raised.

It's unnecessary to hold the lock over this call, shift where the lock
is taken.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_lio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index bb3b460dc0bc..4d73e92909ab 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -880,11 +880,11 @@ efct_lio_npiv_drop_nport(struct se_wwn *wwn)
 	struct efct *efct = lio_vport->efct;
 	unsigned long flags = 0;
 
-	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
-
 	if (lio_vport->fc_vport)
 		fc_vport_terminate(lio_vport->fc_vport);
 
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+
 	list_for_each_entry_safe(vport, next_vport, &efct->tgt_efct.vport_list,
 				 list_entry) {
 		if (vport->lio_vport == lio_vport) {
-- 
2.26.2

