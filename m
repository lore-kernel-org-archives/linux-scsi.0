Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B026AA7
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 02:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712887538; cv=none; b=MMX2HWK/ktbqFuU6PgPu4up3lV5vS4xddmAymrQqKfSZdjbNE99coUd81C6TkEW+HGN/DJvGcngInJcX9Bp65ZeXsSkKquuI0V06xKnqCGx3QNXdEUIcFOIYrhYL5TgOdXzPD6KksuGyt83Vppeqyj30/ibLAOHoPcI6S2zzf+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712887538; c=relaxed/simple;
	bh=0694QDe032d6VFR77cpToBVpXdP5y2nsc1s7uL9aUD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bHcs6S1fl6hP7dxQCw1iEidegItzQJBcxUMZuycZU0jbrxXVCCLMKiJeuNYpXRcRfx1JAP5cVrbU5/BdQJWF1Igo/1lJYG6RU99oicTe5OsImQBaI6KhDF3I+7D2/OZL+0M4/LN46oXLTJtSpW48GifgNHJbkn46PTn5LhracZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I8WIr/6x; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I8WIr/6x"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BNJieg008147;
	Fri, 12 Apr 2024 02:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=K3EKfewxu6meUBhQmVIN0tIEYWK5bgbXNxmxTgJNDMI=;
 b=I8WIr/6xE7RVDA2NrGALTPXyU2Q3UbraLDuIjcyYecdNVPyh9LX/Bp5cE2CrN+Aw/+Av
 FwT6fcgXKoQtZvYcm2ENPG9dga6Okv1lZpl6gkn9WIi2AMeLQd8FIiUrxs7DJTNu8vgd
 W0TdxCg91NRdCy8Xo0cx/SMqf/acXTuVGEkqxYhfSPMlVyXg6JWUzT7nbxmEIjSuOMzL
 c50nGNlRXqXrhWsaPBpYDGTGiRmKCGRoIUFllHpB0eNB4ip9UlCQ1ZPQ3HYi+XkyJ7CP
 06Q3Vm/94jzDSPE+g0F+s343xRwlla6DtpgkhL7UDinMiuJtzhUfXsaE9SDrfUn2NmgP yA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xavtfape7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:05:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43BN8o5O040028;
	Fri, 12 Apr 2024 02:05:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavugmd2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:05:31 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43C25UFg013100;
	Fri, 12 Apr 2024 02:05:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xavugmd1x-1;
	Fri, 12 Apr 2024 02:05:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Improve the code for showing commands in debugfs
Date: Thu, 11 Apr 2024 22:05:08 -0400
Message-ID: <171288602656.3729249.15963082473915374537.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325224755.1477910-1-bvanassche@acm.org>
References: <20240325224755.1477910-1-bvanassche@acm.org>
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
 definitions=2024-04-11_14,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=808
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404120014
X-Proofpoint-GUID: JhSfFswrQly27JK-tR0HjDcj_W6YiWVm
X-Proofpoint-ORIG-GUID: JhSfFswrQly27JK-tR0HjDcj_W6YiWVm

On Mon, 25 Mar 2024 15:47:52 -0700, Bart Van Assche wrote:

> The SCSI debugfs code may show information in debugfs that is invalid.
> Hence this patch series that makes sure only valid information is shown
> in debugfs. Please consider this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/2] scsi: core: Introduce scsi_cmd_list_info()
      https://git.kernel.org/mkp/scsi/c/9972c02a8067
[2/2] scsi: core: Improve the code for showing commands in debugfs
      https://git.kernel.org/mkp/scsi/c/ba0f09b0dbd8

-- 
Martin K. Petersen	Oracle Linux Engineering
