Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9707331234
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 15:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763132948; cv=none; b=SxHlZPJPVG9Owke+VurfsTRZwUMmEotCkLFHg/8rW0jkoEv2gzWabuUfmrbAstPYk2Pf2DgkVUo17PDM1XuLxc5MnYR56loEStT2/jnV0Z0wejsXLfXA7RqNZog/6TNlftE0LH7qjgIlpymGeOiTrkha7rleW1xX+X5LjN7X7Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763132948; c=relaxed/simple;
	bh=2Tps5f1Fyw8EQWXWQD6thZKjGk5FwlpUaqUe/ah92YM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RIDPMydstn6XnQyZHeVkEuFywMe5p4ASfTuGKtxg44NicNYP6UlH/nZPFFxOurxr7P42Qf/0qoITCVZ3UDoZsdN64k8EjB+7ih1mxlEFX0smpRv+XKGYf9F80q5iImKFfslkPr9JuqFo2gBSEC1TzuOC98TuUAA1We20tt53T9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QfxLfM/n; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h9fHoHzo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QfxLfM/n";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h9fHoHzo"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AE8QZ431491315
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 15:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=g65rZQuL+DW
	NmeD3XddH64dFlYKY4T/kqk9emttSerM=; b=QfxLfM/nMmqDYpNzlt05IGvZIml
	3SIS49rg0gpKaNFQlFsoJKgYfWEehTA7kOGxr1P67GPiaXI3wTcd36FZ48Wt6dpY
	SXSonze2ITw5e4vH7iYi5vZb4Xl4DvgwUIGPMmKBfXeFdtixmj02ySDXn34CJ0aZ
	jjhjt527siatmUWsbnXODK8aGE266J7x2+Fm30S4QbpFGs2tAaEFCMBu0Z9sLONO
	VLGo5dtDi8PTa+JovBxgmP6UhaQYbT/y7zdeAzJH+9DovaZ9oxHjpDA660JbqMa2
	/DL0KlNip4J0kHn2PVUcc6wsX6PfV4zO+yxtMIYoA93bNvPWyvVG4bwc7kA==
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4adr9htj9p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 15:09:05 +0000 (GMT)
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-787ea29b1bbso23371807b3.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 07:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763132945; x=1763737745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g65rZQuL+DWNmeD3XddH64dFlYKY4T/kqk9emttSerM=;
        b=h9fHoHzohZ1gZULmDXnweZSYkajrWWKutoMIjJq4rLZOU9RFQqtBRlaRY4izsUaf9Q
         0ugreE9rS2VU5/XSEipuwr1tHMq0BAyYI0djMVLHaX4llHLzRWD/Gs5k/maaOSm4tTLs
         KRcodK914qRor8MdResGgp1IlCBhbyPAioXsUnR1RZ18cP0IbSTuFiABa7LFMiIsb/po
         PL1JjWNsAcXa0DSdgXYRi85GaDdSG6f0lXa2TDCPUrnWZU1USkbaCWguDuUxxDMqJVCK
         YwzX2pqtA9mU4w058yA0E25wkQkbY+5rS36+Z3F/iVwE18w0Y85M4YLu6W2QNXmE03DM
         Lq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763132945; x=1763737745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g65rZQuL+DWNmeD3XddH64dFlYKY4T/kqk9emttSerM=;
        b=LPl62cn1DExiUe1IkyOU1iPD/MyMteWHF2vCExHkX242AU21qjcaKnNGV6IrCNapGI
         UZw3/1oRgOoLdL5HsVyNvvsoSD7seL0o8oTV/m45PO/jVn8mteuxA/yQDDAs3mk7BLVe
         yudkee0BjwhEVnJkxhpAdkze3lKmc+ZYfqlEDwPYuWYbGpndMHf/w7XAhO1YvPvPcRUg
         SP6fC6WcZiymGRgjbrHm+R0LMO1glTA2A+MgYnwyWiYzHCf3ao47loomPNeZFvVXyDiy
         l0b7/CskdafxpREnbdQssTwGCCD7M9de9A6PJZCZOvRGbssEmee7yTzsnzwCaFfTdAqQ
         ntfA==
X-Forwarded-Encrypted: i=1; AJvYcCVmuJdi0wEdH+lpa4nskto6f+Ig84WlFe0fgOxXDpVkq9WVUZniFbBwDS683GxTomW3OLtOsZL4QwMT@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7kPBW/70+XPHGZj7eJEjB01PWQ1rEdrrMQSPG7TEvqvP3+TNy
	hsFtsTiwQXWGpsKEnS9x1i4oJ3v1DtgNBLku2NkXRFbVRrOarxwjk206iAIL2p25XzhMr2dy1rM
	4thSZA5oaDEzirE/hbtZgg8vhiIHYIE+mYVoSKp0poSrqV+/F3/cdNgLKurpJ4Rk2
