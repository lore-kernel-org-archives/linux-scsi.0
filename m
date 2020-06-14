Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B15C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CF3E206D7
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgFNWjl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:39:41 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42941 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgFNWjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 18:39:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id e9so6768163pgo.9
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2020 15:39:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lFjh0ainvvAyvsbkM9NQ0MeC1XuOATfgG9XyDriCGbs=;
        b=P+d+0q96GWoHfknv/T8PbTRJOA6BN/YReZIA2DZAHSEuFXyDHuELo4bisu5UKqKeTm
         obZgE0JWXTJRJwfu9SBGzYgHFOuoDhtBq5ufa7/o0M4LJ7RbsSXadEpwKvOdMWwxAu/b
         X5P9Xqtn95pI7Qc03YJRg1yrXtJ2IInGUG+3b2JM99acFVxN7++Crzt25LiRSE5C4N4j
         0F7EnlsYheCLpUTtveS64tAh0wtUrbTMsrGkzycX31McB+XZyPcwJSjuHn8obTJ8cT9k
         7elzsJJbJ/Wtnyhs+xo1o0B00i765efTHvUZ7L93OncHuPDds1Du/3yq6iigGes5GLVm
         6D/g==
X-Gm-Message-State: AOAM532OapfX6yK3Ej7RJWRTvsiY+fH/Oh1DQ1iQAYtvXG5W3uRCwkwq
        NZhCxlyhXtnrV+LMVXRyRU4=
X-Google-Smtp-Source: ABdhPJzxQqew76Fu2aV1GSEKuq/LVWtAAZt5B6e7qJj8nrZLw7pIkDe4mO5tNL4HTS5KDYR+8+SQjA==
X-Received: by 2002:a63:c64c:: with SMTP id x12mr15497100pgg.362.1592174378325;
        Sun, 14 Jun 2020 15:39:38 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u25sm11768711pfm.115.2020.06.14.15.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 15:39:37 -0700 (PDT)
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
Subject: [PATCH 7/9] qla2xxx: Fix a Coverity complaint in qla2100_fw_dump()
Date:   Sun, 14 Jun 2020 15:39:19 -0700
Message-Id: <20200614223921.5851-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200614223921.5851-1-bvanassche@acm.org>
References: <20200614223921.5851-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'cnt' can exceed the size of the risc_ram[] array. Prevent that Coverity
complains by rewriting an address calculation expression. This patch fixes
the following Coverity complaint:

CID 337803 (#1 of 1): Out-of-bounds read (OVERRUN)
109. overrun-local: Overrunning array of 122880 bytes at byte offset 122880
by dereferencing pointer &fw->risc_ram[cnt].

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2ed0b849fbfe..5e873b70e843 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1063,7 +1063,8 @@ qla2100_fw_dump(scsi_qla_host_t *vha)
 	}
 
 	if (rval == QLA_SUCCESS)
-		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
+		qla2xxx_copy_queues(ha, (char *)fw +
+				    offsetof(typeof(*fw), risc_ram) + cnt);
 
 	qla2xxx_dump_post_process(base_vha, rval);
 }
