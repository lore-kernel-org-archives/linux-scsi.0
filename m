Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BF8C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD8720809
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iKBQLnRs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgG3IEU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3IER (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 04:04:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008FCC061794
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so13326955pls.5
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=luQb5lyiEEqoaF0b/6c+iPo14ohb5J61PajZl1BcNt0=;
        b=iKBQLnRsIYSEZkzVEMWlT1NYHIQlc9fVJ8FQkxRWD6JgwreNSrgDL6vylbrC18hGsn
         C5cl+L7HySGTSdN4VXFwqhEAhOVJlv7Q966ixAyFxZa0Hawqwq58jIboT3Zsckf3zhRM
         YOoVOae8CugooK2fBkY/0Iicl9VayGlpEmZyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=luQb5lyiEEqoaF0b/6c+iPo14ohb5J61PajZl1BcNt0=;
        b=jAt48yd7CwORm3mE/YHip4QQ5fgR0ymiCxgEwh4SzTYurkNfY8S9BpD72gbXPeiKAd
         vA2zi41K6M6P/qVNwTpOCmMCMl/ZgjJi3Gs2lr8D4tIkjMbU9iW3rRwbpVEXH1Hw5joF
         zfrsRzw5gFYR5qxbpz2k3aYDZ3kCafQawOWjbwTngeMhRJVl8HC7GNJU7RbxhXKovmfp
         HUpWH3Z4tHcqb2VZR4N4HSBtJPLQLwWZEgnBc5kZPEsQMH8VaBTBhdpdvutC38DcovfA
         /iU1cKije1y4Y5wcgx/4qBRoXLJ5qPvz9s0RhJLETowmyXEZm30IocdmTblTH0Tk3S4k
         /xzw==
X-Gm-Message-State: AOAM533AzkRglE+tapoBcZU0OBGWATZTYs2ldZjHThRhZr/cJI4jP7BN
        IZw66/5GM6Uan1Klgx9A8Jvdi+xkdM0OIQ==
X-Google-Smtp-Source: ABdhPJwUbGJvDU/huoTeN910qiNTe1dN/kLr+uJhtVSScvNcUd/9VrLFv+JNBVLTWXWjEELem6wYoA==
X-Received: by 2002:a17:902:9f82:: with SMTP id g2mr21273337plq.254.1596096256344;
        Thu, 30 Jul 2020 01:04:16 -0700 (PDT)
Received: from localhost.localdomain ([192.19.212.250])
        by smtp.gmail.com with ESMTPSA id d13sm5051412pfq.118.2020.07.30.01.04.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 01:04:15 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        sathya.prakash@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 0/7] mpt3sas: Enhancements and bug fixes
Date:   Thu, 30 Jul 2020 13:33:42 +0530
Message-Id: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set has below bug fixes and enhancements.

Dump IOC system interface register set when IOC fails to
transit to READY state during initialization.

During controller reset, cancel the running work along
with the queued works. This avoids processing the expired event after
the controller reset.

Before returning the target/lun reset with failure status
to SML, poll all the reply descriptor pools looking for the reply of
timed out SCSI command. Due to interrupt latency issues it is possible
that interrupt for timed out command might have been delayed. So poll
all the reply descriptor pools looking for the reply of timed out SCSI
command, if the timed out command 's reply is found then return
success status other return failure status.

Memset the config command reply buffer before issuing the
config request.

Suganath Prabu S (7):
  mpt3sas: Memset config_cmds.reply buffer with zeros
  mpt3sas: Dump system registers for debugging.
  mpt3sas: Cancel the running work during host reset.
  mpt3sas: Rename and export interrupt mask/unmask fn's.
  mpt3sas: Added support functions to find target and luns.
  mpt3sas: Postprocessing of target and LUN reset.
  mpt3sas: Update driver version to 35.100.00.00

 drivers/scsi/mpt3sas/compile.sh       |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c   |  50 ++++--
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  21 ++-
 drivers/scsi/mpt3sas/mpt3sas_config.c |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c    |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 245 +++++++++++++++++++++++---
 6 files changed, 282 insertions(+), 48 deletions(-)

-- 
2.26.2

