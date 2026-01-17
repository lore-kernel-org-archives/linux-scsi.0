Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D8728466D
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 04:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768624624; cv=none; b=dUeLfOqxSvDTfRB28+BHJh7upQicWsu1nNcLk+W/Sp9wyIqk4lAA4yyYRPJpkhEvmHGTvHxxYVezF9zafeqeK5xENGwLMnIqu//yQBs9XUqwsz2Gumi/Y5jMY+24jsr/+RJnDia6G0wbE/N/7psrAzjBKACPxqsNpSVE40hXYpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768624624; c=relaxed/simple;
	bh=h/pBf5VN0xsIZzSsHMlNZ5GVsD0qyahc5M0YLR5QJMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XnEs62oWvDaBN2p7zsWIJQwVZuApY/VZU5Sa6h8aZxjU5Zc9oj/5inmLeQ58KMcROW0iY11Xbq5GvFsUkizP17qShUJvbmrQJGB5YykfCbIeeZXSaln1R4feRWNQWsay9t29xUllP/y/FGhnU1T6k+kNqGyJAlt7MIa47Zf5tZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nU+8U1Dp; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nU+8U1Dp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60H3NxWH1035757;
	Sat, 17 Jan 2026 04:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ngfftxyHsSbCHjaCrB5IAqMLU5S/WiyeF2T9QYWFjKo=; b=
	nU+8U1Dp1k0KeM8fkxrrKAIzz1UB/pxcJpIcFZRHOPt92OMCnpsTKUmXxmB0l1zS
	g6E74uBo1W9IEqXs7+lyzN+OYXOmmac5gBJhlM8JRUoLW9RT+/tVWPcaghOVf3mJ
	1C8Sjl8a55fqAIC4w1rN0mAO3lKtHmSX3vQTUOV69uvv+NO9FAOxP6jClSP1xmvZ
	V9yoygiXOETfJUIS6huf5oOvvi0kZocoKyw+oiUlUXe1sS34nsD6rhpTbYdVi6UC
	atH4b5e9Aj4MUZs6m0dpUXwbZGmBQYknLXvPmqSJnhrJ+S5UBSh6w3rhtLNr/Opf
	N59cT6uXIeYR1t1tiJpJ3g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2fa01e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:36:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60H1XlPI008409;
	Sat, 17 Jan 2026 04:36:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v6bk54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:36:56 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60H4at7J005851;
	Sat, 17 Jan 2026 04:36:56 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4br0v6bk4d-2;
	Sat, 17 Jan 2026 04:36:56 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: mpt3sas: Simplify the workqueue allocation code
Date: Fri, 16 Jan 2026 23:36:46 -0500
Message-ID: <176862008999.2331811.17658161043136207535.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260106185655.2526800-1-bvanassche@acm.org>
References: <20260106185655.2526800-1-bvanassche@acm.org>
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
 definitions=2026-01-16_09,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=861 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601170034
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE3MDAzNSBTYWx0ZWRfX0FTqsBZ4ibdo
 sSSDXEEqnEJetZw8GOXEwM2UFBcsMzeDN/Lr3tle1n8eSvR6tuS0TfDsovcc9vYxauyeR5RIDzr
 go3tTm4FRXSTWJms+9RHfFUA90rkDrwq8RXEODM+YdR5Rs8szZD5JwnuZgb93jjQMsM605maYLc
 NPjdKOZMjkAd1G6EdMt5YG0XDzc8+bFNK8sFn0weccgSSWUcPmB5iSnagaRSW7xI7DTjzsbj/hP
 8MfgMSBiZ0Y1NwD7GUXo2Ly9zvEqAGMZwP4lg8PBas/kyyEdA8zOWwty0wj2OJd497hAZmTGwoQ
 Um2rbLPr5CkW+Ziuib6+npOh/L/q/OlgL3vCfMkmk07l4xhf837UYSeQ0Z+4mmEpUkA/xzuKmz0
 snhdZQ8U4IFxtKnh/ovTA68uiOT2CCzz55m/nBRuFg71ziu/sfLgBtLEJyO884gns2UWT3QJ8gE
 HwcrCzyeYqwGsJ9CkYQ==
X-Authority-Analysis: v=2.4 cv=HvB72kTS c=1 sm=1 tr=0 ts=696b11e9 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=KB8hJxlyT7t6aYlWqOwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: oi1W0wF6lUX88EmVC9GV6m92uWCC_ZK5
X-Proofpoint-GUID: oi1W0wF6lUX88EmVC9GV6m92uWCC_ZK5

On Tue, 06 Jan 2026 11:56:54 -0700, Bart Van Assche wrote:

> Let alloc_ordered_workqueue() format the workqueue name instead of
> calling scnprintf() explicitly. Compile-tested only.
> 
> 

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Simplify the workqueue allocation code
      https://git.kernel.org/mkp/scsi/c/bf286f5558bf

-- 
Martin K. Petersen