X-Gm-Gg: ASbGnctY7CxA7ctS6bUINeLeIIEs/mbChjJzQ53vLl+hY8Lb19x45u5UY6RragBJOFY
	QgVsZ4TB4i93jZ6PwGqs3ZRlIDy49OBG6hQxS1oYrmGQffY6MAlW2thyC4Z2sg1hLCmDbFY122k
	YHFZ6hLoeu9jFUdHn9x8JOOFw/WZetFa9hxqEnmbBCS/4zs//AtQN3gbAyC4MumLTKDGao0Hxeq
	He6f6IDH+qkd6USvVk3/N2sEJOD+tCZHWOM3KHftzK5MM6+NEKk31s4HbaAJkdfdOoS3KdfM8Kf
	Ah+6vOgetmqIGV8OQEwTZIUOBD/jXQq1OUI2gX3VLTMk0gybmaV4kOeCh6nUUsX6WUJCWBFai5f
	HLz5Y6DYcKF1cubgivPoieDTUdejUuA==
X-Received: by 2002:a17:903:1aed:b0:295:3eb5:6de1 with SMTP id d9443c01a7336-2986a7414d6mr33995235ad.34.1763132235511;
        Fri, 14 Nov 2025 06:57:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHcURM2L9I1+OOyvpvUoXTqdprgHqwKbFhDjS5ARa2c04S0kA+aBdyLlgE7Rc9u1AAr9SgIRQ==
X-Received: by 2002:a17:903:1aed:b0:295:3eb5:6de1 with SMTP id d9443c01a7336-2986a7414d6mr33994885ad.34.1763132234969;
        Fri, 14 Nov 2025 06:57:14 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c244e13sm57548015ad.29.2025.11.14.06.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 06:57:14 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com,
        quic_ahari@quicinc.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V1 1/3] MAINTAINERS: broaden UFS Qualcomm binding file pattern
Date: Fri, 14 Nov 2025 20:26:44 +0530
Message-Id: <20251114145646.2291324-2-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251114145646.2291324-1-ram.dwivedi@oss.qualcomm.com>
References: <20251114145646.2291324-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: zSS7Zqng-exZyknNyl5_Vk4zB5-LMYLV
X-Proofpoint-ORIG-GUID: zSS7Zqng-exZyknNyl5_Vk4zB5-LMYLV
X-Authority-Analysis: v=2.4 cv=N+Qk1m9B c=1 sm=1 tr=0 ts=69174611 cx=c_pps
 a=NMvoxGxYzVyQPkMeJjVPKg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=COk6AnOGAAAA:8 a=VwQbUJbxAAAA:8 a=52jqHT57hFt4fz_33zkA:9
 a=kLokIza1BN8a-hAJ3hfR:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE0MDEyMiBTYWx0ZWRfX/Q+tjtI0aoJ/
 pAjNgH9V1oDCa7L2dtC2rHTGq2zVWtZyhFAb0Iho99g9KwJL6BMo/VqcF27Xm6KaW956l80SVvK
 ArlZ1agrTdERZLX3XcUStJ9hmhW45apM0Ag8Qw0vmMg7IREpW2A23c4JhZodtduT7xINJ4M9yNF
 ziy6PMly5s/818cE94+uaPRPs2h8l0hudWm5JgLdcSW4qN1dKFZoySHxB6u1NS8K7EnEaWZNvgk
 +vA7rYJz1HM+d3+kGEm2sznu60n6oyMGbapQzfEggYsMwiu0FCuBTeRYnlrUElZj/aE5M/sRhGo
 jl8zpDRsZbGY8gs/uVI/WuYUoS3kJO0PLKdDmDw0I16ScpVtHXVd87ohBngI62XQ4DlUhCvxISR
 snoa9qfeosTAv9DoIDIfr6KolfnJqg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 suspectscore=0 impostorscore=0
 clxscore=1011 malwarescore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511140122

From: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>

Update the file pattern for UFS Qualcomm devicetree bindings to match
all files under `Documentation/devicetree/bindings/ufs/qcom*` instead
of only `qcom,ufs.yaml`. This ensures maintainers are correctly
notified for any related binding changes.

Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 58c7e3f678d8..2d6a4ed4b10c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26574,7 +26574,7 @@ M:	Manivannan Sadhasivam <mani@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+F:	Documentation/devicetree/bindings/ufs/qcom*
 F:	drivers/ufs/host/ufs-qcom*
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER RENESAS HOOKS
-- 
2.34.1

