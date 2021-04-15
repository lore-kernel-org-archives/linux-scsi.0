Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEE3C43462
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03301610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbhDOWJT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:19 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:36494 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236637AbhDOWJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:18 -0400
Received: by mail-pl1-f173.google.com with SMTP id z22so7753496plo.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xaz2gGbraDbegGathgoxn2YQGI6l3GdxLG9x+mNykh0=;
        b=DbGsYQCeC++LW9SYkLq6tHNK8rXF2A9P25IHWZnK22MZTITQr9l5Yi/S7Cqmbju/CL
         6r0viubOCXWTjjNaGtzGesmhf2UHweaett2TByuVWAx2b/gUiqgtm+CTAgB+vSr9FVWz
         1SM2ZIbQnvzEmcNq8IGF/fz0NUUocmjRyasFbfG6+zu9N1dzH1GXN4jpXFCnTt8C3ZOT
         UmqwhhRMvSsboBV2SE7o8QABbHkIVSEx4C3Rp8Rqph2RMjZkgzqbWK6DxHUDtXVMOzYN
         Gpme0W3RhuJ6B5sEhcZwZtDBYukCPb5gLcYZ+PQyz4gFyrnpdRur7VGfcEsI+Al0Jkqh
         uP+g==
X-Gm-Message-State: AOAM533jqheLBKRQqyi8DTdXnoP8351qNAT15D0yT/CHttTxTTuggu5v
        f5UrqrEebmdINBDhHm4KZ6U=
X-Google-Smtp-Source: ABdhPJzMHQB7/eiDViaz+17nZ63PhBcwpDYgSf3JacnJHqTcHr8I3EykZg5jya0Hyo33MfVYBR20Qw==
X-Received: by 2002:a17:90a:6407:: with SMTP id g7mr5950512pjj.206.1618524534437;
        Thu, 15 Apr 2021 15:08:54 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 16/20] sd: Introduce a new local variable in sd_check_events()
Date:   Thu, 15 Apr 2021 15:08:22 -0700
Message-Id: <20210415220826.29438-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of using 'retval' to represent first a SCSI status and later
whether or not a disk change event occurred, introduce a new variable for
the latter purpose.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 91c34ee972c7..cb3c37d1e009 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1623,6 +1623,7 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	struct scsi_disk *sdkp = scsi_disk_get(disk);
 	struct scsi_device *sdp;
 	int retval;
+	bool disk_changed;
 
 	if (!sdkp)
 		return 0;
@@ -1680,10 +1681,10 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	 *	Medium present state has changed in either direction.
 	 *	Device has indicated UNIT_ATTENTION.
 	 */
-	retval = sdp->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
+	disk_changed = sdp->changed;
 	sdp->changed = 0;
 	scsi_disk_put(sdkp);
-	return retval;
+	return disk_changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
 static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
