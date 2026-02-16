Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6592D060D;
	Mon, 16 Feb 2026 13:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771249625; cv=none; b=tm9p0kbElhpNRj0E+x/NCdLBtuxVvrJ7Qo3iD/BGlexUr7R1N8cdSbV4kM5oFm45Pvajqkqv+T/hr+8mgoebrw+W4NHbTHe2TJuxJ+o8DvFRMKczVKob46jg8hCJDmrZ925PypxGt6Og+Xk4XI17KmuyPokAS3EjObP/v9B/39E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771249625; c=relaxed/simple;
	bh=OdoyuhTlY1+vBx9iEMczkPecRlHebK/bJVhivYoxcYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N473BYsJWeHZMufsfQhUVZQdT6SF1pF2KEi6tkpbMKemQu9RriL7+SuwXL3CxbqRIas1sKcQAUcRiGo1JvcODZMAYLPm73K0IRMUEZkSkbwbEYdjFxt+tk493sjtntM/w1sZwlkUjfCFNBI6eMtdB3ZEwhGhJC33KOZRbjZaXDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Yl9WtWs8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Yl9WtWs8"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GB8Z3s1582941;
	Mon, 16 Feb 2026 13:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=i+FNGK4JMIV
	y11v7TTKhiseiLl5FWUolZtQr5bc+6vQ=; b=Yl9WtWs8pdm+09KsTWGcxDt2dtR
	PUYgDuuW5My+Wftd+JPzcszEMxpjudYvdBX7yDIgz5ZSbS5nUIxX3fELc4010vcT
	NoVr85GJRQwb2hhrmUJk4ImDaTDVJX62zyVBkVmDR8NGWXM3Ph9chdpBhFVYgB3k
	woniSNePpIeuL9d4DaZo2Drx5x6aJWN1eF9xEuI1sSqvAMhehCdlNb/DOnQhecrb
	hM/rvZiGX1VLr5anGrot01bV8iy6+tj/UWlJCxddwVM3mqRXa1xk/L/W1SUr4qJG
	bKdWBYxT9PoEzo2oNO1lFqXU4Po6Rl7tJ2gs7LTvO69s/YSYU6uIUNW6PZQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cbnv9hrwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 13:46:49 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61GDkmbk014904;
	Mon, 16 Feb 2026 13:46:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4caj4mubvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 13:46:48 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61GDkmSO014893;
	Mon, 16 Feb 2026 13:46:48 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 61GDklc9014891
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 13:46:48 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id D19505A8; Mon, 16 Feb 2026 05:46:47 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Huan Tang <tanghuan@vivo.com>, Peter Wang <peter.wang@mediatek.com>,
        Bean Huo <huobean@gmail.com>, Ziqi Chen <quic_ziqichen@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Daniel Lee <chullee@google.com>,
        Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Liu Song <liu.song13@zte.com.cn>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] scsi: ufs: core: Add support to notify userspace of UniPro QoS events
Date: Mon, 16 Feb 2026 05:46:35 -0800
Message-Id: <20260216134636.3477154-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260216134636.3477154-1-can.guo@oss.qualcomm.com>
References: <20260216134636.3477154-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: bVbGed-3AC4qp49M_7mxe4bmMC4fLZBo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDExNiBTYWx0ZWRfXyFTkcKO+My/G
 mQ0UvD+EPZJ1CiLjROagp2GlPFGNFQ6sMNPoU2nCrxmYoHqDeOYI9nK1NpdAmx6wM3ckfNdE5Yi
 yuVzi0DiN3XyDX4DqTOtX6nYYLPWGbnAJJ/D/dT2wSY9S1pn+8AwdjqB2e3eoTEstgOV3DivEOu
 QabIk+6uWfPBdaz9Fo2XDUwVcd6GhyVc476Zz8vgapwK4JRuD4D5gvqUxvaV+BKe4tQBx1KlpaH
 Qc02ZMoFx2YXjc+NUD/xKOtnFgdr3DWf1bZbOlRoScF0xcEWiYh8UwTu+7yW7Syi90XIdw1p9mw
 zfWPBC1I98X0qqq1C5AnuwPNIJflfj4jXYGGqFwLgtQ3+yLZhEvcrhp5Gvi6wqrBeToagCZzumT
 y3svidccRV0VX7EPi+TeJa3l/uu1olHjzouAFHozBIZfLfuoOPjnITOvxXQmu7cUnp4DIOdWN+x
 5SQ5D3I6k8D1qwTIC4g==
