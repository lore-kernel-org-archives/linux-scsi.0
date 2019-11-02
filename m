Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785CBCA9EC7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F5632084D
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:01:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HiFd7Q7l";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HiFd7Q7l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfKBFBs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 01:01:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49886 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFBs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Nov 2019 01:01:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DDCBE614E6; Sat,  2 Nov 2019 05:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572670905;
        bh=V2XXMW38kUhdfX3PiI9di8Zsl+Mv2fzek+ewvx/P0Ok=;
        h=From:To:Subject:Date:From;
        b=HiFd7Q7lmqS9gnN2M4YNyUeiflkruRFlwJMkzKL+9qPweA5RnL7OCq2HVLRPaBpnE
         1ZNXFzWPCOgOavYMx6qoEYwboUPMulhqKI4O5M3qoHZnTWthmjy/BoMw3jHvU+aUyh
         Ku+/oxuWgxHAd1Cg9l/AdlyNkhhJ7fvJTSW/Pe3A=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F1AAB60FBB;
        Sat,  2 Nov 2019 05:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572670905;
        bh=V2XXMW38kUhdfX3PiI9di8Zsl+Mv2fzek+ewvx/P0Ok=;
        h=From:To:Subject:Date:From;
        b=HiFd7Q7lmqS9gnN2M4YNyUeiflkruRFlwJMkzKL+9qPweA5RnL7OCq2HVLRPaBpnE
         1ZNXFzWPCOgOavYMx6qoEYwboUPMulhqKI4O5M3qoHZnTWthmjy/BoMw3jHvU+aUyh
         Ku+/oxuWgxHAd1Cg9l/AdlyNkhhJ7fvJTSW/Pe3A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F1AAB60FBB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v3 0/5] UFS driver general fixes bundle 1
Date:   Fri,  1 Nov 2019 22:01:33 -0700
Message-Id: <1572670898-750-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 5 general fixes for UFS driver.

Changes since v2:
- Incorporated review comments from Mark Salyzyn

Changes since v1:
- Incorporated review comments from Bart Van Assche.

Can Guo (5):
  scsi: Adjust DBD setting in mode sense for caching mode page per LLD
  scsi: ufs: Set DBD setting in mode sense for caching mode page
  scsi: ufs: Release clock if DMA map fails
  scsi: ufs: Do not clear the DL layer timers
  scsi: ufs: Do not free irq in suspend

 drivers/scsi/sd.c         |  2 +-
 drivers/scsi/ufs/ufshcd.c | 40 ++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/unipro.h | 11 +++++++++++
 include/scsi/scsi_host.h  |  6 ++++++
 4 files changed, 44 insertions(+), 15 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

