Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE7325B2FA
	for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 01:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625309; cv=none; b=Yt2G+iK/rIpfcdgFmxFs0QKHPbg+Mx3bgC9G2ONKUVeSn4cqHAg1OzTOwJwSSF+3/47Of/PYyqzeNK+fygNHcewGUFJAe7GGU9h4lLwGVuOxQbE3OqFYDzQBtiKyNLG0O0V9eVPDkKUqLaz8yjwWFHEJFX9+dmV/vLGXBxIfe70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625309; c=relaxed/simple;
	bh=Gp1RnjlYD/GObEpMR8gd8910vbZ9/+0KOnquayh2mjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Km2kdoFdAB/QaX2F/r7TvropMH4YwWUogfe6fiWLQz6bkfUvpJvc105i18vF7/BJ48NlRjWoqdkOeb9mZUXGESeIAR8Eu9hdENA0+QxkN6xJUz/6lV8asO7bqEJE0Ib6nEa18vlCAo6fiNDQcbSmxp3adcWsgr3ymIuc9+lRuUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y57MtMOg; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y57MtMOg"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FMmRBv4177353;
	Mon, 16 Mar 2026 01:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lS5Nmckq8BzOO+HU/fwqkdq8Sst6mJg6TrX0okzH9WE=; b=
	Y57MtMOgZ01d1wD+bDOslPO7c9ghT9juOT31LWU3zuToJi/7RrIiW+v1KJbVmVZo
	Fe00R/vQZsiDuhmf8tNXtNOSHBxwkiiX4X5QesKmVQr+DJQ/fgRd6NHUnzZrVCOE
	yJhp4qrNhJgbgOfls98FoOQF09oMXPm8nGZhidGan4wuR1S6BUAR8yS/O0YpJhZp
	aSpgHRB/BzJ6X4A0vzTigAqibouq2ziCMd6O6yPE6cdEmp67bpDOcIV6QEc8Rh8m
	w21bI5QZqaGHdgozkICai8XBfxIMWKePRCb7wYRqFXvYAY0J8BhiM+wycNNDl8Cg
	2uvxwLXijqzqZf2dh7e0QQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cw07r9aqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62FK3b3V002736;
	Mon, 16 Mar 2026 01:41:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4j86np-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62G1fXhZ032070;
	Mon, 16 Mar 2026 01:41:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4j86mp-8;
	Mon, 16 Mar 2026 01:41:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@sandisk.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, ed.tsai@mediatek.com, bvanassche@acm.org
Subject: Re: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC command
Date: Sun, 15 Mar 2026 21:41:27 -0400
Message-ID: <177362524479.2599440.14041046227573442647.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260306054419.3816557-1-peter.wang@mediatek.com>
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_01,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160011
X-Authority-Analysis: v=2.4 cv=HcsZjyE8 c=1 sm=1 tr=0 ts=69b75fd1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=mpaa-ttXAAAA:8 a=qFATSNlW8LwFkCsGeMsA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 cc=ntf awl=host:12271
X-Proofpoint-ORIG-GUID: m3f0sv0dYCe-_QKN0X64JSSNVPJROIwQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAxMSBTYWx0ZWRfX/JXjjMWI9X3I
 HOrwuMf/93QG0JJHpBZXcHcEwQLd0YEXGvlOW/vZAuttODBe6AldVE0N3hj+96RENHW0SI0Bvo/
 jYl8JgFPISt7kxn0HaeKiFgd2xKKrqiUdGbMPmFAWpYLXXUDkwD/K6oEzQaxrhSDIn6QqQnkz1W
 6DOvEeaCnvPZN7dRG9xuu5Ah3UjQAN7Jvw9ch4+rGUusYz7W7GFU7pn4ExgbkY90TR2QGecB0oO
 fZFuGLYmRPgYsGtDvlRN+PtUI+GZElVR7LT8D/Tf/Rg2PdJ16dY9FwWMVFL4OlJQXpL70jfFmeu
 lHETD8dxqdKZuMPMIjgCzrdy+geiKbAzoJprsnnuYSbwt+LZu1KjoXV6ToRUJam7u/ECV7ThAgs
 pYA0yqT963nvws+QEs9vlIeWT2ZxWm72ZilIhsr7LW3fd62a3XYmryOp8GAElRWQ4yIL31HSrY2
 SlBHcBItl1CobqQOvqP5mpsD0wkGDXWfe8Lr8rWo=
X-Proofpoint-GUID: m3f0sv0dYCe-_QKN0X64JSSNVPJROIwQ

On Fri, 06 Mar 2026 13:43:02 +0800, peter.wang@mediatek.com wrote:

> Only return IRQ_WAKE_THREAD when MCQ and ESI are not enabled
> and no UIC command is active. The default UIC command timeout
> is 500ms, Using threaded IRQs during an active UIC command
> increases the risk of timeout due to possible preemption
> by other system IRQs.
> 
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] ufs: core: Avoid IRQ thread wakeup during active UIC command
      https://git.kernel.org/mkp/scsi/c/6475cfb81fc4

-- 
Martin K. Petersen
