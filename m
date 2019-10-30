Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AE9CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 12:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09CD42080F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 12:37:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EfUho6b5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EfUho6b5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfJ3Mhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 08:37:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37172 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfJ3Mhy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 08:37:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C141960FCF; Wed, 30 Oct 2019 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572439073;
        bh=29OC2t52ZBhvNt59FZeQtveFg1xmaj6rJzInpL5k7Tg=;
        h=From:To:Subject:Date:From;
        b=EfUho6b5A10kaYeDQldYcHlks76s/Yf0iuAFzbdoIWy/i36E8n5eWp8nUYaiNQ2ey
         z6QqZN6ehWWwh/FKefqw4medU3ZWRZ0jc18Q0Dw/AHuNkarx1y0OuyUcLS/13PZ39u
         jfLzK9x4O1ZgFgt14xxt1j4uoJTcg4WIacLFfZ8c=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E23DE60B6E;
        Wed, 30 Oct 2019 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572439073;
        bh=29OC2t52ZBhvNt59FZeQtveFg1xmaj6rJzInpL5k7Tg=;
        h=From:To:Subject:Date:From;
        b=EfUho6b5A10kaYeDQldYcHlks76s/Yf0iuAFzbdoIWy/i36E8n5eWp8nUYaiNQ2ey
         z6QqZN6ehWWwh/FKefqw4medU3ZWRZ0jc18Q0Dw/AHuNkarx1y0OuyUcLS/13PZ39u
         jfLzK9x4O1ZgFgt14xxt1j4uoJTcg4WIacLFfZ8c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E23DE60B6E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v1 0/2] Introduce bus voting vendor ops
Date:   Wed, 30 Oct 2019 05:37:41 -0700
Message-Id: <1572439064-28785-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some vendors need to vote for bus bandwidth when bus clocks are changed,
hence introduce the bus voting vendor ops so that UFS driver can use it.

Can Guo (2):
  scsi: ufs: Introduce bus voting vendor ops
  scsi: ufs-qcom: Export bus bandwidth voting ops

 drivers/scsi/ufs/ufs-qcom.c | 53 ++++++++++++++++++++++++++++++---------------
 drivers/scsi/ufs/ufshcd.c   | 19 +++++++++++++++-
 drivers/scsi/ufs/ufshcd.h   |  9 ++++++++
 3 files changed, 62 insertions(+), 19 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

