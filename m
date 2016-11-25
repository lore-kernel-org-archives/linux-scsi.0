From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 189051] New: Function fnic_probe() does not set set code when
 the call to mempool_create_slab_pool() fails
Date: Fri, 25 Nov 2016 11:20:03 +0000
Message-ID: <bug-189051-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753100AbcKYLUP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 06:20:15 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 9E83A20453
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:20:09 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id CE13720172
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:20:03 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=189051

            Bug ID: 189051
           Summary: Function fnic_probe() does not set set code when the
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

In the function fnic_probe() defined in file drivers/scsi/fnic/fnic_main.c,
when the call to mempool_create_slab_pool() (at line 738) returns a NULL
pointer, the control flow jumps to label "err_out_free_resources", and returns
variable err. Because variable err is checked at line 714, the value of err
must be 0 here. As a result, function fnic_probe() returns 0 (indicates
success) even if the call to mempool_create_slab_pool() fails.
There are other 2 similar bugs when the call to mempool_create_slab_pool() fail
at lines 742 and 747. Though these errors may occur rarely, I think it may be
better to set correct error codes (e.g. -ENOMEM) on failures. Codes related to
these bugs are summarised as follows.

fnic_probe @@ drivers/scsi/fnic/fnic_main.c
 541 static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id
*ent)
 542 {
         ...
 547     int err;
         ...
 713     err = fnic_alloc_vnic_resources(fnic);
 714     if (err) {
 715         shost_printk(KERN_ERR, fnic->lport->host,
 716                  "Failed to alloc vNIC resources, "
 717                  "aborting.\n");
 718         goto err_out_clear_intr;
 719     }
         ...
         // Insert "err = -ENOMEM;" ?
 738     fnic->io_req_pool = mempool_create_slab_pool(2, fnic_io_req_cache);
 739     if (!fnic->io_req_pool)
             // Bug (1): the value of err is 0
 740         goto err_out_free_resources;
 741 
 742     pool = mempool_create_slab_pool(2,
fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
 743     if (!pool)
             // Bug (2): the value of err is 0
 744         goto err_out_free_ioreq_pool;
 745     fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT] = pool;
 746 
 747     pool = mempool_create_slab_pool(2,
fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
 748     if (!pool)
             // Bug (3): the value of err is 0
 749         goto err_out_free_dflt_pool;
         ...
 901     return 0;
         ...
 914 err_out_free_dflt_pool:
 915     mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT]);
 916 err_out_free_ioreq_pool:
 917     mempool_destroy(fnic->io_req_pool);
 918 err_out_free_resources:
 919     fnic_free_vnic_resources(fnic);
 920 err_out_clear_intr:
 921     fnic_clear_intr_mode(fnic);
 922 err_out_dev_close:
 923     vnic_dev_close(fnic->vdev);
 924 err_out_vnic_unregister:
 925     vnic_dev_unregister(fnic->vdev);
 926 err_out_iounmap:
 927     fnic_iounmap(fnic);
 928 err_out_release_regions:
 929     pci_release_regions(pdev);
 930 err_out_disable_device:
 931     pci_disable_device(pdev);
 932 err_out_free_hba:
 933     fnic_stats_debugfs_remove(fnic);
 934     scsi_host_put(lp->host);
 935 err_out:
 936     return err;
 937 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
