Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334D31AAA26;
	Tue, 10 Dec 2024 02:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798190; cv=none; b=sQgztXoog7rxoK1YD34/IVB3zEnYEl3uMwyY2n3b8acoy9O1JGvoGzCqUO4X1ryCNeS9ScLS586uO3zNtvdfdDJ3pS8+UZ8bKkQxOG/ZxIe5+D6zQq1C4NkHGyxmgLfQrPUcqorpvfzhSs5phfslSeBrjhqIeKk3AbO3BDI9KSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798190; c=relaxed/simple;
	bh=W2CxuNmn8ipTDvv74FKIaUBJEtJ9OD8YuhN9EqWOgS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FH+u08IOP/z4Z70FlxdVKYMqh2PJWlQnC01omfyQvL0iAj3/lT2nyhsg4MhTEFG2zLNLlgDSEy5PCUpts+HrVoJC8lob3MqLPAoY4Vc6GUbMqn+oXd6DnvJj1ZL42WZP7VOygYGLzJPbwQNyv7k3emWxMhnLKzzl+vqZxzZO9wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CSB4nOPv; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CSB4nOPv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1Bsbg027433;
	Tue, 10 Dec 2024 02:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=RGeWGBjye3Dm9UGrLKEkNObVS/o76qYh178Mz/Gx38g=; b=
	CSB4nOPviAhOio1qifTupqCMVHbxH+4Kk818neVe0BYIpBgr3bmlt+jWsj7ob73S
	pYcHUfK47P9Un6P07/UW5d9IF1OkWn3bR2+/uxt0OJBQbaOW7Aq0E9+fKk0kbMaF
	oK5x6fMl3+bkvV8UZkFTXs35g+VxxBJyqQ/SCBY1KLSNpbWDwWOj/rfexQ0Tvj16
	giqXvqmqU0t+4nGymFXzzIYQqy5W31in+tFlFc1ZsoksWLT8oVCP3uT5rsw5cqQ/
	x4nABTViXctkWVrc+ZOSkj16/Sho+GbKIXoEo6OYwkZ0c/whc68DQ+rBUFmYB6CP
	z2zxrE8/6cPAtRjjABFNXg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43ce894mwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1jAba035082;
	Tue, 10 Dec 2024 02:36:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf7y87-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:22 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4BA2aIv1010256;
	Tue, 10 Dec 2024 02:36:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43cctf7y6u-9;
	Tue, 10 Dec 2024 02:36:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v3] scsi: fnic: Use vcalloc() instead of vmalloc() and memset(0)
Date: Mon,  9 Dec 2024 21:35:40 -0500
Message-ID: <173379777403.2787035.14964577709946774001.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241107104300.1252-1-thorsten.blum@linux.dev>
References: <20241107104300.1252-1-thorsten.blum@linux.dev>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=995 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100017
X-Proofpoint-GUID: IgSKjMF346_toCJc9kStgYJOJOUd81-O
X-Proofpoint-ORIG-GUID: IgSKjMF346_toCJc9kStgYJOJOUd81-O

On Thu, 07 Nov 2024 11:42:59 +0100, Thorsten Blum wrote:

> Use vcalloc() instead of vmalloc() followed by memset(0) to simplify the
> functions fnic_trace_buf_init() and fnic_fc_trace_init().
> 
> Compile-tested only.
> 
> 

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: fnic: Use vcalloc() instead of vmalloc() and memset(0)
      https://git.kernel.org/mkp/scsi/c/5f8822c4a420

-- 
Martin K. Petersen	Oracle Linux Engineering
