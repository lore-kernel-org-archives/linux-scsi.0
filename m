From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76681] Adaptec 7805H SAS HBA (pm80xx) cannot survive ACPI S3 or
 ACPI S4
Date: Thu, 22 May 2014 08:13:36 +0000
Message-ID: <bug-76681-11613-G01XvVomfU@https.bugzilla.kernel.org/>
References: <bug-76681-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50062 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaEVINk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2014 04:13:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D10FF201E4
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2014 08:13:39 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1EB322026C
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2014 08:13:37 +0000 (UTC)
In-Reply-To: <bug-76681-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=76681

Jack Wang <xjtuwjp@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xjtuwjp@gmail.com

--- Comment #1 from Jack Wang <xjtuwjp@gmail.com> ---
Sorry, I don't have hardware to test, could you try patch below:
diff --git a/drivers/scsi/pm8001/pm8001_init.c
b/drivers/scsi/pm8001/pm8001_init.c
index f7c1896..083a030 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -916,6 +916,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev,
pm_message_t state)
        int i;
        u32 device_state;
        pm8001_ha = sha->lldd_ha;
+       sas_suspend_ha(sha);
        flush_workqueue(pm8001_wq);
        scsi_block_requests(pm8001_ha->shost);
        if (!pdev->pm_cap) {
@@ -980,7 +981,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
        rc = pci_go_44(pdev);
        if (rc)
                goto err_out_disable;
-
+       sas_prep_resume_ha(sha);
        /* chip soft rst only for spc */
        if (pm8001_ha->chip_id == chip_8001) {
                PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
@@ -1009,6 +1010,9 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
                        PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
        }
        scsi_unblock_requests(pm8001_ha->shost);
+       pm8001_scan_start(pm8001_ha->shost);
+       msleep(100);
+       sas_resume_ha(sha);
        return 0;

 err_out_disable:

Jack

-- 
You are receiving this mail because:
You are the assignee for the bug.
