Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320EFC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 099CB6143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhENVgs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:48 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:43968 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhENVgj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:39 -0400
Received: by mail-pf1-f173.google.com with SMTP id b21so637470pft.10
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qc2024KrSNi9X/MmdEEPfFIpG0meC/1WijHNe78H61c=;
        b=crDmqmWvF7dx/9LwYJpG1hYF780FOXcEXmmpWDYR3/KS+LffDHnB8+HgW4h38tjjmJ
         c3GQLRxOUA61dzttfGsBYjvJRO8CC1VyrBv5b33mEAAO9BEh39ZiT4/4HUDxbmoqLuas
         JyaThswb0G9jl4I31W+agl9XgHm94JOW3GK9Ynw0DyHWqqnNWz9VeL/azpvibbnUxi4G
         bqoAKd5lRMt9HUSRR1hGFAlRbUXsZA+WK95WY5QvIiINwTyjMWUlFOIpPg66Um8R7An5
         zuz51UzlYhktseZEeCYq7tLV68rYpVU4RJvngmPtBLDfr4U8kdjVXeFu2VPfnXz7FnNJ
         rhdw==
X-Gm-Message-State: AOAM5303dpZ6lkYw1K7VtIAuq9GO5cFgJCsbGSm1vo8szj1LrvusSYKU
        SqdSTcSn8X52NvsSOdbWS+g=
X-Google-Smtp-Source: ABdhPJyK4aqhllCA22UhDrX3LHEjtF6KlN4BA1moECkPnGNu6z7Wdugf4MBQo1ItYZjIqAzlbOcA8Q==
X-Received: by 2002:a05:6a00:b46:b029:2d3:3504:88d9 with SMTP id p6-20020a056a000b46b02902d3350488d9mr8132850pfo.39.1621028126401;
        Fri, 14 May 2021 14:35:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 47/50] xen-scsifront: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:02 -0700
Message-Id: <20210514213356.5264-48-bvanassche@acm.org>
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
 drivers/scsi/xen-scsifront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 259fc248d06c..785b39cbe0f7 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -212,7 +212,7 @@ static int scsifront_do_request(struct vscsifrnt_info *info,
 	memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
 
 	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
-	ring_req->timeout_per_command = sc->request->timeout / HZ;
+	ring_req->timeout_per_command = blk_req(sc)->timeout / HZ;
 
 	for (i = 0; i < (shadow->nr_segments & ~VSCSIIF_SG_GRANT); i++)
 		ring_req->seg[i] = shadow->seg[i];
