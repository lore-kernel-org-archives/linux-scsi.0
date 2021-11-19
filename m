Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F2CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DEAD610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhKSUA5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:00:57 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:37745 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhKSUAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:00:55 -0500
Received: by mail-pf1-f177.google.com with SMTP id 8so10238273pfo.4
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:57:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vLRJ3SCXbH4NweGhAcBFCYovJZq4yIfhx39FAmMGgmI=;
        b=KeU4+wFRNcZ+vAywAgPf/DmdYOBZnRCl20xXz9JbM+vRH51UgPCqOGftNnrbeEFh0Q
         zVRBKY1Y6NXVPzgReKIvka9KC2N4VQiZMXc7mkwmUTvLUSZ6tT3aijDJL/IQ15dTA+PR
         mfPktBR8u3+vQe3AgEsS11/+r1e6lD1W0ubXBjcFPoWikMxaLXl4y6scfKquvOfQRfIr
         RS2QiVkfKuxfa2hpRX/t+i6HoX9/Jh37zMBKe90UH57JYuaIziNtYprmzQa/akIMz6Sw
         EjxT8CSYElVaRlCakWoNSdrejdnqP8eomu+I1eeXnWzv/JM3v/98iSkEQhQDGgBp9k3+
         wo1A==
X-Gm-Message-State: AOAM530jbkN0/ksEXmxTkIvAHxe+ve0ofa0k9/TXmpy9lVGMDYRNIhKF
        e3T9EknxHyHsbjLD4P2CZBbd24QtsLs=
X-Google-Smtp-Source: ABdhPJwiIBBWBBFQofubcKxSLzhWstk1IENSMgxPu2YNkXzVuJld6OyEMyVdYi/5F8/oMG1uf0aZfw==
X-Received: by 2002:a65:5944:: with SMTP id g4mr18826990pgu.374.1637351872808;
        Fri, 19 Nov 2021 11:57:52 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:57:52 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 02/20] scsi: core: Unexport scsi_track_queue_full()
Date:   Fri, 19 Nov 2021 11:57:25 -0800
Message-Id: <20211119195743.2817-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 408dea0ed41c ("[PATCH] kill scsi_syms.c") exported
scsi_track_queue_full() and introduced a call to that function in
drivers/scsi/tmscsim.c. Commit 71bd849dbac9 ("tmscsim: replace by am53c974
driver") removed source file drivers/scsi/tmscsim.c. Since
scsi_track_queue_full() is no longer used outside the SCSI core, unexport
this function.

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index f6af1562cba4..ace6d477034b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -276,7 +276,6 @@ int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 
 	return scsi_change_queue_depth(sdev, depth);
 }
-EXPORT_SYMBOL(scsi_track_queue_full);
 
 /**
  * scsi_vpd_inquiry - Request a device provide us with a VPD page
