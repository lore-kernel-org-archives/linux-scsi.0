Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8932D63E8
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 04:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761797179; cv=none; b=jPKW7tSWBla1/V8t77Eo9AlzULw2CGUXZ1uvPJ+09CykhARrXUnxfnZdDIs5t4/d3Pu79XdLbFiMYKT6QSYYywuv186gXsDlXGeBdez0CLqlU3LVGAO+/kU8KBJHt82n4GDeeY29a5VJ5UF3BbfGZZuxsdBqDxh3h5YpOel/pv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761797179; c=relaxed/simple;
	bh=uCzNU7kM6rCDsU1AHKgO5YABIxClQC3Sz2cbubnxLE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=icxPYl77dc2iazCo4Mw3WOzGi5X7w1S6EXFRZeqRpXhrEnn7VadrYR0vsjpNWz5RV+fJZwcUIbMAAadirkCbqLhh9TUXw6eIF3GNcpUkx72z0U0ZBXrLxIxH13JSE2vACWzY8a1BPxwEAhaSiFfuRnZGaGsz1RDkyvTGERNyWrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VqBo1wa3; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VqBo1wa3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U36R2O001339;
	Thu, 30 Oct 2025 03:33:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=l84/v2HJ4tS/lQku5RuFnZgms2yPnnR6GB8rZdy4tQ0=; b=
	VqBo1wa3qUGNQ5WGFF38LWPfP0800C5g/VrmJfdcbJKvh+D85pcIx3pWreuXegZD
	ouxHhJw1Y9y5HCXX7oA9oJvM4Ens0zb9IaEP2cFTw4hcGeLtNCzX0D/k7a0OPbWz
	ChE/x1PF0fvlV2EL2KLg+SfKNJSHyzmdjDz+H266kPkd3AMj9todnoS02ol8aUge
	Sl2ogMjW3Idc2zS/0fnOt6euBrzLB17LlCBOcV7hzgqzCFPMJRGlrOPk9JSTCRKa
	gehLhOFrAdMI3gp7aiAadKE5fkg60+PJEgeRmEd22haux8pEEij4zwP0Phx2tJj/
	M0bsOMDXB7v0Ezb2gBj00g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3y02g2ff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U0uCxi007744;
	Thu, 30 Oct 2025 03:33:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33wm1kv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:01 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59U3X1nN023116;
	Thu, 30 Oct 2025 03:33:01 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a33wm1ku9-1;
	Thu, 30 Oct 2025 03:33:01 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 0/4] scsi: ufs: PM fixes Intel host controllers
Date: Wed, 29 Oct 2025 23:32:56 -0400
Message-ID: <176179516245.2050237.3254847944175771560.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251024085918.31825-1-adrian.hunter@intel.com>
References: <20251024085918.31825-1-adrian.hunter@intel.com>
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
 definitions=2025-10-30_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300025
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDAxNCBTYWx0ZWRfX/hTyx/R3EE3w
 8nHuihjY8gTetFq9fUQ47Eh1MvOstPtlFouWLIcLXmsFudnp/kYDxf72whFbVh6EddDI+qAQhXd
 yYQM/nGvPFiQNb3KLiJG/ITls87LjEwptGCTpFMFA9QuNIEuxNMqKvSXNJ8gxqKFBqxh3PTQXvI
 KUwLSdeZp4GJ+30Mq4aIQOJ3k8AzksKf6c8sLd0v+qbYu3z6GuP0c9SU/c0opBUsGdYYbAnX/oa
 M0h2jSvQezdA/forDc04gZS8G00g4Ant5syzXFzZP0YGf8x+ER+l+2n+y1/OK4clewuP3RCXnVy
 v5DIgazea6yEYSJ+Vz6WZvJGvAYs/YdFzmZsR//qslziTupwsGvEwDixvDKXeVU20GeB0NvGoIh
 DMg6P4XR3YYtLJfNKS7A1y+rQhrE9g==
X-Authority-Analysis: v=2.4 cv=PbfyRyhd c=1 sm=1 tr=0 ts=6902dc6e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=TYY7r4AlfqQ7HXVRb7oA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: Vy-YFpAhq5upNktDpEj2g9l7C_VFmE7_
X-Proofpoint-GUID: Vy-YFpAhq5upNktDpEj2g9l7C_VFmE7_

On Fri, 24 Oct 2025 11:59:14 +0300, Adrian Hunter wrote:

> Here are fixes related to power management on Intel host controllers,
> primarily ones based on Intel Alder Lake.
> 
> Patches are based on 6.18/scsi-fixes
> 
> 
> Changes in V2:
> 
> [...]

Applied to 6.18/scsi-fixes, thanks!

[1/4] scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers
      https://git.kernel.org/mkp/scsi/c/bb44826c3bdb
[2/4] scsi: ufs: core: Add a quirk to suppress link_startup_again
      https://git.kernel.org/mkp/scsi/c/d34caa89a132
[3/4] scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL
      https://git.kernel.org/mkp/scsi/c/d968e99488c4
[4/4] scsi: ufs: core: Fix invalid probe error return value
      https://git.kernel.org/mkp/scsi/c/a2b32bc1d9e3

-- 
Martin K. Petersen
