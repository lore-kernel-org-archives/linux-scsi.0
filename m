Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100DDC4742C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7F82206F8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DmDYPWXt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgKBOZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgKBOYN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:13 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A27C061A04
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:12 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id h22so9699102wmb.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mzeTsnVBQeYqxq9T62Y4dbDZSOnvVH0q+uB/IaQ0f7A=;
        b=DmDYPWXtnNuGHa6+tatUFk5QuHY4P4xSS6RYT8Gi1DqL5YQAxlVL6dREZDhAANp77/
         Sm5qufyo+ehieT15KjiZ7iqVwv0J6Qyf17VXXGYXDHX9jh3Kx6QqNU/9ZeJbWFbJSApC
         phoXu4Rja9nt7CMqDsO7n2jJhL/cjpXI0m2sPX35uE/TEVufO7DA1dxRjWjMwSFlyWkY
         Yy0x7/2YHj4IVGPYmSc/jY6lUh/rmRc06x0hJmB8MKjqHjder1Ym829TJjzvEADuVSKX
         f+SncEEEEndwGzXPYtPvk8yArX1v/OE1/MhWarv5FmdExUK7EjHy3TNciwei95VccO5m
         uRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mzeTsnVBQeYqxq9T62Y4dbDZSOnvVH0q+uB/IaQ0f7A=;
        b=YeFmLW3Iw2fqicvTrO9+y7wSqRsvL6gEwJD9KRnMtU3wD+8rCiLawlN3UhW+XayqLF
         O6QocOOWxEkPlsVLP63b70RuDnmEeB0mqme7InSnvjK0lhCZb3V+bsBPl1wTYT9KKZQH
         SyqWLToBnby7ZDcVIqAsIR9jvzWOR8MYh9WNC0vNIroPjX84p8CDX5XMqRriJlgoXHbb
         /q3PGzkbZSTRCIk/xUEn4Sfm2SD0yIdmymD2nexXfqJGJ4sHe9gvYGxHg4YCVVu0ZQ6w
         0s9asSNF41gUaj5uZQezSQtNO4mxmvTYJvpfRqlbWeMVnw1EiI1qL/VhUybBrgqd/yfW
         40YA==
X-Gm-Message-State: AOAM530YjfJRmhvkFVqilztNbug0JUHr2PzAxktZt1tgTUnFHygzfzMD
        jOS0oy/6MtXFOawPiK4HIw7Rng==
X-Google-Smtp-Source: ABdhPJzGG8Kirb9ed21xWpDkJf4IlXV5eshgVVQ2V2F96eVC5pVPn5sCprzulPBLnTyJ9tet1oQuXA==
X-Received: by 2002:a1c:2901:: with SMTP id p1mr18492705wmp.170.1604327051506;
        Mon, 02 Nov 2020 06:24:11 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:10 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [RESEND 06/19] scsi: lpfc: lpfc_debugfs: Fix a couple of function documentation issues
Date:   Mon,  2 Nov 2020 14:23:46 +0000
Message-Id: <20201102142359.561122-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_debugfs.c:4204: warning: Function parameter or member 'len' not described in 'lpfc_idiag_queacc_read_qe'
 drivers/scsi/lpfc/lpfc_debugfs.c:4781: warning: Function parameter or member 'ctlregid' not described in 'lpfc_idiag_ctlacc_read_reg'
 drivers/scsi/lpfc/lpfc_debugfs.c:4781: warning: Excess function parameter 'drbregid' description in 'lpfc_idiag_ctlacc_read_reg'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 325081ac65539..5a354abcbafc4 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -4186,6 +4186,7 @@ lpfc_idiag_que_param_check(struct lpfc_queue *q, int index, int count)
 /**
  * lpfc_idiag_queacc_read_qe - read a single entry from the given queue index
  * @pbuffer: The pointer to buffer to copy the read data into.
+ * @len: Length of the buffer.
  * @pque: The pointer to the queue to be read.
  * @index: The index into the queue entry.
  *
@@ -4762,7 +4763,7 @@ lpfc_idiag_drbacc_write(struct file *file, const char __user *buf,
  * @phba: The pointer to hba structure.
  * @pbuffer: The pointer to the buffer to copy the data to.
  * @len: The length of bytes to copied.
- * @drbregid: The id to doorbell registers.
+ * @ctlregid: The id to doorbell registers.
  *
  * Description:
  * This routine reads a control register and copies its content to the
-- 
2.25.1

