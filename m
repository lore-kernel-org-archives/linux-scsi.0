Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6C7C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1038061107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhDTCPD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:03 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:43666 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbhDTCPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:15:00 -0400
Received: by mail-pf1-f176.google.com with SMTP id p67so19540278pfp.10
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E8eY+3b1e1VB8Xgf2jPBHrqijd11LuHKYiSCjB5BH8Q=;
        b=GBwu/2qyYFI1i22o7pIWHu5JKFT5znEKPk+S5lHdGRnws509vMCfqBWAgI8CnaTZpm
         5+38Je+A9M9GqCdySOQhafQAk+3ipTWbMeUyaIeSIqO4qGJ/SvO270GIuhkR0ghqchdQ
         DMdbbaRnrml1VeU+8Rivp3FqbnjuxHNLK+ohrZLIgrppzL+dewbDScDulnRujmRSONHL
         FxuN1noQRYs8wTC8/gRkq15BgPQvI1RRBLHc18dNFvBz86obP5EduhvES3+PTeDO0Wec
         HloOhHcl3H58LpKzJMMHB9JKteA2YG/n/+1KaE18zfh9NDAtAUFf5jseabwqlo2+2Ncu
         FleQ==
X-Gm-Message-State: AOAM532//r8NT4yO02kIaDdJy7QPR3UldVEf8sOiWDQq+AKYTSVoCgiv
        sLg60X1vDX3kS29KRA8LyC4=
X-Google-Smtp-Source: ABdhPJy04JLKc8lhi72vGOQO+quk7anQgV0+KK0ruBSqR+miMYrpnG4GZChsc0I8LDzKyTtGiM0UBA==
X-Received: by 2002:a62:e40a:0:b029:263:e573:e1c9 with SMTP id r10-20020a62e40a0000b0290263e573e1c9mr616214pfh.74.1618884870189;
        Mon, 19 Apr 2021 19:14:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 108/117] xen-scsiback: Pass union status to the {status,msg,host,driver}_byte() macros
Date:   Mon, 19 Apr 2021 19:13:53 -0700
Message-Id: <20210420021402.27678-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/xen/xen-scsiback.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 55a4763da05e..835bb6d6a895 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -217,7 +217,7 @@ static unsigned long vaddr(struct vscsibk_pend *req, int seg)
 	return vaddr_page(req->pages[seg]);
 }
 
-static void scsiback_print_status(char *sense_buffer, int errors,
+static void scsiback_print_status(char *sense_buffer, union scsi_status errors,
 					struct vscsibk_pend *pending_req)
 {
 	struct scsiback_tpg *tpg = pending_req->v2p->tpg;
@@ -336,17 +336,18 @@ static void scsiback_cmd_done(struct vscsibk_pend *pending_req)
 	struct vscsibk_info *info = pending_req->info;
 	unsigned char *sense_buffer;
 	unsigned int resid;
-	int errors;
+	union scsi_status errors;
 
 	sense_buffer = pending_req->sense_buffer;
 	resid        = pending_req->se_cmd.residual_count;
-	errors       = pending_req->result;
+	errors.combined = pending_req->result;
 
-	if (errors && log_print_stat)
+	if (errors.combined && log_print_stat)
 		scsiback_print_status(sense_buffer, errors, pending_req);
 
 	scsiback_fast_flush_area(pending_req);
-	scsiback_do_resp_with_sense(sense_buffer, errors, resid, pending_req);
+	scsiback_do_resp_with_sense(sense_buffer, errors.combined, resid,
+				    pending_req);
 	scsiback_put(info);
 	/*
 	 * Drop the extra KREF_ACK reference taken by target_submit_cmd_map_sgls()
