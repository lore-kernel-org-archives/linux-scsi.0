Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99448388366
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776939638; cv=none; b=sXq7skQWHlUh+7ABVMTfHU8Z2t0iKnw0K8kbiLLMyaWswFKyLq7QiTWQ1tSKvLxFXgC/Z05lzaXuTyVbA8QZlkATA+5M0AizDKOTexRJ6/gMthaOhN1oxU0E6KWAeC8DMHxEhwGswnt7RFr8RxGSqL3y+vszzVLqUFkqHxASat0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776939638; c=relaxed/simple;
	bh=R+38vX2FNnuJCggvn2tdBNmfImnhD2B/HCAJZNf3ybY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ORHOlPiitnp3ZDa319YOikks5lSm0m4XyOl/t4SbdqzN05yH/akncRwWnsO7cFmkX5rZrLBZS0RbcMpfqBl7m3tj8Cml5xdxm4kInbmxEYrkZUPVsoZI/ZCNR2eUb2a/kAGULgyMM+szaW2ddG8BZ0SF2WChzbMgATDPBqOe7Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B0H8v9v0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LoqLeu4L; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B0H8v9v0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LoqLeu4L"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N8u4GC3768955
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=VyAfqt+wWZL4gBkHzohi+GbktLjgIONg10c
	KaMxDrm4=; b=B0H8v9v0JpFjaziXU4Uk46ig+haWwuLsYWI+446cpMwDSKurhOx
	QzCQ8VI5wsmQ3RNvzy/nlYYhsi+AfExGcbwUB/EE5LMpbSgjS2cFfRvppb1lt3Bv
	5yw+SJfBOC2Badxm7Z0EbDUGu7GBwQsedapTx9DGwTwGWKwmIYVzX3lJZ/FJwtc7
	x+E0dLKyAR3UZvB3cdC2iF82YbSOIEgUgslCkpkmbmDwY1wzsB8KhUxa7nQP8R0k
	53ohOdeEEwXeii4Px9AOoZtqNKbYpAONSNCh6m3rHGQDYD7Isyrp/ZNOWmrgc4Kq
	wmct9nyOSJkgvvotBWulu+Cp9VOaDt+Whng==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dq1hq3ceg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:20:36 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-358df8fbd1cso8808883a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 03:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776939634; x=1777544434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VyAfqt+wWZL4gBkHzohi+GbktLjgIONg10cKaMxDrm4=;
        b=LoqLeu4LOQsfgIJBsOv+BJJDSeOHl8LCYimAGVkulgb7GUqsepy39V9feUdYya9OgR
         Bzsl4pFa6ZwyiXbGMHwy6rH9YEaOKi1+2t9mZh8lF+JjEAVCIJtSszZIXaX1wAL/pr6Q
         JPB9P2IDY2wzW1rgFwQaIV8heUUXd4E1yWX1uZvtuS6WuOFwy9/kh80esUmS2iVO0RJJ
         GAxttH8Y1W3RDA9ym7JjD6PqDzTtigm9GD2km6r7/M186tpp24jJmFxJ/W3NIibTiiAW
         x6fi83Cz6PQfS/uZyfhsXxUFyNic70NDBQEFeEsBtFkDu/KWGoClyAS1YwyM6cMTMNX6
         XjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776939634; x=1777544434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyAfqt+wWZL4gBkHzohi+GbktLjgIONg10cKaMxDrm4=;
        b=g6Nzwc2oURVMo8FqDE7OoSKkPzYFYPiBerQcGv1/J+4hoS3cvKlBf7YNm0k56P27Dy
         GA/IcZpCIWjKB+yGf2Cqz5Nb7PLGxpkRGufdeQhcB19/qTmQLRVHEPqOLnmohltRlj+X
         bZUMFUg84mX669w9cOi1nbFNcfET0fjXAnjnHqONpWBOm7yjo9y9WySqCDFOmMM+3rXH
         e7+GXUA/5wnc8XUt9Cgawadm1rl0/dHhuwWVo1PmmSSuAkjeILt0rzoqhS/36fZM0i1C
         cLWFR5NMqOTS7jMcMhXbOygbn8GR6IcI5qDNIsS1KBo8Rs6itWuH398eCHMSRVbRPLNn
         BZCQ==
X-Forwarded-Encrypted: i=1; AFNElJ/AZQ0cVf1zME8EdYFpmc5kIhnOCGaNRhYjNw356xy6VJH6A18nIiI5pz8MB8eSrWaFtA8X3Us8pFTz@vger.kernel.org
X-Gm-Message-State: AOJu0YwePO/Av91QboIflPFfExgp7pf+0CBbNBpsOJuEuElnCm6NzWRH
	gWI7KKNm4WmTnzZE7J0nITPdRUJO4y8+ZGcRlnmIs3uILW2XpkRYDKpGJuYPmzjA54tyPjlKzdi
	Sw5z3h6Cd4lbegkPINOwirVh8gFsX9PTUpIQ0U9YPchb+xyq+p3Jc66KeaZXGqrSytFU9FAYw
