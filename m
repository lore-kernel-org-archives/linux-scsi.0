Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB0EC43332
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 08:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8198E2399A
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 08:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbhAUIjt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 03:39:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbhAUIYA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 03:24:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5143623975;
        Thu, 21 Jan 2021 08:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611217399;
        bh=8MbQghIX86lQQEjetS0v6+wqvTD+XqNx7AqMICVjUUo=;
        h=From:To:Cc:Subject:Date:From;
        b=cD/nIccHVUpxYlT/doTCy28hAKnMi055BFw66/LnGPW7iZtQNEM8Y+yeC3F+Cb6yP
         IrO1hVthr5e0zQhKvNHuOjSIWD6myPhgCFN1m4g7n6gHxt0wvkUG2/Uzbnz/XgR28P
         btt+Cr1J2YDLw28cFHZ7t2YwagNHnsLgEC10TNEHBE64jU/WqaRPlcUuT1lXf5PvdM
         yMU/8OM7/fVceA/i0kesPwBJDGM9+vEf10DHhAlM/byWHoOW1+QowDH5deXaiKXo+p
         53kEhUoJeim2lX76qJzvEbLXLxuqq7XaNyD7r1uJIstNKQ4YXSRtc42rWhRDrG7lBQ
         nl2K6POFXuVIQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 0/2] Resource-managed blk_ksm_init()
Date:   Thu, 21 Jan 2021 00:21:53 -0800
Message-Id: <20210121082155.111333-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset adds a resource-managed variant of blk_ksm_init() so that
drivers don't have to worry about calling blk_ksm_destroy().

This was suggested during review of my patchset which adds eMMC inline
encryption support
(https://lkml.kernel.org/linux-mmc/20210104184542.4616-1-ebiggers@kernel.org/T/#u).
That patchset proposes a second caller of blk_ksm_init().  But it can
instead use the resource-managed variant, as can the UFS driver.

My preference is that patch #1 be taken through the MMC tree together
with my MMC patchset, so that we don't have to wait an extra cycle for
the MMC changes.  Patch #2 can then go in later.

Eric Biggers (2):
  block/keyslot-manager: introduce devm_blk_ksm_init()
  scsi: ufs: use devm_blk_ksm_init()

 Documentation/block/inline-encryption.rst | 12 +++++-----
 block/keyslot-manager.c                   | 29 +++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-crypto.c          |  9 ++-----
 drivers/scsi/ufs/ufshcd-crypto.h          |  5 ----
 drivers/scsi/ufs/ufshcd.c                 |  1 -
 include/linux/keyslot-manager.h           |  3 +++
 6 files changed, 40 insertions(+), 19 deletions(-)

-- 
2.30.0

