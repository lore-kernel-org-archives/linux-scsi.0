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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0475FC2D0DA
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Dec 2019 05:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9BA920722
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Dec 2019 05:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwFO/WIG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfL1Fzr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Dec 2019 00:55:47 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45723 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfL1Fzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Dec 2019 00:55:46 -0500
Received: by mail-pf1-f195.google.com with SMTP id 2so15697813pfg.12;
        Fri, 27 Dec 2019 21:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rzb2iWzVOOE5ZHAy7Xq+QC6ez/IcLN6B9JqJpd3OZE8=;
        b=NwFO/WIGuzTo8IvRNWHmFJa4lb5MaWAjgbFU5DbMgG1M1wR7yq1IZtaLnCklK9rZW9
         gMVE7CBAzRPv7O4vhdUDsH708QNB8VV42Fpibb8wrwlX7zAKeMY+1/gRuyr4tC0PttlH
         uUf1UYicUqXHFnQfA/8OXtGcPNMwEF93y6pjI6PCDKRhtJYDAxhooj0X/nxO8/48U/Qs
         DDwZloUVky9yibWSofKkSYl8ZmDblwIObWNoqDvwQ3SvDamq2OWIFVfWRtQbbBcJiRMr
         D0Or40UP/5xo3X88ptGACp45iZneOIGdFgXwsNwG2enVesMxORasjNnBA2JrTxRzggz7
         6xgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rzb2iWzVOOE5ZHAy7Xq+QC6ez/IcLN6B9JqJpd3OZE8=;
        b=JmfuRixx3IspZUxT2eVwo6F7z98IRaJ26nR+EUlMJzOASVP8rP9GkwCK3TbAnrtO7E
         +neLVBInylvApF4kd4i9PSSKBpDubSLndE2p5rC4vb5KB1jVRRGjteAC01at5LQi4oYG
         aRmdinbpK1fxOAIzpCVdRrzNnaoT7Tq5L22nwjhbfhZFTkafS1CkXQFMXvnVH4Nv5wO8
         qtrnGeMLJ8LEGu1CTzExsuD39o2MycsZitiAWcho00G4RWn4uSJ46gk1+DYaWPA6YihO
         2keDDq6arkYq6RQaB69ir3LHii9WBTtU3x3FnVSu5qihH01AV5C0/YhnFJiRJqYFWuI8
         DZuw==
X-Gm-Message-State: APjAAAXYNYYiktBqUNXu4179eDRlx8b33O/+qShMDazm+u9VegEmZPUr
        l4bSE1Mfrz031rTUW66cxZI=
X-Google-Smtp-Source: APXvYqzLP2MDNYi9/ZhjjcbwKR+kR4RqcQ80x56ny14ih6rpA12XKPxWHUWAerkT8xxDqaO/jYVD9A==
X-Received: by 2002:a62:62c4:: with SMTP id w187mr31317532pfb.216.1577512546250;
        Fri, 27 Dec 2019 21:55:46 -0800 (PST)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id r1sm16361535pjp.29.2019.12.27.21.55.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Dec 2019 21:55:45 -0800 (PST)
Date:   Sat, 28 Dec 2019 11:25:38 +0530
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
Subject: [PATCH 1/2] scsi: mylex: Use the correct style for SPDX License
 Identifier
Message-ID: <88332ad390f985bdebb9f2adaf2d499b0a639753.1577511720.git.nishadkamdar@gmail.com>
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
header files related to Mylex DAC960/DAC1100 PCI RAID
Controllers. It assigns explicit block comment to the
SPDX License Identifier.

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/scsi/myrb.h | 4 ++--
 drivers/scsi/myrs.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/myrb.h b/drivers/scsi/myrb.h
index 9289c19fcb2f..fb8eacfceee8 100644
--- a/drivers/scsi/myrb.h
+++ b/drivers/scsi/myrb.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- *
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
  * Linux Driver for Mylex DAC960/AcceleRAID/eXtremeRAID PCI RAID Controllers
  *
  * Copyright 2017 Hannes Reinecke, SUSE Linux GmbH <hare@suse.com>
diff --git a/drivers/scsi/myrs.h b/drivers/scsi/myrs.h
index e6702ee85e9f..9f6696d0ddd5 100644
--- a/drivers/scsi/myrs.h
+++ b/drivers/scsi/myrs.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- *
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
  * Linux Driver for Mylex DAC960/AcceleRAID/eXtremeRAID PCI RAID Controllers
  *
  * This driver supports the newer, SCSI-based firmware interface only.
-- 
2.17.1

