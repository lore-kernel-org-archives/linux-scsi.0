Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C27303A30;
	Thu, 20 Nov 2025 04:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612214; cv=none; b=kbUJOIqNAE4hwx8qxf2Ej9oEgTM6XiyxPa9+nsZRTvvQL7u2yA5gRy41TTXzstlD9L6OVLjDyagFQCaB2yIUK+qUu37lzwDy6uvTOjJ2EWfvWNRgdkeA6re9NY1tEeBMdFreUFIFr3D0g/r2O/smcTKFxA/+3Ng6kmPabDKBceA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612214; c=relaxed/simple;
	bh=FccLqvOgq6a+p3k2CatJ1EcOFZ9PmE0LHO9LIPu3N4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9xUF6WbKhgYJNI+JN0thMy58c7iR//eBD87LTj0s4b/nVnBq1osXI8yRO4qZsoJCqr2oBzJvvibVGMAkzH7DH0yuWEKHguwqmNv1AJuNIJ/405vHEFLolbV6Cq5uCG8le88WO91tMLuUqkL7D7ARnygJxD+JEp1OE2s2GDZ+JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KyctXPLL; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KyctXPLL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NOvR029790;
	Thu, 20 Nov 2025 04:16:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AmzEwQRyIArJ0bW8DiJcpINmB8SRXpNLY+aM+ORC3DI=; b=
	KyctXPLLEj1PeSddNOL/JEcNYdlFCHfmq1j6GZGiwucRmQXsY127Ytr7DTG+OjS5
	X/0LvN0W3i0Xe4Jb68q5E2s6i5ZlmKPvTV9tbCum6TddKkPn7aHY69FBLUDlRU3s
	RR2xGlTnLGRB7mUNjRPQVBS6jwSg2C8S3ZjzelYyQMDqQAY+v5ztN97tXz0nfFYL
	V6mK8ep9vV3AVM5MjiKiGZrfS8ApEeM0ORMWe+EouIy1kqcq1axcpv4XiHg0/oD4
	k5+EKuDDywYwOIwfJr/ALzWGYn7rKFfrAGwd/B1XMZZpgZiByKg+NfvQqp0nzfMM
	qccJrEIfMOAyh5GTziK9tg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968bhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK2KoeV007938;
	Thu, 20 Nov 2025 04:16:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:28 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPf012546;
	Thu, 20 Nov 2025 04:16:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-8;
	Thu, 20 Nov 2025 04:16:28 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>, Tyrel Datwyler <tyreld@linux.ibm.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: add WQ_PERCPU to alloc_workqueue users
Date: Wed, 19 Nov 2025 23:15:57 -0500
Message-ID: <176357169055.3229299.15331205438908667810.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251107150542.271229-1-marco.crivellari@suse.com>
References: <20251107150542.271229-1-marco.crivellari@suse.com>
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
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691e961d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_suGTTe_43wmAZudwJ8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: X_wEQ0XjMUXoqKS5FSxT23ek1SttkyF5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX4/nBvFN2B5YU
 PQe0bRkhKSu6RXA/t4NnqqEc9PBYZJMK11grpCQ8Y2FHrOcNDgUlaK7aWYaTg2gd6c3YQ+nwabD
 UiaJIx9Ybi14keNC1bxKJCOE381sGfEu8CJF8nmxJ4Gwc0jLge6/2gwqUTXUkoN1kbYL80S3BEC
 3l2eaCsoYtdm1NXgjyeOVF0ju7gkqA6WmVWi4rvkb19ivZLBBn9xUrc76NH0V4qQGtUq1oxcw+2
 XXMCAFKRkHQ1vUMBPKpwtqRPK/TxLns3WzAIeg6Wnxjsm/X90KfaplN09vZLqEruPSi///I6YOH
 sQ3Gw6TycsVN4qL8by0d+fsDByn12Qsp+V26usXm9uKNjuNfHG+QaHJwCnYi75SPiY5nx08qE/V
 BVLvWM35ISR0nHcNuT2Xnaz+0DCJmg==
X-Proofpoint-ORIG-GUID: X_wEQ0XjMUXoqKS5FSxT23ek1SttkyF5

On Fri, 07 Nov 2025 16:05:42 +0100, Marco Crivellari wrote:

> Currently if a user enqueues a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistency cannot be addressed without refactoring the API.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: ibmvscsi_tgt: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/42312d3acde5

-- 
Martin K. Petersen
