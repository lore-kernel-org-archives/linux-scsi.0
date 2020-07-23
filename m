Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D436C433F7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F1E206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xTfiRk90"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgGWMZR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728963AbgGWMZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:14 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD21BC0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r4so2011015wrx.9
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HAIXAoCGqRA6aXiEiRW1R66V0LVzLBw6uYtWpjQ05tI=;
        b=xTfiRk902Ux5z0iLg95e5TXWewYKIvXvL8/J/I5m9W04gEagMxuZuQUJqEglaXOHTD
         8cO7dex6ejeb33Fr+JckVgaaRtP8237JEcRZpIQY/Kg+mGsdxQEVu07uxFb015X7f2L2
         rg7Kd/6zmR4EcZtRYLpgqAEKcP4zECyy3QGjW8I25aefIKbakjBVSx1XP01mSSfX1gsW
         JFen4kOawaCoSco3oTdRoa4lBuO6gD1LM5ppqC+cQxWiCM/PlD///eCg93g3UG5qL9N2
         Bg4/5JP+ffO/fSmzF3kjIJKYnDWMi3V9+ilhrYWmxxjpCwwtMJquB2RzqnloOvlzKU6q
         I9SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HAIXAoCGqRA6aXiEiRW1R66V0LVzLBw6uYtWpjQ05tI=;
        b=ecLTBNDXLODPMKN+nzAEZFlEWzLtDkgpqbk03xmz/BYOjxDSo9kBBl8tHQwJL5d8xr
         DuHVZh+itLcTV8rkA2JvK8XPXMYZ8W44wZso5GYQELW7Mm/Yoh9u6DVtvc7RQBcwwO+i
         yCTF0ssV8A/GH6BpFb18gLMglyIyXbqDH2YGqJIFf8wLx8q9eB8wbTWf+OJOzvingqZL
         zBtJ9BnvRmDwzbj/+b126oR4UKKqnnelUcSRLi5TakPJvbu1WkTHKiH1AK5kicg7Yovy
         S4cuqpQAMFDDQjE+IAQ9N93rjiTHiIMCu7fu8em6PxB/dHWx0GX/m/bMad9DNeSB8SwC
         nEvQ==
X-Gm-Message-State: AOAM531N8IDfQq89hAS2q1+zC/JpRIDAydOMjdFI2n/KCUVJ4h4jniXv
        TQJOceHgF/NA535IJkRZI1EXaA==
X-Google-Smtp-Source: ABdhPJw6c+4/R2KsXk5e1ke0zgJmSY+jh8jMKQMPrpTCdgWccXiEJ7HwuDP9IpkKqcDH7tGFistLXg==
X-Received: by 2002:adf:eccc:: with SMTP id s12mr4269090wro.157.1595507112468;
        Thu, 23 Jul 2020 05:25:12 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 19/40] scsi: lpfc: lpfc_nportdisc: Add description for lpfc_release_rpi()'s 'ndlpl param
Date:   Thu, 23 Jul 2020 13:24:25 +0100
Message-Id: <20200723122446.1329773-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_nportdisc.c:1079: warning: Function parameter or member 'ndlp' not described in 'lpfc_release_rpi'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 5276bf5bd59bc..e4c710fe02451 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1068,6 +1068,7 @@ lpfc_disc_set_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
  * lpfc_release_rpi - Release a RPI by issuing unreg_login mailbox cmd.
  * @phba : Pointer to lpfc_hba structure.
  * @vport: Pointer to lpfc_vport structure.
+ * @ndlp: Pointer to lpfc_nodelist structure.
  * @rpi  : rpi to be release.
  *
  * This function will send a unreg_login mailbox command to the firmware
-- 
2.25.1

