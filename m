Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3EF185B59;
	Wed, 21 Aug 2024 06:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724223098; cv=none; b=fQRLFsjabrgoseYWOI19hCa6Uc7GVcIH/quvZaty9GruVkt++DwvC6+aNNXeM0EAbsX8GvMlwZSRsOjKvo+gXM02ZCoVo8TXvBRwAvNm+MTZ0EqgugpDm4+DPtmMB+pZg1W7+Ci1752SIi1x015UE3nxxHHy+v8G8hojrfY1jmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724223098; c=relaxed/simple;
	bh=eCHDWLX3EQfO870KM02gATOAbYHiHFt3dOKAmRMVTu8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dcKwX2aD7WqKfSO3/06EYSfZ0tngwqP9yxHHOoZONJ8NJWKMEln/S1AUuxnQjNHi/ZVmO4tKIU4kuXGqGL39wEj50IUZLWG51VwJmlgPemP1Y8/N57tXwQZdF+e/omE7RKkfvW13JcIUz6FtNeQE6rmxBIDMqrohdUxgPFK97fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=apU+KR6K; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="apU+KR6K"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47L4fYPK003860;
	Wed, 21 Aug 2024 06:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=corp-2023-11-20; bh=NMKia/ORa1GdOb
	qCLAYhbFv9EbJlEL5ozFVZElGmjnQ=; b=apU+KR6KV4BTnUPg2vMN72uPFeS4Po
	dqbq2yEENba8tVWTJJ1bXSsjeWGE7TCcUyxJByCTJ5RvBFtuD9eocZDQe0/vYw+k
	ylmZPOpSa5XYXQnLqnVRSH8rAcciyvtEp/h7jmn8FpU3WLzgMeEcTbbREstt23Tl
	c1Kv3usAkjPHpVD5a9oEfJKmUl04Rjyn8xiaqt9v1lntuPVdn22h6WKblFMBQf9K
	X123iLnybuTGmE7rsiDJm3hQ/LS0sDY7Jk/UP7k6FqFV1h5432iu1RGwfRLobrtU
	MCMEI/IpHIlj4x8zF8Pmy2no9W4WOvfM4iY3KVDyn/pN+wVkQyv7L5fA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 414yrj12sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Aug 2024 06:51:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47L6It4R006250;
	Wed, 21 Aug 2024 06:51:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 415av28vdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Aug 2024 06:51:32 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47L6pVPq016860;
	Wed, 21 Aug 2024 06:51:32 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 415av28vd5-1;
	Wed, 21 Aug 2024 06:51:31 +0000
From: Sherry Yang <sherry.yang@oracle.com>
To: james.smart@broadcom.com, dick.kennedy@broadcom.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        sherry.yang@oracle.com
Subject: [PATCH] scsi: lpfc: fix overflow build issue
Date: Tue, 20 Aug 2024 23:51:31 -0700
Message-ID: <20240821065131.1180791-1-sherry.yang@oracle.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-21_07,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408210048
X-Proofpoint-ORIG-GUID: c1bK0JHnvUEOFF_iZA-3zJQpaHoTqXf8
X-Proofpoint-GUID: c1bK0JHnvUEOFF_iZA-3zJQpaHoTqXf8

Build failed while enabling "CONFIG_GCOV_KERNEL=y" and
"CONFIG_GCOV_PROFILE_ALL=y" with following error:

BUILDSTDERR: drivers/scsi/lpfc/lpfc_bsg.c: In function 'lpfc_get_cgnbuf_info':
BUILDSTDERR: ./include/linux/fortify-string.h:114:33: error: '__builtin_memcpy' accessing 18446744073709551615 bytes at offsets 0 and 0 overlaps 9223372036854775807 bytes at offset -9223372036854775808 [-Werror=restrict]
BUILDSTDERR:   114 | #define __underlying_memcpy     __builtin_memcpy
BUILDSTDERR:       |                                 ^
BUILDSTDERR: ./include/linux/fortify-string.h:637:9: note: in expansion of macro '__underlying_memcpy'
BUILDSTDERR:   637 |         __underlying_##op(p, q, __fortify_size);                        \
BUILDSTDERR:       |         ^~~~~~~~~~~~~
BUILDSTDERR: ./include/linux/fortify-string.h:682:26: note: in expansion of macro '__fortify_memcpy_chk'
BUILDSTDERR:   682 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
BUILDSTDERR:       |                          ^~~~~~~~~~~~~~~~~~~~
BUILDSTDERR: drivers/scsi/lpfc/lpfc_bsg.c:5468:9: note: in expansion of macro 'memcpy'
BUILDSTDERR:  5468 |         memcpy(cgn_buff, cp, cinfosz);
BUILDSTDERR:       |         ^~~~~~

This happens from the commit 06bb7fc0feee ("kbuild: turn on -Wrestrict
by default"). Address this issue by using size_t type.

Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 4156419c52c7..4756a3f82531 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5410,7 +5410,7 @@ lpfc_get_cgnbuf_info(struct bsg_job *job)
 	struct get_cgnbuf_info_req *cgnbuf_req;
 	struct lpfc_cgn_info *cp;
 	uint8_t *cgn_buff;
-	int size, cinfosz;
+	size_t size, cinfosz;
 	int  rc = 0;
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
-- 
2.45.2

