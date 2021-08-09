Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB33C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2674A60EE7
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236930AbhHIXEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:41 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:45920 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbhHIXEk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:40 -0400
Received: by mail-pj1-f51.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so2386827pjl.4
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=96BcAWjd2E5/FjUNSuNIq7ZLjvEwKHE+7FePnmlgD2c=;
        b=M9NSwFUnf13YRhB0FwRV5m/a+UisDUJDLRoIg84mHZfo4PY2iInFJp5s+G4QsDI4cl
         U3p7h8ik+BoT4O4GlfkEwLTM6zKIodEvpg/VmNooKDOuIlyBDQm7Ie9kvUhfEoAwfoSY
         QMZUEDmE0tnqOu9aQn/CI/3m9rsHV3NYBF3zjYe3W/l+YeXOnULnZNN3LA2moDonSKWY
         Cq8c3D9YQZzkpL5FkOEoTg9dCQZK0ZaqVStFBIpadMWMSnZRKlmfRLu2159TZ6c9styb
         jw7dyhqODqANafV1piSSBaV79MpNPnuktNGqrtkw7LOch5RL8kypsX35hvf0l84BDyge
         N5AQ==
X-Gm-Message-State: AOAM532gSrRdCrjwgQzoWUrEyO7O1E+RYXj3a0EloPy02ClxL9bHadNc
        ZuJbFeraZBcnEqw04LhJodY=
X-Google-Smtp-Source: ABdhPJwLdRRVib0SR3nzWTRgMGWQQFFwnCV0jeYIX+CP5NzTMpIlocDCGl9191ahuisvc1uPxQrx8Q==
X-Received: by 2002:a17:902:c202:b029:12c:9970:bdf9 with SMTP id 2-20020a170902c202b029012c9970bdf9mr11622130pll.30.1628550259583;
        Mon, 09 Aug 2021 16:04:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 11/52] 53c700: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:14 -0700
Message-Id: <20210809230355.8186-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
