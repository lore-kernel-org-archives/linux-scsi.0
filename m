Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB58C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 00:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FEC361177
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 00:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhKCAkX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 20:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhKCAkW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 20:40:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2559CC061205
        for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2021 17:37:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so195484pji.5
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 17:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wa3NOHCf3U1aur5kRZW335EJTyvo20m6TWpz6Ee93z4=;
        b=qeoNPWCDisFMYbqOExPhP7lwmk3zdmH9O9ZQGvHISlNSlwEAPnqKhXn/cMhVPZv7SV
         51R1D3RjVIXTO/57fsGpBvCUmLuPBbULkyG71KLy2CleqM4T8XPEhx250bxSYw8QrCt9
         qhJ5qrJlqe9V9InnPzX6BYEkXf+ulE2An33dO5RNbczxNQKGnV0pqjxLWz7lhR5WSXXd
         yD3olysYAUME5VL93e2LdmrW4Q/arnkLUaJS8y5cDM54e9h10oAdDnTHOfdwa4FYYnqA
         DHcRRksc5SkYc7CJfMAsrM+CHSWUXglTBw42ZIqcVxwfoe5rKD7hnBWIesSjtDoLWyf7
         bdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wa3NOHCf3U1aur5kRZW335EJTyvo20m6TWpz6Ee93z4=;
        b=Du7kOR0oCNI+I0hgXJVNLMgxlWwr3jZrswHI63MDZdEsSlBNensmK9qvE+Rny46rag
         o4FLkVduxpeLMv5V03szYAMVmpr5gCpKAbOFXCiaV377UBYyJPf1LLp4v85q2DLLHKrm
         A2Gc7ekBcn4RufUE+Hh3oSmthCm1ICISECVWPTVFCl7fLf+cBFbemF5MN/vxQn3UobZX
         f14LtuTywm8nuTRCr0hVKhywNSmeuzsWJX9+/u6ef3LTmRY+pXlrfy2BcSEtf3Bee2a1
         z9LOsnb6D+DjCNa1uMWASPMXMFaabamgqiZNZoRG6PAp0giCwFDM0KTeX16T9pixOnUQ
         snuA==
X-Gm-Message-State: AOAM532hPHiM2Uh8v52MKKWN2WJalq3JtninNsdkY1NMk/DdKaStj6te
        85n9DLxb5KtjtbD0ha/9n1YIdKAru+vhWVOq
X-Google-Smtp-Source: ABdhPJzkyqxuxEaanIPZ4V895U+b0wUB+nkMnRg4hv4eTHxChiPPXzjJShuyAcaJ+IPNzQtXka8kkw==
X-Received: by 2002:a17:90a:de0d:: with SMTP id m13mr10970746pjv.85.1635899866162;
        Tue, 02 Nov 2021 17:37:46 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id n20sm219159pgc.10.2021.11.02.17.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 17:37:45 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     linux-scsi@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/2] scsi: scsi_ioctl: Validate command size
Date:   Tue,  2 Nov 2021 17:37:18 -0700
Message-Id: <20211103003719.1041490-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Need to make sure the command size before copying the
command from user.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <stable@vger.kernel.org> # 5.15, 5.14, 5.10
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 drivers/scsi/scsi_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 6ff2207bd45a..58c1f62aca68 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -347,6 +347,8 @@ static int scsi_fill_sghdr_rq(struct scsi_device *sdev, struct request *rq,
 {
 	struct scsi_request *req = scsi_req(rq);
 
+	if (hdr->cmd_len < 6 || hdr->cmd_len > sizeof(req->__cmd))
+		return -EMSGSIZE;
 	if (copy_from_user(req->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
 	if (!scsi_cmd_allowed(req->cmd, mode))
-- 
2.31.1

