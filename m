Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B21EC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 07:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58E8D20CC7
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 07:08:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJQhvxXY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgH1HIs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 03:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgH1HIs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 03:08:48 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57670C061264;
        Fri, 28 Aug 2020 00:08:47 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l2so182050eji.3;
        Fri, 28 Aug 2020 00:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HXOXmq5s+5xr9pj5xy7+jYoZFzInVOBH9Zr4gfwWfP4=;
        b=eJQhvxXYVJnPbsMLfzFUP4xrXCfrI6e7tjrluf3qNHhupvHC3ulEml6Mo/iYaIJE9O
         fjG3GVnF7GtGSbnL35kJU1t8rb9K6zcK1Mj+Flak3h1PsbeLAk3x/erHRKLtF0+10f3a
         /U+wDjYB/Kw6VUzDE2OIDpdX+rG7syqxC6BusaZq/5T+QMkc/JrjNT8S2NBmd4yNMAX8
         DIft37j+LYx38dZR6TcNt66SpDrHDyhn7IBPGzEn0LkdSmehM1OTtvJvin05EjlGgNfT
         c4WPp0w+SszLkkLMMIg1/gYmgRvZ2E0WI5QsIkjaERTubHiBwJsS7tGnyeeDGVoeCU/o
         bYrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HXOXmq5s+5xr9pj5xy7+jYoZFzInVOBH9Zr4gfwWfP4=;
        b=TXZm+3bz7bHUO+oeNp7jK6JeE6D1yAyaNK4jfcgDk+Zhi/DtdfBrPQ+rz6DRbq0WzU
         p3Uj5uYVWrGETc76LeEoGIf4IU/GUQQcU5TMolnDK5iRmDu3uSicKWqIespyxUveThe2
         3uN8ITqJ7JaB5uyUvZxoeCu1v37uHMufU0rRYTmoa1AY4SGfgzM5SaqR+smw8Ks6pLrP
         YyMklwYI9+NOT0o5QB9B55pQVC6hMfFywc8iB05Fo3Vdx46+oUthwATIC60UyakriP0u
         be9d2FfiH2ylvwJYPFyQq2NwgjuQUALjji4sEbpl/Bab3AEbSQlzCAnGd8mYMg0tZvMB
         DXow==
X-Gm-Message-State: AOAM530oKvX5zOnCsaaOmBIIHJnWhd0y+prOCuyMTKK/B8YlYdA7a/pv
        M1hTjvvlXa+/oFm2wz/v++I=
X-Google-Smtp-Source: ABdhPJzDtDJP+OFgVA3ZKUouqUhYlcc/gNPu/2CApK5JjTni3uOW8dD9njZtxpj22dK93U68RVecTA==
X-Received: by 2002:a17:906:7204:: with SMTP id m4mr388917ejk.342.1598598525970;
        Fri, 28 Aug 2020 00:08:45 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d94:4000:498f:ce0c:876:946c])
        by smtp.gmail.com with ESMTPSA id cf24sm88968ejb.61.2020.08.28.00.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 00:08:45 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: orphan sections with qlogic.com group alias
Date:   Fri, 28 Aug 2020 09:08:24 +0200
Message-Id: <20200828070824.8032-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Previous attempts of getting an answer from the qlogic.com group alias,
i.e., QLogic-Storage-Upstream@qlogic.com, have remained unanswered; see
links below.

Mark those sections Orphan to prepare their deletion or give an actual
person a chance to step up to maintain those drivers.

Link: https://lore.kernel.org/linux-spdx/20190606205526.447558989@linutronix.de
Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.2006300644130.4919@felia
Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.2008270740140.31123@felia

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on current master and next-20200828

James, Martin, please pick this minor non-urgent patch.

Anil, Sudarsana, if these drivers are still maintained by qlogic, please
provide actual names of people that maintain these drivers.

 MAINTAINERS | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b186ade3597..415058b48a2e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3507,15 +3507,13 @@ F:	drivers/net/ethernet/broadcom/bnx2.*
 F:	drivers/net/ethernet/broadcom/bnx2_*
 
 BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
-M:	QLogic-Storage-Upstream@qlogic.com
 L:	linux-scsi@vger.kernel.org
-S:	Supported
+S:	Orphan
 F:	drivers/scsi/bnx2fc/
 
 BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER
-M:	QLogic-Storage-Upstream@qlogic.com
 L:	linux-scsi@vger.kernel.org
-S:	Supported
+S:	Orphan
 F:	drivers/scsi/bnx2i/
 
 BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER
@@ -14212,9 +14210,8 @@ F:	Documentation/networking/device_drivers/ethernet/qlogic/LICENSE.qla3xxx
 F:	drivers/net/ethernet/qlogic/qla3xxx.*
 
 QLOGIC QLA4XXX iSCSI DRIVER
-M:	QLogic-Storage-Upstream@qlogic.com
 L:	linux-scsi@vger.kernel.org
-S:	Supported
+S:	Orphan
 F:	Documentation/scsi/LICENSE.qla4xxx
 F:	drivers/scsi/qla4xxx/
 
-- 
2.17.1

