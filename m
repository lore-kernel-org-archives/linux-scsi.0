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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461F2C388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBC77222BA
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:55:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="byawQ/SZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgKBQzd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbgKBQzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:55:33 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9B0C0617A6;
        Mon,  2 Nov 2020 08:55:33 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 10so11618333pfp.5;
        Mon, 02 Nov 2020 08:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fW/BfkSigqeA/7sHlInXZcmolxISxSAGZHTmLq9vq7w=;
        b=byawQ/SZbG7wwZwJ/BWULutg85ygIZfRKdeXa6SDhyrH+Rigyw6EMt2sR1MiBbdTHo
         M1mHBCdM3y2DRE3nwIa0HJ5k9WC0RrQrjWynbAxYIaDORDdrqukMS2WUewpCne1LJXYW
         BP9li66eIdwTbKooMZc37vvk78qDwS6ARQJQ40bwL8JbiOZpr3L3H9JFwnhEbKs8bYYr
         e1Jkp1hoefRoRYxYTlxlvW5g3nfMnlKn0RQzuPdS5E04KMkj2nsjb7E6s3+hmDMw/rBF
         ale7UeErtqRDabJT2q8yjGBLjBtYgxYA1bRnU+8UJus5+SNjPOrGz8Yh9NnvSOXLkPm8
         vhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fW/BfkSigqeA/7sHlInXZcmolxISxSAGZHTmLq9vq7w=;
        b=MzkzJ2/gIxgofl9dMAo0go0xUkHT4i5hS/xf7LdHsY5kB1dUlkc+M0QwbCE0bqj95m
         UTWdDAiZxlgqFGKyArvZeVFAKzsiaA4h1vrl1t150z4vlOBcTX6EsK5E6wR4qGI+tdn+
         zDaDQEvUv/3gxVbJHfBgwB6T/USe3hIi3FOdTq5pQEX6ZQFYFiwh3mcEwXlBbet/PnaV
         fGqo7QMolnwylwKRAAwWDyYOHzPSnAdvjEBH1q2r5FWa12H2XK1rmJqhjYDHT8b8XspG
         OnztcWQ3Cmi0bMZ0uJD+1ELB2Xxe/wud3W2cTMDiBK2aiEwU2Kv5eiA8BHf/jXUfTjbe
         GBQw==
X-Gm-Message-State: AOAM531Q7aQaKH8/ZpLUxNWjO9O9HADp4alq461FnzGVeV0p56W/GMJO
        5u/79dUw6kT5cVh06S2zLwY=
X-Google-Smtp-Source: ABdhPJyhJXUnKsKoEx0UezB9HVKpp590ogdrqyESHRkls/XQE7Dx1XdbSnVjSMeH5dlNWJM1qUpfVw==
X-Received: by 2002:a63:221d:: with SMTP id i29mr5230679pgi.69.1604336132873;
        Mon, 02 Nov 2020 08:55:32 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:55:32 -0800 (PST)
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
Subject: [PATCH v4 28/29] scsi: pmcraid: Drop PCI Wakeup calls from .resume
Date:   Mon,  2 Nov 2020 22:17:29 +0530
Message-Id: <20201102164730.324035-29-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in pmcraid_resume(), and
there is no corresponding pci_enable_wake(...., true) in pmcraid_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
pmcraid_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/pmcraid.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index cbe5fab793eb..5c767cd8ffc3 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5271,7 +5271,6 @@ static int pmcraid_resume(struct pci_dev *pdev)
 	int rc;
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	rc = pci_enable_device(pdev);
-- 
2.28.0

