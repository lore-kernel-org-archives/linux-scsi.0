Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E78C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 115B061406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347127AbhI2WI6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:58 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:40902 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347099AbhI2WIx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:53 -0400
Received: by mail-pg1-f171.google.com with SMTP id h3so4142943pgb.7
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9y0QsIwMPGSgzx5MSYES9jzyAyZhlnryYct60FKOcbI=;
        b=KPJl2IsC3Hn09d7DJ9UpsiqePkDmf6ktwnis6UcEKmRMUil8fcEMtjJ635j1e0gAK4
         efZ6UEG53RZKzVoRqZeNTs3yjxa0X8RN9BE8D6dpDp76Un8xb2ETGOiGTTc97eJ+gLMQ
         BOfWB4iT4nvyRPOkbwrqRq1GKAECKphMCEDgtSFDHtl8DehPFLzi7i68Xl8lgBXwFiB4
         bbEaNwIHeGSfA6lZcrZRIyPkgFBsAjELWF+X4x3JyCuFqWr89q8+7ugd21XaAm5DBXBl
         VMQeFYuuz92FNUEUqGlvMb+enU3caYsVWbwe4CLz7JnYp063bpAk2SAPHpaOoa6pHry1
         sYHQ==
X-Gm-Message-State: AOAM5327zO566RKSWFJcYb7l54Q8sXlKYyik1VN+4GhSrtjdcfkq2Ezn
        ibh6LMpEQ6II9my6qtgx2VE=
X-Google-Smtp-Source: ABdhPJwXiuxxtLjwY/ughuKgPQVNTjhbFzMQ1KW4wcPwBLnkLWK2W4oKPQ1wqwDzJrLdaK38KLw34Q==
X-Received: by 2002:aa7:9e0a:0:b0:447:a7f7:40e with SMTP id y10-20020aa79e0a000000b00447a7f7040emr863841pfq.37.1632953231893;
        Wed, 29 Sep 2021 15:07:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 34/84] fdomain: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:10 -0700
Message-Id: <20210929220600.3509089-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index eda2be534aa7..9159b4057c5d 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -206,7 +206,7 @@ static void fdomain_finish_cmd(struct fdomain *fd)
 {
 	outb(0, fd->base + REG_ICTL);
 	fdomain_make_bus_idle(fd);
-	fd->cur_cmd->scsi_done(fd->cur_cmd);
+	scsi_done(fd->cur_cmd);
 	fd->cur_cmd = NULL;
 }
 
