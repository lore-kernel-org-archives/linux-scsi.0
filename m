Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0E63C13EE
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 12:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784810875; cv=none; b=gxjUijXUUo3uzRYKjDB9E+M2PBaahsLgyfM53n/4BRREhwLdudB7hCm1XX1WsHq/JtoKpGfRsWKd0fXmdCdusBCvlD/Gz5eKjDwaj9DkhPQf3FxGPP7lu0QIJ8VsEuNvZB8WZ37Aio0tooF7bl+XNHBe4VCdZXXXyAhbvpBpCcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784810875; c=relaxed/simple;
	bh=/OOWqM+/ChEU9d8362G66BOwQk9kGeX/ndon4wIIahQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kLewSluQ2d0EAYmuVzXG97+TWtUYWUrzglgjHDIbwbxC5hkDXlHSs5KzezbRpcstYOJmD7NnjXAZHY7fTPs557ic7elsyQniAocmS/CNV0EtODDvGv3PkywbuWJ1AKKdriTbiyJXy1y3CjDNawy4Gp8kFym6i0zcXdONU58V7TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZVFISBcO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=f5EG9ZUY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZVFISBcO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="f5EG9ZUY"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N8qWel467146
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 12:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=TxDUiGp8SHaAPcdouNgR23yANnHbyiCldl9
	AoUt6zEI=; b=ZVFISBcOEB6VCAVDLMRI3ohYazPQ6fjJbMy69rfg1wQrpGaqIhg
	HdAAofDt1I+GqKrtdCD1JhdfYfIuLkD0+VGqncoOyA0goQo/Aeb6wzi/1wWkwVBW
	Zr7La5jnytK2WzMt2AvNruMd8ZLkQ2NfNn4D9e+yWtO2pa6+6nOmcS7KaQte6iuo
	LavT4d40zp3zbJzGF7Jl5O3tVh9UZeAFb7yQnNdzN+dy3QaBT0I1v5T2bsglYGSX
	cnWGCZY2/vbyfXMM8CHXwRjWWTnRclTTwCKD3xPB1ByukdVyiknWgC191UT2s92w
	auaOI30HTBptaMfGOxhDsI7radPXLiLaZ9Q==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fk28xv49b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 12:47:53 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb4cdf95b5aso1292300a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784810873; x=1785415673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TxDUiGp8SHaAPcdouNgR23yANnHbyiCldl9AoUt6zEI=;
        b=f5EG9ZUYK418qxhxRUTWRuVWJ9J7Ajcg+bJMllyAQa4qwuh40vWYPZTqe4bT4b1Lu+
         S0qEupmL+q+zsLRqGjp6vAtVft5EehUW6r6l9G4jv2t80sHjGyErt0hMkHuLMo/L3IHg
         PuZkq5vJzcniMD0GmLppJx0pHVnAP5mR5OFnF9ZwuKLzOOmNnJJvNz3yLceVSpZZIswn
         475yVuGv7hpfst9df87kAOHIJAPwBq1+26GnNiwy6NVSDXSDzeraDaDOVoiIJiD/j6Nj
         nVpviwuH/QkwYm/gJIBFXgfXUKGUdd3A9zde0gyZi2t+dPvTVEim4o/EH/m8xXk+04JU
         cKHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784810873; x=1785415673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TxDUiGp8SHaAPcdouNgR23yANnHbyiCldl9AoUt6zEI=;
        b=dM69/BWKEY2MjWUIgC8FuB6ULW4ISh4IFkyyIzCepf/Ss5g6JarW1UWEmWORqxoWPm
         WzUEyTe3oV9QsW3MV46bQa2djU7VKXByxeBkY6xmSjIEh+iXNRh2fB0KnweuhnM1ZaKs
         PMRCQFCRKNioBQMKqdQvgglKwc0b8XtAaJhn4Dv+uwq/APAjzdZORFDQ2XiReh9lFbHg
         Lbgyco2AEGiodv6bjHK40j7+/2yUI8OdusP2D5NyGkhH7wDLYpZ+7jZv3QQ1zr6X3Yxq
         rKr9v9riF2PDk2kXCg0SIm74apHTKHwQW/E3wt2yRH4bVblC6399UC+uRPGO+hs2koGr
         /dAg==
