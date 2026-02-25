Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EE626F46F;
	Wed, 25 Feb 2026 02:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771986639; cv=none; b=AVoE3U5BAEsAnqEBkyA7U0C6RuDshfgYLrxJ7xsYzrSYzdl/TgsJBwQpqUYwwxACNGN+ftGsHt6pPQqxSUXkpltWqh5BJHMjz4ZleBZkV45ESdudFn2N9r385qbe5WGoUWFml/YpCQoS9Ol3VS9S5S/e6Cy/uefyzBQrqkFF5gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771986639; c=relaxed/simple;
	bh=uRrjzOl+PtlzqU88b5S83LRos4F9qAL9gYJiEzWw4mY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XywZHawzy+rBpoXOKLbDLFkWGYrnQFxg2Wo+SVk6Ii1o2n9BK2x2YZ5JI2XLWaIKEI/zLH2zQOZUBWlGuBZi3W7Ftc93BckrAw8ckDQ2kUKOBSDEDEOTNfiuAnNA2CRcyCy52yMETtYrABAnDRFsTtMlnH6EZkHYaEOShM6q7PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NWlx2sQh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NWlx2sQh"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OMjmvd4044329;
	Wed, 25 Feb 2026 02:30:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=cXqRX0SK2nA
	QUGkzZ132JJWUCuSaUGuakNeIqrcjJhE=; b=NWlx2sQhdU6xHr96ipY9KHiu10j
	CbNYcB1MOMdYR9fklQZ5FZDxkY6CugMa8cPTjGHz3544neWRKhjHorcjEUf91LP3
	1GPdlmBjTGR8h8FZvo3KJjih7R/2L6e5MWdKJMRGQOdlUClUAbO52azA+hMZnsQS
	FsIfCAr3EZuCtzvcMMacY13AH/siYCAo5Jn4QyILd7UY/YydW12JEydssR7oMHy8
	1TwwyXoIqK6ZPAfrSjPx6Fr8jHBKV0SIbVRR4XPOsl6Yzcs9LPISMUYaVnSIBOYI
	6QFe4grymV8yw3NUc9n1+yDicSQIK56D8OZQCpz9rkHhsW6Ht9lfNPgC83g==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4chexehwv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 02:30:25 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61P2Sqcj005322;
	Wed, 25 Feb 2026 02:30:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4chbqu67wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 02:30:24 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61P2UOSD007218;
	Wed, 25 Feb 2026 02:30:24 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 61P2UO4B007209
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 02:30:24 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 20EE75A5; Tue, 24 Feb 2026 18:30:24 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>, Huan Tang <tanghuan@vivo.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Daniel Lee <chullee@google.com>, Liu Song <liu.song13@zte.com.cn>,
        Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Bean Huo <huobean@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] scsi: ufs: core: Add a sysfs entry for ufshcd_state
Date: Tue, 24 Feb 2026 18:29:42 -0800
Message-Id: <20260225022942.345564-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260225022942.345564-1-can.guo@oss.qualcomm.com>
References: <20260225022942.345564-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDAyMSBTYWx0ZWRfX38lUiIg+mz5x
 2OQMLj4Kz9O1VRQaSUEk9V1zWv4jTp/35iOVM+mClL4FglXStE7E9B72fUJE9fAQMUZoMhuEhZ+
 Fxokd6mcyVFOOFI2innuAM1LCkaHchemRVRo4CLFO4yx4pHdY7JBi9LzvPROVAmDo/LbGspRggZ
 mZ50YiAOs2uNsx9Bk3E12jNdyrHlfOREfEpQP+waf0guEyMLsIomoo4WzY+/5PTwkNFdbjpJmm9
 ZiEWNCUVjd86u23SpQ67f4CWn9+/xc92Ih85Hg+he6EorjUeegfL3gZKChQvI4V0tbQ+ANxE0N0
 RZH3qrlJNMteTCEtERUYRhs+JO/GOsUgV4vpeCg16G/nKPjnnoA4Lvu76khk3Aif2vWICjC10ve
 TtAAeuXwAOKSWzabBSoBjHd/ezX5NGeAXSmHHpRie40GI0wXkESD31uijC6Du9PbZv+1F/WW5IE
 c69Spq+ND1g29njRbHA==
X-Authority-Analysis: v=2.4 cv=V85wEOni c=1 sm=1 tr=0 ts=699e5ec1 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8 a=NxQxUFsvoc-cg5by0coA:9
X-Proofpoint-GUID: TiwqMsby8nvHJ3AybvUapoembLH9MNGg
X-Proofpoint-ORIG-GUID: TiwqMsby8nvHJ3AybvUapoembLH9MNGg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250021

Add a sysfs entry for ufshcd_state, such that userspace can check and
track the state transitions of hba.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  9 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 18 ++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 665819308b40..339bb1befc9c 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1778,3 +1778,12 @@ Description:
 		notification from UFSHCI UECDME.
 
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/ufshcd_state
+What:		/sys/bus/platform/devices/*.ufs/ufshcd_state
+Date:		February 2026
+Contact:	Can Guo <can.guo@oss.qualcomm.com>
+Description:
+		This attribute shows the state of ufshcd.
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 99af3c73f1af..10804ec6e252 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -97,6 +97,14 @@ static const char * const ufs_hid_states[] = {
 	[DEFRAG_NOT_REQUIRED]	= "defrag_not_required",
 };
 
+static const char * const ufshcd_states[] = {
+	[UFSHCD_STATE_RESET]			= "reset",
+	[UFSHCD_STATE_OPERATIONAL]		= "operational",
+	[UFSHCD_STATE_EH_SCHEDULED_NON_FATAL]	= "eh_scheduled_non_fatal",
+	[UFSHCD_STATE_EH_SCHEDULED_FATAL]	= "eh_scheduled_fatal",
+	[UFSHCD_STATE_ERROR]			= "error",
+};
+
 static const char *ufs_hid_state_to_string(enum ufs_hid_state state)
 {
 	if (state < NUM_UFS_HID_STATES)
@@ -633,6 +641,14 @@ static ssize_t dme_qos_notification_store(struct device *dev,
 	return count;
 }
 
+static ssize_t ufshcd_state_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%s\n", ufshcd_states[hba->ufshcd_state]);
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -650,6 +666,7 @@ static DEVICE_ATTR_RO(critical_health);
 static DEVICE_ATTR_RW(device_lvl_exception_count);
 static DEVICE_ATTR_RO(device_lvl_exception_id);
 static DEVICE_ATTR_RW(dme_qos_notification);
+static DEVICE_ATTR_RO(ufshcd_state);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -669,6 +686,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_device_lvl_exception_count.attr,
 	&dev_attr_device_lvl_exception_id.attr,
 	&dev_attr_dme_qos_notification.attr,
+	&dev_attr_ufshcd_state.attr,
 	NULL
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c6c7de7a0603..32a508e1582e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7917,6 +7917,8 @@ static void ufshcd_process_probe_result(struct ufs_hba *hba,
 		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	sysfs_notify(&hba->dev->kobj, NULL, "ufshcd_state");
+
 	trace_ufshcd_init(hba, ret,
 			  ktime_to_us(ktime_sub(ktime_get(), probe_start)),
 			  hba->curr_dev_pwr_mode, hba->uic_link_state);
-- 
2.34.1

