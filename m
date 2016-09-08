From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH][SCSI] scsi: ufs: get a TM service response from the correct
 offset
Date: Fri, 09 Sep 2016 08:22:22 +0900
Message-ID: <000401d20a27$da459040$8ed0b0c0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:38425 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbcIHXWZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2016 19:22:25 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0OD701R68KXBRT20@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 09 Sep 2016 08:22:23 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, =?UTF-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

From: Kiwoong Kim <kwmad.kim@samsung.com>

When any UFS host controller receives a TM(Task Management)
response from a UFS device,
UFS driver has been recognize like receiving a message of
"Task Management Function Complete"(00h) in all cases, so far.
That means there is no pending task for a tag of the TM request
sent before in the UFS device.
That's because the byte offset 6 in TM response which has been used
to get a TM service response so far
represents just whether or not a TM transmission passes.

Regarding UFS spec, the correct byte offset to
get TM service response is 15, not 6.

I tested that UFS driver responds properly for the TM response
>From a UFS device with an reference board with exynos8890, as follow:
No pending task -> Task Management Function Complete (00h)
Pending task -> Task Management Function Succeeded (08h)

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: HeonGwang Chu <hg.chu@samsung.com>
Tested-by: : Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs.h    |    1 +
 drivers/scsi/ufs/ufshcd.c |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 42c459a..89c121e 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -295,6 +295,7 @@ enum {
        MASK_QUERY_DATA_SEG_LEN         = 0xFFFF,
        MASK_RSP_UPIU_DATA_SEG_LEN      = 0xFFFF,
        MASK_RSP_EXCEPTION_EVENT        = 0x10000,
+       MASK_TM_SERVICE_RESP            = 0xFF,
 };

 /* Task management service response */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e8a706b..c641cd3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3013,8 +3013,8 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index, u8 *resp)
        if (ocs_value == OCS_SUCCESS) {
                task_rsp_upiup = (struct utp_upiu_task_rsp *)
                                task_req_descp[index].task_rsp_upiu;
-               task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
-               task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
+               task_result = be32_to_cpu(task_rsp_upiup->output_param1);
+               task_result = task_result & MASK_TM_SERVICE_RESP;
                if (resp)
                        *resp = (u8)task_result;
        } else {
--
1.7.9.5

