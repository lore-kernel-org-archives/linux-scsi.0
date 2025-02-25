Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A701624C4;
	Tue, 25 Feb 2025 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740507760; cv=none; b=M4qXFt3ZI7evJ8m3Rhm9IzDpgJLU+25ljTYZqjx+/bWD3XgNTpIJIZY/tIEkJhKzzq6hj/FWEhabKD9f5HtBvGFHrf3/RR17TTwhBrz59snkJXI9BlD5mnCGfbNQ4Q/elE7vuYZQ0wFtjC/0vrJoKZeSwkIWEWAnuUsqAwE1NYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740507760; c=relaxed/simple;
	bh=qb4Lkvua5HTzO8mdZJQMjJPTj5qb9aMYFAXoIqFoigo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRO0tGHtvW4dUfkPQBgeKP8RBtnFHyThDwRnP0Kxfo7QZP0VTRnyKujxmBNSXqYI3SjGUF/lXWAwK6lm64LqJkkp0MF/v6/legINp6m/myFxJJkdD1JUlZTqn5s1vrezAI2yiQ4Vh7S0/gBY6Dko7cdjHP4VKy4Of8hM2LwmyoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RPhh6bNk; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RPhh6bNk"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PHtccq028274;
	Tue, 25 Feb 2025 18:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=jqvPW
	h1XotWX+Uhry/+cGJzjY5ak8C0eomurxRwFRJg=; b=RPhh6bNkMT/3V2e0cUm8I
	Bp98apH+lQ6Wh04r0tjDK3BkoAQQ9Ho9yNEa75qUQkEMkEzM31vpUlSYLaYmWobO
	KNT/DEpp360+TOOqDi2dopNW2liQce0Ft8wTwL4GY3IJ6uYHlIEUsh5cMqgWpoyE
	EPgPNesPQKJ5TTXg9vwR1q2vGwZ/2zarXoFE5XAkl1xHPSwWP/XwPANnE8174ge1
	tC6yIBu3BMaFYdhW9MrHu2khtAWtc33dykUMMdd+1N7NvT4IMkS+3FxJVZNNNr7y
	rWZeOpPzudJ8414chOwKC9f1EEO4ON0KSUdsPeAh20/vSl9k5kI/uHEDqSvVcfei
	A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y560604v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 18:22:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51PHA6H1024384;
	Tue, 25 Feb 2025 18:22:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y519n6yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 18:22:35 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51PIMXe6038769;
	Tue, 25 Feb 2025 18:22:34 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44y519n6x8-2;
	Tue, 25 Feb 2025 18:22:34 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH blktests 1/1] common/xfs: verify xfs_io supports statx atomic write attributes
Date: Tue, 25 Feb 2025 10:31:08 -0800
Message-ID: <20250225183108.3881328-2-alan.adamson@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250225183108.3881328-1-alan.adamson@oracle.com>
References: <20250225183108.3881328-1-alan.adamson@oracle.com>
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
X-Proofpoint-GUID: 1Jq9aL3QLj6_Tjn4rS3-IQVoU6JxQyzU
X-Proofpoint-ORIG-GUID: 1Jq9aL3QLj6_Tjn4rS3-IQVoU6JxQyzU

xfs_io atomic write support is a dependency of the scsi and nvme atomic write
tests. The xfs_io atomic write support was introduced across different
versions so if xfs_io pwrite supports the -A (Atomic Write) option, it doesn't
necessarily support statx atomic write fields so that needs to be verified
separately.

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
---
 common/xfs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/common/xfs b/common/xfs
index 10ecda7c75c8..79e79e7f45ae 100644
--- a/common/xfs
+++ b/common/xfs
@@ -11,6 +11,14 @@ _have_xfs_io_atomic_write() {
 
 	_have_program xfs_io || return $?
 
+	# Determine if the statx command returns the atomic writes fields.
+	s=$(xfs_io -c "statx -r -m 0x00010000" /dev/null | grep atomic_write_unit_min)
+	if [[ $s == "" ]];
+	then
+		SKIP_REASONS+=("xfs_io does not support the statx atomic write fields")
+		return 1
+	fi
+
 	# If the pwrite command supports the -A option then this version
 	# of xfs_io supports atomic writes.
 	s=$(xfs_io -c help | grep pwrite | awk '{ print $4}')
-- 
2.43.5

