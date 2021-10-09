Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06ADC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 08:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B36C60F6C
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 08:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhJIIzU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 04:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhJIIzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2021 04:55:19 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B95C061570;
        Sat,  9 Oct 2021 01:53:23 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y7so624743pfg.8;
        Sat, 09 Oct 2021 01:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=cyxKiaN8F6IYwIVrU5ZS38VsZWDL+7em/5KS+qZepfE=;
        b=jF7MQSabdruuLP5KMT52cY0YiCB6M62vcbOxJcN2m+n3Zpjg5LB4oQjnqTmP4jw8z4
         ZAiS8NBddhwkimiqXB3MLa9sBGxuFSkfiS549Q0ymTj4EVrOkr0E6XrfvwSrDtgkJq54
         njRlRn9P6dlue9b+60OE24z/E5wAOgUuKA0BARH4XCx18jk+liljIsl9f1XQ7F2B1h/A
         bxZAAOcPkBfaNb9o1zvmeaEWkIUqh1Tt38ltKIgx0FYyuQWCkYj+msYqqM/tuxPuMFwm
         j05TQTi8yPYcHvj13559tnOCphhLqZsfaVTYDO7awykke9lHedQF25Jx3so/TxjBV31Y
         Dmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cyxKiaN8F6IYwIVrU5ZS38VsZWDL+7em/5KS+qZepfE=;
        b=4DPXoEtknXlwypxu336jHD1jZO0Bq1zY0x8djYyW8/yO7VnSE1Ph3jkQF76rEg636q
         rzwuuqLcj63g6oFn3TSvHpc98dwVqBm5EAUPr1BVx/iCU4eACzfcNI15rjSCfvPpTJf7
         2utAOqvuUT8lMiCvizE0tgHNuB4ayvrSg6Nk+NbpPF/3Vnwj2i+B03hZ3g6U3ExHuIos
         ct3HM6/kqMXP++XBtJetABq4gfYsgdOEQaE8dJqs7G28VNMXCPACrrpFk4MnXSA9BquX
         c9LhGOsUEeGuS2BVznIhRkz9JN3GvRwUVvVLbEE6f+POPURIXtXSwi3UrlI98nrW0NQ3
         g0sg==
X-Gm-Message-State: AOAM530lC+YH4WLk3kqHp3AOOwbqnY7/1b0q+BSjzZ24xeCXFhSzqCtw
        D0oEBc7hb0rsbtNqOJXkjcOXY7Kkx8yuWw==
X-Google-Smtp-Source: ABdhPJy0UHL4FTZzfKQH8tXbqqFKkIc7hb/n+12F5G4XfhSHzHGM841WiUyiQO9oL2HG8FzrzE7g4Q==
X-Received: by 2002:a63:d19:: with SMTP id c25mr8524925pgl.393.1633769602799;
        Sat, 09 Oct 2021 01:53:22 -0700 (PDT)
Received: from VM-0-3-centos.localdomain ([101.32.213.191])
        by smtp.gmail.com with ESMTPSA id m186sm1579251pfb.165.2021.10.09.01.53.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Oct 2021 01:53:22 -0700 (PDT)
From:   brookxu <brookxu.cn@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: core: use eh_timeout to timeout start_unit command
Date:   Sat,  9 Oct 2021 16:53:19 +0800
Message-Id: <1633769599-19764-1-git-send-email-brookxu.cn@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

In some abnormal scenarios, STU may timeout. The recovery time
of 30 seconds is relatively long. Now we need to adjusting
rq_timeout to adjust STU timeout value, but it will affect the
actual IO.

ptach 9728c081(make scsi_eh_try_stu use block timeout) uses
rq_timeout to timeout the STU command, but after pathc 0816c92(
Allow error handling timeout to be specified) eh_timeout will
init to SCSI_DEFAULT_EH_TIMEOUT, so it is more reasonable to
use eh_timeout as the timeout value of STU command. In this way,
we can uniformly control the recovery time through eh_timeout.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b6c86cc..ec864d1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1404,7 +1404,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 		enum scsi_disposition rtn = NEEDS_RETRY;
 
 		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
-			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->request_queue->rq_timeout, 0);
+			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->eh_timeout, 0);
 
 		if (rtn == SUCCESS)
 			return 0;
-- 
1.8.3.1

