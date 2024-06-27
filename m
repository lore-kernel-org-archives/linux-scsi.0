Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FC1171B6;
	Thu, 27 Jun 2024 03:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719459472; cv=none; b=dBNSfDhrnOmeP0MY3LgsFUK00J/SYYtQ/4sedPU2zOj274waulQw65pXLG099jKAl66PRh+wKPwTsx2+ohp7PV0IAEQ+I6cotwA0KbcOiF085jD/KuAjrxVUufjC73yXPJa7B3x2RJv8+Zy/aSR0VwfqnQmSP5PxK6Y8GkD7LhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719459472; c=relaxed/simple;
	bh=0ctTLc1gOa3X5ypY3vb2iTsmCTV8Fs/g16AnX5CYyG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eRZcb0zJqkxwCuqHhjVunTVHAhIw+0CKByszu9YKdt2PGQObQo/+ph5dRk5fkATDZg2BNz2z65qvbnfVitic6Wy9j8V+CQISa/jnGzXZRPLnUcrsOh/bGpEfvjZcOKU6JgjN1sY4kvY58pjEjLA/LueUZ9VsvlQ/VkO7fxcy6UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LFsMQtzD; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LFsMQtzD"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QLMtVb011191;
	Thu, 27 Jun 2024 03:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=gZCIqUdsRlF4jkuGcHN42qFJiptbarME3rW3jxaP5XQ=; b=
	LFsMQtzDXd3LRKK/1wpNKwfJFCYOZ+1tSyGxmjErKs26UlF7fuSiN1elXOrerOcA
	iPj0qQkAFb5DSBoMIxi4EkhEiV0LDKJPfcrDXRyzQA1GNwugSteX7fwP0YkMGZjM
	PS04eGZykuv0Meqa04FGrcypdg0AW7ofe5o4N59dtKSFdSnOOd7UYrWJMuQSAAwi
	K27eirc3aiiFKij71y01qra++Qc6BCsFRdL26r5WCHC1p30HFr4wxwlcSpAi2HyI
	iUssDdJ2IhotM1GsLd7sdZNUVIOXhT4/6k/hWnPYsKJjKh7dHTjU8hRzrXHe4K6V
	0fQ2jni1buRcGcRAYyfxWw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywq5t4xfc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:37:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45R1LngZ037140;
	Thu, 27 Jun 2024 03:37:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2ac4dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:37:31 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45R3ax0B020028;
	Thu, 27 Jun 2024 03:37:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ywn2ac4c4-2;
	Thu, 27 Jun 2024 03:37:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: john.g.garry@oracle.com, yanaijie@huawei.com, jejb@linux.ibm.com,
        damien.lemoal@opensource.wdc.com, Xingui Yang <yangxingui@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        chenxiang66@hisilicon.com, kangfenglong@huawei.com
Subject: Re: [PATCH v5] scsi: libsas: Fix exp-attached end device cannot be scanned in again after probe failed
Date: Wed, 26 Jun 2024 23:36:50 -0400
Message-ID: <171945940411.1436776.443944070004554375.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619091742.25465-1-yangxingui@huawei.com>
References: <20240619091742.25465-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_17,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=886 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406270025
X-Proofpoint-GUID: 4SczOlptWWl9kAeQhrNEMIhN8a52SVxc
X-Proofpoint-ORIG-GUID: 4SczOlptWWl9kAeQhrNEMIhN8a52SVxc

On Wed, 19 Jun 2024 09:17:42 +0000, Xingui Yang wrote:

> The expander phy will be treated as broadcast flutter in the next
> revalidation after the exp-attached end device probe failed, as follows:
> 
> [78779.654026] sas: broadcast received: 0
> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 500e004aaaaaaa05 (stp)
> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> ...
> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> [78835.171344] sas: sas_probe_sata: for exp-attached device 500e004aaaaaaa05 returned -19
> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
> [78835.187487] sas: broadcast received: 0
> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 500e004aaaaaaa05 (stp)
> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
> 
> [...]

Applied to 6.10/scsi-fixes, thanks!

[1/1] scsi: libsas: Fix exp-attached end device cannot be scanned in again after probe failed
      https://git.kernel.org/mkp/scsi/c/ab2068a6fb84

-- 
Martin K. Petersen	Oracle Linux Engineering
