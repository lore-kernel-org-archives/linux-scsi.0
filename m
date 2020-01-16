Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45DB2C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18AE62075B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/S9G9vP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389564AbgAPWAc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:00:32 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39043 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733113AbgAPWAc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 17:00:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id 20so5432169wmj.4;
        Thu, 16 Jan 2020 14:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VgoO/JemCCtHEcyOdPPD88fO64o+HNjcCaOaOMSoYgA=;
        b=X/S9G9vPtdjQFCMAbB5QoI9OZ0RlEOk5/4hQp0ehmqiu18vbnp3JbZCB0FjjbLtN/C
         gl6K6bz6j8CjEh1wXhE1jjoXuOiCAR9s/Ae8d4h0r1McEPOXuHcEdpBQdayvdMoJfJ25
         /pT6Yi+mxYMt4+LxgHsHe62qIHG8amxwjktkEI4SP7VjB+CEoD8ZG6OT4fIAuYefrwUX
         eLc/TVczaKKWGmGiyxtrpyGJlNCzO/iEAe2rf7BcmCJSH6DSvcEeFnweQO1OCU3zQm5i
         Isvvhng+2yhNicShQlLYHAEqMSWiE7L7HXR1kssogTvtH2GgtzT71XpIqicwSZHTp2GX
         kZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VgoO/JemCCtHEcyOdPPD88fO64o+HNjcCaOaOMSoYgA=;
        b=dngFYDfKHKURXEVJ1uKpDQl+b7vf+N1x1RMbTXW2ko6wSNJ/KsfCxrUKg8+iUu2WUG
         57Yog4KRuxdkEoaxdjyEEAxCjNXSuHdajITbTimLy0uQMqkMj0PbvqaG+qvA9KQVaCRe
         1+ig2CZXu9juQqfGWbRijPtg2bSHcFeITTpIQece1xNDXy4sZIVPEau8eBgnQ/EEJLzo
         ctWOBPrzMU/0wzmYgkjUEQ1aBkJA8EItJ0FmW5dHm6W7Jgytc7p0O4NKtRAovWlgf1Qx
         ug9useyw2mmkPuD5qX2AnkqlNJRAP7jukgdxnEX5m0x5aFT5QZleCJrsai7vGN7Wu/Bl
         Nygw==
X-Gm-Message-State: APjAAAV3P8UHRdhhidq8qqwcKKhjJ7SAy+yfvVjNKtKxk/eBoImUrED2
        JTCxYi5D5UsCrGdCXENRIvA=
X-Google-Smtp-Source: APXvYqz5jrnjAR3QRpoLXO9Z5XePkFVS+1ZhDLd6rAvHssRz5LF8WVO462x1OQa0Otf11xp1bsI3gQ==
X-Received: by 2002:a1c:7f4f:: with SMTP id a76mr1152839wmd.77.1579212030156;
        Thu, 16 Jan 2020 14:00:30 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id a14sm32418131wrx.81.2020.01.16.14.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 14:00:29 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/9] scsi: ufs: Add max_lu_supported in struct ufs_dev_info
Date:   Thu, 16 Jan 2020 22:59:12 +0100
Message-Id: <20200116215914.16015-8-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200116215914.16015-1-huobean@gmail.com>
References: <20200116215914.16015-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Add one new parameter max_lu_supported in struct ufs_dev_info,
which will be used to express exactly how many general LUs being
supported by UFS device.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index fcc9b4d4e56f..c982bcc94662 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -530,6 +530,8 @@ struct ufs_dev_info {
 	bool f_power_on_wp_en;
 	/* Keeps information if any of the LU is power on write protected */
 	bool is_lu_power_on_wp;
+	/* Maximum number of general LU supported by the UFS device */
+	u8 max_lu_supported;
 	u16 wmanufacturerid;
 	/*UFS device Product Name */
 	u8 *model;
-- 
2.17.1

