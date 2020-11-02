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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2861C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77A2122268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EInGRm6c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgKBQw0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbgKBQw0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:52:26 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54572C0617A6;
        Mon,  2 Nov 2020 08:52:26 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id j5so7098449plk.7;
        Mon, 02 Nov 2020 08:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=80Yi1XLQzKPeoqRYuchuEzVl/P6+59b0kyvSplkNuqw=;
        b=EInGRm6cBk43ZkBUefE+Lxc1nMZ8wuWhwjNtsLaYAjJkkpXaroUIq/Ir/9rRIReZTa
         TX9Syn6BVfq83IPRQ7ykGpcDSU2omjDUI3aFWdcpcTOE4zk4dSfSsjJxRXA/HxRfwRnq
         ItPVjw8aiAUDrYudk7Kq3o9fsSpGJ085X8SNop1TA56COWuz2G5PaKpEdELT/3brT2Re
         Z3KSEtx+XzcTXvGNXhcZFGfzpg1EJVAyhG85b4saGFxQuf05Tf97gMtSJAW5Cf0q6pit
         ImNpcFHlfvOWYNqWyTpk9PqZ2elCuC7uo5nkhF6uYvOiCQO/H1luHZ5Su0VVC1HGsZPR
         VbTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=80Yi1XLQzKPeoqRYuchuEzVl/P6+59b0kyvSplkNuqw=;
        b=KFjTtzvKL3ixdicJKOip7CvYadhzT7PDfJ/f1hEkc6Eqxjk4/U7ka66QJvF1hsrJOS
         bPFyy2+0nAONKUAmAOrgGNzhCZXPEbtXTuiQcI6q7Kdc0wU1bTrUXL43yZo94pBJIfQ2
         arcO1Y7/eN0TyAmL3DKbU7Twlvf8STLmTz3+zSjFEF04uV8qQLH/76yPOQPtWhFIgGXm
         8enbjNvLfXwUBMYV9+0a/27G5xs6MSiIRx1OQOOpEIL/ViAd5lQ2vNDHhYLcgMrbYrA/
         698UbugsxuMWh3L+cmDZlfj0GtDQXyPnjCCmbrJzkyFiN8ARafoVBvE5F0qNaLHs0PSo
         koMg==
X-Gm-Message-State: AOAM533UrePATMO4paMLeFP4dj1vrlrFCbP3Q3dm1Wq6bn6onF9hytjg
        T2mNkv19ZJ5Mk/PD93la8ow=
X-Google-Smtp-Source: ABdhPJwWscqt8CM6V8MAKcDq8ZXDB9lxb+Wc/XDRC0YTbVpR2R6o45JcQIqTodOCmknuT+Pb9bX4UA==
X-Received: by 2002:a17:902:bb81:b029:d5:b437:edb4 with SMTP id m1-20020a170902bb81b02900d5b437edb4mr21171215pls.6.1604335945887;
        Mon, 02 Nov 2020 08:52:25 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:52:25 -0800 (PST)
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
Subject: [PATCH v4 10/29] scsi: esas2r: Drop PCI Wakeup calls from .resume
Date:   Mon,  2 Nov 2020 22:17:11 +0530
Message-Id: <20201102164730.324035-11-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
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
index 09c5c24bf391..905a6c874789 100644
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

