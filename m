Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E19C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351555AbiA1WVo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:21:44 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:34415 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345207AbiA1WVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:13 -0500
Received: by mail-pg1-f174.google.com with SMTP id v3so6478155pgc.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NFKW4dOo/Xf01/0PtVmG2vqtR1RJIFHWVoQ11+RrB04=;
        b=uut7Difm/kh/VKwk/yrXhWmvyJfOllrdUWVOBAq11VaozzBJhZYn3V9BDpR2tD1coq
         VeVsc7SgH+2Rx1vjk1IFL6JEQtjAEiVqFutt2bf0umYXheXya4q0oF+au7J1AHKQi2+l
         KddZPDyhJ+E8Lm8gN/joeZQ0ETZh1K8Mqi6sFr64v6V+bnlOS4pC4XU0FaFoYdp484NW
         dIa4spPAvg/nVNaS1p4SsNBTfWWK0aB4g7y/TtXGLEgPKHUbAext2G4AEi42VZ81SKKv
         2U+MSlZ/BAr/1Bx7zUJRiFpJCeyReV9iHHbd8XDFxpbIFzBG6WN9sRujAbDZWGO+LALf
         3tmQ==
X-Gm-Message-State: AOAM530B/y9LKjzXZ7q6a8LlNhTLLOCXUCOi7GTY2uBQYCxauf4k9qcj
        g117yGVE70OShmx5nibO5XM=
X-Google-Smtp-Source: ABdhPJx+cyVr3lXYB0w5jf1c3ftCe+vJj5gYJA2TX6pMFcVDYLqyhiUBVc26JxMSslL0yt6xBOfE+w==
X-Received: by 2002:a63:8948:: with SMTP id v69mr8223333pgd.112.1643408472522;
        Fri, 28 Jan 2022 14:21:12 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hiral Patel <hiralpat@cisco.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 18/44] fnic: Fix a tracing statement
Date:   Fri, 28 Jan 2022 14:18:43 -0800
Message-Id: <20220128221909.8141-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Report both the command flags and command state instead of only the
command state.

Cc: Hiral Patel <hiralpat@cisco.com>
Fixes: 4d7007b49d52 ("[SCSI] fnic: Fnic Trace Utility")
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
