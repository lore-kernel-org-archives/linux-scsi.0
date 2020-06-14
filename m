Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61350C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36FB0206D7
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgFNWja (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:39:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42931 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgFNWja (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 18:39:30 -0400
Received: by mail-pg1-f195.google.com with SMTP id e9so6768047pgo.9
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2020 15:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3rcGI+lv/GbDLHyVBFGFYQmwCj9Q/jOfgKgD1DKG3V0=;
        b=jDWAFj4DzdnVvhC/0E4rmj6Bmcw7lT7FlrKLNJpEuD3xxCQO6a6MpOyE/FAi4s4j5A
         zlRQoRwv0sZON7nrcEodJHJQ9I6eFpVU9KanNmnfTzvaD/Z6GmZ6L5sOZG2WGlTpVH7Y
         rxCvfYRyeaovDKqCHMiAPr6yOPydaLXWWZ1lQpDeGScpJKlcXNYThbDrUdG+s/ze6Fvp
         AXXebVnqRACuvQT3/lonMT9BJc0Yn7OPaqUvDRrMEWjljjTrMZo7WsFXXv7vA70pInLo
         95v3UwsPO1QC4DryBk65EQni6XBSU0edG3S6nwAyXSaC/XiVrJMjIiQbWV15Q9WkN87J
         ZCfA==
X-Gm-Message-State: AOAM533085NbpRZUCgtHOZqowuFU3XIPs7Y7fBbQo/y6jKUKz2dY0lJQ
        xCCqYjCFvI5re5CcruGqeOk=
X-Google-Smtp-Source: ABdhPJwfoRpGNdwQJWUpkU+FYRH7/3RXlygYw9d61/ayQuqajQ5aDMy5SzulJbVMf/pB7CDjzvCKTg==
X-Received: by 2002:a63:e314:: with SMTP id f20mr6123589pgh.116.1592174369589;
        Sun, 14 Jun 2020 15:39:29 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u25sm11768711pfm.115.2020.06.14.15.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 15:39:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 1/9] qla2xxx: Check the size of struct fcp_hdr at compile time
Date:   Sun, 14 Jun 2020 15:39:13 -0700
Message-Id: <20200614223921.5851-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200614223921.5851-1-bvanassche@acm.org>
References: <20200614223921.5851-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since struct fcp_hdr is used to exchange data with the firmware, check its
size at compile time.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 188aa5f02c01..f7e9b5bc0b26 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1971,6 +1971,7 @@ static int __init tcm_qla2xxx_init(void)
 	BUILD_BUG_ON(sizeof(struct ctio_crc2_to_fw) != 64);
 	BUILD_BUG_ON(sizeof(struct ctio_crc_from_fw) != 64);
 	BUILD_BUG_ON(sizeof(struct ctio_to_2xxx) != 64);
+	BUILD_BUG_ON(sizeof(struct fcp_hdr) != 24);
 	BUILD_BUG_ON(sizeof(struct fcp_hdr_le) != 24);
 	BUILD_BUG_ON(sizeof(struct nack_to_isp) != 64);
 