X-Forwarded-Encrypted: i=1; AHgh+RrotnUMuHPV+w02tGk329RIuFLne5+WtUd0eaw3co0gb655lB2aMr3I7f24zs0c5VsM8JPHmmCE7ghL@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9M1BsKABsQn5FTF+nmpSJ8JG5zWoPN/PenjGGZSe0J7K9xIn6
	IV3g3RgMc08E1mKJdFjXhCWn4SKBxVS/beI/kFNnRBgGppBeUz2L2leuXpk0y2jAhtxladYzh8H
	wuD2KXMq91cCpIX08eqYa4cqSl36KbiljNeKlUeG2FV0UR5A6w8XyOOfBm0x9atEU
X-Gm-Gg: AR+sD10z6QMl8aEQVmY8h8EsA3Y0p5YYX5DPjx6+ziepla/c0htk5LmRDkLbvB3gt0D
	Q+kr+s4uemIObvNHx+XEXqmVe4T+Di9SfuN6FbW/+FClAIwFt0BmMRem6qoP615oi0Dip4aHZ4b
	6l2LkXhDCB0PGxURzpOZHXX4Y9ryuz37tfo7jI+Rwiy9aprXNZYLkompJnckK7u+JQ5zTDmQ97Y
	iqt3PKYrxTdHnCDCx5bWtSFYf6ijNiKd2oLQrgMOJ0TBH3RScg+XLEdx1TMvDILjjpJB4sG1A9R
	YXq0HtdiHUQeSiF4qsA3yK8K6KumGhDXj4Qg+2lpRi4NjzOduwE7fR3hrBYH88nWRnj5umenaE7
	jmYj2rAjOgdaA1DktpSMyAWKOmdXgQG6AitQfl+/76+q07qZHlQ==
X-Received: by 2002:a05:6a20:7483:b0:3b2:8685:1473 with SMTP id adf61e73a8af0-3c44afb58c5mr3374569637.7.1784810872727;
        Thu, 23 Jul 2026 05:47:52 -0700 (PDT)
X-Received: by 2002:a05:6a20:7483:b0:3b2:8685:1473 with SMTP id adf61e73a8af0-3c44afb58c5mr3374545637.7.1784810872316;
        Thu, 23 Jul 2026 05:47:52 -0700 (PDT)
Received: from QCOM-IvKeorbwK5.na.qualcomm.com ([120.60.139.18])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1c9289sm20350504eec.29.2026.07.23.05.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:47:51 -0700 (PDT)
From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
To: alim.akhtar@samsung.com, avri.altman@sandisk.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
Subject: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/O quiesce for clock scaling"
Date: Thu, 23 Jul 2026 14:47:33 +0200
Message-ID: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ETTGYRn5B_GhPZbM8QtgZxjpKbqP_DXP
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEyNiBTYWx0ZWRfX/f7CAbxs6M7m
 xpyINT5S27v/2LM9HUCq+I6zmGtBgSeTR1NGyBS/RQM0evPrP4ZG0id5w3Tu5edUkbAbEUR61U/
 ZTA3ji9GXhavpgd3tbqTyvOZvTZZnNw=
X-Proofpoint-GUID: ETTGYRn5B_GhPZbM8QtgZxjpKbqP_DXP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEyNiBTYWx0ZWRfX22m0j5jVfC9p
 GICfcVD5jFlzOza9lkBIlNdNpBcsXwSZ/AYsaOzi5oiWXYGVoOAaUSrdVdvFByXzdbgqlS7mAZA
 cLXp+5kAGzhTIRKYofPJwrt6ZQAuIDtm+izcCY9LsPEDTiBzbRxplFVvvOC5ESWqS1idMPN8qXb
 QdmmIJg3b8UKi9hov7K+I6TL4P+YwyGvoQ8o12OlSQjAalw58cPAG/NqMHTzOWdHllnCbAPKTm/
 H0oMNRo/r5QmO42z5rU0KLQuGdXhQXhBcu1pBcCQ27ItziWIpH6BWENbBs4zmS6vWl7k1Ycc9yO
 c4CFw0r2QxGapyl/Nhq9XeNBrCM1X/LVRsuVyMn8TNhpelMQsMyMk+tpM6Uo+3ma759NzUnw55D
 WvP18f7LtYjhPNninONFbWcGwIuh0vjlMUUuWBgH58gQf42A0jd2N1bNMMRTrbPKgREth1KTI0K
 EOEwi/zRgWoRef8eWYw==
