Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E981FC4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A59B020B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:30:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UClizyI0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbgJAMau (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731987AbgJAMat (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:30:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D7FC0613D0;
        Thu,  1 Oct 2020 05:30:48 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e18so3934128pgd.4;
        Thu, 01 Oct 2020 05:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=08PYeurcX5Vq/35NZf/krIMx9TNkE2AMAtJDR5OrRSQ=;
        b=UClizyI08VIm/vQ8nJqeIAbyEYMxRxqGpcI9FusZBz7DvsVF7ubCMQvbUve487fviP
         WVkSGVTBZgEnW2uqwsS2/nUzU4MJCNzuNvGBqzbLtgUNDl+gRAoigTtp1ujGLy5LVPik
         /NyG17ybIW2fvkdWYQWWgfdH/nBL7XXtU4FxHU1G9G344V6VFYGlMRFQW1zkBlP7C3Fs
         dxIzMfom1Kd8OoeolMSkORkB+cxShrLeYaNny2m2r1/6oK52SDi69U9JCLsAreMlGicF
         YZOvIPjoCMRNh9JudNtQkLtJp7Mv3Rw32vPomHMAnlFTowUAP+nYPRc43Tl/fsKYTCwH
         CF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=08PYeurcX5Vq/35NZf/krIMx9TNkE2AMAtJDR5OrRSQ=;
        b=HP9wOq78wc4BmyhrwhC3ybzRo9v8Rh2k0+3qX/kyxiH0qwWQAjU9gxLe8yIhz1wtfi
         UbCe7Vlw+b4UjzzfwuztvDvu9K5y9KFWqpHgswEQwPB83hAS5XrBSeAOa+IrDQVWfP8M
         uf53a01d7zGcdCnMFJo/I/wD1e2FhusYAISfpEnT+EUkxOctHo9bfP/9ttNwc+0d7oVS
         paiJVUtGyVV9jjIONbHeJVUlI6Yw7Bk+WdUlAxol5DQu3CoRYchVnHgsy+MN+VudGtqn
         Ej1VRfsRFk7/6TJmpD2C6zUnzUvzrxhpe/I2EPHBt9w0FzqZI4/xJJFEI/CHNe+Ppiwy
         TF5w==
X-Gm-Message-State: AOAM5304mrAIZ4W0f2/YW/TIGCyVNnft/sKzUVuVIDj8mRGTNHcjpJ/W
        BOiQfMfnKw86Jv0WxrIHrek=
X-Google-Smtp-Source: ABdhPJxR7bQaE+TCO8waq1FrQFlsa8qiJ19vieCYYeJwvWOnmGAIFrqiOfw1z33AhlDcElu7bocMWA==
X-Received: by 2002:a62:19c1:0:b029:13c:1611:6529 with SMTP id 184-20020a6219c10000b029013c16116529mr6783201pfz.9.1601555447756;
        Thu, 01 Oct 2020 05:30:47 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:30:47 -0700 (PDT)
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
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 17/28] scsi: pm_8001:  Drop PCI Wakeup calls from .resume
Date:   Thu,  1 Oct 2020 17:55:00 +0530
Message-Id: <20201001122511.1075420-18-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in pm8001_pci_resume(), and
there is no corresponding pci_enable_wake(...., true) in
pm8001_pci_suspend(). Either it should do enable-wake the device in
.suspend() or should not invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
pm8001_pci__resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 9e99262a2b9d..ee27ecb17560 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1248,7 +1248,6 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 		"operating state [D%d]\n", pdev, pm8001_ha->name, device_state);
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 	rc = pci_enable_device(pdev);
 	if (rc) {
-- 
2.28.0

