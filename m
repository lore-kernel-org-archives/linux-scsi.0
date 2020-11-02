Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AE3C388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 007CB222B9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o1vVtcE0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgKBQub (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgKBQua (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:50:30 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35C5C0617A6;
        Mon,  2 Nov 2020 08:50:30 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id t6so7084486plq.11;
        Mon, 02 Nov 2020 08:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eVI1RgdCTcgKOQYTeMJvf6pf7gm9DRT8JtIKidpJzFw=;
        b=o1vVtcE0URMlblenBRnxhQv+WgM1/34H7ENf+T6jvqYNL4Ji1VBlKPS1oMXYJ2aWyW
         NK/DV4SRSh+J8EOC3I9/1kRBQ7wyBgPQ9no4+U5sAsh42ryw8q3tsj7U8yvGUk1wOars
         qZt5hZUX15fvSrC6TLoj51YQu4QNGkj+OSo85oiqugyIKxty5w9yQm+q2f3eCusPsW1Z
         PBnu+O5hefQXc+E8y0mVQEjw45gBPEfvgCxuGmJEWOMe3N8nabHRI98VwK8wkURnJSxw
         eaAqYKq6AxzOfK3c6K9bSQ/NCf6gE11ArGXN3Izlko1WekyG2IkiVys9EO6Lo5DzzIBz
         P/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eVI1RgdCTcgKOQYTeMJvf6pf7gm9DRT8JtIKidpJzFw=;
        b=YOmLZxn0BQl5RPxxzI47h+zfkYBdxHnkDD9XPFHpj3H+YOZ0KH7bD16jBCpiF76giD
         bQlbxIWWl1/9MYHG9tGGdpcskkvG5PTDqsgEjOMOiLwq/mIlujcYy+LR93HXDQAchPcw
         wiPJvv5CDPBP+8s694b5Bs0wZoqPRMpAsw0UQfaK4qdKOXYSMspSdWHHRW7TJQviqKr+
         Q1iZp/0mlJE9XogmhxeeImelMw1fSO7HRYa5YI66AkUnNLsIdzy7MyYBKdX2U6wW1ZKC
         gWmTTyDKRscCKO6ELOjMSPqr/Tvil1COj0kss3oGdYrh3B49Z96MUMs0rbyWqdzmLFJg
         GT9A==
X-Gm-Message-State: AOAM532rRysNk9GhXpB9gCQnnjLDL/9R5x+pjQ4vaShJyiBko1k5WiUN
        j1LWayV539rqIJ2Ovpmp38Y=
X-Google-Smtp-Source: ABdhPJw5fJDnITTvgjuL1NAJKSK4gc4d1RYAkQ7nw/AjwjVz99aLStx0ZElhrmau4lJ+iSxFQEjLvg==
X-Received: by 2002:a17:902:6909:b029:d6:6ec4:e1f7 with SMTP id j9-20020a1709026909b02900d66ec4e1f7mr14716425plk.40.1604335830255;
        Mon, 02 Nov 2020 08:50:30 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:50:29 -0800 (PST)
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
Subject: [PATCH v4 01/29] scsi: megaraid_sas: Drop PCI wakeup calls from .resume
Date:   Mon,  2 Nov 2020 22:17:02 +0530
Message-Id: <20201102164730.324035-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
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
index 41cd66fc7d81..47ffdada541d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7668,7 +7668,6 @@ megasas_resume(struct pci_dev *pdev)
 
 	host = instance->host;
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	dev_info(&pdev->dev, "%s is called\n", __func__);
-- 
2.28.0

