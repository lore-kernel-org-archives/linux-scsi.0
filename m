Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6234C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFE5261B27
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhKSUBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:03 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:35484 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbhKSUA4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:00:56 -0500
Received: by mail-pj1-f53.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso11804968pji.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:57:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EVj1TeqLe2fHgADctdpQhIfZjSaJEz9HmFLvLPa1dDM=;
        b=todD70gMsYnBjm0Hce2kFBsxYVoJb9emWcDZXGVs5e21F8jzMLhHyllB7uSqO5MVgd
         HLYMLTSRt3Pdt1rPZg3IIlkmDDRoG+OaweyosDah0Cy61ISMUgDY8ZDjkFbuyhi1xOdK
         MHZ8D1g7IQQVgBKaZldsgfvY4kRaJBvXIiLV71Z7TI3jA79gvWykqgpfX4l7SY45ElQv
         QAShTbfKn5Z1EBAauScUeCUu0eu105Ea1A9zpzo0PEZa07w9m/zz4eXSWmO3qme9Bunw
         X1qa2AsRIihPUm+N0HWyf4QoMB6SyA+bbMW7UHOXiYkDUsNDAcUZ2yf0kdIV+6psfBXd
         04ig==
X-Gm-Message-State: AOAM533F6R5bNlFtJj6NlY5s4iBOpbuOe6Y6lXIuhN+WxxeWcfNvq9MJ
        cqdut2We19zg5WdctZDmMbs=
X-Google-Smtp-Source: ABdhPJyzJ5CBM/VBoqMEUhxrPVVKaEGSEvrslL26PGp07MjcpzE4fRi0elO6PTTTgc/xgGz71gomzQ==
X-Received: by 2002:a17:903:124a:b0:143:a627:a992 with SMTP id u10-20020a170903124a00b00143a627a992mr76896441plh.32.1637351874099;
        Fri, 19 Nov 2021 11:57:54 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:57:53 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 03/20] scsi: core: Fix scsi_device_max_queue_depth()
Date:   Fri, 19 Nov 2021 11:57:26 -0800
Message-Id: <20211119195743.2817-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The comment above scsi_device_max_queue_depth() and also the description
of commit ca4453213951 ("scsi: core: Make sure sdev->queue_depth is <=
max(shost->can_queue, 1024)") contradict the implementation of the function
scsi_device_max_queue_depth(). Additionally, the maximum queue depth of a
SCSI LUN never exceeds host->can_queue. Fix scsi_device_max_queue_depth()
by changing max_t() into min_t().

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Fixes: ca4453213951 ("scsi: core: Make sure sdev->queue_depth is <= max(shost->can_queue, 1024)")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ace6d477034b..0d2a91aa1f13 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -201,11 +201,11 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 
 
 /*
- * 1024 is big enough for saturating the fast scsi LUN now
+ * 1024 is big enough for saturating fast SCSI LUNs.
  */
 int scsi_device_max_queue_depth(struct scsi_device *sdev)
 {
-	return max_t(int, sdev->host->can_queue, 1024);
+	return min_t(int, sdev->host->can_queue, 1024);
 }
 
 /**
