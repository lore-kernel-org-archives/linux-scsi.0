Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6A6C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354111AbiBKWdg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354108AbiBKWdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:35 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3572DD54
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:32 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id w20so5756772plq.12
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y0M6XC14NmFEhp0o4hgZi4UrdhPuRybsPzWnxMeaeUU=;
        b=hZC/ueeusBZ28R9Q5b6DbZa++DK12dj8QyAjXt9DigQv5Bw81cqq7ttGbi0WrD6im6
         ZTOeIK3bRc81MID8FNg7E73+q2DWFu8aPba9C6klpyShYSiUbMQ4x0lDqIxgDBiHWqWE
         hbcv9fKjKAKDuL4Cb1vyg1Jg7FDrpZ3pQHxcLxfqaVbU9YK9K6RgNp0wcTCLqNQI2a5x
         pkc6WM83KwbppV7DvBnO97cD0EGC3oroaqpQP20CjCc1PJ6wpw9wWIrPd/jBuJcuSd57
         oCjrzDlRbs6fyhmEsurrEXgA+0ZakuDMyQwZzphU8lMn49qlzI26g7z/jCOsOGxQ9kKD
         HISQ==
X-Gm-Message-State: AOAM530+ndfHk2lS2T9IQ7DR9Oaerve4uSVexHBvdhrjN2FvDT9c5tWL
        u9EfZ7pTdJpoNvGKmifaGk928tU/qZh5nQ==
X-Google-Smtp-Source: ABdhPJxaVADUrUPbop8T/SjJVSgtDZ2eDbNZxQtelRS/YCrgHeSR9FFDyVTTmOD/5CxBKdX7P5lCbQ==
X-Received: by 2002:a17:902:bd0a:: with SMTP id p10mr3497406pls.159.1644618811620;
        Fri, 11 Feb 2022 14:33:31 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 12/48] scsi: 53c700: Stop clearing SCSI pointer fields
Date:   Fri, 11 Feb 2022 14:32:11 -0800
Message-Id: <20220211223247.14369-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

None of the 53c700 drivers uses the SCSI pointer. Hence remove the code
from 53c700.c that clears two SCSI pointer fields. The 53c700 drivers are:

$ git grep -l 'include.*53c700'
drivers/scsi/53c700.c
drivers/scsi/a4000t.c
drivers/scsi/bvme6000_scsi.c
drivers/scsi/lasi700.c
drivers/scsi/mvme16x_scsi.c
drivers/scsi/sim710.c
drivers/scsi/sni_53c710.c
drivers/scsi/zorro7xx.c

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/53c700.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index ad4972c0fc53..e1e4f9d10887 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1791,8 +1791,6 @@ static int NCR_700_queuecommand_lck(struct scsi_cmnd *SCp)
 	slot->cmnd = SCp;
 
 	SCp->host_scribble = (unsigned char *)slot;
-	SCp->SCp.ptr = NULL;
-	SCp->SCp.buffer = NULL;
 
 #ifdef NCR_700_DEBUG
 	printk("53c700: scsi%d, command ", SCp->device->host->host_no);
