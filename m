Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6261C4A2D
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2025 02:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754448006; cv=none; b=uUPQKoqjPwsX3xG2Vq9wiQZ4R+58GG14KwN44QBRWGv54RdsfLKgzfypFSHC5rZbAwmWXIuz6rn18qxBlIVinMvXJ89Jm04X9r3PSXQp5pa+mLyHa78uAbcNXLvVDZqhDml5DMgx5OgDAJDzMcDiRRxli3d+KOqU/Y+THbjcRq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754448006; c=relaxed/simple;
	bh=UzwVCMNMMQ/k1sYxIfikpVYpbTcBHhiNxCfBn43WX+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7yRd6Wp3vL+EaQOrIbn4THEZUkHIKHjObGVb09FuWnRlkqngfATr4+uT5DZEk5MqX7MA5jF4Kk9GanQOYOBSyApW4F6knusuURZ0OTIATXdoMwYVBxYQeVO2NwrjgPuoTtCqYjnLfdOXDDClPLTd6Tw8vc5CcgHeCHxkHdKvoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QxOwmR7f; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QxOwmR7f"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5761uWLU027406;
	Wed, 6 Aug 2025 02:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3B2sh/dPjNFHUyXh17XMgLf+BSuC2XG6faMv2lVoe+o=; b=
	QxOwmR7fKnRI61JOkHqEq1IOTiqpSyEVlHYon/XkcHQVPmRzGT0ofNfC5ae39az0
	gwKWTLFrMXJ5cFMkbaHetozHiFxEIL2pK+vXjVZXqD0U5rcOEdjeLATLHOycDzwD
	QWVM9xUsoqz8VYllIXsGVRCswZvJbURe6sQLoevezvRYF7u4QOj8hXkLJv/Ki71V
	Ss98vk+RzjOgVSa8gYN7NfeGtRmvzYGq+0DvamLlHc341oggmxv15OJ8G1PzyLXd
	rlvUx6freT0y4aRreP+lTWi3oSgM/YG2TXLUqMJEecb1VbN50sIV4ciGJULArmMA
	0IoPgOP88GcamuMWVQEXEQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvd0mp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:40:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5762Y4rG032070;
	Wed, 6 Aug 2025 02:40:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwpx5xq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:40:01 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5762e0Px004349;
	Wed, 6 Aug 2025 02:40:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48bpwpx5w1-2;
	Wed, 06 Aug 2025 02:40:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Correct sysfs attributes access rights
Date: Tue,  5 Aug 2025 22:39:49 -0400
Message-ID: <175444522417.711269.16741372103055653165.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250728041700.76660-1-dlemoal@kernel.org>
References: <20250728041700.76660-1-dlemoal@kernel.org>
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
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=731
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060017
X-Authority-Analysis: v=2.4 cv=fYaty1QF c=1 sm=1 tr=0 ts=6892c081 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=0ukT8vsd8pv8HR2t59AA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 cc=ntf awl=host:13596
X-Proofpoint-ORIG-GUID: _XVyQBAyYW-fqrYXEozSNKOXdBDnpFWL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAxNyBTYWx0ZWRfXwb1P9FJT+l75
 AM8iVYVRy0uZnITT6ew0rNZFJr1LpTPBhBnIj0CyIhbUH39FDOZ/MGcHnFtClvBeXbLKkovxI05
 DQaasiH71INH6axYNRiBxxfC7IoF0mc9wpqTIpdIMj0jlhtzdoIhhk27z7cXjbQCwz7+y/rNsek
 8YhG8RzzX6gdgeyBMvUyJekBaEtzJEjGr3MSCXeuFLZ8fx93ZAJ8OOH42ciylqxRseNZuSLOX/v
 vsYqIvOSkNLn9k5/uiklq+gJxtQHSNCYXF+cT/3QYA8Hy7HxuOmxhiyeC+HWANcJ3eJKteicCJs
 By01c4Zagl9bz5ag55YRqKRYh06BnXmO7qvKPHjcE/ydAVvaqxWbCM9fSvVmIGQFStDepvYk0Ib
 IhsxD3Rbxy4wgEqt4iMB96ms7wUn6vqf6wXef01NN2rDGU36AFkLgcwUKZDOgS7p+hvWlV++
X-Proofpoint-GUID: _XVyQBAyYW-fqrYXEozSNKOXdBDnpFWL

On Mon, 28 Jul 2025 13:17:00 +0900, Damien Le Moal wrote:

> The scsi sysfs attributes "supported_mode" and "active_mode" do not
> define a store method and thus cannot be modified. Correct the
> DEVICE_ATTR() call for these two attributes to not include S_IWUSR to
> allow write access as they are read-only.
> 
> 

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: Correct sysfs attributes access rights
      https://git.kernel.org/mkp/scsi/c/a2f54ff15c3b

-- 
Martin K. Petersen	Oracle Linux Engineering
