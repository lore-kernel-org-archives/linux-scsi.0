Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0300117A2FC;
	Tue, 13 May 2025 02:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747104549; cv=none; b=iZPxHCQoKlX6N/0lnGY8U+GFv6vA5vhwArNeXJsgv+hXcyQqCr1ZeWsfjiQDmcB6id+sDQU6q0Jsxe5fq9XcZldU6LqqoyUHopRFHiQj2zRAQh5/Iff6/B60ZqVeJlbIeN5GyGP8x/wsxpK+nXRRyM0viX//+YMrUda9ncsQKfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747104549; c=relaxed/simple;
	bh=/B4TIpksFyTrA1zOwhGtBlYy6JPQDd5w3k1IHXFVLmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwhKaG2FzL733WIgoDiaRA/xIuXuu9i+TnaIC0fY9uY5VjYP75ts/bMr0L3EaZWv4QIbqmj+KTdLZT2hXyNIw2tTcAEVZ/K3liKO39x/v4wWBxRyGTFmSRaSLFPJt3AksBujsMw7ICM1Xz/lg/g7s1bS0IA9hXASKTpFePMqKsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ha815Avw; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ha815Avw"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1BsI6002821;
	Tue, 13 May 2025 02:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4XjneJH5/AI6LJLlpYHIeJxoakEi0qTFzDaq5/3qncw=; b=
	Ha815AvwUHl227MlSmRlCmm0jjBNZPUOIgVdPjvmQzPCsxGAkfvlwxjip1xTp7eV
	uYcH8FQAQydiyL7++9J3B5ZoZMGRUmPClWLz7N6PHtNdVAw3pR3QTEkl+YXDtjBD
	XSYsWfbWFzCLB55u8c58RCmgZ5Pcx5iGdoczzetP6qXG1P27KEgb/FnclTjwZAxV
	5h4PX+Y6y0PZA8EuRRLNoHqreClpcIfElhmM0wCq4oOztyHIKGjQNTNm8eRBiM/p
	6F6BQo8HgFLQf5xpp5AYAgvy4/z22A4UQjSvu06QG4D9kgKF5eYiNxWCUOMAMGd5
	H3RiAoGl6NCZN2WrNFo7Rg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j059uvd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:49:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54CNl1tZ016039;
	Tue, 13 May 2025 02:49:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46hw8841j7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:49:01 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54D2muXC003994;
	Tue, 13 May 2025 02:49:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46hw8841cw-5;
	Tue, 13 May 2025 02:49:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: docs: clean up some style in scsi_mid_low_api
Date: Mon, 12 May 2025 22:48:14 -0400
Message-ID: <174710241027.4089939.10415462985305888673.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250502015136.683691-1-rdunlap@infradead.org>
References: <20250502015136.683691-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=833 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505130025
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyNCBTYWx0ZWRfXzQ8K9ZAi+G0A Xu8xwfeDJVbnVD9BDwZLFoMsyd2thgCPEvfepRu3Gu8V2+aNcCGZCwWocF8GYXgxEmBlbu/v1OS y4sPuKQlYv+Qm6YGku2N9p7+fpolGdsN9kMofFszENpIjbigw8vUOpqbzPy9TZT1L7SvDM4H7Py
 qfVtW9OwFbuIOvQiCBKYdF2St0OxmobJEkOXVy8Tdmq0gzdHYMN5MZ4n3oqeEWbBI74VcBslFYY RGu+FWnC47TjOGYpW2oHNUZfox1k/AHcJaLIrbrMXFFLOwzgKchyi3mlwn/hGf9HjmoZ6U+fOcu IbQpryBTVwcEs2jo/qyg0/v9gH37AsGx54+600pViNFfHIOQ7crDcwvvr/aS49LCyP5zFqUrwVS
 ULo4YBmM3Fa18YfJTI7/F0zQvlTvm+O3UT+GPO2pJmhtvgT4+KTV1I7+TwESIZiBQyR8MZ0e
X-Authority-Analysis: v=2.4 cv=RPmzH5i+ c=1 sm=1 tr=0 ts=6822b31d cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=zGV4Fc0G-G8a24uY27UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: g8KlBiaSwFSobU_Ngzz0KKzpQwcfsZak
X-Proofpoint-GUID: g8KlBiaSwFSobU_Ngzz0KKzpQwcfsZak

On Thu, 01 May 2025 18:51:36 -0700, Randy Dunlap wrote:

> Capitalize Linux but not "kernel."
> Spell out Linux instead of using "lk".
> Hyphenate "system-wide."
> Hyphenate "32-bit".
> End a sentence with a period (full stop).
> Change "double linked" to "doubly linked" list.
> Use SCSI or scsi but not Scsi.
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: docs: clean up some style in scsi_mid_low_api
      https://git.kernel.org/mkp/scsi/c/73349697fd99

-- 
Martin K. Petersen	Oracle Linux Engineering
