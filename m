Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5AEC4742C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A135206F9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="To8S2jHL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgKBQxJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgKBQxI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:53:08 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61531C0617A6;
        Mon,  2 Nov 2020 08:53:08 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c20so11601537pfr.8;
        Mon, 02 Nov 2020 08:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6EF8lQwOXO2Z8DiQbYXGCQ2159bXf7Ji78BoyHo/jeA=;
        b=To8S2jHLUsT+F/DtIpwDe+1nsQoZHhatxgqGT8Sxc9KuSJcRM3S8ryS3lDtBN5YMeC
         eShZMSTpM3aCVSG4nLzekO+XOUtDj7y1FgYmyOoflsoop1hjOytHUrxV2RaxdVt1uR2K
         MsYuRH9Cm4h6i8pQu10lgzPWUt+Es7x0imUyp5peUkZWoz88nNq3tKjWLVQXyeoy5Ul/
         z5pEcBNh47ZPnd7Kj8KAiwpTLOhaDKBFsZhXe+elVgnjgD1CuacyLxDuhKvU82nUQZGn
         tVYMZUv2X+pju79d8atKoU76RgvzTZQ64FLTcnhEqHIhg+OcbKdWCbaUTKMj13OhJ0Ia
         oasA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6EF8lQwOXO2Z8DiQbYXGCQ2159bXf7Ji78BoyHo/jeA=;
        b=d37kHKDzFpSjOQ915Qhlftyi96Q79AhiEdFGO0Pdss1OH3yeAJUjhwfnHrfQsOz7Qt
         vPWxNKQOt7fPi6a28yvMonDG51O9eIdVKmXq/lwmTHhdQdwb7+zJa3opTo0Jp9IxyfWj
         ysPrKMmDY47xt2Cjwbt7Spus3aQEXRBwNEl86BKLm0tgaZOZJ273oiatbXPuc4v7ooUH
         wfNOJxgq89YUdZxstLvGvIV7xamZnf7OhvcXe23KI8C7TyZiV5XZB03CZU4akR9t6hDn
         d09jfsDEU3PWmJRCW/EGzeJAYVeRpVnw7JxJ473YyNIfzSUxU4d85XTjaIbBwdvxGyzo
         3u6g==
X-Gm-Message-State: AOAM5301Ed8Xr0TZHYFimmSHh/2KmMqrWIMjfUUid6oKqV8+0fKA4c5l
        PrNCnhq9/jx4ni4nbUT+sck=
X-Google-Smtp-Source: ABdhPJw+WZ503yKFquawRt0K3fv1VZ0392lfMRA03Pm+y/b3nAXy5mhWcTDXFlgVjXkApI1klFFsZw==
X-Received: by 2002:a65:6819:: with SMTP id l25mr14077553pgt.111.1604335987979;
        Mon, 02 Nov 2020 08:53:07 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:53:07 -0800 (PST)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Balsundar P <balsundar.p@microchip.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v4 14/29] scsi: hisi_sas_v3_hw: Remove extra function calls for runtime pm
Date:   Mon,  2 Nov 2020 22:17:15 +0530
Message-Id: <20201102164730.324035-15-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Both runtime_suspend_v3_hw() and runtime_resume_v3_hw() do nothing else but
invoke suspend_v3_hw() and resume_v3_hw() respectively. This is the case of
unnecessary function calls. To use those functions for runtime pm as well,
simply use UNIVERSAL_DEV_PM_OPS.

make -j$(nproc) W=1, with CONFIG_PM disabled, throws '-Wunused-function'
warning for runtime_suspend_v3_hw() and runtime_resume_v3_hw(). After
dropping those function definitions, the warning was thrown for
suspend_v3_hw() and resume_v3_hw(). Hence, mark them as '__maybe_unused'.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index dfeb86c865d3..9f0b4fe564cc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3502,7 +3502,7 @@ static int _resume_v3_hw(struct device *device)
 	return 0;
 }
 
-static int suspend_v3_hw(struct device *device)
+static int __maybe_unused suspend_v3_hw(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
@@ -3518,7 +3518,7 @@ static int suspend_v3_hw(struct device *device)
 	return rc;
 }
 
-static int resume_v3_hw(struct device *device)
+static int __maybe_unused resume_v3_hw(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
@@ -3541,21 +3541,10 @@ static const struct pci_error_handlers hisi_sas_err_handler = {
 	.reset_done	= hisi_sas_reset_done_v3_hw,
 };
 
-static int runtime_suspend_v3_hw(struct device *dev)
-{
-	return suspend_v3_hw(dev);
-}
-
-static int runtime_resume_v3_hw(struct device *dev)
-{
-	return resume_v3_hw(dev);
-}
-
-static const struct dev_pm_ops hisi_sas_v3_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(suspend_v3_hw, resume_v3_hw)
-	SET_RUNTIME_PM_OPS(runtime_suspend_v3_hw,
-			   runtime_resume_v3_hw, NULL)
-};
+static UNIVERSAL_DEV_PM_OPS(hisi_sas_v3_pm_ops,
+			    suspend_v3_hw,
+			    resume_v3_hw,
+			    NULL);
 
 static struct pci_driver sas_v3_pci_driver = {
 	.name		= DRV_NAME,
-- 
2.28.0

