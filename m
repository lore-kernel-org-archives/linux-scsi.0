From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188951] New: Function beiscsi_create_eqs() may return improper
 value when the call to pci_alloc_consistent() fails, which may result in
 use-after-free
Date: Fri, 25 Nov 2016 11:11:50 +0000
Message-ID: <bug-188951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751227AbcKYLTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 06:19:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 845BB20453
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:11:57 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id D351020172
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:11:50 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188951

            Bug ID: 188951
           Summary: Function beiscsi_create_eqs() may return improper
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
memory. In function beiscsi_create_eqs() defined in file
drivers/scsi/be2iscsi/be_main.c, function pci_alloc_consistent() is called and
its return value is checked against NULL (at line 3052). If the return value is
NULL, the control flow will jump to label "create_cq_error", frees allocated
memory and returns variable ret. Because after the first execution of the loop
the value of ret must be 0 (see the check statement of ret at line 3067), the
return value will be 0 (indicates success) if pci_alloc_consistent() fails
during the second or after repeats of the loop body. In this case, the freed
memory may be used or freed again in the callers of beiscsi_create_eqs(). I
think it is better to assign "-ENOMEM" when the call pci_alloc_consistent()
fails. Codes and comments related to this bug are summarised as follows.

beiscsi_create_eqs @@ drivers/scsi/be2iscsi/be_main.c
3028 static int beiscsi_create_eqs(struct beiscsi_hba *phba,
3029                  struct hwi_context_memory *phwi_context)
3030 {
3031     int ret = -ENOMEM, eq_for_mcc;
         ...
3045     for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
3046         eq = &phwi_context->be_eq[i].q;
3047         mem = &eq->dma_mem;
3048         phwi_context->be_eq[i].phba = phba;
3049         eq_vaddress = pci_alloc_consistent(phba->pcidev,
3050                            num_eq_pages * PAGE_SIZE,
3051                            &paddr);
3052         if (!eq_vaddress)
                 // ret may takes value 0. Add "ret = -ENOMEM" here?
3053             goto create_eq_error;

3065         ret = beiscsi_cmd_eq_create(&phba->ctrl, eq,
3066                         phwi_context->cur_eqd);
3067         if (ret) {
3068             beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
3069                     "BM_%d : beiscsi_cmd_eq_create"
3070                     "Failed for EQ\n");
3071             goto create_eq_error;
3072         }
3073 
3074         beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
3075                 "BM_%d : eqid = %d\n",
3076                 phwi_context->be_eq[i].q.id);
3077     }
3078     return 0;
3079 
3080 create_eq_error:
3081     for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
3082         eq = &phwi_context->be_eq[i].q;
3083         mem = &eq->dma_mem;
3084         if (mem->va)
3085             pci_free_consistent(phba->pcidev, num_eq_pages
3086                         * PAGE_SIZE,
3087                         mem->va, mem->dma);
3088     }
3089     return ret;
3090 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