X-Authority-Analysis: v=2.4 cv=b7K/I9Gx c=1 sm=1 tr=0 ts=69931fc9 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=EUspDBNiAAAA:8 a=T8lAIxqZN1jmFlUga84A:9
X-Proofpoint-GUID: bVbGed-3AC4qp49M_7mxe4bmMC4fLZBo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_04,2026-02-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 clxscore=1011 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602160116

The UniPro stack manages to repair many potential Link problems without the
need to notify the Application Layer. Repair mechanisms of the stack
include L2 re-transmission and successful handling of PA_INIT.req.
Nevertheless, any successful repair sequence requires Link bandwidth that
is no longer vailable for the Application. Therefore, it may be useful for
an Application to understand how often such repair attempts are made.

The DME implements Quality of Service monitoring using a simple counting
scheme, counting error events and comparing them against the number of
correctly received or transmitted bytes. When the error counter exceeds a
programmed threshold before the byte counter overflows, a DME_QoS.ind is
issued to the Application and both counters are reset. When the byte
counter overflows before the error counter has reached the programmed
threshold, both counters are reset without triggering a DME_QoS.ind.

The DME provides Link quality monitoring for the following purposes:
1. Detection of re-occurring repaired fatal error conditions on the Link
   (PA_INIT loop). This kind of detection is useful if capabilities
   exchanged between local and peer permit a potential operation at a
   higher M-PHY Gear, but the physical interconnect between local and peer
   Device does not, or, after Line quality degradation, no longer satisfies
   channel characteristics.
2. Detection of degraded inbound or outbound Link quality, to allow an
   Application to issue an ADAPT sequence for a Link running in HS-G4 or
   higher HS Gears. This kind of detection is used to monitor a slowly
   degrading Link quality, e.g., one being affected by temperature and
   voltage variations, against the expected M-PHY bit error rate.

Userspace can configure and enable UniPro QoS via UniPro QoS Attributes
(via UFS BSG) and get notified by dme_qos_notification without polling
UniPro QoS Status attribute.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 10 ++++++++
 drivers/ufs/core/ufs-sysfs.c               | 30 ++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h             |  6 +++++
 drivers/ufs/core/ufshcd.c                  | 16 +++++++++---
 include/ufs/ufshcd.h                       |  6 +++++
 include/ufs/ufshci.h                       |  1 +
 6 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index a90612ab5780..665819308b40 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1768,3 +1768,13 @@ Description:
 		====================   ===========================
 
 		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/dme_qos_notification
+What:		/sys/bus/platform/devices/*.ufs/dme_qos_notification
+Date:		February 2026
+Contact:	Can Guo <can.guo@oss.qualcomm.com>
+Description:
+		This attribute shows and clears the DME	Quality of Service
+		notification from UFSHCI UECDME.
+
+		The attribute is read/write.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 384d958615d7..99af3c73f1af 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -605,6 +605,34 @@ static ssize_t device_lvl_exception_id_show(struct device *dev,
 	return sysfs_emit(buf, "%llu\n", exception_id);
 }
 
+static ssize_t dme_qos_notification_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "0x%x\n", atomic_read(&hba->dme_qos_notification));
+}
+
+static ssize_t dme_qos_notification_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned int value;
+
+	if (kstrtouint(buf, 0, &value))
+		return -EINVAL;
+
+	/* the only supported usecase is to reset the dme_qos_notification */
+	if (value)
+		return -EINVAL;
+
+	atomic_set(&hba->dme_qos_notification, 0);
+
+	return count;
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -621,6 +649,7 @@ static DEVICE_ATTR_RW(pm_qos_enable);
 static DEVICE_ATTR_RO(critical_health);
 static DEVICE_ATTR_RW(device_lvl_exception_count);
 static DEVICE_ATTR_RO(device_lvl_exception_id);
