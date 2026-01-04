Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F93314D15;
	Sun,  4 Jan 2026 21:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767563012; cv=none; b=Pcq5RPRdljdHIkhzQ3JV89djJZfwjiyRR/T9BA4krDLGaGGWmqspOW+cCt2N531p+dw2DswzTVCBsCgtpdKQx0KZ7wDUi9kwZhmv9mqoTYqGRVt5/sMvaol1jUv1tQLO1t1rAhX4laJ0yp1iN1J9UU3h9sIyxQ6wYbhZW6NMufk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767563012; c=relaxed/simple;
	bh=ajlSs3fZGY1pvLcPj2DVYGlWoPc+75W7+DMe5+Wxe+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XixX47pYlwfe2z0TNiU8zd3EZ44wbnBxyJMKt4qJmLndF54TIRo7mAczspFuyaHcedlOVLdOmGGUJN3OIbFuc4EXOPbNpBOiU7G2ozTj2mfVP/FKDIpKPM/lDGp7zH8Yqi8fuELh/4fdmoKaaSmJadldGH31S9OlbxB0R4LrEkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qAENVFi+; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qAENVFi+"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LhSHm488499;
	Sun, 4 Jan 2026 21:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ReUQC4yztGXP0SOAc66uyxdWYITC6g6sGGq9DW57a90=; b=
	qAENVFi+I54fUd5ch5ArcIVpc3nDmtl9K+oNuX0Q3TwmGKE0irFh7MV+Kt4COdt0
	KxsXi/wiTiTPngllpRQE+WXftGudxgub3tGJvcDgXzN+OvMKmlMlF+TPSCeh3hD9
	Xbk8e6eoOLbHGigiGNEEMN0RaGC87r4rhg+hMNhQcWfDVtxIwPzY0L8j2qTSTTSz
	N+EZ4Vb9AbhxXWAbEYLD8pqu27UXFGCLLvypmPXLAfaDJHhDtN4PzdX/ct2hwt3P
	wmw0v9tEzP1fmp4c5ri2GHP/Xp539IRThrJy4jMWo7j7kV3UhS6HHmKibKngFT78
	vKmw+GrBrl9BnskQr2PqpQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev2jgyp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604H1GGc027366;
	Sun, 4 Jan 2026 21:43:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj6gbgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:26 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LhPoO007658;
	Sun, 4 Jan 2026 21:43:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4besj6gbf9-2;
	Sun, 04 Jan 2026 21:43:26 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: john.g.garry@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, Gulam Mohamed <gulam.mohamed@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V3 6.19/scsi-queue] scsi: target: core: Add emulation for REPORT_IDENTIFYING_INFORMATION
Date: Sun,  4 Jan 2026 16:43:08 -0500
Message-ID: <176755562228.1327406.689464773638662127.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251201110716.227588-1-gulam.mohamed@oracle.com>
References: <20251201110716.227588-1-gulam.mohamed@oracle.com>
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
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040200
X-Proofpoint-ORIG-GUID: s-clf9BiXjSUAXPel_RhqJfrbYtSOB8f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX+/udLYvrZXW0
 ce7Le7X3zvmQqg0v2FNEf1ZkCxWukBeg0mvvmIsYrYX5R2IHp8k5QffgfOc6onBqaKnJmnByx1Y
 4t8vI5hPvbG2EJ2ap6ufzI63to7z+Whi/iUZxk1nvx/35GbtfOIk0803vhXmZwTicnPMrmL/xuC
 UJat2s157nwYNoLvl0tUHrhzdJvZoCJ4VnYhoq+60W5x/lJ7vqTu7vE7vuXiqpb6EjxK2PuOip+
 TO458Mqo3CLJL3HOv9VuqKo+NL6ij5NhsL3THm2NXLfaSNPH8X0HNs0JzKzImqNPU8qAv/so0oh
 YcPNzN65o/JLpPqmLUNS7hYtopWhRUTahczohcmdcgp/sdjy0efp4Bomg1KkSxg/IaAuvY93vmD
 mORKEQL60sPBpok0K2UclHvJXGcsXOhCWcBCtg5EW7H4askmtRwyYbRo1CiaNS4/a0Lz7DanTEz
 Jxa6Y0zOKnxC3w2bufg==
X-Authority-Analysis: v=2.4 cv=A9hh/qWG c=1 sm=1 tr=0 ts=695adf00 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=w2h7RB53Uq-13jtNowoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: s-clf9BiXjSUAXPel_RhqJfrbYtSOB8f

On Mon, 01 Dec 2025 11:07:16 +0000, Gulam Mohamed wrote:

> Add the emulation for REPORT_IDENTIFYING_INFORMATION command using the
> configfs file pd_text_id_info in target core module. The configfs file is
> created in /sys/kernel/config/target/core/<backend type>/
> <backing_store_name>/wwn/. The user can set the peripheral device text
> identification string to the file pd_text_id_info. An emulation function
> "spc_emulate_report_id_info()" is defined in target_core_spc.c which
> returns the device text id whenever the user requests the same.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: target: core: Add emulation for REPORT_IDENTIFYING_INFORMATION
      https://git.kernel.org/mkp/scsi/c/7011e8aafe8c

-- 
Martin K. Petersen
