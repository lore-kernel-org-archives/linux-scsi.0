Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DB8C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 18:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjBISxm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 13:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBISxj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 13:53:39 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71AB1E1E1
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 10:53:37 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id pj3so2988217pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2023 10:53:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xIImaOy0qhbbIZG+o8zbEkqUy2VtEOpF3HJ9A/6L4T4=;
        b=wvmZ9LgKp8yZqoq15DlYTiHTI/KBlL2WAc8OShKWanKpvgzgwU7IhbVBeeohqPgKuS
         qdikUYgLmNmx6kIjP7/WaDVHA4SJEveV44xFobYYVWwPS1yTzjhvyzgf3rJdNU/wZEUo
         g53vI3S4+jUEIRwhEOD2JCdCo8pxyjZwAvs3rHD6Fd9pjQ+Ew9i4BlQrMk66GA0w7JcG
         22qmaySpjE7otSVuTUJye53sBz2L6DZi2v1FbG10oUkTivGHAwWEm5p15nG3VpshcZiU
         Q0ES8YENDTbuvqi5J7AoC8PfDy6Att4HhSKtj/M5SWQQj5kNF6Svore9GoKf+TtqrGxI
         ZtqA==
X-Gm-Message-State: AO0yUKWgecEurModYjzp2FowFREs0S8M3V2ztzyZGQuKxZw34z5u6VKr
        chv4AO61JP944/meY3lfpLs=
X-Google-Smtp-Source: AK7set+ilB4esSywzdIxyYBwFvpmlz0/ipJQDfdvYBUhDxTc19wJ+rL1aoXGzJpYDPzbHrxyOvOaMQ==
X-Received: by 2002:a05:6a20:8f13:b0:bc:7371:e3d6 with SMTP id b19-20020a056a208f1300b000bc7371e3d6mr12881673pzk.55.1675968817155;
        Thu, 09 Feb 2023 10:53:37 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:15f5:48f5:6861:f3f6])
        by smtp.gmail.com with ESMTPSA id x18-20020a63b212000000b00478162d9923sm1603988pge.13.2023.02.09.10.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 10:53:36 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 1/3] scsi: core: Extend struct scsi_exec_args
Date:   Thu,  9 Feb 2023 10:53:26 -0800
Message-Id: <20230209185328.2762796-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230209185328.2762796-1-bvanassche@acm.org>
References: <20230209185328.2762796-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI LLDs to specify SCMD_* flags.

Cc: Mike Christie <michael.christie@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>
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
index 7e95ec45138f..c7bfb1f5a8e7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -462,6 +462,7 @@ struct scsi_exec_args {
 	unsigned int sense_len;		/* sense buffer len */
 	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
 	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
+	unsigned int scmd_flags;	/* SCMD flags */
 	int *resid;			/* residual length */
 };
 
