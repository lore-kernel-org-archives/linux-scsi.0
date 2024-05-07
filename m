Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1D08830
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 02:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047287; cv=none; b=XIEvGr+QLJqpj/h6a/gcn7Zo3yUs07dK0+TjdcQQaLJ22hLi1gMu+KvU5QqJ9r89D+h3vcxZzskUYTwg2bE3c68FliG/BFYuhdgZ5/p8bvJALzHuQVeXE/UGz8tRnmzUSXEfTwgHmiA9buRQcPK9WvKAkfMlAM6fnDkvnOfxsiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047287; c=relaxed/simple;
	bh=N6gcn5pDst2jTVUy2VtwpWooKLNexlTpB4S4my8VwCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ENJj9QNQnz6WCcxLm9mP2Efr7HqZvJmfcXflWhNS28vcVzS6/m+ha8mnfgXCZucPvHOctudL9h/o1H0R1PLT9MMyvjO2lLKhwskeYpqJ++Za71iGe/6AZ6eYZXBN7n+rMqANIj+gTP3LhhelDd4dJ8ewYpDHqwzSteN6UWzGyZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MO9uPe3r; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MO9uPe3r"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqIhC031187;
	Tue, 7 May 2024 02:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=KXCiWAnmLFUubjL4NIUuUrZcok4wg0q40JvqpUaRdr0=;
 b=MO9uPe3rdeM6V2SR8J9VVpjAfuFZCI+jNUmXSpfUK8s0Zbnleh8M+gm4F3GZz4ezdPt3
 P2lgT7aDpvAyHoYT47vXF/vy+ti6340OAQn18QOsnDsjO6FlsFcVS0dsLkoZSdjn74HI
 M0erNy6zbj1etpFQWYbzkGIafKGFwIQKdB/AKYyvIc7H3TfOrQA2pZmo6Q+OlJLKkUOR
 raH4Qk6sRX+l01QKn4/QnHsFe+mNNO8wJZ+BZKZUAr3eInR1nSuMQpGAr24trLO+0Uw0
 WML5ObJZYCM5Stxdba/JZzXj/+Nm9kYdfSRf1mU2lnhm7aoMY1b4nVAxnQXpkTFpxWKm nQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwdjuuuw3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446Nkjun007016;
	Tue, 7 May 2024 02:01:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7dbyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:21 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44721Em9034149;
	Tue, 7 May 2024 02:01:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf7dbvc-6;
	Tue, 07 May 2024 02:01:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH] scsi: mpi3mr: fix some kernel-doc warnings in scsi_bsg_mpi3mr.h
Date: Mon,  6 May 2024 21:59:53 -0400
Message-ID: <171504445063.1494912.15289291740670820883.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424055322.1400-1-rdunlap@infradead.org>
References: <20240424055322.1400-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=941
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070014
X-Proofpoint-ORIG-GUID: KP8_q-glHEfNH1TxDCC3xXbfg7ZZ3igB
X-Proofpoint-GUID: KP8_q-glHEfNH1TxDCC3xXbfg7ZZ3igB

On Tue, 23 Apr 2024 22:53:22 -0700, Randy Dunlap wrote:

> Correct the name of a struct in kernel-doc to match the actual
> function name.
> Add kernel-doc comments for 2 reserved fields to match comments
> for other reserved fields.
> Correct the kernel-doc comments for a nested struct to eliminate
> kernel-doc warnings for them.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: mpi3mr: fix some kernel-doc warnings in scsi_bsg_mpi3mr.h
      https://git.kernel.org/mkp/scsi/c/aca061774bc4

-- 
Martin K. Petersen	Oracle Linux Engineering
