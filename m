Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AB824466B;
	Wed,  5 Nov 2025 04:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315354; cv=none; b=Xage9adYzxlgbIuUgXQWz8ZlEbZ7LVTEzlFUJMQcZdPMOAHSm2BgMZYvIDI+Qb7HySYj92Y7heCVPUhPyZ/IqAqYNK6PaHo2DiW4TvWgQEwL6iSY+uDxQrAuJJ0kFlMSD4QEMZCgrTSngvjIVHGQG6eW+JJeqZS17zO0Yqy8uNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315354; c=relaxed/simple;
	bh=9KfdG/oYB+HwMCtwAkWPjm3buBit1BLYq+nsGL0+Caw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fwgtob688RO2RHCNmUM7hL0j6ioXgg7Lt+Pvt48ZPO/v2zPIRqK2q7L8MUX6ltEk7c8Y4/HTzw2KGnKJQihYHV5FsWSpCWpH8FEby+Pjk6NQMACM7PupDktAEU61kmxMgECiE1kppVXra0X3CvT3bfaQVtV4QPP12f/giPrQOXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eaF7xPhM; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eaF7xPhM"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A52xm7u005218;
	Wed, 5 Nov 2025 04:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NsNd89S3PdCqeXopLsWKvP9wWyHlbXmL4RdlGAzfmVs=; b=
	eaF7xPhMVt8pNMsxgYe5Z7K2DCWiVfEGm+F7pSUtGazalibZXTpf4vaYr50aYZzk
	E/jhEprxYKTIUAwxsyNlJpbeOfhuGY/VjbVQ5haUqjOYSC9/lMa2mk1Ctl6M9suO
	gwIN1lKwUXwIFiLxvdwigNvqAObyGAv5nYjZsOG2dgc0ifJUbSdv5W8LkpXPSylJ
	NgnjLAA1EfOixQXmCN55zYWXfJ/RWWp45kZB+S4w2plfO7Ii0uq3vM1nBWHPQhUo
	hgCrdSlEjz1M/vvfTbUM28Hkkzn4/PQx0CDRtICPmvQBtjtTQl2pMbnBzZmo+oK3
	3SDTrcgNJ4aFMlaVALWX6Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7x9fg2dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A51F6Vk024921;
	Wed, 5 Nov 2025 04:02:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ne15hs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:27 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A542Prm005395;
	Wed, 5 Nov 2025 04:02:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a58ne15gy-5;
	Wed, 05 Nov 2025 04:02:26 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: mlombard@redhat.com, d.bogdanov@yadro.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/3] target: RW/num_cmds stats improvements
Date: Tue,  4 Nov 2025 23:02:19 -0500
Message-ID: <176231440777.2306382.10043312134741476911.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20250917221338.14813-1-michael.christie@oracle.com>
References: <20250917221338.14813-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_02,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050024
X-Proofpoint-ORIG-GUID: X4dwLFzHhJOAyGTLmXQ8ShaH_xzCiJfd
X-Authority-Analysis: v=2.4 cv=LYkxKzfi c=1 sm=1 tr=0 ts=690acc54 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=O8ftZXc9_Udbri4xdk0A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13657
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDAxOCBTYWx0ZWRfX2lVX7ANcZOJ6
 mErWMR+amt5gJwJjbwtOdhHxXpuZTcG1eTT4DiUq2Zv86IJQa6LS6g2S7273kmqh4giQPO/U0jC
 tISo49cbNuqeeWqWgWGkQBJl+fR/Y32egmHHdgemWPVWNPQPE0VKenJAcV7gcqfgkcIQjhjsHIy
 Y/0I8D/KijrwTN5VvGjQcdvIL052+St2TONUcvJVU4S55qxjO76KeQRSIHvYAMdNunoZcwfruzB
 cmgUh82uv96kw2HH392vS6VzkcbshEm5GozYimyReGiS3Y9kCVKl3Us1gNorSAUpZgfTKAi/8WJ
 plAdxU6zCxr1LgbfZDzbujaWToVlHnld4aokISaSEsXI0ZNO/8v7mEwtQHPcnS2dc3rxQ1/+CLh
 iHgW68lLd/OGkEI8CySk8CE+2y4EIrAljzy2Ibh0/4Pyfh15Er8=
X-Proofpoint-GUID: X4dwLFzHhJOAyGTLmXQ8ShaH_xzCiJfd

On Wed, 17 Sep 2025 17:12:52 -0500, Mike Christie wrote:

> The following patches were made over Linus tree. They fix/improve the
> stats used in the main IO path. The first patch fixes an issue where
> I made some stats u32 when they should have stayed u64. The rest of
> the patches improve the handling of RW/num_cmds stats to reduce code
> duplication and improve performance.
> 
> V3:
> - Fix ENOMEM/ret use.
> V2:
> - Research if percpu_counters would work.
> - Add patch to fix u32 use.
> - Fix several issues in last patch: do unsigned 64 bit counters, fix
> remote xcopy handling, fix default lun0 error cleanup path, fix
> byte to mbyte conversion.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/3] scsi: target: Fix lun/device R/W and total command stats
      https://git.kernel.org/mkp/scsi/c/95aa2041c654
[2/3] scsi: target: Create and use macro helpers for per CPU stats
      https://git.kernel.org/mkp/scsi/c/ed6b97a79577
[3/3] scsi: target: Move LUN stats to per CPU
      https://git.kernel.org/mkp/scsi/c/bbb490053173

-- 
Martin K. Petersen
