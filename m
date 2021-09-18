Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B42C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22F3861164
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242692AbhIRAHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:46 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:42809 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242793AbhIRAHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:44 -0400
Received: by mail-pj1-f47.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so2931109pjv.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kYLCJrelhZyfUbYgWeKzwy/9UHYa6/H2nyik2Rb13cQ=;
        b=MUOS8Dm6fXmMoBm6zk7jtO4u9FnpJ5zIGNyfwhdLfchWLp2RJsyU5G8HkQ1G8PXVGH
         NYnVOsBpBz0gXYWVHDUd6+vCAi3aaps3jjh7O2Kl0Eul7CUV0DjdQvoMO9bmJ7IQXnMc
         gWmxJlqeghzwnHDg/ifgS7RHUNNvazlmrcjjUYGcvMxZB0hEDeS/DXeHymo9m5u6YcFf
         tZYugK0nyxVGL+M3Bm4KABtiDiAppTS3w0Be6rBj/4bSeQRT+A4sX+uLco+B6CSWBIhJ
         7oFvnfDZ4o6Pej/TZc055AqU06OYtaX+cAqr0gsHMa1B7hPEqs567SKGP3oUNNzqwJ+y
         C1EA==
X-Gm-Message-State: AOAM533B/++BA5JvSWnWntNTTE3pioiYqMh09zjKNoUuUw7PbTwXeZbe
        +9HIyqCKfv4or9a2Q855cCA7MzrFe8k=
X-Google-Smtp-Source: ABdhPJxXsZuMLW/Clh7H4inH+Xrmmf3pgyD9fj61EQVk4sKNH2JFctzIP7JbEfQdIH1UpvQ8JO++Rg==
X-Received: by 2002:a17:90a:16:: with SMTP id 22mr24459662pja.25.1631923581265;
        Fri, 17 Sep 2021 17:06:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 05/84] firewire: sbp2: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:48 -0700
Message-Id: <20210918000607.450448-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/firewire/sbp2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 4d5054211550..aeed3f2273e8 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1375,7 +1375,7 @@ static void complete_command_orb(struct sbp2_orb *base_orb,
 	sbp2_unmap_scatterlist(device->card->device, orb);
 
 	orb->cmd->result = result;
-	orb->cmd->scsi_done(orb->cmd);
+	scsi_done(orb->cmd);
 }
 
 static int sbp2_map_scatterlist(struct sbp2_command_orb *orb,
