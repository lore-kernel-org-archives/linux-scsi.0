From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106261] New: there exists a wrong return value of function
 asd_map_memio() when ioremap_nocache() fails
Date: Mon, 19 Oct 2015 14:23:27 +0000
Message-ID: <bug-106261-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41410 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbbJSOXa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 10:23:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8CCB820789
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2015 14:23:29 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0E37720430
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2015 14:23:28 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=106261

            Bug ID: 106261
           Summary: there exists a wrong return value of function
                    asd_map_memio() when ioremap_nocache() fails
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AIC94XX
          Assignee: scsi_drivers-aic94xx@kernel-bugs.osdl.org
          Reporter: rucsoftsec@gmail.com
        Regression: No

In function asd_map_memio() at drivers/scsi/aic94xx/aic94xx_init.c:80, the call
to ioremap() in line 104 and ioremap_nocache in line 107 may fail, and thus
function asd_map_memio() will return the value of variable 'err'. And, the
function asd_map_memio() will return 0 at last when it runs well. However, when
the call to pci_request_region() in line 97 succeeds, the value of 'err' is 0.
So the function asd_map_memio() will return 0 to its caller functions when it
runs error because of the failing call to ioremap() or ioremap_nocache(),
leading to a wrong return value in function asd_map_memio().
The related code snippets in asd_map_memio are as following.
asd_map_memio @@drivers/scsi/aic94xx/aic94xx_init.c:80
80 static int asd_map_memio(struct asd_ha_struct *asd_ha)
 81 {
            ......
 97                 err = pci_request_region(asd_ha->pcidev, i,
ASD_DRIVER_NAME);
 98                 if (err) {
 99                         asd_printk("couldn't reserve memory region for
%s\n",
100                                    pci_name(asd_ha->pcidev));
101                         goto Err;
102                 }
103                 if (io_handle->flags & IORESOURCE_CACHEABLE)
104                         io_handle->addr = ioremap(io_handle->start,
105                                                   io_handle->len);
106                 else
107                         io_handle->addr = ioremap_nocache(io_handle->start,
108                                                           io_handle->len);
109                 if (!io_handle->addr) {
110                         asd_printk("couldn't map MBAR%d of %s\n", i==0?0:1,
111                                    pci_name(asd_ha->pcidev));
112                         goto Err_unreq;
113                 }
114         }
115 
116         return 0;
117 Err_unreq:
118         pci_release_region(asd_ha->pcidev, i);
119 Err:
120         if (i > 0) {
121                 io_handle = &asd_ha->io_handle[0];
122                 iounmap(io_handle->addr);
123                 pci_release_region(asd_ha->pcidev, 0);
124         }
125         return err;
126 }


Generally, the return value of caller functions which call function
ioremap_nocache() shall be set to a negative number when the call to
ioremap_nocache() fails, like the following codes in another file.
pmc_setup_dev @@arch/x86/kernel/pmc_atom.c:296
296 static int pmc_setup_dev(struct pci_dev *pdev)
297 {
            ......
312         pmc->regmap = ioremap_nocache(pmc->base_addr, PMC_MMIO_REG_LEN);
313         if (!pmc->regmap) {
314                 dev_err(&pdev->dev, "error: ioremap failed\n");
315                 return -ENOMEM;
316         }
            ......
327 }

Thank you

RUC_Soft_Sec

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
