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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54ACC4741F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81C0E20B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z87+Fi6I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbgJAM1x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731926AbgJAM1w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:27:52 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A225CC0613D0;
        Thu,  1 Oct 2020 05:27:52 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s14so1466853pju.1;
        Thu, 01 Oct 2020 05:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ouf2Btjyrfu8hsFcX+gtYlfigwnxT6LfTNtyIop3GBc=;
        b=Z87+Fi6IIGwkNUbmObg3E0/O10eaRcuM5Kd3G82MlAh09V9X7354YHpxaBYFyuNw1G
         WZmDVHcXg/w5luVGvpjX43K8Zwgyn+A4750tWtcDrYVTESOfZajw4J2U/353zYymU52w
         X3G/k102+ysSejaWCLDW4VWmsXgfhvIFJ7euzzDP1YbWASctdo07HJPSvYp8JBZWdKwl
         VLVAY2vy1xzDtS6dMqClEXoEoiMgJpOEbI/kf3MPw3ASAOBu/3gwhylq6WvVbQSenOT/
         d5Cve0jXoU9L9+EuVPjBjoMvmMTgpgorWPG7eAQur7PIIMfWSGrSHzGcDhBOo1JpS+XR
         zxvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ouf2Btjyrfu8hsFcX+gtYlfigwnxT6LfTNtyIop3GBc=;
        b=WcviQ5SsYXywhDRHKUu9QVgRVDeZpSIscZBxawBN2l85JD2bR6SyhmDJHf01NAugSt
         tvcOMkJjA6i3Yc6E9H+UUXQZ/DfORwIhNJ1d0dJhQo+P1Nl7tzKtaM5DLyXmIphZUzaF
         Rwq9b6lPktf24r2QKhitB1H9Ir/Sur5UpPs2pjKhGhiR9APoTpKwsNPOBwrbrUHrLDwW
         dX3bBGArEkNvwlMgObXpRG2uzqaWeDZ7T4dtZiYvEUl20XIN4Z0T0mx4Pz4174afBk+T
         jdeI/UA911oERKjc+BVLETiH6tH+Ku2hBB4FMCxzsFCTbawqCFOvvAe3in12LyZHkIm5
         a4sQ==
X-Gm-Message-State: AOAM530kqUg1l0NjL568Ui4+cu6BcAN/uYFSnhbRySwQoPbI6PICxDcs
        jmLsL/8trY+usgdcEYhqL0Y=
X-Google-Smtp-Source: ABdhPJxe+iLicMnfTPWlWjlRFAFHdqc2Xz6AwEGS5yjnoYV11M4Hi9lSXBxqapocUcsLDxuimEqxWw==
X-Received: by 2002:a17:90b:e01:: with SMTP id ge1mr6582136pjb.187.1601555272157;
        Thu, 01 Oct 2020 05:27:52 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:27:51 -0700 (PDT)
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
Subject: [PATCH v3 01/28] scsi: megaraid_sas: Drop PCI wakeup calls from .resume
Date:   Thu,  1 Oct 2020 17:54:44 +0530
Message-Id: <20201001122511.1075420-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in megasas_resume(), and
there is no corresponding pci_enable_wake(...., true) in megasas_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
megasas_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 00668335c2af..93ade9915ec0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7614,7 +7614,6 @@ megasas_resume(struct pci_dev *pdev)
 
 	host = instance->host;
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	dev_info(&pdev->dev, "%s is called\n", __func__);
-- 
2.28.0

