Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE60C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2057B2071A
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgFNWjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:39:40 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39311 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbgFNWjh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 18:39:37 -0400
Received: by mail-pl1-f196.google.com with SMTP id v24so5999717plo.6
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2020 15:39:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tq326eO73Jg/ADfRmtMYw8srTNnadA8+cdvXjVwbeEU=;
        b=Jpi8OpdndclZH6FCnmxFyHJ/638rm0J8s3kP8UcQIYg/4oFP8wZG6jvUzuX717KlVv
         Es8Mr1F8uck1mlx9g+i+M191QF/eAEZe51SxfYj/UOar3Tb1qPCWAFD+mKXDhTGBs0Zq
         Dl56I+OeoH8bsuwUt8Ua1bmCoJC5lldGHE1O98DkNjB6EIeHG9ikWPtx/8Y6jPmMLYeQ
         qPPWp6bK8JhHszriI/UIdNR7kcZZjVNzboESisAJ5kapGkA5Vd8XpSrH6lk7H0G18O7K
         CsLWkgGHYGl4fJp+0jwD09WLlTuib4akCMGyhe7CCWx+7Kd+kFnz3ew96y7iLJQGhtqz
         p50g==
X-Gm-Message-State: AOAM530ljMP25Hy5cJM1ypoOHubn+DFeAmEo8sB0TtM+BhdpUG5oJyez
        Q6fdhoY3BMsbem6V8y2rZyY=
X-Google-Smtp-Source: ABdhPJxIeozXpCs+Z5JehB0w2kE6mFL/Bw3L2x7Ci4TUPGXKxxmJbKGMB1ZwoCAqAoFPx03weeOHog==
X-Received: by 2002:a17:90b:3004:: with SMTP id hg4mr9945917pjb.208.1592174376910;
        Sun, 14 Jun 2020 15:39:36 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u25sm11768711pfm.115.2020.06.14.15.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 15:39:36 -0700 (PDT)
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
Subject: [PATCH 6/9] qla2xxx: Make __qla2x00_alloc_iocbs() initialize 32 bits of request_t.handle
Date:   Sun, 14 Jun 2020 15:39:18 -0700
Message-Id: <20200614223921.5851-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200614223921.5851-1-bvanassche@acm.org>
References: <20200614223921.5851-1-bvanassche@acm.org>
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

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Fixes: 8ae6d9c7eb10 ("[SCSI] qla2xxx: Enhancements to support ISPFx00.")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8865c35d3421..7c2ad8c18398 100644
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
