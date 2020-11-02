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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBFBC4742C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B093C22258
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4lK7B2j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgKBQxA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbgKBQw7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:52:59 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0F0C0617A6;
        Mon,  2 Nov 2020 08:52:58 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id y14so11587475pfp.13;
        Mon, 02 Nov 2020 08:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MBzsuEUa6bYvsV+CNnIl+xHeK3YoENUVJTW96RlBScM=;
        b=i4lK7B2jCeWUWs/7k7aRJe2mVzCOREf/YaZphfdcnGM0u+NoaCHXT1UMtxiid1cPRk
         z+BPB3zIpcTUGy7gNJ+vQ+mf6T/j71u4xbBtkOpJFr0pkC7C9qKw3p0Q/5/01HSApBta
         Ou3O6JCnnfnkLTA7bAPGiA4KrhBxm/8fKADenbdF1J4iCL0+VyOS918WGeSy6jnLmizw
         gqP9jIo7nYYWjov+spMoRffy2As9Y9GUzTL5aQWpXYLgfZia0BjMUJBE8J1Or8gBFVVo
         F016wRV7uUCivQ4adKG5hAUXH+lhQwfZSg1Wfk102HFPrtIRVcxXRArRP+VFGN2ZB9nO
         alSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MBzsuEUa6bYvsV+CNnIl+xHeK3YoENUVJTW96RlBScM=;
        b=bipUM18rmPTrQX97TuRcxqTJVVlM3ldiB9OtaHS2o66vKrGS9Gm0qNr7LH0etVY5K5
         SPjAhwU8y4YAEKTrGIc96hhlD4hA/+/zzhnJYQimMAJZc3vl8cY0+nnzgp2f1rAV8Amn
         QqfXMscTePQB0l7f23qk7HcFiwaj9sxiOwpXKnO0LAQEu1mLQcHLKrUq25kaXFGsh6R/
         DnZU3z4GJz+9TxmUPmb7r4v2n31q411FWXaFzXTWCQevktnf9uetU1nKAzY6hs++aiIX
         y786XCihAkW7t97meEikuYhSoGoP2sFVJO7z2VTToyLphNzEUMXV3cmRgNR3uLgLUAyk
         bzHQ==
X-Gm-Message-State: AOAM532uqq4HWH+zqVXLAPOQvw1n6kCiZDVgeUsiIjyLvSG3hJeo0AMj
        quQgZnHzDdUocDL4wgVexnk=
X-Google-Smtp-Source: ABdhPJxiIXDXayIA4x2vypTJ5B2naXIVlq1IYCXlgXG2jWp3RJ2Zwiiq5D86qMZ/Pko1ZcPv4K6N1w==
X-Received: by 2002:a17:90a:3e4a:: with SMTP id t10mr18207881pjm.151.1604335977846;
        Mon, 02 Nov 2020 08:52:57 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:52:57 -0800 (PST)
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
Subject: [PATCH v4 13/29] scsi: hisi_sas_v3_hw: Don't use PCI helper functions
Date:   Mon,  2 Nov 2020 22:17:14 +0530
Message-Id: <20201102164730.324035-14-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers using new-framework/generic-framework should not handle standard
power management operations. These operations were performed by legacy
framework through PCI helper functions like pci_save/restore_state(),
pci_set_power_state(), etc.

Drivers should not use them now.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f19f3db1ac6d..dfeb86c865d3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3440,7 +3440,6 @@ static int _suspend_v3_hw(struct device *device)
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct device *dev = hisi_hba->dev;
 	struct Scsi_Host *shost = hisi_hba->shost;
-	pci_power_t device_state;
 	int rc;
 
 	if (!pdev->pm_cap) {
@@ -3466,12 +3465,7 @@ static int _suspend_v3_hw(struct device *device)
 
 	hisi_sas_init_mem(hisi_hba);
 
-	device_state = pci_choose_state(pdev, PMSG_SUSPEND);
-	dev_warn(dev, "entering operating state [D%d]\n",
-			device_state);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, device_state);
+	dev_warn(dev, "entering suspend state\n");
 
 	hisi_sas_release_tasks(hisi_hba);
 
@@ -3491,15 +3485,7 @@ static int _resume_v3_hw(struct device *device)
 
 	dev_warn(dev, "resuming from operating state [D%d]\n",
 		 device_state);
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	rc = pci_enable_device(pdev);
-	if (rc) {
-		dev_err(dev, "enable device failed during resume (%d)\n", rc);
-		return rc;
-	}
 
-	pci_set_master(pdev);
 	scsi_unblock_requests(shost);
 	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 
@@ -3507,7 +3493,6 @@ static int _resume_v3_hw(struct device *device)
 	rc = hw_init_v3_hw(hisi_hba);
 	if (rc) {
 		scsi_remove_host(shost);
-		pci_disable_device(pdev);
 		return rc;
 	}
 	hisi_hba->hw->phys_init(hisi_hba);
-- 
2.28.0

