Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CB53A9D8E;
	Tue, 24 Feb 2026 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951691; cv=none; b=HvAVbbZcXZlLNW+6kahgWWbuHjfCTI7Yx8bykyyd1JeWIsLWQrD5WhBa6LKwClk2JY1AIOGqtIEEWtSmJSRK8uyVDdEvyprM/hOmsoHa4YZ2Kl1g1E6sZdwRHq7SfSjenTTY7veFEQ9ciUfmhfF2GAcqQROlBs4cs7BfYzLEHxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951691; c=relaxed/simple;
	bh=Drcpfxi2W/uFtI1HUq88rybKzuTYyfxEXhCD/AqKnBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PMS+vHbuTHGDMZwiK83yZd2O9pQbf0Kst3T2FCI+GW4YckHrKFCjhlpr7NqwaMJ0YkDv5DxOEvs/KP+iigrShPnmPo16Ip1zFMQVS+RZ7y+R4skDrjURY7Bn+2kDIZEN2W1cX4dzCMtGaHuYQxgcPZZGdpwVKqUZxdwrffNH2Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bpR66Fl8; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bpR66Fl8"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMrF6087200;
	Tue, 24 Feb 2026 16:47:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aerDdRzNTwzTKGdx6j+kihSNk+XITPeccx8fqrE5OKY=; b=
	bpR66Fl8LuTy9EbOhnv08VkTnFN27KXHt1arjD68hgHGCD04b4czfb51xRmwlS/H
	FT+MqTamEKjjDc4bnRxBuDn06Rqc1JQm+mgBgpVM5G8prx2KMDUVnPMTLzQeYsQX
	LEo1oJIf6dA4LTb4GbosuEVnStJEVEx1/5R5anW3PL1aU0ImgHWQp1xlcSPYmJCq
	W8SLWf4B3/2J3GkAk7Ho33ox7rfYTYhr7SlSJTOK6mIUGW+HJPMNW4jaIZyL0mOU
	5nXJfJRhFLzra0V34wrTDy91Xka63OG08akha+LiK+tEwQ7qrdSAj6/Qlf1tQWhm
	RH4F0PU9g2WTkYBu1xDf7Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3mn4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:47:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OFxGVb015689;
	Tue, 24 Feb 2026 16:47:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35a6kk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:47:55 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61OGlt4d012936;
	Tue, 24 Feb 2026 16:47:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cf35a6kjb-1;
	Tue, 24 Feb 2026 16:47:54 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>,
        Alexey Charkov <alchark@flipper.net>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: core: Fix RPMB region size detection for UFS 2.2
Date: Tue, 24 Feb 2026 11:47:40 -0500
Message-ID: <177195161175.1154639.14825050984153004588.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209-ufs-rpmb-v3-1-b1804e71bd38@flipper.net>
References: <20260209-ufs-rpmb-v3-1-b1804e71bd38@flipper.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=676 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240139
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699dd63c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=WpOT6c3oHlBwd_VzIKoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: OAI26Lfgsre45pj7kprhQoHFlNqMmHyy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE0MCBTYWx0ZWRfXw74xnOpNU3c+
 owGvCl1NxBZo5EYqbBmEKErYOAY7ycCOwVaQSgLVdso9taR3o3o4HtJGTtWaf3iCt0k73NJw4wi
 c1g5f8qAuYOP1SzsLK04TX/q3Nmrmw1eeEkEoFv1ObrRXwiGGARGVk6IR/NQfvcIcu1cN+9FEAA
 52JALmdKIS8SBQw+FFkRpeqQsIcpAnr23vE64jNmVD/yhA49Zr1gza4nkRSo3m67jzfEAgyE4ld
 h5Hb1FB58Ua7bqRzADzweGl4+No0BptAjBZ+5MmBv4GXus9rH8mscJ4lkE6vaN3yzH6bRf4ETkU
 Fzo8+qLLmPkOLIS3B5YTWFUR4O4VVCNg71oelSb8OaL3DlqZiPRj0mmPbLbt0jcGy5rTvpNK7YM
 zvBVkK5l34bPhjtW6sIR0HXBuWMRDEfM4rqlVcZzPwoZvFfUYgI4cLigW0bm5tKIXtF38LCkww2
 MHFUmob0l+meb0hBhvA==
X-Proofpoint-GUID: OAI26Lfgsre45pj7kprhQoHFlNqMmHyy

On Mon, 09 Feb 2026 19:17:34 +0400, Alexey Charkov wrote:

> Older UFS spec devices (2.2 and earlier) do not expose per-region RPMB
> sizes, as only one RPMB region is supported. In such cases, the size of
> the single RPMB region can be deduced from the Logical Block Count and
> Logical Block Size fields in the RPMB Unit Descriptor.
> 
> Add a fallback mechanism to calculate the RPMB region size from these
> fields if the device implements an older spec, so that the RPMB driver
> can work with such devices - otherwise it silently skips the whole RPMB.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Fix RPMB region size detection for UFS 2.2
      https://git.kernel.org/mkp/scsi/c/2e6b5cd6a4b3

-- 
Martin K. Petersen
