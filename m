Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2C7C25B0F
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Aug 2022 06:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbiHNGob (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Aug 2022 02:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240244AbiHNGo1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2022 02:44:27 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B290D5FAD3;
        Sat, 13 Aug 2022 23:44:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ch17-20020a17090af41100b001fa74771f61so266645pjb.0;
        Sat, 13 Aug 2022 23:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=8w69UxMgS/IUHtw9ds2dBjBRrqH0ahgGAwwqZA/txFQ=;
        b=aKKQz5sFQCVaTceIOoVbWkOV3QFKZDWPRq1urXbfMFSBC7wIGRp8tsO2Alk6zbu3o9
         PjFri5yx0tzYG72rSP+VKd7/HoED9DYtZn/fi2v6C6XjyCDYthz7fxfqUbSABFurUxtO
         SqCnN+m6DqDJRV1kfAA08mZVpl0zK4ASReMxxzU5PXDkhu9HRM03muCuq88aQPJY6Blj
         KbB5o9GCYHBoiwLqSvamKcbujJ55J2onSG9uNaAx5Oo2WSmZPbDFPzAWRar5ssw5/7HH
         pERKfc3ybed76W3+KWN+KT/F6lU6vN5jpYiHYe495ZUfmDaIRzlji/94bxd4O5g1x4yQ
         We9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=8w69UxMgS/IUHtw9ds2dBjBRrqH0ahgGAwwqZA/txFQ=;
        b=2y4lm0Cl+16owL6vjB+my8O/4JiK2pi/hTJfTEpmZPz8tBZOzN48r8kx22AvSlBkPD
         njMy9h0/mfKcJFFn+FpwdrGM/9H7qxC1WKhBxT+4CumnF92oY9zoSojgfAH2CVsFqo4f
         01kiRjam8Vhxry1VFpB9xG8KWYRL91erh/FMB1QrTPbE2Uz2UBEcipig2LIHYpavYmDc
         zCskNlgmB643RKq8ITgc9u1zinJ5PAHSUnWonH+z/sCWzS/WymfbnQ7PXF5homkozHsR
         RBFLFjb+Cy7+C497dW8YincKGJXdDvjMuaAJbwYVjWpmtAdvwIVuEl6X3tfd7Qe49eqI
         XKtA==
X-Gm-Message-State: ACgBeo2F+WeH+fTIr5BfkvHw1Ln9YfUSNqK8TCifSaA9MrUmy/c0TcW2
        XjwxCHkfQQxb/ZDy0gPmSm4=
X-Google-Smtp-Source: AA6agR6Jn3ZfRkr3Esc1AnXnpCacJ/RYaHz3m4BC1Ktg7WZ0a4caJ0bbcvxNnWE1fYzjRAY7WRrk2g==
X-Received: by 2002:a17:90b:152:b0:1f3:2b02:90fe with SMTP id em18-20020a17090b015200b001f32b0290femr12300966pjb.198.1660459466184;
        Sat, 13 Aug 2022 23:44:26 -0700 (PDT)
Received: from localhost.localdomain ([182.160.5.243])
        by smtp.gmail.com with ESMTPSA id o27-20020aa7979b000000b0052d481032a7sm4593778pfp.26.2022.08.13.23.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 23:44:25 -0700 (PDT)
From:   Tuo Cao <91tuocao@gmail.com>
To:     James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        khalid@gonehiking.org, willy@infradead.org, hare@suse.com
Cc:     anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        91tuocao@gmail.com
Subject: [PATCH 2/9] scsi: a100u2w: move spin_lock_irqsave to spin_lock in interrupt handler
Date:   Sun, 14 Aug 2022 14:43:30 +0800
Message-Id: <20220814064337.32621-3-91tuocao@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220814064337.32621-1-91tuocao@gmail.com>
References: <20220814064337.32621-1-91tuocao@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

it is unnecessary to call spin_lock_irqsave in a interrupt handler.

Signed-off-by: Tuo Cao <91tuocao@gmail.com>
---
 drivers/scsi/a100u2w.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index d02eb5b213d0..391c094758c0 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1055,12 +1055,11 @@ static irqreturn_t inia100_intr(int irqno, void *devid)
 {
 	struct Scsi_Host *shost = (struct Scsi_Host *)devid;
 	struct orc_host *host = (struct orc_host *)shost->hostdata;
-	unsigned long flags;
 	irqreturn_t res;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock(shost->host_lock);
 	res = orc_interrupt(host);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock(shost->host_lock);
 
 	return res;
 }
-- 
2.17.1

