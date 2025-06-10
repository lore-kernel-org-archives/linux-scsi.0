Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4879199FB0;
	Tue, 10 Jun 2025 02:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521247; cv=none; b=nx3D0OJBI2C4h0GLk4reS8NMmudoG99R1UZAnNgOXlgv2IvkT3qEwHMKiUOUU4oIk2pt2dTR7iuzt2vYfrYL/SMCxjP/GsIlijDqpxItQcijK3C9754OixYPDXULdpImV0A1WUToJq9tg1KVROwAyxICMJlPDua4itH+DbiIhuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521247; c=relaxed/simple;
	bh=Khl0Gg08PltbgoVPqbTT3Z97rJkwsl2X1WNPBoLia6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/HYh3Y8PijrTkNAiawS7bMRqaPOi27afnyXcJzGwaYn23eGFx7hOar2gfqp4B0/XItsJrBSivJDXeTjzrgiHUuGY+5biDljAp5mSBdwufeDauavpYdYxmwVJ9wF+6HRoC7w9mrQfNwJmRdeMiC+0gl0GyamFVRSYTYgLSh5ph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IUmJFtM1; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IUmJFtM1"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 559FcrTI017589;
	Tue, 10 Jun 2025 02:07:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Jm4iZhusmRIAIRK6bbhztOQOKbIJTVCtBKJZMx420iM=; b=
	IUmJFtM1jQa/vi9cfNZG3gpbGKx3Yq5AUe882tCp4pSWVQ0kbaQBaO1h+SOPbY+f
	3n8vwiRXbSZ5nbvuNBmF/CJaUqETJ7o5UNMUx3YqeWo6+MebTzT1sg+yeRizvQ2M
	Py84fTwn3WT8lWk/XFz2dr34O4XsOCp1bt2xRNnW1CNh+uz0UFXJjWu8HUrMex1S
	3Ox/obzQsXiEHtCC+l2X8/vWisHiaYW5BSVgjD+foqw4SRdmD5i6Lq0DVfDFGYPQ
	5C8yqIUg0O2GyCnfMeIW1VDmBvj1BFV6EhVyFxRnd5mOkgk8JK03d/1yb+RYDeFc
	EhYRsyVNwC6cAzXlfwNl/Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c74u9mu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 02:07:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55A1A7eb031370;
	Tue, 10 Jun 2025 02:07:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv84jff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 02:07:20 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55A27Kqu016523;
	Tue, 10 Jun 2025 02:07:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 474bv84jet-1;
	Tue, 10 Jun 2025 02:07:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: lduncan@suse.com, cleech@redhat.com, michael.christie@oracle.com,
        James.Bottomley@HansenPartnership.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, darren.kenny@oracle.com
Subject: Re: [PATCH] scsi: iscsi: fix incorrect error path labels for flashnode operations
Date: Mon,  9 Jun 2025 22:06:45 -0400
Message-ID: <174951883633.1141801.4572248277182090285.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250530193012.3312911-1-alok.a.tiwari@oracle.com>
References: <20250530193012.3312911-1-alok.a.tiwari@oracle.com>
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
 definitions=2025-06-10_01,2025-06-09_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=932 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506100014
X-Authority-Analysis: v=2.4 cv=LIpmQIW9 c=1 sm=1 tr=0 ts=68479359 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=ZFjwF5Gz_3r7dmuddG4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _7ALXlVP53ua1-rp-P5BFxVJoc9viP7i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDAxNCBTYWx0ZWRfXznH9xBxmX5Vg W/+c0sx4YQOgQwQWeVUz7aCYRY2JhGpY64C+fe0H7pPDW3xyLUbTF6/Bxqe24h4nzTBbyDZEdu1 J/Eq6lHF90K3g4vnTx66XWXuJkt2UevV03VgW3CCMCLWW3m/4EnqHl7rB4JG8vF1p4dIKxhjlaj
 nxAIdpYJaSNYyioat9G1ImqCrYvA01tpmpsj3gdjCAwrxOrcb2gpNx1S7+wnMxdg+O1Nnfpf9kl zxOx1nMCfKRLUAD7lAw2V7MQ1DxTgDruZkzCXlJOkmJaUwcaMJ2DavxCK2z+Hvw95NH5go5P+uv 8rkYSZR1WllltKMZgqQR4HrSv+Ss7JO+5FayKBTi84IN2zWKyn4IaYmJ1EhRIRXfK/SbzikyEX3
 nxKtRhY0hogBliUvbBRdfweKQmNUPWlgE5hkqlTK8ITeSr0cy/S+VRU2FVFLTVkfBg+1E2JY
X-Proofpoint-GUID: _7ALXlVP53ua1-rp-P5BFxVJoc9viP7i

On Fri, 30 May 2025 12:29:35 -0700, Alok Tiwari wrote:

> Correct the error handling goto labels used when host lookup fails in
> various flashnode-related event handlers:
> - iscsi_new_flashnode()
> - iscsi_del_flashnode()
> - iscsi_login_flashnode()
> - iscsi_logout_flashnode()
> - iscsi_logout_flashnode_sid()
> 
> [...]

Applied to 6.16/scsi-fixes, thanks!

[1/1] scsi: iscsi: fix incorrect error path labels for flashnode operations
      https://git.kernel.org/mkp/scsi/c/9b17621366d2

-- 
Martin K. Petersen	Oracle Linux Engineering
