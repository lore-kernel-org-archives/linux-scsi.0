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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599ECC00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1532322258
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7V5ebDK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgKBQxx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbgKBQxw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:53:52 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7FEC0617A6;
        Mon,  2 Nov 2020 08:53:52 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id x13so11599551pfa.9;
        Mon, 02 Nov 2020 08:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6rD2BjZVXaWq6x/ciVXhavn4M1TtA7njBLCCq/6xvNk=;
        b=b7V5ebDKKXGuZHoL4SHs/xhU9TSjdnCtAK37F+LCrKoSIqMXn5CcNy6Q7UT6JXy5DQ
         FUwcS5u4UIEyEmtTB+fdZZ/Bn7qPuDQDD3GZPwCrJ3x0nb5OlkVEustCFKdd5zAEktLk
         OAwlU8y8Agp+4CSx30btenvFNwz50WL63UtlPVo29WPutJSRSMPbz9fm0pwBSkvADWzq
         xgvDFX9h8N5QCdSVpJt9yc82mMVjp6GWSoiIjAcHYK8WFXoAC8gsBvslTruCDf7LfBas
         5PCT5R2awaZbMHlmbLEQLiqBn1Q/1k9+Sdkkdy1pobcJzsFulLI+TpB9iQbIlL76eD5f
         AYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6rD2BjZVXaWq6x/ciVXhavn4M1TtA7njBLCCq/6xvNk=;
        b=aBdXmiOPDUjdxttjgwsBrsEe99+abUBNyF82r+iiA0jFgshzDfa3UAhCwt9bcRwB49
         lZ0tPgJlon9p+tTkDyjk2vCQCIbJyrgw1ONQ34YHYcmajjJV1/AbkNR/VI04h8oQshE6
         GGs0B2T8IhusxY3jRWxhkLxxrCQ3Sm3MtllWHb+MURubGxUpzrAyM17gxT2OpRrUbAVJ
         wZZvG/z2B/A0JYAi1CrWYji3Vok4AC44rbtprDBVtGJ0+5Gr6GiGECp4ZXpQ9+w68EVt
         E7I9HDBLk0nIGAgrA6Id5HhOh2Y7q52APoCUOj7mbV+3rFBb/+99S+Yif5XX69YqZIo6
         RybQ==
X-Gm-Message-State: AOAM533VAUE9KzAskzDYutVNr0PeBlvCoOMwWqSTP5rWRpHAaX7tk1LB
        l+MPuY4kVpJgoSZaqPeTRxk=
X-Google-Smtp-Source: ABdhPJwsP+UyDRDmxoRtGAw+s8a66u11cnaGSNVCpQZuTJmTiL6Ebr0tI4XDNJ+fnuEGBgA7g0EPwQ==
X-Received: by 2002:a17:90a:a4c6:: with SMTP id l6mr7360518pjw.91.1604336032479;
        Mon, 02 Nov 2020 08:53:52 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:53:52 -0800 (PST)
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
Subject: [PATCH v4 18/29] scsi: pm_8001: Drop PCI Wakeup calls from .resume
Date:   Mon,  2 Nov 2020 22:17:19 +0530
Message-Id: <20201102164730.324035-19-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in pm8001_pci_resume(), and
there is no corresponding pci_enable_wake(...., true) in
pm8001_pci_suspend(). Either it should do enable-wake the device in
.suspend() or should not invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
pm8001_pci__resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3cf3e58b6979..d47ed9a33173 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1327,7 +1327,6 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 		"operating state [D%d]\n", pdev, pm8001_ha->name, device_state);
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 	rc = pci_enable_device(pdev);
 	if (rc) {
-- 
2.28.0

