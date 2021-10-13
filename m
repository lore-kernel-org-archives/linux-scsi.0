Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9AFEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 06:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C040060FDC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 06:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhJMGkP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 02:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhJMGkN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 02:40:13 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69ADC061570;
        Tue, 12 Oct 2021 23:38:10 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 187so1551015pfc.10;
        Tue, 12 Oct 2021 23:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kZDTyeqeP7XFf8baG809duK8U9RiKPxnGx7hrBpTCRw=;
        b=CLhaOBUhvqCAvsXUI0MfZudlv3vLfUIhp297hyecjEnNNklYM78rT1htsrkDX7VKby
         mCv/X2757P2834lAagBNr0Zqe6/F8k1O3BNODogfz1UToNZmYXgBeh8Lpxqmufh/KvVJ
         zjRhXxWhA1week7NS1DeXImmtdWydzdLgzvFJw/KBBh0jdf80szs4RYpDV/6BdoQ8tU5
         R9bfBryu/gczaHkH2yc+JGFq38JcNrY+30evHoXMFdfccQF65sexaUS4ml7GtmbBh8zU
         knEr+buEotjXEun8gaL63Jm06kopXzx9tEz+Dgce91QX/oHDnZ01lewlnmJQ2piereDU
         e9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kZDTyeqeP7XFf8baG809duK8U9RiKPxnGx7hrBpTCRw=;
        b=8PVdYlqpekxBOhAZUCdMNGnC/KCqENDBXrvyZ68rfM4eihU+/RN6/fOmp2N9iEvAvk
         /K997AUS+iVtTZCKU4PSYVGsJ+Qkbagj+Xtx6UsJ+PzlO0Qb0ItYkDDXWI8+KIszh3Jo
         8jlm3+eblaryVPNUlaQdq7K4gMcL/TqiDqEqvqBf0cIGXDlxQGuxxGeTvRYyr39ibk8x
         Q7EnIsMQKAamzKLUNjcUGkouP7YS0VT9pRvd3IqATAR8cKLoRi+cj3y0sN5h4m0I/h/g
         n/+V6UpXrd5Tj4sPgcCPPFcTvo2pskgyoz9G6K5bDJFvbplDjLMGEtc70yETTms0C7xz
         C+Ug==
X-Gm-Message-State: AOAM5335ntLhrARci/RH1fm3wM13cj1wAmWa1v4dPCrtb/hrT5UrWn9L
        5gv/NAZhksn1yj+J6nFVAYI=
X-Google-Smtp-Source: ABdhPJzQ1b8Gi5FIvmxfmuGYIvO1mJ3QxKFCHI/XhxGOqSjmAZtU8+O3V+qtv2SopZzmhx0Va/U8cg==
X-Received: by 2002:a63:3e8b:: with SMTP id l133mr1643107pga.352.1634107090260;
        Tue, 12 Oct 2021 23:38:10 -0700 (PDT)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id p20sm13557653pfw.124.2021.10.12.23.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:38:09 -0700 (PDT)
From:   davidcomponentone@gmail.com
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, davidcomponentone@gmail.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH csio_mb] Fix application of sizeof to pointer
Date:   Wed, 13 Oct 2021 14:37:53 +0800
Message-Id: <20211013063753.1699694-1-davidcomponentone@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: David Yang <davidcomponentone@gmail.com>

The coccinelle check report:
"./drivers/scsi/csiostor/csio_mb.c:1554:46-52:
ERROR: application of sizeof to pointer"
Using the "sizeof(*mbp)" to fix it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
---
 drivers/scsi/csiostor/csio_mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index 94810b19e747..4df8a4df4408 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -1551,7 +1551,7 @@ csio_mb_isr_handler(struct csio_hw *hw)
 		 * Enqueue event to EventQ. Events processing happens
 		 * in Event worker thread context
 		 */
-		if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(mbp)))
+		if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(*mbp)))
 			CSIO_INC_STATS(hw, n_evt_drop);
 
 		return 0;
-- 
2.30.2

