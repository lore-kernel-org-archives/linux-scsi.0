Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5E11A0734;
	Tue, 10 Dec 2024 02:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798208; cv=none; b=FD3S/YHQX/umF13Y9XuiDiUf2DqsLyuSwm/N2WX4aVfFPJqNfa5grNmF5ZAmwLrDThrbEf2ypigs14dG49HIbSSuuPirx6mQCQ4OHgBFVvJ1+0Pxna15VD1dCEAqUo4wBl1v1u1FFcqOA3SVUai7/XLfAKltU6MLmFKHQdzYMBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798208; c=relaxed/simple;
	bh=eLfmnR4vxpcbYxLI6lD2Q2FXJZ5uBbHu+IQcw1+hbg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QNFu5feuODvtkyU2NYMGsd+Xql25ecsnnwOQcK2+aaosR8n7PXTvhP/xb0veui7Xbhbgotia0S4940Byae7ZxEtFo1kS/NhnNmu722zZDxOvvgVfVCdZ6/MHN63bEYR5oy9VLMSuFdM9vdRYYJsb7Z7Rx9IB+ELS4ln+xVXoT/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UmLWR5/3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UmLWR5/3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1BuVs005416;
	Tue, 10 Dec 2024 02:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=kRATcHBz1uLl39r9mue2y5/++MSVY3TMpTapSyKPzzU=; b=
	UmLWR5/3HSmDK1X32xMHtH8KglrifYuUxf2TnkbqVbTt9/TmPzNKKTbhTdLnEPvW
	3APIcaoedXZQaYqiSRZ1kLGx7tzJLd3v7pFtHdEKBDYa94QUkdiDoBVPRqbteX0L
	kgOJyiSEh24GPi+QjGgeME3VHeumBaWt9OBxUL6PqSL3dnDdhVGm8SBfOC7P/tQo
	WjB0gI0W6m4hdcFgjLODapdz94nEKfeaFWiXwIrNVzCNlqjfNbqvmNpE0i0gpcjT
	Msc+c0zG6DNCH5hnb/XU9fK2qOluDDW/XsBqbyJW+rj2MXbYrl4yUV1JapVG7V83
	YBQF3O8fTbcUlGRX2Yp9kw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cd9ams63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA0VQw8035101;
	Tue, 10 Dec 2024 02:36:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf7y80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:21 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4BA2aIux010256;
	Tue, 10 Dec 2024 02:36:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43cctf7y6u-8;
	Tue, 10 Dec 2024 02:36:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: Replace zero-length array with flexible array member
Date: Mon,  9 Dec 2024 21:35:39 -0500
Message-ID: <173379777406.2787035.5783892725479689291.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241110223323.42772-2-thorsten.blum@linux.dev>
References: <20241110223323.42772-2-thorsten.blum@linux.dev>
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
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=578 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100017
X-Proofpoint-GUID: Ez0p7d2FzmCJsv1oSr3ppsVCTrnXYbOO
X-Proofpoint-ORIG-GUID: Ez0p7d2FzmCJsv1oSr3ppsVCTrnXYbOO

On Sun, 10 Nov 2024 23:33:24 +0100, Thorsten Blum wrote:

> Replace the deprecated zero-length array with a modern flexible array
> member in the struct iscsi_bsg_host_vendor_reply.
> 
> 

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: Replace zero-length array with flexible array member
      https://git.kernel.org/mkp/scsi/c/cdb03e598750

-- 
Martin K. Petersen	Oracle Linux Engineering