X-Gm-Gg: AeBDievcmZbWDo5SCTJc2MBJQGjJM+7DoDN7OIYjMl6iPdNAKVw8GgKg8o16hkPgYZL
	kDSQ+EoMF1sqROh5hpAyBPKqcbfVv5O0kZ4Q3eFBOCpI+hYU79qfpCin/8vtg5SNlthQfBvCc0T
	xAXuGtxbmZSQMjVwrzYg2n6d8rafFQ2wn+P+RcOzLdRyFCs3OLHOLn9q1u9NqDyq94jjxK+Bza/
	LTdwseOI8oCbRmXnATZVaJrrCp4GcuT/0DhuWbXLq1Hj//BePrA584KrYFAdRwKZNp568bXUOFg
	g0dzKa5ODiOjvvPZGYMhZpuaZ7TXDgaiPo6w2xT9kPTG3Rc/nDsLG6rOM45InLP+kqsqIVtHfZO
	ycaRqgGWtYmQy60oQaBRJJ4Af17iGgdIFsVjmjHXpU+fx7AEhvJwoQAl9peLvB79z
X-Received: by 2002:a05:6a20:918a:b0:3a2:e510:4231 with SMTP id adf61e73a8af0-3a2e51044c4mr14662929637.45.1776939634431;
        Thu, 23 Apr 2026 03:20:34 -0700 (PDT)
X-Received: by 2002:a05:6a20:918a:b0:3a2:e510:4231 with SMTP id adf61e73a8af0-3a2e51044c4mr14662894637.45.1776939633946;
        Thu, 23 Apr 2026 03:20:33 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976f92183sm13944461a12.3.2026.04.23.03.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 03:20:33 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        shawn.lin@rock-chips.com, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V7 0/2] Add post change sequence for link start notify
Date: Thu, 23 Apr 2026 15:50:21 +0530
Message-Id: <20260423102023.3779489-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDEwMSBTYWx0ZWRfX7kmcJ9sJun8b
 Bxc60muJNU6T9QcNyL9gqrErJ2b8IOgY+NdEzTZvJudxuS8cS8IfrTB3k6FcD9QC78a0zDqYB8m
 9MZi8xGiKKMF3Mt7xEByS4JeSZGweDWLwjeZ9cHRLFFElc64y2dbcGLKGFkqspl9MVaCGyZlNQF
 TARLqB0BLHbcft+E/IgTOzBtqUOlCPJMUUAx9wY+NRL3FHsW0PvwnXYlja+rYCnTUHlzNCyAiCY
 F2ZOsuIoUbd63n/kU+W1vYBRk2KESIRGOYmh5z5DDkverkN3uuiTu3GirSl47FK3uj86DZJnsBC
 3lhNO+E052/zXZgTk1LuIPxii1lQXfkJNCAMr1Yt3jtMuY6sVEafbM58Bo+nqyeBR0KBY0uQkn2
 ge8mdrilDt4UwOQKzHelku94klJloCKBzJ2UeK7/INzkCSBDAK0V5vKJxDmwZ5eTL0cZEKWBj3w
 Ad2Ab5xo/4h06fn9kdg==
X-Proofpoint-ORIG-GUID: HK2VoTq-M3cuhw63lD2wnziFbIXFqRVI
X-Proofpoint-GUID: HK2VoTq-M3cuhw63lD2wnziFbIXFqRVI
X-Authority-Analysis: v=2.4 cv=TJt1jVla c=1 sm=1 tr=0 ts=69e9f274 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=QkLE9msmHX_cMu4pcKkA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230101

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

changes from V1
1) Addressed Shawn Lin's comments to fix comment to connected lanes.
2) Addressed Bart's comments to remove warning and trigger failure
   incase of lane mismatch.

changes from V2:
1) Addressed Shawn's comments to fix commit text.
2) Addressed Bart's comments to remove variable initializations and
   indentation fix.

changes from V3:
1) Addressed Manivannan's comments to remove extra comment and return
   logic.

changes from V4:
1) Addressed Manivannan's comments to fix indentation and return
   handling.

changes from V5:
1) Addressed Manivannan's comment and added back the missed tags from
   V3.

changes from V6:
1) Addressed Manivannan's comment to fix return handling logic.

Palash Kambar (2):
  ufs: core: Configure only active lanes during link
  ufs: ufs-qcom: Enable Auto Hibern8 clock request support

 drivers/ufs/core/ufshcd.c   | 33 +++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
 drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
 3 files changed, 54 insertions(+)

-- 
2.34.1

