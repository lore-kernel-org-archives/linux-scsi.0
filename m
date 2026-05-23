Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708D3B672;
	Sat, 23 May 2026 03:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506119; cv=none; b=pyl7TiXhVykB6DQHlmQ0rVi/Ux28LE7wR6RxYAPDoli8W5sk3MfMmMWGkYWQqSLh+OkHThvou8ezTAhS+h7egndCtSD044RoNGKHva0TNBFPn2wgST3436vo/vvatl6Giw+ZiBywD6jADdVQ0UbpH46wW6KAWzQOMZBouPtTizI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506119; c=relaxed/simple;
	bh=DwZNuwY0fKeIzTDsvOHyLoubTPnvEKV2FhPuRoxNRLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zi1uI2e7rlSizjQda7xZ2o2+qdAivMRG0p04vIrSadaLHhUAWH7UMdFxn7xU3Sht0ifV917G7vw5v6DaN2TNEjKMkETFKoCnMyr9WtlUOPrGdcgSQUGqtMIS4MfmkGTuyq81uhejRsxetPSJmzNSMXG/XFhiEuBmoq1hU+Z8sR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HhuzrYiL; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HhuzrYiL"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N39cKn2840870;
	Sat, 23 May 2026 03:15:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uIoEv4UmIiGEbZhoQl6JdVYiEdEkre16sHyRRg4BmAI=; b=
	HhuzrYiL1usAaiPTSCdtdCT/LQrOEEwVLOvHARr9dypQbvfRuZmCmK8WZR1YFoSR
	Tvj4B3bWzLi/+zzVUOr02uwN2DhQei8/tFWPnmsnFDW9WSFAI17OAvEm59KRrEqF
	I4SEOXOoPTjWpkqGw7PrwdobXZgHKOeJ6irvwcyRGcnDXPZYql0d/O3Uw5JJT/g7
	kvkgrbYgvinZXpSIfPmyg6EiV9eR2bN0XzCdLO9Ow26I6yk7jbM/qBUoWueGXsGm
	Stq7TjUpGxTLMIHZ+eqVkQRzjkxgt79NMp7CkHXMNRmAXc+ZSCrePqqTT8jqiA47
	MwbA2DpTBXm9QVQrtHZi/Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb3us80d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6w2032342;
	Sat, 23 May 2026 03:15:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hse2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:13 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9e0032824;
	Sat, 23 May 2026 03:15:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-4;
	Sat, 23 May 2026 03:15:13 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgenii Burenchev <evg28bur@yandex.ru>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, kartilak@cisco.com,
        nmusini@cisco.com, sebaddel@cisco.com,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] snic/vnic_dev: Remove dead store in vnic_dev_discover_res()
Date: Fri, 22 May 2026 23:14:18 -0400
Message-ID: <177913641762.1181900.9483130298257376269.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429095212.11251-1-evg28bur@yandex.ru>
References: <20260429095212.11251-1-evg28bur@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=Zewt8MVA c=1 sm=1 tr=0 ts=6a111bc2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=obzxcOSibZW-SFeEL7EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Ajv3yf3uqpezbkuOXZ7_gu8DfZ26__dg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX0DkjzegDShKu
 4/jXjnPBV4pCCgByxhVs6l7YjHQQb6ElUevonrFIJqIIymD9FtzRgej6TFGq3YVIhL8qL8RHZvE
 6xY4O1lmaE1SoF3ehwZeehQWh8waFdGMx8LjvBqDxG/1NCjDXThGApAyDNbDnNU8Wu2XKq3ecI2
 Ww/sP8jCXb/d66Kl9MdEwhQ00cm5I3KSIFX/SDu2x4bBylzKuYbOgmPYLOE2clUh7EPoOOuqGsn
 P2Jq5ahO1yhGEluRUPePAP80yefNphdh08AiW528GeRk3ep600cudbK4Fvf8KO4TsShMJLXVbzU
 MmQj9/mUGARswssAr8XNiMsMLW56U5gYmtY1cFI0n+z/xbfEBgNdp94qjpAKM7L9+g36M0n4Tcu
 JJV7Z/jTu5OQIaDpWuo0cm7ZnRKXWa9mn/1MusQeWoI8zKzgOTjWgslBABOGB7zeIE4nFFccSSh
 cDnPjIDyVOUUA7Y7Glg==
X-Proofpoint-ORIG-GUID: Ajv3yf3uqpezbkuOXZ7_gu8DfZ26__dg

On Wed, 29 Apr 2026 12:52:12 +0300, Evgenii Burenchev wrote:

> The assignment 'len = count' for RES_TYPE_INTR_PBA_LEGACY,
> RES_TYPE_DEVCMD, and RES_TYPE_DEVCMD2 cases is never used.
> 
> Drop the unused assignments to fix the following static analyzer warning.
> 
> No functional change.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] snic/vnic_dev: Remove dead store in vnic_dev_discover_res()
      https://git.kernel.org/mkp/scsi/c/195254adeddc

-- 
Martin K. Petersen
