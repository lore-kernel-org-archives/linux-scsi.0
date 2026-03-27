Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCF03DA7CD
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 09:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774602249; cv=none; b=koW56KcNsLQsl56VeA4PW6rkUQLZ7mICMaJuQyPTk5XotEfEOsqfgIILHZCDVDoFPSysUe6lZVLmGPUODR6lJPr59OG8MmHYTKuyUI+35RJtF3p4P1uMi99sLPAX17xdcIJjWcG6X/Q6NINTmmEs38hZHeT7gE593uEuejTx+28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774602249; c=relaxed/simple;
	bh=L22x1sAmNTPfVGmo45h6OxTwrRURMxryt2366AE58cQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QIDSSmxsnDw3rCyK87AMqh8h0cWcJywn95Q+PnyqtP5SUG/rVw28UddXXuMkwXDCLeUVDP8ftyNn4+vKIynAVUSfwica0GFli0nyZRcbOjss0uXqjHTdnDzu+j7mWf1i0qvmvbQ3RKq+B0VoETRwhX5pA0Qi4V9DHzbpEkbldEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YyYUOzlI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d/NNvbYK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YyYUOzlI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d/NNvbYK"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R6w3Jr1860238
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 09:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=wUm1g75HVM1
	ePzrrQoDeo9sTJxG42J2EjNdxBe1uf3c=; b=YyYUOzlIk9vqMY6mh4cpy7bl0e0
	DIjyOWSM7552V6EA896uPxRz8YqxWhd0gl32fuwO3ZdSsoyrolbL4prfXelS5XHO
	uqCQNJygaSxwGHVzEiS/NQgfEs0sTkuO/MzHQ1lCIvcUXKRWj7EELYHn+cf5eOOu
	2wXVg2f7hTvvmRjbx8Ff0tzISPudIXDMu1wOT5HWLDoK6ZdCOZhhX1bG/8RK0D/l
	jm7ts3ac7gMdKXuSJaO0mRHQyl6iQS87Ung80gQJRGr2doInjRM8QwDu/++h9/xl
	e+I7m8++ScGNNt0/J3xrUhzmFLASi3JkLzYENUKJh0rTtoMK5HLAYoegfOw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d5bxv29hb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 09:04:07 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35a032cdd78so3922051a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 02:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774602246; x=1775207046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUm1g75HVM1ePzrrQoDeo9sTJxG42J2EjNdxBe1uf3c=;
        b=d/NNvbYKZkRfE0TzBzVWU7R8OHswSeLqksUOxyCM936FMGOMoOjeoIgDtDQbz7qjDf
         U2uhE5U5H/2rr8x9AQJUYQgKH54U211i4wAXjopnk2PZ9eIgVkh1z53oWcealkj9VpxY
         NSdRwQ3Km9lME9EBhAkyzh0dP1QYPgPAaD0NHBk1zdbW/oCo7th+Xkswje8ax4HbD2rE
         R22j6MVe6o6Prf8FyrJjxxwT49QHRDXE58Y0PfGyVHEVMw9K1igjjSU0DCE8uEz9TQTt
         YUGyXsFCQxX1TKEXOt4rLu3B8qvXEIdWL7ISo469TAZn/rRVzm2KW4LvI4YGc7i4mQOA
         97cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774602246; x=1775207046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wUm1g75HVM1ePzrrQoDeo9sTJxG42J2EjNdxBe1uf3c=;
        b=MnEFhv2XAvUksBYanI9fKuRbtMIesK9aNO+Q+SRi0wjC6/IzV+ytbRqhwkJyM1CLd0
         Mo/nMeqgK5jh8TPENdBjniaDu4/hKEIdqzjE3/agfL5Z2+YEfHw857cyk2tEVSWHiHjf
         YDs7x49ECGirhIkKeWpZH7xCNs2H42pqjJflAD0V27BOdLjOhIzDIgjNRjZeQaiL9eN0
         qwkQCRbdOBXTDIVTKUQKP0/FXq7V7fEePuxMQ8R6Ov9cKq/lc3LokJ2En9+HCVDQyQ3j
         LHBVkQhMgUzpKSLvMrzsa+CEaQteiDgdzlK/mKUFQWs0V/7WZ0t25dnqUPOSIT210SCL
         WxSg==
X-Forwarded-Encrypted: i=1; AJvYcCUHWrVzjuhl4rJKE9O0nSUQLBpJl+rWqVrXrTaozsRM7xygU8dFh4nYg74Gh4lWz5IieRGupVtMBcFU@vger.kernel.org
X-Gm-Message-State: AOJu0YyadwA/B2noWeprLOkbijTY9+tTi39InRvs0FsPBe8MUELIxyW0
	9rkLOYe7gh2SgzwR9bld5tIwd4NWYLNqAwsWpQ6/VIYFdwZf7RjwTmmyudrkxnABHGpiG1n/Fua
	ZUlXw0Pm/4cIVnds19/+YaXiJpOkIGBufbC98uHRKHV0lttMZhnOwQsBE52Tvp0fJ
