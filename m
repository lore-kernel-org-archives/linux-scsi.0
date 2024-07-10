Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EB5194A59
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 17:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720631485; cv=none; b=HODLNERtCaP5SzxSfcbq6MxiZw/Z7c+4hTH++tNoazjpINobxaI2NsIoX3RnUlumVngLHMYAJBHi107IYgJ1bCMb2TR3QwwgNCHwmXm7UuO6kbnxlaMzlpCGGsxboXm3EPKR92unZXueYkWVh6EdNTbkL5kkn4WHKE1/4tHZYH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720631485; c=relaxed/simple;
	bh=lc4ZaAn54clsUKgZpmUMwFZmCZ0j3aje5jHDahvDgpo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fiP+JAnRtuyyNm0Ndh6JRX77YdazwMezYOFb54gLAW5gqEs2kj5LT5ImHBioGJSAG3uCMdto1t9/zq4eoxABiYn3V5L8lPWES0UnhWwWX6k+RHjHXIxuX07ip+1ODTy4FS1Oz/956PH42OjAYp9rn99BN0MQnf2JXMQi7ae/NQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=iFpere+a; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="iFpere+a"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A9lEo4023826;
	Wed, 10 Jul 2024 10:11:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=h
	SqWL1jzJL8X5Ye9wLb4KMs+ps3XaMjtv2ghEXYfnw4=; b=iFpere+aCi4lCv4sC
	C7rXBivG9s6k4Z2aJKsS+qAsdt0QtP6lJ93Mb8ZMbG3pdQ1VB9zdeHqD2CogF86r
	NiBgPTFK32XG2geUNNKWz8yN0kpMShTG01TTEnx+kjVYK7K8PiCcrBMwgn8ItGpv
	RLmxac8TzMlSPLJFq4KFa2LonCu+coBKX6N0/6M0t6D5b0ldYmRQiT4GGxyeEcyF
	cHp2MgErV/6byG+WmujFbhby8deRL2PhW3Hh9PYZnNWUM47W8aT8V2ngJP8yNkAQ
	3/Lx1F+qSVJdMrDzpoVl+chrGTGkM1ffRvnx5QTY2jUN2YESc1aN4vfdm8RUOyQ+
	Jm4Jw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 409qyf21mj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 10:11:21 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 10 Jul 2024 10:11:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 10:11:20 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 22B1B3F708F;
	Wed, 10 Jul 2024 10:11:17 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 03/11] qla2xxx: Fix for possible memory corruption
Date: Wed, 10 Jul 2024 22:40:49 +0530
Message-ID: <20240710171057.35066-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240710171057.35066-1-njavali@marvell.com>
References: <20240710171057.35066-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ErYwKQl9ZpMRIafI2w2TgzMLTbhaRtRi
X-Proofpoint-GUID: ErYwKQl9ZpMRIafI2w2TgzMLTbhaRtRi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_12,2024-07-10_01,2024-05-17_01

From: Shreyas Deodhar <sdeodhar@marvell.com>

Init Control Block is dereferenced incorrectly.
Correctly dereference ICB

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar<sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fcb06df2ce4e..70f43eab3f01 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4689,7 +4689,7 @@ static void
 qla2x00_number_of_exch(scsi_qla_host_t *vha, u32 *ret_cnt, u16 max_cnt)
 {
 	u32 temp;
-	struct init_cb_81xx *icb = (struct init_cb_81xx *)&vha->hw->init_cb;
+	struct init_cb_81xx *icb = (struct init_cb_81xx *)vha->hw->init_cb;
 	*ret_cnt = FW_DEF_EXCHANGES_CNT;
 
 	if (max_cnt > vha->hw->max_exchg)
-- 
2.23.1

