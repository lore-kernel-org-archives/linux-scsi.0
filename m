Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEDDC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 05:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A20BC64E0E
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 05:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhA2F31 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 00:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhA2F30 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 00:29:26 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327C0C061573;
        Thu, 28 Jan 2021 21:28:46 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id g12so11187644ejf.8;
        Thu, 28 Jan 2021 21:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8f3on+5v4iBB2rL3AykrTv13S1IND7BtLGtDGclV4MM=;
        b=Y784vclj8qO6YSnTkd4sR+M4m3PKkQGBgvHcxtrMatOOxgdxfEvhgGzrqBUB6SRVTe
         9C1o0I6KlFYG/0obNYhYl6iIROEYE2tKc2/vz1IhrkdpPytkZO+Bt3WHVuzfU60sbdvo
         uGzTck+LBFEhPGNmRLi0OlNljFTeXLBDoFH7Os0xHv/fvlsfp0xepPzMTpQlDI1MLz7W
         yE6GP/Yn5ZGY1Lh9h2+RMPFhULsD5SWN2wp8yhJVY6jGRuCACYCh6MjnMg0Wbk5Vgvd9
         Ia85kqK2BPI+V4Glvfduivweo7ni/oLuT6ZnproJFxiGZhEFkxBUkDnXdy1yntgLlV2T
         GRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8f3on+5v4iBB2rL3AykrTv13S1IND7BtLGtDGclV4MM=;
        b=nWrADbdl5ML/Yknm2ZgWZk0UOMf0dDX3Kowov3E1FxE3a8MREMIRvzgzd6bS7VDU4g
         FiFAHBsagfsybdjWUlGMRguhoIoj7I66Lk09G87PoYn6OBARAQbdP7TCPGVBQWyMq4+/
         EowO0RUP2bWo46Wf001DOSfeRxZM0d0MKLwFLHSuYTqx/ApsCz46gB6cW2y50VnXVN0B
         r+PImtIfc1f5fnAhlWoBr3C8CHXV4uJCZ11WKgxrwrRdjtvpPF0d+n1XIegJqJVfWXA9
         z4g+1c4OxFHApurCVjcozHgrNZG/Dx2aKNyuzxye1XuIWwDJzUCrHdpyZBEAEpWFCGOz
         1/5Q==
X-Gm-Message-State: AOAM533TKORfmEZU9bZS0pLN33MK8UkbQ00PaI8vo0YELnCuawZCJRq4
        HRjWR6hlBAdPmp4jkrQvg3JKvP7bt7OczA==
X-Google-Smtp-Source: ABdhPJzTsfH5S/gnj802+W55fEk+rmkRp6O5DvJ3OUFe5YNQEKZMOYln9Qfx6rIvdxFKDAd4Gv5Z/g==
X-Received: by 2002:a17:906:c7d2:: with SMTP id dc18mr2849467ejb.149.1611898124934;
        Thu, 28 Jan 2021 21:28:44 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2d91:2600:859e:aee:ff42:2cc6])
        by smtp.gmail.com with ESMTPSA id p16sm3252082ejz.103.2021.01.28.21.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 21:28:44 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Pia Eichinger <pia.eichinger@st.oth-regensburg.de>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: adjust to gdth scsi driver removal
Date:   Fri, 29 Jan 2021 06:28:29 +0100
Message-Id: <20210129052829.13642-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 0653c358d2dc ("scsi: Drop gdth driver") misses to adjust MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:

  warning: no file matches F:    drivers/scsi/gdt*

Remove the GDT SCSI DISK ARRAY CONTROLLER DRIVER section as well, as the
driver is removed now.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on next-20210128

Hannes, Martin, please pick this minor fix-up on your scsi-next tree.

 MAINTAINERS | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dfb1f1af32bb..5e1fec71f21b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7363,13 +7363,6 @@ M:	Kieran Bingham <kbingham@kernel.org>
 S:	Supported
 F:	scripts/gdb/
 
-GDT SCSI DISK ARRAY CONTROLLER DRIVER
-M:	Achim Leubner <achim_leubner@adaptec.com>
-L:	linux-scsi@vger.kernel.org
-S:	Supported
-W:	http://www.icp-vortex.com/
-F:	drivers/scsi/gdt*
-
 GEMTEK FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
-- 
2.17.1

