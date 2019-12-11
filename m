Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CECC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 08:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 834E52173E
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 08:28:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oSv9unKy";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="gcqJnfWK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfLKI2g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 03:28:36 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:38508
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727298AbfLKI2f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 03:28:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576052915;
        h=From:To:Subject:Date:Message-Id;
        bh=T+SOY+C/TzdRLUffaFKIDSJ4S22xaITChXJVNwry4V4=;
        b=oSv9unKy82fAUnkmVna+o1fWEhqHz5WpSpQd6vdlKObQaIyDI74BdRZlrL5U/6D6
        QobwU2C04/pF74F9eKJF3E1JMXk1zD0aPpnu+OQcFnRETCU78QoLf4KBq6qcEQvXY3l
        8l/GVaVule5hTz6MarL0FPUDFPU2A3wEIO2OP92w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576052915;
        h=From:To:Subject:Date:Message-Id:Feedback-ID;
        bh=T+SOY+C/TzdRLUffaFKIDSJ4S22xaITChXJVNwry4V4=;
        b=gcqJnfWK6ev7GoVmAGrh4Nez8gO5C7T2+ZFITO2GpYulQOLii2rEzuHMN516MIJ2
        IrQbxYmnWEMt1Ja1q38AssR4wZpxXr3nmGsuXcfqAKvg7Fck2+hfUDhNsKl87NjSdUn
        oHuaBreSJXGSia2zLiMEtcQ6f70h5bI2dv/p7ug8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 261AEC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v1 0/2] Modulize ufs-bsg
Date:   Wed, 11 Dec 2019 08:28:35 +0000
Message-ID: <0101016ef412fb74-5d665849-fdb8-4957-bdbb-3ece4f638afe-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2019.12.11-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order to improve the flexibility of ufs-bsg, modulizing it is a good
choice. Introduce tri-state to ufs-bsg to allow users compile it as an
external module.

Can Guo (2):
  scsi: ufs: Put SCSI host after remove it
  scsi: ufs: Modulize ufs-bsg

 drivers/scsi/ufs/Kconfig   |  3 ++-
 drivers/scsi/ufs/Makefile  |  2 +-
 drivers/scsi/ufs/ufs_bsg.c | 49 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufs_bsg.h |  8 --------
 drivers/scsi/ufs/ufshcd.c  | 37 ++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h  |  7 ++++++-
 6 files changed, 88 insertions(+), 18 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

