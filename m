Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBC8C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0296B6143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbhENVhZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:25 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:42890 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbhENVhO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:14 -0400
Received: by mail-pf1-f180.google.com with SMTP id h127so643205pfe.9
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:36:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=42ckW6LU8oo00tgEtvvvObYtPpqzKDgelcuguXzF2mk=;
        b=VnqV1CrcYu+tyzKhd6K55D9yEVQOCCSLl4LJS6IAkipMEMsS9bwcNkQ1dy2rfbimP7
         +5VGslPJQ+tb0mmepd9h/UN4/zU2ZbiJ2Ir7ORAI7Y0cvJKcQSgGsKUMg4+IgA85PkjA
         Sa8hkVoAynBvp+SSwDrjSxo2ENJ3Tyo2Fd1WRKI38Mje7tNdngBX8Ri32usS/uOU026l
         MQggwWqTqhuNLuGo9edn5cBsGwj9RDl6vVr65KackarqYYWOSjAID58SzTOktzarBMgQ
         eppt0FY9xLJydMDkeYVLZUQHzy1qYz8N2TVNpkN2M9er3ADZIF/344TA6eJrcuxCxnjR
         Ld8w==
X-Gm-Message-State: AOAM531F8lACngmvolgLtv5M2IYSS9U1oW1k5Vm+vRM7CmOugYYB96/u
        Z/P5ZgYghmGTv4XMTVZTBhVkbTUtruK/ZA==
X-Google-Smtp-Source: ABdhPJxE0EV0Z8PUZTxCENHWt/rseFaAqD0JRfsIAhMnk3syLVMjXdV6QDig/iL0EbzmNqFARbBIIg==
X-Received: by 2002:a63:231a:: with SMTP id j26mr8148261pgj.77.1621028161580;
        Fri, 14 May 2021 14:36:01 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:36:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH 16/50] csiostor: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:22 -0700
Message-Id: <20210514213356.5264-68-bvanassche@acm.org>
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
 drivers/scsi/csiostor/csio_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 56b9ad0a1ca0..234e0baec091 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1786,7 +1786,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 	struct csio_scsi_qset *sqset;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 
-	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(cmnd->request)];
+	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(blk_req(cmnd))];
 
 	nr = fc_remote_port_chkready(rport);
 	if (nr) {
@@ -1989,13 +1989,13 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		csio_info(hw,
 			"Aborted SCSI command to (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			cmnd->request->tag);
+			blk_req(cmnd)->tag);
 		return SUCCESS;
 	} else {
 		csio_info(hw,
 			"Failed to abort SCSI command, (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			cmnd->request->tag);
+			blk_req(cmnd)->tag);
 		return FAILED;
 	}
 }
