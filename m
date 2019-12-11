Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A57FC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 08:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 031502173E
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 08:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d1NZeeKV";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="e/AEu3jN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfLKIsv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 03:48:51 -0500
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:39044
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbfLKIsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 03:48:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576054130;
        h=From:To:Subject:Date:Message-Id;
        bh=EhYKCwcNiWYZcZLt2HN5MwZyJn49PZz2yvBkv5rACGE=;
        b=d1NZeeKVHZ+cr9S2IeUIDihnZrWQDzCjX7rRsRpcwVXjCMBS/BsKqwA93m0aLMx9
        oAVjFZrAB8gMRYPTBkguu09cM0OeH5LQHmSsnR0oVNCLTBBVGdvo99ulV45wkD95iSa
        WQPWR/acsBz0QZcIqhbgZB1hclWvAySyjHI2fwOQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576054130;
        h=From:To:Subject:Date:Message-Id:Feedback-ID;
        bh=EhYKCwcNiWYZcZLt2HN5MwZyJn49PZz2yvBkv5rACGE=;
        b=e/AEu3jNOUZOqivakGWdBjnyiJivGs1EG0Ac2xxTeMAVAYWs+ra8lJvTRNrquOVV
        7nsCdopycEcqaCJ2ZhzhVcY3/Zhg32/Kn5HFCxuzOFr27Z+9EtOkhBEKw5HgvV7ZG2Y
        0W6oMzN0FzKwQpE8zWFj20u9DaEAQu4n0QsU4FRw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 95A9BC4479C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v2 0/3] Modulize ufs-bsg
Date:   Wed, 11 Dec 2019 08:48:50 +0000
Message-ID: <0101016ef42587cd-c3341e2e-452e-4455-8a05-7210b6ba8596-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2019.12.11-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order to improve the flexibility of ufs-bsg, modulizing it is a good
choice. Introduce tri-state to ufs-bsg to allow users compile it as an
external module.

Changes since v1:
- Included one more defconfig change.

Can Guo (3):
  scsi: ufs: Put SCSI host after remove it
  scsi: ufs: Modulize ufs-bsg
  arm64: defconfig: Compile ufs-bsg as a module

 arch/arm64/configs/defconfig |  1 +
 drivers/scsi/ufs/Kconfig     |  3 ++-
 drivers/scsi/ufs/Makefile    |  2 +-
 drivers/scsi/ufs/ufs_bsg.c   | 49 +++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufs_bsg.h   |  8 --------
 drivers/scsi/ufs/ufshcd.c    | 37 +++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h    |  7 ++++++-
 7 files changed, 89 insertions(+), 18 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

