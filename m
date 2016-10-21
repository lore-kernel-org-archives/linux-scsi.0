From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v3 0/7] megaraid_sas: Updates for scsi-next
Date: Fri, 21 Oct 2016 06:33:28 -0700
Message-ID: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35316 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932706AbcJUNd7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2016 09:33:59 -0400
Received: by mail-pf0-f177.google.com with SMTP id s8so57262115pfj.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2016 06:33:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com

Changes in v3
 two logical patches created for "Send SYNCHRONIZE_CACHE command to firmware"
	- Send SYNCHRONIZE_CACHE for JBOD to firmware 
	- Send SYNCHRONIZE_CACHE for VD to firmware 

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
  megaraid_sas: Send SYNCHRONIZE_CACHE for JBOD to firmware
  megaraid_sas: Send SYNCHRONIZE_CACHE for VD to firmware
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

