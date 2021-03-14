Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BDEC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Mar 2021 15:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EFB964E75
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Mar 2021 15:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhCNPcz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Mar 2021 11:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhCNPcu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Mar 2021 11:32:50 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131B5C061574
        for <linux-scsi@vger.kernel.org>; Sun, 14 Mar 2021 08:32:50 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w11so7405139wrr.10
        for <linux-scsi@vger.kernel.org>; Sun, 14 Mar 2021 08:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=bytX+5WvVh3XVBiMdmM47UYYwIb8mxjDw/4bivOZ4xY=;
        b=lTHLwb/r2XOXjpokvLMwoCWlIl0iq5/27Bon+mhol94sBolMWvNogFfaeQWy27Edwh
         gszyCJuH2AIBqGaSFsy6VmiFHkIJaIgKrdWO9aVwq3AcCSygb8LC8suezoVWhSS14ZyW
         1NjlS7IfpsP8OqFBXCels1QsTHDCLEzsRNhY7calLrBDHwX3Pt2m7/A6XzKHFgriaItF
         XCipz/K0F8c8OS9jDoPr/DGnNH+KqZYGE1xlpcfzhi4P7nP3q256xMb6F3iuZLQf++U2
         ei88yNRIO3izN4cP2J0zhNOLumkk+lHqcQE3XK323BlYpzMgNMbgBo6MSYQIjUsevFl/
         Rl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=bytX+5WvVh3XVBiMdmM47UYYwIb8mxjDw/4bivOZ4xY=;
        b=naSuv2Eu9kHUWSFWoD5xOHcV1EPPv/pWXi7YtxZZgeF3LiY3MTLxcQcIPxqr8wvs7B
         +zFkIy5rRZupyKMnzlRL+rqa0FnTMFgu4ihgk9ouHJQ8nO7EjGNdzQQzU2XTOG/NYuKo
         q9fklnVMjieOeOs9agk/r2vCDeQ7iUH1eKtiNKyVi7A6EdhXrjAdj31A8EP2dxBAFzJM
         qzXnGuMQeXcErI/WYGxL2yLV0kXtoJJHdXjoYYDP5vNXCEONmAZb4wZk3dNWAc29JbeE
         XMHDv/KDcesAX8haS4R62/cA7Sgw+sQjmstZRsISjIXpFmIcA7CEEYwGksvc8bFpjttr
         1gRA==
X-Gm-Message-State: AOAM531f27+RvjQbPVsYCw0r5kaGj3w9rgfe8ObHobsA5KmDi5N2vJFf
        0gmFPqVYATQ01mugiDRm0q2QzSxF4Q==
X-Google-Smtp-Source: ABdhPJx2laPfCQf4sOYMoy8yLRhafQxTgACQiCUZrVwhq7coWFyQgrnPM3Gw5Y9eM8fb04BGDytnTg==
X-Received: by 2002:a5d:67cf:: with SMTP id n15mr23214895wrw.95.1615735968777;
        Sun, 14 Mar 2021 08:32:48 -0700 (PDT)
Received: from localhost.localdomain ([46.53.248.83])
        by smtp.gmail.com with ESMTPSA id f22sm9567920wmb.31.2021.03.14.08.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 08:32:48 -0700 (PDT)
Date:   Sun, 14 Mar 2021 18:32:46 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, njavali@marvell.com
Subject: [PATCH] qla2xxx: fix broken #endif placement
Message-ID: <YE4snvoW1SuwcXAn@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only half of the file is under include guard because terminating #endif
is placed too early.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/qla2xxx/qla_target.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -116,7 +116,6 @@
 	(min(1270, ((ql) > 0) ? (QLA_TGT_DATASEGS_PER_CMD_24XX + \
 		QLA_TGT_DATASEGS_PER_CONT_24XX*((ql) - 1)) : 0))
 #endif
-#endif
 
 #define GET_TARGET_ID(ha, iocb) ((HAS_EXTENDED_IDS(ha))			\
 			 ? le16_to_cpu((iocb)->u.isp2x.target.extended)	\
@@ -244,6 +243,7 @@ struct ctio_to_2xxx {
 #ifndef CTIO_RET_TYPE
 #define CTIO_RET_TYPE	0x17		/* CTIO return entry */
 #define ATIO_TYPE7 0x06 /* Accept target I/O entry for 24xx */
+#endif
 
 struct fcp_hdr {
 	uint8_t  r_ctl;
