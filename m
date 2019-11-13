Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC17C17447
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E520222CD
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VNqbWqVY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cE3LIukx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfKMGAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:00:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34510 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfKMGAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 01:00:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A08976085C; Wed, 13 Nov 2019 06:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573624835;
        bh=sN9HQYh6wIVagBIBwBcjFatf2XSTX81OaYD+RTbaeUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNqbWqVY/bmzctdrVnkZSUYUle6FSwHzelkaTp7nCr8zdpQnw+WmkmwU32T0GMK+s
         l+cPbHishAB5bUBn3rWMI2335jm/yNQWfhKEVYMKJ8nSuFsbCNiMfhbxmFEwcAqwn2
         +5lp44/NutUc14EVC/5wzk1DYJ5ykHJc+qZjpKv0=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 368B46085C;
        Wed, 13 Nov 2019 06:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573624834;
        bh=sN9HQYh6wIVagBIBwBcjFatf2XSTX81OaYD+RTbaeUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cE3LIukxnPXlR2D8LxaC1rc2/L2i/wL+rsdNdnqmdde97hKM+kq4n6AMuxbe//EiD
         73CD9CvhxW2hNYgm8r8XqliYwhwa8TcKdi4PkNFeJTL2//cbbLpHDMe4OL+Czhr8tz
         x12ublCLHJy05tgGyhpiO8glnSTKWC0Qm1ZUnDpE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 368B46085C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 1/5] scsi: Adjust DBD setting in mode sense for caching mode page per LLD
Date:   Tue, 12 Nov 2019 22:00:19 -0800
Message-Id: <1573624824-671-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573624824-671-1-git-send-email-cang@codeaurora.org>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS JEDEC standards require DBD field to be set to 1 in mode sense command.
This patch allows LLD to define the setting of DBD if required.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/scsi_lib.c    | 2 ++
 include/scsi/scsi_device.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5447738..3812e90 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2108,6 +2108,8 @@ void scsi_exit_queue(void)
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
+
+	dbd = sdev->set_dbd_for_ms ? 8 : dbd;
 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
 	cmd[2] = modepage;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3ed836d..f8312a3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -172,6 +172,7 @@ struct scsi_device {
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned no_write_same:1;	/* no WRITE SAME command */
 	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

