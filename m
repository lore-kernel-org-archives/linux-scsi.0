Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395BEC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 03:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E5F3206B6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 03:54:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ThQJJXYT";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="gZIpd4SY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKRDyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 22:54:45 -0500
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:33628
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbfKRDyp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Nov 2019 22:54:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574049284;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=3kNWDZv0x8ErTPlPCyTym8GRuw9qCcISjdDdviQj9jU=;
        b=ThQJJXYTB7T2Dz7dlfuxjE/rkXGpc/nn7yduWx012uDKo5UiFA5daCuQZOr0erVQ
        KvPOWni/dMfX4wuAB6FacdNNTQiujMxFjPu5/sTJs+NpflJIhIQ6Gh3hUCr2mFtqAs2
        +kPZ27FIob8WoX4uxSWKNq+id6QOVqnNciRsSpZw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574049284;
        h=From:To:Cc:Subject:Date:Message-Id:Feedback-ID;
        bh=3kNWDZv0x8ErTPlPCyTym8GRuw9qCcISjdDdviQj9jU=;
        b=gZIpd4SYycMHFq++czyod6c+M9sNXxs/1Qf4Tnc1lznXKdeJ5OnlKc1aNorwozlv
        hKTL3i1EE1tfg6WC+N4ij3PwwDqEr+/g75Mf3i93sdhBuvyYm9eUy4gxldDRz+/F0c6
        ymUKfSERIey5qgE12u9PcM0RPk5/WiPG0rh1fNJA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8FE8AC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Can Guo <cang@qti.qualcomm.com>
Subject: [Resend due to wrong mail address][PATCH v2 0/4] UFS driver general fixes bundle 5
Date:   Mon, 18 Nov 2019 03:54:44 +0000
Message-ID: <0101016e7ca601eb-5bac9575-6706-4724-8a18-602f04b2571e-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2019.11.18-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Can Guo <cang@qti.qualcomm.com>

This bundle includes 4 general fixes for UFS driver.

Changes since v1:
- Incorporated review comments from Avri Altman.
- Removed change "scsi: ufs: Add new bit field PA_INIT to UECDL register".
- Updated change "scsi: ufs: Complete pending requests in host reset and restore path".

Asutosh Das (1):
  scsi: ufs: Recheck bkops level if bkops is disabled

Can Guo (3):
  scsi: ufs: Update VCCQ2 and VCCQ min/max voltage hard codes
  scsi: ufs: Avoid messing up the compl_time_stamp of lrbs
  scsi: ufs: Complete pending requests in host reset and restore path

 drivers/scsi/ufs/ufs.h    |  4 ++--
 drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++----------------
 drivers/scsi/ufs/ufshcd.h |  2 ++
 3 files changed, 19 insertions(+), 18 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