X-Gm-Gg: ATEYQzzkXrFJsT9Y54sBwixDSgyyhE2eIb6tIEhuhmPZsv81F1qFRDikuGL3VJk6r7e
	5IzncEfZTnuCLE5IpShlwJfYMH9tgNBLM5OH9aTa4QfVAf0kKlUxQdGFmFhQw2p0MyxZwydqbFz
	rKflZFRf1iP4OWMn/AQ4Ci1GmudjhsrDR74zPpEi2csSFsYCcK5GUKNrjKiesgSexIh8H5e41tK
	dEi2X2gEdEWabXKV+smoK/prU1BK+9Ax99W4UvCkRt1FURQhKTWaKZjVXKP7OJae8BLJ3Ck06z/
	q1f5jv5EEEDdhWmdBX9HESYHtAY1An3+DGnAJfh/PnW59TK5/9nuktNoW5iJQqnjvg2UNi4UayC
	m9kVaSiMYD6Eu4NLU/Zeax8sgj8PeX8Ozn0NdfnYJZ/4gMPAL+O35ow==
X-Received: by 2002:a17:90b:4c:b0:359:1130:1047 with SMTP id 98e67ed59e1d1-35c3005bb92mr1909517a91.17.1774602246437;
        Fri, 27 Mar 2026 02:04:06 -0700 (PDT)
X-Received: by 2002:a17:90b:4c:b0:359:1130:1047 with SMTP id 98e67ed59e1d1-35c3005bb92mr1909490a91.17.1774602245965;
        Fri, 27 Mar 2026 02:04:05 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22a81744sm4230006a91.5.2026.03.27.02.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 02:04:05 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        shawn.lin@rock-chips.com, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V2 2/2] ufs: ufs-qcom: Enable Auto Hibern8 clock request support
Date: Fri, 27 Mar 2026 14:33:46 +0530
Message-Id: <20260327090346.656324-3-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260327090346.656324-1-palash.kambar@oss.qualcomm.com>
References: <20260327090346.656324-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=A99h/qWG c=1 sm=1 tr=0 ts=69c64807 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=gce-7N_bzMkFAa6Kq10A:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: Dy2HkA0ZUaP-aNNH7dfDAty_kaME2ZXs
X-Proofpoint-GUID: Dy2HkA0ZUaP-aNNH7dfDAty_kaME2ZXs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA2NiBTYWx0ZWRfX1MJQufWAJLpn
 j+LT8okxH1DOkJnmGBlESa5ITbRh8ucI2J70K9EIOHod452T89JWhYBeIoiZYPi82m13BfHOkws
 0wH/WlNNvot81XW7OHbcKlQr5KJPx+12sY8tEU9DuTRNkQdRI17i0yGHMR8DphlFXwetF0jEM+z
 K8RgX+FHp47scVNv6hYhhJTgPOzjjDAR8gk2vc0GQweyoXC9aAizYxXQyKKMieYINGD1GFhLoDX
 xJvMqTVeo5O8TRThCSYG0EZ4qMGpiHxcHbbLKDq3agyQmrP/rDrbAYAA7vn9ZC6BDblQoMoQt4D
 OOk/kakDp7IDNdeiGKk5FtRVKKClunDTpF6PcnWVa1gYIlQ0b6i07R0k5KKpViFPg2VuSVZuZGv
 /ny0XY4QgBjAC1mNRMDd5J0jVUsadbusB3nfRA1OB6Nx4tPAotPnTP8Y61kNX3mAGtErM1BM/uo
 A2fpdrZ9G4WeU1oq5mQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 impostorscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270066

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

On platforms that support Auto Hibern8 (AH8), the UFS controller can
autonomously de-assert clk_req signals to the GCC when entering the
Hibern8 state. This allows GCC to gate unused clocks, improving
power efficiency.

Enable the Clock Request feature by setting the UFS_HW_CLK_CTRL_EN
bit in the UFS_AH8_CFG register, as recommended in the Hardware
Programming Guidelines.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 11 +++++++++++
 drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8ebee0cc5313..0e653b34b00d 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -683,6 +683,14 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, bool is_pre_scale_up, unsign
 	return 0;
 }
 
+static void ufs_qcom_link_startup_post_change(struct ufs_hba *hba)
+{
+	if (ufshcd_is_auto_hibern8_supported(hba)) {
+		ufshcd_rmwl(hba, UFS_HW_CLK_CTRL_EN, UFS_HW_CLK_CTRL_EN,
+			    UFS_AH8_CFG);
+	}
+}
+
 static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status)
 {
@@ -708,6 +716,9 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 		 */
 		err = ufshcd_disable_host_tx_lcc(hba);
 
+		break;
+	case POST_CHANGE:
+		ufs_qcom_link_startup_post_change(hba);
 		break;
 	default:
 		break;
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 380d02333d38..f19def37c86f 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -228,6 +228,17 @@ enum {
  */
 #define NUM_TX_R1W1 13
 
+/* bit definitions for UFS_AH8_CFG register */
+#define CC_UFS_SYS_CLK_REQ_EN          BIT(2)
+#define CC_UFS_ICE_CORE_CLK_REQ_EN     BIT(3)
+#define CC_UFS_UNIPRO_CORE_CLK_REQ_EN  BIT(4)
+#define CC_UFS_AUXCLK_REQ_EN           BIT(5)
+
+#define UFS_HW_CLK_CTRL_EN	(CC_UFS_SYS_CLK_REQ_EN |\
+				CC_UFS_ICE_CORE_CLK_REQ_EN |\
+				CC_UFS_UNIPRO_CORE_CLK_REQ_EN |\
+				CC_UFS_AUXCLK_REQ_EN)
+
 static inline void
 ufs_qcom_get_controller_revision(struct ufs_hba *hba,
 				 u8 *major, u16 *minor, u16 *step)
-- 
2.34.1

