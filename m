Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FA1C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 12:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1716D60FE9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 12:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhDTM33 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 08:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhDTM32 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 08:29:28 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C87C06174A;
        Tue, 20 Apr 2021 05:28:57 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id m11so25444874pfc.11;
        Tue, 20 Apr 2021 05:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=yKSbPOSK7MpUKuWddMMeJqmMmatdqHxk/RMpzGE8ZVQ=;
        b=CJ1GYO/PbUr8Dl7VB+8JFcRr35+7FKhK73AJKHxi8NmhzpW31fN8KuU49fNxuAKbr8
         94W1Zhzmck5i3xPcMpZJt0qM5UzQXcDeWgIyFg8YTYruerZNSIJQWGBMk4qz8yIqRtVf
         AEZ1gDO7/0D3MMvHUZSXYufNLkdj0Ru7VbKEB3VQG5KzDS+dK3tllkNycpoew1zK5DUk
         BH34/TbJswk2rqbhNegVDo/T+GYOBrRr3Uf06EHLqLADpfWx/SF21X+oZozT/nZUNyX0
         Eo3fKnHjKpZI/vrqKEk53FevVr2ZwcKRg5zW3ad8MQR22e2RNE+NKmEeHquwEoi0YQnE
         MoSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=yKSbPOSK7MpUKuWddMMeJqmMmatdqHxk/RMpzGE8ZVQ=;
        b=BwuG7CpOcEq7hoF7aovjdVpiXXqABvtTm7cREkeMMeWdpNiVp9Q6dagRSW6VsxABvz
         ReKwY3le4weW6HE89FsE4ATpY3pBk1w7Hx/XHdTd5ew91ZitA20ZEjKLPdjCJp4Al4me
         OrLsqu5i1SH1LFoddHBStd/j/8JmTCtacmt7hNosLqp/ZrYreEJFd6L9xS4xU+M5npJw
         RGq6wNkMionDtltEcs5RM6q6nmGJlm2+BDQ7AlDL/26bTn0puQBsA2mdsNryxI3IK4av
         KUo1kTv7VGBgs+OSwUcidxXrfpl5QJBm6Hdq02Sm6hjTpFtrCHTIlPuKnKHZLAxgWxQh
         q9OA==
X-Gm-Message-State: AOAM532+ajUYYAhm1KF2nW5XOPShzUmZQ1CG+S9c/yPxcs8KJnu6P/bA
        LDtj7UTUqS7rgM9P0JjTVFc=
X-Google-Smtp-Source: ABdhPJy1BT3K9zG7Np8t0pJaeh8z/TOoCtWE9fxFAx34e3kEs3F8Ap1B9wc6gmUWQ4+a3bfNxPIC6Q==
X-Received: by 2002:a62:7e53:0:b029:254:44f:23da with SMTP id z80-20020a627e530000b0290254044f23damr24909517pfc.38.1618921737102;
        Tue, 20 Apr 2021 05:28:57 -0700 (PDT)
Received: from localhost ([157.45.118.103])
        by smtp.gmail.com with ESMTPSA id m15sm2541307pjz.36.2021.04.20.05.28.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 20 Apr 2021 05:28:56 -0700 (PDT)
Date:   Tue, 20 Apr 2021 17:58:46 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: target: target_core_pr.c: Fix tabspace error
Message-ID: <20210420122846.gjh6pmzz2w37tqc5@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tabs have been used to replace spaces.
This is done to maintain code uniformity.

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 drivers/target/target_core_pr.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index d4cc43afe05b..6538b2be1634 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -539,18 +539,18 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			return 0;
 		}
        } else if (we && registered_nexus) {
-               /*
-                * Reads are allowed for Write Exclusive locks
-                * from all registrants.
-                */
-               if (cmd->data_direction == DMA_FROM_DEVICE) {
-                       pr_debug("Allowing READ CDB: 0x%02x for %s"
-                               " reservation\n", cdb[0],
-                               core_scsi3_pr_dump_type(pr_reg_type));
-
-                       return 0;
-               }
-	}
+		/*
+		 * Reads are allowed for Write Exclusive locks
+		 * from all registrants.
+		 */
+		if (cmd->data_direction == DMA_FROM_DEVICE) {
+			pr_debug("Allowing READ CDB: 0x%02x for %s"
+					" reservation\n", cdb[0],
+					core_scsi3_pr_dump_type(pr_reg_type));
+
+			return 0;
+		}
+		}
 	pr_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x"
 		" for %s reservation\n", transport_dump_cmd_direction(cmd),
 		(registered_nexus) ? "" : "un",
-- 
2.17.1

