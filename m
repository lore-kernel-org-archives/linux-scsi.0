Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A546FC77B78
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 10:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjECKlL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 06:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjECKlK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 06:41:10 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B5C44A1
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2023 03:41:08 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-305f0491e62so4435947f8f.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 May 2023 03:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683110466; x=1685702466;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=18+zD8zJYi3/Cfjv44S8LZuiPVGNRYG6CxrA5L7f37c=;
        b=pJJ5gpIVOdGJhMps7tKZauJYNEF32/NT8iGK0CuyrDEMVE/+NBU3KOqSMTj9UrNyxH
         yh/mmvEsDhCerh0pN6S2YvvP317oQzB7NpLlxLEMd8exJoQ3WtTLvenIe8rrvw5tksJI
         9bMdxotUdgPuRgbPr53Q0DIRKEwizOkOpgz4WPR2SaYSgLLJQAqJCT/fXY1dYluBqQr5
         sL7lU3SPvBjKCj5N5RDsALucCOjJ9LZg9edK22h+/i+33pi/ryAYptI8g2Ye0C4pmGy1
         IIrZkCMo02AhdeWs9zNglu94SXjxtdSx5EY0EvurVmzqaZ4gdLFAnnM9FlXJ7iZmTjlr
         VgBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683110466; x=1685702466;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=18+zD8zJYi3/Cfjv44S8LZuiPVGNRYG6CxrA5L7f37c=;
        b=F8kG8uEjcoshotbRfaYbacexnT+Kw+GPngbuQtalCYhTMol/JChLHovHvRWsK/ILRv
         0Gx7dU5SZ+xhkP0vxbQGSb9iDQPIVn+xB4rkS5TdoISZMf9iDWVMGYkTbr7ThC2bQSkf
         jlG/J/VvDsbPckf1dZ6ODIHs2KvdpIp0pVnReSWhcpbMMPW7OZbs4Rq1qWVTLuwxcvqi
         Sro/vAiuPz6+VqCJW7YjoqskJWChQz845nP4L9+1lyECcfW4uMuyncj3kZtCCN2HmyMT
         +PiEd+EQoXfjrygxJaSP2/kawE5KqFu5XSfhQhTY23bJeNfHJWYS8KrEdb12SCYiWyqL
         KXjQ==
X-Gm-Message-State: AC+VfDzoQXAc4PF07D/bitsmYzRXHBaS2gVLTQ9jZbzP5uUEWeStmlLg
        VE/qdmTJ9X8xGDdNCZBYei0tRA==
X-Google-Smtp-Source: ACHHUZ5WMJai/7lvt00NBo93bMqGBV8AwVXXrIpyWqT8UcwT9B2mcylhVQ9xuSDVl+13JhaF2VwWsQ==
X-Received: by 2002:a5d:448a:0:b0:306:459b:f575 with SMTP id j10-20020a5d448a000000b00306459bf575mr554124wrq.12.1683110466641;
        Wed, 03 May 2023 03:41:06 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h13-20020adffd4d000000b0030631dcbea6sm6450573wrs.77.2023.05.03.03.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 03:41:04 -0700 (PDT)
Date:   Wed, 3 May 2023 13:40:59 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Andy Teng <andy.teng@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-mediatek: delete some dead code
Message-ID: <68fce64f-4970-45f1-807e-6c0eecdfcdc2@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is already a test for "if (val == state)" earlier so it's not
possible here.  Delete the dead code.

Fixes: 9006e3986f66 ("scsi: ufs-mediatek: Do not gate clocks if auto-hibern8 is not entered yet")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/ufs/host/ufs-mediatek.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 73e217260390..a054810e321d 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -410,9 +410,6 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
 		usleep_range(100, 200);
 	} while (ktime_before(time_checked, timeout));
 
-	if (val == state)
-		return 0;
-
 	return -ETIMEDOUT;
 }
 
-- 
2.39.2

