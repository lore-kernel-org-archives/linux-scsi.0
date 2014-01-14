From: XinHong Zhu <zxh3737@163.com>
Subject: [PATCH] [scsi] : pm80xx : fix problem of pm8001_work_fn reseting uncorrect phy device
Date: Tue, 14 Jan 2014 17:41:05 +0800
Message-ID: <1389692465-7628-1-git-send-email-zxh3737@163.com>
References: <y>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:53788 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaANJlX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jan 2014 04:41:23 -0500
In-Reply-To: <y>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: XinHong Zhu <zxh3737@163.com>

If a phy device is removed ,the device can get error of I/O and HBA maybe receieve
IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS of event which causes pm8001_work_fn to reset the phy
device ,but in pm8001_task_exec don't assign a value for field device of ccb  and in
other case a ccb used have device field set , when  ccb is freeed the field device of
the ccb don't be set NULL.So there is possibility of getting another devcie reset in fun
of mpi_ssp_completion .Also there are another way to solve problem by adding following
code in mpi_SSP_completion:
  pm8001_dev = t->dev->lldd_dev;
Signed-off-by: zhuxh <zxh3737@163.com>
---
 drivers/scsi/pm8001/pm8001_sas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f50ac44..f0ea5db 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -434,6 +434,7 @@ static int pm8001_task_exec(struct sas_task *task, const int num,
 		ccb->n_elem = n_elem;
 		ccb->ccb_tag = tag;
 		ccb->task = t;
+		ccb->device = pm8001_dev;
 		switch (t->task_proto) {
 		case SAS_PROTOCOL_SMP:
 			rc = pm8001_task_prep_smp(pm8001_ha, ccb);
-- 
1.7.9


