Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BAB443AAA
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427174; cv=none; b=hSDpjcGXdSySgyY1v1XI9j1+w7qTZSO3yjYpySbneh+yDq+EFMNZGVQ0VV8M1/w+5q27MRYRN06Up6/dAtX4ZiMgZt9XQ136h42chPAV01dLqjr5Oq4b8Ql4Q7K6GI9y9jS6SZuvmH7IsYpOAA9kihr3i7mKtiQ9qPSwxSKCjO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427174; c=relaxed/simple;
	bh=ogY/c3nNwcs32HJYHx2if3RmD4F+ka8he3HEPj7A600=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdt4g2ibzrCgLLqw/kJVB8BYV2ev0Bp4bom44pE7pB2aieCDkVBV0jvglUOQgjNqHcYG7U5nTxx8alDHw+zea5FJj03W6H8TuA3hHNn+3ThgH5M9O33/5SeocRftqEmcNyh8JQUqOiS/SB2q88dyPT5EeQxTLB9q12HWjZ2MLh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=b8/dPldw; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="b8/dPldw"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFVGf73038870;
	Thu, 30 Jul 2026 08:59:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=6
	KQcv/DNYXJodWg18F0sxy3rS0OY+OK6nHuxm1tkTAs=; b=b8/dPldwKdpdnIGfB
	VJ+c2O9Mz0LmWwjqi9ZlQYQ0PlNim+zCN9Gdvfyau6LEsdiRBMKqJKYVaDGq0HK0
	mt0HuoCBuRudLQOloCxRsxw83kQEbwi8SlG8lKshnoq0qXiFz+vyQHrZf7jkqMOa
	kPFgdzCaE05HvADy49+frOeWQQamCKrReT7PRdiLpHblYzBvYjaC7u6JulOwqOBa
	LfrXKG4+DjUTWRnJQLP7G/zeJr1BLK4j0G2U/Tm7KmIT8sS4x+ayHREUCCDyxvzh
	9NAMo+aCD5W7L6mQM+Hx4JBgjwzavggyq3HpJYc16/RMXK+Gw7Z4JsGBrKMOVTqZ
	H4C4A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7atqwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:29 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:29 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D7ABC3F704A;
	Thu, 30 Jul 2026 08:59:26 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 09/33] scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
Date: Thu, 30 Jul 2026 21:28:14 +0530
Message-ID: <20260730155838.2119230-10-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX8rV2AmunL/8F
 x7tuw4/ZVR20OTv6vKTUKVIgbju2OkCSqzLib4oUOqf7rPMGM1CWDi2HCD0oKZl+vlAXvPxIT2t
 pFPLx2EVhOBsF7UfetemGalnTqUx05bggMZ9NF6JXSMFYHBnSAoAvTuXtum0pO0hYc3ADBxaxMp
 /S8FYHacOZcfQJFVHBT25uO7qsZNSacEW1xGAJ9O8YWHeqM23WX3ICAwQqzTjYOWIP/ch+HiWWp
 MVD9BAM8UV+rC+ORMeUFucUEaoWzdKgkY0exjO5rw21WJs08ViyLlflnK7Yvmn7l7932Kz1ui8C
 tgNdoSeq35DIiJqYI7bPC1sihyZNGxDO/H6WDgSNCjwLkB9V8m68EJikx2JEz1qzlNFueq9HnJa
 0GNO7t/GUgAf8WzT8PzC8ZiAqtgJNtyTvTp3Rm/ols91HvT4Bk4tCc9YOHMcuph3tSq2Xv7J7As
 UbP9wwhCNoXweEr2CVA==
X-Authority-Analysis: v=2.4 cv=TbKmcxQh c=1 sm=1 tr=0 ts=6a6b74e1 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=kHUOPGJzchApZ1z3-SAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: hWi5BiY0ZrTY9tZ4NhaeqI1OGk3cCAAT
X-Proofpoint-ORIG-GUID: hWi5BiY0ZrTY9tZ4NhaeqI1OGk3cCAAT
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX9HfPVoTA/QNV
 4ZrCzKi++/bgeCqHvDTI3amJ0or5UcLcXyinVaNJYJ3NekB79n/+zwcAyu093INdQkZSrNG6SEq
 L5Bg2HsSkDIwAGSULfm4zK/mFuNRmPs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla2x00_dfs_fce_write() called kstrtoul() with a NULL result pointer,
so a successful parse would dereference NULL and oops. Worse, the int
return value (0 on success, negative errno on failure) was assigned to
the unsigned long enable flag, inverting the intended logic: a valid
number was treated as "disable" while a parse failure enabled FCE.

Parse the value into enable and propagate parse errors to userspace.

Fixes: 841df27d619e ("scsi: qla2xxx: Move FCE Trace buffer allocation to user control")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 177d47e92e49..5d08bdbcf70a 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -510,7 +510,9 @@ qla2x00_dfs_fce_write(struct file *file, const char __user *buffer,
 		return PTR_ERR(buf);
 	}
 
-	enable = kstrtoul(buf, 0, 0);
+	rc = kstrtoul(buf, 0, &enable);
+	if (rc)
+		goto out_free;
 	rc = count;
 
 	mutex_lock(&ha->fce_mutex);
-- 
2.47.3

