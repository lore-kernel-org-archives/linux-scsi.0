From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 00/12] SCSI patches for kernel v4.13
Date: Thu, 1 Jun 2017 16:26:59 -0700
Message-ID: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:41432 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdFAXcK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 19:32:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>

Hello Martin,

This patch series consists of the bug fixes and improvements I came up
with during the past two months. Please consider these patches for kernel
v4.13.

Thanks,

Bart.

The changes compared to v1 of this patch series are:
- Left out the block layer patches from this series.
- Reworked this patch series such that it applies cleanly on the 4.13 SCSI
  patch queue and no longer depends on any block layer changes that are not
  yet upstream.
- In patch "Avoid that scsi_exit_rq() triggers a use-after-free", make the
  prep functions save and restore the SCMD_UNCHECKED_ISA_DMA flag.
- Addd patch "Introduce scsi_start_queue()".

Bart Van Assche (12):
  Avoid that scsi_exit_rq() triggers a use-after-free
  Split scsi_internal_device_block()
  Create two versions of scsi_internal_device_unblock()
  Protect SCSI device state changes with a mutex
  Introduce scsi_start_queue()
  Make __scsi_remove_device go straight from BLOCKED to DEL
  Only add commands to the device command list if required by the LLD
  Introduce scsi_mq_sgl_size()
  Make scsi_mq_prep_fn() call scsi_init_command()
  snic: Remove code that zeroes driver-private command data
  virtio: Remove code that zeroes driver-private command data
  xen/scsifront: Remove code that zeroes driver-private command data

 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   8 +-
 drivers/scsi/scsi.c                  |   9 +-
 drivers/scsi/scsi_error.c            |  10 +-
 drivers/scsi/scsi_lib.c              | 309 +++++++++++++++++++++--------------
 drivers/scsi/scsi_priv.h             |   7 +-
 drivers/scsi/scsi_scan.c             |  16 +-
 drivers/scsi/scsi_sysfs.c            |  37 ++++-
 drivers/scsi/scsi_transport_srp.c    |   7 +-
 drivers/scsi/sd.c                    |   7 +-
 drivers/scsi/snic/snic_scsi.c        |   2 -
 drivers/scsi/virtio_scsi.c           |   1 -
 drivers/scsi/xen-scsifront.c         |   1 -
 include/scsi/scsi_cmnd.h             |   1 +
 include/scsi/scsi_device.h           |   7 +-
 14 files changed, 263 insertions(+), 159 deletions(-)

-- 
2.12.2
