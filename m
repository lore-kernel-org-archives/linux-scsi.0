Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D73C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C60E222D3
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fkrjvmbk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CM6K4LMK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfKMGqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:46:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43776 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfKMGqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 01:46:15 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3DD7E602DE; Wed, 13 Nov 2019 06:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573627574;
        bh=tQhwhsE0fjctOK079Gb7BAz3txy2pHSD1SpmLbvQG1g=;
        h=From:To:Subject:Date:From;
        b=fkrjvmbkRXbWJFdgZMh6C+JESpC/teiPaYsEzFG1eHbmYfe6EQFvL7n0ZHZ2jV7D4
         voRFzddVHcJUQCpJjl2zeLym86P30pSqAZH3IxcETCYTa0Q1Hv5e6HKDbgR7eaxeI9
         TWeYIm7I2BBDajWk740IRKCoy7/DPIVtXTcM28os=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4E3AA602EF;
        Wed, 13 Nov 2019 06:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573627573;
        bh=tQhwhsE0fjctOK079Gb7BAz3txy2pHSD1SpmLbvQG1g=;
        h=From:To:Subject:Date:From;
        b=CM6K4LMKbJECgJxiIsoqQ9HmALIePF4urdTtqaPw3AVcgJ4ZUl6qfsM7zYP4w2Nmf
         HSOQTK0zxrcMlTvAAQEH6zCz5hAUzukSFIMZ5jJ2wo6y/Tb4bTTkWnBhXon+HTntxW
         d/3jBUbIt74uCzL9F7ygeyDLO+/tkZB7gk2hwnGk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4E3AA602EF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v4 0/7] UFS driver general fixes bundle 3
Date:   Tue, 12 Nov 2019 22:45:44 -0800
Message-Id: <1573627552-12615-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 7 general fixes for UFS driver.

Changes since v3:
- Updated UIC_DATA_LINK_LAYER_ERROR_CODE_MASK in change "scsi: ufs: Fix irq return code".

Changes since v2:
- Updated change "scsi: ufs: Fix up auto hibern8 enablement".

Changes since v1:
- Added one more change to fix register dump caused sleep in atomic context.

Asutosh Das (1):
  scsi: ufs: Abort gating if clock on request is pending

Can Guo (4):
  scsi: ufs: Add device reset in link recovery path
  scsi: ufs-qcom: Add reset control support for host controller
  scsi: ufs: Fix up auto hibern8 enablement
  scsi: ufs: Fix register dump caused sleep in atomic context

Subhash Jadavani (1):
  scsi: ufs: Fix error handing during hibern8 enter

Venkat Gopalakrishnan (1):
  scsi: ufs: Fix irq return code

 drivers/scsi/ufs/ufs-qcom.c  |  53 +++++++++++++
 drivers/scsi/ufs/ufs-qcom.h  |   3 +
 drivers/scsi/ufs/ufs-sysfs.c |  17 +++--
 drivers/scsi/ufs/ufshcd.c    | 172 +++++++++++++++++++++++++++++++------------
 drivers/scsi/ufs/ufshci.h    |   2 +-
 5 files changed, 192 insertions(+), 55 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

