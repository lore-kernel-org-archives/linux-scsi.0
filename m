Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD1EC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8F3C6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbhDTAL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:26 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:46615 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbhDTAK6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:58 -0400
Received: by mail-pl1-f176.google.com with SMTP id s20so2839562plr.13
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dnIB7fkR0ppzt0xr3zdaDYcmDYs3kwuioxp7i8u70aE=;
        b=DFrXw/RMwWQl/cWKJ3scGlDodfvid3wFSa7HK9/0WpOBLclqfOja4LKDujoFgCFe8Q
         J5V5lQNZOAwdOSsoyTSovfB5HCcZRvfux7bDzDpbern6ldp8hQpgpB7Rosu7Lk0ubpCM
         QUl+s+5ex0yUNw/sizZWcUDT6qDYC7vxXJGmKefC8lNRRtjoORuj3yWR7fM+oP6mc00v
         hPz3tx5OXBEW+geIddl9/LgZLP0h/Oh1wOo5DOX1cFTRWLlU4Qi0zgeO/AOp540rnXwc
         XFlUHH1EK3jGRa8dnbYGPERbFI7z2Q7+ebhuj1sLxroA4bA/iClyz+dUSJGlp2Qj19fA
         O3KQ==
X-Gm-Message-State: AOAM531AYpXvpGUiw+Q90W3b6R/dHvgbKczo6xN/sKeCWoRkP+VgC+N/
        r78+SbRbiShq6j/Zyre11eA=
X-Google-Smtp-Source: ABdhPJyGpkiJuZrDd/1TNQdahGUPAo52M+cq8kzrgALcCKlhqaAgeQSD8hzxRpzg0lmcCbrTFT4a6A==
X-Received: by 2002:a17:902:7c0d:b029:ec:a243:cf9b with SMTP id x13-20020a1709027c0db02900eca243cf9bmr8841916pll.75.1618877427569;
        Mon, 19 Apr 2021 17:10:27 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH 083/117] qedi: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:11 -0700
Message-Id: <20210420000845.25873-84-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..7879fd15177a 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -2016,7 +2016,7 @@ void qedi_trace_io(struct qedi_ctx *qedi, struct iscsi_task *task,
 	io_log->cached_sge = qedi->use_cached_sge;
 	io_log->slow_sge = qedi->use_slow_sge;
 	io_log->fast_sge = qedi->use_fast_sge;
-	io_log->result = sc_cmd->result;
+	io_log->result = sc_cmd->status.combined;
 	io_log->jiffies = jiffies;
 	io_log->blk_req_cpu = smp_processor_id();
 
