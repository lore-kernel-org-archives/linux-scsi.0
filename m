Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CD0308F36
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 03:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768187762; cv=none; b=Qi6P9fd2UbssOL2/aPRzGsHjOnkyN51FoLgi5xr13YkXJXbAGNyJCBaUL1k3xeJ6kQkEIaiqrNsAH6gwACduBFOS5otQUfM1oLfs8q9ACd8Hyz5Rt0GlzJ3laH+PWOsPr9yKAMUjprlJp4jyYWhGdCUTDy9hMrl1BgkLKVvBZec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768187762; c=relaxed/simple;
	bh=kINRXHQLPIwgfy4cTvzO0OzHrHd74yawEpbqmuaB4p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JRcBuJknVWr3oidTr6VopAIy7nB9KSWh030I7CF+7GxWQRcNWpNZ3olX9rBHFwb2HDQ1Vwg7iczPYhUuvbds12+vSTLuL/SBos7aTBNihXaZUu/+hWVAWm6/NPK7uYXF+RZYf1VpKL40sL92AHvArh57RGP8QfE4lKCONyRnVL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iAfBDKiI; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iAfBDKiI"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C250Ov084657;
	Mon, 12 Jan 2026 03:15:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gKzc4t9C6DTC0z9RlK5WB7cz6C2QzZvuhdJfT02XxU4=; b=
	iAfBDKiIMlnvKiDA1ddTkarAefIiuH5FzRIXUtwPFuDmhu4axom5r1UP2EA8ohox
	rqErFMeXYHT+v632tDx3zl+ToLMHwJVkfOY9kGDcVzLI1uGMabIRFbxzQhPmeuL5
	IxdJ1/wYidLdvgV3wMiwMqnzgGcF7braJzgccn1PP4Iaf6c1rdJDS/0lY2yTVTKo
	E1A7ZSD7XcpvsbMZQNjYDYSlRfKPYO7fVCu407nzrXHaTOKm75zgDolhx0T3N47U
	6+Y9ReDxDDz8Fz6hx/Gdjq6a/NYfRYtkLu7Tv2yvLOkkdDYLgPUfUS/ga2tk/MRy
	tfkaTc511+cqXxmkG72EvQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre3ryac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:15:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60BMo56X029146;
	Mon, 12 Jan 2026 03:15:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7gnqsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:15:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60C3FaCm019952;
	Mon, 12 Jan 2026 03:15:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4bkd7gnqs3-2;
	Mon, 12 Jan 2026 03:15:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: ReBeating <rebeating@163.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sbp: potential integer overflow in sbp_make_tpg()
Date: Sun, 11 Jan 2026 22:15:33 -0500
Message-ID: <176818268036.1966853.5377578311736769603.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251226031936.852-1-rebeating@163.com>
References: <20251226031936.852-1-rebeating@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=947 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601120025
X-Proofpoint-ORIG-GUID: 4y56LUAzgDx0mzLXwp8Joj-7wPdmmzIB
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=6964675a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=eI0pgFUfYL_bNO_LkIcA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyNSBTYWx0ZWRfX6E7BhGPJ/QM9
 qxFlO8eiIdz7CgJCZXV1FBQfy30s7L27trTeT5u6221u8sfNciyHoHq9FrDsA4nxlr9X6eNJblG
 L6+U5AxljCbwLE+a+KfnUhAWTdOrSFc4XXPy4yMzZLDAivBzXZDzREJxq/TLosnIvb5sirxIUjF
 hq5NQKQ1YFuzZvla9hSH8qMl8uvbfnYnd3ziTVqId4AtAbNtEfIptAKu4TLS+V9G0BwWjxKf55o
 wpXMm5HO0/n3v5VOKXUMaFZknKQP7e4q1UDbvjZa6qxiSbgPFby3QuG5fpFId/Q9Skbm/eSStP9
 XNoRHVk/lfMjamECfjZvtnN5sr/cXgjUEqUolL/zvcNzKb+VAOpbTxFlEj8w1cf7i02+JwufOlk
 dG6yjDXoIT/WWhKQk9QUsUpZ/7KY/Vv53A+6ICk5NwKYQsUAEI/WWRUIOWeV7ycGBWOGY5HFF4O
 DopRy48Wjc3C+GuYYptD59FJsIbK6DvVWTRubfjM=
X-Proofpoint-GUID: 4y56LUAzgDx0mzLXwp8Joj-7wPdmmzIB

On Fri, 26 Dec 2025 11:19:36 +0800, ReBeating wrote:

> The variable tpgt in sbp_make_tpg() is defined as unsigned long and is
> assigned to tpgt->tport_tpgt, which is defined as u16. This may cause an
> integer overflow when tpgt is greater than USHRT_MAX (65535). I
> haven't tried to trigger it myself, but it is possible to trigger it
> by calling sbp_make_tpg() with a large value for tpgt.
> 
> I modified the type of tpgt to match tpgt->tport_tpgt and adjusted the
> relevant code accordingly.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/1] sbp: potential integer overflow in sbp_make_tpg()
      https://git.kernel.org/mkp/scsi/c/8e8e8e7e8406

-- 
Martin K. Petersen
