Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6947F184E;
	Wed,  5 Jun 2024 02:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554829; cv=none; b=ofp3h8AWjTifUBNCDOtj2bdtJusLQQ9QtPcCqKXJVk4VoOOUh8q9lVGOVWeobmsTw6e216xeOOdDvq3c+hm+ckjzQ98HvodUQnjq1HlN7KqYZsEQiD+LSQfvjdOFC3Qwc+oQ1F5F9xc1zYw2MpFOv0AySfKdFDbUgSMaA8UVVP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554829; c=relaxed/simple;
	bh=dun0TDd0utwbNinES3F+ftYwHCdjEIOR1tSpDW4GbQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y0ap0v2VIG/Rfcqh2mbLGCxjwHIaNixtJbEgv08w0xHI2UtVipCMAF8zOUeUz30CL5JWpyLiTWn1YrG3XZAzPmMt7Cp/Cmyux2pMNlMNYyvg1uZg02mP6oOWaszokaqMBKty9BdZvyDycwKnFR2s4nkumIiI3n4ep9YmSTbpnP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iPVmyNXu; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iPVmyNXu"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4551Efnu026560;
	Wed, 5 Jun 2024 02:33:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=corp-2023-11-20;
 bh=bNrVYYzCRJ6RmugHcrDKujka3xszreX8leYLvf2idxo=;
 b=iPVmyNXuj6s7Pt7mxugEE8Wecn00uX2zJHuUHuEuhQ9Dg9SkPA/mcoG5beNeFs+Aka6C
 rbROgYOg2Q38cyV61Obe8evvyBQyEtCkgZbyCbTv0LaRYmt8EdfqO5qVoVXGsupIYeRj
 g2JmZWA/7qm8XU7AaOIzYNtb3SpAt56ct39x4QPlzx5pisH4rGuCEXgKkq3nFbA7tcA3
 lwoOdRTNGLbi5B4qFFbBxuoQsC+bW0ayHe/vGuMuJEI3SkCqD7nLpy14T+6z3GDAjRss
 F5+ZxYhzZ5SQdtRIeHqkawjkdMLxzKmmkmCR53aaxICDrXDgsYZCkgBpO+2JEFT7+sA2 Mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbqn069j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:33:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4551ohM8015624;
	Wed, 5 Jun 2024 02:33:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrjd4bub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:33:43 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4552XFLw011499;
	Wed, 5 Jun 2024 02:33:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ygrjd4bky-3;
	Wed, 05 Jun 2024 02:33:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: remove unused struct 'scsi_dif_tuple'
Date: Tue,  4 Jun 2024 22:32:39 -0400
Message-ID: <171755313982.3904072.3893180845588161684.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240528215640.91771-1-linux@treblig.org>
References: <20240528215640.91771-1-linux@treblig.org>
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
 definitions=2024-06-04_11,2024-06-04_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=802 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050019
X-Proofpoint-ORIG-GUID: JEbwQvOF2Ilyk60f-LEElwnitOfVHseW
X-Proofpoint-GUID: JEbwQvOF2Ilyk60f-LEElwnitOfVHseW

On Tue, 28 May 2024 22:56:40 +0100, linux@treblig.org wrote:

> 'scsi_dif_tuple' is unused since
> commit 8cb2049c7448 ("[SCSI] qla2xxx: T10 DIF - Handle uninitalized
> sectors.").
> 
> Remove it.
> 
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/1] scsi: qla2xxx: remove unused struct 'scsi_dif_tuple'
      https://git.kernel.org/mkp/scsi/c/96281dfa266d

-- 
Martin K. Petersen	Oracle Linux Engineering
