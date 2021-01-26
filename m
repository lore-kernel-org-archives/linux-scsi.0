Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4BEC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 00:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B9D22597
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 00:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732745AbhAZAHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 19:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732672AbhAZAHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 19:07:43 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DD8C06174A;
        Mon, 25 Jan 2021 16:07:02 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id r9so11079827qtp.11;
        Mon, 25 Jan 2021 16:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N6LXBrjg+bB/2+WBjCTrxF6qvgdWtiQma/8rh0wKxUk=;
        b=hW/YdWhwfBFWw3mYF6n5RNvWDzReO5HABiplOpXnk0/ieoSFPQsH1IvkMaM3AMykKC
         xy09myn4AaRDPUrNAC+bKbY2CAunsU8/xTN3ZeZnnjjqXIyPHcZuGdrbeo7EVgjRCjSy
         h0FDbG2H6SaSSEJcj8jOuoYHNUDKYwMIPctrkQQG/fs9HzwQeP4A99VWn7tY4+0Lcr3R
         aEr3G1IHUZjVLuyhaKBwcWXFACA2Uoj6j4pbOBALFmZRKeSJdpx7JhNl60HISl5XZFIX
         LO+jnjPfWUbid+35dE9V+BB9ie3dLUZaBTUdM9w/FD4zGKxYFkKCn/A6gJSD6YR+o/+2
         BJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N6LXBrjg+bB/2+WBjCTrxF6qvgdWtiQma/8rh0wKxUk=;
        b=gZqkvytEJ7HfJnSn7JaeExreZSL3wJ7DKB5A9fMA0q6GAerOFQP0A8AVPNj4QlOCRV
         /OEqgtjj3Z7joVz/vmkLn1eSmiDSrfR2Tjgz6sw9LMNxFu3Fq3JYMIhioWLMzHnwvr3q
         pskhiHVMRhxwV2GwP8MPBniv4bVY/nIPTKbFtFAJke1JNnfyfFJ+vg5dmCr9Oc3hF0pa
         w+B4O/DX4DtcsinnHXGlPToqZZt+40NgMiKihZisKCriQRrKcSp4AQKiUfdjs4gaOf8u
         teiFmyjjD0s8iXpXw3GQD1ysw7Tcuos0niXUU9oY5es7s5MUSZRXDfQBk7/K6mRmhLGf
         z6Hg==
X-Gm-Message-State: AOAM533rl9FeSs3oQosmuNnn5iiVCXwSV0wwy7u4eM56UrLU2PeGrgV1
        wACcuqu1GqM2YA7GfYIRADc=
X-Google-Smtp-Source: ABdhPJzGPNNQphuBVAFkY4woM8KHgzTBfveuo+G8JIC5qbpE+3i4pkNtg6YkvgrAGubfaLLObWZNuw==
X-Received: by 2002:ac8:6049:: with SMTP id k9mr2933402qtm.104.1611619622060;
        Mon, 25 Jan 2021 16:07:02 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:c7f3:98:3560:1329])
        by smtp.googlemail.com with ESMTPSA id t14sm3148128qkt.50.2021.01.25.16.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 16:07:01 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH v1] scsi: lpfc: Add auto select on IRQ_POLL
Date:   Mon, 25 Jan 2021 19:05:54 -0500
Message-Id: <20210126000554.309858-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc depends on irq_poll library, but it is not selected automatically.
When irq_poll is not selected, compiling it can run into following error

ERROR: modpost: "irq_poll_init" [drivers/scsi/lpfc/lpfc.ko] undefined!
ERROR: modpost: "irq_poll_sched" [drivers/scsi/lpfc/lpfc.ko] undefined!
ERROR: modpost: "irq_poll_complete" [drivers/scsi/lpfc/lpfc.ko] undefined!

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 701b61ec76ee..c79ac0731b13 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1159,6 +1159,7 @@ config SCSI_LPFC
 	depends on NVME_TARGET_FC || NVME_TARGET_FC=n
 	depends on NVME_FC || NVME_FC=n
 	select CRC_T10DIF
+	select IRQ_POLL
 	help
           This lpfc driver supports the Emulex LightPulse
           Family of Fibre Channel PCI host adapters.
-- 
2.25.1

