Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E01C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjCITbX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCITal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:41 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E426FC238
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:50 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id h11-20020a17090a2ecb00b00237c740335cso2914492pjs.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C5gBIhC8WBeIKUevKHd/72SKoMXkdl9EMvIEJ27ZMNk=;
        b=w7DHC539dKLS+7hFJ2ownqCeNYuH9+cxOWXjqmSrcxkTGJnHJ7fUD9xwgbDKUSIg0L
         qb5CG2a80V7cwI4jj30/ccWfZmzbEuMxKODTWtabJtixK+uOiRpebvP64pB4vNClE9/V
         fsDt+x78FbF9PmyHWRBlnhqhGZXdGRuaLmxWfUBJvxP3QtMWNmblyCaM3ceL3IECJFB2
         QqGoEQyPaG9+tDXe1g64QcXNXC/7MqmAIC7/zEB631H23JwslhU4z9U1bufB8KVJ9n90
         Ulilu/SLmuJyAKUyRPPTy1aLPxoCP+DHZuHuVtZsMAKnHCi6wU0HeTcM0yN4Vg3l0E9i
         NBlQ==
X-Gm-Message-State: AO0yUKWspvIRY/mRJeQ++P68oXqDnAKARnxJy38bT9AwI9Cdli1G0WFe
        5z5wLAWxl5C0cZ171skEy0Q6/BFo1fUgJg==
X-Google-Smtp-Source: AK7set9dpAVotKOJbFxoGPG8ChvnFupKSaBaT1QAizk2kjrChcjGsuIbqpSqBHpTmQxFbbVd43axwg==
X-Received: by 2002:a05:6a20:394c:b0:d0:61ff:8535 with SMTP id r12-20020a056a20394c00b000d061ff8535mr9736680pzg.4.1678390189389;
        Thu, 09 Mar 2023 11:29:49 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:48 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 64/82] scsi: pmcraid: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:56 -0800
Message-Id: <20230309192614.2240602-65-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 836ddc476764..23c5230dbed4 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3611,7 +3611,7 @@ static struct attribute *pmcraid_host_attrs[] = {
 ATTRIBUTE_GROUPS(pmcraid_host);
 
 /* host template structure for pmcraid driver */
-static struct scsi_host_template pmcraid_host_template = {
+static const struct scsi_host_template pmcraid_host_template = {
 	.module = THIS_MODULE,
 	.name = PMCRAID_DRIVER_NAME,
 	.queuecommand = pmcraid_queuecommand,
