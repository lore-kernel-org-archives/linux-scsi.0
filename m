Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584E2C43603
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29BAF21744
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:14:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FbjTwvBE";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="LKGMlNkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfLECOU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 21:14:20 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:44650
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728121AbfLECOU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 21:14:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575512059;
        h=From:To:Subject:Date:Message-Id;
        bh=j8wlTo4CtuFv1J4kXDuQYIBQQaAJCv2B48LBGB+ZQug=;
        b=FbjTwvBEg8oQStnnW74STyoF+27hrul03lXUjLpbdC3wdXEkgfregSoLbtu90aPv
        rJm/x1W61wtVbn1ygBsG5Csxe05uFDk61RjAtYLFsSkBmU8OZSJSvFfrg2VOelhbBx9
        RoJuin6PJwA/nl+kcK0WUgW7RZlUckEjdTl2TMsU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575512059;
        h=From:To:Subject:Date:Message-Id:Feedback-ID;
        bh=j8wlTo4CtuFv1J4kXDuQYIBQQaAJCv2B48LBGB+ZQug=;
        b=LKGMlNkfN4Oo7uMDD2GaRkVG4FkF/x9bUC/Q4hQruiHxKRnBDxEHhtSjQVyYiebN
        +kyCSWhFzUDZyv3+XVPpTYNlrUQ4cPtULeT2tdpDN58NLqQdyXcpouIjZtxmY8J50xf
        hu2+YH6dDy4L7m9Hl009wBjC/oHTWzBizIKHGZqA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C82E0C447BD
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v6 0/5] UFS driver general fixes bundle 1
Date:   Thu, 5 Dec 2019 02:14:19 +0000
Message-ID: <0101016ed3d62f70-fd63eb46-fab2-4d40-afc8-25a5faefe5cd-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2019.12.05-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 5 general fixes for UFS driver.

Changes since v5:
- Fixed a minor typo in Reviewed-by tag from Avri Altman

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

