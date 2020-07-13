Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15B4C4345D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B041A2072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NPfPymXX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgGMIAU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbgGMIAS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:18 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4DCC061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:18 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a6so14742534wrm.4
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uh7jTGgLUvWvRRLhz59nl6r+4sZq+HqjUUSpbbMrHCY=;
        b=NPfPymXXgeCvbsIcOSveuB8RE/oz+R82JSmYA3ZI4olCsfegJRLZAAQhll84hISKim
         cdPBITN6oejfxhDnkp5CX8roTgmpUAWG5ARcpoA99lcxInO06+Ei2nsZoLaXZtKlcZqs
         dY8ppdHawM4k/eG56eXRXOJFsL6/lgZgO3CS82LXKFK7Xi5SjeuP9C4fDwvHRnFIUvKB
         ylpoPu02xpJ2xFxJzY7qsiTFtRGJDA9oGgii0we30RzcaHk7R4kfJpMFRI9yPOBNNyke
         cUM9/aOExlgfmUxysWpH+tBB9veZyKyqKr00hEDHt5CiXAvurtY+PkGUOrPKXoR2Z6zv
         6xrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uh7jTGgLUvWvRRLhz59nl6r+4sZq+HqjUUSpbbMrHCY=;
        b=f/gBcz40FHP3lszdRYnmAKYfwiebe5kob7j3fRMMaIXbgFwP90KQzn5Gf3vB4eHe7F
         1n7fay45XQJTiAkKoc29NZMnjKMHm4WG42fBy1SOLaR04ODhXAOaOr9MZ4zWbpnb1UAh
         2kktIRlywZHKs6M+81FXyMU7VHkFCySO44nFSDVNyBuBIl2hzEOXvhE75hw9cau5rFhV
         O/Ve/SL9QB33YY/VoimPyAf/WUKalvzvuHDmYojRwBoqkwbu06gQiBpC33w7Kxrlh/Dx
         ulBMlGUa43ue8cpa726e26bcb+rGeJwcMud/NGI3mwjk0C2K4XqB/qkexBtz2Drz1U2j
         sEuQ==
X-Gm-Message-State: AOAM533bb5NUYfiyHDxvIrLkJ4SB45Imobp4AIaizxQuP35Hb8uaNQG7
        jcSMu9w5qkIryiLTZlFtHOFtHA==
X-Google-Smtp-Source: ABdhPJzGhGCbIvtDoNNaNoQzXKPNNMJctLfEI5QYuLStqKwwHjDsDS6TmAYE3PR02E3/kNadJO1jsQ==
X-Received: by 2002:a5d:464e:: with SMTP id j14mr78277693wrs.393.1594627217314;
        Mon, 13 Jul 2020 01:00:17 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:16 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH v2 09/24] scsi: aacraid: rx: Fill in the very parameter descriptions for rx_sync_cmd()
Date:   Mon, 13 Jul 2020 08:59:46 +0100
Message-Id: <20200713080001.128044-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

... and document aac_rx_ioremap() 'dev' param.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'p2' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'p3' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'p4' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'p5' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'p6' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'status' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'r1' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'r2' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'r3' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'r4' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Excess function parameter 'ret' description in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:450: warning: Function parameter or member 'dev' not described in 'aac_rx_ioremap'

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/rx.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 3dea348bd25d2..cdccf9abcdc40 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -144,7 +144,16 @@ static void aac_rx_enable_interrupt_message(struct aac_dev *dev)
  *	@dev: Adapter
  *	@command: Command to execute
  *	@p1: first parameter
- *	@ret: adapter status
+ *	@p2: second parameter
+ *	@p3: third parameter
+ *	@p4: forth parameter
+ *	@p5: fifth parameter
+ *	@p6: sixth parameter
+ *	@status: adapter status
+ *	@r1: first return value
+ *	@r2: second return value
+ *	@r3: third return value
+ *	@r4: forth return value
  *
  *	This routine will send a synchronous command to the adapter and wait 
  *	for its	completion.
@@ -443,6 +452,7 @@ static int aac_rx_deliver_message(struct fib * fib)
 
 /**
  *	aac_rx_ioremap
+ *	@dev: adapter
  *	@size: mapping resize request
  *
  */
-- 
2.25.1

