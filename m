Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18D63009EC
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 03:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765250490; cv=none; b=II5lKQ34Pq+VVohfhT9fko7RIdjXNfQgkwjOrcj7e0yl017EyVha1h98pXBxQwfuKcpElIqzP/SxW0iChQowVLWxfTHMhXGZMc0zf+UuzQ4cZDAvLTwe9SXWNkzX0DMK7ne0Xa79UYeD3uCspYTk4ax5fQtT3aaFE7YjaqngmlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765250490; c=relaxed/simple;
	bh=BmHaL042O9moQVDLtKTajwnQsn9Xrsh/nFlYUmnPlp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Omc2GuAcdxSW6H1mKPzBuwHgpuQhmZeiCSMXUdVl58WnWDqzQnJbcPJfw78iRCnVMz0yYSZ7rpxNKe8wOrBGZ4/ixvij2DHkQ6DT4XgKGR/CudX/XsB4BQqMYumX3Eycg0Jgg0SiD1HAi5tJ9V2Dp7W7xtmNhyA5j1UNsmuePNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dkhkPYsu; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dkhkPYsu"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B91gD3b3845429;
	Tue, 9 Dec 2025 03:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=w+I2Hjl8e029fTi/wV9TP+ez8nEBkBJXoh/ck6qQffE=; b=
	dkhkPYsuNMTiPk3VoWF+OQZ0EVAb+LH975NyrnFIXR2oIuNcb6MSmIMsVG+pALyq
	cBqamQ2cUzJDCaXGY8uujtk/tgX2RB5hV/RMptqjm54D3drSrKfr7Y95strnpAd7
	yOYQxMP4sdcuZg+kCAYUSyAA4I8tOGdOyf76oVY7DC/MZHLcax6/6kHoZuE3jViZ
	REjiH7QtJI7/JclJ2UOxAzU5JdZSygU8es6jAp1ueAtsId+X8Nyh3brD5G7mjLv7
	AA409KfAF0oVdMgUcqNIWMk8S1OEyarcutLHXO9zK78/xhSJy85or4c6JiCt1/P7
	ryurS5potvcU2plVi0kMgQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ax9c684n1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B90UBNd038344;
	Tue, 9 Dec 2025 03:21:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8j02u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:23 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B93I4Fe022652;
	Tue, 9 Dec 2025 03:21:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4avax8hyys-9;
	Tue, 09 Dec 2025 03:21:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: njavali@marvell.com, brking@linux.ibm.com, linux-scsi@vger.kernel.org,
        wenxiong@linux.ibm.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, wenxiong@us.ibm.com
Subject: Re: [PATCH 0/2 V2] enable/disable IRQD_NO_BALANCING during reset
Date: Mon,  8 Dec 2025 22:21:08 -0500
Message-ID: <176524933134.418581.5709310797426673581.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251028142427.3969819-1-wenxiong@linux.ibm.com>
References: <20251028142427.3969819-1-wenxiong@linux.ibm.com>
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
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=972 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090023
X-Authority-Analysis: v=2.4 cv=aKD9aL9m c=1 sm=1 tr=0 ts=693795b4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=kn0sQVdITEVxbyyqJcgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ZwyNuy_2QHG7G1EHh_F3HogH-lJK3ejF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMyBTYWx0ZWRfX/M2XokmpNpGJ
 I3t2j112WuF7cHaYLMsAfMnIfL7bNa4fcEYM4WTc09NTKdKDaZc76gYHgNwic4T/N/mAxPh4ZIw
 wbn5EN83kkLuKpNYl0qP6HhzKdgCefz3cUe45QJaH6KoYaKUnsnhrrfKuQI9CXJt0LdTG/7UKQJ
 zLyJ2jEG2CxcwCB8Dz1OG1hxp9tziYDcnCQ7iKgZ3EBmfA4K30Liu75Asc2pY/Nkd6WCG0sT85C
 cIal3VXm5MKOJt00JgioYnQyvim1oPP7qH3dyye2z0LfHv384ARru2PjNQ4KjRmPwwM91XYL7ry
 3gshFAYFPH935yT0fZ2j96ZsVE+lQrTyNGmQY8if6/5X8q9nqd9XzoWoZIUeAEGhImTsG2b2XJI
 yi+Dg6bPNzGgBBiYEnaKXWBcqlcrWQ==
X-Proofpoint-GUID: ZwyNuy_2QHG7G1EHh_F3HogH-lJK3ejF

On Tue, 28 Oct 2025 09:24:25 -0500, wenxiong@linux.ibm.com wrote:

> Issue is:
> Dynamic remove/add storage adapter(SCSI IPR and FC Qlogic) test
> hits EEH on Powerpc.
> 
> This patchset fixes the issue with enable/disable IRQD_NO_BALANCING
> during adapter reset in both of ipr and qla2xxx drivers.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/2] scsi/ipr: enable/disable IRQD_NO_BALANCING during reset
      https://git.kernel.org/mkp/scsi/c/6ac3484fb13b
[2/2] scsi/qla2xxx: enable/disable IRQD_NO_BALANCING during reset
      https://git.kernel.org/mkp/scsi/c/eaea513077cd

-- 
Martin K. Petersen
