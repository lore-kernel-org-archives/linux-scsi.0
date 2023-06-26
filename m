Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67E3EB64D7
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jun 2023 10:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjFZK7N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 06:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjFZK7L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 06:59:11 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD10C10C8
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 03:58:53 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-313e09a5b19so1583162f8f.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 03:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687777132; x=1690369132;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NmyUEybaSl8jewhXJwO5GjHWG9G5WP3PmoAzPe0ILkU=;
        b=avrpOfeIQ3438935VtYjHQuaBm+6uCU1b5BwltsAYwa5QvGk4cE0tbV7j8w+VbT7cu
         H+SsGvsDgY5AadNGqc6+K3GbYrsGh4guoZFpokrCCR95ax4iusW9hwzPYYGs+MRP8LLh
         sazU0behMVHCQC9sBhTpjbg9H/mILQaVXUUBXfY62QjQAg82LsIOVCgKkSporXWTHgAK
         a/P0/lOtjiPorhnOKLPSpMfDUOIGuFzVYZp4Ol6fWNUKgsjUSbzmvEDDr3j7Y9Yb+5rd
         LwJ4aLomAqL7hxZfvCowL3F+3NYvBYgp8fPKIaWRUmFxJgzIxembueIm5e+XRm0fh8EL
         aT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687777132; x=1690369132;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NmyUEybaSl8jewhXJwO5GjHWG9G5WP3PmoAzPe0ILkU=;
        b=Gter6ePfsR7P/SbHIvXWgg86rUfJC4G908aYM6mXAyadk1iWtUJKuov9zhwkfdhFF9
         JwyGazdilunVHjMEqS41ZC9Xz6u7m13HMKOGbTOWOFbYkYQOluLqiTn+vmbf11D+PYoR
         w2qgPYU85nuA2ni7PzhUiQ7QtzYqLF3vtvBdn+t3GvDjs5D2pJ+mN0mZoQw9Afp17xcq
         mFNohin5yPSrI4kFq2yEEMjcoamj0fJScSpWOGKtt2Nhg990LSH+VvRvrnln59F9Mq3f
         EPKJFyy4HO8ELvr1fpyzLSuTCG9b/scSZvnwt+61d2gSimYFh2lOGF80WNeZlcz2gBTY
         Y07A==
X-Gm-Message-State: AC+VfDxVZHLAnFIlssKB1aThXck9F0rdGDi7eMI5pToPL7yyodpTrsdy
        0gnusu3hwdILwrm6ngGks1eCTw==
X-Google-Smtp-Source: ACHHUZ5KMnxgiSOOYF9kimp5XVLCW8BXCZswbAvUiPD4AGxmYKKq49SRqCT0jLX3nnllF7SWgh7TDw==
X-Received: by 2002:adf:e910:0:b0:30f:c7e5:6176 with SMTP id f16-20020adfe910000000b0030fc7e56176mr26655207wrm.14.1687777132307;
        Mon, 26 Jun 2023 03:58:52 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id o7-20020adfeac7000000b003095bd71159sm7140636wrn.7.2023.06.26.03.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 03:58:51 -0700 (PDT)
Date:   Mon, 26 Jun 2023 13:58:47 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Quinn Tran <quinn.tran@cavium.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] scsi: qla2xxx: Fix error code in qla2x00_start_sp()
Message-ID: <49866d28-4cfe-47b0-842b-78f110e61aab@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aa0485e-766f-4b02-8d5d-c6781ea8f511@moroto.mountain>
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This should be negative -EAGAIN instead of positive.  The callers
treat non-zero error codes the same so it doesn't really impact
runtime beyond some trivial differences to debug output.

Fixes: 80676d054e5a ("scsi: qla2xxx: Fix session cleanup hang")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 9c70c4e973ee..730d8609276c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3912,7 +3912,7 @@ qla2x00_start_sp(srb_t *sp)
 
 	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
 	if (!pkt) {
-		rval = EAGAIN;
+		rval = -EAGAIN;
 		ql_log(ql_log_warn, vha, 0x700c,
 		    "qla2x00_alloc_iocbs failed.\n");
 		goto done;
-- 
2.39.2