X-Authority-Analysis: v=2.4 cv=WNxPmHsR c=1 sm=1 tr=0 ts=6a620d79 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fabVTapF7hbH8ecADQZKXA==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=KsTwQG257LBwhBlho30A:9 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 impostorscore=0 suspectscore=0 clxscore=1011 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230126

This reverts commit 85b2b966285498e1b551ac85f02c79cd06c0cff0.

Qcom UFS Host Controllers do not support scaling clocks when the traffic is
ongoing. But the offending commit removed the block I/O quiesce in the
clock scaling path, which causes below UFS failures during clock scaling:

ufshcd-qcom 1d84000.ufshc: ufshcd_check_errors: saved_err 0x80 saved_uic_err 0x0
ufshcd-qcom 1d84000.ufshc: ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting down 0; saved_err = 0x80; saved_uic_err = 0x0; force_reset = 0
ufshcd-qcom 1d84000.ufshc: pwr ctrl cmd 0x2 with (MIBattribute 0x1571, mode 0x11) completion timeout
ufshcd-qcom 1d84000.ufshc: UFS Host state=3
ufshcd-qcom 1d84000.ufshc: 7 outstanding reqs, tasks=0x0
ufshcd-qcom 1d84000.ufshc: saved_err=0x80, saved_uic_err=0x0
ufshcd-qcom 1d84000.ufshc: Device power mode=1, UIC link state=1
ufshcd-qcom 1d84000.ufshc: PM in progress=0, sys. suspended=0
ufshcd-qcom 1d84000.ufshc: Auto BKOPS=0, Host self-block=0
ufshcd-qcom 1d84000.ufshc: Clk gate=1
ufshcd-qcom 1d84000.ufshc: last_hibern8_exit_tstamp at 196451913 us, hibern8_exit_cnt=20
ufshcd-qcom 1d84000.ufshc: error handling flags=0x0, req. abort count=0
ufshcd-qcom 1d84000.ufshc: hba->ufs_version=0x300, Host capabilities=0x1587031f, caps=0x124f
ufshcd-qcom 1d84000.ufshc: quirks=0x0, dev. quirks=0x310c4
ufshcd-qcom 1d84000.ufshc: UFS dev info: SAMSUNG  KLUDG4UHDB-B2D1  rev 0400
ufshcd-qcom 1d84000.ufshc: clk: core_clk, rate: 300000000
ufshcd-qcom 1d84000.ufshc: clk: core_clk_unipro, rate: 300000000

Hence, revert the commit to bring back UFS on all Qcom platforms.

Reported-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Closes: https://lore.kernel.org/linux-scsi/al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 79331c2bd38d..1a5a851d43b2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1445,7 +1445,7 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, u32 target_gear, bool scale_up
  *
  * Return: 0 upon success; -EBUSY upon timeout.
  */
-static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
+static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 {
 	int ret = 0;
 	/*
@@ -1453,13 +1453,16 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	 * clock scaling is in progress
 	 */
 	mutex_lock(&hba->host->scan_mutex);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
 
-	if (!hba->clk_scaling.is_allowed) {
+	if (!hba->clk_scaling.is_allowed ||
+	    ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
+		blk_mq_unquiesce_tagset(&hba->host->tag_set);
 		mutex_unlock(&hba->host->scan_mutex);
 		goto out;
 	}
@@ -1475,6 +1478,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
 {
 	up_write(&hba->clk_scaling_lock);
 	mutex_unlock(&hba->wb_mutex);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	mutex_unlock(&hba->host->scan_mutex);
 
 	/* Enable Write Booster if current gear requires it else disable it */
@@ -1502,7 +1506,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, unsigned long freq,
 
 	new_gear = ufshcd_vops_freq_to_gear_speed(hba, freq);
 
-	ret = ufshcd_clock_scaling_prepare(hba);
+	ret = ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
 	if (ret)
 		return ret;
 
-- 
2.43.0

