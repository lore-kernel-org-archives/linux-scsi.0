Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC9C1C698
	for <linux-scsi@vger.kernel.org>; Sat, 11 May 2024 18:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715453653; cv=none; b=cUjuyZCZneLabC4gmJcPbvwPWahKltIGfcE+oSZSmlKL34Go9fmT8ZZeYIfCOse5d3nSnyl0X2CrAqyDYBYO4LqUZs3xpKTDxcsVS9sRGQlRgMEC2KchHJQ9w6s2+w194Oo4D+CU73XJHLajyFVfWmqZ1WqUPonn1Riv4XDjlak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715453653; c=relaxed/simple;
	bh=dDYwXr2u2Amx74yTMT+VgO/23kFoZxx68dZOk3HNw2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g04Eq/pShKCrHmLxG2lZxLsiYMlvZgdIhMH/2U+urvxbslILNOVnA9MMMyRlJ9w3ympnPspeZSSW/g2TpjNGbKRmUJ8N8MFPOgiBJrU2ayksyAS9UvUGTYmxxBeOiggAF2XapB9WnzNrt9ZqVe5rLLRjKEFkO4i8kpFFbW6mq5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JmL1Csxh; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JmL1Csxh"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44BIpFE0019777;
	Sat, 11 May 2024 18:54:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=ivmxaRsDVGtjQhGPC3J6QZyZo1H88PP1k38/rqqFsXQ=;
 b=JmL1Csxh7zKvTGk9OxXB/gsB/71e6UsNyvTyd2SXccYkndRx+fhpLpHiLKk1YBALudzv
 D+DtGGcZ7Dr/a5VHflFHd1SHLikziIgJrnUmOU5SXZ71u7lfdW1rfaA/PO+KN4NcJyGG
 jiMblue7BaofBKida0qR6xxf2l1kvdIOFRXrfZGFw8+rL9Uv0Elh7vpO2OKuuWVlqRud
 sQeGeWybfSEkTKnXhy2r6v2gEVzeEJr/kkZIFz3DXxV946nsbQlsMu7u22tbHguyqA6a
 exk5ZZFVPJbhsI8ljmRmeNVcJXYAuUy2TRydlUYNXV+IAnwi9mDEUARcPD7pPjpSz0rp 8g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y20qd0jbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:54:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44BF0aXO022491;
	Sat, 11 May 2024 18:39:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y44fn69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:39:52 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44BIZYPQ028255;
	Sat, 11 May 2024 18:39:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y1y44fn5r-2;
	Sat, 11 May 2024 18:39:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/8] Update lpfc to revision 14.4.0.2
Date: Sat, 11 May 2024 14:39:08 -0400
Message-ID: <171545260086.2119337.17731940731359054022.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240429221547.6842-1-justintee8345@gmail.com>
References: <20240429221547.6842-1-justintee8345@gmail.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405110139
X-Proofpoint-GUID: UDWxECzvM65PhjVIVKPSQbJFkN2wt0gC
X-Proofpoint-ORIG-GUID: UDWxECzvM65PhjVIVKPSQbJFkN2wt0gC

On Mon, 29 Apr 2024 15:15:39 -0700, Justin Tee wrote:

> Update lpfc to revision 14.4.0.2
> 
> This patch set contains updates to log messaging, a bug fix related to
> unloading of the driver, clean up patches regarding the abuse of a global
> spinlock, and support for 32 byte CDBs.
> 
> The patches were cut against Martin's 6.10/scsi-queue tree.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/8] lpfc: Change default logging level for unsolicited CT MIB commands
      https://git.kernel.org/mkp/scsi/c/1db60fa05929
[2/8] lpfc: Update logging of protection type for T10 DIF I/O
      https://git.kernel.org/mkp/scsi/c/18f7761d5c6f
[3/8] lpfc: Clear deferred RSCN processing flag when driver is unloading
      https://git.kernel.org/mkp/scsi/c/bf81e9cd1767
[4/8] lpfc: Introduce rrq_list_lock to protect active_rrq_list
      https://git.kernel.org/mkp/scsi/c/5f800d72762a
[5/8] lpfc: Change lpfc_hba hba_flag member into a bitmask
      https://git.kernel.org/mkp/scsi/c/e780c9423b10
[6/8] lpfc: Add support for 32 byte CDBs
      https://git.kernel.org/mkp/scsi/c/af20bb73ac25
[7/8] lpfc: Update lpfc version to 14.4.0.2
      https://git.kernel.org/mkp/scsi/c/37a8001d7b9f
[8/8] lpfc: Copyright updates for 14.4.0.2 patches
      https://git.kernel.org/mkp/scsi/c/3f1d179f8f47

-- 
Martin K. Petersen	Oracle Linux Engineering
