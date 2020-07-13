Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29678C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A302077D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yYUh48KN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgGMHru (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729391AbgGMHrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:16 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5A2C061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j4so14665295wrp.10
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ERoz3fkdfBzQNDlM4+cYEX1ahP8otbMKTg0c52YoDQM=;
        b=yYUh48KN0Zmb3XwIAmWYhxedT6tKiKsH7prVn9xUAC5ez7airPPFOcLdygthJXRRvV
         I5vpKwHL6zlkGBu+4n7ddEcH6UocXT6wzUb2QbjnP6Jbsb+A+ZVtFe4ICd1zi6jdaHR6
         bERwig5lB+KrLPSzAi3zfPFjXVzHNSPbarzwJ/oyKnZwseEGT6qxygnnmUlyttFimk55
         /VIrwboCqRRQj6LodED8DN19y2h+fzZT+CiXie518pOrpl8q7jULg9pYHkGkA36MvFIC
         PuyPl+FfcYRJpRyMut3MtSyvVmvvbnErXmF1/+qW3fohRNTTkyGodjt5mEUhqJtLlrbX
         t48A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ERoz3fkdfBzQNDlM4+cYEX1ahP8otbMKTg0c52YoDQM=;
        b=VxVMpwsB51KFLgIFH06RUpSWaS9BxA+I3E96ArJpJ7Ffc+SExdYhBOZHueWBDFLpQ5
         UbEg0lS6vZMP3YY+MYDxRZFtvb41V4m3PTuJ8eQNKZgsRr6NzDCyErc35DqOcs6wbjBP
         DGDixegfA+pZlZlE7I0JA6YZv8rsBkQ4SuDkPus2WAjY4R8P7ABBc/HwywbHrobByOCd
         Whf8UKP7/FNnuMH9TRfw88uvJXuSlCIc/TXjG0VLMq+zk8ZvZzxQEwTomAzzFOzPBBeE
         5qWdzd4V/nyl6xj/rl0wamARn1wMbefF01+LGE4dMDtufRbeAFineApzW3xvEv0LB6Vh
         Aaqw==
X-Gm-Message-State: AOAM530d1idyDAR19AcOOd+ML1SQYOiw/40HcLRsmepwPb6DMf0v0T75
        YLlDKcFqEaoRZqNK42U/yCLwAA==
X-Google-Smtp-Source: ABdhPJxQyqXPz1y6vSze5cvmbtAH7bBLRqoz9XwPG2ZTG7RY3evXm6mZqbEgVT7UGWcPpjd+bu0ZrQ==
X-Received: by 2002:a5d:658a:: with SMTP id q10mr78337337wru.220.1594626434536;
        Mon, 13 Jul 2020 00:47:14 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:14 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH v2 25/29] scsi: aic94xx: aic94xx_init: Demote seemingly unintentional kerneldoc header
Date:   Mon, 13 Jul 2020 08:46:41 +0100
Message-Id: <20200713074645.126138-26-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the only use of kerneldoc in the sourcefile and no
descriptions are provided.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic94xx/aic94xx_init.c:538: warning: Function parameter or member 'asd_ha' not described in 'asd_free_edbs'

Cc: YueHaibing <yuehaibing@huawei.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index bef47f38dd0db..a195bfe9eccc0 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -530,7 +530,7 @@ static int asd_create_ha_caches(struct asd_ha_struct *asd_ha)
 	return 0;
 }
 
-/**
+/*
  * asd_free_edbs -- free empty data buffers
  * asd_ha: pointer to host adapter structure
  */
-- 
2.25.1

