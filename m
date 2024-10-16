Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC1641C7F
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 02:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729046455; cv=none; b=GMciA/FZUT+MEGybXseKQ29fSfQgAuYiq0K9jCxuNtP4RMc3GW9zV0QGTkv67Hz9TB939oeuZgGe6rlwKRjQ1ldhimgEv67Fe1Cxq38MpPHY2bY8kDgL+KCfxk7KQzhStY8A2nqAzb6iEBIwHflhQw7vEWnXKBEp8+mWSIRzRaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729046455; c=relaxed/simple;
	bh=R90fCGw7Ns7Fj621uh6c3nKRVd/wuqf8/+/cmZ8Lf7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qv7Iw0ckZSChwNkko7IbpT1lu7jjO144EDnHfTSFnAf5lDfLitgeV6zA1D7IoOZzEncs9Ur6NiRwMtj3kvaBex9IcaUZtHX765ROkv8lyOnQKZzRDxsZcs3/UUzapQp09mp4b1luh3q6SqVg3k82fs9wOkMYRMl8clk2IiquD2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=koh7kDnw; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="koh7kDnw"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2N0Ca007836;
	Wed, 16 Oct 2024 02:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=wap87z0JVYhTFqQ8SDUVlvKeFd5YVu+ksQi7EhzYRDw=; b=
	koh7kDnwy+qR7b5TeDdpnILS7sqaZwHv6MUCcySgdFZcC3EVbjeVPY3/LwgZJTbt
	QVyUd2aP4+bm9GyMhQTAZZPYSQt4bCNAEL/mv9KYRSeUhaejGtXhy9/+nxXphj8r
	jG3sjAPz+JmQz/gV9iVhRT47W2TqPidKo6YCHX7s/qglbmWxjDhdceDdY/R04a8c
	g7Je92m7wLaESR9Xx1Vg9QeUNi3OTh8uJ+CIJLls9ZHNUYH+0Z2gvIcznBBSaBjg
	UqrtnVUU3HUGTWeRCNMZNY1KvkV/FwJfuuWA2T+3lth/rIGSLXq+ib5LYEZRWtHH
	CFbEsOFfDvkvGpFCaWWxXg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427g1ajgy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:40:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FNnYUm027322;
	Wed, 16 Oct 2024 02:40:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjesxyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:40:48 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49G2elg1001510;
	Wed, 16 Oct 2024 02:40:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 427fjesxyf-2;
	Wed, 16 Oct 2024 02:40:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/4] Clean up the UFS driver UIC code
Date: Tue, 15 Oct 2024 22:40:03 -0400
Message-ID: <172852338076.715793.8660499494990057202.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240912223019.3510966-1-bvanassche@acm.org>
References: <20240912223019.3510966-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_21,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=808 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410160016
X-Proofpoint-GUID: tpLq4Ysl65xEkghDcV0Hc9GiIZds1yOn
X-Proofpoint-ORIG-GUID: tpLq4Ysl65xEkghDcV0Hc9GiIZds1yOn

On Thu, 12 Sep 2024 15:30:01 -0700, Bart Van Assche wrote:

> This patch series includes four patches that modify the UFS driver UIC
> code without modifying the behavior of that code.
> 
> Please consider this patch series for the next merge window.
> 
> Thanks,
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/4] scsi: ufs: core: Improve the struct ufs_hba documentation
      https://git.kernel.org/mkp/scsi/c/22fbabe82cea
[2/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to read
      https://git.kernel.org/mkp/scsi/c/e31931d646d3
[3/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to analyze
      https://git.kernel.org/mkp/scsi/c/fcd8b0450a9a
[4/4] scsi: ufs: core: Always initialize the UIC done completion
      https://git.kernel.org/mkp/scsi/c/b1e8c53749ad

-- 
Martin K. Petersen	Oracle Linux Engineering
