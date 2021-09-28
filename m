Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F50BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 194A96127C
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbhI1Vnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbhI1Vnp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 17:43:45 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30409C06161C;
        Tue, 28 Sep 2021 14:42:05 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v17so717607wrv.9;
        Tue, 28 Sep 2021 14:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pvllr3GeG294GoikM9fJ2KdjZeRxpceYgNhsknGjFb4=;
        b=ivwtjsgzIdJ4tJm476qLHT4bTmhxEPqnv+iDD7pngEM4LQkrBsu754kvUNDAf942UD
         MbZEygKqH1EOCAELMWqauclYLGipRjHYYLYIc2sd2wjzEc77EBe2IRV2sBgoH+nnXSk7
         88pTAJTh73Z+Z+KetURcLIiV+9KNbU9FGIATuTvzsfIZ+BtkMbxssXzMcSqVZCuYr6e7
         vhjYH8dmzw6hv3igcjqKrVkMwFqkAFaNH3Jf3XUoPxwa9k5W9zVEDSkKeUvilNMUmbar
         h7ntP8qJhuXqmntTBkiivCN+jpmLlde7cwmCCtJX5VPfJR8NXSVK+/A49T3xy5z3n4Yx
         wzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pvllr3GeG294GoikM9fJ2KdjZeRxpceYgNhsknGjFb4=;
        b=qPuSZthFCD8KIQaaCoGFn5TGo/lO6ZvFyCUuVJ0jzeU1ycbtyk2GBkuWFYRRQL07E8
         K/OrYSIJJ8HimULcQt0gspoVTx10OoHsoJXp+MoqSO4W9hvW5ady38D+6FIKqhRYeJnn
         AwxNOJFjFgnpUn6A54GCeu0+RBX3iGh6x9oz3Y/Rsgs1NteV9i1EFpLksAdKlahtOTD3
         2ZrowZfui12rmwOlqDyKxB4scBtDFBzrfEmnJj3hIVR9fk2ZO/Iq8i11PnH/44E83B34
         hDGIVLzHJU2cHyEwn/AHtlHMp9/cS4q8NDmOuXwGh4nBNAOX+YoYUnWNpLFaElGVNssk
         vVSg==
X-Gm-Message-State: AOAM532LSY8xfB8Hzd1f9FfPosXNzTawVxj0Q8c/mjKWcKRsiGcqoY6Z
        T642GmVXqXCNJNZHGCF1Hak=
X-Google-Smtp-Source: ABdhPJyXz3S85R74NDgdvUghApNFwzzoGIircmdV0ftmyzRJj/+f9zeN1KoOjXk44inSpGqCQNdcNw==
X-Received: by 2002:a05:6000:1567:: with SMTP id 7mr2811972wrz.84.1632865323842;
        Tue, 28 Sep 2021 14:42:03 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94717cfe07139628ae9da1147.dip0.t-ipconnect.de. [2003:e9:4717:cfe0:7139:628a:e9da:1147])
        by smtp.gmail.com with ESMTPSA id m4sm314147wrx.81.2021.09.28.14.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 14:42:03 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Two fixes for UFS
Date:   Tue, 28 Sep 2021 23:41:48 +0200
Message-Id: <20210928214150.779202-1-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

V1--V2:
    Fix a typo in the commit message

Bean Huo (2):
  scsi: ufs: ufshpb: Fix NULL pointer dereference
  scsi: ufs: core: Fix a non-constant function argument name

 drivers/scsi/ufs/ufshcd.c | 2 +-
 drivers/scsi/ufs/ufshpb.c | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

-- 
2.25.1

