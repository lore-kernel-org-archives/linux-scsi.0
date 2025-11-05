Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B2625FA29
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 04:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315354; cv=none; b=fB2nR+K34SxaAKTBQMUUh0KeUWFfUxvOlSuIlPFFJPmyB3llIjjwYam3MznQE7Cl/f72hGcRAO4N5vdq7ai0O3C22bvjLv1PZ1/tM+zBLBn6xQTWKmx8uwW6CUImVaNwFZ7EiMyBauErpV+tw73z/gkMwWDI3LOG/8aV8Kx2Oh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315354; c=relaxed/simple;
	bh=9U0WPfgJwiTqQkK+K7bgffGms6czjNs40p6SqQa6kQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lhOYtPjXiJBYWp9G/0oYpZ5X9mDscdnZqPKsc4EGqWMrYv7RIg0Z33+FrSNQS0gO5Ynraqu3ECpskQDMB5jRZ7idvx3qNDHr2dil6pljKj0KOfWAQwpQgdCAHdts18xRX+wImoKABxjLKnsNbsR9LFCiNWkE3IVh85n9QR/XRm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mVr452mm; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mVr452mm"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A53pgeJ024898;
	Wed, 5 Nov 2025 04:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=t80NgooTVVRsnW0i4rezwHaMK6QNOLiXB2e7K4IZd78=; b=
	mVr452mmd7kJBjyKCSss6oFBdV1f5RzJRPaTb95N6FC5Ve8B/uR8bFpazLbDOcy5
	9ayIE3OPDlpL4wjsIF5mHwvE1fuPwFOV9VZt/ljtGBJNneUW1n6ijcVywv7YMvXp
	KT0TBOl3pQyrrWloZbFnogMKxsZqzZF7uFFv78e4HK6nVZO+t7W+4hPeTLQ4CMGG
	4X8eQUsdrA6T127Jlp5KQ7nWbG53bDWXtt+ytkqInmugyclu9eYtFxn7sWhnvGVI
	JY/kaaBys31/M9v1almdGvBNSZc192Nv4eLv0EUFnnx3kX5ih97GntRFzvlvPqeY
	FG2jqznAn76BraDs9ej5rw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7y0wr0bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A51nBoO024877;
	Wed, 5 Nov 2025 04:02:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ne15hg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:26 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A542Pri005395;
	Wed, 5 Nov 2025 04:02:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a58ne15gy-3;
	Wed, 05 Nov 2025 04:02:25 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: Remove unused code from scsi_sysfs.c
Date: Tue,  4 Nov 2025 23:02:17 -0500
Message-ID: <176231440766.2306382.579741403426295727.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251031220857.2917954-1-bvanassche@acm.org>
References: <20251031220857.2917954-1-bvanassche@acm.org>
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
 definitions=2025-11-05_02,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=740 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDAyNCBTYWx0ZWRfX3ldZyfPXrIMd
 xyU1scBnc8cXnLwWe4RnRI+q/lSiyYty31fsTtB+I9m/KzkUBn7NELZ8ZVlaeILahfh4URwFthO
 zHoGLoHqtj6GBRMTMkCaJDA6hSEMRgV68xIHxiSRhUUsZ9WQnEKAsLwtRLXrbkKAI0M6E1gDGgI
 8rtQvvLgz+p6kTZQtROjmxk6VPFdCmb8Epp0n1zqXbiheSfUm6tLTiSy/WkMggHranWME1vhwQe
 xbmZhBY88pKcpYc/eOQB/bYF9VZ095vIY9pCLDQbPEWsuMLNN2ccJqGfmR7sqvqGAUaluLFPvOU
 y0JjYZvr6sY9bdY0zQkDW5fXZq3X/scSEsWEP6kVjYJV1ZSFPnoFpBSPJEnL0a+uIEAfiV0sEQp
 pkoklRUXtSaJNP9kEDS3NpiJB9Y0+dND9K1ex4iy0WEu+Kq5xEc=
X-Proofpoint-GUID: Sv0C6Z7i6g95QkRIUFonJ5GISinNO10R
X-Proofpoint-ORIG-GUID: Sv0C6Z7i6g95QkRIUFonJ5GISinNO10R
X-Authority-Analysis: v=2.4 cv=PMwCOPqC c=1 sm=1 tr=0 ts=690acc53 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=iwiEVIA_BkjSbdBvWV4A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13657

On Fri, 31 Oct 2025 15:08:56 -0700, Bart Van Assche wrote:

> Remove unused code since we do not keep unused code in the Linux kernel.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: core: Remove unused code from scsi_sysfs.c
      https://git.kernel.org/mkp/scsi/c/61deab8a323d

-- 
Martin K. Petersen
