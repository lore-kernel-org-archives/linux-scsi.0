From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: Add softreset in hisi_sas_I_T_nexus_reset()
Date: Wed, 20 Mar 2019 18:21:34 +0800
Message-ID: <1553077294-129863-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

We found out that for v2 hw, a SATA disk can not be written to after
the system comes up.

In commit ffb1c820b8b6 ("scsi: hisi_sas: remove the check of sas_dev
status in hisi_sas_I_T_nexus_reset()"), we introduced a path where we may
issue an internal abort for a SATA device, but without following it with a
softreset.

We need to always follow an internal abort with a software reset, as per HW
programming flow, so add this.

Fixes: ffb1c820b8b6 ("scsi: hisi_sas: remove the check of sas_dev status in hisi_sas_I_T_nexus_reset()")
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---

Hi James, Martin,

Please consider this patch for 5.1 fixes. It's fixes a big regression,
where we can no longer access SATA disks, like here:
https://storage.kernelci.org/next/master/next-20190213/arm64/defconfig/gcc-7/lab-collabora/boot-hip07-d05.html

Thanks,
John

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 3c3cf89f713f..14bac4966c87 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1801,6 +1801,12 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 	}
 	hisi_sas_dereg_device(hisi_hba, device);
 
+	if (dev_is_sata(device)) {
+		rc = hisi_sas_softreset_ata_disk(device);
+		if (rc)
+			return TMF_RESP_FUNC_FAILED;
+	}
+
 	rc = hisi_sas_debug_I_T_nexus_reset(device);
 
 	if ((rc == TMF_RESP_FUNC_COMPLETE) || (rc == -ENODEV))
-- 
2.17.1
