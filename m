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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A11C4727F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C22FD21707
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ofxvab+g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbgJAM3d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731888AbgJAM3d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:29:33 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3CCC0613D0;
        Thu,  1 Oct 2020 05:29:32 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x123so4334898pfc.7;
        Thu, 01 Oct 2020 05:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZ7mt7sETAYntydhqj7zSY8Hb/mTTvO0FCNgup4L184=;
        b=ofxvab+gDa9g6e3GCmRNtAWmZgzvGNWvNibyvC7rraADmGTq1B3cETmqA1yEwb4Sjj
         d+BAlu0Zu26l9w05vCkME9kjZLJkbJ+2T55OZtnVF2Eol7At2NE7DKjUKkvBw9Ua140d
         Qqlb7u9ZSdyD71hLDUzTkMatHSjZmUdkcCrvHrEmwziPJ778n5dPexVUisZWxDERkpZ0
         dp5H610n+2VZ7CKg/dLkPTI5M8cY0cySZNtgI34kn65nWzAtT3GBxRjGfL0DAhYABm3M
         lOyvgh3DPdJnkl+AMxiXbe+pbrjMX4jIfDZ+r2nbgetiAhAGOVJ53H/7JREN8iJ6KYwu
         Id7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZ7mt7sETAYntydhqj7zSY8Hb/mTTvO0FCNgup4L184=;
        b=UUFXfbgfsXzAdsHM7f1QJhi6OVs4Ov5YTA0v3XP7WIT3OumFnjmDB8qA1paZ2vKybv
         HteuyAkpyXvB5YZIpVk8eDf+8qErB6sHO3LwBpIBez8Cll7OgisWqEu8pBU7EDCGeXC2
         ApOW0+bD6sSR1i3VheaU6fGLUNXnr7Hg3w0KuDnylsa4g0MCrqx52L7hgHIIOHOtZIpt
         sWOI4bQNk6DE3wo4cLzz9ladQF+MEpcQ6lMzMNeb7mJceKCNnvv2Y8M2Hhblit2HOCOr
         CayiB4A8kKKym2bL40/P9/zhngp/x0b+c+TQPd/otjb5UUz3jXsH7ltno5fwK0avpTjB
         TsNA==
X-Gm-Message-State: AOAM5323XdOead9yoHOimVpFAwgsOsVF8PIHtGlQHYp8laPTDIx7M2WM
        g/ZV7KUjfpIrZn+dwilE2KI=
X-Google-Smtp-Source: ABdhPJwYFX9JzHaMbhHVTN3co8ODVcF0d4NZ4tbbKgJM0ztwTs8zXOSTqSzUZ9YqbBR0AQLE2XU7ag==
X-Received: by 2002:a17:902:a3c8:b029:d3:781a:15d1 with SMTP id q8-20020a170902a3c8b02900d3781a15d1mr2470367plb.0.1601555372488;
        Thu, 01 Oct 2020 05:29:32 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:29:32 -0700 (PDT)
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
Subject: [PATCH v3 10/28] scsi: esas2r: Drop PCI Wakeup calls from .resume
Date:   Thu,  1 Oct 2020 17:54:53 +0530
Message-Id: <20201001122511.1075420-11-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in esas2r_resume(), and
there is no corresponding pci_enable_wake(...., true) in esas2r_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
esas2r_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index eb7d139ffc00..90bc3489964b 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -676,10 +676,6 @@ int esas2r_resume(struct pci_dev *pdev)
 		       "pci_set_power_state(PCI_D0) "
 		       "called");
 	pci_set_power_state(pdev, PCI_D0);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_enable_wake(PCI_D0, 0) "
-		       "called");
-	pci_enable_wake(pdev, PCI_D0, 0);
 	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
 		       "pci_restore_state() called");
 	pci_restore_state(pdev);
-- 
2.28.0

