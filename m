Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8C71DA62E
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2025 02:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521324; cv=none; b=k23/uHhbEfDSnwbW9jUfxMawAEfRMnE2C4LJmcY73Cz2TUdC0LQcABlqeNn9K/Nla9sW+xqtSgwpvPxflItQPANkscGo8020ikcr7ZH4wuZiCTvL7rNVxogx/tLvwE+/CJOtDtzPlJ+WOnbre2UZRJkd3GW9XY2lM0fZ8VqM3Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521324; c=relaxed/simple;
	bh=sqytDlMZZjCQS1mAM89CRWY0kZFQvQE/ct1TSuDkyD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SzXeol4zjAUw11JUL4IcYY80wsjGCUW4UkZX3wATSjTH5LRc6MszIkh9kQLxMiKHO8z0ezv+wgUuz09APaY+WkOnOLo9a++SrEMq2fqFtVb9fTRfxjPfqc1g9NfuyHUIjQ8Nh8pVLovaFkq2loihZQ7N3QzUNWoaGQeiuHtjRoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cXNSVsNs; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cXNSVsNs"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 559Fg4nM010696;
	Tue, 10 Jun 2025 02:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cWRvPoUFZ+D3SrYaXyeNVqmEXVQ+y5T6A7iL6OYF8uw=; b=
	cXNSVsNstQBi4g1Xt0M0w4/l9lnm59IhAcw5cD6l+0Lytz97djk3TLjW4SC4iNeg
	2WZkcJV70uU3hZ1uCx3kHl0fk0etPsl+82ivNNvuLSIBzJomFxG3qkBxnBJljLFi
	FtX74+cBPDllVaaulGS+beM09apDxElsw0UV2w4t8myHFv0uivuIwaPs5FzK9NyW
	g8fK70yU0IfdX7PkWRskyDko5iaXtPeG3604ZKY89IM3ryTE3hDgxT8cBICJyGAq
	SdndhWZB0OBwshHQL3Kq8qbmdTLbeYgKMq+L6Ln9CissA7fivEwbwgydqqWnGqms
	B0Vg9u0MhK7J1OeD/ijI5w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474cbeb8y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 02:08:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55A1pdNw007382;
	Tue, 10 Jun 2025 02:08:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv7vr0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 02:08:32 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55A26uge001728;
	Tue, 10 Jun 2025 02:08:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 474bv7vquh-2;
	Tue, 10 Jun 2025 02:08:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Hannes Reinecke <hare@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Rajashekhar M A <rajs@netapp.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] I/O errors for ALUA state transitions
Date: Mon,  9 Jun 2025 22:07:37 -0400
Message-ID: <174952124904.1235337.15603496950228203722.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250606135924.27397-1-hare@kernel.org>
References: <20250606135924.27397-1-hare@kernel.org>
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
 definitions=2025-06-10_01,2025-06-09_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=804 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506100015
X-Proofpoint-GUID: wOT4Fm8UCEdw4svtDaon79RVYWZ2bzIY
X-Authority-Analysis: v=2.4 cv=BffY0qt2 c=1 sm=1 tr=0 ts=684793a1 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=nNig1Xe3f8JmSwzMsIYA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: wOT4Fm8UCEdw4svtDaon79RVYWZ2bzIY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDAxNSBTYWx0ZWRfXwHPGTM48hiYd Q9jz4XPb/cEEasiQ+70564lSENAzl5/KfVubW6ifOCU9EVKWJQeZRnBry7IZJTzBrff5SDwZ26D L5jbrleVy2aFJ1atVRujQS+BN4m1fHA7relc31ZipcuMEtJlFP/TGMLRfgxaGEGWmEfm5rrBWtV
 EG9UX1yWy68RKAyLDKSvJx9hEHbeuPg7OmzZhU0zFiEOD7B+pwSVttqVcKx5/zFYQrimjThsJH1 pTl9XRyOCRjQqe2ALBltmSQZs5X5naggf9l7HxmgC6+bsgYBFOfCKpJaO5n+RfrNrPWfel8y1mH SaOIZxvJEk2eVyKQS3ISwZP30MPB9Is3l4GsSqld4hlACJvJW6gSJqtAEie+5ZEaTr2OaX6GO6Y
 32jvAJztL0GRh2U7uAX39u+Sp2cfG2FI9FdlqEaU08j8fohCEtP9OLze8MshbME+H/pHEUqX

On Fri, 06 Jun 2025 15:59:24 +0200, Hannes Reinecke wrote:

> When a host is configured with a few LUNs and IO is running,
> injecting FC faults repeatedly leads to path recovery problems.
> The LUNs have 4 paths each and 3 of them come back active after
> say an FC fault which makes two of the paths go down, instead of
> all 4. This happens after several iterations of continuous FC faults.
> 
> Reason here is that we're returning an I/O error whenever we're
> encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
> ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.
> 
> [...]

Applied to 6.16/scsi-fixes, thanks!

[1/1] I/O errors for ALUA state transitions
      https://git.kernel.org/mkp/scsi/c/5c3ba81923e0

-- 
Martin K. Petersen	Oracle Linux Engineering
