Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F209FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354136AbiBKWd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354129AbiBKWdz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:55 -0500
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBD2D54
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:53 -0800 (PST)
Received: by mail-pf1-f171.google.com with SMTP id 9so15762184pfx.12
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mPpFGanc5O2VtDF8xLPur0DYQVt1vugjv+KVWyukjrk=;
        b=RzqZ2QHm5gO/sqQ1wf3X3KXPurk1tP7LvG6Vyj83DNKod5bAdQOZi2LdIC5OhzjEoz
         W4a5PJz9OBgamU58+TSGQWPxUp3Ztd3JWxp3+tosVGeKUcbdkW9BnmwIFVXaV8cCYwmF
         O0Dv6eO5y3uIPFUhWyBS5x2mcqYgewKb++6hyjYpKVr7uPF3ooYzwhWtcKOEEfKYzSNk
         8oVNeHZkNPU0e4awLnTyuMTk40Y78Z0QDITwJM8BLvqZCeqJPlCRZhzwQ1AdartBMm22
         9rSvWsj5nOMCPu0VCBzoHfFJLTpCoP4G5ZRLGFsaG9eJjeXQKuGqqde91gPK5Vplpj1G
         0lrw==
X-Gm-Message-State: AOAM530p2cuFAZkRyod4pKRr7uRvRxwdPCa6weeod+n759DOnK0sTvs8
        dngOJFCtxxGkkzmmRMdrtMg=
X-Google-Smtp-Source: ABdhPJxcUYTY9pz0WH0NQ9fnO2vLiZQ6oaalCZ3O1734dXOy21eSoTMe486dTpFfpkcjUOdUAT3r9Q==
X-Received: by 2002:a63:4c41:: with SMTP id m1mr3061935pgl.52.1644618833298;
        Fri, 11 Feb 2022 14:33:53 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:52 -0800 (PST)
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
Subject: [PATCH v3 22/48] scsi: fnic: Fix a tracing statement
Date:   Fri, 11 Feb 2022 14:32:21 -0800
Message-Id: <20220211223247.14369-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
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
