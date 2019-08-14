Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0492C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B8ED20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvXPp9bY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfHNX5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45969 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfHNX5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so403267pgp.12
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xPvP587wom3O9I1ML4kqBRzHZIlWsotwWkV5gld0PDc=;
        b=GvXPp9bYtV6tYRacwcNpRoKFbIUTw70hlJBsO8AIZPUZ5iTtu5rRA/ZUNShXyplA+i
         pyhumgGUx9geNVXGs+gmOJ1SSPwV1BurEhurSQ6c+Ntrh1rXDNa2A+cTgBK44i8Za0R1
         MD4FwLJ2d5IFCywbvxNrKs+m7fQK2LiTmKBYEaSiV0NlAsocWC4Edp+/nifZZCbbYCoU
         cbA6u56Kf3YEiSUbsLZZciJh9QnzdAoJJVzXqw+A2JgoNYrm1lQmSunBOcupgPpeJ8ld
         NBHuuBtYVFw9/FBiHRNOLbE0Ldm24ns1HjgTRY7pJvpTQYVAdpvd9A3WguwJHxqTYjHC
         WAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xPvP587wom3O9I1ML4kqBRzHZIlWsotwWkV5gld0PDc=;
        b=uYFcJQrTMd2GWrRLeEnTKoq3JLuXja8n3B/RfIBjudATIwc6bc3oR/9PLD9FijMkn0
         8zJuWTO0NT4GIUFhZNn1B5/p/Jo8ltVuy9cBd4xbMVaA/51EWJie5UFu6by68TnK/wvT
         655PrmrBDJ7CX2t7Sthf1nb4mDCmMb/s5bwNFpb6QHE+O16DEFi6W6QQbdLLAlOpznSE
         mX0Ek46dyDa4YaTY+N9UJGydG48J1a4HO9qymUYkTZqbA9mky5qdGVVhYHNfugOFEwEG
         f5xXkTTnrnTnQGcglp3NQpN6WO/1sS+hAAHyKyUSYwYFRuXPrk0MgW3XynLftyOFGWcM
         9xfA==
X-Gm-Message-State: APjAAAWSOC3BKTn9JV9NqBUdB33+PwluOUmk0kfj5hU7R0HUO/BKq5t5
        JySIUx6hg29L3eMY9wseEQLAV8rM
X-Google-Smtp-Source: APXvYqzXHxseChB2rnq/JWEqtI/s14kF0iTQVHyTqtq0azb76GII5akdZYozi4H+THkLJlWfqXGiOw==
X-Received: by 2002:aa7:87d5:: with SMTP id i21mr2606527pfo.70.1565827043174;
        Wed, 14 Aug 2019 16:57:23 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:22 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/42] lpfc: Limit xri count for kdump environment
Date:   Wed, 14 Aug 2019 16:56:31 -0700
Message-Id: <20190814235712.4487-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI-MQ operation inherently performs pre-allocation of resources
for blk-mq request queues. Even though the kdump environment reduces
the configuration to a single cpu, thus 1 hardware queue, which helps
significantly, the resources are still rather large due to the per
request allocations. Blk-mq pre-allocations can be over 4KB per
request.  With adapter can_queue values in the 4k or 8k range, this
can easily be 32MBs before any other driver memory is factored in.
Driver SGL dma buffer allocation can be up to 8KB per request as well
adding an additional 64MBs. Totals are well over 100MBs for a single
shost.  Given kdump memory auto-sizing utilities don't accommodate
this amount of memory well, its very possible for kdump to fail due
to lack of memory.

Fix by having the driver recognize that it is booting within a kdump
context and reduce the number of requests it will support to a more
reasonable value.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1ac98becb5ba..02231370428a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -39,6 +39,7 @@
 #include <linux/msi.h>
 #include <linux/irq.h>
 #include <linux/bitops.h>
+#include <linux/crash_dump.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -8309,6 +8310,10 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 			bf_get(lpfc_mbx_rd_conf_extnts_inuse, rd_config);
 		phba->sli4_hba.max_cfg_param.max_xri =
 			bf_get(lpfc_mbx_rd_conf_xri_count, rd_config);
+		/* Reduce resource usage in kdump environment */
+		if (is_kdump_kernel() &&
+		    phba->sli4_hba.max_cfg_param.max_xri > 512)
+			phba->sli4_hba.max_cfg_param.max_xri = 512;
 		phba->sli4_hba.max_cfg_param.xri_base =
 			bf_get(lpfc_mbx_rd_conf_xri_base, rd_config);
 		phba->sli4_hba.max_cfg_param.max_vpi =
-- 
2.13.7

