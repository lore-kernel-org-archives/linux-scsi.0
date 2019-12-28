Return-Path: <SRS0=EFIP=2S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05959C2D0C8
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Dec 2019 05:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D068220722
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Dec 2019 05:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Os6dBwLu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfL1F4z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Dec 2019 00:56:55 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33055 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfL1F4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Dec 2019 00:56:55 -0500
Received: by mail-pf1-f195.google.com with SMTP id z16so15729184pfk.0;
        Fri, 27 Dec 2019 21:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7OIpJjie4YKsuRpHRWNnPtvHpiZZJeONgDblU2venY0=;
        b=Os6dBwLuuObAc/7/lx0paGvtFJn7f+DcAfFDfqrvewjuSi622rIGxd2zWxiaSJrP15
         zYUuizTGOTald9U/S93HOnMCv6pEPGVU3Lx6eUqgEx3LK3N/VM4nMKac/d9g1+xQizgI
         xky+PFWQH3edYHW3r5vAIrSCQ6S9vR3psZA6IBuAd7VcfALPbNPPay1N7bLPpPGwsazn
         5qtQTV15ynI6/HfzCc4qSjZ5QRTX7Q+ddtP4n8ON1M7bSH0B8TyVxDFcuLtfFDsh9xeF
         dr88AE+D8wFmP9sKsB+ODEuudTVYhjQPFfUqpfw2pyhPpmZ7Wn47ToSXdy6lsz+aBXpk
         +soQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7OIpJjie4YKsuRpHRWNnPtvHpiZZJeONgDblU2venY0=;
        b=dmSR8oP9gS3ky31U3bIZzf6maWDpB4Api2yFhImZ4+SpNTHDbVBgE0lF1UgwWi4lIS
         pIKp+jrDemCvU78UFeocdzN9xu1VQGpXtha+4DDcCmAH2OdWMjX8lIq40A1nzXrZITBL
         L2WpQeI1lx3s8tehKwnbFwT1eLTeuYsfBCSTQrWUEhywWtKO08F0pnx/QyEOSb6kGeiJ
         yie895frjw+R89LGa+vm8SjkgTtOQREQlz67Mwaj2W6ykdUE1nynn3LU475Nh8A01PbM
         XhW7+TzqFn/vF5gnuewuuEJHEEYnVM+7ume91Qh9PLGOiqzuQv+jYVVNcSomDDBejkiF
         niDQ==
X-Gm-Message-State: APjAAAXCYTk8//zb0cnQkvtFlSTrwk2/0QnfFHbkJH+Vk2g0KpQzKKTv
        vjAjjpoFroNMt98GN5KARtg=
X-Google-Smtp-Source: APXvYqyekuVTw7YXrVQjmQQ33q9y6/ohLU0ZBk261fVIeN3OzrJwL9e0vQEtKIujkMaRJjqZCBn8Bg==
X-Received: by 2002:a63:7d8:: with SMTP id 207mr59065588pgh.154.1577512614688;
        Fri, 27 Dec 2019 21:56:54 -0800 (PST)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id 65sm44606224pfu.140.2019.12.27.21.56.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Dec 2019 21:56:54 -0800 (PST)
Date:   Sat, 28 Dec 2019 11:26:46 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Hannes Reinecke <hare@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: ufs: sysfs: Use the correct style for SPDX License
 Identifier
Message-ID: <5ca6287665fe52d8f40062e0eab8561d2b7a5b40.1577511720.git.nishadkamdar@gmail.com>
References: <cover.1577511720.git.nishadkamdar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1577511720.git.nishadkamdar@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch corrects the SPDX License Identifier style in
header file related to UFS Host Controller. It assigns
explicit block comment to the SPDX License Identifier.

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/scsi/ufs/ufs-sysfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.h b/drivers/scsi/ufs/ufs-sysfs.h
index e5621e59a432..0f4e750a6748 100644
--- a/drivers/scsi/ufs/ufs-sysfs.h
+++ b/drivers/scsi/ufs/ufs-sysfs.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (C) 2018 Western Digital Corporation
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018 Western Digital Corporation
  */
 
 #ifndef __UFS_SYSFS_H__
-- 
2.17.1

