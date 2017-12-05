From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 0/17] scsi: arcmsr: add some driver options and support new
 adapter ARC-1884
Date: Tue, 05 Dec 2017 09:21:22 +0800
Message-ID: <1512436882.4577.26.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:37995 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752734AbdLEJVb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 04:21:31 -0500
Received: by mail-pg0-f43.google.com with SMTP id f12so10280389pgo.5
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2017 01:21:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au

From: Ching Huang <ching2048@areca.com.tw>

Hi Martin,

Due to 4.16/scsi-queue conflict with 4.15-rc1, so I resubmit these patches again.
The following patches apply to Linus' 4.15-rc1 tree.

Patch 1: redefine ACB_ADAPTER_TYPE_A, _B, _C, _D and subsequent changes.

Patch 2: simplify arcmsr_iop_init function.

Patch 3: add codes for ACB_ADAPTER_TYPE_E to support new adapter ARC-1884

Patch 4. update ARCMSR_MAX_OUTSTANDING_CMD and ARCMSR_MAX_FREECCB_NUM to 1024

Patch 5: replace constant ARCMSR_MAX_FREECCB_NUM by variable acb->maxFreeCCB that was got from firmware.

Patch 6: add driver option host_can_queue to set host->can_queue value by user. It's value expands
         up to 1024.

Patch 7: replace constant ARCMSR_MAX_OUTSTANDING_CMD by variable acb->maxOutstanding that was determined by user.

Patch 8: add driver option cmd_per_lun to set host->cmd_per_lun value by user.

Patch 9: add ACB_F_MSG_GET_CONFIG to acb->acb_flags for for message interrupt checking before schedule work for
         get device map.

Patch 10: add a function arcmsr_set_iop_datetime and driver option set_date_time to set date and time to firmware.

Patch 11: fix clear doorbell queue on ACB_ADAPTER_TYPE_B controller.

Patch 12: spin off duplicate code of timer init for message isr BH in arcmsr_probe and arcmsr_resume as a function
          arcmsr_init_get_devmap_timer

Patch 13: adjust some tab or white-space to make text alignment.

Patch 14: fix grammar error.

Patch 15: Add module parameter msi_enable to has a chance to disable msi interrupt if it does not work properly.

Patch 16: Add module parameter msix_enable to has a chance to disable msix interrupt if it does not work properly.

Patch 17: update driver version to v1.40.00.04-20171130
---
