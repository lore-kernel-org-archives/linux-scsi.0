Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89680C77B7A
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 19:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjDQTFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 15:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjDQTFq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 15:05:46 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FBE5BB3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:05:30 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-63b875d0027so587539b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681758329; x=1684350329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nu0FgEWXnpBhPGUc+h6nHpwsNCiBBQeBvwietVqpOCY=;
        b=rs8LRKi2T7r1Q8sfy/jTMRmPs5+tHvVONgNZHTCYj+654MQOLFlBQgG0zcN445LGzw
         Sq/a1JwYgIKv4uqdWR9lu1ZVqCM5jVIlH64pQ1C2E9Ba/9ykAC8kQbpC2M+YUq25NJip
         A1DukqA6LvWhp3uyBjaZoE3Iu56vz/xJXKe2OS0D2m8fHOYA/s1+7uMwjhcYKOvYrKGY
         xJcfLQ0b90M0RtXECvlK+DhnDCdZ/lZyBuZ/8r2rq5XQKf612Cd0E6oDmF7hGbj6iJ5l
         Cgc7PjSsbK1eSd+RuwUUKufWBppg2fHVMKKgSVy7+TcZSMiKGlruUZd1yfTGiZ4DkGAM
         jPxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758329; x=1684350329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nu0FgEWXnpBhPGUc+h6nHpwsNCiBBQeBvwietVqpOCY=;
        b=JSClSZdR2Nsbx/0VicbrcbFA/3VQ9TGJNENKNZLhuPEZi2+I/x0vSq8WQnCStq/c4t
         7KYlF7a1ODyH+UfQeeC9MR7Jcd3tKaBqCD9dmE8alKEGdMg1j6iM1vilbLKFkLsos55E
         H5GXBeA98/A9Z20BRkdFQkv+YArk4EE644y47pEQafTb+QRM46Fnr6vOO1IgT+TRhgVi
         sHRHUZJlsTlAxBrs8HG6JbgeULSbi7ajo6E7mAiNwkeWtapdkZNdjHyPgu1UQweZDha+
         dDq8jRg1a2tyu/8RnQkSRXHQAD3LTL6Lo4pAFMoxCXBWKIaJ1i3QkJNKz1m1SaP6sLmx
         ntjQ==
X-Gm-Message-State: AAQBX9d31/AHLm0ttDQYJ3JmyRgbIdA/QZcBlhSSDA8Jr6ouoijopj1S
        STHQutuf8EPEq1caq+2mvdIRk/vq9pc=
X-Google-Smtp-Source: AKy350bErss/wYLzRjwFW08nzvmt9D1Oy3JAWIiV1kGr0dpMinxiPDEpYx6p3WqwkPJSiJEkuSna8w==
X-Received: by 2002:a05:6a00:1c9e:b0:63d:344c:f123 with SMTP id y30-20020a056a001c9e00b0063d344cf123mr703466pfw.1.1681758329237;
        Mon, 17 Apr 2023 12:05:29 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x18-20020aa793b2000000b0063b7c42a070sm4291439pff.68.2023.04.17.12.05.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Apr 2023 12:05:28 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/7] lpfc: Update lpfc to revision 14.2.0.12
Date:   Mon, 17 Apr 2023 12:15:51 -0700
Message-Id: <20230417191558.83100-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.12

This patch set contains fixes flagged by code analyzer tools, introduces a
new CQE status to handle DMA errors, and replaces the usage of blk
interrupts with threaded interrupts.

The patches were cut against Martin's 6.4/scsi-queue tree.

Justin Tee (7):
  lpfc: Fix verbose logging for scsi commands issued to SES devices
  lpfc: Fix double free in lpfc_cmpl_els_logo_acc caused by
    lpfc_nlp_not_used
  lpfc: Match lock ordering of lpfc_cmd->buf_lock and hbalock for abort
    paths
  lpfc: Update congestion warning notification period
  lpfc: Add new RCQE status for handling DMA failures
  lpfc: Replace blk_irq_poll intr handler with threaded irq
  lpfc: Update lpfc version to 14.2.0.12

 drivers/scsi/lpfc/lpfc_attr.c    |   4 +-
 drivers/scsi/lpfc/lpfc_crtn.h    |   4 +-
 drivers/scsi/lpfc/lpfc_els.c     |  30 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c |  24 +-
 drivers/scsi/lpfc/lpfc_hw4.h     |  11 +-
 drivers/scsi/lpfc/lpfc_init.c    |  26 +-
 drivers/scsi/lpfc/lpfc_nvme.c    |  44 ++--
 drivers/scsi/lpfc/lpfc_scsi.c    |   3 +-
 drivers/scsi/lpfc/lpfc_sli.c     | 392 +++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_sli4.h    |   4 +-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 11 files changed, 309 insertions(+), 235 deletions(-)

-- 
2.38.0

