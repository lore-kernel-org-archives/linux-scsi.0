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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6631AC47420
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3096A2087D
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:28:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uD8CXQZd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732195AbgJAM2Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731946AbgJAM2Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:28:24 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6105C0613D0;
        Thu,  1 Oct 2020 05:28:24 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k13so4365489pfg.1;
        Thu, 01 Oct 2020 05:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ypqOHrjRHTrRjWj0JrpKHgXr697RC6F/PNYuZQnGfKg=;
        b=uD8CXQZdzmDCEwzR8gXof/EZqnW9HM5+NDbk8JtZCj8WkwAaxxnZK7jCKvHoox3Cgv
         o4blxFzlUCoFhAaWUgRoWnymVNWSLY4de9HnYhOHIGjeX+IXEuGtM7ikCJ2I/H1jvVb4
         gDzdLwMMsF293gOLxQqug/womCmgxYrbjbHo3HLsB0+apfAa59b0b2oZynJXL3sNuFsf
         LqKIJjoE+Nwj1brTGFCrzTQIjXRhJcpn4MEbfWH+4Tb7Sjd5PN5dt4mg6I0E4d0SyjSd
         GdtP50OsY342DXUasAaWEVCbHT4dHCuDDfduYrTCSYqf8j89m3vaO1+u4E2YkSms1l9q
         82Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ypqOHrjRHTrRjWj0JrpKHgXr697RC6F/PNYuZQnGfKg=;
        b=OQA6tv2cTvWN1+8bBpdyzfce6ZGH1bDOdEU0/rTtM1hEVcVMVK92IiGoMuN7snqJq6
         V/zY3riJp9yZgZZgZdwQU0mA3RXkJpf6t4XZZLuhFqQhUY9sNl1BlwwohXdseCENEZBy
         QnZS8DVXyKEyS65xvFgLVyjXYecS34eLdbL0ZI7hnsLOD4AQMDCannDq+em/FxK+v5mH
         MAGx3s097QQCUbMbZGLy+lrYY+VpFlIq3j8n8PwdjWNAomK57zKsqGdrAEfULL/6F5dz
         VoU30JpOku8VcqZwgIzxcGBhktnmQW6hqOkvIEWRFhck/3KM/oCCVHDhe3+6NTtlYOy4
         FK2A==
X-Gm-Message-State: AOAM530oBgUmWRstr7bu83EEN25IZZOKMkEZ2QYT2pIvSYl5OJNqWw8y
        owkZE4s3Mds+LKkcDOyAyiY=
X-Google-Smtp-Source: ABdhPJwBz5U6AswbiGknT4A+/BI8h3JQ1UevL5inKwYxlFZqbQj2tSMJL/mXdP6Bi7sF+EQXX6cAXw==
X-Received: by 2002:a62:1542:0:b029:150:e3f5:d8fc with SMTP id 63-20020a6215420000b0290150e3f5d8fcmr6787347pfv.66.1601555304239;
        Thu, 01 Oct 2020 05:28:24 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:28:23 -0700 (PDT)
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
Subject: [PATCH v3 04/28] scsi: aacraid: Drop pci_enable_wake() from .resume
Date:   Thu,  1 Oct 2020 17:54:47 +0530
Message-Id: <20201001122511.1075420-5-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in aac_resume(), and there is
no corresponding pci_enable_wake(...., true) in aac_suspend(). Either it
should do enable-wake the device in .suspend() or should not invoke
pci_enable_wake() at all.

Concluding that this is a bug and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
aac_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/aacraid/linit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a308e86a97f1..289887d5cc79 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1938,7 +1938,6 @@ static int aac_resume(struct pci_dev *pdev)
 	int r;
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 	r = pci_enable_device(pdev);
 
-- 
2.28.0

