From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 189001] New: Function twl_probe() does not set error codes on
 some failures
Date: Fri, 25 Nov 2016 11:16:16 +0000
Message-ID: <bug-189001-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbcKYLQ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 06:16:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 9D7EB20172
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:16:23 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id C02B72045B
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:16:16 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=189001

            Bug ID: 189001
           Summary: Function twl_probe() does not set error codes on some
                    failures
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: linux-4.9-rc6
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

In function twl_probe() defined in file drivers/scsi/3w-sas.c, because variable
retval is checked at line 1608, its value must be 0 when pci_iomap() is called
(at line 1614). If pci_iomap() returns a NULL pointer, the control flow jumps
to label "out_release_mem_region", cleans and returns the value of retval (i.e.
0). As a result, function twl_probe() returns 0 (indicates success) even if
there are errors. The behavior of its caller may be misled.
There are other 2 similar bugs when the function calls fail at lines 1601 and
1624. Though these errors may occur rarely, I think it is better to set the
correct error codes on failures. Codes are summarised as follows.

twl_probe @@ drivers/scsi/3w-sas.c
1564 static int twl_probe(struct pci_dev *pdev, const struct pci_device_id
*dev_id)
1565 {
1566     struct Scsi_Host *host = NULL;
1567     TW_Device_Extension *tw_dev;
1568     int retval = -ENODEV;
1569     int *ptr_phycount, phycount=0;
1570 
1571     retval = pci_enable_device(pdev);
1572     if (retval) {
1573         TW_PRINTK(host, TW_DRIVER, 0x17, "Failed to enable pci device");
1574         goto out_disable_device;
1575     }
         ...
1601     if (twl_initialize_device_extension(tw_dev)) {
1602         TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Failed to initialize
device extension");
             // Bug (1): retval takes value 0. Insert "retval = -ENODEV;"?
1603         goto out_free_device_extension;
1604     }
1605 
1606     /* Request IO regions */
1607     retval = pci_request_regions(pdev, "3w-sas");
1608     if (retval) {
1609         TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1b, "Failed to get mem
region");
1610         goto out_free_device_extension;
1611     }
1612 
1613     /* Save base address, use region 1 */
1614     tw_dev->base_addr = pci_iomap(pdev, 1, 0);
1615     if (!tw_dev->base_addr) {
1616         TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to ioremap");
             // Bug (2): retval takes value 0. Insert "retval = -ENOMEM;"?
1617         goto out_release_mem_region;
1618     }
1619 
1620     /* Disable interrupts on the card */
1621     TWL_MASK_INTERRUPTS(tw_dev);
1622 
1623     /* Initialize the card */
1624     if (twl_reset_sequence(tw_dev, 0)) {
1625         TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1d, "Controller reset failed
during probe");
             // Bug (3): retval takes value 0. Insert "retval = -ENODEV;"?
1626         goto out_iounmap;
1627     }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
