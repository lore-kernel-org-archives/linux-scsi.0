Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756E319597F;
	Tue, 25 Feb 2025 18:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740507761; cv=none; b=BlUDbhzVS/B/abLcn+GcZdflplnWP6oClU2XHsLKOJK1s2LnJk7XbrB+FsYzyT/iTnSzXHv7bBqJIEYfq7k0ybTMxlFdq0ygC++gS7QkZGKP2C9woNPc9xJBKFwImctL8TJ2+nxx+lMveNzqeMcklX4tjwQYWIwtPDAJ1wkigKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740507761; c=relaxed/simple;
	bh=PNvCJg9elJfwoYtj5L3LVl7XN5WApXh77sQmP1Dbg9c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HjUU8l6DOUol1AFIDk04rC3RgkX3t++FvN5C2ryovJIrPTGq7zZJpxS40rAzZD+rb5eRTJGDvYDCW9cJ/PxDjN9y76/qaAhgX3QRvarPJntOefTilGrKOLS2j3+Fbo8JN2yIH4rS7bC/v8j7uvLY94QGEAndU5PSPtziOD+opVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dkU0DeKs; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dkU0DeKs"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PHtbtP008584;
	Tue, 25 Feb 2025 18:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=/G+22Z5klOB/BaYgo3/8FGrN8t10I
	pNqOIARPY7xUJY=; b=dkU0DeKsROM/mZtEf2javZx2D5KeN1Q3Io1FzZ5INlqWU
	EjOlBw66OK2reLo2njrm75c4txi/6CI3EYfXzMOzMr8yrhuq/Rk3y4spj0/utNYT
	qe/TsvY2xl5PzkeunlttnluJuzmvFxZ3sjVcNbVyJprbpFto4EBK2CQ44O0llBV6
	ZFtUTWqNL2bfoAhuIvaK/BEbPISpEohdP/F0kN9/ZVhMIkmhxTHPxvnz55bPZCpK
	x1oNSxh2YChvvMB0cH7iw5fB8wTXCdY4lj3vdmiqri+1i58iXLs95KTQKba+zHfF
	u/OaRW/9wlQ7AzkNt/U/u0j+g7gGqOSk5wVCefx8A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y5c2e1k0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 18:22:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51PHVu0r024499;
	Tue, 25 Feb 2025 18:22:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y519n6xv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 18:22:33 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51PIMXe4038769;
	Tue, 25 Feb 2025 18:22:33 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44y519n6x8-1;
	Tue, 25 Feb 2025 18:22:32 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH blktests 0/1] common/xfs: verify xfs_io supports statx atomic write attributes
Date: Tue, 25 Feb 2025 10:31:07 -0800
Message-ID: <20250225183108.3881328-1-alan.adamson@oracle.com>
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
 definitions=2025-02-25_06,2025-02-25_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502250114
X-Proofpoint-ORIG-GUID: pffJKxOyNP69FTdj4LuhTKOWd7JakYK2
X-Proofpoint-GUID: pffJKxOyNP69FTdj4LuhTKOWd7JakYK2

The xfs_io utility is used to perform atomic pwritev2 and statx system calls.
The atomic pwritev2 was supported in xfs_io v6.11.0 and atomic statx was
added to v6.12.0 so _have_xfs_io_atomic_write() needs to be modified to
check for both atomic pwritev2 (-A) and atomic statx.

TEST RESULTS
============
Using xfs_io version 6.11.0:

[root@localhost blktests.x]# ./check scsi/009
scsi/*** => nvme0n1                                          [not run]
    /dev/nvme0n1 is not a SCSI device
scsi/009 => sdb (test scsi atomic writes)                    [failed]
    runtime  0.156s  ...  0.148s
    --- tests/scsi/009.out	2025-02-24 17:04:22.372544559 -0500
    +++ /root/blktests.x/results/sdb/scsi/009.out.bad	2025-02-24 17:50:33.256602965 -0500
    @@ -3,8 +3,8 @@
     TEST 2 - check scsi_debug atomic_wr_max_length is the same as sysfs atomic_write_max_bytes - pass
     TEST 3 - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length - pass
     TEST 4 - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran - pass
    -TEST 5 - check statx stx_atomic_write_unit_min - pass
    -TEST 6 - check statx stx_atomic_write_unit_max - pass
    +TEST 5 - check statx stx_atomic_write_unit_min - fail  - 1024
    +TEST 6 - check statx stx_atomic_write_unit_max - fail  - 524288
    ...
    (Run 'diff -u tests/scsi/009.out /root/blktests.x/results/sdb/scsi/009.out.bad' to see the entire diff)
[root@localhost blktests.x]# ./check nvme/059
nvme/059 => nvme0n1 (test atomic writes)                     [failed]
    runtime  0.035s  ...  0.036s
    --- tests/nvme/059.out	2025-02-24 17:04:22.371132656 -0500
    +++ /root/blktests.x/results/nvme0n1/nvme/059.out.bad	2025-02-24 17:50:36.383906336 -0500
    @@ -1,8 +1,8 @@
     Running nvme/059
     TEST 1 - Verify sysfs attributes - pass
     TEST 2 - Verify sysfs atomic_write_unit_max_bytes is consistent with NVMe AWUPF/NAWUPF - pass
    -TEST 3 - Verify statx is correctly reporting atomic_unit_max_bytes - pass
    -TEST 4 - Verify statx is correctly reporting atomic_unit_min_bytes - pass
    +TEST 3 - Verify statx is correctly reporting atomic_unit_max_bytes - fail  - 16384
    +TEST 4 - Verify statx is correctly reporting atomic_unit_min_bytes - fail  - 512
    ...
    (Run 'diff -u tests/nvme/059.out /root/blktests.x/results/nvme0n1/nvme/059.out.bad' to see the entire diff)
[root@localhost blktests.x]# 


Testing by czhong:
the default xfs_io version is 6.11.0 on my system,
after applied your patch:

# xfs_io -V
xfs_io version 6.11.0

# ./check scsi/009
scsi/*** => nvme1n1                                          [not run]
    /dev/nvme1n1 is not a SCSI device
scsi/009 => sdb (test scsi atomic writes)                    [not run]
    xfs_io does not support the statx atomic write fields
# ./check nvme/059
nvme/059 => nvme1n1 (test atomic writes)                     [not run]
    runtime  0.081s  ...  
    xfs_io does not support the statx atomic write fields
and then I upgrade the xfs_io to 6.13.0:

# xfs_io -V
xfs_io version 6.13.0

# ./check scsi/009
scsi/*** => nvme1n1                                          [not run]
    /dev/nvme1n1 is not a SCSI device
scsi/009 => sdb (test scsi atomic writes)                    [passed]
    runtime    ...  0.271s
]# ./check nvme/059
nvme/059 => nvme1n1 (test atomic writes)                     [passed]
    runtime    ...  0.078s
everything looks good now!!
please merge your new patch to the repo,
Thanks!
