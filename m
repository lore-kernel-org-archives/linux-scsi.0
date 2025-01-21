Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E352918AE2;
	Tue, 21 Jan 2025 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737497830; cv=none; b=Hbt8m+xgFS3Y52/YiTPaleXXR+aFSOMwPruDFALlZGXGZr5OXgQk2IFlmAcWibzFS8xcJKzS2yuN9rWXevHiIUj1BhlL++L9yj0DyqQp008o5CjJo/RtORXwyzLrhSFnEGe7HPc4fNxLaWoy0WKL0IlHqZgZH7dIULy5n7fM/eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737497830; c=relaxed/simple;
	bh=qws4CGRtecxpbMfGkdf+jE6GWcbxBbffFa2AR5+dL+g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IDZ932w9SGA2gi/b9CzCSqXVnCrQgDPHLWXKO7Fql3tt/tcGOLGzsrnLMhGAkMGL0EQRTBlj8UytUsMhZ2ESCIYHQqc04Rry59k4YW6LRUw2ixgNmDm9lMppFtk/eWaEhXfgPFAxb/hQkxETYXoP3jGFWyWjlZOXXxvU35/7uyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m/1ZCtV9; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m/1ZCtV9"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LJK2HH012570;
	Tue, 21 Jan 2025 22:17:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=QeNsc5WC6tpfZfsjMRQqubNZIHmtn
	uAiLEdIcZ2vvrM=; b=m/1ZCtV9dQtmqYmU5j0HQBvvw8OFV2r5ZD5mgvpFFjP1C
	ZPBWg45DO6a+D69KDV1w368I87H/JEonesXlPjEyRmBdVDA3qhO6N1UHC3J1g0c7
	T+bjfJ21EGQcBOg1OgyX/zCM6pTebBddeJiYvIu/j0Da5MSdaUjh9uSEs3NqyXIp
	as8Zl5SgxhqimU69ZWzF6bubINvLuXg12rGC9xYd6xYo01wvfWA3tOsLcP7+Ae5k
	WgcCrMnxg6EGgX+AfajFM9n6XxoFzAIB9uN6zCYBjyeKeplM2ZsIoMT/I9/i1iRr
	DUBkzr+yAGc2lQJtil9OVJPCsOEpFWxmyauScV7jA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485qapmun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 22:17:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50LL8SjM036463;
	Tue, 21 Jan 2025 22:17:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44917q44w8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 22:17:02 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50LMH1Rx022589;
	Tue, 21 Jan 2025 22:17:01 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44917q44vy-1;
	Tue, 21 Jan 2025 22:17:01 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH blktests 0/2] Add atomic write tests for scsi and nvme
Date: Tue, 21 Jan 2025 14:25:28 -0800
Message-ID: <20250121222530.2824516-1-alan.adamson@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_09,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501210177
X-Proofpoint-GUID: VHGMdPPp6gssZAGfKjRmATtmP37piIrh
X-Proofpoint-ORIG-GUID: VHGMdPPp6gssZAGfKjRmATtmP37piIrh

Add tests for atomic write support.

Tests will be delivered for scsi (using scsi_debug) and nvme.  NVMe can use the qemu-nvme
emulated device that supports Controller-based Atomic Parameters (QEMU 9.2).

The xfs_io utility delivered with the xfsprogs-devel package (version 6.12) is required by
these tests.

The Linux Kernel 6.11 (and greater) supports Atomic Writes and is required by these tests. 
