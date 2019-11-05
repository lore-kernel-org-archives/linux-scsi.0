Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C44CA9EC7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 04:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1726D214B2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 04:00:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cq4jCebF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cq4jCebF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbfKEEAL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 23:00:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbfKEEAL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 23:00:11 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C2DD560B7F; Tue,  5 Nov 2019 04:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572926410;
        bh=qU7M807V9kqDcPNAVelvCZQNTfzAqiEF706IyrBUVMs=;
        h=From:To:Subject:Date:From;
        b=Cq4jCebFzV++pwDu/miuooLRGMYgn8ueqquF/vZu3+45V2WtPig1Iufvj2Gvl+QSa
         KoSzZhSAiS6Kkg88Yo+99for8cuB3vedqf1Q3XBBnh+eA6sByTqRa0JDf556sh1NuT
         XfVGbmJh8DH+YopdwY4buEdafqqCrTzFox3vnF4M=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBC3A60B7F;
        Tue,  5 Nov 2019 04:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572926410;
        bh=qU7M807V9kqDcPNAVelvCZQNTfzAqiEF706IyrBUVMs=;
        h=From:To:Subject:Date:From;
        b=Cq4jCebFzV++pwDu/miuooLRGMYgn8ueqquF/vZu3+45V2WtPig1Iufvj2Gvl+QSa
         KoSzZhSAiS6Kkg88Yo+99for8cuB3vedqf1Q3XBBnh+eA6sByTqRa0JDf556sh1NuT
         XfVGbmJh8DH+YopdwY4buEdafqqCrTzFox3vnF4M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBC3A60B7F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v3 0/7] UFS driver general fixes bundle 3
Date:   Mon,  4 Nov 2019 19:57:08 -0800
Message-Id: <1572926236-720-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 7 general fixes for UFS driver.

Changes since v2:
- Updated change "scsi: ufs: Fix up auto hibern8 enablement"

Changes since v1:
- Added one more change to fix register dump caused sleep in atomic context

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
 4 files changed, 191 insertions(+), 54 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

