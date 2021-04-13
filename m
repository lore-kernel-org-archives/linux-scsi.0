Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B964C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0412B613B7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347130AbhDMRIL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:11 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:34412 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347096AbhDMRIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:08:01 -0400
Received: by mail-pf1-f172.google.com with SMTP id 10so2958289pfl.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xaz2gGbraDbegGathgoxn2YQGI6l3GdxLG9x+mNykh0=;
        b=cUptomzjqb086jXG8LF1mU0+pp7ukdYpq4WkpHJhRwo0YRAm/9vyBSb8HkkbDV0ibp
         Ld1qM3Vpgo9fg4oUzneSditGh0F9WEB3FC8LcE3e/2W7wjza4iOm8+/ORE5vS5+wPXc9
         sjuSJDA6lrhKvcLTusJVB9CX68oBoimje7YvpVdXrYNqs9/smm1Yp39zV/rlbpTZsxgi
         h6bCkCpZ59AxAm0IBrDO3/8528g05VDLqXrJDAlXbBn8dCNHCGplZWO571f62pyWv+UV
         zy/9oFLm8bXpj9JOZrJOjDai7YClylPjsLVz0Ka9/EdrEGtPpiCj72SEZShah/NC5Pzp
         nutA==
X-Gm-Message-State: AOAM532vhjKS1e6ztBJQspTd3GzlKrja5cClRlkkzEdEdvstqHjHcenI
        rXI8gNYHw0E+O61y+0hfmZE=
X-Google-Smtp-Source: ABdhPJzwOEPnPAEyq7QbzMQVI7rVmsgjVgvkDzBoJRx79uG9/DSGM8zK/e1HzPivXaehWsnA/GRXKg==
X-Received: by 2002:a05:6a00:1511:b029:24c:e3f9:cce6 with SMTP id q17-20020a056a001511b029024ce3f9cce6mr10793447pfu.28.1618333661486;
        Tue, 13 Apr 2021 10:07:41 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 17/20] sd: Introduce a new local variable in sd_check_events()
Date:   Tue, 13 Apr 2021 10:07:11 -0700
Message-Id: <20210413170714.2119-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
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
