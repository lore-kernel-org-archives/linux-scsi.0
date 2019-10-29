Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6839CCA9EC0
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 03:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33A4920862
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 03:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L4cbU5Gs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L4cbU5Gs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbfJ2DLI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 23:11:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729145AbfJ2DLI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 23:11:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CA2256039E; Tue, 29 Oct 2019 03:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572318667;
        bh=P/GOqeWrnbIyols/4U7369z4idV9uAvgxcjPZ205xgs=;
        h=From:To:Subject:Date:From;
        b=L4cbU5Gs16ywoPtgG2v2AwI68pxLv+lLtm0/p/a4+yx8w5qzfqfjaI7KlvwZ15N15
         Te0WzYR3hEyxu8MeZbXh7EUkzVNZWJRPwz6o5E9P2gc0fpSR9dqyGwgv+ZdmUQclCi
         QJDkDthUOpECeohZnDzd0OErddRrl2bTXJGmPh18=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DDC6960CDD;
        Tue, 29 Oct 2019 03:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572318667;
        bh=P/GOqeWrnbIyols/4U7369z4idV9uAvgxcjPZ205xgs=;
        h=From:To:Subject:Date:From;
        b=L4cbU5Gs16ywoPtgG2v2AwI68pxLv+lLtm0/p/a4+yx8w5qzfqfjaI7KlvwZ15N15
         Te0WzYR3hEyxu8MeZbXh7EUkzVNZWJRPwz6o5E9P2gc0fpSR9dqyGwgv+ZdmUQclCi
         QJDkDthUOpECeohZnDzd0OErddRrl2bTXJGmPh18=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DDC6960CDD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v2 0/5] UFS driver general fixes bundle 1
Date:   Mon, 28 Oct 2019 20:10:49 -0700
Message-Id: <1572318655-28772-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 5 general fixes for UFS driver.

Changes since v1:
- Incorporated review comments from Bart Van Assche.

Can Guo (5):
  scsi: Adjust DBD setting in mode sense for caching mode page per LLD
  scsi: ufs: Set DBD setting in mode sense for caching mode page
  scsi: ufs: Release clock if DMA map fails
  scsi: ufs: Do not clear the DL layer timers
  scsi: ufs: Do not free irq in suspend

 drivers/scsi/sd.c         |  6 +++++-
 drivers/scsi/ufs/ufshcd.c | 40 ++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/unipro.h | 11 +++++++++++
 include/scsi/scsi_host.h  |  6 ++++++
 4 files changed, 48 insertions(+), 15 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

