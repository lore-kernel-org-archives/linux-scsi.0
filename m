From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/3] hisi_sas: device id/IPTT collision workaround
Date: Fri, 15 Apr 2016 21:36:35 +0800
Message-ID: <1460727398-102091-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:23876 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbcDONVm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 09:21:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

This patchset introduces a workaround to a hw quirk
in the HiSilicon SAS controller v2 hw.

The quirk is as follows:
When a SATA and SAS frame arrives at the host at
the same time the frames may be swapped under this
condition:
SATA device id bit [10:0] == SAS frame IPTT bit [10:0]
The workaround is to ensure these 2 values never
match. The workaround algorithm is as follows:
- SATA device id bit0 always 0
- SATA IPTT has no restriction
- SAS IPTT bit0 always 1
- SAS device id has no restriction

The major restriction of this workaround is the
SAS IPTT range is halved, but this should be ok
as testing has shown that even using half the IPTT
range does not affect performance.

John Garry (3):
  hisi_sas: add device and slot alloc hw methods
  hisi_sas: add slot_index_alloc_quirk_v2_hw()
  hisi_sas: add alloc_dev_quirk_v2_hw()

 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 11 +++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 58 ++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 2 deletions(-)

-- 
1.9.1

