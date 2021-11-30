Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594C3C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbhK3Xgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:36:55 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:46729 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241159AbhK3Xgw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:36:52 -0500
Received: by mail-pj1-f53.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so18719645pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:33:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F+dZM7KWrnvw9D2zFlMFJLpRTk0sjY7KdgSvJCF/dHw=;
        b=KQxnIiuLyTvvf+neeSW8EXJ1ziM9HuWIddkHp3yA9bXFlxEoqrEqNTrmWbtEWFi75r
         dCAW2oLgt5X66lQfb4cFQ0iHCjTmDiZ/NHK3so/X5l3S1XJORDHqqaOa/CxcvynOmVFG
         XNXO7jUwgOzXgH+K4491weRVH63pu35GstHsb9icC7O5xyx2edkYpBwMR55cPk7peGxb
         9eiGBTsYqUignVmdEhf4/kLYZMS6a7hJ3TZZEuOmHBE3wX3ZU8JpukDdITFaDlAzgw2h
         8ifwR3Evxn2gnnkAWp6ZELoDoeCB5bKBhfQ2/9+MkPGx4w4yNXhmx2sC2ODbaYuDWU9Q
         SVNw==
X-Gm-Message-State: AOAM53214eErjogsGmKbGFsjGLOQWduc2eXJDE4bUrcRbCYkcNnxOEzA
        VcqpfVsXmY6ICtlAqQ3KehY=
X-Google-Smtp-Source: ABdhPJzpiU4f9PiZuH2BX+mC30gL7rGfLvFIrrjRW09J+Ubhb1pqn66zczXt9hbbAzt8PkiD3UHQOQ==
X-Received: by 2002:a17:90b:1a88:: with SMTP id ng8mr2646696pjb.180.1638315212445;
        Tue, 30 Nov 2021 15:33:32 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:33:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 01/17] scsi: core: Fix scsi_device_max_queue_depth()
Date:   Tue, 30 Nov 2021 15:33:08 -0800
Message-Id: <20211130233324.1402448-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
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
