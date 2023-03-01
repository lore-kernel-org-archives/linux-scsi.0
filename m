Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3820DC678D4
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCAXHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCAXHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:08 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EFCC679
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:07 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id s12so16205596qtq.11
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=37gDeXfZBIRzr5hQYUOLChkVs/I2DI/dpxch2sylZGo=;
        b=nJXOAKd/ffQU0UkPRq2Oqiza8KRYXITUbW5+d2tvrNnLKqviI/kf6tSOaLVA6oDBsD
         y0//9eAFI0sxcaowssNnTUEx1vmFDmAF/uFUuHJXvRan0voJrqFN2fLLYMzUCxQylBeS
         jmyaYq0l0v6KjwKErrZOWzO+R+lbOIjIXmgF8BOxaT9kHPY0Qxz6KXrlvJryYhQwHru8
         7u8LnX/x1xfPrvgfBlsDpnD2+MIktOzNeK61YqD17AjGOkaG3MF2+YEahaCPmS2dd3Dg
         SkT2r5FVQnIF+tby1hImvi5g9xZhXsLxfzKV9cpd8HYcWcWUV3PlnRVGDVCN/jTjEnE9
         QXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=37gDeXfZBIRzr5hQYUOLChkVs/I2DI/dpxch2sylZGo=;
        b=nbYBF8tIe+pzZWcxwwLFlKYpGRKgYlyNk1qViLSln/95xa2zy/9+slR5k6y1Y5muIZ
         uZ5qhExsqF/s1JsgnBcwAfB6X6WT/ORRZkvVxrsa8wZoz5gcyh4sEeWsduSgkhtw8hcY
         Daf3lYp1gqOYHDPutQCAthSWTqkXDfNQYSjOOOHxy11UHqx9zpXcYZf/wMpp0BCGYDLf
         NTtQSKdFo6YGfLJ4TEF3q3AKQ//XFUoMuG6EdQ9NDnLn3M+5Rm3H3DeW8RoC9oglFgYg
         kz2xBkhr0QT/3Ima3/eIFOc3URme5SsY3j+6GT5mkRed4J8oi473RpdEFzKkANYbIM2h
         nTEA==
X-Gm-Message-State: AO0yUKU/kUt+8DWENruw1jGHn7Tw5DBpYUIGe1WpPPQANjOsFhihA9HD
        0tl0m1QezTNV7QAFjQlt3DiqxeN4W9k=
X-Google-Smtp-Source: AK7set/PywktF0ccEW39oH19m3JiDjqBJEA6qunNNYjq2RG9qPh61bf0ELc/Ov3TPUSDbuuPhQwN1g==
X-Received: by 2002:a05:622a:1448:b0:3bf:a564:573b with SMTP id v8-20020a05622a144800b003bfa564573bmr15904834qtx.0.1677712026524;
        Wed, 01 Mar 2023 15:07:06 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:06 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/10] lpfc: Update lpfc to revision 14.2.0.11
Date:   Wed,  1 Mar 2023 15:16:16 -0800
Message-Id: <20230301231626.9621-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.11

This patch set contains bug fixes for buffer overflow, resource management,
discovery, and HBA error status handling.

The patches were cut against Martin's 6.3/scsi-queue tree.

Justin Tee (10):
  lpfc: Protect against potential lpfc_debugfs_lockstat_write buffer
    overflow
  lpfc: Reorder freeing of various dma buffers and their list removal
  lpfc: Fix lockdep warning for rx_monitor lock when unloading driver
  lpfc: Record LOGO state with discovery engine even if aborted
  lpfc: Defer issuing new PLOGI if received RSCN before completing
    REG_LOGIN
  lpfc: Correct used_rpi count when devloss tmo fires with no recovery
  lpfc: Skip waiting for register ready bits when in unrecoverable state
  lpfc: Revise lpfc_error_lost_link reason code evaluation logic
  lpfc: Update lpfc version to 14.2.0.11
  lpfc: Copyright updates for 14.2.0.11 patches

 drivers/scsi/lpfc/lpfc_attr.c    |  6 ++++
 drivers/scsi/lpfc/lpfc_bsg.c     |  4 +--
 drivers/scsi/lpfc/lpfc_crtn.h    |  2 ++
 drivers/scsi/lpfc/lpfc_ct.c      |  8 ++---
 drivers/scsi/lpfc/lpfc_debugfs.c |  9 ++++--
 drivers/scsi/lpfc/lpfc_els.c     | 50 +++++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 39 +++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_hw.h      | 14 +--------
 drivers/scsi/lpfc/lpfc_init.c    |  5 ++--
 drivers/scsi/lpfc/lpfc_nvme.c    |  6 ++--
 drivers/scsi/lpfc/lpfc_sli.c     | 28 ++++++++++++++----
 drivers/scsi/lpfc/lpfc_sli4.h    | 19 ++++++++++++
 drivers/scsi/lpfc/lpfc_version.h |  2 +-
 13 files changed, 134 insertions(+), 58 deletions(-)

-- 
2.38.0

