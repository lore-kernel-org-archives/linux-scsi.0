Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57006304BDB;
	Thu, 20 Nov 2025 04:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612215; cv=none; b=SfwitIraSZjCBSY2s7fypDIKd1VQIjqc9aPPT++//Feoq9IhApMmPNrw5zEydkZ28U/MKFk7/ammCAo6FWKG1RBbThpUPL3zz2GbusmCWkJTGlDD9Qvvx3k9OrG2VIkPpki4KSTZzotkINrep02WQuBvT1xta2TW+l8H9NN+tRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612215; c=relaxed/simple;
	bh=qBOo7UMOeuhXqm3xBmZ0xsybcUq+voABCttD+tweQOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UBrRYBaIqT7UZGkJiiuH1isGiQr4oDqzBNxKd3/s/KQYPcKBEU/cY6rVssq1Hf7H1nxtTxttGhKpdstB0soULKZzfqUvS4xcsm8GJN9sAsy2DwZPofuYWmiKg6Jxt+UMIaFQTn8f3rS66Oxh99j+Av2/Wt1cUFtHwTFddzM8JgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A92U4/HK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A92U4/HK"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1O4M5030642;
	Thu, 20 Nov 2025 04:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=B3tls7xrhn7d66I4BXg0IpjP2bje7UUBvhHwfBjX5Nk=; b=
	A92U4/HKlafiQ/mka+eslI3qY3f71WPX6f771CnpEd3H0hqe8xBVsVjQOj6xf5Dd
	eRwxvYN3K1UB05E2pUdkOMRIt2CEggavqZzj9+6jtJHCSw78VK9pvoId0FODIagq
	aTYjPQq5IX+9DjpXHt4iQCwS/vIVm0M5zzC2Lq4o4O3uFcpQDEXah/WRsmhQYb97
	3D2/9T8eFgjwwGKARLiI8PswqhdA0aXnmsKeqOcFOBOVYffuNW5yp7h7iLzdwMrK
	YxCVLRn+KC9nvJHBj0uvZPSOD8AW7ccKrQsWirb3echTJYjbi8Gb4VdACGGn3P1s
	ZyXqXhBqJMj+UutN35pybQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968bhw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK3b02Z007188;
	Thu, 20 Nov 2025 04:16:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:32 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPl012546;
	Thu, 20 Nov 2025 04:16:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-11;
	Thu, 20 Nov 2025 04:16:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH] scsi: pm80xx: add WQ_PERCPU to alloc_workqueue users
Date: Wed, 19 Nov 2025 23:16:00 -0500
Message-ID: <176357169061.3229299.17905413254575977892.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251107155257.316728-1-marco.crivellari@suse.com>
References: <20251107155257.316728-1-marco.crivellari@suse.com>
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
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=959 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691e9621 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_suGTTe_43wmAZudwJ8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GrSZGH58PTCeMKZSZ_D2SCaIwr7nmDuJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXySc7bxktRmzh
 C4q5aqwxqXSFkWWoJR/GU1lC3+sqiZ/iboo44awzTqfYU6ahxA7R5hCeVmA+uBqTIufy8zmjpEj
 38x9d0G2un4CxCyiZYj0IuwXAm+5T2yQq/yJDnh7IV2P01Q3IdU+8Go3S0Mwzfeb/jcR4cEWk+H
 UB6gox4YFMLS68Z5WOx0j2ZM2PwIg39zP1+RP8YABn9ofFXTpTPIR4CASp7NUh+WHvKMNK2FkyJ
 HE7rP3gyZoTGxNsQaKxSbUaqMQNxzSaO4XhI+RAKx7nM6fQjmFU582dMeEn5ePb2Au4Xh7aHZv6
 E2HG64SzPTgUjA+Wgz2xSlY9ou8qbgLwBADKO3Yeij4kkwc7B1+wqU7vSFjomxRWMaVL1RQQ4k3
 ANBlP+1+P3oq/F+4I/FBL3Q5tNyFag==
X-Proofpoint-ORIG-GUID: GrSZGH58PTCeMKZSZ_D2SCaIwr7nmDuJ

On Fri, 07 Nov 2025 16:52:57 +0100, Marco Crivellari wrote:

> Currently if a user enqueues a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistency cannot be addressed without refactoring the API.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: pm80xx: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/8d5cad38cf7d

-- 
Martin K. Petersen
