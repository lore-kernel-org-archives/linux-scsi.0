Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF83C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAAFF61440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhENVhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:42 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:39922 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbhENVhZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:25 -0400
Received: by mail-pg1-f176.google.com with SMTP id s22so255304pgk.6
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NeWkHCvNgyn7u3PNQUIeXJvghqPHu+F/KuNw5psQyjU=;
        b=tCbEs2UGrwnTKXW/78pV+j++1Nu3htR8LnUe4l1o/YRt1P8IqA2rllhXAR9HZctqPP
         G0HqjRW9JwDu4JmyCxVApT/OJnhqywk7QnVBwDkuuZtF+QYq6TcjeQXkAPcradlE6gPN
         PkuVG8DbKwBERnluYJp9j6oHEaQadPJI10SfGDTtcMm+xG07pUWvlrSu79VwNZ3pqWf1
         WMzUmAlw1RRpFWA+wBWTywjc1syDvtDKoJ6vVAY5QwSSCacyTwAbstNJr3IQjmmNKvGK
         zL7IgbeqNX4Elu85FGBjUYpbWPonpzM5t5qrd+NB7cm8OwsF7RoeWnR+toE3VJ1loDID
         +y5g==
X-Gm-Message-State: AOAM5324R91MBSKP96tNgRclhYDER4oD4t3XFL6K9H5H6t/rIy0bPnQk
        bzVzQ0bSzxozH7HZVP733Ds=
X-Google-Smtp-Source: ABdhPJzyWu8mIsK/lK9K7iFI93b2x5Nfw52uPlnVj55X3wcxBTV1p2Qj2qMxq6xzJjhpP2vmM4t5Jw==
X-Received: by 2002:a63:7d12:: with SMTP id y18mr7894772pgc.130.1621028172114;
        Fri, 14 May 2021 14:36:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:36:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 23/50] ibmvscsi: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:29 -0700
Message-Id: <20210514213356.5264-75-bvanassche@acm.org>
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
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index e75b0068ad84..48e07b8a6b63 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1072,7 +1072,7 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
 	init_event_struct(evt_struct,
 			  handle_cmd_rsp,
 			  VIOSRP_SRP_FORMAT,
-			  cmnd->request->timeout/HZ);
+			  blk_req(cmnd)->timeout / HZ);
 
 	evt_struct->cmnd = cmnd;
 	evt_struct->cmnd_done = done;
