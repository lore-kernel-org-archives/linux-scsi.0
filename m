Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A3A335559
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767706830; cv=none; b=mWMbyoWfFqtxKiTDnOToxIbRAnp5NwiRk66W3DfsgGRbIOfTYljF5jCw/PtM+vpRY76TrUMUjgAG1wo/vPADBjIyEQUH1VKRor6oKNasS+E46EswDHqAdqCs60DA+Zb/bbHvd08xqtsI2VhWy6q20bd+stdmFG1kkfzYkqsOU4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767706830; c=relaxed/simple;
	bh=n/olLfZ4nDPE0Fc/nYoIgrhjqAFOMhm0RkBbmAj4e+k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sKSCujNmNOTNrnPMPs9MMZxNN2dk7j0QRJYHZ1dwzoOicIDEn3Kj44y07kqFmCc6skIJ6qO0iPZpdRfEME5cLl83z2Wrpqj8Z+DxSYiiR9NQXcY2oiVwQqvj/nawRkWCu5pf93n0QKhQLRbz5CSwCFiEOqXJS18LbCT/LHSBets=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QVILRhxJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GthBDPoD; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QVILRhxJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GthBDPoD"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606BfMfr307825
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 13:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=YaxEWXLeS4I
	QAnQ85ZZDFxXJrHCM2rSQp1hb6FjV+/I=; b=QVILRhxJ802/Iu/rZuFMWlsVIik
	x6sytcaj7queG6ZfRC+C6ltFHLlI+FjSq+juO26LSyyINlStscr5J+BY6gD41yGi
	azueXlSwXweuQfbE4/M3ScIIOvYaz8DuLuTmw1t5CRuPlp2qp6gBGtBd5/t2IXgd
	0u7m+qQx2KHOpH+R3G9o4aiTdrFTNb2Pm7hEwvXBzJKSr2rE2eD5QBoR2vWuZEhA
	FWM7EaAjjwROh4XSNAEJlHNxuiFw0Ph3kQrbX2NK/GugOahe261DeqsGFVhWI+R7
	R8s70pZfn6B/FX7/MEugBn1jYJUQpISbgmx0w64H7kz0+9RQE+zX4V4OsaA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bh1r6gah3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 13:40:26 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a089575ab3so12900155ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 05:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767706826; x=1768311626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YaxEWXLeS4IQAnQ85ZZDFxXJrHCM2rSQp1hb6FjV+/I=;
        b=GthBDPoD8aM2K32Eu09O+xaWE0Lcad4hHrqqetD6ckaM73iJ7/mLPUII1YLpEqPpRw
         jbSsz+VGvIayHqvpNW5RitQ7ezeqZ5ilaBkOu/5Mhwmpl47WuTreUFMQeElQkWr3ZoiC
         OSoTRf9LmqWpLjW013E9FifIXKEWW/HlkZRSY5zBHbT2QtfvXmvBKOnkWD1izc5J1YRh
         l28B2i/lmO+s+fI6o8Y91n7XTB5oYiBTwEHoxf7izSsgNJyIIAwu/TqL4OeGFMzdDVpT
         b1CtDL1eH1tb4C1htAjVyPaRMwek4mAvnhkseAoza3BKKFQKOl9yJ2UMG6PTKS1eF94H
         3yUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767706826; x=1768311626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YaxEWXLeS4IQAnQ85ZZDFxXJrHCM2rSQp1hb6FjV+/I=;
        b=uYou/0w+fNwLv51aJR+bx0zuefOnz1xrkAzjpYhUdlmRtjGL7s1W2XDQCEbHD1tpiB
         RUm0iqXunJw5zJzmty2PRWjr3ehZvpQWct+jAdv6wFb5b8qOa1OQ+AJn1GjY/LhmHcCB
         yIe0j9MIsaXH6hVt/qpsXfuZcxhJSu5unC+z9r9CdNLK7XNgqKJp3I39Pf40OkdkwEBj
         Iwc0Hlbu2oodpuAZdSKjmLwne8kcLTvCPWLhFAm+ombZxw3cve6lqopf2hTqmBDlulcz
         MgIfquwy2Y4sLZMQX0Xczm9m50VNEL4Lo/YLKcYaTq0vQtbrxyqRVzrRdV46vaA0j22F
         LSeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpfFHFIdvzJv1gU6/fpiH5J5roRKNdYtl6V77K3LdsRdXgXG1BzGoZHDAHXSvsZvR+4zBKVEL1+5X4@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy/CyjHhWIPsrUMqV0CGzmv+KzB5lQ4shWnLACyTpfB0Fq86ac
	s2BwTCAcn0wRFn/HR3/dMrhDXe+Kq8XNyb6kjSlF5j0IC90/U8wZhAbqC6eBIUQZY5f5oFo9Mur
	uoxyUL7/UXHJtP2bYA4CgWQ9B6Gs5ABoOTeyiB1Qjc3jTT2rbgIdGfb08ZsB9zV3zGSsoZL13
