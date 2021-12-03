Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150B5C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376688AbhLCXX1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:23:27 -0500
Received: from mail-pj1-f54.google.com ([209.85.216.54]:42715 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbhLCXX0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:23:26 -0500
Received: by mail-pj1-f54.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so3742633pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:20:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qY/e1tYjy/CX5akbZhb3KBBMMKjYLigNzjhchVjN1r4=;
        b=ZdWoZeNOhQBO2cW4avhUu4oy45W2275XwMOn7QKAyL84rF759fz0Gc9Hb9M1B4HeVf
         KPzk1XDPSAVwzza83pciYqcr418i5TzfB6GS9UDBMR8EjxSc9WewfKBhIUCoed3Y3lak
         JkcFhR+2vGVfPXAwvU6UQCcV/qlSx3l+M8CGb8eidY2VmHVl+7ngbrkTaUEBhOI0mcLR
         aNZnwK1+JV/NbzxmjocOKsfYc+SlOqmYjOXBi3akGuz+QFbhoyXnfQKd41rRvo7+/JbG
         cWVix7VJt1ich4HL5Oz1x2priVCwz7BkNslOV0ZhTBOiuvA173wVDzJkkh+SNfUi/xtf
         2ggw==
X-Gm-Message-State: AOAM530t3zqJzMaMFMF8qtP9QAokcJoFM/dHZJjMATQwqeinjjFMTo9u
        8lOnpHCi/7hWW3MwANatcVo=
X-Google-Smtp-Source: ABdhPJxhH0yXNMxn/yFbNZYtvylTM8n1NLBVT8fVPuIYUfX+OKLRvng9qOh/bFV37v9dIa9NKBFS9w==
X-Received: by 2002:a17:90a:fe0b:: with SMTP id ck11mr17425845pjb.15.1638573601674;
        Fri, 03 Dec 2021 15:20:01 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:20:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Bean Huo <beanhuo@micron.com>,
        Hannes Reinecke <hare@suse.de>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 01/17] scsi: core: Fix scsi_device_max_queue_depth()
Date:   Fri,  3 Dec 2021 15:19:34 -0800
Message-Id: <20211203231950.193369-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
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

Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Fixes: ca4453213951 ("scsi: core: Make sure sdev->queue_depth is <= max(shost->can_queue, 1024)")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index dee4d9c6046d..211aace69c22 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -200,11 +200,11 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 
 
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
