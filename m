Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E22D21ABCF;
	Fri, 15 Aug 2025 03:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755229114; cv=none; b=EbBa049+Nq/zHceZN6iUuCGp/QI4xTxBnkMXgYQdgv99U5fk4IWd+sf/Os6g4UdlhGZdr+Lqn+qAsPPkzA5ycPgRZfcqT6N3JItmaywgcW60QhM315i6zZ6nGMiOJDUORJ9h/ChjsbP3iDUWtdH+KuUMzEpVXOey1ANEtsjw9Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755229114; c=relaxed/simple;
	bh=3UW87/kRuZkhV9K4Anr68lLz7oMu1cqh3YTb+r1FC94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RA2sPOldcv2zvu/iSIs7SN8kRzQwSj+ngUHOMMSfZdSE6zin/Rs4ZEEj0G7Vtykq9Fdzk31YSzUC2IAHDxOz3kR7gYbwLfrpT79WPwptTlY5g2VEJI4sYpP4Vxaxkq6ENLxHqmbYZ8fHaRFst0V2JWtdvHDHd8hAFFyLcfpRirw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mGCrtnNl; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mGCrtnNl"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EHfrZ7001234;
	Fri, 15 Aug 2025 03:38:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BEJ5Hj5T/cTo/mpdxqKDVP49fhBINVQ0BdNE0EO3D4s=; b=
	mGCrtnNlFGxTx1WBwmRaACg7gXivUCCYkJWnR8Fds9OiXXu7OyM98sKVo8v2s7x3
	D2vOgzpVSgDpDK4oJpPlnLbMDVyzC8y0YBfnE9dtXaBzJHyZFFXPLd0Zmn+wFODk
	bCajlW1WXGQlk32lK2sZl8SnhwP+zgU8lOS9JfVfMbA8uSY+aH3mhV+RvZDxgarp
	QuyxeJo8jGb7aPPWrJ9q2hmrmu7+CTAZaXIGyr2aVe9AUeTaj0dToOJHWXzKIS6y
	PJURfnTU4gLPuIbgLt4BMMUci32T8AEOap6x8RQIK6qdJgXbZ5MrUBCrMV5O3ker
	kA9hUj7w298MO+z3d9VpWg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw8ek9nf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 03:38:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F2ihH2006535;
	Fri, 15 Aug 2025 03:38:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdcuwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 03:38:23 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57F3cMAi015669;
	Fri, 15 Aug 2025 03:38:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48dvsdcuwe-2;
	Fri, 15 Aug 2025 03:38:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Mike Christie <michaelc@cs.wisc.edu>,
        Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        James Bottomley <JBottomley@parallels.com>,
        Ravi Anand <ravi.anand@qlogic.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: Prevent a potential error pointer dereference
Date: Thu, 14 Aug 2025 23:38:16 -0400
Message-ID: <175522907876.1556995.12357818221698958241.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aJwnVKS9tHsw1tEu@stanley.mountain>
References: <aJwnVKS9tHsw1tEu@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=691 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150027
X-Proofpoint-GUID: CFdC9KmtxA-togNm3NGqAA1db_IxdIJ1
X-Proofpoint-ORIG-GUID: CFdC9KmtxA-togNm3NGqAA1db_IxdIJ1
X-Authority-Analysis: v=2.4 cv=ePQTjGp1 c=1 sm=1 tr=0 ts=689eabb0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=4zpkLbjWt7iokNEccsYA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13600
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDAyNyBTYWx0ZWRfX9+QHt7Te489S
 qfGyehobkKnFKqaAqoSYHJUNPFYkJbhKl83bULXkVX/TtYW+tmMpa9nI8CNALqiKjr0C4GxiBD2
 kWP2N05MEHECSXAqObMEcLsNbkMKV+MLDhWS42eOCbXbLyqkX4YAeQYORGM/WUnhM8o61zTrwwh
 O06LuwbTeZhekqdyYwIgHtgkpg+Zwl0bnLKTNXFU30phf7po7d+570OQhE/+7BVykYo8sy2fZbm
 l7DiW1pit/GxextZ45IPOaLhprcDV0yqMjEisA9AzMREQHgXlskCR3J9EGPwH8Q9Lxk5HQIyhwi
 G+9/aq3kUgvP564Ew24Rho/SYt6jqIEKNfW3AKr4FcJHrKqQS/SCtjYe7vKzHf4PJxLVlG/VDiY
 2Xi/olldJghnbt9HOPwEzTfHAm4vDeofBWpIxJqiEiBJ6pjFhK8ywSQ++UoZiAGsqTEg5Utt

On Wed, 13 Aug 2025 08:49:08 +0300, Dan Carpenter wrote:

> The qla4xxx_get_ep_fwdb() function is supposed to return NULL on error,
> but qla4xxx_ep_connect() returns error pointers.  Propagating the error
> pointers will lead to an Oops in the caller, so change the error
> pointers to NULL.
> 
> 

Applied to 6.17/scsi-fixes, thanks!

[1/1] scsi: qla4xxx: Prevent a potential error pointer dereference
      https://git.kernel.org/mkp/scsi/c/9dcf111dd3e7

-- 
Martin K. Petersen
