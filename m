Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A83025EF9C;
	Tue, 14 Apr 2026 02:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776133175; cv=none; b=GL/kuW48EijvZvFeNqymYlbEjqi34UOPb7qzKxfJPbSair+/uS1NO9TM7k6pJA7FOVQo+AQcTmbBKgaSlMHXhgKyTTTK3xfaCaq+4ukwure0JvC+5lwzxuOlhZjNjcxIPnLXWEcXbyy7rr/Sce0BX5OqVHzXW6+VSIYK6VfjmMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776133175; c=relaxed/simple;
	bh=XY+z507e4fk5BQpmikDUss4cL6L7pvvwxKegbAN/5Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLEPGNpdhNEPnCvnlktA+7AFPmA54garW63g3kU6TZOcazor5WMFtUuKUQfJWomX5reSsTqb261pqpKETB1t1nC5cTrG4KUDxr+SKD+32FaFofvP/tr1K2MiUMKJvU9bCVPIsqLxsZL5fNBDzdNIYXa/jiGfOSKQhsbmJRE+ld4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gx5ipQbG; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gx5ipQbG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLETW53851331;
	Tue, 14 Apr 2026 02:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GzkZCIT8bQRvayh4Hw0lMdnOXy2MQwutxZmDeZNrohw=; b=
	Gx5ipQbGHDirzOHaYYguZElrILukXr4QmI1bdKqbdQ5Pl4ebv2oZtlwxs+27sQCG
	tcIedNCc1WkLMBGkPWwQHHS5Vhb5AWmInlzb6lsFqnkjwChHOtYdJwTtmPsqxJt5
	mbwNY6USA0VvMvYfWwpqEQHHvykn/u+A5mlaZtnnvPvaB8YIjiNFCk6/qX23mnEK
	EMCyjADW0fqOJjznj+MVXKei+CHxSIugSsIRV/v/TcukayHmduSLB0oAcjRkz8S4
	5x67wdXwRkIU+fcS9o7Mmu43REb4EyJ5cLWRVtfX8IQrd4QnXjTp7kIQBpLYfk8G
	tbsyuaydG8SC9idmwCydiw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87m8ag3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:19:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E2EJq5023532;
	Tue, 14 Apr 2026 02:19:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nj0ns7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:19:30 +0000 (GMT)
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63E2JTjd036955;
	Tue, 14 Apr 2026 02:19:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dh7nj0nr0-2;
	Tue, 14 Apr 2026 02:19:29 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: iscsi_tcp: Remove unneeded selections of CRYPTO and CRYPTO_MD5
Date: Mon, 13 Apr 2026 22:19:16 -0400
Message-ID: <177595422510.3963380.2387618551172566258.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260404203003.33738-1-ebiggers@kernel.org>
References: <20260404203003.33738-1-ebiggers@kernel.org>
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
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=866 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604140019
X-Authority-Analysis: v=2.4 cv=JKYLdcKb c=1 sm=1 tr=0 ts=69dda433 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=GCFWr-IWmwxHsq0_GSEA:9 a=QEXdDO2ut3YA:10 a=0lgtpPvCYYIA:10
X-Proofpoint-ORIG-GUID: Rw8XG_HQ4wu_buWrahayxPpi80bqcw58
X-Proofpoint-GUID: Rw8XG_HQ4wu_buWrahayxPpi80bqcw58
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAyMCBTYWx0ZWRfXyLOZtcprATq5
 8WqNc38PAyBCI3KbigtsBZdfZSW0NNVA2ZGQV+2Zjtfci3MXtEwD3hTs1SNhR2qaibOmu8D9L09
 9oyVHWNrVMfsR+ZUvKsNGkZEf+9pI2lo97ov64jXMxHiY2YoTAXLatKcgB/EmCCwtr7QPFAy0PM
 tbOVFE9oGO/B9gNjvybJACiGY/PjZ2KHk4QzFGB+lk7fwCyu35rYOCNJE8DhoVUuiXs/mo1qD2+
 FWJWmUvLnJex8zA75qPv83Xv+RHflXntgvj2NFDcrnsvE92QdDoRhgM31VRqoXXD/6M0bpQC/ye
 WY+2GgliXrHMlwlgHqQ6eXDgr/e2LmNwUuO9bL8Vg7D+hxhxnTayjYZrsmOqgwU58Mk2jviBavy
 D/p82JakthLaB06RY1ROc1NjLQp7oaVj2EYIEKumbivQWGrhIt/HFUfO5GWwad2AcHpg2CvDJ1H
 7EuVY+QZG9NzAhmQgsQ==

On Sat, 04 Apr 2026 13:30:03 -0700, Eric Biggers wrote:

> As far as I can tell, CRYPTO_MD5 has been unnecessary here ever since it
> was added by commit c899e4ef96f0 ("[SCSI] open-iscsi/linux-iscsi-5
> Initiator: Kconfig update") in 2005.
> 
> CRYPTO was needed until commit 92186c1455a2 ("scsi: iscsi_tcp: Switch to
> using the crc32c library"), but is no longer needed.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: iscsi_tcp: Remove unneeded selections of CRYPTO and CRYPTO_MD5
      https://git.kernel.org/mkp/scsi/c/7aa0f56d4b48

-- 
Martin K. Petersen
