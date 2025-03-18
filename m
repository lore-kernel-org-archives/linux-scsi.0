Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A40576410;
	Tue, 18 Mar 2025 00:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742259321; cv=none; b=dt1hAHyiLwlKU7Mwh+5bmLNfuptR4sNZiRZRK9rV6Rg+OjDMT+5QDctxHhQum0xwptR17Y6RI2DErCXim3K7P01ejIMzzN43YZ1eIz5HRrWVqEhWvpbB5Ou3FkeSSjLnSJrsV7u5dQAGpc09IZ7Eikbp9hjJkYtyOAc1jotZwwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742259321; c=relaxed/simple;
	bh=fFiaIx4seu/Q+1sDUZsiytT4oQQSZKMn54Cnu9yhHaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kf+0zc2qKUrHmL3VsGygpcVgK6ujdRUdr5OZmeyZThpkzEdo7ynqEfxB88Dj5ztbiLsWkmLBiSOJceDU+90gyF4yUOU+xzNns9V91UjnfQVmB3cQ+dIlFynouWNf4E9UTMLVhAPP9vsNAzw8WjkbueqnYiDfTl6whFdv6LCawEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dO1Tg86a; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dO1Tg86a"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLtvOk007220;
	Tue, 18 Mar 2025 00:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=YkHv4sy+k+XKFAdxnFQNmfjpr8CgyfoTQnghAYkPRoQ=; b=
	dO1Tg86aNvCqLlN11YHnwbjilqPYgpWR3Nc9HMBTyzBh7OAV4exXZcQ5REqzQtWY
	03L8bdQHGmhj6wBHY3QbFf9+G01hh/70DSHk1Sidnc1S3iwMjYPwCZhgfzBJX8OS
	CeNd1JEYYewBiql9q0FNB//Rwqa9LhOPO2UFNiGfg21td8xUyPe/JbHk9BYyssAc
	2NKrpbp8r20T4jziHkkVPti/HrezbQRgHzO/TC0wyngNSjnoqcmOpRCKS4aLWYyb
	rJVzg221yk4xrvMkvbrIzjHB3VPhWSbhyKc4Ch/U2YVf+fKmRuzl+3Jjmj/YvKnE
	pJcSQU2sGyN+cA4nL0tXSg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1m3m4nv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 00:55:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52I02k7Z022430;
	Tue, 18 Mar 2025 00:55:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeen35w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 00:55:15 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52I0tCZC013983;
	Tue, 18 Mar 2025 00:55:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeen34c-3;
	Tue, 18 Mar 2025 00:55:14 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: static most module parameters
Date: Mon, 17 Mar 2025 20:54:43 -0400
Message-ID: <174225924957.1094535.17343674204834325184.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250309143348.32896-1-linux@treblig.org>
References: <20250309143348.32896-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_10,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=849 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503180004
X-Proofpoint-ORIG-GUID: p09izDXMQl5Ikcsatev1hpNgyz0Z4uAV
X-Proofpoint-GUID: p09izDXMQl5Ikcsatev1hpNgyz0Z4uAV

On Sun, 09 Mar 2025 14:33:48 +0000, linux@treblig.org wrote:

> Most of the module parameters are only used locally in the same
> C file; so static them.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: megaraid_sas: static most module parameters
      https://git.kernel.org/mkp/scsi/c/b79e4a2d3e5f

-- 
Martin K. Petersen	Oracle Linux Engineering
