Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA9EC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6489961440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhENVf6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:58 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:37873 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhENVf5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:57 -0400
Received: by mail-pl1-f182.google.com with SMTP id h20so105086plr.4
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39CFdvPUx2YylU5fmmA6ia5kiG8IPH28yP2o/gwmaNE=;
        b=jF5mAamObq4WjFYzenL2/ir1yDkatGGD9PS6dWMb72pLp/U3WWLwRB49jRx06CbknJ
         QrVStJP2OF+KPMJ2cH6erSoV7avL94LndxDIDtU+FjsaHGy0NVVqv8OchMV7CAziBI34
         MoJ3SNOlYJDksjBgft47jtLPIpJj1HRqaqYLu1fRZIPPd2EWnMElYcGOWYUG5IAbchlk
         U/gd3josYePUeD6pEKf6FXasSKTdnehMk9FRWCJPHU3lBFeuKjk7UbP40dfydAw2h70l
         szvdkaqUVPkjz4I+dq8WiN94oFm34xdQk2ZMo3LRfUxEIxJ5fkPNupruZ7itchB8QKvd
         m/Hw==
X-Gm-Message-State: AOAM532PEKEtwm2bDdl8t7YNTrE4kbrKTh6KSHXRSF71HeUOuPwFses2
        RLZYjRf1JuiHQPLpnhJRlts=
X-Google-Smtp-Source: ABdhPJypq4+Him1LGOE2G3yyZhpZpPSb/x2XxLN8t8MpnTnhrvC1YHii8CGH1r3g9uXtXsLk8uiH2A==
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr21909887pjb.56.1621028085575;
        Fri, 14 May 2021 14:34:45 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 24/50] ips: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:39 -0700
Message-Id: <20210514213356.5264-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index bc33d54a4011..6bcc655d1f15 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3733,7 +3733,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 		scb->cmd.dcdb.segment_4G = 0;
 		scb->cmd.dcdb.enhanced_sg = 0;
 
-		TimeOut = scb->scsi_cmd->request->timeout;
+		TimeOut = blk_req(scb->scsi_cmd)->timeout;
 
 		if (ha->subsys->param[4] & 0x00100000) {	/* If NEW Tape DCDB is Supported */
 			if (!scb->sg_len) {
