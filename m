Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B723502B9
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152351; cv=none; b=ThjRQFXpobqWpSa68Kqd+V/9qK9b9Fb+4q6V70V8QcKJy2Cco8hrzbfY5WDZOhtAOMKzFnrF/Wf2t2ZCxtRCaBQWD4J4fGfPzSl+a8pjWxTTt03KwTOp8iuRzMEXIJMmlTAakIp+qZMp5IBlQ1Yq2veryZi9KLNaHlzr3wxhlLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152351; c=relaxed/simple;
	bh=x8W7YFsJwrSYKOKmEXpyRQobU5TTunwvLhoouBKogOg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=rrXF6uGcxKFwhPrPH7wvOHBDIhPTF7Ufjho+vw4JVBko5oGekUuXv0KQa2VI+2YQjjVI+D1EwF1O1F8m85iD3C8CPbzjpY/mdhl+jqjDEKQpC6MHihqyPwJkylBChHWQT4d7wd3QkMCoBxOX9+yt6+7uD9sk3KNkVkLBPlVO8LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=p0mZi1m7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=g0S+acyG; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="p0mZi1m7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="g0S+acyG"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N4xLcc3810693
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Fk2TJ5qtpVWF/kCIinx7PD
	RDdoF7Zuq53aiUFH2n1U8=; b=p0mZi1m7l2GChCoXPmxbGB3weR0lZjYNMg5HUu
	cOAyLGgnibk1CB5aaWLuJEVeowiLVVh0Kkdlu3jO1zyv4gdvC2fbluGJ/vCPGMHi
	zrqxWe6ufFSjeppKeYDQAMRUHquMZH2rA/yzIy9h70oy4I+gK4lyxgjYe+CIHgU8
	wgiQ36V3LSzySjqOQxM/2qWYTXmXKv2jJnxL5x8g7B7Z70U3+ljwkGKG6pOfvzAZ
	XSxdqgDvDNVx9lJ50QK0G0VrJh15aQSGVQYz3As+UIR0qGYyP2zV81iseVN7NhH8
	OEojEoRfpme7U91Yqy8+P2dD9/fvg56ebm9XjILbmgja49Xg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bujq1btxu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:28 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a58c1c74a3so18869855ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 23:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152348; x=1769757148; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fk2TJ5qtpVWF/kCIinx7PDRDdoF7Zuq53aiUFH2n1U8=;
        b=g0S+acyG5VL+GqxoQP1c+Pa+iPSpGArmU/JQl388fIjSIN0yfwXCIrgyFhhT7DBfnz
         gqa/iUIPuwMKtTd1CjYeOuP6133v63zQvVNs5E7aw2BkiMXoKQvoOYw1+a14xGafQghd
         D5axUmeViZPrDuekT6u17deebM63U9G6tZkvUf5KTSJRVQim7WXu5Xr/vSuirDK3/9I+
         DyGYHIkBQ5zzE8bWgRVs0pRdTUo2hPGdPlveAbJ+1nhDs9iibOz7u7rFXCQTcpCeemFR
         xDRDTCOydXpDiYq1BvpB5VxtdZGVyvkRvYVKJ34WCc+NekmMB96xbmDOiYQqqtkUnhSc
         KClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152348; x=1769757148;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fk2TJ5qtpVWF/kCIinx7PDRDdoF7Zuq53aiUFH2n1U8=;
        b=EirpCc/b5dbvCY16iYqhrZds8zcd4krDg7cT6/kFsi0mmh3Lfnn6wpF9yog8IvuPZX
         QBPxyxGTfd0vamXsQLDd6OD1eMoZdrdBjJ1eqiX1P7i8ij06WXYbodlxqb/r+EaEn5kI
         3tKX97LDZt8uMNRKUJqCwKl18Mm0aeKODJDGuoOPzazp47gd+IGngUdzc/pYM7fUw+Z+
         WjAVDVDPUNN2yL9r7AFGnwysMR14+ttQ2OtXBOm+d2aLWSbMkGtIqNeYVIx4bWVPhAwt
         Pdf9yjGbB/MslrP5TvpHJOsm+tA1AKaOrI96teQ9jSu57qHbndkYzx1jNxysKgJ+owFd
         95Cw==
X-Forwarded-Encrypted: i=1; AJvYcCVOkmqKOCmy5rS/fb39KKH5VW6vap6o84GEBKBDfxAgCOjm4OB0Bh2j35Vx3f9O1eiiQ9YRsZ3d9p9N@vger.kernel.org
X-Gm-Message-State: AOJu0YwFj+fYyJAbpAnH54l/Z3I8ryejSZCcgu4s51D4Wi/U4Hx3G42P
	mTG9brlwJmotTzVxg6SFlnl2SD+kVtQ/7FKslszL2xBOEW2+YG8o8oLDv/FshkF9yV/tHiHdb5d
	MH+TyhsDUo9RVtJ+lbQO/4XazvLZ2c/7xyF5ObLHNz8lv4t1SMfzqtYoLmOnaNAxS
