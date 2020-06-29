Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA87C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61EB22063A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgF2WzR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:55:17 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40591 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgF2WzR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 18:55:17 -0400
Received: by mail-pf1-f196.google.com with SMTP id u5so8534658pfn.7
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 15:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7xa6NFI+S11VWHfwvQSsdqPE2V3UYkuUqqGGNmptq44=;
        b=iXUXw0nv8+OO7DAFfEaREMsZfWewGWOdQXGNL8+v/EAk45WPQM3wILzvIRuBR1S7UR
         BJ1k18jewWRUJoI0rIGREjXoe+qHuqQ924G+/8JxK1FPf2cKByfQRYrzqgMJdF87Y4im
         wl5wlje8RtJeKMn9eYJP7BNU7RWkyTUIiPJhICy3jSNaxTFpMMheujcwLr8WWYTFS2ZT
         YAEW6O0zzgaDoGWLcJvLvpTADwxJfvE3trfii9O9XmmUOsnLrSYRHMhwiPG9WQiyR5f3
         v3MLhUTBzsHVgRojCv/sSyvdwO5Qb0m0JmGWGi/LQu7tE2NNemx7cBxBGvK5rgGKBtcY
         j7kw==
X-Gm-Message-State: AOAM531uBoWSfPaSwZZ83S+y3H7ttIyusJQwJCreWqAJhOFYJw5HYDTd
        xhFznc9g5AjCodt+ZjuSJUCwaGXyCDg=
X-Google-Smtp-Source: ABdhPJzivQbT7mYtD71pZidu4L8m252lttzTO8nY97j0s44ZnhqmHFrtWIFZh4wGf1Ow2fTOaScFAg==
X-Received: by 2002:a62:2743:: with SMTP id n64mr15950295pfn.163.1593471315831;
        Mon, 29 Jun 2020 15:55:15 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mr8sm478379pjb.5.2020.06.29.15.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:55:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 7/9] qla2xxx: Fix a Coverity complaint in qla2100_fw_dump()
Date:   Mon, 29 Jun 2020 15:54:52 -0700
Message-Id: <20200629225454.22863-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
References: <20200629225454.22863-1-bvanassche@acm.org>
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

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 2 +-
 drivers/scsi/qla2xxx/qla_dbg.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 19005710f7f6..41493bd53fc0 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1063,7 +1063,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha)
 	}
 
 	if (rval == QLA_SUCCESS)
-		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
+		qla2xxx_copy_queues(ha, &fw->queue_dump[0]);
 
 	qla2xxx_dump_post_process(base_vha, rval);
 }
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 54ed020e6f75..91eb6901815c 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -53,6 +53,7 @@ struct qla2100_fw_dump {
 	__be16 fpm_b0_reg[64];
 	__be16 fpm_b1_reg[64];
 	__be16 risc_ram[0xf000];
+	u8	queue_dump[];
 };
 
 struct qla24xx_fw_dump {
