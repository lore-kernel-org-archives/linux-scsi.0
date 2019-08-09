Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFCBC0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 474FD2173C
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405297AbfHIDDj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:39 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46367 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:38 -0400
Received: by mail-pf1-f193.google.com with SMTP id c3so22085532pfa.13
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5mzYUvpY824donNEvb3aVB/8zkQjwgF1QoWLcFofEx4=;
        b=Dk3ZzJROHcGV0xrcU3c58N87YiB4O0moT6qjuGULpRpGz/5U7sxeCMTN4ZxVsPad9l
         2UcEbZ8oPFLDdo8u7vevHfIMXXTu9+LwgRwCQ/CvXRuYsXrrQoQXgTBfXUSqZCGUMIN9
         XE4cRSjD4Z67ZwHqIZvhd5tbTCf/luLu313sK22032PKgTZ1gXZ1g+vCmPvkSqYLNPoL
         UeX3uzgHCXeJKY6KR2Clyr0DJGEkWkmvs8uR+dJPiww5xCRHI3bKCu8CNFhSB+ed6AnC
         VCwfVyAxzH5pXsaJHb9qFxFQ1BdbuPDlX1B0h/ZBUmoUdDq8n7O6pchzM9Avp1UTn7Iy
         N00Q==
X-Gm-Message-State: APjAAAVZsPSM9lppth7gjClege+OPQVOBwDCHwzRGH9D4eSf9g5BIjwv
        u0bl4OCj2vfEoTcYuIc+jOY=
X-Google-Smtp-Source: APXvYqyIOZJla0S1vyg3KT6xDuQbaDZOKgaWjs8+ussBYUmSz0+dm30NeZT/w8iWYvm0VTHenFu0LQ==
X-Received: by 2002:a17:90a:a789:: with SMTP id f9mr490329pjq.19.1565319817914;
        Thu, 08 Aug 2019 20:03:37 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 46/58] qla2xxx: Make qlt_handle_abts_completion() more robust
Date:   Thu,  8 Aug 2019 20:02:07 -0700
Message-Id: <20190809030219.11296-47-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid that this function crashes if mcmd == NULL.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d25c3fa43601..cc0c99b5f3fb 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5731,7 +5731,7 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
 			    entry->error_subcode2);
 			ha->tgt.tgt_ops->free_mcmd(mcmd);
 		}
-	} else {
+	} else if (mcmd) {
 		ha->tgt.tgt_ops->free_mcmd(mcmd);
 	}
 }
-- 
2.22.0