+static DEVICE_ATTR_RW(dme_qos_notification);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -639,6 +668,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_critical_health.attr,
 	&dev_attr_device_lvl_exception_count.attr,
 	&dev_attr_device_lvl_exception_id.attr,
+	&dev_attr_dme_qos_notification.attr,
 	NULL
 };
 
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 7d6d19361af9..14e8cb145f43 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -446,4 +446,10 @@ static inline void ufs_rpmb_remove(struct ufs_hba *hba)
 }
 #endif
 
+static inline void sysfs_notify_dirent_safe(struct kernfs_node *sd)
+{
+	if (sd)
+		sysfs_notify_dirent(sd);
+}
+
 #endif /* _UFSHCD_PRIV_H_ */
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8349fe2090db..e0e70da35c2a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6900,6 +6900,7 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 	if ((reg & UIC_PHY_ADAPTER_LAYER_ERROR) &&
 	    (reg & UIC_PHY_ADAPTER_LAYER_ERROR_CODE_MASK)) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_PA_ERR, reg);
+
 		/*
 		 * To know whether this error is fatal or not, DB timeout
 		 * must be checked but this error is handled separately.
@@ -6962,10 +6963,17 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 	}
 
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DME);
-	if ((reg & UIC_DME_ERROR) &&
-	    (reg & UIC_DME_ERROR_CODE_MASK)) {
+	if (reg & UIC_DME_ERROR) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_DME_ERR, reg);
-		hba->uic_error |= UFSHCD_UIC_DME_ERROR;
+
+		if (reg & UIC_DME_ERROR_CODE_MASK)
+			hba->uic_error |= UFSHCD_UIC_DME_ERROR;
+
+		if (reg & UIC_DME_QOS_MASK) {
+			atomic_set(&hba->dme_qos_notification, reg & UIC_DME_QOS_MASK);
+			sysfs_notify_dirent_safe(hba->dme_qos_sysfs_handle);
+		}
+
 		retval |= IRQ_HANDLED;
 	}
 
@@ -11044,6 +11052,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_disable;
 
 	ufs_sysfs_add_nodes(hba->dev);
+	hba->dme_qos_sysfs_handle = sysfs_get_dirent(hba->dev->kobj.sd,
+						     "dme_qos_notification");
 	async_schedule(ufshcd_async_scan, hba);
 
 	device_enable_async_suspend(dev);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 8563b6648976..5a49d44c163f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -943,6 +943,8 @@ enum ufshcd_mcq_opr {
  * @critical_health_count: count of critical health exceptions
  * @dev_lvl_exception_count: count of device level exceptions since last reset
  * @dev_lvl_exception_id: vendor specific information about the device level exception event.
+ * @dme_qos_notification: UFS host controller DME QoS notification
+ * @dme_qos_sysfs_handle: handle for 'dme_qos_notification' sysfs entry
  * @rpmbs: list of OP-TEE RPMB devices (one per RPMB region)
  */
 struct ufs_hba {
@@ -1116,6 +1118,10 @@ struct ufs_hba {
 	int critical_health_count;
 	atomic_t dev_lvl_exception_count;
 	u64 dev_lvl_exception_id;
+
+	atomic_t dme_qos_notification;
+	struct kernfs_node *dme_qos_sysfs_handle;
+
 	u32 vcc_off_delay_us;
 	struct list_head rpmbs;
 };
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 806fdaf52bd9..49a3a279e448 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -271,6 +271,7 @@ enum {
 /* UECDME - Host UIC Error Code DME 48h */
 #define UIC_DME_ERROR			0x80000000
 #define UIC_DME_ERROR_CODE_MASK		0x1
+#define UIC_DME_QOS_MASK		0xE
 
 /* UTRIACR - Interrupt Aggregation control register - 0x4Ch */
 #define INT_AGGR_TIMEOUT_VAL_MASK		0xFF
-- 
2.34.1

