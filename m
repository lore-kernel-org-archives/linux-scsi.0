Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC03E8BEA
	for <linux-scsi@vger.kernel.org>; Tue,  2 Apr 2024 01:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712020265; cv=none; b=tV+8EkU/boroSNKjBl+TsLqEw/6i5lsTcmQUP8NGRMTIk7uXNGBcQik7QBJj4J0Y2HbRPew4QIlywLXwHewcKfo6lclhXx0dtNZOWkpq6wvyP/8RORqyfLmYsm6Ssv+ncnFIfQeTaXr4JSfiHMQ6IJ+amqcwCJIxKHkEB3hhlU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712020265; c=relaxed/simple;
	bh=K+gIFnrbGtUGSzuM7iuQNdshssEBZGFOgEQZnAusgK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dYmTcduhgGT/OPQxjp9BRp+7atWOZ16lkRCsXsSlT9B8PJVgwsmDalcuLuz+aHWirONYgmw1H9h6J/6NRYiYXP61vZlV0NUCc+vZh6SQDisiJ1kgtYIlGB+nCipoM97L6fF/MWeNK/EhD3Iw2A1Ce9grvN4e69xZNNcQkNsWafs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jXogWh9/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jXogWh9/"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 431HoWTr027615;
	Tue, 2 Apr 2024 01:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=0FmXWKhEiIfLmfWM0BRbXQ/54sMWUqT3DHYjy69rZFo=;
 b=jXogWh9/Ntfn+e8xQHjrNPAWceDzqhqs8yLj8YWNT4J+cRCqHvpgzqetqxBWBVgE6Aff
 ascBpg3I+DMEEdGWf/jF48/gbZJeGBuihRN9XGD3DyjvExycObpKfFfQUTypIODqNYqU
 d0QDok5CbnTaljkPESN0uQg2XyIZS3qymnjO3dPByWMtkS4r7l9iEBjsfrTy0rUujoCf
 vU03+fJxCC3K1d07O1GdAleFUPRvkvgn43ijEvdgnf80xOX8SYwKscqa1GRlMMP44YMI
 tV92HF3SGbwWnjeSi1udy93zfRYUGXm/NjPGTSkTj4iahGM3oxMFL3x44MIIwduRBgv1 mQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x6abubh91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Apr 2024 01:10:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 431N0xeR021368;
	Tue, 2 Apr 2024 01:10:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x6966c8fg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Apr 2024 01:10:55 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4321AsND020327;
	Tue, 2 Apr 2024 01:10:54 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3x6966c8db-1;
	Tue, 02 Apr 2024 01:10:54 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: libsas: Fix declaration of ncq priority attributes
Date: Mon,  1 Apr 2024 21:10:43 -0400
Message-ID: <171202016133.2068687.1746458816502971332.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240327020122.439424-1-dlemoal@kernel.org>
References: <20240327020122.439424-1-dlemoal@kernel.org>
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
 definitions=2024-04-01_18,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=874 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404020007
X-Proofpoint-ORIG-GUID: Vavud4fwIfnhviiP_QYRLqylBIsuRv0u
X-Proofpoint-GUID: Vavud4fwIfnhviiP_QYRLqylBIsuRv0u

On Wed, 27 Mar 2024 11:01:22 +0900, Damien Le Moal wrote:

> Commit b4d3ddd2df7 ("scsi: libsas: Define NCQ Priority sysfs attributes
> for SATA devices") introduced support for ATA NCQ priority control for
> ATA devices managed by libsas. This commit introduces the
> ncq_prio_supported and ncq_prio_enable sysfs device attributes to
> discover and control the use of this features, similarly to libata.
> However, libata publicly declares these device attributes and export
> them for use in ATA low level drivers. This leads to a compilation error
> when libsas and libata are built-in due to the double definition:
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: libsas: Fix declaration of ncq priority attributes
      https://git.kernel.org/mkp/scsi/c/0ff10cb7f818

-- 
Martin K. Petersen	Oracle Linux Engineering
