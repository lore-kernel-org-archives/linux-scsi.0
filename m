Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBF1C33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F7602467A
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DKuBB46r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgANLWu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:22:50 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40042 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbgANLWt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:22:49 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so13252412wmi.5
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H0SLcpjgTCq8jlUG56TWa+gnLqgBhu49QepW0ozeyWo=;
        b=DKuBB46rB5Eb2ytd8RT3Yw0TIjNEJQq/F4LHZMMbNVD7qipb1W9AZW7TaiXrSypww7
         XoLg6dg1YJ9cLJ4z5KOHQuJALMtlWbnF1hMG98DalmtTXQXbdD/TOC8MzzmqKFWGDnYQ
         l/VyHz10U/Emyu8LGX7Xii2R74gLiaNUw6msM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H0SLcpjgTCq8jlUG56TWa+gnLqgBhu49QepW0ozeyWo=;
        b=CnxjIzChVWFL2WiF2XByfga8/IRYig89CcZd1BHzdIQUpO2C7ku23ClvI4OBwYm8uV
         0z1yyVGJdA8QpdZXbjI8gbH6Bk/MRnR86yviUXFKCdVlpTAoPbK/Cr3taNpNJlJPDY46
         gQlX4EuHPs7kKMxEunaoNLFPbMEANQiHL7DntyVfGO2VCkX5PEaRjc6ll6Rqr/Pngpu3
         QLT1cnmyCDU4h+eSXQmJpJbB8Mr0pvoGhTtZwJxjV7SxdLkiWpAdiOJWcVbJg04ZnuD+
         Abe543DMq+WrJF/0zG2ofZeCwsJpFD8CvHbPoZLq+MQsG44NRkvnCGCY0VXHyKFeVeAO
         gWfQ==
X-Gm-Message-State: APjAAAXvN3AaOPh/R10Kx1O+DTjMntf2qAFtKfePRdrlNK80U9H27yWw
        3GtlR81+Uwe34oKS68obDsz2UdNfjrJ0Wu+dM72Lv763wZ9w6zuNh1vXwQWof1Fyi6OFjRe6rV/
        lpgFbHlkofQsgznS6GdWlXntFkJNnn/n4SDcd0htf3jrSCJA7vnFbjWUUwuFmvZTiXyK1mEE4BN
        IOaSqX6w==
X-Google-Smtp-Source: APXvYqzxS9qROvQnf5LW5aK5DjKvEO7Xbgm+rBHLH3uOYJCyXTF1JUnQRxR5SqJD3MWGgu43p9K6eg==
X-Received: by 2002:a05:600c:118a:: with SMTP id i10mr25377719wmf.142.1579000966354;
        Tue, 14 Jan 2020 03:22:46 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.22.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:22:45 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 06/11] megaraid_sas: Do not set HBA Operational if FW is not in operational state
Date:   Tue, 14 Jan 2020 16:51:17 +0530
Message-Id: <1579000882-20246-7-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After issuing a adapter reset, driver blindly used to set adprecovery flag
to OPERATIONAL state.
Add a check to see if the FW is operational before setting the flag
and marking reset adapter successful.

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

