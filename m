Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344A0C388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDA2922258
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CggIJjuL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbgKBQyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgKBQyY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:54:24 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB18C0617A6;
        Mon,  2 Nov 2020 08:54:24 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 72so4910754pfv.7;
        Mon, 02 Nov 2020 08:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tsLH0jLFmVf53d+PF9Z2Na19r4rjuIS/8Zz7+PtjCXU=;
        b=CggIJjuLgbNz5h9DMzIwuEZcDOyBeLnQvT5WCGynKw9pz1RuWMdXCJOWYp3NZzApN1
         5TBUiKdxFqSDRUHRCO2qU3kio/t0jZwx4abi/KMvW5/UTq0nqPOsP1O4ISj+P/XIDkuH
         rpNVoompz/nXdUmotTvmXnXwyZasLldh77ZFlBopuN2bA8ODByuIso2frephWNPNMtVW
         WneU29PmIXRrtBlNSHAqfCqNigB9Itbwqg/wTL6QT7uIFrHWrp6630UHXsjJIOYgn3sq
         vvXQZggrNhY8c0S3Wt//xQ+geunh8dWFZlZ0BymMoJhsD/DrtE6kuxIlfI/Kc69YAQtB
         JAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tsLH0jLFmVf53d+PF9Z2Na19r4rjuIS/8Zz7+PtjCXU=;
        b=dbqatvVHzdQKPm5dTPWdqfRmOelvsSDRRWuL/jEqE3fPxCZRWTXVMQ2MOKnqly3EBy
         zVknUHl4LpL7inYKWN35A+wFPjMUXxpAX6w/sgTmB6A70/2GwpgjsZOv1DfTCCinVYTE
         h/J4m+7jv+SOKemWB5WWu696lSQArN+V4gfDou++xnEF8/sVCKbQgTm5PvtBACZHV1ji
         66aU82GoaRQFuWBz2SfXlbGUoIAuuCE278RqSlmzBa8ppuQGZPYnujs139STHvqvS7qp
         p/K4cbXmC7JcTEYMAeU14V0uP2I8t7gWJcwHl9wOxgDTxRo8GBm19yfg21XNWvsRb3Lu
         N1hg==
X-Gm-Message-State: AOAM5318hLUdYDLIOvBw3/8ca55L4LRcyUzaIq0wLd2valKwKrVp0JgM
        LnN4A7WO/zKKNGMMZy/cJ20=
X-Google-Smtp-Source: ABdhPJxfN31gUnc7+QlY1HyEuUCBrTa6c8PhSwyeZjh6Dft+Dt5ux4oRfpn1AS4dPI5FbYSinWGC5w==
X-Received: by 2002:a63:70d:: with SMTP id 13mr14407549pgh.263.1604336063665;
        Mon, 02 Nov 2020 08:54:23 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:54:23 -0800 (PST)
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
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
        Don Brace <don.brace@microchip.com>
Subject: [PATCH v4 21/29] scsi: 3w-9xxx: Drop PCI Wakeup calls from .resume
Date:   Mon,  2 Nov 2020 22:17:22 +0530
Message-Id: <20201102164730.324035-22-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in twa_resume(), and
there is no corresponding pci_enable_wake(...., true) in twa_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
twa_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Acked-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/3w-9xxx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..e458e99ff161 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2230,7 +2230,6 @@ static int twa_resume(struct pci_dev *pdev)
 
 	printk(KERN_WARNING "3w-9xxx: Resuming host %d.\n", tw_dev->host->host_no);
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	retval = pci_enable_device(pdev);
-- 
2.28.0

