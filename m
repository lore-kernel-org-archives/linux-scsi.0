Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1381861FDF
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 02:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739156356; cv=none; b=GyfGCNUEFXKjM02P8psapmQ0bY70lXuU7ZZIR9MY0+/HNpZG5bhDjtdh9khJjDRwOVMdctOui1cvwLKATNAxrQqcwfvVLTzyUl622XIl2Z69PFvbJxBqD/MCnKHa7irbEVFpSPUca2YcgyGc/VlwvYd8EHVUupJLLpNR0253GsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739156356; c=relaxed/simple;
	bh=IErPcxplmmx1/qCAumIs8YufPqKS1tadzEvzOiwCikg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLPaSmGn8a1xjeaDAACq8DckogKLY4qtVsBKB756cKe2rcoMNZpdySV2cCQl8sUnYSwfkO36TuN9hysJU+k5CQ+B9oHrwJV3rd61mlGClWK+Ty6ObyOZm9Y8XG8SHocUpD0K8dOPZNVoQKOxmDdEAxcKLF9deiWq45EutyHlFeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JPbUHUpb; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JPbUHUpb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 519NVtJn032460;
	Mon, 10 Feb 2025 02:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=i94Wyi0bKEtE6Tjz5rWf8tO0+IjxjJlpgRBe+F/5Mjw=; b=
	JPbUHUpbpH6NhKo7+0ffITTSxunKkp5kaLFOE7DhZ4S5xCoegxxljWrSqr5fUpxv
	fh+HD6NqXzg8nXYcXmlbm9d5O3gEEmNeIlBUHU9a4WxEyAxh3IuQQQQqRSiBUG0J
	3U8sHKDyZO0aGb6Nbn9JEBbBULrC4VNuydQnwYDTikIMy5fcCFFOkdDCZZwfXyv6
	xjJEf1u2vyvGK5SfRiGkRiCMHg/MO76J22Tpvi1tOulu8EDlJ4ZohjNET33+6DYo
	DReqfyYpjPJ3JnYuxYBek4lkmTdGsZ3lldS89pRc0GmC/MPWqxwBe2bNEdKcYwyr
	rWPVlYSGhKztJvMfrh742w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0qaa39j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51A2C9xL012543;
	Mon, 10 Feb 2025 02:59:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq6uae3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:06 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51A2vwAb033952;
	Mon, 10 Feb 2025 02:59:05 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44nwq6uacs-3;
	Mon, 10 Feb 2025 02:59:05 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/6] Update lpfc to revision 14.4.0.8
Date: Sun,  9 Feb 2025 21:58:25 -0500
Message-ID: <173915612143.10716.8701750716065136257.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131000524.163662-1-justintee8345@gmail.com>
References: <20250131000524.163662-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-10_02,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=888 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502100023
X-Proofpoint-GUID: D8NT6nA3fcdAgRZ_aU-CHyZ044B96PA5
X-Proofpoint-ORIG-GUID: D8NT6nA3fcdAgRZ_aU-CHyZ044B96PA5

On Thu, 30 Jan 2025 16:05:18 -0800, Justin Tee wrote:

> Update lpfc to revision 14.4.0.8
> 
> This patch set contains fixes related to diagnostic logging, smatch, and
> ndlp ptr referencing issues.
> 
> The patches were cut against Martin's 6.14/scsi-queue tree.
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/6] lpfc: Reduce log message generation during ELS ring clean up
      https://git.kernel.org/mkp/scsi/c/8eccc58d71ea
[2/6] lpfc: Free phba irq in lpfc_sli4_enable_msi when pci_irq_vector fails
      https://git.kernel.org/mkp/scsi/c/f0842902b383
[3/6] lpfc: Ignore ndlp rport mismatch in dev_loss_tmo callbk
      https://git.kernel.org/mkp/scsi/c/23ed62897746
[4/6] lpfc: Handle duplicate D_IDs in ndlp search-by D_ID routine
      https://git.kernel.org/mkp/scsi/c/56c3d809b7b4
[5/6] lpfc: Update lpfc version to 14.4.0.8
      https://git.kernel.org/mkp/scsi/c/8be7202ad3af
[6/6] lpfc: Copyright updates for 14.4.0.8 patches
      https://git.kernel.org/mkp/scsi/c/ef12deb6ce74

-- 
Martin K. Petersen	Oracle Linux Engineering
