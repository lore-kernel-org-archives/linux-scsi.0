Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B676C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 06:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DD5E60F44
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 06:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhJOGgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 02:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhJOGgA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 02:36:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFF4C061570;
        Thu, 14 Oct 2021 23:33:54 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso1031928pjw.2;
        Thu, 14 Oct 2021 23:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=LgmdE1XOeelCIv9kprKZKgpgZX3+QsY9KrSqoYhDPwk=;
        b=SL1fMcOyAqx0UTJqjwDaIm09RWUguTv2VxPrz+sUUZi9iFYZn96Orj1xgRgZ9A1gfH
         G7uvomr81v1Uiua6NV4PmgQHa3vcd3VzElW/Kr7ozHlm/qEqzhmbhrHXfNqIcVtOBwGy
         cN3rY/XaZwVe4Oy1P+RgPmzSW5X5ayRPzHjoj72B/hmECCt6P6QJhx9FmuZX3Hd326N8
         /CjalOsY7ZgJ42sLA9SR/NzuFppJT7d+6zYDK0vCsnOwp9Gvaw3nM2vsim1USScEVtpX
         b4kymYwcomjvsOvBN5bna1be+kDQoLdkiLy9xzDemN8LDPQfokQGPHKb7nzu9sau5Bh6
         RH5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LgmdE1XOeelCIv9kprKZKgpgZX3+QsY9KrSqoYhDPwk=;
        b=rqJ4fA8YSzRTMUDsqvYprD40iO1EtpFbe3zqg2jsSEnJ/JMaIRDXvlXppdeD5Zmui1
         DUy/BBE8808jGlqU/XV0WF3SNb4jqwoxXC7cKxnYvxfpFU/ITQNBNb2fIfjata2OTLj9
         HQ187iXRXsYSQXBR443SKaE0PZDtRVYz57ER7tP5ilOC0/OofHendw8bZeA3qHMUhwP+
         uG4WzhYVhP6NSf5Xcxw844SgEWCszewCvgWN4KMdLCWZEeF1md2sOvE5MXKzdPPHv1tA
         3OI20I5NV0kW8wvcm5P890gqgfmZ2N0Fh5XpV4LLMASGTZ69Injew5zydei3cD2L+TDa
         80AQ==
X-Gm-Message-State: AOAM530GAjYhLy9HGxStzIkPrPCOBqZ7gcuV0yW+eQMtOKfw/M5hrd87
        xApYFYomBmgaOaOxTl3XxQ==
X-Google-Smtp-Source: ABdhPJyCn0Z5GgQIXcv2A+f7t9yhBa5Cgu2IEWK+5DuCeY/cLJBG9WxTykagaHOeniC1+cmLMMDqsQ==
X-Received: by 2002:a17:90a:cc01:: with SMTP id b1mr11623433pju.104.1634279634035;
        Thu, 14 Oct 2021 23:33:54 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id gk1sm2723795pjb.2.2021.10.14.23.33.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Oct 2021 23:33:53 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] scsi: lpfc: Fix the misuse of the logging function
Date:   Fri, 15 Oct 2021 06:33:41 +0000
Message-Id: <1634279621-27115-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the driver fails in lpfc_enable_pci_dev(), it will call
lpfc_printf_log(), and in a certain case the lpfc_dmp_dbg() is
eventually called, this function uses 'phba->port_list_lock', and at
this time this lock is not been initialized, which may cause a bug.

Fix this by using 'dev_printk' to replace the previous function.

The following log reveals it:

