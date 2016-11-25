From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188961] New: Function mvs_task_prep() returns improper values
 on failures
Date: Fri, 25 Nov 2016 11:12:35 +0000
Message-ID: <bug-188961-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbcKYLTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 06:19:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 7EF9A20456
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:12:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id F198E20172
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:12:35 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188961

            Bug ID: 188961
           Summary: Function mvs_task_prep() returns improper values on
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

The function mvs_task_prep() defined in file drivers/scsi/mvsas/mv_sas.c
returns 0 on success, or non-zero values on failures. It calls function
pci_pool_alloc() and checks its return value against NULL (at line 794), and if
the return value is NULL, the control flow jumps to label "err_out_tag", cleans
allocated memory and returns variable rc. Function pci_pool_alloc() is called
after the check of variable rc, so the value of rc must be 0. As a result,
mvs_task_prep() will return 0 (indicates success) even the call to
pci_pool_alloc() fails. I think it is better to assign "-ENOMEM" to rc when
pci_pool_alloc() fails. Codes and comments related to this bug are summarised
as follows.

mvs_task_prep @@ drivers/scsi/mvsas/mv_sas.c
 711 static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int
is_tmf,
 712                 struct mvs_tmf_task *tmf, int *pass)
 713 {
         ...
 719     int rc = 0;
         ...
 783     rc = mvs_tag_alloc(mvi, &tag);
 784     if (rc)
 785         goto err_out;
 786 
 787     slot = &mvi->slot_info[tag];
 788 
 789     task->lldd_task = NULL;
 790     slot->n_elem = n_elem;
 791     slot->slot_tag = tag;
 792 
 793     slot->buf = pci_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
 794     if (!slot->buf)
             // insert "rc = -ENOMEM" here?
 795         goto err_out_tag;
         ...
 838     return rc;
 839 
 840 err_out_slot_buf:
 841     pci_pool_free(mvi->dma_pool, slot->buf, slot->buf_dma);
 842 err_out_tag:
 843     mvs_tag_free(mvi, tag);
 844 err_out:
 845 
 846     dev_printk(KERN_ERR, mvi->dev, "mvsas prep failed[%d]!\n", rc);
 847     if (!sas_protocol_ata(task->task_proto))
 848         if (n_elem)
 849             dma_unmap_sg(mvi->dev, task->scatter, n_elem,
 850                      task->data_dir);
 851 prep_out:
 852     return rc;
 853 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
