Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68F8C07E9D
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 23:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99F65610F7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 23:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346541AbhGSW6O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Jul 2021 18:58:14 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:41552 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243150AbhGSWa5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jul 2021 18:30:57 -0400
Received: by mail-pj1-f46.google.com with SMTP id jx7-20020a17090b46c7b02901757deaf2c8so1389263pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jul 2021 16:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I526wSzOkW00CVxYXad8tWeRPw9m3Gt17/KZq068/AA=;
        b=fN2Kv4Yce9HmRQ4wTAkKI2dKTlQqinvSOx5E5DBmqTZhIa1oQ7yEvTvlxhu6/uOxxA
         xaIRZ+XZoY5doEJ4lriZamIxDjNlZkpilcCRbDexTaWHweR1Ht5Vb2N/d7kQruVIrkLH
         IBry/8vnuMiYPLML0PsLClA/G4tDDwlh4J07Essj8qTvxemDHmfG11CG7CEiMXK+kibe
         gKyEkG7giC/sR1iQ0N3mtUZS26MsMTOg9hz2U/79qAen++Q/SLfuvlPZtLu34VFyR+uF
         9LlqIhPX1r0uIr3GSK4XTyC39A3ei9/IXOVdSyaBuEKV1RR5uX/f5mwLlKLc9/8id8Db
         swAg==
X-Gm-Message-State: AOAM5304UCfcGtLgL61r0D1d2QXSUqeuxk6VyT4OMCxT4DNnKfYKFLZK
        VNFAwnIYfI1o0LY3t8wg+aw=
X-Google-Smtp-Source: ABdhPJx+gMyR3YFvAvIePUmM2o9//jognnaCMgE3wvh6dbcj7DPA+xF3mn1Rq3GsJotcRJrS4Af1Zg==
X-Received: by 2002:a17:90b:3617:: with SMTP id ml23mr26792259pjb.236.1626736296849;
        Mon, 19 Jul 2021 16:11:36 -0700 (PDT)
Received: from bvanassche-glaptop.corp.google.com ([2620:0:1000:2004:b968:4d11:8f24:cf85])
        by smtp.gmail.com with ESMTPSA id n32sm20855140pfv.59.2021.07.19.16.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 16:11:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH] scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()
Date:   Mon, 19 Jul 2021 16:11:22 -0700
Message-Id: <20210719231127.869088-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If param_offset > buff_len then the memcpy() statement in
ufshcd_read_desc_param() corrupts memory since it copies
256 + buff_len - param_offset bytes into a buffer with size buff_len.
Since param_offset < 256 this results in writing past the bound of the
output buffer.

Fixes: cbe193f6f093 ("scsi: ufs: Fix potential NULL pointer access during memcpy")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 89da2cf2c969..00502ffe9b4a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3365,7 +3365,9 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 
 	if (is_kmalloc) {
 		/* Make sure we don't copy more data than available */
-		if (param_offset + param_size > buff_len)
+		if (buff_len < param_offset)
+			param_size = 0;
+		else if (param_offset + param_size > buff_len)
 			param_size = buff_len - param_offset;
 		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
 	}
