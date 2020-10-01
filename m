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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D69C47420
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C023020B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sgY1fPrx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbgJAMcB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731936AbgJAMcB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:32:01 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260A2C0613D0;
        Thu,  1 Oct 2020 05:32:01 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id y14so3914105pgf.12;
        Thu, 01 Oct 2020 05:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/MM5wiFpgdT4mwRJ2jTZ+VkorPqMhISLnhdlnmMc63Y=;
        b=sgY1fPrx0IIEz/mOq8kxGdUETanyglSMjkCnSF4mTv/pLvw8tyO5Cwpb2sLVYF1Oz1
         9m2TR79x+fC9Q9GSgfU15LGIGsiOikZGA7o//JJgcQwToPC4Z12sE1zKJal7nFk3k8UZ
         AEOYH5VoltYZa6p0fSG+GVeja3IiLnbCo9be2TA1gkiF1wbKQ/8PJAGDtYIuDEdoPoo5
         KebSd/18DSUIzKJDl7xqS4rggtobe+tSXTD8zwB+iRhPrpAhbHVRMiUXSepvRlEoieNA
         la7rbpdYHXAZNSiDEvu6yBb+9lMdZD4LPofEZqCyseas6wHIb0EetnR3VWLfO5p4kT5S
         0SWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/MM5wiFpgdT4mwRJ2jTZ+VkorPqMhISLnhdlnmMc63Y=;
        b=ONzTfKvNZaQs4QpI66uxeZm4RmReYHsWnGamu0GvNHYYsaa8R0ByqpGUDFyTTuWekl
         tpXVrW/CaemTUGVrFUnoAt+Q9F0z7gUL02Zf41r/gzLQE1VygZEIcHX1voX0MP0PX90w
         pCMg5TMPBtmHh9S1hEHrPiaBFUkqz3mLQB/+Q913ft8fMBXeLJZJCPUrJ9lwMh9gi66r
         qYxBLikXS178sVaV12fNUX33Qt1f1ldkmx2CdNjrXNaIUcMZTgV9jFwRhQPRfCTeIk4v
         WG84gY5Iy6DaQWwzHhW0ZFaXH0dUvcNx8hKMZ01Rz3dVmG0YvEJwbr4pHH91D9mug8Q/
         q6Ww==
X-Gm-Message-State: AOAM531W7g3wi+Mu4fwfnYc1Hj4zf0v46tAk1aubEcGWsY66Jjfe6iSK
        PCiPyeJ1LFF7xa+OIj9KLFk=
X-Google-Smtp-Source: ABdhPJzfLjOv1Um6n+JXmHxhDleig+gqaBsH2YdlboNeT6atbMUqJdrMFxbom5GiSdgteIOYOIsH3A==
X-Received: by 2002:a62:be0a:0:b029:142:2501:35de with SMTP id l10-20020a62be0a0000b0290142250135demr7404486pff.62.1601555520655;
        Thu, 01 Oct 2020 05:32:00 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:32:00 -0700 (PDT)
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
Subject: [PATCH v3 24/28] scsi: mvumi: Drop PCI Wakeup calls from .resume
Date:   Thu,  1 Oct 2020 17:55:07 +0530
Message-Id: <20201001122511.1075420-25-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in mvumi_resume(), and
there is no corresponding pci_enable_wake(...., true) in mvumi_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
mvumi_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/mvumi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 8906aceda4c4..6a25e6918e26 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2594,7 +2594,6 @@ static int __maybe_unused mvumi_resume(struct pci_dev *pdev)
 	mhba = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	ret = pci_enable_device(pdev);
-- 
2.28.0

