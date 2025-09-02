Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E762E719E
	for <linux-scsi@vger.kernel.org>; Tue,  2 Sep 2025 07:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756799320; cv=none; b=X4muIwJduOKuArSI0lwGV8/Ug090aZKClBy8VAHvjn0nTE4nwDmaXYiu4TtaJX53UWNyTOdXw5z4bm8Ug9fvLt7wCbra+TSziU3XwGcSGoN5ndQ9PNPklqbpfLNYl6aoXAo5l1YaLnNrvbbIuNOlVAIFAP7OzKIZZ+UbcrgJgk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756799320; c=relaxed/simple;
	bh=fDoOHY0Zpl4rBQTY1PUdC0etCtUgqqjSMNTz3YokoUc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sBoc3CYZ6c/s6PPnsEq6PS4bVcJpEL6O3ELkDmwgsNGK/uvwYfW+DgmN/8U4UfzfeRgSY4jCTNJh4vN1o+N91B1syIAso4RoIWWdve6gkLFNqvn/irzZ7jwTqVIz6RbADSZHOxCiXvJI7xKO1bfxJEFXL2O+53jEZ2KW2LnehZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eCyZFndy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eCyZFndy"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5822S7rv030605
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2025 07:48:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=qaqsDaJl/E8BLR+cwPeJEtVPr1RgbXmwoZR
	9XUu8+uw=; b=eCyZFndy+RC0oFgBGyH160boutj8Oi6XPvPRlIUodiUgVkvddEB
	acBtYugF8QLf/LhwJfxWmjPJNCwwpYb/xQnFyvTjKuWG7MXVII3kB8zVxJUrnp/A
	czImov6QLNggYXBWH/uoskeYKcu79w74E6/ajxtZtzozzv7O1KEt6072kv3w4E0y
	Y92g5b9BrxBTso7KLa3IYHOe5tNrtrzGGOk8mzeFw9drVGA4LUYnNUrl9A8X3FYM
	foMdixCTd1l61xhlF1jbaMqSC1oMlnw67yHlchmZIPWLqrPHZUVYdFBu3I9uwD2s
	qQakv0+7HOlioYIl2H4S53owqJjdDMRe24g==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48ura8pxve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 02 Sep 2025 07:48:37 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-76e6e71f7c6so4738120b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 02 Sep 2025 00:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756799316; x=1757404116;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qaqsDaJl/E8BLR+cwPeJEtVPr1RgbXmwoZR9XUu8+uw=;
        b=H59Bp37cF7sAoOhE7EPvTwS8xNn+B98mctt1/Ol2AJBD9UBsVQsfOdJthSOb+gHOBk
         IuNHk8M+dbsux6C3WTkoVBl/qHz62IEQFa80fvPiJrkCmFzomkhVA/He5ACxANK45wJg
         G3IoYH0Rrt6aV77lalX2ta3k6imA5kvgo+sibmJj9SVHZfBi1bEeQmCLhYhzmEqe/hMa
         tpB9VhvzBYj0pou/GDaj/m3HL17BnC0hQZp/PJMbiqub3Ed6PqCRPLCK7mJBLL8U9p06
         7AauJjDkR315TMJYxr0cg7eiAgazZDgcYd87gZYT48NJTjTIkgoIOL3Q0qJxFQyG1mTG
         yqng==
X-Forwarded-Encrypted: i=1; AJvYcCU1gCxBi/dlPy4NQWsH9AMtvfwRstkEWZ+ZW6FRIQ3wSD1N5byZ2PoSsuTDiRvkxof/n+a3+W2IHRSD@vger.kernel.org
X-Gm-Message-State: AOJu0YwxmpmByNzakJ+pb22EtjbCJ3Zavgx1bQiJqiqZFq+JvfTLJcJu
	xL/MO4KFNSj1lcAYZDcYKqb3YPH8cNmj32G52FdQ/JSmQlmkdcAYbyN8NRITMmFW29iplhHSINS
	IOx67G1d93l3kpKNfD46YSC01SbWWU5ayH1jUwHl+TtmdoAeUxxMJPg9PD7HDV3bp
