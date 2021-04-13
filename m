Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A90BC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71137613B7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347108AbhDMRIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:10 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:34553 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347091AbhDMRIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:08:00 -0400
Received: by mail-pg1-f181.google.com with SMTP id z16so12389267pga.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YMKuvSuStmi+Y5MBD+/AJkPa4jmcUESw9esKkMO9iHU=;
        b=MqJp6XP03tZgL+gsyd7rGI+ORqjCIKyoYrQ0i3EpoyRGoPE4e1EY6b6xnIkt6nrFSX
         dChPSKJkAeQD+MFuShY566/2l4OPilNp2D/zHYx7tBYl6CWq+1hdp6cgGZvoA+1MDllQ
         E74LChyVr2XKAE6WWnklca1za7lcpDbJCID0Mq/nlQmo3aQa/F6Nrkk1QbIp2Q1FcFR9
         B45RvXAKYVlKlOlCu4IlSDtbW3SMErAHFB+SsmKWtGj544CDUKiKXyopW6+e9du7VYHT
         RXZ6iVKOzNSWsrs3MuYzA6x70rZ6n6UDzc6Tbu4IAq66uSBq1/hb2QGXBx9ciP+nURxl
         USUw==
X-Gm-Message-State: AOAM531+t06Sra/cG/Ilqz3sZv6uxgCaD4MVlxoUephZ3DlQG6FbTqXc
        1I6jhKWuWCK09i7BFOMzPo0=
X-Google-Smtp-Source: ABdhPJwvhbPlZVnPFhv2Y6Xqsj/+2RfYAH/FG1g29A8wfu0gbhz+UnRfgLsn0AE1jXo+cdojULZcmA==
X-Received: by 2002:aa7:9f45:0:b029:24e:6fe8:5bf0 with SMTP id h5-20020aa79f450000b029024e6fe85bf0mr8394542pfr.79.1618333660292;
        Tue, 13 Apr 2021 10:07:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 16/20] dc395x: Open-code status_byte(u8) calls
Date:   Tue, 13 Apr 2021 10:07:10 -0700
Message-Id: <20210413170714.2119-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The dc395x driver is one of the two drivers that passes an u8 argument
to status_byte() instead of an s32 argument. Open-code status_byte() in
preparation of changing SCSI status values into a structure.

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dc395x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 1e9ec4d8c605..be87d5a7583d 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3258,10 +3258,10 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		/*
 		 * target status..........................
 		 */
-		if (status_byte(status) == CHECK_CONDITION) {
+		if (status >> 1 == CHECK_CONDITION) {
 			request_sense(acb, dcb, srb);
 			return;
-		} else if (status_byte(status) == QUEUE_FULL) {
+		} else if (status >> 1 == QUEUE_FULL) {
 			tempcnt = (u8)list_size(&dcb->srb_going_list);
 			dprintkl(KERN_INFO, "QUEUE_FULL for dev <%02i-%i> with %i cmnds\n",
 			     dcb->target_id, dcb->target_lun, tempcnt);
