Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C25C33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F1F124676
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cSVdOB6s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgANLWi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:22:38 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38844 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANLWh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:22:37 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so11784568wrh.5
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cy1Jb5hYtJ1epiCktid+5GFTwHRojPnSHEwxWIKkSzo=;
        b=cSVdOB6sKhc4sEw5C90topeNEQDeTSrTjqBe9Ngztj9ykccleUpBpphRSXSjjwP78c
         UNfxcLaTOQF4sJpRXZzGb5CsBRXb1U12472BcUbM/V+LJCSEEKA0KEjqOROYKWcyfbZo
         ewh2LQ71OB09gPFZWMObhYzs2O7dhVKDiW7iY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cy1Jb5hYtJ1epiCktid+5GFTwHRojPnSHEwxWIKkSzo=;
        b=nC0DI94lor+LsEEfWzmCy78n6IkUrZ0CtPKD2uHA3rBlLAvclz9H2roBvcS4RcokVD
         8cj4ASqcVIucUg2kTww2DThWHH0fwmH4ud3DiDaOfAreoB9qBtpbnia2DVQOVGcJXl6f
         qkxPAZRvEty2qxDY+cfLUnKFSkbY9C+TinvBe+kIXWC70EbxCOaJqUPqD38HbJELZ+TN
         ngzpz0fe2hxNjzdOj1KoyPMPrr1qjM0ovjpJXv0dj9AJ9xms2I0eEDINwqsGuy+piMlC
         IMnLUxXySI+QTkSbMTR+UuZfceFsVdUQHGxVwLFRtOUj9y4OrziIy0nPfF0Dx4TWvgod
         YEzQ==
X-Gm-Message-State: APjAAAXtJAP0aRoWdJ0Q1noKwbmwPBaIJovEIasjXjxpSCZhIPOPKkaK
        gtcKQp+4Vk2JgETnTwvRd1H9QcMfUgOjlWE/S9c1026KXsjXyIO4Wj+5II2IP+FHHBIoUSKaNi7
        aiESDGD5jLeiylbjsCFfIhbOGkl4DP/0fzoEWqbOSePeJPxdMVAI1l0wpuvPDvq4jOANUl8eHCQ
        vAXzhy+g==
X-Google-Smtp-Source: APXvYqygyU/mYsj7rT0+4efamk6M/Mq1rh0bcKj9TeDVcMV6iZLVNd+y0lPkCCDaOZE6rPcncJQMzg==
X-Received: by 2002:adf:fd84:: with SMTP id d4mr24438528wrr.211.1579000955493;
        Tue, 14 Jan 2020 03:22:35 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.22.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:22:35 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 04/11] megaraid_sas: Do not kill host bus adapter, if adapter is already dead
Date:   Tue, 14 Jan 2020 16:51:15 +0530
Message-Id: <1579000882-20246-5-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8b9ecee..26c5119 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2154,6 +2154,12 @@ static void megasas_complete_outstanding_ioctls(struct megasas_instance *instanc
 
 void megaraid_sas_kill_hba(struct megasas_instance *instance)
 {
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

