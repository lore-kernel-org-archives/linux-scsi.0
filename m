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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8248C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A191F22268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kl55ZSfn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgKBQxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgKBQxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:53:20 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB30C0617A6;
        Mon,  2 Nov 2020 08:53:19 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id x13so11597992pfa.9;
        Mon, 02 Nov 2020 08:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SOLD0sLwTuY4TfChHkgrK5w3Qn4ds7uACuE/j2qv8aY=;
        b=Kl55ZSfnA/Mn6mRPbWGTEkVUeJVome2iCB4Xfr9T7sFbx+NyK9JIXu+IgS5Nd9JzVu
         VIIWniztcf0DJVP/1CQMsGvr4EqGMnwwNEGK/M2b7Gl0TfcJcryeDVWLN/iYumoIrO43
         ADHSpvqZXrzcigImQPZNzVq6jtJj/CAOky00a8lUaOYngj4zbATM9922FCGv563HpKp2
         420zs+mB01xfIaGLNNvJXAoLvO000Crd4uVftw97qkXpTpnQTlw6XJH+L3qEp1Vzeduy
         e1Y0xnM94DQx2YHOQ0SugTcrZcuPHU0jJ/3B6iTbhTxv0Q4cGUnh5ZUD77kF7eTV6KKt
         V0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SOLD0sLwTuY4TfChHkgrK5w3Qn4ds7uACuE/j2qv8aY=;
        b=b09xyGseVAenFqiXgspXQ+KB0SO/IvfN6CR2QVBjrGyeoJhUS3HD1pPeHXf5mT7vbY
         4tKyUzj0+tg5yMfkDFg9JFk3x/GKf2lwKcaMY3k+cacHq1oHgyqj+l84UvzdAJaeHiuT
         3MKRuud0w1sZkcDbdFSuiddq/AsVq9Ci2qrAKe80kwq9HgeNokopQvsgTg9hhpiSJ3+n
         Iftidd6DMTD5Pc/kImElE1W/gF68vwjriCKinciecRZnMbdgpzexPe9BEeKaKbdboquF
         YAOlSK/S0PLTeY7J573orZPsCz3ZCItcaGgUeknOrxsRsPqzR+7AXy7a2nWKg/UQaQ/+
         9PRA==
X-Gm-Message-State: AOAM5333f5sUQ3gWj37TvgZZdMxZSZhOei+nNaA+osuXXaDMkeXAYrD/
        IqTXvUAcRw/sEzYf6gkt3zg=
X-Google-Smtp-Source: ABdhPJy9xYff9LIPIsDObGt8ERWBvTi6YfmYoCnJqKilM2cZDKSwDGQcnLftGSiW4932taWJnp+wKQ==
X-Received: by 2002:a65:5c4c:: with SMTP id v12mr14283773pgr.119.1604335999411;
        Mon, 02 Nov 2020 08:53:19 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:53:18 -0800 (PST)
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
Subject: [PATCH v4 15/29] scsi: mpt3sas_scsih: Drop PCI Wakeup calls from .resume
Date:   Mon,  2 Nov 2020 22:17:16 +0530
Message-Id: <20201102164730.324035-16-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in scsih_resume(), and
there is no corresponding pci_enable_wake(...., true) in scsih_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
scsih_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5f845d7094fc..2d201558b8fb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11140,7 +11140,6 @@ scsih_resume(struct pci_dev *pdev)
 		 pdev, pci_name(pdev), device_state);
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 	ioc->pdev = pdev;
 	r = mpt3sas_base_map_resources(ioc);
-- 
2.28.0

