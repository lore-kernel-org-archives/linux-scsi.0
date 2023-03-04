Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F3DC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjCDAgH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCDAfW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:22 -0500
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA8C5F206
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:46 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id h8so4513988plf.10
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4RbMXUm7pqAemtbTxFEHuwxSO+lKtdQq5rpNrosHYA8=;
        b=HeR7cvs6w0IObf2P4Vu7cCTXGrQ8geXIIub90NRhBFrFzwM7lX2e6YcjU0zsW9lDSv
         t2ajZKWJpVMn2yvLxpcUkXgYJpwzfYhsWtX3XPp7T7L8LMB+236JCLIbdw2ioxkoettd
         xA2fQyK4ffho+uQPJjcAiq9/tOKFAyRHMNJmlpqKEZPmNFJddGvT7ps8OeY5Z0ECN8aV
         GR131fXnriJ7T6TukgdF/GzAwJbb/mcaJjlMxL3Xnrxly6kXuGVCVjJqQMwXs74BYA3t
         nUMQ4RzRQZqqqukWdx1O6PxWWsOQnCJZfWuq4j4eizFOVgQakE3LRKqz3kqL/C4TJ295
         BBEg==
X-Gm-Message-State: AO0yUKVQUVl+OxnGdTG4nyHrnlXd6XNkxqjLb4FRoITun20oI8BQleUw
        E0o9BnC621ABLsQn2gwoWj+dSdXma84inA==
X-Google-Smtp-Source: AK7set+Ej6DfCvHZY5Ttev/EoYuOnOQN6rz9VkflbbDSWypfnu1k6HkYgrg524uhCnf8TIvaKI1bgg==
X-Received: by 2002:a17:902:7605:b0:19a:f02c:a06d with SMTP id k5-20020a170902760500b0019af02ca06dmr3338375pll.29.1677890086171;
        Fri, 03 Mar 2023 16:34:46 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:45 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Charlie Sands <sandsch@northvilleschools.net>
Subject: [PATCH 77/81] scsi: rts5208: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:59 -0800
Message-Id: <20230304003103.2572793-78-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/staging/rts5208/rtsx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index 2284a96abcff..db2dd0baa8be 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -191,7 +191,7 @@ static int device_reset(struct scsi_cmnd *srb)
  * this defines our host template, with which we'll allocate hosts
  */
 
-static struct scsi_host_template rtsx_host_template = {
+static const struct scsi_host_template rtsx_host_template = {
 	/* basic userland interface stuff */
 	.name =				CR_DRIVER_NAME,
 	.proc_name =			CR_DRIVER_NAME,
