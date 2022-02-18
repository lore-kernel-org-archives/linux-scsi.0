Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AE6C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238299AbiBRTwj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238310AbiBRTwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:31 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00C2291F85
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:13 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id l9so8014558plg.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mPpFGanc5O2VtDF8xLPur0DYQVt1vugjv+KVWyukjrk=;
        b=G7lDdMSsg9Mukpo/Vyx5SkrzVfGGRDRR7oO8sx/w+bhOdTe5s7qgLLiJ/l9/O7I2PX
         GP0CqBShktsZdhZrfIlOCenZzv/a8nQDltQ82vD91m8c96IB5CCCeKp1aFDwu/YkbqXr
         NJx+gGCk/kxXVXZkud2CSdSrJf9dNebtT4W6lXe+2c1M9FCNUlh6m5Z2QPPyaenIk6m0
         olg6/rUYMpoB6kRZbxndp/kpEDIE41X5mLmZPt8r6H7XcOS/1T6XelP9PLCr/HNAunm4
         Gfnmc1XEXXzmvQE8UsqbUSkkUNP9HE2N44679ZTroNOYnrMNzNfOWJCBKrp6SaPtc0b+
         ZE4A==
X-Gm-Message-State: AOAM530/Q4ARdiGshveOLrvJrlZZqPNGvRmJUV89Gw2ljQJ/My+4Qg+Z
        CYynPW/2LxEWSa3+NISvV8M=
X-Google-Smtp-Source: ABdhPJxHWHwoHvtpMzFg/HT3yrP6tx9IkW6LUaIXwfObY70zI+ASkmUzB44Yk97LcVdcuhm8WaQObg==
X-Received: by 2002:a17:902:e748:b0:14d:7e1d:5d83 with SMTP id p8-20020a170902e74800b0014d7e1d5d83mr8687323plf.103.1645213933124;
        Fri, 18 Feb 2022 11:52:13 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hiral Patel <hiralpat@cisco.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH v5 21/49] scsi: fnic: Fix a tracing statement
Date:   Fri, 18 Feb 2022 11:50:49 -0800
Message-Id: <20220218195117.25689-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Report both the command flags and command state instead of only the
command state.

Cc: Hiral Patel <hiralpat@cisco.com>
Fixes: 4d7007b49d52 ("[SCSI] fnic: Fnic Trace Utility")
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 88c549f257db..549754245f7a 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -604,7 +604,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc)
 
 	FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
 		  tag, sc, io_req, sg_count, cmd_trace,
-		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
+		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
 	/* if only we issued IO, will we have the io lock */
 	if (io_lock_acquired)
