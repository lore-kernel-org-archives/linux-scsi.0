Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8FAC43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A33EC613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbhENVhB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:01 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:39637 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhENVg5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:57 -0400
Received: by mail-pf1-f173.google.com with SMTP id c17so653230pfn.6
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bZYJ8fHp38zbqAQJSrWOFxcvcx3rN2CDAD1oYFPEzbY=;
        b=SlVAxBzbtm1gRstFx+C2SvI6qSlZSJyl2y2no+Vo7/h7Jfnior4YgHTruILrj9v5xg
         40Vl9YYhIdPt6ocV7pIc7pWEMlGhmOu8/e0s2kb7xrgn4xA9zyEd3Y2iZF7wf8iFXVw7
         qMd2xKHsL009XquY4zCAI7Yq83NIFgi7jm4pKZNigF5/UqReF3aTQViIajTM8IhtMnpf
         Rth2CcpDNM4bzXW8F/i6fpv+AImrhl5jPPqOPfzjRviBD+NqzVkDEnj//RR6UzPoAI7G
         vWuhV91xRBpQLW9NNOLsBa0dNyVxYzIubLKR3d7rj+7XmnkuJ8weebUsD93+DIWXIwsp
         ulig==
X-Gm-Message-State: AOAM5313vOk1shAKNnjEe81J4wtWxTQNQO5Ln7+t8hQc90V1UpOvfesn
        ytERkqJqHUVQfd1Plrw4f3P3apEmAiNwrw==
X-Google-Smtp-Source: ABdhPJxl1y1/pck+BKYjPeRtAaTtc1j82HVuEa6ORj5Rhh4b8hKRsNiTuqCk02a6LVlyrEyIOkojlw==
X-Received: by 2002:a65:48c2:: with SMTP id o2mr47907912pgs.376.1621028144395;
        Fri, 14 May 2021 14:35:44 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 06/50] scsi_transport_spi: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:12 -0700
Message-Id: <20210514213356.5264-58-bvanassche@acm.org>
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index c37dd15d16d2..e75c7c184a01 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1230,7 +1230,7 @@ int spi_populate_tag_msg(unsigned char *msg, struct scsi_cmnd *cmd)
 {
         if (cmd->flags & SCMD_TAGGED) {
 		*msg++ = SIMPLE_QUEUE_TAG;
-        	*msg++ = cmd->request->tag;
+        	*msg++ = blk_req(cmd)->tag;
         	return 2;
 	}
 
