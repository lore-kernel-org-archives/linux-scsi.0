Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48CBC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8252C20672
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JUHdqzup"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgG3IEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3IEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 04:04:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545A7C061794
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q17so13313268pls.9
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nJ7WevjVgZ7eT7LoDOQ8U5gkrK3MCM2WTYob4apNT5A=;
        b=JUHdqzup2VR+qQgPso+mqunO2Z/WLI7mQ4dN3DP6rWUdqW6n/OkleAekdt3KK6EPuD
         IDdtXqYCVC8qG4x5T+f3CErejBR8aoHz+kLrh/XIOnmf1P2JVLYnTAYF/nmKcPeNEkwv
         VrF+mE//26HtgsK/HfnMg/OHjHqODzuMWjeRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nJ7WevjVgZ7eT7LoDOQ8U5gkrK3MCM2WTYob4apNT5A=;
        b=nySjEilMtXKJdESo4O+aDyeu3qBrv0BkCy42aXmbMOzZNSnopX4Vsqj6+5F1tnzDI0
         CXYHh1uqc0phvcK6Gf6i7eYct+QnqW1S0HJ/yXOtIiTYyKy+P2WYBq9sPDF6sZOdb1y1
         Zk2L+tnILb77dF1SURVzhdQKU6+LPVjDsj+vl+/PRwYPUT1Zly9RqZU53jIJwEAUreZd
         0zDkcGtyXQSUBDmZ8FknaKPnlc5MK4UvJDKTjoyzLj5Y4BdnJiJjHHaDu3x9GPGSKOU4
         aBbSPSwzmjcPoKoAgczn48gz5h54Ga5EglAwXk+0FALR+Bk/7dyKxqH1aZIx/GwxQu3W
         x5Bg==
X-Gm-Message-State: AOAM532QDG6XA06OC90AbB3/U2cVf3Ogi/0zJXtZqumbMH2WS1PrkAd+
        jKt/I89X49jAyoLmm4r5HPq7uP8YQn8Urw==
X-Google-Smtp-Source: ABdhPJy1V2rKswbLeSpJAgBWZjIEd3Lupf7WTinsPYpfXwRDJdT3tevFKRdvBxpK9B7drOtYFKXLFw==
X-Received: by 2002:a17:902:bb94:: with SMTP id m20mr20079715pls.190.1596096259795;
        Thu, 30 Jul 2020 01:04:19 -0700 (PDT)
Received: from localhost.localdomain ([192.19.212.250])
        by smtp.gmail.com with ESMTPSA id d13sm5051412pfq.118.2020.07.30.01.04.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 01:04:19 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        sathya.prakash@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 1/7] mpt3sas: Memset config_cmds.reply buffer with zeros
Date:   Thu, 30 Jul 2020 13:33:43 +0530
Message-Id: <1596096229-3341-2-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently config_cmds.reply buffer is not memset to zero before
posting config page request message.
In some cases, for the current config request, the previous config
reply is getting processed and we will observe PageType mismatch
between request to reply buffer. It will be difficult to debug this
type of issue and it confuses by thinking that HBA Firmware itself
posted the wrong config reply.
So it is better to memset the config_cmds.reply buffer with zeros
before issuing the config request.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 62ddf53..17c7abf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -372,7 +372,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	}
 
 	r = 0;
-	memset(mpi_reply, 0, sizeof(Mpi2ConfigReply_t));
+	memset(ioc->config_cmds.reply, 0, sizeof(Mpi2ConfigReply_t));
 	ioc->config_cmds.status = MPT3_CMD_PENDING;
 	config_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	ioc->config_cmds.smid = smid;
-- 
2.26.2

