Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98A5C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 14:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8F4A206C3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 14:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jcax+9eK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgHKOTf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 10:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgHKOTe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2020 10:19:34 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EF5C06174A;
        Tue, 11 Aug 2020 07:19:34 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id i26so9213311edv.4;
        Tue, 11 Aug 2020 07:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sRUO7nqZw8Td1PZj4u/+l9GQRmOqXg8WCKFUvaEDiMI=;
        b=Jcax+9eKmNuGFrqX1KUGfpVqdzP7oVH+uHXsTNt9QzQyQHQkWPs8JFnzLKk9eoSn6o
         G5RJFYjh1AzrLkns4IPfULDh19PQ26F/7wE21b4DFbp1N5l712G1YObhNPjjLdTVmpaL
         l8C9FzIPQBT4rN0dswDy2y+NtpwQOiK3dwRuldpDTqKS8n2hlQJXAw5UfDk1tJwklNV9
         pILsUtUQBEunS3EwK2m8oeAs8oj/YICZ2oWvsyKkLmA3Acl1/UDGllNulZeblIXlGJXJ
         qfD2UlIBDdZXL+PdwsWkFWaF0XRIQ7R154XP9CbUTodcvVoiO36wjm7WfC7I0c+se30M
         YGsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sRUO7nqZw8Td1PZj4u/+l9GQRmOqXg8WCKFUvaEDiMI=;
        b=etOisnqNI7sR7mEnvViMsp/p7zU8XeIapNJ356mBnN8oI5ju4ZWMxpGnI1iAEzkO0T
         AupDe0lfLsI5e+o5YoLoTAN8hr+tot+b/t8EuAHUGJUcG0ZqgEfIaDU3nfnsCmRY82DH
         gfWgaTdf6nUsXph3OLA1SYLUZczWas0wmLp9vA+KbXl9MOwhsyTrq7q52fzaspymPjDp
         UgXQrghT6f1y09weDu+LrAPzJTfsxOTfC497jig2w8eQK+sHZxcezEBICXEx3uRPbSrw
         v9S3lXhrseAZ66FhfOcKDSDJRe+i71J17ma53URxh52LNg8gfL4bJTpj3pBadOQk8DQy
         ttLQ==
X-Gm-Message-State: AOAM532yDcwiFpHTeBasjhATWbMjt65oY/46aSLlkbYOBbfmOtdIu9tv
        hUEXtSZB9jX31kBjWjgSo0E=
X-Google-Smtp-Source: ABdhPJwTojKvvsHa8ltrgMzjyaSPo572NZ8XaYM13FtE5r6rktPQ89hqILbeOx9BZoq1SVAKFqhjow==
X-Received: by 2002:a50:e109:: with SMTP id h9mr26461231edl.47.1597155573225;
        Tue, 11 Aug 2020 07:19:33 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b888:52c9:44c:d55b:5f94:2fc4])
        by smtp.gmail.com with ESMTPSA id q15sm1467050edc.74.2020.08.11.07.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 07:19:32 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] scsi: ufs: two fixups of ufshcd_abort()
Date:   Tue, 11 Aug 2020 16:18:57 +0200
Message-Id: <20200811141859.27399-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:

v1 - v2:
    1. add patch [1/2], which is from Stanley Chu <stanley.chu@mediatek.com>
    2. change goto command in patch [2/2], let it goto cleanup flow

Bean Huo (1):
  scsi: ufs: no need to send one Abort Task TM in case the task in DB
    was cleared

Stanley Chu (1):
  scsi: ufs: Cleanup completed request without interrupt notification

 drivers/scsi/ufs/ufshcd.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

-- 
2.17.1

