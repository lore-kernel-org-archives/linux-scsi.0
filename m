Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC079EACE;
	Thu,  5 Mar 2026 11:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708965; cv=none; b=UarPRwOYi2I0IS9ZLmuIXMxmBujfkx8Aszuo2bAKqAzxYP08DoUyNSvGHC+UlxinCKo3gmS8Vc3UrxtIOnjNZjxA3bcXZAzoMCS38YKLZzKfMuHpfayg1zcZ4+NvCRmlgxJi7hB1ooCYy9tpObgNv0cedwT3NRzxeb9eDbGpdt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708965; c=relaxed/simple;
	bh=4q8eG0iogGNaHaYuMOCURnYP/gUErb67c6ZjV71qBL8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QkShBdWqiDtej7QOfvnD9amXEbQzbebEl7Cb9MmxiuuXFeJtoJr+YzTV57FUGnMAInEnLPE0ApRW5Z3dAk0I7xVcXtVylCOcbPDhBm5TXecXm8szKo8o1IvZ5P1H2qL9Ea2yEVAo+mtmwsAyvJ1d5FcDECDzSf8sJZ0GxqSApSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VmogwvRF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VmogwvRF"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 625AFuGi936376;
	Thu, 5 Mar 2026 11:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=/KIc7s6lgxa
	PSNsSILYge2o6za9NEysQWUihn5wFA9k=; b=VmogwvRFfklAL8DI69c433lYtNw
	I4rb1916RSVMKp/sKzbzX6MD+EQhXfnUcH7XhRjXNmaWrZObp2ij58etx1SzQPVw
	Gz6euaeyXS3qTC2GTnGhT01rClPr/Hqgy6qL9I21edIzv7i3osNbovy1+V1blVc0
	7F19H3EWGBOQhxArt9uC8asGE9DG42IVPS5QX/L+/Cvn7+FzQrux276ZjwEwwm3M
	i75ZQS85VzyDHHEbuoFwjLSLfP40wLS3oK44B2a0I44BKcv1cqKJHzTJI9opDu73
	uL5KaAuorL4oKj9PcH2x8Jr4Tz4XPa+lkRsKEY/qclMnz+FflqFMQfXU9Bg==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cq04u1stu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 11:09:07 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 625B4F8f006105;
	Thu, 5 Mar 2026 11:09:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4cpy54e7n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 11:09:06 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 625B956e017271;
	Thu, 5 Mar 2026 11:09:06 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 625B95AK017255
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 11:09:05 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 34DAF5B2; Thu,  5 Mar 2026 03:09:05 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>, Huan Tang <tanghuan@vivo.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Yangtao Li <frank.li@vivo.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
        Liu Song <liu.song13@zte.com.cn>,
        Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Daniel Lee <chullee@google.com>, Bean Huo <huobean@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 1/1] scsi: ufs: core: Add support to notify userspace of UniPro QoS events
Date: Thu,  5 Mar 2026 03:08:56 -0800
Message-Id: <20260305110856.959211-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260305110856.959211-1-can.guo@oss.qualcomm.com>
References: <20260305110856.959211-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-GUID: PMbap5W0XoWCRVPKHgNB7RqbHkizx9Ax
X-Authority-Analysis: v=2.4 cv=eqTSD4pX c=1 sm=1 tr=0 ts=69a96453 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8 a=_qHeCve5qu6K62WyP8gA:9
X-Proofpoint-ORIG-GUID: PMbap5W0XoWCRVPKHgNB7RqbHkizx9Ax
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDA5MCBTYWx0ZWRfX+2PINIuok1r7
 qjd+36T6JlxlabW4cuusvH8OODa/zz1NM+53jTTx4K+u9P2uxEhRQQNcppKifK4zF3W/UFEH9PW
 zQxvKK+ZPaoOCN7YzRVlNoeNRJ6ojqg2r9CQgDRPayC2GCe/NkYAv6mQ0mGrMZwCHzllY3Oom6q
 Dfwvxjm356ivH0Vz1dJaLt5KdDdvhpzyg1GgO87wnZxQIAfR+drPsaNCqI+SBiZCRR5qUnrfM8r
 JrxK6c1TUtpeHuvgc8Bn5EcJ6XJ8hmFFWJcLxfhWt/A1iwkorJUYCEo73m+ueSK36Zmr3wsNF1t
 fXFdM1EOqMOEkYHbrbd1TrS/U0pwxXnTsVucuuzTphHSXtXhOELgn6nKsIVVEs7JFR7iyCVh3L6
 jkiCfSpBvIJRBf4NHdg+hueMOhhu4EXoXd8IPb0E8h8/V7xvC/oLUw7AtehmflVUeEFWdthj12P
 /Tui6MYl+PzV+F9Jhvg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_03,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 clxscore=1011 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050090

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
UniPro QoS Status attribute. The dme_qos_notification attribute is a
bitfield with the following bit assignments:

