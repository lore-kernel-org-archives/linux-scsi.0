From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v2 0/7] megaraid_sas: Updates for scsi-next
Date: Thu, 20 Oct 2016 02:04:58 -0700
Message-ID: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36690 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752711AbcJTJFP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 05:05:15 -0400
Received: by mail-pf0-f175.google.com with SMTP id e6so32838118pfk.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2016 02:05:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>

Changes in v2:
1.  Removed unconditional msleep and moved calls to atomic_read into 
    megasas_wait_for_adapter_operational
2.  Updated change log for patch #4.  Provided more detail in change log.
3.  Agreed to remove module parameter. If we remove module parameter,
    we can ask customer to disable WCE on drive to get similar impact.
4.  Always Send SYNCHRONIZE_CACHE for JBOD (non Raid) Device to Firmware.
5. Add log message printing the state of FW sync cache support
6. Moved version update patch to end of series

Sumit Saxena (7):
  megaraid_sas: For SRIOV enabled firmware, ensure VF driver waits for
    30secs before reset
  megaraid_sas: Send correct PhysArm to FW for R1 VD downgrade
  megaraid_sas: Do not fire DCMDs during PCI shutdown/detach
  megaraid_sas: Send SYNCHRONIZE_CACHE command to firmware
  MAINTAINERS: Update megaraid maintainers list
  megaraid_sas: Do not set MPI2_TYPE_CUDA for JBOD FP path for FW which
    does not support JBOD sequence map
  megaraid_sas: driver version upgrade

 MAINTAINERS                                 | 10 +++---
 drivers/scsi/megaraid/megaraid_sas.h        |  7 +++--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 49 ++++++++++++++++++++++++-----
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  6 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 23 +++++++++-----
 5 files changed, 71 insertions(+), 24 deletions(-)

-- 
1.8.3.1

