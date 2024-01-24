Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CD363AA
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 03:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706065268; cv=none; b=EOxWquS05Wz4bzOs/ePX4+GnVzSQcNbayWTyLbVKyCiUKPzDYJh5J0kOvyeI1xkkMJokEZg/fAL0UujlDg/aHZU/+VCfK1ExGufOKer/RNq8qBpRsjCXMUEzsZfE+CXCVOqSoVMMdJamHoFfz42FxBBA+hTcpUqswY5Xecg9ktg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706065268; c=relaxed/simple;
	bh=1JaHWlqAGRbwAtQbQJw/Uj11kTgWkwtYFeKZUntrf1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ihSJBbBCZfHM908yoLmgnKWHXNe55B8efE+TkgdQ5eiCHXzVhzE7zHqIHDRJwLRIIyDFRuFSB+TwjVBbzWIXzHTRm9hVY7YFBwLRwd7ATXC2NKueL7Sz7ME36X0U06eR6OXWXeUWxhDhM4nSS3wX20X9z5iwuvnJjyeykPuGFuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kdjD4rLd; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kdjD4rLd"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40O2x3fH003494;
	Wed, 24 Jan 2024 03:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=5Cfe8S7R4+cIYN054XN1YlnvfBA14YLZiaNteAJ+rQQ=;
 b=kdjD4rLdg3T3B2UMZJf6YvchGQaiTABqAoEk01Eb5M4ZYQJRVXKoOog7+N3sy8gA0cZe
 fNPZlP31wsEWAZ20qqD+FvCAA/lSVOFmaRxBKzhL/+6Fytbp2Q4fB5FiXarDeIPq4EAF
 tMHxA99Khv5Puojp+vVzDtGMmiCpuZ+dZLFuGqOxP5FdNqBp+hOWXbC87bEV91KXQJ3f
 KnYjQjGHfkZPHF+IJuyXY7WLoRBoecdSGuzABb79/V97oEa3a62628FojjSmqjoG6ul/
 hDj202Rmc7YfqFLdiCf0kjkCES4mcY+JYdF+N9mpoeEFu5GqaH7onQMXSzyecIkfJUbC Mg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cwfyuy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 03:00:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40O0kWTX000466;
	Wed, 24 Jan 2024 03:00:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs3168jju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 03:00:53 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40O30rRs012869;
	Wed, 24 Jan 2024 03:00:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vs3168jht-1;
	Wed, 24 Jan 2024 03:00:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, jejb@linux.ibm.com,
        virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
        Li RongQing <lirongqing@baidu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] virtio_scsi: remove duplicate check if queue is broken
Date: Tue, 23 Jan 2024 22:00:42 -0500
Message-ID: <170606516772.594851.746305387302604176.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240116045836.12475-1-lirongqing@baidu.com>
References: <20240116045836.12475-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-23_15,2024-01-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=767 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401240021
X-Proofpoint-ORIG-GUID: ok2mNGSdqadIJlRG2GUYTLzHYFngfa4D
X-Proofpoint-GUID: ok2mNGSdqadIJlRG2GUYTLzHYFngfa4D

On Tue, 16 Jan 2024 12:58:36 +0800, Li RongQing wrote:

> virtqueue_enable_cb() will call virtqueue_poll() which will check if
> queue is broken at beginning, so remove the virtqueue_is_broken() call
> 
> 

Applied to 6.8/scsi-fixes, thanks!

[1/1] virtio_scsi: remove duplicate check if queue is broken
      https://git.kernel.org/mkp/scsi/c/d6b75ba52189

-- 
Martin K. Petersen	Oracle Linux Engineering
