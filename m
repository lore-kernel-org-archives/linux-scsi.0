Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3FE5228
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 02:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047293; cv=none; b=ES6VOot/ieYTisFG5XxHVz2MKnDqh/rQuu1BV7u5uS98HoOlmd3j0BvIHbcj7uZ8mGa7rd2EfAJdZu7OuVgoPwMlSz72TnNkJJVvKr4c/uCXOnhfsXdDYITbXO60tAlsce5qDbgOuJtvDMH3XYvZ0RdsO2lgZMsvNT414SWz46o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047293; c=relaxed/simple;
	bh=ALwfuvVb7OLtHVTaeyXj+wfSmgW2LxLeFdbppgAj59E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sLN22izQuT2Af1BSvXM+CTJus6jQhm6YKPtowqve/OkOWPnpe/I3ksaO5Espm8j8ohLD4FVNyYKtNUVUrNtsrnQL+ti22J5plYHXR1yBq+wHwKchPE++EID++FmrlrWmdIr3ifeoJd11kd6dn9Pzw6D5QRDT6DZQ2CJ5FvLv29c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SELtF+V+; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SELtF+V+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446Mq0ef027932;
	Tue, 7 May 2024 02:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=BylQ60MFfPl62ZD444msicH/z7YTx98bC1FLDhnMPbU=;
 b=SELtF+V+fdNA/KXq6MiijYjNSOWPOrcXX70kA2TBlqVHtdpawqNIyy2U5kRjX7gdyxlW
 P/wGUg/+rbruq5q8YzXY7O2nPdij4vdWk5go2l5OPhKIcjXT5m4OrabrNb9wSHi/bqfG
 ndypllfKMw2bWexsNMgcgJMO7OY7lrClQZTDtIzXf6fkQPSMgs5rmUJnyIDEgczjGWWn
 1gxC1jkaXn+M073Hjuz//OwfFKSTqEMxlHLPNXyBLJmtDtpZ7rQh4kEHb687xOfWnRwt
 V7e2GeWRuzCTC9zz5DuscdeKVc6xyjzJTXHfVabLcIXhArKtOsSfy8FXNqxybWYzn8qo Nw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwcwbuvej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44700Adx007053;
	Tue, 7 May 2024 02:01:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7dc0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:22 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44721EmB034149;
	Tue, 7 May 2024 02:01:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf7dbvc-7;
	Tue, 07 May 2024 02:01:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: ufs: scsi_bsg_ufs.h: fix all kernel-doc warnings
Date: Mon,  6 May 2024 21:59:54 -0400
Message-ID: <171504445061.1494912.4170421545818557572.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424055316.1384-1-rdunlap@infradead.org>
References: <20240424055316.1384-1-rdunlap@infradead.org>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=962
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070014
X-Proofpoint-GUID: QbsxNQUw8zfS_sZ6C9UbKo3FZ2uMFysu
X-Proofpoint-ORIG-GUID: QbsxNQUw8zfS_sZ6C9UbKo3FZ2uMFysu

On Tue, 23 Apr 2024 22:53:16 -0700, Randy Dunlap wrote:

> In struct utp_upiu_query_v4_0, add description for @osf3 and mark
> the @reserved field as private so that no description is needed for it.
> 
> In struct utp_upiu_cmd, use the correct struct member name to
> eliminate a kernel-doc warning.
> 
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: ufs: scsi_bsg_ufs.h: fix all kernel-doc warnings
      https://git.kernel.org/mkp/scsi/c/de37677ef17d

-- 
Martin K. Petersen	Oracle Linux Engineering
