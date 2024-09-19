Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DE51A08C2
	for <linux-scsi@vger.kernel.org>; Thu, 19 Sep 2024 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761237; cv=none; b=l5YWFLkYcyVjCI4OnjUlWeIJ9dSLy7jbZAAoHtKapo9mLJgca5IMmsadLToY15lkhtkz928NNholrj7gnDRaceEf+5AuPzuuukGZNxYcx5X+1bb8tAfjQulGQrrxGfoIjdu5DwurB5RbhQidR/uQjd9tiYHTX1Ov7kIbLBvMnbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761237; c=relaxed/simple;
	bh=QB897ca3sr2xDzeTcWefSsGW+wptUE3CJ9pO/im0B18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o2gQvr0WdaMOAdngEs7NbkR7vnat1lCuEYsATafiKTMcvvQF71Sg18YyevzwbsvjuSrbMLelFd7GqoGT+kchlgvTg+8+25Upxo12JO76/RORz+CbH9SI8/g6UZiC0IlGfcMgT4YGObdcRzX9OUzC6RayZI4VxVdm/+MLwP3oyio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IWhnaDnF; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IWhnaDnF"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J9PDbk015605;
	Thu, 19 Sep 2024 15:53:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=5GXA/rJ8vH6PWmHUgJIsVuhz0PYt6j/NhygOPJsJZ5Y=; b=
	IWhnaDnFmT5P6r1JgPP0NAhgGSBd8CPkXgxN+aqNE9jKL8Rof0VEaYipeE/TfqzO
	42ISWCeSZ9mzpopgk154j3kNIDw5LYYMpNU7a3Ji4XHUKKlTo3TSoGSLVHt3V7lM
	w6Xb+lJHluMYEindi1vthWWgBiuCB+9kMxc4bpPI8NV69HQdsN4zpZpoJE153WIo
	mmT2Eyco6tOoceCw9veu4M6ov5ftAgpcLWRw0YY0YpZiiqmfhmZyapLzGIhKwbaU
	hBl3e62DjMr+AZ+V81BmTXEibB1/0X26jSjwf7XJD3AEys0zB/oEWEV2gGy83DxL
	ZZyMNl9MNQ6n44669CxDxw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sfvgcb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFJt7I011588;
	Thu, 19 Sep 2024 15:53:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xj88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:44 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8d031813;
	Thu, 19 Sep 2024 15:53:44 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-1;
	Thu, 19 Sep 2024 15:53:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: mwilck@suse.com, Brian King <brking@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        tyreld@linux.ibm.com, brking@pobox.com
Subject: Re: [PATCH v3] ibmvfc: Add max_sectors module parameter
Date: Thu, 19 Sep 2024 11:52:47 -0400
Message-ID: <172676112035.1503679.842454992605986623.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240903134708.139645-2-brking@linux.ibm.com>
References: <6594529f81c043f25b74198958718c84be27be4a.camel@suse.com> <20240903134708.139645-2-brking@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_12,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: WaipykLoPXwx59PoRXJ3iPKkHDc0wDZc
X-Proofpoint-ORIG-GUID: WaipykLoPXwx59PoRXJ3iPKkHDc0wDZc

On Tue, 03 Sep 2024 08:47:09 -0500, Brian King wrote:

> There are some scenarios that can occur, such as performing an
> upgrade of the virtual I/O server, where the supported max transfer
> of the backing device for an ibmvfc HBA can change. If the max
> transfer of the backing device decreases, this can cause issues with
> previously discovered LUNs. This patch accomplishes two things.
> First, it changes the default ibmvfc max transfer value to 1MB.
> This is generally supported by all backing devices, which should
> mitigate this issue out of the box. Secondly, it adds a module
> parameter, enabling a user to increase the max transfer value to
> values that are larger than 1MB, as long as they have configured
> these larger values on the virtual I/O server as well.
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] ibmvfc: Add max_sectors module parameter
      https://git.kernel.org/mkp/scsi/c/e36840069454

-- 
Martin K. Petersen	Oracle Linux Engineering
