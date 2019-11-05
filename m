Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA6FC47E49
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 08:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAC7C214D8
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 08:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572944198;
	bh=bxxJ3At97W9ejJeVHBTKeg1vHlHOi0dxLZJ2xX1raco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DO0sFyUqjCoJKhYK6QZbDMXACYYrOoab0eoLHltStEdY3g3CvEP9eX4vqPvJTS+tY
	 YRkFStgY+vx36+7LnrKNooKwPz86drmnq/xDLWc2NCiZE0hSHKSV+COEJBL2UhpM1c
	 zb5US/lbmQr0fbFTriyg5pPXdWpGRH16mbHGjHFA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbfKEI4f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 03:56:35 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34574 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730433AbfKEI4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 03:56:34 -0500
Received: by mail-lf1-f67.google.com with SMTP id f5so14494234lfp.1;
        Tue, 05 Nov 2019 00:56:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7bb9D4WPcQK27Aximq7MEMFrCEKcoamLe8wArju1HWY=;
        b=LE9zZqSaU5KDi7ReRVRuDC/KdfJijXssH/mMo7WDexrprVddk6cTBCU9CdS8ILi2Kl
         23RFZj1zC2QzT+euZEClL8Xa1x+W82qLYIEj3EjeP7yJumnH0oKPcRvzfLFyRGtkh+bx
         wBiROE69LzBbAqTjPOLfScnOVWSEsYgLZb9rOKeWgYNuMGhK1xBfmDW73CWoEodiWi4y
         MOgDkw6ArHFb8d7fKTMPNLWgdjbd239syuRYKtazGp3oX0cQEgiWw9wT/OXRnFg0dzjl
         6WsdtAjX7pV66jNGouOfaSXHBlHKMwMcMprfP58cFbz432n3K2Sj7Qv/fHBTFZCm45uy
         eo+w==
X-Gm-Message-State: APjAAAWDeEjc6wTU0gSIo/lS/VPzRNNejNQbd43/mAwMxDQ6zwPrVwm3
        QNKgFEyY2b5IdmgdbmPoJtQ=
X-Google-Smtp-Source: APXvYqyVqua2p1bwHqX4uNUl6tgjGR8fZ/v8HunB5j+94A3HEw1xGg4GxSpf3aehL05R4tj1c3lAgQ==
X-Received: by 2002:a19:8196:: with SMTP id c144mr19349235lfd.129.1572944192326;
        Tue, 05 Nov 2019 00:56:32 -0800 (PST)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id z26sm8344171lfg.94.2019.11.05.00.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 00:56:30 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iRuda-0000cm-Gq; Tue, 05 Nov 2019 09:56:30 +0100
From:   Johan Hovold <johan@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 1/2] scsi: nsp_cs: drop redundant MODULE_LICENSE ifdef
Date:   Tue,  5 Nov 2019 09:56:08 +0100
Message-Id: <20191105085609.2338-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105085609.2338-1-johan@kernel.org>
References: <20191105085609.2338-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The MODULE_LICENSE macro is unconditionally defined in module.h, no need
to ifdef its use.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/scsi/pcmcia/nsp_cs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 97416e1dcc5b..93616f9fd6d7 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -56,9 +56,7 @@
 MODULE_AUTHOR("YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>");
 MODULE_DESCRIPTION("WorkBit NinjaSCSI-3 / NinjaSCSI-32Bi(16bit) PCMCIA SCSI host adapter module");
 MODULE_SUPPORTED_DEVICE("sd,sr,sg,st");
-#ifdef MODULE_LICENSE
 MODULE_LICENSE("GPL");
-#endif
 
 #include "nsp_io.h"
 
-- 
2.23.0

