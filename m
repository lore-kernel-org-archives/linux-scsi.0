Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F14C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A38A66109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhDTAKz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:55 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:35495 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbhDTAKi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:38 -0400
Received: by mail-pf1-f179.google.com with SMTP id h15so6628690pfv.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y5gbjrHGltWhAYAfDTabb9y8W51n+dQFg5lCaUq104U=;
        b=PHI+tuWq7VlKqPgFbu5OkPHra6eBThsW0Wjr2M/f9vqnq1t0/zFHtOcZ+9D8OqLwfW
         R3mSJAoDAmECdNuv+7Y2617XQ7jwLZH7RaTRPJpZSA61HB87ImLpRDDPji/2PYGkA9AX
         F7mGEdk+UmDU6K+qkLR9o/2F5PRISBQgkcM35XoNCZKLYtLPz4B2TNs7GU2xATnaEE+s
         d3df9r5oxIp/BIJkE1AZ5dNjF+f9CcZ8G+ACYbTX5/xodkdKbFij3oyZMg3jbQLZltYY
         8mhFOMg5Z1wvCXdZL5FxN6SFx/NGJpiPKNcH9bCNiLijIzCs9Z9xhWOWvm0yYYjYHRC+
         7HEw==
X-Gm-Message-State: AOAM533/c+660rm2Z3DEHcoA8FONCzPNuGO+7A5MQYOubitF/fSgvsmW
        l0SNzdER9xmByfYa7PN1iu4=
X-Google-Smtp-Source: ABdhPJxSJoMpJcrTgZXVHaMxOklJFaWgqnGHZ+PoLogLLxPxQwSs7krTWTnTcP5WEIPlDyJ5uAFMOw==
X-Received: by 2002:a63:da10:: with SMTP id c16mr4731738pgh.221.1618877407902;
        Mon, 19 Apr 2021 17:10:07 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 066/117] mac53c94: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:54 -0700
Message-Id: <20210420000845.25873-67-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mac53c94.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index ec9840d322e5..294efd192cae 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -347,7 +347,7 @@ static void cmd_done(struct fsc_state *state, int result)
 
 	cmd = state->current_req;
 	if (cmd) {
-		cmd->result = result;
+		cmd->status.combined = result;
 		(*cmd->scsi_done)(cmd);
 		state->current_req = NULL;
 	}
