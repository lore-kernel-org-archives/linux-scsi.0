Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210D8C3A5A7
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 23:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiLAXJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 18:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiLAXJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 18:09:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E0393804
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 15:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669936113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4JvfJWU7+uq7jrpATovd2AsryJuPNwIs+V/5GzjE+z8=;
        b=Hl1FmKGjn7bLR58i1TR/e+DgV7GR/Ln1FPyWoyuUhRqF2ohzIXnE7IsecQkCr45I7OPncQ
        uR93aCjIiL0SIRJHIXpmNPrVeGEdYGArXim/SWPZW/FtE1yVB2VRz5M1KhnG8ianuHV0cI
        sRIQmloarvaB4lfMuphRXAG3N4EglGY=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-227-6oWAiVYaPQS8U8lDx2EOHw-1; Thu, 01 Dec 2022 18:08:32 -0500
X-MC-Unique: 6oWAiVYaPQS8U8lDx2EOHw-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-13b88262940so1486990fac.15
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 15:08:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4JvfJWU7+uq7jrpATovd2AsryJuPNwIs+V/5GzjE+z8=;
        b=HyAu/7f0MqjQG+VmlbFnu6zBzD7kWCNhu9LiCcC8kArFTYO145HSV5yNrT0aBssdfd
         daTdfrnjdpgUa2xn/gQd68vUDQ0GDaYGCi13DKsnGeGKYmNQ2J4CsVV8xLYHTxKO32tH
         yuW5qAZ9/SZzeT8WZu8mwRnT7dRbQW5ryhZnMX9Ks8uSFbPr4wWVuECdlql8SV7g+x5X
         1+YG92by9/6gU7Z+s+9h7gZvh8DUsWhT5/ldPfzX9Q5tw8G8EjKbPDp/t6kQPatpK3k5
         XCinaiE6Mchg1phbUqY7xIVtF0EqfeXdrmgoyfUcmEccKCpIuaSWn3nvv+QfIm3CV7vj
         vRag==
X-Gm-Message-State: ANoB5pna49qPATVenMZGI8fe7runxynsu6MJA40RF6w34jxt5oh0MuLk
        hOdjO3q0ucuFRDddGkpbUiAsPOFRw8CTx5OjG5wrvqjOIL8d8X59I771A7aTUkd4mNKW3D/Jn4x
        8eWQEDIFN8fUb/ynQ8NAlOw==
X-Received: by 2002:a05:6870:738f:b0:143:995e:807b with SMTP id z15-20020a056870738f00b00143995e807bmr14586264oam.160.1669936111502;
        Thu, 01 Dec 2022 15:08:31 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4R/AbnN+GXungjyYMQ/UXertPssHquQIq+R2j7hlnxk6+qDZ17QK95zUZPe2UXHoxhg7AYjQ==
X-Received: by 2002:a05:6870:738f:b0:143:995e:807b with SMTP id z15-20020a056870738f00b00143995e807bmr14586242oam.160.1669936111243;
        Thu, 01 Dec 2022 15:08:31 -0800 (PST)
Received: from halaney-x13s.redhat.com ([2600:1700:1ff0:d0e0::41])
        by smtp.gmail.com with ESMTPSA id y22-20020a4ade16000000b0049fb2a96de4sm2320393oot.0.2022.12.01.15.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 15:08:30 -0800 (PST)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     andersson@kernel.org
Cc:     agross@kernel.org, konrad.dybcio@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, p.zabel@pengutronix.de,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 0/4] scsi: ufs: ufs-qcom: Debug clean ups
Date:   Thu,  1 Dec 2022 17:08:06 -0600
Message-Id: <20221201230810.1019834-1-ahalaney@redhat.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series attempts to clean up some debug code paths in the
ufs-qcom driver.

Andrew Halaney (4):
  scsi: ufs: ufs-qcom: Drop unnecessary NULL checks
  scsi: ufs: ufs-qcom: Clean up dbg_register_dump
  scsi: ufs: ufs-qcom: Remove usage of dbg_print_en
  scsi: ufs: ufs-qcom: Use dev_err() where possible

 drivers/ufs/host/ufs-qcom.c | 135 +++++++++++++-----------------------
 drivers/ufs/host/ufs-qcom.h |  11 ---
 2 files changed, 48 insertions(+), 98 deletions(-)

-- 
2.38.1

