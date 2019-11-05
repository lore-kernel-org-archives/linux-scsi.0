Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68264CA9ED4
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48B1920848
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfKEAmf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:42:35 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44930 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbfKEAme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:42:34 -0500
Received: by mail-pf1-f194.google.com with SMTP id q26so13798538pfn.11
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:42:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yKX9fQ9NGZSOomqGU7ja+xhT8Km25Q6j6CsIUYcN+vM=;
        b=e67+RmiRabGTw7v7+1UOjbr0asQJVMxNgWvXEsaWVn3maBZfoUoT8oj8Y9KQXGBQw9
         ucoHGo+A8vn62Llf7mJuUCynKFstQvgfmfvtNlNik9dfctfLX2duusHKXlvBzCOVzAaM
         vKtnTVtEXmNsxFayodhHD5aw+o+V9QOCRiniDtNY42/mimKbAoihpWNTdX0Po4cTQLcU
         huOEo4gXV4vqGWX03PS8wGyIws67eu6SI4686Blv3dWHADgl0r+GAQfcG/sfezu0N7AQ
         /7Hwz1Oeb7Xaefv5qF23tmGPWC+BsHOIEXQRx6YfZJdJ5K5p7qnIV6buD8roVMxRUPFD
         1YuQ==
X-Gm-Message-State: APjAAAXAWFik4Q6Xg6Y2DNHUmipz/W1yRsgXTViu4gRy2cL1vPJ5TSX0
        D24ZCydSs23wmg3fWbQkERQ=
X-Google-Smtp-Source: APXvYqwo0MqueWd0r5+12EjuRxpe0U/YGoJ6VfnEAIwGPV7sMk03vy8j8WQNXKwxakWVP1kfh5SsXQ==
X-Received: by 2002:a63:d20c:: with SMTP id a12mr30772544pgg.402.1572914554012;
        Mon, 04 Nov 2019 16:42:34 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a21sm4235449pjv.20.2019.11.04.16.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 16:42:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH RFC v2 1/5] Allow SCSI LLDs to reserve block layer tags
Date:   Mon,  4 Nov 2019 16:42:22 -0800
Message-Id: <20191105004226.232635-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
In-Reply-To: <20191105004226.232635-1-bvanassche@acm.org>
References: <20191105004226.232635-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_get_request() allocates a reserved tag if BLK_MQ_REQ_RESERVED has been
set in its third argument and a regular tag if that flag has not been set.
Make it possible for SCSI LLDs to mark a subset of the blk-mq tags as
'reserved'.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 1 +
 include/scsi/scsi_host.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2563b061f56b..b9ac7a93aafd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1894,6 +1894,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		shost->tag_set.ops = &scsi_mq_ops_no_commit;
 	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
 	shost->tag_set.queue_depth = shost->can_queue;
+	shost->tag_set.reserved_tags = shost->reserved_tags;
 	shost->tag_set.cmd_size = cmd_size;
 	shost->tag_set.numa_node = NUMA_NO_NODE;
 	shost->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index fccdf84ec7e2..abf1f0e59919 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -612,6 +612,8 @@ struct Scsi_Host {
 	 * is nr_hw_queues * can_queue.
 	 */
 	unsigned nr_hw_queues;
+	/* Number of tags that blk_mq_init_queue() should consider reserved. */
+	unsigned reserved_tags;
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

