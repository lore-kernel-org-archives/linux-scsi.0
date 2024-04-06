Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73DEBE58;
	Sat,  6 Apr 2024 01:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712368748; cv=none; b=L/Nl1481tdFio+q8zSCvAUvkTl/iyEFTBRNOPIUXoTdbAHTwtQustvdnQbKfLxkB0DN0sCTJelTZkc2c17ZOwVSLpC/uWUVkc6pkyGJNC4fEiQ4rGIHLUewed+DRY1nO0/DFmk7P5y4pK2v4pB1k8AeFG6Lae49HgBZwA9NGtRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712368748; c=relaxed/simple;
	bh=wIkWyqZniZYzekGWs8q4lFnPM4o4DGCtpTVrYxa9t/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TlTvki333cxdFPRlq9R+MwRniPpanBzbTWl0ngy78RjhjaYZsogvwcG19wBd5MJ4E8faDzLzZQzXpJ0bdvKFIWOr8X0uWXmYOU3CYw2GIY+pfqFfdXuZ36NxnwsTjanDtlOuYVa+VpqveSVlJNkxgBNNbwUtXpEjwT6n9dOl9xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FqoC2G3U; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FqoC2G3U"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4361PfX0009086;
	Sat, 6 Apr 2024 01:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=QlpodhCcxa5L7EjxXui40IV0K01oC0uGxVd3pVsrKjc=;
 b=FqoC2G3UdLt2mmTyTDeHWLn3zscE1pLougG3S9d+M1RXdChBHcLL3NubQBx3QlAKMApj
 YHeW5Bpdz5pOy/Qj7JwjMvsVH6qJXhm/Z8ln3nkaEuZ7IYB4Sezo6PBi6+v0ZRMCuFEL
 TD8wKzxiBVgLegfOYGTYADP6OiGvUiLkiK+Jqi41CCAbj+5T1gsBjMmFKIDKYGj/MFxn
 zPVvkUkV2i36H6e/HSXGRYhckev1HW6UL8nSNLvCZZTgEPU+nPj6npg6CkCEGZ83oUCo
 ycRR1lviSFv/fz4ogYuceivUSCtNgLOXgBW7AJpapP7Q9OikJWDD3WIiVJCiAQj0eNhV kQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9emvvnwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Apr 2024 01:59:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4361XRCp032429;
	Sat, 6 Apr 2024 01:58:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu3rerk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Apr 2024 01:58:56 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4361wqvc000912;
	Sat, 6 Apr 2024 01:58:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xavu3repx-4;
	Sat, 06 Apr 2024 01:58:55 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: michael.christie@oracle.com, Maurizio Lombardi <mlombard@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, d.bogdanov@yadro.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: (subset) [PATCH V2 0/2] Fix SELinux denials against target driver
Date: Fri,  5 Apr 2024 21:58:34 -0400
Message-ID: <171236847470.2627662.1362215447249668581.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240215143944.847184-1-mlombard@redhat.com>
References: <20240215143944.847184-1-mlombard@redhat.com>
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
 definitions=2024-04-06_01,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404060013
X-Proofpoint-GUID: VYssn9eTGa0d66FYDRR_T5tgAwfDJdvC
X-Proofpoint-ORIG-GUID: VYssn9eTGa0d66FYDRR_T5tgAwfDJdvC

On Thu, 15 Feb 2024 15:39:42 +0100, Maurizio Lombardi wrote:

> Steps to reproduce:
> 
> 1) install the ibacm, rdma-core and targetcli
> 2) service ibacm start   (ignore the errors)
> 3) Look at the dmesg, you will see an error message like
>    "db_root: cannot open: /etc/target"
> 
> [...]

Applied to 6.9/scsi-fixes, thanks!

[1/2] target: fix selinux error when systemd-modules loads the target module
      https://git.kernel.org/mkp/scsi/c/97a54ef596c3

-- 
Martin K. Petersen	Oracle Linux Engineering