X-Gm-Gg: AY/fxX7iyhXa47/TTp79fJ4O9TK5E7zMjFFqgz/KrtLY9DykYG1xMI+iASSuAZbt9uR
	4GyygHsnzSMk6uDBiJ258YM3dgPE3NBiC5SfCkciYiQ3K8tHQXaFEdMpwQ7MyhyT1JhsS6swaqw
	scbCUaxGeTTgMaVwKD9r/avwE80zp+1SXplCayGJ3f+3jl1eU3c0RJajhm/6Qd7vzMan6RT9QW3
	+G7PZerr8qH1AdE5uuSzEqsqbzwbWpN8K0iSdhFzD9M7bTJ1z3lH//ZflKblGFiIyoCQXvn2Nea
	Rr4wyMSjtFWXZJqa1KVM2wuztKMFYZLDVWDXKHOLI3l91QKZzgHfNrG7Ux54h0LEDbLgrtwNx7K
	J3NHDhTHedFbVKYiRRDIRtP2kAXnGrrfwaXPOu2L1
X-Received: by 2002:a17:903:198c:b0:2a0:9028:11af with SMTP id d9443c01a7336-2a3e2d3af69mr30779665ad.59.1767706825605;
        Tue, 06 Jan 2026 05:40:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEieAkNkfzs8koh6Bg3dTEFf/GMuiBcAv0H5vh5UdFiILgR30s04bnX1DVzy3oeidl5YUx4Dg==
X-Received: by 2002:a17:903:198c:b0:2a0:9028:11af with SMTP id d9443c01a7336-2a3e2d3af69mr30779385ad.59.1767706824996;
        Tue, 06 Jan 2026 05:40:24 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc7856sm24112515ad.68.2026.01.06.05.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 05:40:24 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH V4 1/4] MAINTAINERS: broaden UFS Qualcomm binding file pattern
Date: Tue,  6 Jan 2026 19:10:05 +0530
Message-Id: <20260106134008.1969090-2-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260106134008.1969090-1-ram.dwivedi@oss.qualcomm.com>
References: <20260106134008.1969090-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: BQV2BmzQ5QKR2dWZreb8QeDJhTA88J2k
X-Proofpoint-ORIG-GUID: BQV2BmzQ5QKR2dWZreb8QeDJhTA88J2k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExOCBTYWx0ZWRfXz42ndUSCt8R0
 bfatumJXTxeHaIc86zCnatL+DJWWiKJM2t8UuxIES/LJrEYjdQoeX+NHDgCmsDz7SOmdvH3qZqF
 NI1ELAlHNRvwfhqsOJC4FA08FQxL3ffAQEgk+CYMZ0x9htXo+cFgns5Zxic42D4Hxr8zuGaJxc+
 4k/5Xj5LvXUN4a9oEbYQogVC+3oP9c2OpunVYkzDmcgCbgu8I7muE8uSVfPaDW1WWvvMNlIC+A4
 lCg2IHIoJMmGQCJX9dvx27VzlZWNClm5S07nqE8yvYxNfDSiPQLCTr1PpmHokuSJKegD8VQjAB4
 JdazmC1px4JZAqff4jxZv24rpXWo8X6F2WfbjqFf2fYujY+qT+49N8l6hfeAu1rYnnF6Tm2McuC
 y3Vu0rs86mW1JriOFw1anzZuEwLufNNekU05+ui48grYQUhKpw2XoE6wN3GshWGENcbO5r9kaM5
 kwZp+fnRlLmz/ElFTkw==
X-Authority-Analysis: v=2.4 cv=Ctuys34D c=1 sm=1 tr=0 ts=695d10ca cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=52jqHT57hFt4fz_33zkA:9
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601060118

Update the file pattern for UFS Qualcomm devicetree bindings to match
all files under `Documentation/devicetree/bindings/ufs/qcom*` instead
of only `qcom,ufs.yaml`. This ensures maintainers are correctly
notified for any related binding changes.

Acked-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0dbf349fc1ed..70c43fc74401 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26842,7 +26842,7 @@ M:	Manivannan Sadhasivam <mani@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+F:	Documentation/devicetree/bindings/ufs/qcom*
 F:	drivers/ufs/host/ufs-qcom*
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER RENESAS HOOKS
-- 
2.34.1

