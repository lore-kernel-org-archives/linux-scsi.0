Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0062926AD9
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 03:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753412474; cv=none; b=ZLqyIo+RjctlmhyDntLYbWTpa4I2N4Fjf3eM+ahbTAHbX9yyXMbZ/IFTj5M4O9zPMVBzIeCsYXTMNVVNj/B7s0XGiwjmQs/dWi5APY+GUTPelIDyXfSB54Yw5Y/2py6F7HvB5xg2e2gTNsM7ZUPeGkCkcMHG4VDnsJY71+XBfZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753412474; c=relaxed/simple;
	bh=Mls13PSKnmMNBXaawotmnWL/RG00h73cEGc8u6w+p0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YYYdC50iM/R/0x0j48HueTnhQvBmPShvspj7M3hlGYbHWK1oJboq8kZsHrR9lbsSJkfUSKjtgYo32Y6ibU7/ohkbsHUjyWxRT6O/F69qPpcdgd4FBEfKEZpr0ac3owFkNQWiejNGpMj9ouk9p+yz0KaRj0jjIK/NbnCjYODxwBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OGOVH0lV; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OGOVH0lV"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLjkHw004433;
	Fri, 25 Jul 2025 03:01:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=88BU2XGlT3aOq7QraDHNHR7cCezhn+MBFGQR1XDM+kg=; b=
	OGOVH0lVzhmKaVDyBqliQCiLbGgt0pYgGVOnIvN4W03V/+9UFkOn2zmN9M+kY2PP
	L+yLopXNUFEtiQT5wc9d5MVihTmmI62YEGpptohinWokHWVTrF7heDVApzZOpSkq
	WCr3kE12yJYl70FpSgoWL505awE+Ef6Zus4SmHdHl2f8kP/bFbQCIWqID1RYy8ak
	W3epW5BBhVW8p0IE+CxCE+7+LefQo2xC/QzHrUVTiTEM7kcv9xmh+RukTzf5QKRp
	zn7rrD10k19YnrImBuls6fNZxyxTEfknRWX38pNBleexdp7iiEKYYqiU8VvUjRiU
	Uo7N2gFlTEPJLJF0MZzT6Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1h07wj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 03:01:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P1dYJg006055;
	Fri, 25 Jul 2025 03:01:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcjmpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 03:01:07 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56P317Vr037766;
	Fri, 25 Jul 2025 03:01:07 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4801tcjmnp-1;
	Fri, 25 Jul 2025 03:01:07 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_transport_fc: Add comments to describe added "rport" parameter to functions.
Date: Thu, 24 Jul 2025 23:00:55 -0400
Message-ID: <175340373564.67790.16348890482832394415.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250721164652.335716-1-emilne@redhat.com>
References: <20250721164652.335716-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_01,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=993
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAyMyBTYWx0ZWRfX9lMx3skM8Ryo
 1LVTW7mZ4Pj5FZgDJTn7v/E9BFpYuC8wpPBsyYotxIhvULXhzFkqxXKXQONJWNRJI22+mTNdqR6
 SfF7ScHbn6fPPA9FWnIlyBbNcQxOrJc1risDZ/PYUxPnIx7+v+DOJ03vrSWhAnOruJw4XC4ADpV
 GVFW8TDcZwzNKi4H7amiQMoKoYJ8MMZciXf42gRsFKEOj485TVqrgoMA8pv1OSO/09XskzxAQmj
 z4rf6hYxK5EDMLEgiOOuHDpZ3LVgVn0+OcdbSTa+yvdeZjzemWVvLKE0kpCyoFcygD6331C8G1L
 MPcGIVmhzkDQea3d+UXoFndl/nRo4LcQcRqQsKdp3n78oqIIx/OX9E/Evru799hJlFDto9aeCic
 qBqFOQccUZxZ1ck9EP/+fwVsAfD3jGFDDM3Bkzn+M7ZJ3gJRLPkh5TUQH0VLBZL1vxrCfRJS
X-Proofpoint-GUID: 6N0bMJyTW6tQxQ6J4tdlXgCLEh4bXNTR
X-Authority-Analysis: v=2.4 cv=RIGzH5i+ c=1 sm=1 tr=0 ts=6882f375 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=OworoZ5YlB6LNwypbbMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 6N0bMJyTW6tQxQ6J4tdlXgCLEh4bXNTR

On Mon, 21 Jul 2025 12:46:52 -0400, Ewan D. Milne wrote:

> Note that there is no executable code altered by this patch.
> 
> 

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: scsi_transport_fc: Add comments to describe added "rport" parameter to functions.
      https://git.kernel.org/mkp/scsi/c/603e4dbe9146

-- 
Martin K. Petersen	Oracle Linux Engineering