X-Gm-Gg: ASbGnctp1rOx3yVLaWdKvhwMCnnlmsbG7jtU04QdGmFP/jMO0FIKK8EoTutYbkhKooT
	UXqINOXJrF3dH7wBFtF+8ESMlH/aYWfQPsRG0ZRJUEnmEIb8bHPKLvPODIcVTUmPSLkWTrQ2o5K
	XbaBIA6a/q++G41OIoh9Cp6uahmmDzFOzLz2R4NoPioYWFP+pzdZMr/1CIN0wWDSgtjkXs/isZN
	Et4qgmo07AavGvJPUtdnX+Voi2R2M9pkmtguGRBnBxIETOMQYXTx7Rve98M3Uig0mWO1MjLsPT7
	sixvvdbMGHf0HKSMi9TQFy/D/4jyqX4WM0mvIyZj7zQZ9z63J8HAs89+qe6UFip7o1JbG4YJq9/
	NWatPtis97OqLqf6d4xoOGrPgBakjyKI=
X-Received: by 2002:a05:6a00:90aa:b0:772:554c:4879 with SMTP id d2e1a72fcca58-772554c5019mr7993590b3a.26.1756799315828;
        Tue, 02 Sep 2025 00:48:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqC44eTVxcBKP6ZclsLZDlo5hgjCLdI1LecbFM3XvQVNcUn1KLXFVzYxhNe0DkscCmNKJkSA==
X-Received: by 2002:a05:6a00:90aa:b0:772:554c:4879 with SMTP id d2e1a72fcca58-772554c5019mr7993562b3a.26.1756799315346;
        Tue, 02 Sep 2025 00:48:35 -0700 (PDT)
Received: from zhonhan-gv.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7723427c127sm11372459b3a.62.2025.09.02.00.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 00:48:34 -0700 (PDT)
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, tanghuan@vivo.com, liu.song13@zte.com.cn,
        quic_nguyenb@quicinc.com, viro@zeniv.linux.org.uk, huobean@gmail.com,
        adrian.hunter@intel.com, can.guo@oss.qualcomm.com, ebiggers@kernel.org,
        neil.armstrong@linaro.org, angelogioacchino.delregno@collabora.com,
        quic_narepall@quicinc.com, quic_mnaresh@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, ziqi.chen@oss.qualcomm.com,
        zhongqiu.han@oss.qualcomm.com
Subject: [PATCH v2] scsi: ufs: core: Fix data race in CPU latency PM QoS request handling
Date: Tue,  2 Sep 2025 15:48:29 +0800
Message-ID: <20250902074829.657343-1-zhongqiu.han@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: TTbFTWNKgn5IxrgJepD7riTle_t_1_4s
X-Proofpoint-GUID: TTbFTWNKgn5IxrgJepD7riTle_t_1_4s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAyMCBTYWx0ZWRfX0yg2WaqkK/a5
 bFsi3L45y1genyRltNd9mAbbYvvwYEJZEhHL4hcueZ8drdEwPtjxjbq4YPud6FVvbye/4M1siEM
 NpYnyVCgLBcdmcR3Kj+tBquLjOXvMt4DDLPDGg7uMUK1flOTOH66J1cVICb0lAiwOBYOFesRsCc
 hcWBhj7avmNKBLc1wmYqvI04AbeVP5PfGOqYQOwDtKXJhOORtJ2o2pq8lagqM/evP4/qjcGBVgN
 f9UB/rDCYXUE+j6IjpyB6oydHedOFOaoEB1FAZjrSyXWbIKxeJUfzxHcETw+LdycdixJ/CAKE1+
 R6uAvgtMlU/O5QJjSMDZmcCJQcjuJLqdLDkqti3FJzspNSI69hohYC7wV1/LW+eI0lgIe3zzCxY
 kP+LETFC
X-Authority-Analysis: v=2.4 cv=VNndn8PX c=1 sm=1 tr=0 ts=68b6a155 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=LWsq1cZ33obsDQM5gBoA:9
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508300020

The cpu_latency_qos_add/remove/update_request interfaces lack internal
synchronization by design, requiring the caller to ensure thread safety.
The current implementation relies on the `pm_qos_enabled` flag, which is
insufficient to prevent concurrent access and cannot serve as a proper
synchronization mechanism. This has led to data races and list corruption
issues.

A typical race condition call trace is:

[Thread A]
ufshcd_pm_qos_exit()
  --> cpu_latency_qos_remove_request()
    --> cpu_latency_qos_apply();
      --> pm_qos_update_target()
        --> plist_del              <--(1) delete plist node
    --> memset(req, 0, sizeof(*req));
  --> hba->pm_qos_enabled = false;

[Thread B]
ufshcd_devfreq_target
  --> ufshcd_devfreq_scale
    --> ufshcd_scale_clks
      --> ufshcd_pm_qos_update     <--(2) pm_qos_enabled is true
        --> cpu_latency_qos_update_request
          --> pm_qos_update_target
            --> plist_del          <--(3) plist node use-after-free

