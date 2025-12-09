Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB62B224220
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 03:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765250484; cv=none; b=BxbNqb7b9JWReoKfmZlgXe00J1CIpvx157+kLiSqSFD8SsRc+24EGVjizdUeYzCBcKtqpzkCQxQy3KzA80wuKuUJnTilgcXJUVWFrBbEyQClgmDPpVq49dbnFZjuuk7lu18zAlhL5GLr//OvwQeOIpmciuHIaui6caBg8lh6i7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765250484; c=relaxed/simple;
	bh=of/kB53Qvj+kvf2R83WkYVlKGDA6bZCKBuBIv4pmqSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cjVA5heomJULlWhgmXw0IN0r4mGwCbFKc0K1Uz0Ehd4IUvPZ3LxNPpt5Mbj1fDSLFLHfAkFygCWapY2kJV8BgD/arNuKH0I2wrmtOmyXiwSkgNreiMr4BRR4bfYLbI5+QypcR/Jgf7p7Ed3qhYhm6liK/cKlQAxMisUUyGYgCj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ps24pZ2d; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ps24pZ2d"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B92fZUk4149643;
	Tue, 9 Dec 2025 03:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=C3eo4n+tlRKM5eQDOH10nKP9tYhe9+82ICp5nyGZP80=; b=
	ps24pZ2dsGR1hL+azcX++b3YLo5sUw6Zl+VxKnkMDiqFoZm1aAzUFBTnaUAfJUD4
	2t8v28jw7o0KK7Na7Boczuyfh3td19dYRtiCz2zUvMRLsm6P1ncTyUm3SwzYoQ3L
	3762TKjvJuTo3HXNU8X0fwIhPuek6zRtCGWyNGeuWPmO9sIXLCc+9HNGYKrJJWX6
	AbTtqQ5b4BCKuY9U9iLGS0211RaStrN6UX+dYqwZgkIjGfnXechEzrnEM8f1qfOL
	YrCYTpdFLJ4gYafihbUzGlz0CkBiJXpgh1RM/nPT4uquPf4Uv/ce3QoRuKoLx2VF
	tfEjoeW+HPFRCx5uzgh0mQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axb7500r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B91Geu7038425;
	Tue, 9 Dec 2025 03:21:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8j00j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:17 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B93I4FQ022652;
	Tue, 9 Dec 2025 03:21:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4avax8hyys-2;
	Tue, 09 Dec 2025 03:21:16 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add the UFS include directory
Date: Mon,  8 Dec 2025 22:21:01 -0500
Message-ID: <176524933101.418581.14830172840666026479.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251119165742.536170-1-bvanassche@acm.org>
References: <20251119165742.536170-1-bvanassche@acm.org>
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
 mlxlogscore=726 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090023
X-Proofpoint-ORIG-GUID: HtcNM424o_iFO_hAY4-LQ1HvEUr31yq0
X-Authority-Analysis: v=2.4 cv=KqBAGGWN c=1 sm=1 tr=0 ts=693795ae b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Qrfao6EbUTu_bUgEJXsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: HtcNM424o_iFO_hAY4-LQ1HvEUr31yq0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMyBTYWx0ZWRfX3ZkxBcCfQ84t
 W86J8LdhLM3cnnwfjjC1jJXMlMXtQ0881oE+O8sd1OXC69xRPPtXsmXANukEkr+7TEuzoeMOyVF
 hgYs+YirSIw31bzXsDobq+UyQCT598IQMEQcX7fq14wabl8UONSchXnQooXZ8fo81hZuT0dkbYP
 vKlSA9LhdDvSbiRcuPSsG/nFG5aPII19y1XkaOEoPMnqJ3JAkXreKu5ehukwONqbr73cduXpCUk
 fFdK2wS19H09uzIiVR7aW+/lL9M96qNKFRTUN+93G55FCfZJK6K99MrZSrOrz6Jgb38CAbYdIyU
 XyCuqOKVJv1nRYOIqDZIIx2XMLoB/VPeZeCHtzgoojIuby2VVYBsoSR3CLnYomKZpbLIepyOEi/
 lPsj6zHzBGLeecio1v76ISzuZGRqMA==

On Wed, 19 Nov 2025 08:57:32 -0800, Bart Van Assche wrote:

> Make sure that the linux-scsi mailing list is Cc-ed for changes to UFS
> include headers.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] MAINTAINERS: Add the UFS include directory
      https://git.kernel.org/mkp/scsi/c/38725491e766

-- 
Martin K. Petersen
