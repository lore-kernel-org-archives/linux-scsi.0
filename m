Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30929C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9DCE22252
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437892AbhARUMy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437860AbhARULf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:11:35 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432BDC061574;
        Mon, 18 Jan 2021 12:10:55 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id r12so14035152ejb.9;
        Mon, 18 Jan 2021 12:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SrT6KxCzPuWbkvK8c/zH4nf3o3AFHlMB/7HpKWNRtUM=;
        b=Rx5UbXkPOfHAqUNj+K5M5rWX3LF15JcyRGamXb081BOdnU+3DpGuMbvxD18bsRT4Iu
         pKYlCcHUnhDb2wzn4kpFiIZbmqJCBp+ZrkKyDnZfwfFtie4e5ljcqi3p/AT49ONQoCRG
         NXK8KwhYx/gbiDJoFkAuCbpHy1XiDjeizlMdsOK0OvJZWoTwPzysl5oKrHUkJq7fF+N7
         pH9e7zz9PoJxU8QlGpjYvQ+eHsO4+J3x4Fr3TNlOW/lEMmHzoAQ32in7i70aIqalSoBV
         BQEgA5UdvBccmS9BOFHltWuUlhOWC0vYFrKDeVLBroT4IwSpNJYCxEwwIC4HdAk1/Hlf
         1Dww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SrT6KxCzPuWbkvK8c/zH4nf3o3AFHlMB/7HpKWNRtUM=;
        b=AGouhS/3Iq+2S/EXzmnJHmwM4LWdV4YWBGSoeBhpP08qlEqUsqTnzRmuZPAh0EkPc/
         rUwcg/7xeZUF19TRp0LId8u/ep9m34ppjiyuUoMXhgALJ/RxT6e/l7vFHYqwBtvQvOfD
         FggA9bfFZroTXvuzrbEZBrlti8s0yHY6WWlhZazjQbgCwTXXbydhXGDIzLTNju0F7jV5
         c7qHoVOsYJW9DNnVAEbEHWU0zMEW+74GxYWd1vSZQ2e53rKWYh+mGlBKVPhMVZVoWvBD
         NGzik9rZYn/NxZu5FSJl4PBuceAAGL8Uv8J0xO//0Y/Gk6hzrJTOqMcqKpoh+DwpZYuC
         C6ng==
X-Gm-Message-State: AOAM5325j91DsV9eIUBR9NM9/P985rj0dJW6aeNTP7ftmggfbDbv/s2Y
        Apf9FFg1g1tckkn/ZsVicUDR8Gwhv30=
X-Google-Smtp-Source: ABdhPJwyM7SVl2VtXw5Xtd/vi3NldIuxBTSjEAJvaUJIY3NkK3PYgowP3nQEdLBOri1m4if+1qmj7g==
X-Received: by 2002:a17:906:97c5:: with SMTP id ef5mr858747ejb.347.1611000654079;
        Mon, 18 Jan 2021 12:10:54 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id qh13sm3972543ejb.33.2021.01.18.12.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:10:53 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 3/6] scsi: ufs: Changes comment in the function ufshcd_wb_probe()
Date:   Mon, 18 Jan 2021 21:10:36 +0100
Message-Id: <20210118201039.2398-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210118201039.2398-1-huobean@gmail.com>
References: <20210118201039.2398-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

USFHCD supports WriteBooster "LU dedicated buffer” mode and
“shared buffer” mode both, so changes the comment in the
function ufshcd_wb_probe().

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3f2b495b36ee..a3758fd83ebd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7294,10 +7294,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 		goto wb_disabled;
 
 	/*
-	 * WB may be supported but not configured while provisioning.
-	 * The spec says, in dedicated wb buffer mode,
-	 * a max of 1 lun would have wb buffer configured.
-	 * Now only shared buffer mode is supported.
+	 * WB may be supported but not configured while provisioning. The spec
+	 * says, in dedicated wb buffer mode, a max of 1 lun would have wb
+	 * buffer configured.
 	 */
 	dev_info->b_wb_buffer_type =
 		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
-- 
2.17.1

