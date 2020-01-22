Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809A1C2D0DB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 10:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 563D524683
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 10:28:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VDO8HEep"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbgAVK2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:28:07 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54865 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgAVK2H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 05:28:07 -0500
Received: by mail-wm1-f68.google.com with SMTP id b19so6221496wmj.4;
        Wed, 22 Jan 2020 02:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Jb1rK1ijAKWlddeRTvmYvVI3ANewkHpq5mDohKCcHqo=;
        b=VDO8HEepQjI98oagAg2ZZ6v4zU4/OQRBSxkAX79mTodcCGPoMLvTcRqYpwIhOuCdou
         JGCjLsoTFZVLasXsk+Llt7X3E5v88SlQZJb3mISB5sOzeIZPdENqxRplRaXnk2nBgpr/
         rajHv7LpG3uEXQNvrB8H1iuVJ4zE31rwO9BIUaIcHaCNHycprGpfWrx/E9kbc7NW3Smq
         59ClloJdA37F02swbgFJxqw5ByuL5aEEqcOGxsWdQ+awxp7OZun9u/0JB6KtJNUfA3vm
         au6s/fSmq9mPk5idvFHkOotPpzR19yOn0ZVPVrHmxs6q1/B7oorpJdt1+v1HwvcZooTv
         AKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jb1rK1ijAKWlddeRTvmYvVI3ANewkHpq5mDohKCcHqo=;
        b=RsRsASK8W9dee7A9/rQVWsqIjTuUXqyJgKoK7K6JCSaMcx4InIlXWD4DN5SwKtJMLM
         9J10cKzYe9hoClq530HcsBs8BL10P+8chV73ddAr7PzbV5HDySF1EoBnf1//PLcoCIZE
         vTtl8CBAH34f0RVS3rNRxgk2yzKBmd7uJ4DL8TJuQyEOz7CzhFRNPIvUY6i0LA6nETe6
         Y1cw15Pcflg2K0Tu5nnRe1Gjp2HpXe6T0ymgMnzv+iM7frgOf2PctzR3mSeGk/QlxYVP
         xGQCZgkblASQyUiAi1LH5stkhYwlME6TeT4+wcLAJgPlaTrzpvkR1ZLV3Y8ZnNHlMFNq
         DoQw==
X-Gm-Message-State: APjAAAXeErISsAx5Bu1/6M2P15E2UKdySYNKExtzv9vu32p6EhzCiL67
        rLYD+K0rCX1m51btj0fhqgs=
X-Google-Smtp-Source: APXvYqwggLqehct3HtKdHf3zlyd9maoMrhlz1jXWSWT55ZJMouZk2ERZQtJ1Vgk+N+QouHMq4/Dhjw==
X-Received: by 2002:a7b:c8cd:: with SMTP id f13mr2207324wml.18.1579688885998;
        Wed, 22 Jan 2020 02:28:05 -0800 (PST)
Received: from ubuntu-G3.micron.com ([165.225.86.138])
        by smtp.gmail.com with ESMTPSA id c9sm3430107wmc.47.2020.01.22.02.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:28:05 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
X-Google-Original-From: Bean Huo <beanhuo@micron.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: scsi: ufs: remove pedrom.sousa@synopsys.com
Date:   Wed, 22 Jan 2020 11:27:51 +0100
Message-Id: <20200122102751.3490-1-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since Pedrom has left Synopsys and his email address doesn't work now.
Everytime after sending email, I will receive his undeliverable email.
Hence delete his email address.
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e09bd92a1e44..8c8956ab248c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16957,7 +16957,6 @@ F:	drivers/staging/unisys/
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
 R:	Alim Akhtar <alim.akhtar@samsung.com>
 R:	Avri Altman <avri.altman@wdc.com>
-R:	Pedro Sousa <pedrom.sousa@synopsys.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/ufs.txt
-- 
2.17.1

