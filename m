Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D111A2750FB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 03:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761795221; cv=none; b=twIZNYNu6G1LszjhZUfF+NKfb0Wpq/GjwgzvdRJK6ZpbfzT9T15kPsk0lRv/F6qOswrqmlw8EkKfkFwcspH8bfwL1WfDTZpgOAqwz2MF2YS2mFgJ4996zvS6HP26b4MwKd8Ov40Yhm/QcbAwlU/nbiIWxydbNI8SQSenvlh2AkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761795221; c=relaxed/simple;
	bh=d0M4bTuJ3tX28G9ENXcw3RUboCSULm6A66bbBlc9R18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nozn38meioUsDBpkQogWnpBMlU7rNZF+oWmPYzLH+d8EQ4xzI7CcR4Ev7fO554IiUp/wU+xydEgOrNOW+fsQJ2BtUs/3x2a6IY9+y6A6xKen72Im6278qw0V0otVEumXajwXshR/oPSOM/OaxS+7hI5IfMHUMV3+a93rtKcDXC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PDxHWN1G; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PDxHWN1G"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U2YiEm023245;
	Thu, 30 Oct 2025 03:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7Bqj+/CkwzbETbtiIn/0WkOoW31wFPs53sB5ZpjjWo0=; b=
	PDxHWN1G+WL8ow4dB7OO8GZFNaRyl2lmSRrHhJAaZVRlTveqMP4SEuya/rHFDLya
	rp5+JOe4NHQmmctIryGixrXKEGqMX71917icnkBbiW7EVBWpEDqGQkJm5aPPVJKk
	0oq9wYXSD0Ms5mjvkc/3s9RbCrNvVtnfwWjA874zIk1AnHNy6BfLlPKJ56SWKZO7
	KER07uVoz8JdcN0dUt74TnKzYCvBgj1QodFx+dd96ITUXFwLcciIt7cokD0tQfnq
	VZtIzuT/4OMdzftJhLM0ZcBlDJxptsDd1L+dzh4olhMbnvh+nhk19G12TRGd80FU
	KKlEnPCyc9XZybQ1kp0zOw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3ybsr25e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U01lHG024216;
	Thu, 30 Oct 2025 03:33:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y01unp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:35 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59U3XYQe034192;
	Thu, 30 Oct 2025 03:33:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a33y01uh6-1;
	Thu, 30 Oct 2025 03:33:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        alok.a.tiwarilinux@gmail.com
Subject: Re: [PATCH next] scsi: qla4xxx: Use correct variable in memset for clarity
Date: Wed, 29 Oct 2025 23:33:17 -0400
Message-ID: <176178801903.1949089.4350749463964032616.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021090354.1804327-1-alok.a.tiwari@oracle.com>
References: <20251021090354.1804327-1-alok.a.tiwari@oracle.com>
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
 definitions=2025-10-30_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=583 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300026
X-Proofpoint-ORIG-GUID: uFfO7FU8V0gQ78WVuzN7Jz4DZ2XZGkpk
X-Proofpoint-GUID: uFfO7FU8V0gQ78WVuzN7Jz4DZ2XZGkpk
X-Authority-Analysis: v=2.4 cv=afxsXBot c=1 sm=1 tr=0 ts=6902dc90 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=UkCFKzd43EouWMw8rvgA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDAxOSBTYWx0ZWRfX6VThmeXLG0cF
 cqt5pLS1SOgAO1UnaZEeghn+aj6VX2Jfz27a1E8ly9WB866n31/CUW5C8ZRNHEFas534th090sH
 nJhqe5hrnNvMBveoZOgX7H9/+D8S+mRUUvW1sIckZhKen98dfQS8FpBklHMNEv6LyiF0hp3hgB4
 OfIq5AFREMCJRBOyOCfoBhCZQm1GKe9c4UwdhQ2Dj0onvSqBZqFH6wkGiVL9IsAw+7JxyMTXTv2
 NQbz1VtPI7cVE/0wTyNwR9Om3SJDfdKt1j8cic/C2gsm7uTi8gwjp5sJkfac+ld8dqZQMztjHCg
 prZWFDsDs8z75NSZpKo3RTJQ4V6xqxA0KKxXpbA+YTbwS4DTlGj0BACzFx62zHbfSU1VLD4CsFT
 iBx5+HRAjw3pXsoNWYQFosFBSkb4ng==

On Tue, 21 Oct 2025 02:03:52 -0700, Alok Tiwari wrote:

> Both mbox_cmd and mbox_sts have the same size, so using sizeof(mbox_cmd)
> when clearing mbox_sts did not cause any functional issue. However, it is
> misleading and reduces code readability.
> 
> Update the memset() calls to use sizeof(mbox_sts) to make the intent clear
> 
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: qla4xxx: Use correct variable in memset for clarity
      https://git.kernel.org/mkp/scsi/c/e9ff858c9adf

-- 
Martin K. Petersen
