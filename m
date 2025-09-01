Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02C02FB970
	for <linux-scsi@vger.kernel.org>; Mon,  1 Sep 2025 08:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756716687; cv=none; b=CYex1X6oSf2g6DTmNeAW6txdcPLlWWPPvfL7UDuQj9tG2BsTElY2A+JKVbC5LdcBKvR8RSLkv0ja9uS8dWFYG/dAszLGBGoFIv837CFk5NmITC1WRNMM6ePAQDSWLJMRjOcewO74DVESC62sqHzu8BvVslIQEep52bCDhVgHM2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756716687; c=relaxed/simple;
	bh=XrbZexRIxDvZhju5+9QWUl6stdqXzSMg2jQoWArCM34=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XSGjkiKrYTvIUfE7bvAB5qVX1wXYolTm3tTrbGOtfyfyXTr1+jRfYQ/nxzOncnJQemromHQ+6xu/G2X6OPO3XtKEzncmq3i06Gg/MdxehZYauj1fBrx5xcr3DfavCH8blniThpuX+9pnhCMEa4/aTabzHqJYkqGo0/u29RgeuR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=d/nw8qgB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="d/nw8qgB"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5817ihZ8007696
	for <linux-scsi@vger.kernel.org>; Mon, 1 Sep 2025 08:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=u/UuUiBZZ0n9XhcUdx3sipQ4gPzSrPJvNFj
	uS2EBN/Y=; b=d/nw8qgBf7jokW/ivtdWqSnh6yvSwDtn4yviWwwNqIV0UzvAYN3
	vYeKHw75co+X0K6HAj5LoZWTZyZWda+01Yb94Zc1NcgOQkiFmiHdxxMrSr41MDr7
	yqUM7cfHSwHgs8lcVpvOkbQMiHFRbOxqKV67Z6tNnrK9WEXmBFQI087awfrDmnB/
	ayCHsAqa39d3KkwBwYPnMLPo+iLrqKvHH3i61dP1zlGXGh8MPEfU6DDR7Y+dHoRH
	AYmrHpphnhBWnsAe+eZru62QzAurpVxS38v+h9iJxomkdTvN4PJaXVAStXgsDFpj
	p48THpAnFrMG1KZv2Z0EAxar/MexfRWirfw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48utk8uybd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 01 Sep 2025 08:51:24 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-32811874948so1646316a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 01 Sep 2025 01:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756716684; x=1757321484;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u/UuUiBZZ0n9XhcUdx3sipQ4gPzSrPJvNFjuS2EBN/Y=;
        b=LFcMsVBLBEkTSp0Uq/wmefJzXqKAbQaWiiq/Yuolyq5OjXOLqpPpd4anaObkEzP+KJ
         QZ9gpfhzshPqLmhdEH8Z+1aKVTlhdonaZExCtqf9aIGqQDFEJMs92Oaj7IVcVPE/HzQ9
         ZXukIbPho2lFqKTW0ztxD0SaVWihXBowl8RJ8y80o14btQXa9JAWWupsDSnftccNFYvi
         W2EGElya0O0G9Ao8kjduN3jwxYB6rhHMykId+aT0ExVmAHKcxS1juZwq5IpJlx0DqoNw
         1pydTLbZLVQ9o7yVn/cBeqBmFTudvd7BAtE8BIRiWv7DtYKkpAHhFUG/FgaAARGICVIF
         Wyiw==
X-Forwarded-Encrypted: i=1; AJvYcCXk8B5tLVEZRuDZHqOa97JoUrwK7l2mvnPJRPuOES2ImPvKqYsc9Gu3oBXNBO3rO/CH6p6mr4DBfCRb@vger.kernel.org
X-Gm-Message-State: AOJu0YzQN+jdFo0reyPFD9gTxCHfGznL3nx2bWhOPScKFoxk2Ikw+OIt
	j2viRZI9fg6nBF4ekhLHZb/wubVKjDjs5GrgK9yYyqF2DfIxG4a2Uhn80G8CL3clyKgMby9RfUy
	S8FtoW4Nz3Cwu0XWJ4pg4wJ+iNvM+OkUKPj/LyCiR5EsZMc0sENm6awS0oXZtYUh1
X-Gm-Gg: ASbGncsgYck2lpsrTqYcx3W2X9wz8/s73fhcE26TzHUsqwRzmk/VXhh9jmcapM1yrOQ
	qXL3bMLxFb3jpedSHbLI+NZ5lHKOX9KYEgN4kaWa3j63FVY+LU7vAD5IbgRbQsXbVM0qB6QEs4q
	GObRB9xfixwT5oQsiQVf7YlYY+FEsyb7FYwsj4ciV58yD4pyiiLAzNUE3hU3wRoZkwHoMYKog5i
	6N/o2QO1ZYBsbiiSg94e8uhSd53CxNA0i692MEm5Q0y13t6HJYPlsXgibOOjBC7I7oy81y+KB/P
	Pt0oioe6ZsT2PwA+Q3zpIs/qK5RtDUwsrzBboK0jHvcyhauTGo42GvoxoyI1qtwc194ceAKY4a+
	1Mfo2vqckUe9zsg5nKgWMdknxhCbMub8=