Bit	Description
===	======================================
0	DME QoS Monitor has been reset by host
1	QoS from TX is detected
2	QoS from RX is detected
3	QoS from PA_INIT is detected

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 23 +++++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 30 ++++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  | 24 ++++++++++++++---
 include/ufs/ufshcd.h                       |  9 +++++++
 include/ufs/ufshci.h                       |  1 +
 5 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index a90612ab5780..3c422aac778b 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1768,3 +1768,26 @@ Description:
 		====================   ===========================
 
 		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/dme_qos_notification
+What:		/sys/bus/platform/devices/*.ufs/dme_qos_notification
+Date:		March 2026
+Contact:	Can Guo <can.guo@oss.qualcomm.com>
+Description:
+		This attribute reports and clears pending DME (Device Management
+		Entity) Quality of Service (QoS) notifications. This attribute
+		is a bitfield with the following bit assignments:
+
+		Bit	Description
+		===	======================================
+		0	DME QoS Monitor has been reset by host
+		1	QoS from TX is detected
+		2	QoS from RX is detected
+		3	QoS from PA_INIT is detected
+
+		Reading this attribute returns the pending DME QoS notification
+		bits. Writing '0' to this attribute clears pending DME QoS
+		notification bits. Writing any non-zero value is invalid and
+		will be rejected.
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
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8349fe2090db..ccd9cf228210 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6962,10 +6962,19 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
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
+			atomic_set(&hba->dme_qos_notification,
+				   reg & UIC_DME_QOS_MASK);
+			if (hba->dme_qos_sysfs_handle)
+				sysfs_notify_dirent(hba->dme_qos_sysfs_handle);
+		}
+
 		retval |= IRQ_HANDLED;
 	}
 
@@ -9097,6 +9106,12 @@ static int ufshcd_post_device_init(struct ufs_hba *hba)
 
 	/* UFS device is also active now */
 	ufshcd_set_ufs_dev_active(hba);
+
+	/* Indicate that DME QoS Monitor has been reset */
+	atomic_set(&hba->dme_qos_notification, 0x1);
+	if (hba->dme_qos_sysfs_handle)
+		sysfs_notify_dirent(hba->dme_qos_sysfs_handle);
+
 	ufshcd_force_reset_auto_bkops(hba);
 
 	ufshcd_set_timestamp_attr(hba);
@@ -9729,6 +9744,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		hba->is_powered = false;
 		ufs_put_device_desc(hba);
 	}
+	sysfs_put(hba->dme_qos_sysfs_handle);
 }
 
 static int ufshcd_execute_start_stop(struct scsi_device *sdev,
@@ -11044,6 +11060,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_disable;
 
 	ufs_sysfs_add_nodes(hba->dev);
+	hba->dme_qos_sysfs_handle = sysfs_get_dirent(hba->dev->kobj.sd,
+						     "dme_qos_notification");
 	async_schedule(ufshcd_async_scan, hba);
 
 	device_enable_async_suspend(dev);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 8563b6648976..182f301c11e7 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -943,6 +943,11 @@ enum ufshcd_mcq_opr {
  * @critical_health_count: count of critical health exceptions
  * @dev_lvl_exception_count: count of device level exceptions since last reset
  * @dev_lvl_exception_id: vendor specific information about the device level exception event.
+ * @dme_qos_notification: Bitfield of pending DME Quality of Service (QoS)
+ *	events. Bits[3:1] reflect the corresponding bits of UIC DME Error Code
+ *	field within the Host Controller's UECDME register. Bit[0] is a flag
+ *	indicating that the DME QoS Monitor has been reset by the host.
+ * @dme_qos_sysfs_handle: handle for 'dme_qos_notification' sysfs entry
  * @rpmbs: list of OP-TEE RPMB devices (one per RPMB region)
  */
 struct ufs_hba {
@@ -1116,6 +1121,10 @@ struct ufs_hba {
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

