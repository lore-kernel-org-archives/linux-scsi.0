Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4452EC4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25C9260FE3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbhHIXFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:00 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:40660 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbhHIXEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:51 -0400
Received: by mail-pj1-f51.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so1411465pji.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wjHPmJeqPk5ydGEPAsbeM+wR0ly8Ex7oFJ5KgXs11aQ=;
        b=L2T0ShgLnuCCVmV0zEbpGwUlRO20uFnKc9xolPyRHsjVCAELe3fBbnrTdgAj370IaQ
         xyfExjHJnwtwD5RRw06nM0GdgNORRzO0QkpohYeZp24ly5Ms//OPXio1BaollnQIYktd
         2hEbhiGrS+4lof6pg6lKcYhhUW+aY+NM8Q2fj6tnQbLfGG0vEM4zsw5Xn2+GHuzRh0qI
         bvb+H3BJ//sBVcr2/UyWzKHqGypNnYjMifFO6bi1cgBkusUuoMbVma4e41MOJn/3F5ya
         zbiDivJgifTvlnkfoyrzDbe/NdSKVFOXhPpIINvuhrwq8yF5lfHIyEQAIbifZ8lIxs0z
         ek1Q==
X-Gm-Message-State: AOAM530BEw5TIuAPWDxGAr8G8X1YAOwLewtYchH5BGu63yPmiedg8tQw
        0YDYVhr8sW8e7aNf5ywWSa4=
X-Google-Smtp-Source: ABdhPJz/mX/hbrsgcj8T0EGKuA0IddSDQJt51pJEosLgD08VBJtQXaBEa6k5gpCBEO2JLa1OSzk+lA==
X-Received: by 2002:a05:6a00:d77:b029:3cb:5f59:e1e7 with SMTP id n55-20020a056a000d77b02903cb5f59e1e7mr8993341pfv.5.1628550269749;
        Mon, 09 Aug 2021 16:04:29 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v5 17/52] csiostor: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:20 -0700
Message-Id: <20210809230355.8186-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 56b9ad0a1ca0..3b2eb6ce1fcf 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1786,7 +1786,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 	struct csio_scsi_qset *sqset;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 
-	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(cmnd->request)];
+	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(scsi_cmd_to_rq(cmnd))];
 
 	nr = fc_remote_port_chkready(rport);
 	if (nr) {
@@ -1989,13 +1989,13 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		csio_info(hw,
 			"Aborted SCSI command to (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			cmnd->request->tag);
+			scsi_cmd_to_rq(cmnd)->tag);
 		return SUCCESS;
 	} else {
 		csio_info(hw,
 			"Failed to abort SCSI command, (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			cmnd->request->tag);
+			scsi_cmd_to_rq(cmnd)->tag);
 		return FAILED;
 	}
 }
