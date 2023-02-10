Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5650C05027
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 19:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbjBJTda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 14:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbjBJTd0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 14:33:26 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A993F6E8A2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 11:33:24 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id o13so6264865pjg.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 11:33:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=szdaICogbPof18r939EFJ5SC6zk5rCW2yG+y+ESrn/0=;
        b=SQPDhzdj0DoBm7oPfXarmH9dWb210835wNDYAgwq4FPjDCJN+lIgFBTRqsKr22ieIl
         MqSFG/wqADiivRM8O7cEFUO8F4WRpSctvB7bErWQnjCTMwUhnHN0W+xqRaFI+UwG7HkF
         9/NvKfqqYoFbsuwU0FmacoajN4Gy7/FjmugIMaPhREje9ZgMmLNJkSLPMDr50brrvn40
         +pOb693msuOLxkSELLGqCc0yuwXUV2yepU+UrKn9l+ygnPuIs7CKJIYXY3HQeJtFheSp
         e3DMTUHXWtfzXHlm9NsBiJxamZVOxQz70TIVJ3/u4drkpnf66es9/jM3gHSagxias4H8
         370Q==
X-Gm-Message-State: AO0yUKUwT4JSMJRmjLycIQsPPpg64tUDTbRHXjVhkRTCs5msrhCXBH7R
        2wpGmjmXan1jEptJSwVbOhs=
X-Google-Smtp-Source: AK7set87Cvct75aaNrzn93zR1r+FTrYyf0ATFqcR+ZFHbtWpjiMyufZkSyCBHf8VMoNyqDZVk5RxtQ==
X-Received: by 2002:a17:902:e881:b0:195:e9d4:5380 with SMTP id w1-20020a170902e88100b00195e9d45380mr18015036plg.56.1676057604111;
        Fri, 10 Feb 2023 11:33:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a834:2664:42:db8b])
        by smtp.gmail.com with ESMTPSA id w9-20020a1709029a8900b0019605d48707sm3718356plp.114.2023.02.10.11.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:33:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 1/3] scsi: core: Extend struct scsi_exec_args
Date:   Fri, 10 Feb 2023 11:32:56 -0800
Message-Id: <20230210193258.4004923-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230210193258.4004923-1-bvanassche@acm.org>
References: <20230210193258.4004923-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI LLDs to specify SCMD_* flags.

Cc: Mike Christie <michael.christie@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 1 +
 include/scsi/scsi_device.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index abe93ec8b7d0..b7c569a42aa4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -229,6 +229,7 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
+	scmd->flags |= args->scmd_flags;
 	req->timeout = timeout;
 	req->rq_flags |= RQF_QUIET;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7e95ec45138f..de310f21406c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -462,6 +462,7 @@ struct scsi_exec_args {
 	unsigned int sense_len;		/* sense buffer len */
 	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
 	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
+	int scmd_flags;			/* SCMD flags */
 	int *resid;			/* residual length */
 };
 
