From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195489] New: esas2r: unchecked return value of
 pci_enable_device() in function esas2r_resume()
Date: Sat, 22 Apr 2017 14:38:51 +0000
Message-ID: <bug-195489-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44574 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1424480AbdDVOi6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Apr 2017 10:38:58 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 56F7F28174
        for <linux-scsi@vger.kernel.org>; Sat, 22 Apr 2017 14:38:57 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195489

            Bug ID: 195489
           Summary: esas2r: unchecked return value of pci_enable_device()
                    in function esas2r_resume()
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: linux-4.11-rc7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: bianpan2010@ruc.edu.cn
        Regression: No

In file drivers/scsi/esas2r/esas2r_init.c, function esas2r_resume() calls the
function pci_enable_device() (at line 730), but forget to detect its return
value. The function pci_enable_device() will return a negative value on errors.
The return value should be validated before continuing. The related code
snippet is shown as follows.

esas2r_resume @@ drivers/scsi/esas2r/esas2r_init.c: 710
 710 int esas2r_resume(struct pci_dev *pdev)
 711 {
 712     struct Scsi_Host *host = pci_get_drvdata(pdev);
         ...
 730     rez = pci_enable_device(pdev);
 731     pci_set_master(pdev);
 732 
 733     if (!a) {
 734         rez = -ENODEV;
 735         goto error_exit;
 736     }
         ...
 774 error_exit:
 775     esas2r_log_dev(ESAS2R_LOG_CRIT, &(pdev->dev), "esas2r_resume(): %d",
 776                rez);
 777     return rez;
 778 }

Generally, the function pci_enable_device() is called in the following way.
ide_pci_resume @@ drivers/ide/setup-pci.c: 645
645 int ide_pci_resume(struct pci_dev *dev)
646 {
647     struct ide_host *host = pci_get_drvdata(dev);
648     int rc;
649 
650     pci_set_power_state(dev, PCI_D0);
651 
652     rc = pci_enable_device(dev);
653     if (rc)
654         return rc;
655 
656     pci_restore_state(dev);
657     pci_set_master(dev);
658 
659     if (host->init_chipset)
660         host->init_chipset(dev);
661 
662     return 0;
663 }

Thanks for your attention!

Pan Bian

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
