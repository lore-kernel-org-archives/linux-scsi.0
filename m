Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF70C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D464161440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhENVgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:54 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:51838 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhENVgs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:48 -0400
Received: by mail-pj1-f46.google.com with SMTP id k5so536025pjj.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/UIWHmvdwtfrOIscDc0heussLtIDhZOhV+XOUIj5B2c=;
        b=e2x7K43ivGNu0S4zu6vrPLuFNT0POIo2nMgtwR23d/YClrB99lJcu+IaDHN8ST50wm
         9qQtsF4ODsRGW7b8iPXFDhs6Lzjgz5wVAKD55ahF/WbXVefjG018VZqOFCnhxPghS7+R
         TJz47NVfwz05IU7cfu9ztDV8Lv3GPT0OBWMGPZE2scXI8CKGh8UULr0wYmXQpo+CSOtJ
         mZ4PPrAVwKwuzqp9ePvEygAv3b7TmysExQpiTMm2QGkBPvwkio+xc1yp1KZcrI7lcIBa
         VrzTRB+tM+qDD9nhjLR/QTVqP+2YN8Oxd3n8sKt1TOWk0JOZXxNuVOFaLTqqztBg+nfg
         NyPw==
X-Gm-Message-State: AOAM530gtd9wUT/ss4EMIMTmd6M59kGmneDV94fHh+hN+CGK5mJl2VJQ
        CxvsMHXRnasYHNKHeqp8x0s=
X-Google-Smtp-Source: ABdhPJxJggpocHYxNY0N1nfwJF2nmX5ntuq9RT1Y9jnJxsEn79U3UN8Bp5c9znNMb9RvCiHxXFYzkQ==
X-Received: by 2002:a17:902:8f93:b029:f0:ad44:35ee with SMTP id z19-20020a1709028f93b02900f0ad4435eemr2930062plo.43.1621028135712;
        Fri, 14 May 2021 14:35:35 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 01/50] core: Introduce the blk_req() function
Date:   Fri, 14 May 2021 14:33:07 -0700
Message-Id: <20210514213356.5264-53-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'request' member of struct scsi_cmnd is superfluous. The struct
request and struct scsi_cmnd data structures are adjacent and hence the
request pointer can be derived easily from a scsi_cmnd pointer. Introduce
a helper function that performs that conversion in a type-safe way. This
patch is the first step towards removing the request member from struct
scsi_cmnd. Making that change has the following advantages:
- This is a performance optimization since adding an offset to a pointer
  takes less time than dereferencing a pointer.
- struct scsi_cmnd becomes smaller.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index fed024f4c02a..f5825be7ee76 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -146,6 +146,12 @@ struct scsi_cmnd {
 	unsigned int extra_len;	/* length of alignment and padding */
 };
 
+/* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
+static inline struct request *blk_req(struct scsi_cmnd *scmd)
+{
+	return blk_mq_rq_from_pdu(scmd);
+}
+
 /*
  * Return the driver private allocation behind the command.
  * Only works if cmd_size is set in the host template.
