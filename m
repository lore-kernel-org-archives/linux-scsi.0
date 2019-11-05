Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066C2C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 21:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1AF02087E
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 21:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbfKEV4C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 16:56:02 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40117 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730041AbfKEV4C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 16:56:02 -0500
Received: by mail-pl1-f193.google.com with SMTP id e3so8196257plt.7
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 13:56:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwWvDszRtZZjYkJRiR0LHlyYfi6cCIKYfphV/rqYWXw=;
        b=KPYZJ7nVoI9A1rS7hlxR4JDphugO3EMC+rLjhkGmIlVbN4uI+v4TEWeAY9qmZeirjp
         SkG/uZ73Xw5FQ7kJL2onvBW0Zx0UpPqM/iH84WGY0qOHSezwjMX2An03dBMUzBMk4MnS
         LckwPz3uwHL7/O5J5wlnaEHZws/QAlduF7WxnnKfKhuwG867qwcvUz4W+QnONCIrpzwl
         /cBD7r78x+B+FGP9OnvJOqcr36I7vjw8b+FlLpG6cfD6DZGBZa8iiwliI0E7IISrbyas
         IiwcQHqz9GwgL/Cp/Lk9B45yRvB4TIykJIyem1tAgkizkLKCkDmqE36dH6vEKdAvZOx/
         FtHw==
X-Gm-Message-State: APjAAAWG6Nm0oWAIwu4Watu42bZ/5RRwu1HRw9wdsOGxToOTi7ydVfA/
        RWFz1/+M1i1eyJWl2Qx7f5g=
X-Google-Smtp-Source: APXvYqyoXxmWUrMqOucQidlfKCt+K8lt/yNwfGBkoFZsZeGvEhfBPZZ5EmvDq+0dAPX495MNjVsSkg==
X-Received: by 2002:a17:902:b198:: with SMTP id s24mr2686908plr.170.1572990960229;
        Tue, 05 Nov 2019 13:56:00 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 3sm22384685pfh.45.2019.11.05.13.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 13:55:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] tracing: Fix handling of TRANSFER LENGTH == 0 for READ(6) and WRITE(6)
Date:   Tue,  5 Nov 2019 13:55:53 -0800
Message-Id: <20191105215553.185018-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to SBC-2 a TRANSFER LENGTH field of zero means that 256 logical
blocks must be transferred. Make the SCSI tracing code follow SBC-2.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Fixes: bf8162354233 ("[SCSI] add scsi trace core functions and put trace points")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_trace.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 784ed9a32a0d..ac35c301c792 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -18,15 +18,18 @@ static const char *
 scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	sector_t lba = 0, txlen = 0;
+	u32 lba = 0, txlen;
 
 	lba |= ((cdb[1] & 0x1F) << 16);
 	lba |=  (cdb[2] << 8);
 	lba |=   cdb[3];
-	txlen = cdb[4];
+	/*
+	 * From SBC-2: a TRANSFER LENGTH field set to zero specifies that 256
+	 * logical blocks shall be read (READ(6)) or written (WRITE(6)).
+	 */
+	txlen = cdb[4] ? cdb[4] : 256;
 
-	trace_seq_printf(p, "lba=%llu txlen=%llu",
-			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_printf(p, "lba=%u txlen=%u", lba, txlen);
 	trace_seq_putc(p, 0);
 
 	return ret;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

