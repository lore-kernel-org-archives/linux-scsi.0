Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20252246333
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 02:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763002036; cv=none; b=sD75/LB53NUWLty7+fVxIWpRy6j/kgrDeZniLCfWnAG15wLvRLG8j8AxA2CCPoVOJUfkuBjMCMTo6p9+ywBgw5fHFhNSoA0so2b8CxBw1BgslBx4ICnpwQT/HoT/nZjR6pzI0Ue2SSzM9CyFjRV+cfK7SMCn+k/kxAsD6Ft/uAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763002036; c=relaxed/simple;
	bh=6ECJumTY7qdef4wdra7aUmy91Kj0u3mc20v3K5QFwh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sd8RnBSpW1kyDxiA6BW6324GzXV4KMGYHp9Jp6NsP+x2aFcNJsijneVgabK1WTO7gMwR6aOF5DLEm+HuG+U96oeYKZRCnWY0o9ph+17cNV3swe5EidUThIULWZVL378rv37Ktfb4hGt1j0ZVfTaHxlQk4FMRCEPFZ6Qw696wFqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EBHirOWR; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EBHirOWR"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gdN3022715;
	Thu, 13 Nov 2025 02:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=o70vx6EBTA3lYXXm5OP1a1dfUB9RZA9FCByRiMkfowc=; b=
	EBHirOWRl3PNWZJ7DH+jUz/+mJffyG53mPCJ9vJ4Xpo0N9BvanFxRaRAuZv23/EC
	u07+FEJPAVWBpJD7BpNKKrxki8Mu1eRhUFK7W6dnONNHRr5sJ6Oyh5rFoKiwDj11
	JDdKIs//G9qf6zHs5emMl+6vG18+xkftAwF94Yirk7uSjef4Hu6gjsrwu8aSw5SA
	MoMVYypkBFSF2T/0NVWinHa4WPNmnf05414awl+dgRS4KyU4DoOER8MKOsud/kin
	1wGs8chYNzzxYKxRHpOwrROmZT417ZWKMWfHkYAQZefwEWqpfJI2A88jIW6YgTld
	0a1wPVu9jCbWMycYKX2QPw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxpngvwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0hUl6032374;
	Thu, 13 Nov 2025 02:47:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9van9qbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:12 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AD2lB8H038323;
	Thu, 13 Nov 2025 02:47:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a9van9qab-3;
	Thu, 13 Nov 2025 02:47:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH v2 00/10] Update lpfc to revision 14.4.0.12
Date: Wed, 12 Nov 2025 21:46:52 -0500
Message-ID: <176298170743.2933492.18175595112500219970.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
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
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=970 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130017
X-Authority-Analysis: v=2.4 cv=Criys34D c=1 sm=1 tr=0 ts=691546b1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=D_de-cIvgTHZ0l0ZsKcA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12100
X-Proofpoint-GUID: qcfHL61mmmlNbj65jy5OCfZcN6hx6Iju
X-Proofpoint-ORIG-GUID: qcfHL61mmmlNbj65jy5OCfZcN6hx6Iju
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0MSBTYWx0ZWRfX1Dj/2rQujJJN
 mOcb1tD0EJmnN2CyUiEzwAHsRQU7Q3pOP2rZ6scPBzkVBpEaTNG21sztmmoclPW5qM0p9TtTtmL
 Eb7b+ppWuDNbzuq2OWWbpVg9aj/CY5N/XDATaKFPqWExONk4AWHW2O4eRR+r63iPzWM8qAr0YKS
 XIjytf2srdpjS/s+bzr/B5t2lmE4STNtgLp8Blgc5bCwPhVMVTCOvKhFI9lzje8foNajkkzrq0P
 IZI9h/ASnTIJjlcbI8gOZX1F0PpfmHce4kyTlyrXSKMGu1IcUw5z5te+bxYu/VauNrjhuLNcbIc
 3lLK6dV8UYjqwxEo9EUssh+/JpYV/CwF0gQO4WARCG6cKGSfkYGkwZkRhkUHGniRbNBa/L5MF6N
 hI2LMnnEg0w0Ky/AOtFAi1lxscgehke3uh1uv4aOsxLGAvGfoVw=

On Thu, 06 Nov 2025 14:46:29 -0800, Justin Tee wrote:

> Update lpfc to revision 14.4.0.12
> 
> This patch set contains updates to log messaging, revision of outdated
> comment descriptions, fixes to kref accounting, support for BB credit
> recovery in point-to-point mode, and introduction of registering unique
> platform name identifiers with fabrics.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[01/10] lpfc: Update various NPIV diagnostic log messaging
        https://git.kernel.org/mkp/scsi/c/051d4b65e839
[02/10] lpfc: Revise discovery related function headers and comments
        https://git.kernel.org/mkp/scsi/c/f7a302e4759c
[03/10] lpfc: Remove redundant NULL ptr assignment in lpfc_els_free_iocb
        https://git.kernel.org/mkp/scsi/c/3c228061c80d
[04/10] lpfc: Ensure unregistration of rpis for received PLOGIs
        https://git.kernel.org/mkp/scsi/c/6f81582b7a9d
[05/10] lpfc: Fix leaked ndlp krefs when in point-to-point topology
        https://git.kernel.org/mkp/scsi/c/23f4906729a0
[06/10] lpfc: Modify kref handling for Fabric Controller ndlps
        https://git.kernel.org/mkp/scsi/c/0b8b15a0b74d
[07/10] lpfc: Fix reusing an ndlp that is marked NLP_DROPPED during FLOGI
        https://git.kernel.org/mkp/scsi/c/07caedc6a388
[08/10] lpfc: Allow support for BB credit recovery in point-to-point topology
        https://git.kernel.org/mkp/scsi/c/683df5fc3ec5
[09/10] lpfc: Add capability to register Platform Name ID to fabric
        https://git.kernel.org/mkp/scsi/c/191da2c71b13
[10/10] lpfc: Update lpfc version to 14.4.0.12
        https://git.kernel.org/mkp/scsi/c/d45fdc6cdd73

-- 
Martin K. Petersen
