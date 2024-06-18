Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3770716EB4E
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717887; cv=none; b=FGaAkK0T1p4/pNWU0YdjQA+TgFR72WZDVsysqecFcVzgBpawYzj9WXa+0v0Ykoseg3MAiq/X5rWbQ9x0GYxDb+3eEu/5AC97n6T5/3Dlg9G6J4N7LcB1EaEsuz41Os0JtwFeTepVdjL2J8AowwFAdO6ok98/nV475OTh8dn/8KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717887; c=relaxed/simple;
	bh=lc4ZaAn54clsUKgZpmUMwFZmCZ0j3aje5jHDahvDgpo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ex7OYxVjteRDWNGDfx5yd8hUoGN2eI0Vnt6ZGTzQ5JajjTmQ0Lzr97XMggWkXuqzLYxgL3Wj9dYuZiyZYFoSb3fW6beMqiMNWP/IORUY3Lfu7H5svyl7PZdYtGW7zCkL7HKItKRNn97d7NvoTu97jq9NCwg50dmMzd89dv1AuMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=McXPd6/G; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="McXPd6/G"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45IBiSUX015596;
	Tue, 18 Jun 2024 06:38:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=h
	SqWL1jzJL8X5Ye9wLb4KMs+ps3XaMjtv2ghEXYfnw4=; b=McXPd6/GQCXn+nNbJ
	xBQdleg0DQCvYygOXDxbXfWPJ/sr6liBq2rFTVDdDDUAfN0xqrbx9SEa+kqRwjbB
	1SGNH2bP/xPrNeKaDd94CwFDxzx9MsR0RJzg0qRF41e1d+siDm5UNNjABl1G50s8
	dcLSp/mHv+Gh+MSmwZGgd4Wejn9XqvpuiKV5zujD53PRmtvUpPa5igKNXjTkzdUp
	jSZxVFJCh6JnJAAKvig1WbYG6IpgVbtCk16A7+D0vwTc8CmiNFNNqEQHHeELRmZk
	ZKzGK0dkt6hBh9P3Wcf78aPqpZ0isHfBDc2oxchw25f3WQEBibyyX+qUwHllwapa
	J+PYA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3yu0nwt3n5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 06:38:03 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 18 Jun 2024 06:38:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 18 Jun 2024 06:38:01 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 457C93F706D;
	Tue, 18 Jun 2024 06:37:59 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 03/11] qla2xxx: Fix for possible memory corruption
Date: Tue, 18 Jun 2024 19:07:31 +0530
Message-ID: <20240618133739.35456-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240618133739.35456-1-njavali@marvell.com>
References: <20240618133739.35456-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: _IgMEHcZ1fKtukubpPfwiPsDpyQkimgV
X-Proofpoint-ORIG-GUID: _IgMEHcZ1fKtukubpPfwiPsDpyQkimgV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01

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

