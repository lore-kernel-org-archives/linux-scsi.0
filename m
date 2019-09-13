Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE7FC4CEC5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA53A206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="G6O6PB4H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388092AbfIMNFP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38836 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNFP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id h195so18052548pfe.5
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WB/QzWn0vqzOOZqEIpVDtJkPkOSan2Oxa3T5EQcsz20=;
        b=G6O6PB4HPMetl2GNzCONq56MyAFJ7dPNhqpfzH9t0O7we3ZOWQ36ctT02O0ctxMiJg
         cnr+oakXysXk9QRjBsE9xRtTH5rVUDYrXLRSumpSHdMnnUdiwJXlVodzsXHPp3C/DP4L
         LTm5+Y4EkAqeKdrSbTZYLSleJ7BwOM92hSzts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WB/QzWn0vqzOOZqEIpVDtJkPkOSan2Oxa3T5EQcsz20=;
        b=duqIfiynNE/rFPYOhjnubWxfhzCzcUpW+gP753lIUSfoirZWd9GFBVOaFelXjfoq0j
         T1ySphxqFZZpOd4qFH3hMKegq2P2zdZ93RY/nIJKKc0kKgmXeQOVV1EKU4fVGFnEYlgI
         ZVsnOgWBBN360/B8XDlzEsalj9BmYUljV/TThQZ2kp2pf0clJHD4jhQ/IY+HAVxoSdoS
         qsT63xih6sCtsYs4RsZfHJ/jZAtQ8eNP1ICLtRO9NmsMltp1btaG+06gG/Q49y7hNaeV
         1d6T4BS4fxPsemoi7vZKgyZ09LzeqCoT/5yXIrRn4Lwurilnctc+m2+mI2xAIrhjHKP9
         O0iQ==
X-Gm-Message-State: APjAAAWE7n5bIw76dRoeyNUjrSA+fdTN5DV11AAIUap++xFpTxO4S5Ki
        37tIh184qoF7ok7SSY86tXySIA==
X-Google-Smtp-Source: APXvYqyLlOe3kdwSwqL4VYtKgSGH1ghY8dwjqwR1tRQaefgSNNUJAbJLYFQJifCM4l9rj4V4/3HKGg==
X-Received: by 2002:a63:550e:: with SMTP id j14mr38888204pgb.302.1568379914644;
        Fri, 13 Sep 2019 06:05:14 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:13 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 06/13] mpt3sas: clear release bit when buffer reregistered
Date:   Fri, 13 Sep 2019 09:04:43 -0400
Message-Id: <1568379890-18347-7-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clear MPT3_DIAG_BUFFER_IS_RELEASED bit once diag buffer is re-registered
after reading the buffer, else driver won't release the buffer and return
the ' diag release' command with -EINVAL status saying that buffer is
already released.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index a14ff88..504e035 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2367,6 +2367,8 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
 		ioc->diag_buffer_status[buffer_type] |=
 		    MPT3_DIAG_BUFFER_IS_REGISTERED;
+		ioc->diag_buffer_status[buffer_type] &=
+		    ~MPT3_DIAG_BUFFER_IS_RELEASED;
 		dctlprintk(ioc, ioc_info(ioc, "%s: success\n", __func__));
 	} else {
 		ioc_info(ioc, "%s: ioc_status(0x%04x) log_info(0x%08x)\n",
-- 
1.8.3.1

