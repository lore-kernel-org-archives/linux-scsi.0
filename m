Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D1719E830
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2024 02:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798199; cv=none; b=Wl6c4NnpvtoVn+5n4vfDNB7tQRVpXLyQcb+bb843QesKgPXVvElNSnnPMo8n5zGiIkZ8JMG4Rq9+NWhKQl8uoCAbBA894aAeEMnC97KijY6XOZ3TF3DsG7mSbfbsSs78RAXhYwgdoO2dbcXqCK/96eZ9mdqSea+YvHj9QKVHx4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798199; c=relaxed/simple;
	bh=zoLJHwCxdK8wD7TQdBW5VRmLlINQNRN6S24b8lLt9nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZjL8V8aTwFCs/sNpNMB+bgjBLy8NhXVKlu34CbOkG/AaMv1hsTTzVOgh4u6qCOQo/wdJ1wsNmOLRkUYKCtqaHO5jfs5fH560wwiwsdZ86X6wW4tOaEj5sYxezaE7mzEolas2CcgX7Ag7uHfpAnOHasY+awnv1c28xk3kTD8n50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eDGL81KY; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eDGL81KY"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1C6iG024691;
	Tue, 10 Dec 2024 02:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=y2x9bo9C1FcA9VFuwWOLTBnX4uZPt7ao0+HdDXhU9P8=; b=
	eDGL81KYeQ+26RmzOPwLY5ENWAUlEdDDugWRSgnsNLN3/0XGhpgXt4gAzmietgzr
	PxBEJKoDS+PeMvwUiL9LlkbNREqYLQtFIFrUViuAasnD2Ekz9h+YqJ1s8pgg/vOD
	TPwQGcweRQc5XCETzAVQ0mFOfo9DHMkg9j81QUhuznvpRO1+ozJ1nu0vJddCAeai
	6cP6uC6dFt44LGCpJf6odL6yJ+UwJ9KdweaK+liWgULYoLJri6Yfmu28u7jwAJZa
	MXvG9jwNiw/55tafUo1jKcVzmrS3nEdFS0WqJohLC9I1GEIMXuqdwmgQ0DdV2YWf
	ONUBW8AzTovB9vvd9/5WcA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cewt4qf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9NjE8T034912;
	Tue, 10 Dec 2024 02:36:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf7y76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:19 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4BA2aIul010256;
	Tue, 10 Dec 2024 02:36:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43cctf7y6u-2;
	Tue, 10 Dec 2024 02:36:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/5] Replace the "slave_*" function names
Date: Mon,  9 Dec 2024 21:35:33 -0500
Message-ID: <173379777414.2787035.11543406387630774831.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241022180839.2712439-1-bvanassche@acm.org>
References: <20241022180839.2712439-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=599 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100017
X-Proofpoint-ORIG-GUID: 0Z1lXgsU-2YrwPdiDOGJ8ijJQRa-xIkN
X-Proofpoint-GUID: 0Z1lXgsU-2YrwPdiDOGJ8ijJQRa-xIkN

On Tue, 22 Oct 2024 11:07:52 -0700, Bart Van Assche wrote:

> The text "slave_" in multiple function names does not make it clear what
> the purpose of these functions is. Hence this patch series that renames all
> SCSI functions that have the word "slave" in their function name. Please
> consider this patch series for the next merge window.
> 
> Thanks,
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/5] scsi: Rename .slave_alloc() and .slave_destroy()
      https://git.kernel.org/mkp/scsi/c/ed638918f4df
[2/5] scsi: Rename .device_configure() into .sdev_configure()
      https://git.kernel.org/mkp/scsi/c/47c2e30afcec
[3/5] scsi: Convert SCSI drivers to .sdev_configure()
      https://git.kernel.org/mkp/scsi/c/49515b7fe50c
[4/5] scsi: core: Remove the .slave_configure() method
      https://git.kernel.org/mkp/scsi/c/0f98212d96a2
[5/5] scsi: core: Update API documentation
      https://git.kernel.org/mkp/scsi/c/b0d3b8514abd

-- 
Martin K. Petersen	Oracle Linux Engineering
