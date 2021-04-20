Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B83C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 871A36109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhDTALL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:11 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:42627 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbhDTAKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:49 -0400
Received: by mail-pf1-f176.google.com with SMTP id w8so20843136pfn.9
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4YyCNLq3Ebz+eM6Zgd93gOYMLNVX+6xJQogiuxpj63Q=;
        b=mwf470l7LRIdm1NwsrMu30njykeXrHUmv+N3aOIrPmLfChT6uXozg/Pdec8PBaKPwg
         wlvKn9NLFRXbKh+jaOPotbkIrsf6eMek6y5tYbmCCtDJM4PyrX9Zid12su+/mVB+pIdH
         pXUirlE4QOzFXVnfGgfRRIvnxGauYiSE3WNAGK4OCzCQtj81MQvgP3w40iANHhronAod
         U861J+FPJedMYs4VPkE698j+GBosWiFq3w5Jjw3O+BsCSjBefT728IBfk/NTLRLvo6YS
         nfS5H/wSApY/scwSiFKssJeLdeWzVr+2yQ8f0sdcTsbx8obSSJJiMYC3Egy5LwskVZKL
         4Lww==
X-Gm-Message-State: AOAM533CKThzmzslrapft7q7Ngc60CkXTn9sUpHGnhPxDXJX4dHTieSj
        roGTwduxqqxrwr08CuDuwQE=
X-Google-Smtp-Source: ABdhPJzEaYiHV9R2WHpzHk25PMec5luo4PFOo5MtPiAJOiHEAz/tDHCBhbF0rJcdWoVwmWqaOn3rbw==
X-Received: by 2002:aa7:87d5:0:b029:25a:b5f8:15ab with SMTP id i21-20020aa787d50000b029025ab5f815abmr15858533pfo.22.1618877418374;
        Mon, 19 Apr 2021 17:10:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 075/117] nfsd: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:03 -0700
Message-Id: <20210420000845.25873-76-bvanassche@acm.org>
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

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 fs/nfsd/blocklayout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 1058659a8d31..f10f559684a6 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -255,9 +255,9 @@ static int nfsd4_scsi_identify_device(struct block_device *bdev,
 	req->cmd_len = COMMAND_SIZE(INQUIRY);
 
 	blk_execute_rq(NULL, rq, 1);
-	if (req->result) {
+	if (req->status.combined) {
 		pr_err("pNFS: INQUIRY 0x83 failed with: %x\n",
-			req->result);
+			req->status.combined);
 		error = -EIO;
 		goto out_put_request;
 	}
