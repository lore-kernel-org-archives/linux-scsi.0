Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4204C433B4
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99669613C9
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhEIVoX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 May 2021 17:44:23 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:47055 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhEIVoU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2021 17:44:20 -0400
Received: by mail-pg1-f180.google.com with SMTP id m124so11863229pgm.13
        for <linux-scsi@vger.kernel.org>; Sun, 09 May 2021 14:43:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BMjPvho0aXfcqdw6F9RPLM21ijwP7wFLH3CxLZw+RoI=;
        b=jFolYTCN2dkmtwdAFIL45tioijF58YEWCUy29WtfHjltMTGNNzpdI/+ZIiy8C3BzEo
         dZvV0sjEq+7N4fihCZzC3kvP8zge0HfKASoTzIz6fSDrB+sYRAanf5/Zjq8UHKOTmKHU
         apQmcR8qpkb3tahCD6prhRw3X198Nm34hcgj/27enb3D0+WtuN/xaqE5O9aBfFueRVhU
         pTpewaJlVC+i37+QxeOuCn/9HTj9WbZ1jn41WTWD1/P7ut3yXup2pbv1Dj3gd/JCsjIy
         2ZNKkSRh+ngn3g6d6T3dXLcGcZ6Tt7/k4ph6N0dBvwSI2k2PfdQOKfck0TvB6B0rl85y
         Lb2g==
X-Gm-Message-State: AOAM533VlsgR8TK8EpYGpKhIc7R1Vw0ijbn1ctBUkGJcfCX/TDFxWnQ3
        iIqbXVWWuxVcmL/u0YnEe4RVdEcRi5g=
X-Google-Smtp-Source: ABdhPJwt8TPOswxh037ga2uUqIuKzk6+n1ak87c6Odva/S25cPv7enHICcINhX2n12kYtsy0wBrVcw==
X-Received: by 2002:a63:d710:: with SMTP id d16mr21910642pgg.214.1620596596415;
        Sun, 09 May 2021 14:43:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1f3e:222f:39bb:cb2e])
        by smtp.gmail.com with ESMTPSA id t4sm9712567pfq.165.2021.05.09.14.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 14:43:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/7] Introduce scsi_get_pos()
Date:   Sun,  9 May 2021 14:43:01 -0700
Message-Id: <20210509214307.4610-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509214307.4610-1-bvanassche@acm.org>
References: <20210509214307.4610-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since scsi_get_lba() returns a sector_t value instead of the LBA, the name
of that function is confusing. Introduce an identical function
scsi_get_pos(). A later patch will remove scsi_get_lba().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index adb8df40b942..8147b1c0f265 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -290,6 +290,11 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 	return blk_rq_pos(scmd->request);
 }
 
+static inline sector_t scsi_get_pos(struct scsi_cmnd *scmd)
+{
+	return blk_rq_pos(scmd->request);
+}
+
 static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)
 {
 	return scmd->device->sector_size;
