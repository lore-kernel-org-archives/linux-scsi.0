Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDB834EEE1
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 02:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775181953; cv=none; b=ZPzq9B1TI4CQwLApsFHhPJngMctbZhYbMYJ1bHqlfZKwdGFQWnXMmlBItoF1yxdRphutHbaNRLONK91LLFezoaTRVrEBxJqweBmGZtHPF3vFr199mVKVUHemHdCKwwd008UPQEEr3Y0NOiErnzO15FoYYVnbK9ZgXGwvkuXm8II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775181953; c=relaxed/simple;
	bh=laRFg8Vl52ouqOqTmm9/XjtWeqji7jAfTD7LbA4wzwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZcWQTlsEIscxQBYPr8mJ5eMO4TlB5n8yF7QA1SoTiJRox3xq1AJyk/3dw2Wv6/C3+K8Sw2thJdv8LhWqHzyCj+w/5lOVyWohk5aq50fhwYuwKu2arG3WHgoL6q4U7h020zOu5Yh50/zxQmYv6ooeBXQeeTR1VgNq7tOq0OuPfjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F9nQviYJ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F9nQviYJ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FBwLw2265475;
	Fri, 3 Apr 2026 02:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uf5gMiMhRJLigFJZhDi05RrqtyFzv37PAD5+2PA31S0=; b=
	F9nQviYJSv5FbV4gls4E3/sEBlGw4m1PAZpfCuTCzt0s75/9uXjTYPPuoPGub2G4
	6jxMR48ycARjhyxmsIALkLEqHxveQdeGLD5q81GYELeNs3T8GJ5pQBDAQ+zf6+d6
	5kpPEy47fkkcp5YJuI8jHxyPlUEr5p0+kbDDB0sljoqImsUupSKgIcBOlFmyEWz+
	e6Zr0eEZSP9E/k6aNkOG/4zKEj9mg3Zu9hfdAM6jjArUe+h8ZoGvmLmjUt78E3JR
	RMh8X7Oh9BDnjCIA+1xFEgOdE5eOtMAV5gRIaqhxwOQ7Ht7MbmyQn2/aOWFSFMEL
	ZOTTZG9BxboQI4RcJRpbXQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65w7hgey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 632NdTnn029044;
	Fri, 3 Apr 2026 02:05:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eddp6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:48 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 63325cqn017364;
	Fri, 3 Apr 2026 02:05:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65eddp33-9;
	Fri, 03 Apr 2026 02:05:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com
Subject: Re: [PATCH v1 0/3] mpi3mr: Enhancements for mpi3mr
Date: Thu,  2 Apr 2026 22:05:32 -0400
Message-ID: <177517593453.3522679.4250201367527965794.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260320090326.47544-1-ranjan.kumar@broadcom.com>
References: <20260320090326.47544-1-ranjan.kumar@broadcom.com>
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
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030017
X-Proofpoint-GUID: vAqCoDSC0x_Sb7ARBAjSUtXnxOZbLGRQ
X-Proofpoint-ORIG-GUID: vAqCoDSC0x_Sb7ARBAjSUtXnxOZbLGRQ
X-Authority-Analysis: v=2.4 cv=DKSCIiNb c=1 sm=1 tr=0 ts=69cf207d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=1a3Wal1vVWMQsUvJvugA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNyBTYWx0ZWRfX7B2SFollLX/w
 csFqPYPtiNtxREr/kH3ck2+bQlWqU9RlY/3Pm3y/lLf7C8ukxvVz3loiul8iztCyY0qbQn70oOZ
 G+A19ioKwiAHI9mlIFowWcoGFs0uoIDH3lSj+iygJXKEaZicOaRxArlTeDxBmpC8FQL0VnESPr6
 r9bcvu2bL2n4HllwzTex7Vz6kQ3Baux0yilvVsE+LEEAnklzruKWKpy1Iho6tn7quw2L4RWiWha
 1xmqFFLOEbQ6tK0Fh6Ta7tXwrQZX069DrooIbqgBtaex71y7dVjxHDhhUn98/AMNHgmUhn9dQ2X
 IshVmBz4MM/E7lml2Ewvf8Uq2aR79sN7XQLAUrJS8D925ssC2kTpMPm7tWxYYifV/ZPZKsXbjee
 E52SNbtwOhlNQn1mlQeETeKrmRn+UxAeVJU1nfP995IWzqYOl2e36Yj8rzv0/HgpxMI7BZ6JFL/
 igX8wUW5z299KJv6UTg==

On Fri, 20 Mar 2026 14:33:23 +0530, Ranjan Kumar wrote:

> Enhancements for mpi3mr driver
> 
> Ranjan Kumar (3):
>   mpi3mr: Reset controller on invalid I/O completion
>   mpi3mr: Add queue-full tracking for operational request queues
>   mpi3mr: Add retry mechanism for IOC shutdown with timeout reset
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/3] mpi3mr: Reset controller on invalid I/O completion
      https://git.kernel.org/mkp/scsi/c/31693fbbfa21
[2/3] mpi3mr: Add queue-full tracking for operational request queues
      https://git.kernel.org/mkp/scsi/c/9d660e482071
[3/3] mpi3mr: Add retry mechanism for IOC shutdown with timeout reset
      https://git.kernel.org/mkp/scsi/c/02ff1d2bcf2d

-- 
Martin K. Petersen
