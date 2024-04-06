Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F707125C1
	for <linux-scsi@vger.kernel.org>; Sat,  6 Apr 2024 01:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712368772; cv=none; b=bTMzk7IgXfpARcR19Zp/+hYQyvVxSNuTUPUI7SLqIUlKBvSDsi1b1ANGWw1rJyljZqhg4nrbevgCooWIIy70AiekiEt9coTP20eg8SgJv5s5ksqaUepNqqTZPgo5x8qBSVNvaop8h8dnWY6sHZitUj6Nq03Vl5SoD/HZTo8hHws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712368772; c=relaxed/simple;
	bh=sTsY7gc2Pzg7lRLEDYPSR69Nn7dQb1XDVJz8idUBsRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AY896/z0QtZ5+xEQSY6gi5/tpQ5O+RHYjdXAdRUdVVPCnfEoBPhDAaInTeHwwQFr32ORwDoly2X9SuplbbsjyYl2BUZgkVQvqNpZN8XrP13ziDjDPoeXaZ/WlUH6uqIADxiCs3tIW+0cDn5aAgNLmtd6CoLh7BJqrG9AYmiaDnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kgHhXMfP; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kgHhXMfP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4361vqQx021307;
	Sat, 6 Apr 2024 01:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=BRL5UMBM5Mnu9D8VkJz0u9c/CK9OPa597UJwpi3pXio=;
 b=kgHhXMfPksl56TovHZ7ByZoMUAPJfl8s8TOqa4pn+lqvX+9u6AeMuuFVeAiQLnNiSdg3
 67+eqshjlchITQe0RhTUFfWoZXkxAc2CQfe4qAKNjPngYTWLYsMJ/3JReLqJ4DultEYb
 wkP5f+LKMarmlMyYdNOark9mLng0fL4pGBSPuJA2U9KVQTX7Ypbqy9sAUyis9bBFoShp
 AhCZJap94bflePOSkO9Ll0BnQDo7cu8PaeVofpw0oN2IJsxAqXpKkSX9bbraqlooY0YB
 7O69hsHKq5xa/x26pG1Hhv5y839/tzgkkhPB3aZhtNHSNjr4bvotNuXe4q/PNbyLOkq1 UA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaw64000u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Apr 2024 01:59:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4361XQT6032329;
	Sat, 6 Apr 2024 01:58:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu3reqh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Apr 2024 01:58:53 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4361wqvZ000912;
	Sat, 6 Apr 2024 01:58:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xavu3repx-2;
	Sat, 06 Apr 2024 01:58:53 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jejb@linux.vnet.ibm.com, chenxiang <chenxiang66@hisilicon.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linuxarm@huawei.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Some small fixes for hisi_sas
Date: Fri,  5 Apr 2024 21:58:32 -0400
Message-ID: <171236847472.2627662.4478375644460855233.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402035513.2024241-1-chenxiang66@hisilicon.com>
References: <20240402035513.2024241-1-chenxiang66@hisilicon.com>
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
 definitions=2024-04-06_01,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404060013
X-Proofpoint-GUID: 2jpbLmtjJSD0P8xtM5apPyHhqeb1Lf_C
X-Proofpoint-ORIG-GUID: 2jpbLmtjJSD0P8xtM5apPyHhqeb1Lf_C

On Tue, 02 Apr 2024 11:55:11 +0800, chenxiang wrote:

> This series contain two small fixes including:
> - Handle the NCQ error returned by D2H frame;
> - Correct the deadline value for ata_wait_after_reset() in
> function hisi_sas_debug_I_T_nexus_reset();
> 
> Chang Log v1 -> v2:
> - Add one blank line after declaration;
> - Keep the line which fits in 80 chars in one line;
> - Directly use jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT in stead
> of using ata_deadline();
> 
> [...]

Applied to 6.9/scsi-fixes, thanks!

[1/2] scsi: hisi_sas: Handle the NCQ error returned by D2H frame
      https://git.kernel.org/mkp/scsi/c/358e919a351f
[2/2] scsi: hisi_sas: Modify the deadline for ata_wait_after_reset()
      https://git.kernel.org/mkp/scsi/c/0098c55e0881

-- 
Martin K. Petersen	Oracle Linux Engineering
