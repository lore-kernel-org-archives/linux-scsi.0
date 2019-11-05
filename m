Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3312AC49EAA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 08:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 060B7214D8
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 08:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572944201;
	bh=zPVocWgcmNtLn7J4Nb0o01WbIi+yMXtmtX6i++56S5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CdyfSFQ1KrT7qshfDlwNPkxi9BYuYrQ+jnBVVsarW0yn2ylKm7TrGzIMGkubsfUtJ
	 JVTVbmRmIVFo+ACDlWnqWIyGCj1bpT2OEqx630dXNS90NO2mMccgRt0Q2XYQ4Wleoh
	 +jGC6yLpORtMTsNhBgaPS6USCPl5802DCa+WUyVY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbfKEI4i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 03:56:38 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38524 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730509AbfKEI4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 03:56:34 -0500
Received: by mail-lj1-f195.google.com with SMTP id v8so5196411ljh.5;
        Tue, 05 Nov 2019 00:56:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2pyiXXQ0QGXnUOP7x/bsC4CyQrXr0SrmnmYPxign9yQ=;
        b=LPgInKWbQuaDrEnZ9qn5tZBohPsQ1Uw0MCrD9OK+g8oasGBeKe2qtzCWv6nbVYB0hU
         oN7p5fnkiOaByQS14ZTQxPsHEjeejG6PM6zpd9XvlplDYDvYxg1xZaWhhjB/StPeI+7s
         daTBpG67J5kzR9HH9aHeVHk9zF+IsWs+aUuKShC6NxhaNZWjSYYSh7CmNDRx9piI04em
         a6VxEE6v5s4aQkD78fZWfBah/UJMPq8k9ZIjvXXFf6YfCKqeqiRtSlwGyVyh8Vjroflp
         clzMn94l2vZjd9oU7085iyE1rDxK8iERgs+Rxj0edKjdb9SPrw4h9crJEJfoHzFAcPk2
         1Bdg==
X-Gm-Message-State: APjAAAUXtSIYVG+u+wWz9AwDAqZ+YhPr06zv5tKImnJ3Yh0MQqt90hoL
        7xiCdcGQBplwgSesZ5lEoBE=
X-Google-Smtp-Source: APXvYqwmoXMmxJlEfNsFQArnDhO/sV6Z1d/d/GSLyJVNsQHWOdlNPnvKuD76pnoQiIgaTYTgUbpR2w==
X-Received: by 2002:a2e:b053:: with SMTP id d19mr1848380ljl.36.1572944192740;
        Tue, 05 Nov 2019 00:56:32 -0800 (PST)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id z17sm2368342ljz.30.2019.11.05.00.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 00:56:30 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iRuda-0000cr-JK; Tue, 05 Nov 2019 09:56:30 +0100
From:   Johan Hovold <johan@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 2/2] scsi: nsp_cs: enable compile-testing on 64-bit
Date:   Tue,  5 Nov 2019 09:56:09 +0100
Message-Id: <20191105085609.2338-3-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105085609.2338-1-johan@kernel.org>
References: <20191105085609.2338-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For some reason this driver depends on !64BIT, but it can still be
useful to allow compile-testing on 64-bit machines.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/scsi/pcmcia/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index 2368f34efba3..dc9b74c9348a 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -32,7 +32,7 @@ config PCMCIA_FDOMAIN
 
 config PCMCIA_NINJA_SCSI
 	tristate "NinjaSCSI-3 / NinjaSCSI-32Bi (16bit) PCMCIA support"
-	depends on !64BIT
+	depends on !64BIT || COMPILE_TEST
 	help
 	  If you intend to attach this type of PCMCIA SCSI host adapter to
 	  your computer, say Y here and read
-- 
2.23.0

