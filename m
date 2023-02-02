Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCB3C05027
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 22:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjBBWEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjBBWEY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 17:04:24 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044192112
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 14:04:23 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id cr11so2240462pfb.1
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 14:04:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ytCOiZJ1WifCB+TWywk21iV9Aj5DrSnqXQF29cwZH0w=;
        b=LkenMa+ZzVk3mDXpanb7wuS08cNwv1+vYqNUsKCQpgc+ecqFNEJQHvVKO14Egzqu7B
         /bUkwvNqeFSrAuuQscgEj7zZrcY3pe3evSl5jrSL0hUO2tkbfltV0UqcPC9dWDeovsBx
         7hxXook5tOU10UDy9FFHK5l/fOYWAOvRar1b+CxkKLsvJ/dYVvWaCghD5FVUvtZInZp1
         wQGDo3chf6R1uEmTZV/xXPtI5XiEzimj/Y5wKXjfcS9pandDdkzefZV4wsWcH/tt964w
         /oBnIyxL4zclUVC3rRps1wNt9NwXMq5pZJ09/PDp/oDODiVucTnzxBOFxR8GVosz3B+o
         yN8g==
X-Gm-Message-State: AO0yUKW39kWtd7qfqeRK3mUMfQyVFgS49E/MWNUUeu5pjHxa6QFFLXXA
        hlDYosAd+yzGiXrOkRZsiMQ=
X-Google-Smtp-Source: AK7set8GfoK/Lu/M3YZZONtxHZCPrLsfn91D8id+HH3tWweJd8Gl5OLnhKqEZ5Qm83UHUh0L3hRC4g==
X-Received: by 2002:aa7:9407:0:b0:580:d71e:a2e5 with SMTP id x7-20020aa79407000000b00580d71ea2e5mr6257493pfo.22.1675375462421;
        Thu, 02 Feb 2023 14:04:22 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id x28-20020aa78f1c000000b0057fec210d33sm160530pfr.152.2023.02.02.14.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 14:04:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 1/2] scsi: core: Extend struct scsi_exec_args
Date:   Thu,  2 Feb 2023 14:04:11 -0800
Message-Id: <20230202220412.561487-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230202220412.561487-1-bvanassche@acm.org>
References: <20230202220412.561487-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI LLDs to specify RQF_* and SCMD_* flags.

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 3 ++-
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index abe93ec8b7d0..5feb8be6d956 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -229,8 +229,9 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
+	scmd->flags |= args->scmd_flags;
 	req->timeout = timeout;
-	req->rq_flags |= RQF_QUIET;
+	req->rq_flags |= args->rq_flags | RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7e95ec45138f..79260e98774f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -462,6 +462,8 @@ struct scsi_exec_args {
 	unsigned int sense_len;		/* sense buffer len */
 	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
 	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
+	req_flags_t rq_flags;		/* RQF flags */
+	unsigned int scmd_flags;	/* SCMD flags */
 	int *resid;			/* residual length */
 };
 
