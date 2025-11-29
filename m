Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479EC231845
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 03:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764387041; cv=none; b=gO63C45l/LIOwKrisH3uDl1yq00e0wqKxWQaEgif6E/Tz/k3LrYmyBtwZk6IkkXfGWGvga7u9t9T9kOuzpor0yhvWdyGvWGGxRlRw6G0eqqVUfscFi0Nwn6uavp8y6QpAdbGsMBSv2ovSa2xfmsQmo7oKVhpvSXrB+cLSMxkfD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764387041; c=relaxed/simple;
	bh=U1A2yoN6TvpicuRvZYrgjtGKnfmjIaHMfGjwQ/UG8ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hBJYnmmmkhwIai0h7CrRP27Pn+Drn/pPaM65rG+g5QZrooPJ2+c21nQj5bnh1DBIsj/TE9eKePx57Rn6oLKOCg/U1+rIHLOKxg05llkCEi4nDw4mnvROMvuahom5vkr9+XydpKMoNiXE1UKE/4sBOck0jb6rVZe7i5esfrfiruE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MWqr4eHk; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MWqr4eHk"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AT3C0CG623909;
	Sat, 29 Nov 2025 03:30:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dZA31L2/RXhe6+KBUm1TzhRdvL6aR8y+t7ajnqDX+ZY=; b=
	MWqr4eHkTdtr9/e3hmk2XwssHVUrFWyP57c0/YCybvaPTmwwcLekeh0yvAIijLDu
	QwV/kXPlE66sEYBER1gbwYRTBT4X0yfpPv4SrhTD/8Gpxb5XW6KpvzjelhNff9I1
	cxR+T0uQULRHVOz16v6yUpS2nZwoZqaC+Z2s3TMo9irbbU+8ijQz6wGT3n1VQxMg
	pt1YJ4oTPiLKl0ienmgh57e6Q95e0gyZ/cx7yNLR44RhygWbf26grNpOF6QzkGvn
	w3fr1CymBNrKAUr3K2bEclM+7HO0ZdPMOZ0F6YcMyc7MLz7Btsk9BoN6GjNIkj1v
	e5YPax6B7TBzsJvz+ZL17w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqrq700bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AT1XZiF031941;
	Sat, 29 Nov 2025 03:30:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq961n90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:15 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AT3UEpF015090;
	Sat, 29 Nov 2025 03:30:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aqq961n85-2;
	Sat, 29 Nov 2025 03:30:15 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: scsi_debug: Support injecting unaligned write errors
Date: Fri, 28 Nov 2025 22:30:01 -0500
Message-ID: <176438479594.3682470.518346544242801545.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251113174151.1095574-1-bvanassche@acm.org>
References: <20251113174151.1095574-1-bvanassche@acm.org>
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
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=688
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290024
X-Authority-Analysis: v=2.4 cv=BIq+bVQG c=1 sm=1 tr=0 ts=692a68c8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=xeEhHgPonyaO15gC86EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyNCBTYWx0ZWRfXz8QWQewZt83L
 bpGFnFclWZoWnF9G9smHVEGwayXJIl6mkzX1N8ZNjUZM0OgemwiCY4r4A+DxYspP8U1WrPzDGCF
 qFq4CNn5MtDkmFdc/I34QeeCW5meBAzni6RMCeOQX2vHkbHjWDtFL6cb6v6fWqPlZo5AfRQLDTY
 iST2XuxYATHrJx/5Hx/kZTsy8oezyaGIfCfRT14T49jxqNUu62MqQOXDhvWkImC9O+gZObCd4WJ
 6eSs2zneqpOeTMIvzVf0dSktI4/r+ssZLrJawH/FgI32kse4NCBpfkWOmXkYWlrfPTpVo5QthjK
 NKbeFX/thdOztOGSepNPjbIkkLQymE593LfCadc5gH5V7Ro8dFwns+SK46dWwj6Kp4MjhhlJUTo
 oafy1wpEojMsGzMFOBSfTOzQoStfug==
X-Proofpoint-ORIG-GUID: 3B7qOJlc8rcwGvxCgydCftWc8sTt6w6O
X-Proofpoint-GUID: 3B7qOJlc8rcwGvxCgydCftWc8sTt6w6O

On Thu, 13 Nov 2025 09:41:51 -0800, Bart Van Assche wrote:

> Allow user space software, e.g. a blktests test, to inject unaligned
> write errors.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Support injecting unaligned write errors
      https://git.kernel.org/mkp/scsi/c/13b77ed9c2a9

-- 
Martin K. Petersen
