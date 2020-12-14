Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE3FC2BB48
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDF6622512
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502827AbgLNUVG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbgLNUVG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 15:21:06 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C70C0613D3;
        Mon, 14 Dec 2020 12:20:26 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id jx16so24341671ejb.10;
        Mon, 14 Dec 2020 12:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CAtJX87HqXXu8z9DPu1gGW2L6L0r7ONQKKLzHO1fhlQ=;
        b=C+fe6fZP1TyzKBNGaW3LtoCox4rIcmYQOaU/AZ3k/EnlwAdE11YbebbqXWTORnxWod
         5ahtEiayO26PSzWmOLPkl32Lyt4MYMW5/LiKiYnUhstsO3Kd2lKOLmnulPwGxoz7ON3j
         1n9GklV8ykXWFVRfOz0a61IjGRBzKJI5XwMbng3GGO9s+FuCIUH2YLlTL7ODTnlW5NT1
         Cmp5U+59K9dGVQpqmWRidQZ4sKScemDOzTE5ry5YzO5aiNPF+dWs0OSA7EicWhOqi5EA
         5akAIGeuk10AatEsiTGYiCsA2ponvV8+ey46LhE1SHYTGuNgVHEt+BQSfo9q6ZRUecSB
         iiRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CAtJX87HqXXu8z9DPu1gGW2L6L0r7ONQKKLzHO1fhlQ=;
        b=fof6hqXvzj9rDxiXo/atKyQi61Tx0dt/vQRqW7iC3nEMLkz6tXJZ5L3PulExPhMgl+
         0OneqTAW+A8oJlFYZ4ZrVGY58hy+5YME9IN+NtBBnMeL98KJOQznwEPffftNRAmKW01/
         pEA2aQiczKzXAr0CQGmGr934gtel4wFNR91dIE4ir+Lzr2drj3piCqpLBHc2JjkCXiEQ
         S3shSJkqA5BaBm1TpO0/fiP0V45aE4LgBjOP1nwxBKVPCFtf3D2xvYPaBWn9J6JEDfhc
         Bu5L85QfgtO6gMHniSDW0N7LCwFuyxhseDnxg+aEVdPTyQFntX4bPAJdOdaEJlzfSeUH
         cYJQ==
X-Gm-Message-State: AOAM532dMSvg7i8DJugdDEHp4p5GbGSF32X73J563UXC4XUzOgirH68M
        qbG0AxPauaXNMBJ2yVUchXw=
X-Google-Smtp-Source: ABdhPJx4TEOVB6AI5rxHDmYP9CjlKqOJ47Mfj2ukov49ocF0SB7yMBvtbk4NqrtVu+OtS/Wc+uIRvA==
X-Received: by 2002:a17:906:2818:: with SMTP id r24mr23244078ejc.100.1607977224826;
        Mon, 14 Dec 2020 12:20:24 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id r7sm9334634edh.86.2020.12.14.12.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:20:24 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org, joe@perches.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] Several changes for the UPIU trace
Date:   Mon, 14 Dec 2020 21:20:08 +0100
Message-Id: <20201214202014.13835-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:

V2--V3:
  1. Fix a typo in patch 1/6 (Reported-by: Joe Perches <joe@perches.com>)

V1--V2:
  1. Convert __get_str(str) to __print_symbolic()
  2. Add new patches 1/6, 2/6,3/6
  3. Use __print_symbolic() in patch 6/6

Bean Huo (6):
  scsi: ufs: Remove stringize operator '#' restriction
  scsi: ufs: Use __print_symbolic() for UFS trace string print
  scsi: ufs: Don't call trace_ufshcd_upiu() in case trace poit is
    disabled
  scsi: ufs: Distinguish between query REQ and query RSP in query trace
  scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM
    UPIU trace
  scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM

 drivers/scsi/ufs/ufs.h     |  17 ++++++
 drivers/scsi/ufs/ufshcd.c  |  72 ++++++++++++++++---------
 include/trace/events/ufs.h | 108 +++++++++++++++++++++++--------------
 3 files changed, 131 insertions(+), 66 deletions(-)

-- 
2.17.1

