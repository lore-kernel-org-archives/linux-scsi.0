Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543E3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Mar 2022 20:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbiCWU5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Mar 2022 16:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiCWU5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2022 16:57:23 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3B98B6C7
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2022 13:55:53 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b13so497121pfv.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2022 13:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xi9iJzkxGYohQuPN+SK5Cjtyjt8hiQsB4kbq14uHCPM=;
        b=AedeBOVk7aeGJsfR2mTfehofTD0tNrYt+wYfLnwhvXXnNt2TZ4kZcz4BVZr5MqHVoi
         L89F8ZKA85GqaIkKP9rNisl49d++Wdy4Ep2RFCT2wKnvP5tpzvAlg7u6ce5/Jg0e/i1Q
         Te0/4JGgsKd216QsixenhmsHuzd7/tZ8BsK/Z65/nGw5QLxWyFza6ilGXkN/H/NqJRVI
         NoYGOkTgMQnHx/i1CDPljwc9hmkDocJ547UN+RJHtoCPS2OKKm23f2jFxYMdLl2XtJxd
         I6pkDUZLRXJ1VTvPpclOhPMQtVpBGPkWe6OWzuDX+2cIQ56I7EoKFpeNrzalT4KcqmIW
         Y3yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xi9iJzkxGYohQuPN+SK5Cjtyjt8hiQsB4kbq14uHCPM=;
        b=YZaKMiMKoY9kv+7vDwFNR/RcUTnuFaUmxOLXi/v7Z3s88V8UrxYqip8S7Zs62l3Wm7
         cNlkpSGxCXbYlvXXnH4u6vpkxq3yVYyolUBWZ3EnsNmVtVkZJaWuoGTXz9vVNJvYsxUP
         fM3YZO7xP4ZgXjGQewVK/3NXRXtHiO1iZLsy1Si9MhYrmudjwfpk1pWpFrNsx4ES9aiz
         v8TK9b7BoMAkpyKhCmQgP7z1RuAOyWCLqcP/w6fhtncWgLBTC7inhu8URWAsk8/4LEBn
         k66wTbIOnQn734rX63IAsFaXgSrEoBWTArhcqxY2ngsBSkJyIV3N3I7Hfte2lwSLI505
         mdvA==
X-Gm-Message-State: AOAM530jTl/4+uo3NutLpdBh/y4WQHaKFR8QgmDvqlonlAE62l4bNer8
        e+EufTxCdrnIdG8tFowowvxevxNfhsw=
X-Google-Smtp-Source: ABdhPJz7TpDHrx8PD5XBTHz80Cm8wufn+KPxDTL/eDH1i3wr7pk6QjlAeMri2Q0u2n9QZNe08KRLcw==
X-Received: by 2002:a05:6a00:1824:b0:4fa:8730:c986 with SMTP id y36-20020a056a00182400b004fa8730c986mr1733773pfa.43.1648068953209;
        Wed, 23 Mar 2022 13:55:53 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x7-20020a056a00188700b004fae6f0d3e5sm600521pfh.175.2022.03.23.13.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 13:55:52 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/2] lpfc: Fix regressions in 14.2.0.0 refactoring
Date:   Wed, 23 Mar 2022 13:55:43 -0700
Message-Id: <20220323205545.81814-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Two regressions were found in further testing of the refactoring
work done for the 14.2.0.0 driver rev.

These 2 patches correct the regressions

James Smart (2):
  lpfc: Fix broken sli4 abort path
  lpfc: Fix locking for lpfc_sli_iocbq_lookup

 drivers/scsi/lpfc/lpfc_scsi.c | 12 +++++++-----
 drivers/scsi/lpfc/lpfc_sli.c  | 10 ++++++++--
 2 files changed, 15 insertions(+), 7 deletions(-)

-- 
2.26.2

