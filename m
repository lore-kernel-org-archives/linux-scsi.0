Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7F5C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9584610EA
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhKCRKF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhKCRKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:10:05 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FDDC061714
        for <linux-scsi@vger.kernel.org>; Wed,  3 Nov 2021 10:07:28 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 127so3037234pfu.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 10:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mnf5X/iTgBRFMMZkRgyzc0OpnzavKwGRo8XYeAaztzo=;
        b=F0ekRK3HoxvdErW+5fKZ6AZS1b99D2x2oYZNVXwHCbjzMYD2YGfPn2h+icOXWeRAs6
         QqabmdvtHlOyw3RF1RDr1FKdUl2mi9z9VJCE833ubY5AkijeiB39tr6AFPfG1K7yTI0A
         ZR7y5fmFtyM4Wg6mwdb2zNW6i5txQYhUdcmOlqwjUbj6SD+NgXQQ8BijaUC/dSg1TqXa
         AYaZK+sMb5VkZWIJqbqf4iKDdnH/j1nFGrTb7PfOuoaZNF9n4j2Fc8c2NbRBQvs3EV0d
         7qb7prde9wqykNUPAAbHIqvcM9rcgThDTTyV5qwIaevIX/utioCXQ+pDplqOmtos0Ci+
         DiHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mnf5X/iTgBRFMMZkRgyzc0OpnzavKwGRo8XYeAaztzo=;
        b=MpuPbePJJMebpKRO2cl0ObZ4WlJntixRv60bcZkd+HxVG/4/SKSNdJDoTLZ5/F8MLP
         qvOjcXv5DW+uv1C3ZXRUHVoEV197WV5rMhGGjycujRHZLIVGqmJfltgWfeZ3AAIGZMmW
         ZzL+n5OU+xo3E/t2mAseRKl2z7mg7YeHiJcWfwmKY8dBSGqgpFeHnlZMJlaHlqJNklQz
         upLcERG73MG8T3ObkGcu1Q3jUzXBQ7mitxVLYEaP4ETqRkJQLQxfiYXyPcG3pEOg+tsC
         +WB53SfJzhY/MIBGwkDeZ5ynfUuYWWZMwMqRfM9+H/DFlvKMdv+K+tT9KaPGJwp4y6kJ
         ln4Q==
X-Gm-Message-State: AOAM530LPxKoGvzWgB1UMuH8zAaCwh7SRzUp+KxOCkIxIJt2beRd4nAR
        Be/V0o1MfkBhhF2LDRtTJ/o19w==
X-Google-Smtp-Source: ABdhPJxSteJafoUWZ7oIH9dsvQq45m1SnOzEvy2k21xAG29248x5Dmvmt6v/lRSa7YGxCHe/Zu1fcA==
X-Received: by 2002:a63:af09:: with SMTP id w9mr33816541pge.323.1635959248142;
        Wed, 03 Nov 2021 10:07:28 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id k14sm3110810pff.64.2021.11.03.10.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 10:07:27 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 1/2] scsi: scsi_ioctl: Validate command size
Date:   Wed,  3 Nov 2021 10:06:58 -0700
Message-Id: <20211103170659.22151-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Need to make sure the command size is valid before copying
the command from user.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <stable@vger.kernel.org> # 5.15, 5.14, 5.10
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
Changes in v2:
- removed check for upper len limit as it is handled in sg_io()
---
 drivers/scsi/scsi_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 6ff2207bd45a..a06c61f22742 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -347,6 +347,8 @@ static int scsi_fill_sghdr_rq(struct scsi_device *sdev, struct request *rq,
 {
 	struct scsi_request *req = scsi_req(rq);
 
+	if (hdr->cmd_len < 6)
+		return -EMSGSIZE;
 	if (copy_from_user(req->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
 	if (!scsi_cmd_allowed(req->cmd, mode))
-- 
2.33.1

