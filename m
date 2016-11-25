From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 189061] New: Function snic_probe() does not set set code when
 the call to mempool_create_slab_pool() fails
Date: Fri, 25 Nov 2016 11:20:47 +0000
Message-ID: <bug-189061-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751497AbcKYLVA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 06:21:00 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 1C8BB20456
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:20:54 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 24644203E3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:20:48 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=189061

            Bug ID: 189061
           Summary: Function snic_probe() does not set set code when the
                    call to mempool_create_slab_pool() fails
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

In the function snic_probe() defined in file drivers/scsi/snic/snic_main.c,
when the call to mempool_create_slab_pool() (at line 589) returns a NULL
pointer, the control flow jumps to label "err_free_res", and returns variable
ret. Because variable ret is checked at line 714, the value of ret must be 0
here. As a result, function snic_probe() returns 0 (indicates success) even if
the call to mempool_create_slab_pool() fails.
There are other 2 similar bugs when the call to mempool_create_slab_pool() fail
at lines 599 and 609. Though these errors may occur rarely, I think it may be
better to set correct error codes (e.g. -ENOMEM) on failures. Codes related to
these bugs are summarised as follows.

snic_probe @@ drivers/scsi/snic/snic_main.c
 360 static int
 361 snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 362 {
         ...
 368     int ret, i;
         ...
 561     ret = snic_alloc_vnic_res(snic);
 562     if (ret) {
 563         SNIC_HOST_ERR(shost,
 564                   "Failed to alloc vNIC resources aborting. %d\n",
 565                   ret);
 566 
 567         goto err_clear_intr;
 568     }
         ...
         // Insert "ret = -ENOMEM;" ?
 589     pool = mempool_create_slab_pool(2,
 590                 snic_glob->req_cache[SNIC_REQ_CACHE_DFLT_SGL]);
 591     if (!pool) {
 592         SNIC_HOST_ERR(shost, "dflt sgl pool creation failed\n");
 593 
             // Bug (1): the value of ret is 0
 594         goto err_free_res;
 595     }
 596 
 597     snic->req_pool[SNIC_REQ_CACHE_DFLT_SGL] = pool;
 598 
 599     pool = mempool_create_slab_pool(2,
 600                 snic_glob->req_cache[SNIC_REQ_CACHE_MAX_SGL]);
 601     if (!pool) {
 602         SNIC_HOST_ERR(shost, "max sgl pool creation failed\n");
 603 
             // Bug (2): the value of ret is 0
 604         goto err_free_dflt_sgl_pool;
 605     }
 606 
 607     snic->req_pool[SNIC_REQ_CACHE_MAX_SGL] = pool;
 608 
 609     pool = mempool_create_slab_pool(2,
 610                 snic_glob->req_cache[SNIC_REQ_TM_CACHE]);
 611     if (!pool) {
 612         SNIC_HOST_ERR(shost, "snic tmreq info pool creation failed.\n");
 613 
             // Bug (3): the value of ret is 0
 614         goto err_free_max_sgl_pool;
 615     }
         ...
 701     return 0;
         ...
 733 err_free_max_sgl_pool:
 734     mempool_destroy(snic->req_pool[SNIC_REQ_CACHE_MAX_SGL]);
 735 
 736 err_free_dflt_sgl_pool:
 737     mempool_destroy(snic->req_pool[SNIC_REQ_CACHE_DFLT_SGL]);
 738 
 739 err_free_res:
 740     snic_free_vnic_res(snic);
 741 
 742 err_clear_intr:
 743     snic_clear_intr_mode(snic);
 744 
         ...
 772     return ret;
 773 } /* end of snic_probe */

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