[   32.955597  ] INFO: trying to register non-static key.
[   32.956002  ] The code is fine but needs lockdep annotation, or maybe
[   32.956491  ] you didn't initialize this object before use?
[   32.956916  ] turning off the locking correctness validator.
[   32.958801  ] Call Trace:
[   32.958994  ]  dump_stack_lvl+0xa8/0xd1
[   32.959286  ]  dump_stack+0x15/0x17
[   32.959547  ]  assign_lock_key+0x212/0x220
[   32.959853  ]  ? SOFTIRQ_verbose+0x10/0x10
[   32.960158  ]  ? lock_is_held_type+0xd6/0x130
[   32.960483  ]  register_lock_class+0x126/0x790
[   32.960815  ]  ? rcu_read_lock_sched_held+0x33/0x70
[   32.961233  ]  __lock_acquire+0xe9/0x1e20
[   32.961565  ]  ? delete_node+0x71e/0x790
[   32.961859  ]  ? __this_cpu_preempt_check+0x13/0x20
[   32.962220  ]  ? lock_is_held_type+0xd6/0x130
[   32.962545  ]  lock_acquire+0x244/0x490
[   32.962831  ]  ? lpfc_dmp_dbg+0x65/0x600 [lpfc]
[   32.963241  ]  ? __kasan_check_write+0x14/0x20
[   32.963572  ]  ? read_lock_is_recursive+0x20/0x20
[   32.963921  ]  ? __this_cpu_preempt_check+0x13/0x20
[   32.964284  ]  ? lpfc_dmp_dbg+0x65/0x600 [lpfc]
[   32.964685  ]  ? _raw_spin_lock_irqsave+0x29/0x70
[   32.965086  ]  ? __kasan_check_read+0x11/0x20
[   32.965410  ]  ? trace_irq_disable_rcuidle+0x85/0x170
[   32.965787  ]  _raw_spin_lock_irqsave+0x4e/0x70
[   32.966124  ]  ? lpfc_dmp_dbg+0x65/0x600 [lpfc]
[   32.966526  ]  lpfc_dmp_dbg+0x65/0x600 [lpfc]
[   32.966913  ]  ? lockdep_init_map_type+0x162/0x710
[   32.967269  ]  ? error_prone+0x25/0x30 [lpfc]
[   32.967657  ]  lpfc_enable_pci_dev+0x157/0x250 [lpfc]

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 12 +++++-------
 drivers/scsi/lpfc/lpfc_scsi.c |  5 ++---
 drivers/scsi/lpfc/lpfc_sli.c  | 10 ++++------
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0ec322f0e3cb..226b9ccfffb3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7331,10 +7331,10 @@ static void lpfc_log_intr_mode(struct lpfc_hba *phba, uint32_t intr_mode)
 static int
 lpfc_enable_pci_dev(struct lpfc_hba *phba)
 {
-	struct pci_dev *pdev;
+	struct pci_dev *pdev = phba->pcidev;
 
 	/* Obtain PCI device reference */
-	if (!phba->pcidev)
+	if (!pdev)
 		goto out_error;
 	else
 		pdev = phba->pcidev;
@@ -7358,8 +7358,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
 out_disable_device:
 	pci_disable_device(pdev);
 out_error:
-	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-			"1401 Failed to enable pci device\n");
+	dev_err(&pdev->dev, "1401 Failed to enable pci device\n");
 	return -ENODEV;
 }
 
@@ -8401,9 +8400,8 @@ lpfc_init_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->lpfc_stop_port = lpfc_stop_port_s4;
 		break;
 	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"1431 Invalid HBA PCI-device group: 0x%x\n",
-				dev_grp);
+		dev_err(&phba->pcidev->dev,
+				"1431 Invalid HBA PCI-device group: 0x%x\n", dev_grp);
 		return -ENODEV;
 	}
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0fde1e874c7a..8ffce2d2a993 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5096,9 +5096,8 @@ lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->lpfc_scsi_prep_cmnd_buf = lpfc_scsi_prep_cmnd_buf_s4;
 		break;
 	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"1418 Invalid HBA PCI-device group: 0x%x\n",
-				dev_grp);
+		dev_err(&phba->pcidev->dev,
+				"1418 Invalid HBA PCI-device group: 0x%x\n", dev_grp);
 		return -ENODEV;
 	}
 	phba->lpfc_rampdown_queue_depth = lpfc_rampdown_queue_depth;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ffd8a140638c..c1cf0ad018e0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10010,9 +10010,8 @@ lpfc_mbox_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->lpfc_sli_brdready = lpfc_sli_brdready_s4;
 		break;
 	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"1420 Invalid HBA PCI-device group: 0x%x\n",
-				dev_grp);
+		dev_err(&phba->pcidev->dev,
+				"1420 Invalid HBA PCI-device group: 0x%x\n", dev_grp);
 		return -ENODEV;
 	}
 	return 0;
@@ -11178,9 +11177,8 @@ lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->__lpfc_sli_issue_fcp_io = __lpfc_sli_issue_fcp_io_s4;
 		break;
 	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"1419 Invalid HBA PCI-device group: 0x%x\n",
-				dev_grp);
+		dev_err(&phba->pcidev->dev,
+				"1419 Invalid HBA PCI-device group: 0x%x\n", dev_grp);
 		return -ENODEV;
 	}
 	phba->lpfc_get_iocb_from_iocbq = lpfc_get_iocb_from_iocbq;
-- 
2.17.6

