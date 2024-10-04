Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DDDD512;
	Fri,  4 Oct 2024 02:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728007731; cv=none; b=R6RhglWwMSoaQad1zQwBeKk1JoMLrGu+tqniij6wXrPLNqaF6ODZ33nZihhDraiF38nEq9L71hr1+nTlwvQQ218lvtZ/G98iB3Mc4y5T+UgEwQDdZGIbKwLUBv8Jx1tmAYzhYHkCxA6SyFcal3J4Mu5+K4zwgQ+OF8VsfJpLcds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728007731; c=relaxed/simple;
	bh=8WgGu3EEynwIv1XV5gQwT47KdjSCSGbQKaESUPMTo+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iXiMc1NNYJxcUPBCzFi7hX5q0Yj6qepecytyKQ+UzU3zKsY8KL3Qw3Kb2xJiEI1pPE9hi3gS8J7+KI4oKWt0rB4cJ/SYQ0dGUcRUKRuBtY8RMLzmb8/jzmgqKAfAQ1rbRILMmBvVjfWPHQ3wgd6Pr7nTR1sPbqMGhYNnFygolM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=avB6+Tqe; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="avB6+Tqe"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940tdjV018014;
	Fri, 4 Oct 2024 02:08:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=j6cuxY/FffKhK/wUc9RQZRcnqyLzArM4skln/J34bhU=; b=
	avB6+TqerQhlqPpTZNb5TZHd/bmvgpWhi51WdUcWL2xtYmj3b60bUDDq7/6CGO0P
	idXGGWDES9nuu4xoZtslrCajVAiC5Gp1oiFkpfcznQcrcNIEbf26PeyMaIs5dN2Z
	hh1GjKFARDUfOShHBq/w0zabeyE2D2ktS/GftlnepybqnVNBnSt4Bn2gB49n4K7G
	U/ziY79DZwU5pEn4CcPaUS05NkrtkP146bvGYzQsf+36DwF0OmDt+mN8hQqGfR8N
	H7K/ODwxvhmInG9sXSA2bvG1vdLvjOlR1im2m8uNGfQ9WCaDZlMeiaVv5feYJQ6B
	/lslOoFFqBGnmiGU9QkDSg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42204erp0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 02:08:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49405vdZ038441;
	Fri, 4 Oct 2024 02:08:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422054pb1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 02:08:47 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49427blc036075;
	Fri, 4 Oct 2024 02:08:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 422054pb11-1;
	Fri, 04 Oct 2024 02:08:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb
Date: Thu,  3 Oct 2024 22:08:06 -0400
Message-ID: <172800766868.2547528.13244857963490989809.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240910044543.3812642-1-avri.altman@wdc.com>
References: <20240910044543.3812642-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_01,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=995 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410040014
X-Proofpoint-GUID: S1tBxJ9nWDfRE7nP4HZ2V7tDoedg8dh0
X-Proofpoint-ORIG-GUID: S1tBxJ9nWDfRE7nP4HZ2V7tDoedg8dh0

On Tue, 10 Sep 2024 07:45:43 +0300, Avri Altman wrote:

> Replace manual offset calculations for response_upiu and prd_table in
> ufshcd_init_lrb() with pre-calculated offsets already stored in the
> utp_transfer_req_desc structure. The pre-calculated offsets are set
> differently in ufshcd_host_memory_configure() based on the
> UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk, ensuring correct alignment and
> access.
> 
> [...]

Applied to 6.12/scsi-fixes, thanks!

[1/1] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb
      https://git.kernel.org/mkp/scsi/c/d5130c5a0932

-- 
Martin K. Petersen	Oracle Linux Engineering