X-Gm-Gg: AZuq6aIJ5y2eBDJmoSkmyhhFMQ0DGii3AIpwd2i+tmEvnntrXNkuM+rJ25WL7TinW+Q
	9XZfKcgBEcL83yoB02nIC2nGIiCB/2wMLTGsaknRIGWx9Nywx84hrDIPe6QXpHXpiKwK++nMWU0
	STx83waODLhlESCyTYBfL7TWs3Nx4jS9TOWrL5+OJvOW/rCyTOipGEdZNlGg7h7isdxDDQ2wYgj
	c1Bw+3l880lBGyBQmsd1CbJXC+7hl7EFH5OBziHcUJ3trtEvV2DrwRPA+la8ZkA9+uzOEWLLZ3G
	d0LfqU3T3Op7lWbG2nnHEmxG5tcwqBFYdHlYTHXcOvy7+NAgE0s2/3jMiztQVcIdo9EnW/AW5us
	wOC6DP0TaDdChOA0HJBi+hwqn8pVgz/18wez3znCcHe0OvIQ=
X-Received: by 2002:a17:903:246:b0:2a7:a653:5203 with SMTP id d9443c01a7336-2a7fe5928b4mr18748745ad.27.1769152348288;
        Thu, 22 Jan 2026 23:12:28 -0800 (PST)
X-Received: by 2002:a17:903:246:b0:2a7:a653:5203 with SMTP id d9443c01a7336-2a7fe5928b4mr18748505ad.27.1769152347758;
        Thu, 22 Jan 2026 23:12:27 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978e0sm11336775ad.62.2026.01.22.23.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:12:27 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Subject: [PATCH v3 0/3] Enable ICE clock scaling
Date: Fri, 23 Jan 2026 12:42:11 +0530
Message-Id: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAEsfc2kC/4XNsQ7CIBDG8VdpmKUBalGcfA/jAOdhibRosUTT9
 N2ldXAxulzyv+H3jSRi7zCSXTGSHpOLLnQ5qlVBoNHdGak75SaCiZpzwSh22nikg43UAVLwAS4
 0gvauO1PDZAXaViitIpm49mjdY+EPx9yNi/fQP5e1xOfvG2aM/4YTp3kaVC25ZEYquQ8xlrdBe
 whtW+ZDZj+Jj8nFP1NkU0owG6HUlq35F3OapheICeZfIwEAAA==
X-Change-ID: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: GtRxPx8yiSwrT30wS-JovgkkDpXbEZwk
X-Authority-Analysis: v=2.4 cv=O480fR9W c=1 sm=1 tr=0 ts=69731f5d cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=LDppR5yyOJ0rrDlUHvkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: GtRxPx8yiSwrT30wS-JovgkkDpXbEZwk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfXw5zhPjbwGwrO
 NSSWdGq7S6srzu41x+pwV+WoE4wRjyYJppLiryuPxDyDiUfTF73La2owq+wbsaZr7tBtFBI8S9p
 QzvKyVLsIhKXwbZiIWFkuJeYyo80K46A1zcOw64wtSsNCxLJG5oMVzuWeN/ikbtBxJzZTRVYnFv
 r56gbGWDMLJif6uoB4zmJEahfATzUFFVh+bKsb4r8hlqAOo7bdXAwGZiGj0pc9F2f+IsN02hdHl
 X+1VkkIHsqiUG79EYIj7eNewbpm9bga4Orfbs96Do5DNvYCYKaTI6pLq9V46qv/LbodO7lFl5mz
 s6UCMBuNGM3ADWPqc0xBn/kQNjueE7P1m8dcb2DChuan4wyuiv4Mqt/Oh9FMv92KLUCPXq4i6pC
 kd8NZov20a1KTWv5TCO3pJi38hCKu04VO4kfFfQgcLoC3HIlGNokxKm3JBtkOIh99LE71Tl5Sg5
 nHCzw0qDzEpqj5e2nCg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601230054

Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
using the OPP framework. During ICE device probe, the driver now attempts to
parse an optional OPP table from the ICE-specific device tree node to
determine minimum and maximum supported frequencies for DVFS-aware operations.
API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
controller driver in response to clock scaling requests, ensuring coordination
between ICE and host controller.

For MMC controllers that do not support clock scaling, the ICE clock frequency
is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
consistent operation.

Dynamic clock scaling based on OPP tables enables better power-performance
trade-offs. By adjusting ICE clock frequencies according to workload and power
constraints, the system can achieve higher throughput when needed and
reduce power consumption during idle or low-load conditions.

The OPP table remains optional, absence of the table will not cause
probe failure. However, in the absence of an OPP table, ICE clocks will
remain at their default rates, which may limit performance under
high-load scenarios or prevent performance optimizations during idle periods.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
Changes in v3:
- Avoid clock scaling in case of legacy bindings as suggested.
- Use of_device_is_compatible to distinguish between legacy and non-legacy bindings.
- Link to v2: https://lore.kernel.org/r/20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com

Changes in v2:
- Use OPP-table instead of freq-table-hz for clock scaling.
- Enable clock scaling for legacy targets as well, by fetching frequencies from storage opp-table.
- Introduce has_opp variable in qcom_ice structure to keep track, if ICE instance has dedicated OPP-table registered.
- Combined the changes for patch-series <20251001-set-ice-clock-to-turbo-v1-1-7b802cf61dda@oss.qualcomm.com> as suggested.
- Link to v1: https://lore.kernel.org/r/20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com

---
Abhinaba Rakshit (3):
      soc: qcom: ice: Add OPP-based clock scaling support for ICE
      ufs: host: Add ICE clock scaling during UFS clock changes
      soc: qcom: ice: Set ICE clk to TURBO on probe

 drivers/soc/qcom/ice.c      | 68 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c | 15 ++++++++++
 include/soc/qcom/ice.h      |  1 +
 3 files changed, 84 insertions(+)
---
base-commit: fe4d0dea039f2befb93f27569593ec209843b0f5
change-id: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9

Best regards,
-- 
Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

