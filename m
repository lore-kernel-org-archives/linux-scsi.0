Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E863EC00143
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D856113B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242853AbhHETTZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:25 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:44022 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242870AbhHETTL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:11 -0400
Received: by mail-pj1-f54.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so12000875pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=96BcAWjd2E5/FjUNSuNIq7ZLjvEwKHE+7FePnmlgD2c=;
        b=flrkkFZv9IDsb+7Ol+zQyPu/YJSuv6DrzUOHPZyvvZr0+k79W8rwCqpo/yW4wqmub4
         MxP250MdNzogEYjE3bYvhKtWcp9nkCW3KUkZrdylxWwpIMIo7JMquVLVz1fQS/9CzQX6
         a79f7K5/u/P9ujg8XMF1aT9itSdef0GigJq7hkxrOflSlpzuDgkyHMuJsa01z27U5QlE
         RpNENucLuK0d+nkJN/vrrdVRmDtjHk5MieBGmEwfCm1mxbozCQ3+9hkyBz9kcfmZkc+1
         sXgBXKzoh8NYsFYldIA3Fl3WA+8X3Lez7w5kbmk6DajYp+VFofJXfm289MNmLIHDnEHs
         ZtvQ==
X-Gm-Message-State: AOAM531KH8eJakzsORHe7AxkiJ33cYcY3TJzeB8Li+sl7pVPAJ58D44n
        jv3Iy5xYpRKkYFa6coH0Ybo=
X-Google-Smtp-Source: ABdhPJzAXFuifv69nlDAOi1w9Q/1Nz+DTtrGnfXDNpClfpTopQxQbk+DFuJAkAKVjE+r+gYwKftgSw==
X-Received: by 2002:a62:7704:0:b029:3c4:5678:ebf9 with SMTP id s4-20020a6277040000b02903c45678ebf9mr887154pfc.45.1628191136411;
        Thu, 05 Aug 2021 12:18:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 11/52] 53c700: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:47 -0700
Message-Id: <20210805191828.3559897-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/53c700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 1c6b4e672687..a12e3525977d 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1823,7 +1823,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 
 	if ((hostdata->tag_negotiated & (1<<scmd_id(SCp))) &&
 	    SCp->device->simple_tags) {
-		slot->tag = SCp->request->tag;
+		slot->tag = scsi_cmd_to_rq(SCp)->tag;
 		CDEBUG(KERN_DEBUG, SCp, "sending out tag %d, slot %p\n",
 		       slot->tag, slot);
 	} else {
