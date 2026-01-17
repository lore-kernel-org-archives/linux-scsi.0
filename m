Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430FA18C02E
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 04:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768624623; cv=none; b=JMXVPG6G6eoCEhOqVDRorQHz3IPC1tU1yRORe3xBWQPM1eZw8+/VccHTxGUBG2+ETWDFv8KzJeDxa9B9ddocmgALyOq0ZCJ9TtJhFzHGu823TsyL4p9S0jZBQ8grdeM+LngpCa5MLmnwji8meHEP7/+EnsfAyLyf5NkZCEIp/dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768624623; c=relaxed/simple;
	bh=2YoPOH9BUAkXFsPVl4m41JP+OknUmk4ceRex2OSBn+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YbhKcGQKCb6EGnKHoNaCg7xJtvNiDVp62jLvXpPNPX5ZBszHOqk32CWpZlqpYipzbqfUa1mVdoy3tI+d2eU8a3qx1uU9k6Qs/1htwuDTUDfuBMGymtu5lEgueDKf/sv4+5SmLueyQ04UQC42kMDdvwtKYJZ9/F4a/fM9O/tU5YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LXyeOilP; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LXyeOilP"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60H2sRYr428888;
	Sat, 17 Jan 2026 04:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sOyYzPgmc63Q5mBtiSP2ibLkfS4b/McgAM4jKJJK41w=; b=
	LXyeOilPL5oS7mHspMRtFQR/ozoI4NKind17SYt3va5ASB8k7THQ5KXF2ElFeINc
	FTp2KbUQIJAAcxXIbfW2t+cNyKZU94b9r786ef3GIDWcrCjTdgVhCd0Fn/gv+awa
	RLZXJssaLr6k7eotYpAeE7yd8Q33YUwz7eFADXCznA/NQ3QbyHS4GpWWO23e+Ouy
	RHGnLUcz38xptN7I80pT41ryu5KS5zuMDThyv8rmKpx0A9fC/Wj2Tymy09n1fIYA
	iQA3LXQYdSeUifWumXMoeB23nOvOlPeiF3Tf/c08Q+FBvaPScIFELtP/aGBfhiuC
	KJlZ7/ADNd54yVtcwqudbA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21q823j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:36:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60H1Xkkj008393;
	Sat, 17 Jan 2026 04:36:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v6bk5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:36:57 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60H4at7L005851;
	Sat, 17 Jan 2026 04:36:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4br0v6bk4d-3;
	Sat, 17 Jan 2026 04:36:56 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ufs: core: Improve the documentation of UFS data frames
Date: Fri, 16 Jan 2026 23:36:47 -0500
Message-ID: <176862009001.2331811.4406583121728457142.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260106190017.2527978-1-bvanassche@acm.org>
References: <20260106190017.2527978-1-bvanassche@acm.org>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=902 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601170034
X-Proofpoint-GUID: iwHk3bpIq5BWIrJgndz9qJ3znyFSZpKd
X-Proofpoint-ORIG-GUID: iwHk3bpIq5BWIrJgndz9qJ3znyFSZpKd
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=696b11ea cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=y5wJQmRk3D5Ua_UfXpYA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE3MDAzNSBTYWx0ZWRfXzv44N2ZmHu/I
 YeY94+4HOV6aFjrrymEmLf4NIxZO+60Hq2z3DMUiLA8gFmLb/XmAggjB+KLCjeYTErJfde9jrBU
 qb1gL26blFz8KdSXPmMt/hsEGb01qVmGPsQ3S5kAxPcZCpNe+gNPZPypOFLXAqgGh+Bl9me2grd
 HvnXZEP1L5K5WMwiiJV/an7aeOmKamvLpqORpAbFs2EGTdtAzbKQuka5FxCxT0cejat5mWPN2P0
 49hXgrGPBhdK9dl842ReiwtNEULlVXgBFP+Pdmzvoi+jQcKe2RDCBYhDapLVOwbGOjEy9Na38vx
 1APP8woTAfofYDYxQmW6KOoG0K8gKK3LzBgJP6F+RDqlNE9Ld1xcGXWSabrQ9N5Gx3eL4tsLTwf
 KGr1Lk3+fBOb9MQwzOR+Bp904m9lVdVF9LpPtKXsiR9hawBN+axc5Y8Cd6PDk+YtJz79NkC+BT5
 0RnE/2N/CeXVuRpK5lA==

On Tue, 06 Jan 2026 12:00:17 -0700, Bart Van Assche wrote:

> In source code comments, use terminology that comes from the JEDEC
> UFS standard. This makes it easier to compare the UFS driver code with the
> JEDEC UFS standard. Add static_assert() statements that verify the size
> of data structures defined in the UFS standard.
> 
> 

Applied to 6.20/scsi-queue, thanks!

[1/1] ufs: core: Improve the documentation of UFS data frames
      https://git.kernel.org/mkp/scsi/c/309b23a1553a

-- 
Martin K. Petersen
