Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE482801
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 03:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750389554; cv=none; b=ldeMH3LMZ9ZknA3EAgZns3x+t+Me6RJRgNKSj+hK1etP7LMrbCB9xQEOeuEQWzXAd9+OMzsnVj/uXMtb4cWlt3Qo2qMFvohijqQBpDYRkdDWo5cmYOnPqL9hqzN8OfoD7FneEv05ODeHjvk2V1h5TeR4/OM/kqS3Tchq79yiEBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750389554; c=relaxed/simple;
	bh=+C3mgGLp6cmkmKectSNglrhtsleNl1Rht1YUnwCPQuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EdO1H+RIjvbv8vXxKaq97yJ/1rJl6dcBDynDf1/t8ARYamoAnhlY9T1tWkK6S7i/ZUA1ifowq4TroZ+qA+vLK2DlO2EY01JMZzvaJHcB8otwB8O9qOykd4Q+1yid/beOvrJmxM0p34iqQEo7EvCnTfVsVL68bDu4dD1kik6ysgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CZhgUfgM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CZhgUfgM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K2teV5012115;
	Fri, 20 Jun 2025 03:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ahqyL9WeILu2kJVv03CcjdSx9n6aVztqAyf7J/rMyiE=; b=
	CZhgUfgMasnJASaPt1ZMnP0RdwZzV/Jm0ffc9IVEgjgagFvCu80SrHQAuIYtR9aP
	BOw3QrSjtCTMtxsbFF1TOk1tYWmoHccIJ4B0Vk/zmorp2ax0HDVknEZsM8hkMGMf
	MLw5vqQt7BKzj/ieselOT9Glh/gj9EV29ejskfdyRJWxSOkda+KTg7G6MLJDI1Ur
	ZONTm2gr6mVOsWB4RzbMyVVDVUFe7OwhivzQ2i6QY8OtD6bQY45scfzahDGZAvDD
	K7ehGN8nz1ajAzZtyiG19aS6uMhyaPUYKcLVnnWtzXpfbo4E8W1tk5GJaWxvhokB
	a3oYOD+pv9e/SzPyhrM2GA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47914etvkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:19:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55K1Xep2009916;
	Fri, 20 Jun 2025 03:19:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhjydh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:19:08 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55K3J7oN002814;
	Fri, 20 Jun 2025 03:19:07 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 478yhjydgj-2;
	Fri, 20 Jun 2025 03:19:07 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: Remember if a device is an ATA device
Date: Thu, 19 Jun 2025 23:18:37 -0400
Message-ID: <175038845867.1665414.12012700200423344561.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250611093421.2901633-1-dlemoal@kernel.org>
References: <20250611093421.2901633-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_01,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=675 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506200024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDAyNCBTYWx0ZWRfX4P2x6+eV6adt 3cjrvSW4O505Uo8hKqCp2+B44AIb0Rm+zN//JjyzEVmmltyODaaKluI/7FZHtrbX4MYlKxoT6Cg aAE/XczIhaFwg6hZdEqoY8yOrEOWz4BPD44z8YlREDD7r6HOkWFo1Oiw8sUMJVXh5zZrN8/yAyV
 2Fm4HeCmHGgdd7PQ6yRi7virv8kshyPdFA9QoHluNje2SK4KUzAdrt7iWjedcpUDDgLHgxdmhRi jZNhqv3BT2ktptBmk+PYVTAuztwLUiAjjD/eaEMGqP8MT2s+1sCxxMC2lpgCIMFQbAODlWS5X18 6LNAGJ2J8wvcvhvapvF+9W0TIEGXIACC9bxrwRoV8WMgENlKlk7+sITPaacMKFp/4Z5QBt06LuF
 Zl58o/YhxhHC6yLnOHKhretboUMAoIzyn2ekf5mBD4wwEIzLgJZxHV6eUWzIkBocnHFETNaa
X-Authority-Analysis: v=2.4 cv=U4CSDfru c=1 sm=1 tr=0 ts=6854d32c b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=WExX_A6daSmWf7HKYAUA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:14714
X-Proofpoint-GUID: wVBa4zAWgAjUa6W3WEL-eFdA_Bw6phXo
X-Proofpoint-ORIG-GUID: wVBa4zAWgAjUa6W3WEL-eFdA_Bw6phXo

On Wed, 11 Jun 2025 18:34:21 +0900, Damien Le Moal wrote:

> scsi_add_lun() tests the device vendor string of SCSI devices to detect
> if a SCSI device is in fact an ATA device, in order to correctly handle
> SATL power management. The function scsi_cdl_enable() also requires
> knowing if a SCSI device is an ATA device to control the state of the
> device CDL feature but this function does that by testing for the
> presence of the VPD page 89h (ATA INFORMATION page).
> sd_read_write_same() also has a similar test.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: Remember if a device is an ATA device
      https://git.kernel.org/mkp/scsi/c/b1ba03c49a71

-- 
Martin K. Petersen	Oracle Linux Engineering
