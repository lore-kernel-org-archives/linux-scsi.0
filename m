Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F2DC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBFCA2067D
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgF2WzP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:55:15 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35457 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgF2WzP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 18:55:15 -0400
Received: by mail-pj1-f66.google.com with SMTP id i4so8652411pjd.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 15:55:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wozg3uqgdUM3vwrgu+WARaaqs5hSy4N1wL+Q7LcUj2g=;
        b=s9UJNnOQope6bz6LgpOGz5HoXAXypwluMjN20bBmHPgirGw7HTuK+oQ2STKwo4Sq4e
         t7c7Ulz8KnjJzIsylQ7NEaMulm7RxtcjEaGINzOww5mzBQKgv2i8RhEBlJ9v8XmPEpr+
         Em4weqRjPe0zmAR3gIfwjxQ2XknQ8v8XoWGWjRBC4iSkObIV84I+872W2R8a4zWy5Lrx
         48zInbMTyDshnUFexRQIYIVFxBFA0vX92y+1zVStHsJ8R9jXQmUZvhkIZVGkoAt8d+7Z
         xhsCgXiefGFW5b3+//vd5M/UorZpGrNlC+eocmik3btnsO+9rEc/irnRZur4EWNmx3TK
         cecw==
X-Gm-Message-State: AOAM531kf0whdQskulbMcAMHZAvqKztP6PMUkbetjMmSItIf2STAJjpy
        18TBqjOBGvxB6LF5ONF0PV0=
X-Google-Smtp-Source: ABdhPJznyBSJ0GRZ9Nh8Mjfbo0H2ASp92iMR/NuBYXEI9A/z018LyB7q8XekWPQsYWEIRHFqVHlQ1A==
X-Received: by 2002:a17:902:9a07:: with SMTP id v7mr10027973plp.312.1593471314264;
        Mon, 29 Jun 2020 15:55:14 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mr8sm478379pjb.5.2020.06.29.15.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:55:13 -0700 (PDT)
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
Subject: [PATCH v2 6/9] qla2xxx: Make __qla2x00_alloc_iocbs() initialize 32 bits of request_t.handle
Date:   Mon, 29 Jun 2020 15:54:51 -0700
Message-Id: <20200629225454.22863-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
References: <20200629225454.22863-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The request_t 'handle' member is 32-bits wide, hence use wrt_reg_dword().
Change the cast in the wrt_reg_byte() call to make it clear that a
regular pointer is casted to an __iomem pointer.

Note: 'pkt' points to I/O memory for the qlafx00 adapter family and to
coherent memory for all other adapter families.

This patch fixes the following Coverity complaint:

CID 358864 (#1 of 1): Reliance on integer endianness (INCOMPATIBLE_CAST)
incompatible_cast: Pointer &pkt->handle points to an object whose effective
type is unsigned int (32 bits, unsigned) but is dereferenced as a narrower
unsigned short (16 bits, unsigned). This may lead to unexpected results
depending on machine endianness.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Fixes: 8ae6d9c7eb10 ("[SCSI] qla2xxx: Enhancements to support ISPFx00.")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 1d3c58c5f0e2..e3d2dea0b057 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2305,8 +2305,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	pkt = req->ring_ptr;
 	memset(pkt, 0, REQUEST_ENTRY_SIZE);
 	if (IS_QLAFX00(ha)) {
-		wrt_reg_byte((void __iomem *)&pkt->entry_count, req_cnt);
-		wrt_reg_word((void __iomem *)&pkt->handle, handle);
+		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
+		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);
 	} else {
 		pkt->entry_count = req_cnt;
 		pkt->handle = handle;
