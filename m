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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2170CC4742C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5B8722277
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:50:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FWH9UY/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgKBQux (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727300AbgKBQuv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:50:51 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA25C0617A6;
        Mon,  2 Nov 2020 08:50:51 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id r10so7110864plx.3;
        Mon, 02 Nov 2020 08:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6vxmT3Q80RGrzEju3iFEpX/Dlj35TxSTYI0m/9BGYRs=;
        b=FWH9UY/wDTqHTqNDW/pn8h2yIfmsgHS21dYTh1aHdf8cUOHfnUFegf8yn4WRjjWGaH
         joAdmrRXOGEPJub/iSdpNMLi3lokD5WjHwC7k6ubgycdjzBFcw0+CbbaxCMVPRI6n8ML
         CY5AE4/7irrONltr1KZNZUnHRB3XLAjcDnAHaEtizk/QyoQZLPhexwozPopzFdSnocqR
         nlkTnvEIyEbP/sJTUBWxMiVnt1vA2HAc860zNARXrW0dlskPnVvCA/UJxJb0gd36o6pf
         YIJbquACBnknKIgAWfALmem9Up0DMD7OBWOCKDhEByXNdWHQ6L1SYiIhbwatDrEychsg
         SJ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6vxmT3Q80RGrzEju3iFEpX/Dlj35TxSTYI0m/9BGYRs=;
        b=rRDxakJdEpKP4b/PSXa78G3xWMNOqBwqx78tNPKP56XNiBf/qE+81Dcz3aSqqRi3oM
         /h+YOz87c7UjviH4O2KHEhFlT3k4Gz/SobPEDRRncEn6jgLpP0qmr2Zf67cYQeSrdOU7
         NgDXrYcU4t0GggJ8ewYvNI45k2ZeELJD4bJJVbFsaW9w1vdr9ktS5aXRCIWf6LphOkCJ
         TQoBsCBEmU3rTZ4J/aR+ffWNO+38wKS5BL18pCal31ejNyi9HcAGdd0ZrUr2I18db7JZ
         mAJ0/yXcjwKTtwV1P9wi3yUZuJ1VDsfA5SeNqrzy20cW7rmC9ei0QFN36r0+eiXROKt7
         KYug==
X-Gm-Message-State: AOAM531m7GNdm6dD0FZ3lezBzMKwCPracN8UJk1QH/6aJelGnQprJV2U
        2C0oTZIuUIh6j+uJcLm0aiw=
X-Google-Smtp-Source: ABdhPJz92w4o9HyAGBIzrllFPmwzHVzYzCAtkRWAXWpfppLSfftceomQcU1lQHfBjVjZXUoUlHfUJA==
X-Received: by 2002:a17:902:8504:b029:d6:7552:19ab with SMTP id bj4-20020a1709028504b02900d6755219abmr22151785plb.83.1604335850971;
        Mon, 02 Nov 2020 08:50:50 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:50:50 -0800 (PST)
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
Subject: [PATCH v4 03/29] scsi: megaraid_sas: update function description
Date:   Mon,  2 Nov 2020 22:17:04 +0530
Message-Id: <20201102164730.324035-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Function parameter 'pdev 'is described as Generic Device Structure. It is
a PCI device structure.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index bd330ea4063a..7384c8e9149d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7958,7 +7958,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 /**
  * megasas_shutdown -	Shutdown entry point
- * @pdev:		Generic device structure
+ * @pdev:		PCI device structure
  */
 static void megasas_shutdown(struct pci_dev *pdev)
 {
-- 
2.28.0

