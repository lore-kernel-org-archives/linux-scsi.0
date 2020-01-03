Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E39CC2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 510A621835
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SylS0PgJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgACLfK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:35:10 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34493 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727608AbgACLfJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 06:35:09 -0500
Received: by mail-pj1-f66.google.com with SMTP id s94so2832749pjc.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 03:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v1YiZ7YpNkHst1r1ATp8BpIslOCCGBdu3YLWzgmP9aM=;
        b=SylS0PgJv2im5ICqeb+ppMxrFRsO09H2B0qu+TOm2alsrByBSaS+VRE6Q6RoPdXXZF
         n/gwfSO9d5KSfMLsLP80/sHw2jLu3BB9yl6G32GobNIf6gy31URJcJkPPrnnIRuuGiOA
         GM3XAP7pcdwU0497fq7n6pO0AV7SkTfueXaG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v1YiZ7YpNkHst1r1ATp8BpIslOCCGBdu3YLWzgmP9aM=;
        b=Cdz1zmp1/nRiiL9r4LSQa6yiPrNIMFKbUhR5L/uYjmcY6nyYB8u5C/JxbA5GKeGvuM
         rXl5h2kpKDklnLJwt22CS1CZqd7bBAeAjuj4gsuFxKRstnomDYQmNXVTEm06+vskZssC
         fhTdFYu0oXDjHKf9QwwrmVEEK7d94ZqpNwpkSo55L+oVIqCFz6/kxDzwylfB7rEvDZPM
         mvOKU2ZGKYeBQ2zoelbfVwHYqLr2ANEZG1SaR2/0nxITJMN2w7veiU6YbiQaTpYwRGSx
         H0uf2N9PrjBnIj066wl+GH5IFqBu5DixM715faB8FIQ/NFj+Q3HJppRET/YrHYR2z3Ju
         u3pQ==
X-Gm-Message-State: APjAAAXQ4nT7iWbdntD0lKFvs2tgjkj+11TMxJX9YaAA9aRmPZ1V6Hf3
        OT/UknQ7ylWZHm/NKYXkZbdb9eFxdEHlRf0LN5t+Urtx7jsbdr30G+QlyXYMbTg3jXUagaAc6ko
        d9iYUMp8Rl0hTpAcdYZlrn+8kethy1mkIUnttGclfVQk+c6cIDo7tvL1jXn+MsXHuBzJZx2QoGX
        k7xXg6MQ==
X-Google-Smtp-Source: APXvYqz99l2umwVm1ZYOM+8bHF6qGU0tHwpl8asATiL4zqZeDOomcNcUGgsEhIW7z1a/Ohg5cbXjGg==
X-Received: by 2002:a17:902:bd05:: with SMTP id p5mr76852864pls.119.1578051309011;
        Fri, 03 Jan 2020 03:35:09 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h128sm70302144pfe.172.2020.01.03.03.35.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:35:08 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 06/11] megaraid_sas: Do not set HBA Operational if FW is not in operational state
Date:   Fri,  3 Jan 2020 17:02:30 +0530
Message-Id: <1578051155-14716-7-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index ef20234..6860fd2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4991,6 +4991,15 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				megasas_set_dynamic_target_properties(sdev, is_target_prop);
 			}
 
+			status_reg = instance->instancet->read_fw_status_reg
+					(instance);
+			abs_state = status_reg & MFI_STATE_MASK;
+			if (abs_state != MFI_STATE_OPERATIONAL) {
+				dev_info(&instance->pdev->dev,
+					 "Adapter is not OPERATIONAL, state 0x%x for scsi:%d\n",
+					 abs_state, instance->host->host_no);
+				goto out;
+			}
 			atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
 
 			dev_info(&instance->pdev->dev,
-- 
1.8.3.1

