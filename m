From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188851] New: Function twa_probe() does not set error codes on
 failures
Date: Fri, 25 Nov 2016 11:03:38 +0000
Message-ID: <bug-188851-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750801AbcKYLDw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 06:03:52 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 5AEF020386
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:03:46 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id D843E20453
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:03:38 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188851

            Bug ID: 188851
           Summary: Function twa_probe() does not set error codes on
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

In function twa_probe(), variable retval takes the error code. However, the
error code is not set on some failures. I am not sure whether it is the
intention of the author. I list 3 positions that seems anomalous. (1) error
code "-ENODEV" is not assigned to retval when the call to
twa_initialize_device_extension() (at line 2041) fails; (2) error code
"-ENOMEM" is not assigned to retval when the call to ioremap() (at line 2062)
fails; (3) error code "-ENODEV" is not assigned to retval when the call to
twa_reset_sequence() (at line 2072) fails. Codes related to these bugs are
summarised as follows.

twa_probe @@ drivers/scsi/3w-9xxx.c
2003 /* This function will probe and initialize a card */
2004 static int twa_probe(struct pci_dev *pdev, const struct pci_device_id
*dev_id)
2005 {
2006     struct Scsi_Host *host = NULL;
2007     TW_Device_Extension *tw_dev;
2008     unsigned long mem_addr, mem_len;
2009     int retval = -ENODEV;
2010 
2011     retval = pci_enable_device(pdev);
2012     if (retval) {
2013         TW_PRINTK(host, TW_DRIVER, 0x34, "Failed to enable pci device");
2014         goto out_disable_device;
2015     }
         ...
2041     if (twa_initialize_device_extension(tw_dev)) {
2042         TW_PRINTK(tw_dev->host, TW_DRIVER, 0x25, "Failed to initialize
device extension");
             // (1) The value of retval is 0. Insert "retval = -ENODEV;" here?
2043         goto out_free_device_extension;
2044     }
2045 
2046     /* Request IO regions */
2047     retval = pci_request_regions(pdev, "3w-9xxx");
2048     if (retval) {
2049         TW_PRINTK(tw_dev->host, TW_DRIVER, 0x26, "Failed to get mem
region");
2050         goto out_free_device_extension;
2051     }
         ...
2062     tw_dev->base_addr = ioremap(mem_addr, mem_len);
2063     if (!tw_dev->base_addr) {
2064         TW_PRINTK(tw_dev->host, TW_DRIVER, 0x35, "Failed to ioremap");
             // (2) The value of retval is 0. Insert "retval = -ENOMEM;" here?
2065         goto out_release_mem_region;
2066     }
2067 
2068     /* Disable interrupts on the card */
2069     TW_DISABLE_INTERRUPTS(tw_dev);
2070 
2071     /* Initialize the card */
2072     if (twa_reset_sequence(tw_dev, 0))
             // (3) The value of retval is 0. Insert "retval = -ENODEV;" here?
2073         goto out_iounmap;
         ...
2133     return 0;
2134 
2135 out_remove_host:
2136     if (test_bit(TW_USING_MSI, &tw_dev->flags))
2137         pci_disable_msi(pdev);
2138     scsi_remove_host(host);
2139 out_iounmap:
2140     iounmap(tw_dev->base_addr);
2141 out_release_mem_region:
2142     pci_release_regions(pdev);
2143 out_free_device_extension:
2144     twa_free_device_extension(tw_dev);
2145     scsi_host_put(host);
2146 out_disable_device:
2147     pci_disable_device(pdev);
2148 
2149     return retval;
2150 } /* End twa_probe() */

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
