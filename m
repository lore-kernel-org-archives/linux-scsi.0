Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF5AC43603
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92DFE2077B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QGe7yryn";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="IW1yh45a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfLECFB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 21:05:01 -0500
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:49672
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728121AbfLECFB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 21:05:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575511500;
        h=From:To:Subject:Date:Message-Id;
        bh=vyvGcgBI7os0/RQ9E+t+2CCYMsngA0mSYgHkHtO/PQ4=;
        b=QGe7yrynOy+iksO3RSzanaIURE7fnEbbuWO8xaSZ6RSXdMmoIJ8nZO6ZOFZrSWc0
        7oPwh3Yygw3YYMIV1IFEuX1YlrNa/4Qql+NzpiE+jE/l1sHeotETQVYTji8ONASvkMg
        gcPMtVdARPgvfZYs2AC/mcwAdI/4BM/FOmrY8teI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575511500;
        h=From:To:Subject:Date:Message-Id:Feedback-ID;
        bh=vyvGcgBI7os0/RQ9E+t+2CCYMsngA0mSYgHkHtO/PQ4=;
        b=IW1yh45a6ru7UAbF5bJjg2a97xYiUD9lVgEoF74AO5oK6CSkwnmOxP3oCyJfQl9Z
        PHXhqbZLscMsMosy/kus2l954JDX/2JPPR18bHJBZlP4fPOeK9Hvsprhb1OaDsfFsSM
        y5fBBGNdBdG2E6UmzHHP+uL/cbr7N7V85S3X7Eyk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E9268C4479C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v5 0/5] UFS driver general fixes bundle 1
Date:   Thu, 5 Dec 2019 02:05:00 +0000
Message-ID: <0101016ed3cda4e8-ec071148-9851-413f-8c16-4f79f540f090-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2019.12.05-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 5 general fixes for UFS driver.

Changes since v4:
- Incorporated review comments from Avri Altman and Bean Huo.

Changes since v3:
- Incorporated review comments from Martin K. Petersen.

Changes since v2:
- Incorporated review comments from Mark Salyzyn

Changes since v1:
- Incorporated review comments from Bart Van Assche.


Can Guo (5):
  scsi: Adjust DBD setting in mode sense for caching mode page per LLD
  scsi: ufs: Use DBD setting in mode sense
  scsi: ufs: Release clock if DMA map fails
  scsi: ufs: Do not clear the DL layer timers
  scsi: ufs: Do not free irq in suspend

 drivers/scsi/scsi_lib.c    |  2 ++
 drivers/scsi/ufs/ufshcd.c  | 42 ++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/unipro.h  | 11 +++++++++++
 include/scsi/scsi_device.h |  1 +
 4 files changed, 42 insertions(+), 14 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