This patch introduces a dedicated mutex to serialize PM QoS operations,
preventing data races and ensuring safe access to PM QoS resources.
Additionally, READ_ONCE is used in the sysfs interface to ensure atomic
read access to pm_qos_enabled flag.

Fixes: 2777e73fc154 ("scsi: ufs: core: Add CPU latency QoS support for UFS driver")
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
---
v1 -> v2:
- Fix misleading indentation by adding braces to if statements in pm_qos logic.
- Resolve checkpatch strict mode warning by adding an inline comment for pm_qos_mutex.
- Link to v1: https://lore.kernel.org/all/20250901085117.86160-1-zhongqiu.han@oss.qualcomm.com/

 drivers/ufs/core/ufs-sysfs.c |  2 +-
 drivers/ufs/core/ufshcd.c    | 25 ++++++++++++++++++++++---
 include/ufs/ufshcd.h         |  3 +++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 4bd7d491e3c5..8f7975010513 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -512,7 +512,7 @@ static ssize_t pm_qos_enable_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sysfs_emit(buf, "%d\n", hba->pm_qos_enabled);
+	return sysfs_emit(buf, "%d\n", READ_ONCE(hba->pm_qos_enabled));
 }
 
 /**
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 926650412eaa..98b9ce583386 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1047,14 +1047,19 @@ EXPORT_SYMBOL_GPL(ufshcd_is_hba_active);
  */
 void ufshcd_pm_qos_init(struct ufs_hba *hba)
 {
+	mutex_lock(&hba->pm_qos_mutex);
 
-	if (hba->pm_qos_enabled)
+	if (hba->pm_qos_enabled) {
+		mutex_unlock(&hba->pm_qos_mutex);
 		return;
+	}
 
 	cpu_latency_qos_add_request(&hba->pm_qos_req, PM_QOS_DEFAULT_VALUE);
 
 	if (cpu_latency_qos_request_active(&hba->pm_qos_req))
 		hba->pm_qos_enabled = true;
+
+	mutex_unlock(&hba->pm_qos_mutex);
 }
 
 /**
@@ -1063,11 +1068,16 @@ void ufshcd_pm_qos_init(struct ufs_hba *hba)
  */
 void ufshcd_pm_qos_exit(struct ufs_hba *hba)
 {
-	if (!hba->pm_qos_enabled)
+	mutex_lock(&hba->pm_qos_mutex);
+
+	if (!hba->pm_qos_enabled) {
+		mutex_unlock(&hba->pm_qos_mutex);
 		return;
+	}
 
 	cpu_latency_qos_remove_request(&hba->pm_qos_req);
 	hba->pm_qos_enabled = false;
+	mutex_unlock(&hba->pm_qos_mutex);
 }
 
 /**
@@ -1077,10 +1087,15 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
  */
 static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
 {
-	if (!hba->pm_qos_enabled)
+	mutex_lock(&hba->pm_qos_mutex);
+
+	if (!hba->pm_qos_enabled) {
+		mutex_unlock(&hba->pm_qos_mutex);
 		return;
+	}
 
 	cpu_latency_qos_update_request(&hba->pm_qos_req, on ? 0 : PM_QOS_DEFAULT_VALUE);
+	mutex_unlock(&hba->pm_qos_mutex);
 }
 
 /**
@@ -10764,6 +10779,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	mutex_init(&hba->ee_ctrl_mutex);
 
 	mutex_init(&hba->wb_mutex);
+
+	/* Initialize mutex for PM QoS request synchronization */
+	mutex_init(&hba->pm_qos_mutex);
+
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 30ff169878dc..a16f857a052f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -962,6 +962,7 @@ enum ufshcd_mcq_opr {
  * @ufs_rtc_update_work: A work for UFS RTC periodic update
  * @pm_qos_req: PM QoS request handle
  * @pm_qos_enabled: flag to check if pm qos is enabled
+ * @pm_qos_mutex: synchronizes PM QoS request and status updates
  * @critical_health_count: count of critical health exceptions
  * @dev_lvl_exception_count: count of device level exceptions since last reset
  * @dev_lvl_exception_id: vendor specific information about the
@@ -1135,6 +1136,8 @@ struct ufs_hba {
 	struct delayed_work ufs_rtc_update_work;
 	struct pm_qos_request pm_qos_req;
 	bool pm_qos_enabled;
+	/* synchronizes PM QoS request and status updates */
+	struct mutex pm_qos_mutex;
 
 	int critical_health_count;
 	atomic_t dev_lvl_exception_count;
-- 
2.43.0

