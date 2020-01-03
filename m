Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30FDC2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 856E522314
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JMLp3T3W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgACLey (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:34:54 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42221 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbgACLey (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 06:34:54 -0500
Received: by mail-pg1-f195.google.com with SMTP id s64so23314989pgb.9
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 03:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dFOhApBaCRZRV98te3Eh+4XUKsX8h5mh84l+JQNhe9Y=;
        b=JMLp3T3WFnhOYZxpXb6S072z91uFVbyjGZTYABcwygjFTOM4YSbO1HUcCGSH0shH+j
         c4bPFjtaO2avqhe+b2nqCAlT4rXU3Ry2TrCqmLaLDpVyc33zh1gvnMosE/jPbvEyaxUI
         puNDPBj33mDG1DMxn6tH7/so9n9ImMzANbxLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dFOhApBaCRZRV98te3Eh+4XUKsX8h5mh84l+JQNhe9Y=;
        b=pwOOGbAoPZus27iaG1Ur+QixZ3N6k85r/tTKLiyGE/TmRKvcsMiuCtiu7b7ukrGdIC
         eR4Nydby011qOAr1t97WaiVYx1eqzBQ7L0iRQo2utS/kd5uqwymjXTFSnr5m1z922Zmq
         d/FhY4fJ6mdzljlcckclWTIIgtpG0X/QSuMvlZuy7pybOET9GtmLzoPu71+ccl5qD6WS
         EA0560CIBCB+bVs+eDj70z5z6fD2qvPvHT38PuWbiKzj4WWc9tCLJo3nTfVX4nfTPlJU
         gxaSWHPdhfCznPb8G9PcZ8T302q9UtxFA7HMkS/56n8Czhcdtq2SDIhJL14JNSrU4eiG
         ELhA==
X-Gm-Message-State: APjAAAUUEE97+UyRP9evte9Tu49757HW1coGJoIF1LvilMRZcHMfxSgK
        MvxMG7Xnggj9wLo+2S/OkN5Cq/2e30huEUBlkv/pb1aKGK18AOMgul3WzE7edtM1woeJHpdfREQ
        oK11WDtraOe7bYimeJUXjbLuFoq0kgXtVN7Gg7WzqSlYzq9h7T7Ic1LsipDbGj+Kaf0Or/jiOAi
        6VRfWkcA==
X-Google-Smtp-Source: APXvYqzS1bzsF/j3DDvW+WRETX9lUuDRrDE5fuXquQ/cotx4yAE5fJo7uS2fCiSRccWDvGSsHKa4aA==
X-Received: by 2002:aa7:9f94:: with SMTP id z20mr90607136pfr.66.1578051293102;
        Fri, 03 Jan 2020 03:34:53 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h128sm70302144pfe.172.2020.01.03.03.34.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:34:52 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: =?y?q?=5BPATCH=2004/11=5D=20megaraid=5Fsas=3A=20Don=E2=80=99t=20kill=20already=20dead=20adapter?=
Date:   Fri,  3 Jan 2020 17:02:28 +0530
Message-Id: <1578051155-14716-5-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3cd269f..87bdcd6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2154,6 +2154,13 @@ static void megasas_complete_outstanding_ioctls(struct megasas_instance *instanc
 
 void megaraid_sas_kill_hba(struct megasas_instance *instance)
 {
+	/* If adapter is already declared dead, do not issue kill HBA again */
+	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
+		dev_warn(&instance->pdev->dev,
+			 "Adapter already dead, skipping kill HBA\n");
+		return;
+	}
+
 	/* Set critical error to block I/O & ioctls in case caller didn't */
 	atomic_set(&instance->adprecovery, MEGASAS_HW_CRITICAL_ERROR);
 	/* Wait 1 second to ensure IO or ioctls in build have posted */
-- 
1.8.3.1

