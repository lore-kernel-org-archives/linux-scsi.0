Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA28C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E537061151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhEXDMC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:12:02 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:42957 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbhEXDMA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:12:00 -0400
Received: by mail-pf1-f176.google.com with SMTP id x18so15375608pfi.9
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjbZV+3MrAdmbLBg1BOHv8e475oZ5SyVoPXmEaezYSc=;
        b=ba2VTeReMkiiit+xhdUEiYeDnBJpc++9K+/OVZwK1MHFkAXKWDvZTSZTWinfD391yB
         r7iIvGNTFIjDXLLEcacE+RaJUkV461hMkQrKS/QMpWj0VmY2C1uvWfzWh6ORL6n2Bs13
         yi2Kn+nhb+S+77ceQU7aW0NnopesoIIfuuskCXvJ3+cTSiNEayATEbfPeD6WxcQsi1TG
         hm1kVlgYx7RzwRaJUxwUAs3fgqA6NcG7forzFGNG8pSQwx+fRMs58gGnNZIURu4syeo2
         XBHJs0vOpCBedbbj/XeTWSsODD7gu6AbuUbqwJJ+JPmKl6etZiUZIBphOPiHOo5vvKCe
         4BgA==
X-Gm-Message-State: AOAM531O287Lam7HuJt7yVZGiC44TWRCCfvoUuSLlO/ssUcEpmxAgdli
        MBV909ijxWGGECcy4f+Z500=
X-Google-Smtp-Source: ABdhPJzqf7iJq0195dB5kR9HRaHxHgCtofA02Frax9LP6Wa3ord6bayb96Rfis2qsTOw3HvlTrF/kw==
X-Received: by 2002:aa7:80d3:0:b029:28e:f117:4961 with SMTP id a19-20020aa780d30000b029028ef1174961mr22740060pfn.37.1621825831552;
        Sun, 23 May 2021 20:10:31 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 50/51] usb-storage: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:55 -0700
Message-Id: <20210524030856.2824-51-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/usb/storage/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index f4304ce69350..4c5a0a49035f 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -551,7 +551,7 @@ static void last_sector_hacks(struct us_data *us, struct scsi_cmnd *srb)
 	/* Did this command access the last sector? */
 	sector = (srb->cmnd[2] << 24) | (srb->cmnd[3] << 16) |
 			(srb->cmnd[4] << 8) | (srb->cmnd[5]);
-	disk = srb->request->rq_disk;
+	disk = scsi_cmd_to_rq(srb)->rq_disk;
 	if (!disk)
 		goto done;
 	sdkp = scsi_disk(disk);
