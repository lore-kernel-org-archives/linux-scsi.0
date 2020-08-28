Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E1FC433E7
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 17:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63A2D2098B
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 17:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="D5qQtWiw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgH1Rxp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 13:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgH1Rxl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 13:53:41 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2C8C061232
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 10:53:40 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m8so1018466pfh.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 10:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TaLyrMTePWVx74K5m0rdCA2b0TFlH+5Xa8M4cBzzyq0=;
        b=D5qQtWiwb69a2Gw9BKdHYEFd/x4winMN3rqV1gJPX5IfI7zYDdjdjMvcia/WQdAXwq
         ogh8TkWo06jzAAc47yO670gAPUFadf3hDprvLZ7xefbXFMIaIfFOlffuA6PLnvCyB/XO
         hzHy8C868P1iZfB+qG7TS/6spmXpe8VrDVpW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TaLyrMTePWVx74K5m0rdCA2b0TFlH+5Xa8M4cBzzyq0=;
        b=Me43UBYn8AYfm18O6frHshkvZFpZ8QXhlEMFL84lO7Tkhl6FdxY8pOnBNMUMH5H2m8
         qUGfI5tgR8it95ptfzWv217Qw2PE9qlcU74H/26kUM26UQLhfs4KWCPt50Hs8IfecLow
         wXcKBPuY2bBj4aN6CgT9GapqpHlmKZRTPYAkkTE99mVdEH+gQoaKI2S6YOembquMgwA6
         dHvlfDMsv22XNP7T0B/OJ/w1N6Bmga4UB3FjkVodCxfm8Qv92nlYjs8XZVWuOrP9X8iq
         lfL+rfCImSzJUBGX2V+jaK04ynDVFP38bg4tPIV2y+I4MO0Qv/p9+ZQEBmC5s9UCkaOc
         7wsw==
X-Gm-Message-State: AOAM532mBM5fzGGnqU+Y1mV/G+9Ej7WK7AsGezkM4EZDJ3k8bbTsVfNp
        1RIumyaoYvEJ0x8v0muU8fSzPSSSnYQCxoqhrCJQ3KJDPEGsL4c3I2qxrloS53EF+M70PPuEsaD
        NfDebwUzymEiaC5MJRWTE/9oR3HxIRSQiw6h0u2rzvlUur0QxT3Rhd43kRqp+GA6Bhpok87RtHH
        tB+rE=
X-Google-Smtp-Source: ABdhPJyGSColFTLeHAgD8EbB5Ju9TVHlnVPlDbHBtRmBjeMxGYxkdp5KYHntohkuQpTKLaz7V74Qlg==
X-Received: by 2002:aa7:838d:: with SMTP id u13mr147684pfm.158.1598637219750;
        Fri, 28 Aug 2020 10:53:39 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e65sm88734pjk.45.2020.08.28.10.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 10:53:39 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 1/4] lpfc: Fix setting irq affinity with an empty cpu mask.
Date:   Fri, 28 Aug 2020 10:53:29 -0700
Message-Id: <20200828175332.130300-2-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200828175332.130300-1-james.smart@broadcom.com>
References: <20200828175332.130300-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some systems are reporting the following log message during driver
unload or system shutdown:
  ics_rtas_set_affinity: No online cpus in the mask

A prior commit introduced the writing of an empty affinity mask in calls
to irq_set_affinity_hint() when disabling interrupts or when there are
no remaining online cpus to service an eq interrupt. At least some ppc64
systems are checking whether affinity masks are empty or not.

Fix: Do not call irq_set_affinity_hint() with an empty cpu mask.

Fixes: dcaa21367938 ("scsi: lpfc: Change default IRQ model on AMD architectures")
Cc: <stable@vger.kernel.org> # v5.5+

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
 drivers/scsi/lpfc/lpfc_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 05ace6916b66..89c3ba0a0df9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11376,7 +11376,6 @@ lpfc_irq_clear_aff(struct lpfc_hba_eq_hdl *eqhdl)
 {
 	cpumask_clear(&eqhdl->aff_mask);
 	irq_clear_status_flags(eqhdl->irq, IRQ_NO_BALANCING);
-	irq_set_affinity_hint(eqhdl->irq, &eqhdl->aff_mask);
 }
 
 /**
-- 
2.26.2

