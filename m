Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188D62C0F73;
	Thu, 20 Nov 2025 04:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612204; cv=none; b=iSXbjbfET2gazysACW7tf4zG0gbEZm/quJRRmCLPvDRg7IRQP0Ff0jK31JqZQpY65WpGhTrI/ExGw5XVw7EIuSDuiRB2/d37A5kR4vRJLuGy2sYEXXOvaCP5dt5ul+eZzmfpPtmG+roo97cmBir5qEz5bO4u8wRhDgbj6N1pMj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612204; c=relaxed/simple;
	bh=2+R7WWApY8TWGd2c9bP1RaQKspmfGyy6mhjQCc3vCzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fdhM8Rukqsy5Mi2wUvLGsUFcp3hd4k4Kbs5imf3FiHasYCCG1/IVShMBz0j5WMuV31a1ZAtmkdRlfatxoXN4Oqge5WDtlR70nzLdf/USx8PYW+HAtCJQswZ1sMbBT4GIeZoh0Th1/C61UHo9N9zHaFxzPy3Dp0uvo0lIYKIx2nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R/llkZ8i; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R/llkZ8i"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NVSG013261;
	Thu, 20 Nov 2025 04:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uKJDSIG1l3qAAwUwQnYUyhPgHI+AfOXiCycqQ8h9e7Q=; b=
	R/llkZ8irJLEGQlcnD63IC/un3n2XfOPnXXRgd+AEXIOU7rGf1ylkjLEffo31tPw
	988T2FqvV0AjjpQaw6rRi9HQReG1IXWRyQRyvEravj2ayQNTBUWKKobZKw5wej1D
	WCahd2+Q5oL/v3iD7kxaM2IhXLuXAUxdQcarDDpjzXl71hCpT028MYbmvohy1X94
	PSdK10EvVy9++b7dGxmzNu/AmrLEL0fCBOoYhsvlvyD5hfMsm6Nf69K20chyq4tg
	t0wF+3nZuT+CwlmxyqtRF4SlBYCzymJG8PsW/1bxSL9xXcG/hrXwE3n8PM/VqpQ0
	GlkSO8+5Xuo60U6lziJtqA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbur8wx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK2RGMq007200;
	Thu, 20 Nov 2025 04:16:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4dk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:36 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPr012546;
	Thu, 20 Nov 2025 04:16:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-14;
	Thu, 20 Nov 2025 04:16:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        moonafterrain@outlook.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>
Subject: Re: [PATCH] scsi: aic94xx: fix use-after-free in device removal path
Date: Wed, 19 Nov 2025 23:16:03 -0500
Message-ID: <176357169020.3229299.14175005699966083724.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <ME2PR01MB3156AB7DCACA206C845FC7E8AFFDA@ME2PR01MB3156.ausprd01.prod.outlook.com>
References: <ME2PR01MB3156AB7DCACA206C845FC7E8AFFDA@ME2PR01MB3156.ausprd01.prod.outlook.com>
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
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=487 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXwy6xlBWwn3VL
 ixw5f4RTVVF9sRRFthxugKIfxTN541zqhizi0sG9zhlfzeoLbx8KWDTKRpgiHCkdS0dL0+CQbC6
 2624GR3D65cLDM8BHa6iK6zynPRSg9tG/qV2RD0UFe33ai2ysL2zUJOHNr9jzwqWudtiXRpEXrM
 y3zl6lbxi7vsT5hggoiQfZtHEIIwrvtj9DIm7C0eQyN7oM2SNvaenGTGvv11rffCYZ/K4VS1t/R
 n7sIxkx5A5azblSO8jdtIn035zhq8wSJqlsJb6ohMBWi+EhiMXbS7fuIqZ4mvDcCkx8sg7vBhSj
 5brvu1TEo+kKlzWdUeur/U1bOamsKqMd79IgiRYR9Di8cjUMQF7RxP/CZMy88oos7OwWbflhHbD
 4aCv6BUb9Je/ft+BU9Q+l1BgV+9oUg==
X-Proofpoint-GUID: Yse-u4KPXFgJEaPX_tg-VI0OeH2lR45M
X-Proofpoint-ORIG-GUID: Yse-u4KPXFgJEaPX_tg-VI0OeH2lR45M
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691e9625 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=UqCG9HQmAAAA:8 a=-IL5odScx_SrRfHQifgA:9 a=QEXdDO2ut3YA:10

On Wed, 29 Oct 2025 00:29:04 +0800, moonafterrain@outlook.com wrote:

> The asd_pci_remove() function fails to synchronize with pending tasklets
> before freeing the asd_ha structure, leading to a potential use-after-free
> vulnerability.
> 
> When a device removal is triggered (via hot-unplug or module unload), race condition can occur.
> 
> The fix adds tasklet_kill() before freeing the asd_ha structure, ensuring
> all scheduled tasklets complete before cleanup proceeds.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: aic94xx: fix use-after-free in device removal path
      https://git.kernel.org/mkp/scsi/c/f6ab594672d4

-- 
Martin K. Petersen
