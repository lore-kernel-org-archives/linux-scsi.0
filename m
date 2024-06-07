Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8531CA85;
	Fri,  7 Jun 2024 10:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717754868; cv=none; b=G67YcPXEAq0p99gbZW4TUg7OFqOq7GU2Klhvfqyb4u/l7JNVewrHmFbdogfNR/V7wc7Jt8q8VxOTN1T6Dm8oQmultsmFVpe2BeB5U6xByaoi+ZNbzMC1AoLoJrhdjeDMZDiz1vM/NKzyHxVLwb08Tet4ajel6SCIPkGVjpl98w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717754868; c=relaxed/simple;
	bh=/GIw8ahA38bUcm722/R6YcFYIDZrCeeA/ZikbJOO3FQ=;
	h=From:To:Cc:Subject:Date:Message-Id; b=AdR5qazC+3cNhGy5vkJ8yGb+evtPbu1mySM/lybxT6Yii8gPMjL+6sE7B6fLAfHVYs254T722M5BXDI0xBNDpEWJmn4M72Ov0AXs/T7FHSPvyCQteT+07nl7KrnIcd5XtlQOfpi0l71ryOA1u8Y31VxltzVQyeJrlO41EzNqA1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=J17X6lNh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="J17X6lNh"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4579pW0w010897;
	Fri, 7 Jun 2024 10:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:date:from:message-id:subject:to; s=qcppdkim1; bh=w/K8iHCPgKYH
	40cQaI+c/K8OCvvyQGKDTZokVkkzy8U=; b=J17X6lNhyyV7C205EAtUhfHaLgsx
	Pkg0uApj1vuFf1oh6hVvXalom9WE4xuXDzdtgUsq6JMv5+vhO9VpNa9jSVvNlT78
	oxbFod77mPcMIiDzNaQL6tlMSchv0heejiZKWe1Sewaef/SrvM3NdH5oLtnB+KD0
	PeYSOWOsP3BxWaLF2hv6XOTgZKSP3L5ozgyDUze8qyJIpOf+ao2JtzrVo+eqF+K3
	z+WAk2XqvQkwwrjgVCNEmMEJw7G0pUgbDISPSGiZavto84/6ih5Id0jM0EQuyXxO
	wHsx1lHB9n3erHnGafqZ9s14OlN96v9mrY59tZwMnCvltQ9Fn3evLjJpdg==
Received: from aptaippmta01.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com [103.229.16.4])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yjhw0x7re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Jun 2024 10:07:30 +0000 (GMT)
Received: from pps.filterd (APTAIPPMTA01.qualcomm.com [127.0.0.1])
	by APTAIPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 457A7Rgk023476;
	Fri, 7 Jun 2024 10:07:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APTAIPPMTA01.qualcomm.com (PPS) with ESMTP id 3yfvqm2f7u-1;
	Fri, 07 Jun 2024 10:07:27 +0000
Received: from APTAIPPMTA01.qualcomm.com (APTAIPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 457A7Rpa023471;
	Fri, 7 Jun 2024 10:07:27 GMT
Received: from cbsp-sh-gv.qualcomm.com (CBSP-SH-gv.ap.qualcomm.com [10.231.249.68])
	by APTAIPPMTA01.qualcomm.com (PPS) with ESMTP id 457A7Q4l023470;
	Fri, 07 Jun 2024 10:07:27 +0000
Received: by cbsp-sh-gv.qualcomm.com (Postfix, from userid 393357)
	id 075AE11D9; Fri,  7 Jun 2024 18:07:25 +0800 (CST)
From: Ziqi Chen <quic_ziqichen@quicinc.com>
To: quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, quic_ziqichen@quicinc.com,
        quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
        quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: ufs: core: quiesce request queues before check pending cmds
Date: Fri,  7 Jun 2024 18:06:23 +0800
Message-Id: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: vcCb_e2R3oYvQyBfTJu8rAIhtvn70LZW
X-Proofpoint-GUID: vcCb_e2R3oYvQyBfTJu8rAIhtvn70LZW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-07_04,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406070073
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

In ufshcd_clock_scaling_prepare(), after scsi layer is blocked,
ufshcd_pending_cmds() is called to tell whether there are pending
transactions or not. And only if there is no pending transaction,
can we proceed to kick start clock scaling sequence.

ufshcd_pending_cmds() traverses over all scsi devices and calls
sbitmap_weight() on their budget_map. The sbitmap_weight() can break
down to three steps -
1. Calculates the nr outstanding bits set in the 'word' bitmap.
2. Calculates the nr outstanding bits set in the 'cleared' bitmap.
3. Minus the result from step 1 by the result from step 2.

There can be a race condition in below scenario -

Assume there is one pending transaction in the request queue of one scsi
device, say sda, and the budget token of this request is 0, the 'word'
is 0x1 and the 'cleared' is 0x0.

1. When step 1 executes, it gets the result as 1.
2. Before step 2 executes, block layer tries to dispatch a new request
   to sda. Since scsi layer is blocked, the request cannot pass through
   scsi layer, but the block layer would anyways do budget_get() and
   budget_put() to sda's budget map, so the 'word' has become 0x3 and
   'cleared' has become 0x2 (assume the new request got budget token 1).
3. When step 2 executes, it gets the result as 1.
4. When step 3 executes, it gets the result as 0, meaning there is no
   pending transactions, which is wrong.

Thread A                        Thread B
ufshcd_pending_cmds()           __blk_mq_sched_dispatch_requests()
|                               |
sbitmap_weight(word)            |
|                               scsi_mq_get_budget()
|                               |
|                               scsi_mq_put_budget()
|                               |
sbitmap_weight(cleared)
...

When this race condition happens, clock scaling sequence is kicked start
with transactions still in flight, leading to subsequent hibernate enter
failure, broken link, task abort and back to back error recovery.

Fix this race condition by quiescing the request queues before calling
ufshcd_pending_cmds() so that block layer won't touch the budget map
when ufshcd_pending_cmds() is working on it. In addition, remove the
scsi layer blocking/unblocking to reduce redundancies and latencies.

Fixes: 8d077ede48c1 ("scsi: ufs: Optimize the command queueing code")
Co-developed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 21429ee..1afa862 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1392,7 +1392,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 	 * make sure that there are no outstanding requests when
 	 * clock scaling is in progress
 	 */
-	ufshcd_scsi_block_requests(hba);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
 
@@ -1401,7 +1401,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
-		ufshcd_scsi_unblock_requests(hba);
+		blk_mq_unquiesce_tagset(&hba->host->tag_set);
 		goto out;
 	}
 
@@ -1422,7 +1422,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool sc
 
 	mutex_unlock(&hba->wb_mutex);
 
-	ufshcd_scsi_unblock_requests(hba);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	ufshcd_release(hba);
 }
 
-- 
2.7.4

