Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE668208A5
	for <linux-scsi@vger.kernel.org>; Sat, 11 May 2024 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715453708; cv=none; b=X0HretOBWqxTX8zzHCcUUAEM6s6bT2tz2Zx/9MKMp0rh1nwaJM1tLM4YBnt8PBASuJXE4+vGwYp7fB3np4E0symkCk9tH01UrM03U1PrQCbpEMOmh9r7VG7K4+RU16zVw42mpy5zz5NiWLS8AN1U41i5Y1ibNSwJwTuOEqiFw8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715453708; c=relaxed/simple;
	bh=ks2X/QGUEiR4nfxGT/5f65DBERZUsh5H2OqQU8IpKh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RmImUWhaI88GTmZVtTi+S0iAERgLCP2lsLCFGR5f14mFgG8GHs4anZZ2oe2Sos7LaVNnb/H95CJS7NB2ke6Yc08za3eeRRnZ+gFCSQXDyy76PsVPdfnHekbu4l6AjAH2kTrbzXkm5tDy6YcFegdo65OA5ttQmS9CO6e0bFjUh88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k0OHN6mc; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k0OHN6mc"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44BIbdYY023817;
	Sat, 11 May 2024 18:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=aj+QCjz9rW//loDzE9nKcP2ctFOqBvlCSNKOzF7MQpE=;
 b=k0OHN6mcvqi5e9oAzwH0XoN6ptdiFATZ0YStlBxWnm3/dHKpsPCCjtrzACdUYGbLMIjF
 hhsq8nRFKTuBCblz3vwhjPBUFYeZI2EUDi91tdJrIcckxT9VPRQ0NwLuw+epMMBWo7s7
 0cGBCCrvVx7gpqvrb3fehGslE1BOMU9e9LVGbh0pEy1YVrKemHugDqy1WNIu+BVG36hj
 07u2+xnHuFNgX3Ma/aFZkCRGoE60b+QGiibosVG18CetKNIgMBnnUUVwlWa4q/bWvTRL
 iACPifN+yRA272Ab3BtnrEMoKqsu3YRQMFy8NCX4h1TOQq5yPGBoni1ISV6TCFX62gGQ jQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y2c2cg2w6-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:55:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44BGTRJc022324;
	Sat, 11 May 2024 18:40:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y44fn7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:40:00 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44BIZYPY028255;
	Sat, 11 May 2024 18:40:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y1y44fn5r-6;
	Sat, 11 May 2024 18:40:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH] mpi3mr: sanitise num_phys
Date: Sat, 11 May 2024 14:39:12 -0400
Message-ID: <171545260088.2119337.4929831740780777901.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240226151013.8653-1-thenzl@redhat.com>
References: <20240226151013.8653-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-11_06,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=671 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405110139
X-Proofpoint-ORIG-GUID: 2_CeM6H6WMscqr6ETyLzXXbjIzuSLWQL
X-Proofpoint-GUID: 2_CeM6H6WMscqr6ETyLzXXbjIzuSLWQL

On Mon, 26 Feb 2024 16:10:13 +0100, Tomas Henzl wrote:

> Information is stored in mr_sas_port->phy_mask, values larger then size
> of this field shouldn't be allowed.
> 
> 

Applied to 6.10/scsi-queue, thanks!

[1/1] mpi3mr: sanitise num_phys
      https://git.kernel.org/mkp/scsi/c/3668651def2c

-- 
Martin K. Petersen	Oracle Linux Engineering
