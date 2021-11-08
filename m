Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD41C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 02:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C61C361351
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 02:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhKHCWE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Nov 2021 21:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhKHCWD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Nov 2021 21:22:03 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B48C061570;
        Sun,  7 Nov 2021 18:19:20 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id r28so13828749pga.0;
        Sun, 07 Nov 2021 18:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=cyxKiaN8F6IYwIVrU5ZS38VsZWDL+7em/5KS+qZepfE=;
        b=MNkZeuOpuyf7/L+0yG8uN+CWXJ6P4LEZyALW/eCNTICCqMqCf3bdZWD+DnsH6FkU64
         ZdMHdIlS209W1DzXSBWN+uFxr4L0iLbhmhPUei81O8AvdmoSxpCqoFxnupefZN568h2s
         VvLHD3SGYAiIx10MXOYCHnomeYZGnnHR8f8HtEProKUFkk9B3i5oXwfYtOU5eVsVdlnR
         ZeoHKJDHXyAuUpn8lt/0Ehlk+FmINih5vweVIMqXkY5nV1aIMUc1ZedYRF4ZG97xyg9f
         3BPzc5v8QXVgOeDOjUh0nVmNI9zHbEZoCrKFUG9tEbJwnK0q0EMFQTMkw7yyFrwt6yZv
         T34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cyxKiaN8F6IYwIVrU5ZS38VsZWDL+7em/5KS+qZepfE=;
        b=dEh4GOyhSIM/Q4SVDt96BEQHKaYwrC4LQ0WqX2pIZKrPJpt3H/myXl2nIgWHUM5h1G
         k3CP4Yes22a1/9KRhvLe6QVUeSNA2tSiRMk7oe/KIuZ1kLZTBhR9WlTlFylfgGYpTwBg
         8mteOQQghwOT8iNBgndWJS9XXGm8pS1NNHHWK8MTlRdtFHDdRmu40co3w0Qq6TrR0Bwu
         KV1ljZQ2SfiHShS/Lv0YFw61yVgNBeqdydL+CJLmhWnkjIhFd4ivvoDCA/9IMTp6S5r0
         Q6xbaMBtTIde8Sx6rucEWKn4gkDsy8GEh5qiSCKtqf75xiSxodbtPbI/tcnPK+E916L/
         y6eQ==
X-Gm-Message-State: AOAM531y6WdWd07Ncyjf2RA3shVMdNMiJE9BxsAeO/xpjJrWwcPCcy17
        aJRAA3T5ylYOjilSjb4IbWULyVDoZb0=
X-Google-Smtp-Source: ABdhPJxA1K3u8Ln757ou5+qnu69wyJgv1GvS8PL9fXlvl4CeoLWRGSJrkISxVBMenXjHQHw8Y/wNXw==
X-Received: by 2002:a63:9212:: with SMTP id o18mr57623767pgd.392.1636337959745;
        Sun, 07 Nov 2021 18:19:19 -0800 (PST)
Received: from VM-0-3-centos.localdomain ([101.32.213.191])
        by smtp.gmail.com with ESMTPSA id l11sm14362668pfu.129.2021.11.07.18.19.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Nov 2021 18:19:19 -0800 (PST)
From:   brookxu <brookxu.cn@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] scsi: core: use eh_timeout to timeout start_unit command
Date:   Mon,  8 Nov 2021 10:19:16 +0800
Message-Id: <1636337956-26088-1-git-send-email-brookxu.cn@gmail.com>
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

