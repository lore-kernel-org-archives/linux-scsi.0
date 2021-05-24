Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38A6C47084
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97A0161159
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhEXDMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:12:01 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:33310 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbhEXDLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:55 -0400
Received: by mail-pg1-f176.google.com with SMTP id i5so19085303pgm.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N6tGovZwyZgc/h6C+G0vQzZVeY7I9MAosRqmfjA9/h8=;
        b=VBE+WGv1FQAsd8C7kOMkgLUJsLXZdHRdyfm4h9/nXVjT0n9RLx4tvxEt4PMR9ttLwu
         xbxo4tvGECpiT+qWFRIxZWY12Iwk7X5hqYek1QLkP+AG7KsI9jaLuwFY4BZazOXJO7KK
         U4xvRHPsOqhTQ9FCugAo99hk3E/rOQkTnzi5cNpBmPSBEmTWj3NLRErt6vRIAUL90RaT
         fczeQ4aNmHT1xGSYkCwXCMICis5qpyMoaN80h0ZuMsVhGvIMxuiFC0bbQr0OQBrVp6No
         KZCHGmtdgaxAP/dZi4QdlSdlmtu/RCXM8zv40LTMMMkTEutgrcINDYjxlsJtfFAnOLSg
         TmoA==
X-Gm-Message-State: AOAM532E9nSfjBi5QEX/Qd7F7fQVSC6o+Ed1tQiFonx5E7E/fN83ZWQ6
        B9JhDMOk1w8KT+D0CZBRskY=
X-Google-Smtp-Source: ABdhPJx+IvWdwXRmNrzvtY3C7D42o2A94nE7J8AgMqa3Zi/d5agrPjbwrWYrXmhZdsvuSZZXSUCnzQ==
X-Received: by 2002:a63:34cc:: with SMTP id b195mr11165007pga.449.1621825826775;
        Sun, 23 May 2021 20:10:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 48/51] xen-scsifront: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:53 -0700
Message-Id: <20210524030856.2824-49-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Acked-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 259fc248d06c..efb95e222e70 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -212,7 +212,7 @@ static int scsifront_do_request(struct vscsifrnt_info *info,
 	memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
 
 	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
-	ring_req->timeout_per_command = sc->request->timeout / HZ;
+	ring_req->timeout_per_command = scsi_cmd_to_rq(sc)->timeout / HZ;
 
 	for (i = 0; i < (shadow->nr_segments & ~VSCSIIF_SG_GRANT); i++)
 		ring_req->seg[i] = shadow->seg[i];
