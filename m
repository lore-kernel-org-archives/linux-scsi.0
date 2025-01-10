Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6A0219EAB;
	Fri, 10 Jan 2025 21:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543864; cv=none; b=s/lSx+TQFqggcPMU0uqgXtqswDbiD986H1Ccfy2ShHYZGFjDWlg296uvuaZsVMAOXlOpi5jLipK9I0sDAK0qqlKWNlZ3O291GfcMca0mXwvzig2TnHn35AKVr78sTgF1rt3XfORSXKSAJEsdkTnKAf8jWJyYR7KWEr36s8RzVBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543864; c=relaxed/simple;
	bh=sgLZSpC0O8fQgi1WM51QB5a4MaByc1B5u7dcOQZEv4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DkYz/iJGk7e55wtAgp2sYEC2x8Gt7k5xNAzTyexzzwwBpoTNqy4Ymdch5WZQPJdhNpCRyxmJ4tDMGFqAzOT2iRCH3erMBOXUqLzsRV5Opl3abMv0JbEjl2lGoDf1NM/cV2uZFTkgVfQUDiaiTbbebiWcB/jCJe39GpLUu4SaC4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M9awWApZ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M9awWApZ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBovw022214;
	Fri, 10 Jan 2025 21:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ELVIrF0mLY6xyYfQPzxeHmDa5n7xtuIqlbdDoabFWOw=; b=
	M9awWApZuQksk13j0p/0lrQXicGXna3oaGmuHfkTp5N5OxMo3K3F9HIc0WlIBc9x
	MV288Ei0GsuWpNt3oV+FclU7HB3hg7mZy8HIXSOFMNrHJ1DV95gM6gT8lm0XKtwV
	kDf9vrTz4OwfVLG2CR2kGQQ2WOc/kmOCTReh+Dqkmfnr+p+JhAE8jaTk7Q8stR1q
	MuG87XdoS8bHBqg6Ik3PgW4RWyoirPgW+9u9URTQ0oKrcaBzbTrFvZc8F8XUZat0
	5h7V0LjReBVBumg14WKS9jVUe72vSa5PbFVmBvpzfDH4gNDdtmHiWLmo2psycjhq
	dZ0iufgRQf98lrgYesg+IA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudcc0sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKbn9i025491;
	Fri, 10 Jan 2025 21:17:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5r7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:35 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ22034137;
	Fri, 10 Jan 2025 21:17:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-7;
	Fri, 10 Jan 2025 21:17:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: lduncan@suse.com, cleech@redhat.com, michael.christie@oracle.com,
        James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: iscsi: Remove unused iscsi_create_session
Date: Fri, 10 Jan 2025 16:16:49 -0500
Message-ID: <173654330167.638636.3105141034218118100.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241223180110.50266-1-linux@treblig.org>
References: <20241223180110.50266-1-linux@treblig.org>
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
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=744 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: 8JdCA6vRvHFWTEaE3O0PG62qOyVodvvj
X-Proofpoint-GUID: 8JdCA6vRvHFWTEaE3O0PG62qOyVodvvj

On Mon, 23 Dec 2024 18:01:10 +0000, linux@treblig.org wrote:

> iscsi_create_session() last use was removed in 2008 by
> commit 756135215ec7 ("[SCSI] iscsi: remove session and host binding in
> libiscsi")
> 
> Remove it.
> 
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: iscsi: Remove unused iscsi_create_session
      https://git.kernel.org/mkp/scsi/c/6e67b32087e3

-- 
Martin K. Petersen	Oracle Linux Engineering
