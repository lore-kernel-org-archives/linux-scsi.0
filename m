From: chenxiang <chenxiang66@hisilicon.com>
Subject: [PATCH v2 0/4] fix dma_unmap_sg() parameter in some scsi drivers
Date: Thu, 4 Jan 2018 10:36:41 +0800
Message-ID: <1515033405-37477-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:54784 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752039AbeADChg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Jan 2018 21:37:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: john.garry@huawei.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, bryantly@linux.vnet.ibm.com, mikecyr@linux.vnet.ibm.com, artur.paszkiewicz@intel.com, dan.j.williams@intel.com, yuxiangl@marvell.com, jgarzik@pobox.com, jack_wang@usish.com, lindar_liu@usish.com, chenxiang <chenxiang66@hisilicon.com>

According to Documentation/DMA-API.txt, all the parameters of dma_unmap_sg()
must be the same as those and passed in to the scatter/gather mapping API.
But in scsi drivers such as ibmscsi_tgt/iscsi/mvsas/pm8001, the <nents>
parameter of dma_unmap_sg() is number of elements after mapping. So fix them.

Part of the document is as follows:

	void
	dma_unmap_sg(struct device *dev, struct scatterlist *sg,
			int nents, enum dma_data_direction direction)
				
Unmap the previously mapped scatter/gather list.  All the parameters
must be the same as those and passed in to the scatter/gather mapping
API.
				
Note: <nents> must be the number you passed in, *not* the number of
	DMA address entries returned.

Chang Log:
v1 -> v2:
	Split the patch into small patchset, and one patch per driver;

chenxiang (4):
  scsi: ibmvscsis: fix dma_unmap_sg() parameter
  scsi: isci: fix dma_unmap_sg() parameter
  scsi: mvsas: fix dma_unmap_sg() parameter
  scsi: pm8001: fix dma_unmap_sg() parameter

 drivers/scsi/ibmvscsi_tgt/libsrp.c | 6 ++++--
 drivers/scsi/isci/request.c        | 2 +-
 drivers/scsi/mvsas/mv_sas.c        | 4 ++--
 drivers/scsi/pm8001/pm8001_sas.c   | 2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

-- 
1.9.1
