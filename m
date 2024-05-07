Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BEE8828
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 02:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047286; cv=none; b=ieuS5vneH1jtp0awNrmcz+3EEdk/734vrdyo5xRWW7crqaDoWF4Hw5UGH4GlmiIek5zFCpiOv8benukF0FUoYZ/IKACl++lAMj63tX2wt7NmVlbnw+1c78+TOLFndj8mNqzkgseZY5XozNdivHSXolj/lTgy54vNsuBNWlSC/d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047286; c=relaxed/simple;
	bh=NkE+cBm/822458p6gQMrVg7fiNcxVvzkYtAOZ7TfuOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VRyb4lzy6OLAOCOt6Ty3ZEMrsBdGDma/F5NAHaLUSKxte2ZJkq5luFl9ojpeWMgD8zlbBJqSpQZi2uEgOYTpr5lMIsj7vZb23gi3YuMpO0tHCUC9ISigU2sOStXa/SkbXKXfQdRsjGUElXKFCt5Ez3epnLcPnEdp3w4FgWZcKYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PRxZbZ9K; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PRxZbZ9K"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqIhB031187;
	Tue, 7 May 2024 02:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=6yIraY9ODCU77C3OFQYdiX41cQs8ycU3JsEKTV6Q0lc=;
 b=PRxZbZ9K/hmp3/VGf2tVSEFtYKzq9RCqANJ3n0G7OAV0+rZnOUj40QpKDyVWSXS803MN
 AWcDH7t/bXjbAkOxzbrF56QSQdnwa/0DYX1Ry6nYZEiIjid9GeaUMomTn1hWaxA3UQLp
 HI2LOBpXsKKOBd+/rfoVIXW8tUPg48Tnv7KQ0767s/bwhA1J4b3bMlSi/NKOdIqlz5zk
 a576n/qIJq5P5qVB+Zn3resOXYAhp28cSEXU202iGGUkr47QApkKe/DbBg5bWok5SdhM
 aKIefNVrfladE9/s8+6CduH8Hpf3ESjvua1eUlXK1b5hOnOjlXJlGbvZk/P+kxCRY2iG SA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwdjuuuw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44701dBG006923;
	Tue, 7 May 2024 02:01:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7dbxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:19 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44721Em5034149;
	Tue, 7 May 2024 02:01:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf7dbvc-4;
	Tue, 07 May 2024 02:01:18 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Manish Rangankar <mrangankar@marvell.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        Martin Hoyer <mhoyer@redhat.com>, John Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH v2] qedi: Fix crash while reading debugfs attribute.
Date: Mon,  6 May 2024 21:59:51 -0400
Message-ID: <171504445058.1494912.11977796303298941853.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415072155.30840-1-mrangankar@marvell.com>
References: <20240415072155.30840-1-mrangankar@marvell.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=811
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070014
X-Proofpoint-ORIG-GUID: Aq0pY69k-fB-_XNTX4ukvGjapRg0rF__
X-Proofpoint-GUID: Aq0pY69k-fB-_XNTX4ukvGjapRg0rF__

On Mon, 15 Apr 2024 12:51:55 +0530, Manish Rangankar wrote:

> The qedi_dbg_do_not_recover_cmd_read() function invokes sprintf()
> directly on a __user pointer, which results into the crash.
> 
> To fix this issue, use a small local stack buffer for sprintf() and then
> call simple_read_from_buffer(), which in turns make the copy_to_user()
> call.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] qedi: Fix crash while reading debugfs attribute.
      https://git.kernel.org/mkp/scsi/c/28027ec8e32e

-- 
Martin K. Petersen	Oracle Linux Engineering
