Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5BC3A7F7E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 16:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951709; cv=none; b=BeVr7c5WZdl8f10S+BIPvWRuoYGu8R2fU+UkSMOhSaQYLJDSboVBPwJ53f/YaX74Mqm/2/7iEWQvuqENZhm029THwZPKbdtyAvvwiHrplmmP4ob3Yzc70zuKOWTtZQbfBctIj5elvY53nT/u70FsdGmSn73OyzXS0RXGMd4u8pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951709; c=relaxed/simple;
	bh=nVF/Qys6sK/+QqvBWnucsg4s/3wD2f8RVY4p64iXxTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dl91MwMeBtYPMR094rysfH+pAddbfKneXXjcGiTGDqdBfK5Wxz+Mj+VyoiAgwFZs18LxxhQsuib6q937gZP0t1YhZS9TsvmsV86F2TbzFjRX08wDvr5/cISgCzzRO5iFpnonkj/PumgamRcOGGet0dCk6GFAUe9M8zpl9cX6tUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hHz0iCl8; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hHz0iCl8"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMtsp351829;
	Tue, 24 Feb 2026 16:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Fj/DRctz5kLXfSixcgYWXzpgYcgUTyQgkOInMopgeBY=; b=
	hHz0iCl8ae3H/RtRkg+AmST8VZeQgGcDCzcmoeZvGrobI3olVjvZI0kjh1IrweWA
	QjaD0XIHWFmwMAfuxPbbrLVCzBrvFgWpi3xExf3Ze8o1B6c3ZVPUddQALit4ZA+E
	dWAA3OzFIkGxTtHoMHd4twSPZEe1LXRp5QJELlznPM/iokPGSha6AIwAUN5lqb4Z
	fblo4G27Tv+DpSDlIOWRw08fa+tsRJM2EZcimLm1UAVyMpgePRiLTiOJlkKKGBFl
	Zby7LPA64anldcMm/RgVLC7BEIR9EL1+K8oJ7pxvGfQyYp/nW9BacCubnMdl2Ega
	zrSclQs+NQyGv4dgLTF38Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4arckk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OG12Ap015532;
	Tue, 24 Feb 2026 16:48:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35a6kpg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:01 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61OGlt4n012936;
	Tue, 24 Feb 2026 16:48:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cf35a6kjb-6;
	Tue, 24 Feb 2026 16:48:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com
Subject: Re: [PATCH v1] mpi3mr: Add NULL checks when resetting request and reply queues
Date: Tue, 24 Feb 2026 11:47:45 -0500
Message-ID: <177195161222.1154639.15202636953536332032.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260212070026.30263-1-ranjan.kumar@broadcom.com>
References: <20260212070026.30263-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=767 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240140
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699dd65a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=nH2g7W27eJArW00wuM0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: b3_ZsdDtlxZXWBnIlHjHhJRxngGXu6uF
X-Proofpoint-GUID: b3_ZsdDtlxZXWBnIlHjHhJRxngGXu6uF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE0MCBTYWx0ZWRfXxN+MdWSwA+xY
 F2oEJfNqWa+XJDJgmwVFn7tb9jis3J3ri/maf5flBAR3rZjTxz8+0wMUt2aTjx3gsfu55UWOa3z
 56r2ToXAO6UOjQQSeWIbiSw6LSwEtmr+GLtM3B4oE0pzL55H1Qn4ZBzo++v8FCLbxkol/C5JeNE
 S5Kg3Vv1CM3VhZzYTzLBd2XSbn+gx8mpQAGIns+qSByNXwDqj/IWpuWGNHcXBWn5JyXi2kVASdw
 StNWgzLoV5EhkgT36tBiw7mWEBbHGCRfsT88Z9E3PMlGwMSEmPesArwXm4268vboAuDxGQOi9KP
 IvDWyfOBWpc6N0s8QfqEJ/mUW9PDxyoL02rDms4BhNOLaDyUAOH4fwB+mEdg8bl1xeqULWWxA/O
 baSg8rRUfpBOzVsoGksYM9BZ83M/S3E+7xW/WVKNcD2hhYiWow7I31OAS0wBuI54PtcWhHaskOZ
 teF2mVfDIDoDO2NyAWw==

On Thu, 12 Feb 2026 12:30:26 +0530, Ranjan Kumar wrote:

> The driver encountered a crash during resource cleanup
> when the reply and request queues were null due to freed memory.
> This issue occurred when the creation of reply or request queues failed,
> and the driver freed the memory first but attempted to mem set the
> content of the freed memory, leading to a system crash.
> 
> Added null pointer checks for reply and request queues before accessing
> the reply/request memory during cleanup
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] mpi3mr: Add NULL checks when resetting request and reply queues
      https://git.kernel.org/mkp/scsi/c/fa96392ebebc

-- 
Martin K. Petersen
