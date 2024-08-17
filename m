Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88CB1C27
	for <linux-scsi@vger.kernel.org>; Sat, 17 Aug 2024 00:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723856046; cv=none; b=oZKsa+6WFHXuCKvm2EVVgKKvpQeMngw3/csg+6dgA9z+KOdzXYXTllK7g9bdd3AutXT7KqoCFagGsaNH6N8KJgrJZljyg0Sakt9fJ5C84aXP+cv6Ad5XWw7RhXbqWigNRpwSmS8iaHsP632x9OtH+e/dToe2bBBkc/OETjdYygo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723856046; c=relaxed/simple;
	bh=bSuXOBztwSjmoFQBmC1KLNWGZcQ0/lxcmMBkE8XKUgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT/BVk3IUQtVxGv4QuXqG8nnZdyQXdo977auTORO4uxz/Eoa92qLsxW3wBc8PoQ3UMVX+XgYEF4C84CeHO5A6IGZG1EcZ2gmjK9tc105D1t2g0zlDQk73iwKKLP3aLtPnbYB5H45MKnGmODUYNmvHNgOvF4vaIHTvHGtanuFvxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c9oXxGPO; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c9oXxGPO"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLBtv4031714;
	Sat, 17 Aug 2024 00:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=T
	5ISDHhzL0sXS5RwLx3vvUN4KGXgJWv5ofRejHMxffw=; b=c9oXxGPOiPvNRVtu/
	JuxxG1sBwSfs//CqDY0Pc8+/UJ48DE3NYyhJwr2uE9rDjeewLVQoe8oOtUjzJWLj
	rIOBlEN70ynZ1CqWCdOfAvVS+l529Hztc9BkIf1PnLpiVwj0GFkC6vawHqV9Ylf8
	qY/3tsuFXltKrc2X7ZpjWJBIOurCrzeJjaXfOG1YNiIffSuG8t/pg0+uX/bocS0K
	NNJB+VGSzcuzcFxBvQTsjlOdbe0evJNUFFaYE+8XmCeJn6Gc3OJnhfxMpAGp+wU1
	sgfvdnJBf/B6x+bDiWSag74k7pO00t/UASmwaVTN2qZtfDXjCR2mE2xN38uk1Rf+
	Jg22A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy035x6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 00:54:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47GMJwHH020583;
	Sat, 17 Aug 2024 00:54:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnkgmap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 00:54:02 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47H0s1bO038785;
	Sat, 17 Aug 2024 00:54:01 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40wxnkgma5-1;
	Sat, 17 Aug 2024 00:54:01 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Bainbridge <chris.bainbridge@gmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: sd: Do not attempt to configure discard unless LBPME is set
Date: Fri, 16 Aug 2024 20:53:10 -0400
Message-ID: <20240817005325.3319384-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com>
References: <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-16_17,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408170004
X-Proofpoint-GUID: had3BXzyBu_iznpQ6y4JGU0LoR0sUBcZ
X-Proofpoint-ORIG-GUID: had3BXzyBu_iznpQ6y4JGU0LoR0sUBcZ

Commit f874d7210d88 ("scsi: sd: Keep the discard mode stable")
attempted to address an issue where one mode of discard operation got
configured prior to the device completing full discovery.
Unfortunately this change assumed discard was always enabled on the
device.

Do not attempt to configure discard unless LBPME is enabled.

Fixes: f874d7210d88 ("scsi: sd: Keep the discard mode stable")
Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 699f4f9674d9..dad3991397cf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3308,6 +3308,9 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 
 static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
 {
+	if (!sdkp->lbpme)
+		return SD_LBP_FULL;
+
 	if (!sdkp->lbpvpd) {
 		/* LBP VPD page not provided */
 		if (sdkp->max_unmap_blocks)
-- 
2.45.2

