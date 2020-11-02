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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47479C388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0537622258
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:52:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IbZ0O0T8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgKBQwF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKBQwE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:52:04 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471A8C0617A6;
        Mon,  2 Nov 2020 08:52:04 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id h6so11288247pgk.4;
        Mon, 02 Nov 2020 08:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2BX3eBQ2Nj+GCCBpMWn5GHt7XwDnkItryaVyf4Y9S0I=;
        b=IbZ0O0T8ZLpruZWx8PvK7pIXyCIC+2LArAr7gf2hEf6irIdajXFoOuZJTcnie4tIyf
         G1oLhRlByJxT057wMLQPeiSB92kNy/zw0tEC2IfA6CbIdp6SUrV4wqfX8P6+8Cpf+M8a
         GFrY3lYf01PJbkFZzZ+BzK7IJTAFCKFn2pLszTcpRuUxeUTgD8ZPZIPNZdiqT16U0CNs
         CRvJFySq8CxeR1BOep9PQjpP6lR3EDeAdABou7VZBITnUMR3mov86UKVWsuKRT+g7sB9
         zXfDZNKgTsb6qXDtavgABdOmqU8ZEYoYP13Iq49TK5NIzr090H/NHAFkHUtljj6QeawQ
         yz4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2BX3eBQ2Nj+GCCBpMWn5GHt7XwDnkItryaVyf4Y9S0I=;
        b=augjeg4vwXr6owyf3qgiRQ6E/lQ/eRFrpXiG4ET1weSEuOB9Rs4MV7jDwpvbKxdPeH
         YApT6z4avuRh6XAUki6s58aZmp8KTHHMjdRuc07psyH+o5KuDt/Mv01jIm7/vTcNim0E
         YSyzEF52WiHWrfWYg1DiBW6gQrdrxjyhjnZQPIaZO+KqLR8Z5LWMwwkLQIZ9Veucojn9
         Wz4N4yNZVIl/6jgZt0fWlMM3cbyS/qF+gMlKOQL6a5lAk5ehtUsP/qRDaw8B9N83J4yI
         F1Xs+CRCVEoLe2Owxc6gOO2FSP+nLchmX+i6T6/+KM6d+RDFQiSCaYUiuStrRILLhXw/
         kWGQ==
X-Gm-Message-State: AOAM532tRFi40NV2GSJkasyI2Yz1UW4weKreWWU/GLLcBo34DQx+TaOr
        zSxyEYXa2RbUFUZBXIbaR1U=
X-Google-Smtp-Source: ABdhPJxxJSxyNACwkohZCylYPgk39LsF1tv3WZke7YS3us4tYJaRefkbEB8qZs0YOFgVDEY57hwVew==
X-Received: by 2002:a17:90b:11cc:: with SMTP id gv12mr4371225pjb.132.1604335923821;
        Mon, 02 Nov 2020 08:52:03 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:52:03 -0800 (PST)
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
Subject: [PATCH v4 08/29] scsi: arcmsr: Drop PCI wakeup calls from .resume
Date:   Mon,  2 Nov 2020 22:17:09 +0530
Message-Id: <20201102164730.324035-9-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in arcmsr_resume(), and
there is no corresponding pci_enable_wake(...., true) in arcmsr_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
arcmsr_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index e4fdb473b990..c7ba4cbd197b 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1154,7 +1154,6 @@ static int arcmsr_resume(struct pci_dev *pdev)
 		(struct AdapterControlBlock *)host->hostdata;
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 	if (pci_enable_device(pdev)) {
 		pr_warn("%s: pci_enable_device error\n", __func__);
-- 
2.28.0

