Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931B218FC84;
	Tue, 13 May 2025 02:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747104544; cv=none; b=QDkEMa5lWid+pFzLlsEotQhF4eL99rNdYgKTHe/JkE3nB3ejMQlz0Reqw7qUfs1UnSbSrpW19dZYWSfj+sZl9zWa/aG6LIvyXD8gbUBN/roUiAX6eKZH+BwsD1ALtnwo5oOCTKbtpF2mSgKwVJP/SA6R7FFa2BgJ2o3Bq1FDnkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747104544; c=relaxed/simple;
	bh=pBX/oUzsEo1LV4tctV9LD4g3WzeoLRn/whfEkpiXVdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X0l/Rbym9ohTAbLX6kISv9m0kHgGMELwGD1Kqn8pkUX8BXY6vr1xNvdHPPlf/LN9Y6ULeYoP9szFzZ+wsyqC8iDrP+uJx47XgjoMmhhAt+D/7iufASGn0yGHlt/ZLM5e8ZLELoibN88WBxrrCL3qiSJlH1izGhd1ANHFsdFltxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tkrka/sT; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tkrka/sT"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1BtaE000697;
	Tue, 13 May 2025 02:48:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=D/12QSDbuk9xt6YnSqN5OVKHORv8FJggQOjkp0udJkM=; b=
	Tkrka/sTTbQVoZy/wFcxATfMBvCSVvTOAfyI75V6Oj8F+S8UN1k1ghTtx1RBJHqr
	ZBCuKwrmEhvNJowVUppc8Hw3/tJqb32AgvTYcY2+ifPXNgDW3igGl/GLLZ04HSyZ
	8tR2BAnfc7RUcW4jN2Iokscg16btI58iL5D1ZNK8qJjncg4zN+U6SRPMFjy7272J
	KkjY2p9O5GKyc3PFBlg8KX/iK6fOM2rH/+qKTPCoSH2zJrohgMBZqYiDjWoTp14w
	el/KDSwlZ3qZclfVDFyL/nnEvJnDpSbuqp/syj9m9obE6zxuV9CgpJ0+O437ZoYJ
	CV4SoMKeQNebrulVDpqTkg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j0epkrxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:48:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1TODd016170;
	Tue, 13 May 2025 02:48:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46hw8841gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:48:57 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54D2muX6003994;
	Tue, 13 May 2025 02:48:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46hw8841cw-2;
	Tue, 13 May 2025 02:48:57 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Remove unused scsi_dev_info_list_del_keyed
Date: Mon, 12 May 2025 22:48:11 -0400
Message-ID: <174710241025.4089939.14357129967241630750.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250503230743.124978-1-linux@treblig.org>
References: <20250503230743.124978-1-linux@treblig.org>
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
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=972 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505130025
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyNCBTYWx0ZWRfX0IFlRn8f4Ees wnDIwt0kTSrA6pmyF0yctbcI40npDwgYtYDiS/opaiC7bGf9G9cO4iMpXx5o+gwkJzjXfaojQod 6kF+uQ4+UbmDhHH3ZZBmhVMFgJX5uDXvzAhTmCSJAGV9nJ+TsbaIUPmbRebw0tuP86Z7aDNdZf6
 Cq0yYmNkYN73qekDsuXfzvBKOlppCwAihaYfb/lyiBNq0ukmu8G0Fd+cc5lXSMI2lz/4liJcqGr Vic2XSmqBdCE9yqlE7jTrDHPgCAp6WkD59uC09NA1xCe6GIFPbeDkUT2iFZWzZt0dvZNtaqcSpt 7KFUqMI897feB0mMgRbSkgq18JvaDP1u6ls9sJ/Nur15Ulalf9IKeRgj7kxbFO53gjI/8Egeoq7
 nbBYiu139H3l7Nk22frMjaHgNPVqJE4RhK2i0hZQ0F5+X5d1A7OLX9DDgGqxHijAm9t1JTN3
X-Authority-Analysis: v=2.4 cv=DO6P4zNb c=1 sm=1 tr=0 ts=6822b31a cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=3WJfbomfAAAA:8 a=r4YeyHfEzw9qaAjqu8sA:9 a=QEXdDO2ut3YA:10
 a=1cNuO-ABBywtgFSQhe9S:22
X-Proofpoint-ORIG-GUID: jeQuA0oOmlOIGpBJPy-PqobBwb28MYth
X-Proofpoint-GUID: jeQuA0oOmlOIGpBJPy-PqobBwb28MYth

On Sun, 04 May 2025 00:07:42 +0100, linux@treblig.org wrote:

> The last use of scsi_dev_info_list_del_keyed() was removed by 2011's
> commit 2b132577a05e ("[SCSI] scsi_dh: code cleanup and remove the
> references to scsi_dev_info")
> 
> Remove it.
> 
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: core: Remove unused scsi_dev_info_list_del_keyed
      https://git.kernel.org/mkp/scsi/c/e256821fbe43

-- 
Martin K. Petersen	Oracle Linux Engineering
