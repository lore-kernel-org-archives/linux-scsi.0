From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188941] New: Function beiscsi_create_cqs() may return improper
 value when the call to pci_alloc_consistent() fails, which may result in
 use-after-free
Date: Fri, 25 Nov 2016 11:10:21 +0000
Message-ID: <bug-188941-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750801AbcKYLLJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 06:11:09 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 481DE20122
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:10:34 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id D3CC320453
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:10:21 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188941

            Bug ID: 188941
           Summary: Function beiscsi_create_cqs() may return improper
                    value when the call to pci_alloc_consistent() fails,
                    which may result in use-after-free
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

Function pci_alloc_consistent() returns a NULL pointer if there is no enough
memory. In function beiscsi_create_cqs() defined in file
drivers/scsi/be2iscsi/be_main.c, function pci_alloc_consistent() is called and
its return value is checked against NULL (at line 3116). If the return value is
NULL, the control flow will jump to label "create_cq_error", frees allocated
memory and returns variable ret. Because after the first execution of the loop
the value of ret must be 0 (see the check statement of ret at line 3129), the
return value will be 0 (indicates success) if pci_alloc_consistent() fails
during the second or after repeats of the loop body. In this case, the freed
memory may be used or freed again in the callers of beiscsi_create_cqs(). I
think it is better to assign "-ENOMEM" when the call pci_alloc_consistent()
fails. Codes and comments related to this bug are summarised as follows.

beiscsi_create_cqs @@ drivers/scsi/be2iscsi/be_main.c
3092 static int beiscsi_create_cqs(struct beiscsi_hba *phba,
3093                  struct hwi_context_memory *phwi_context)
3094 {
         ...
3100     int ret = -ENOMEM;
         ...
3106     for (i = 0; i < phba->num_cpus; i++) {
3107         cq = &phwi_context->be_cq[i];
3108         eq = &phwi_context->be_eq[i].q;
3109         pbe_eq = &phwi_context->be_eq[i];
3110         pbe_eq->cq = cq;
3111         pbe_eq->phba = phba;
3112         mem = &cq->dma_mem;
3113         cq_vaddress = pci_alloc_consistent(phba->pcidev,
3114                            num_cq_pages * PAGE_SIZE,
3115                            &paddr);
3116         if (!cq_vaddress)
                 // ret may takes value 0. Add "ret = -ENOMEM" here?
3117             goto create_cq_error;
             ...
3129         ret = beiscsi_cmd_cq_create(&phba->ctrl, cq, eq, false,
3130                         false, 0);
3131         if (ret) {
3132             beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
3133                     "BM_%d : beiscsi_cmd_eq_create"
3134                     "Failed for ISCSI CQ\n");
3135             goto create_cq_error;
3136         }
3137         beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
3138                 "BM_%d : iscsi cq_id is %d for eq_id %d\n"
3139                 "iSCSI CQ CREATED\n", cq->id, eq->id);
3140     }
3141     return 0;
3142 
3143 create_cq_error:
3144     for (i = 0; i < phba->num_cpus; i++) {
3145         cq = &phwi_context->be_cq[i];
3146         mem = &cq->dma_mem;
3147         if (mem->va)
3148             pci_free_consistent(phba->pcidev, num_cq_pages
3149                         * PAGE_SIZE,
3150                         mem->va, mem->dma);
3151     }
3152     return ret;
3153 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