X-Received: by 2002:a17:90b:370a:b0:327:aaeb:e814 with SMTP id 98e67ed59e1d1-328156babd1mr6591979a91.23.1756716683689;
        Mon, 01 Sep 2025 01:51:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZhrulCPEiXiqrYyGIf41rwfHjxwpZKyJ/5zPadKvzIZFBh7PM85GZFS8GhIVy869wdnfmBQ==
X-Received: by 2002:a17:90b:370a:b0:327:aaeb:e814 with SMTP id 98e67ed59e1d1-328156babd1mr6591959a91.23.1756716683147;
        Mon, 01 Sep 2025 01:51:23 -0700 (PDT)
Received: from zhonhan-gv.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd006dd49sm9045090a12.5.2025.09.01.01.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 01:51:22 -0700 (PDT)
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
Subject: [PATCH] scsi: ufs: core: Fix data race in CPU latency PM QoS request handling
Date: Mon,  1 Sep 2025 16:51:17 +0800
Message-ID: <20250901085117.86160-1-zhongqiu.han@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: zkun7JzOEHnjc_dDPC36XNciyDy48k8s
X-Proofpoint-ORIG-GUID: zkun7JzOEHnjc_dDPC36XNciyDy48k8s
X-Authority-Analysis: v=2.4 cv=ccnSrmDM c=1 sm=1 tr=0 ts=68b55e8c cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=af37CCu951KBZlcfKc8A:9
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDA0MiBTYWx0ZWRfX3rqLrfEGsE1D
 d08nh4jQ2Hyt7n1r9y8DlY92Gm1k47aibtI7CyMOKAM4OWjkKNZXTF1JreYVdt6OGILmAE1dE4E
 QXjeCxgMA+Z1kKo+5iLpwv4hm/zf4NZg/Vv6puWKRYqIN/ueT30vUFzef/KPjCVVCv5XfvZL1aJ
 qrbkBBLvAzztD0UdKHp/O2o2s9G0CWCOxCKx0YC1V+ENRCvBH0y+ZbJMcMgtyRTQXe2x/ETdUEl
 hEqwAgePrSQ5KlO2OfbT/kH5DgINgdIP557uBBWk+r3zxPpHf7cA3tsrxT01nOcTjJsuxzHMnzw
 x+08e8zd9hQfU+cVZA8lX9Bo2aUwZ2HAI5KbteHzSyIJb7+R7C7ctzINU4jhDQcVg2SoUd/VPmO
 mDQWCM/3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-01_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1011 suspectscore=0 spamscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300042

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
 drivers/ufs/core/ufs-sysfs.c |  2 +-
 drivers/ufs/core/ufshcd.c    | 16 ++++++++++++++++
 include/ufs/ufshcd.h         |  2 ++
 3 files changed, 19 insertions(+), 1 deletion(-)

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
index 926650412eaa..f259fb1790fa 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1047,14 +1047,18 @@ EXPORT_SYMBOL_GPL(ufshcd_is_hba_active);
  */
 void ufshcd_pm_qos_init(struct ufs_hba *hba)
 {
+	mutex_lock(&hba->pm_qos_mutex);
 
 	if (hba->pm_qos_enabled)
+		mutex_unlock(&hba->pm_qos_mutex);
 		return;
 
 	cpu_latency_qos_add_request(&hba->pm_qos_req, PM_QOS_DEFAULT_VALUE);
 
 	if (cpu_latency_qos_request_active(&hba->pm_qos_req))
 		hba->pm_qos_enabled = true;
+
+	mutex_unlock(&hba->pm_qos_mutex);
 }
 
 /**
@@ -1063,11 +1067,15 @@ void ufshcd_pm_qos_init(struct ufs_hba *hba)
  */
 void ufshcd_pm_qos_exit(struct ufs_hba *hba)
 {
+	mutex_lock(&hba->pm_qos_mutex);
+
 	if (!hba->pm_qos_enabled)
+		mutex_unlock(&hba->pm_qos_mutex);
 		return;
 
 	cpu_latency_qos_remove_request(&hba->pm_qos_req);
 	hba->pm_qos_enabled = false;
+	mutex_unlock(&hba->pm_qos_mutex);
 }
 
 /**
@@ -1077,10 +1085,14 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
  */
 static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
 {
+	mutex_lock(&hba->pm_qos_mutex);
+
 	if (!hba->pm_qos_enabled)
+		mutex_unlock(&hba->pm_qos_mutex);
 		return;
 
 	cpu_latency_qos_update_request(&hba->pm_qos_req, on ? 0 : PM_QOS_DEFAULT_VALUE);
+	mutex_unlock(&hba->pm_qos_mutex);
 }
 
 /**
@@ -10764,6 +10776,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	mutex_init(&hba->ee_ctrl_mutex);
 
 	mutex_init(&hba->wb_mutex);
+
+	/* Initialize mutex for PM QoS request synchronization */
+	mutex_init(&hba->pm_qos_mutex);
+
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 30ff169878dc..e81f4346f168 100644
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
@@ -1135,6 +1136,7 @@ struct ufs_hba {
 	struct delayed_work ufs_rtc_update_work;
 	struct pm_qos_request pm_qos_req;
 	bool pm_qos_enabled;
+	struct mutex pm_qos_mutex;
 
 	int critical_health_count;
 	atomic_t dev_lvl_exception_count;
-- 
2.43.0

