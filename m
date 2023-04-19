Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBC0C77B78
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 05:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjDSFmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 01:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjDSFmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 01:42:07 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1352E5BBA;
        Tue, 18 Apr 2023 22:42:06 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id BA56A3F558;
        Wed, 19 Apr 2023 05:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681882924;
        bh=PHWY28RNZSnXh8z/q/7yzDlNLTSA9IeiJKkegwI+W08=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=MdKGfLFOnFVyo/Dj7l9ISKdYE/IimL4e4v6AYgRbqyu01AbRoZzBapHGYYQMyfubT
         HnFihMEnWwp9vYdULWi31OupXtV6jzhOonYY+mqvtU1doz9eIky3jSpAE147n/MJVA
         56dCnxSsS4giqNbC9aYIGameWLlseO6E5UrIZMWmsustB3OTB7ol7idK379crbnd5R
         P/iPmBZXWn74+X6589ncL4pp6efw3Vjshw0gTtBDlx9SnzHc82PqmbNVjYndcYCNoa
         y9ch3jl09QudmRXWX8yYo9DFaTXSBtLxqEuBvLEtykfmlQ/dXJwX58dbcuJX3Fx55q
         UhTQOBZoKdS0A==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     acelan.kao@canonical.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: core: Avoid doing rescan on suspended device
Date:   Wed, 19 Apr 2023 13:41:12 +0800
Message-Id: <20230419054112.269734-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During system resume, if an EH is schduled after ATA host is resumed
(i.e. ATA_PFLAG_PM_PENDING cleared), but before the disk device is
resumed, the device_lock hold by scsi_rescan_device() is never released
so the dpm_resume() of the disk is blocked forerver.

That's because scsi_attach_vpd() is expecting the disk device is in
operational state, as it doesn't work on suspended device.

To avoid such deadlock, avoid doing rescan if the disk is still
suspended so the resume process of the disk device can proceed.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/scsi/scsi_scan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d217be323cc6..36680cb1535b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1621,6 +1621,9 @@ void scsi_rescan_device(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
+	if (dev->power.is_prepared)
+		return;
+
 	device_lock(dev);
 
 	scsi_attach_vpd(sdev);
-- 
2.34.1

