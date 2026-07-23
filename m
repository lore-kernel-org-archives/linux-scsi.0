Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D591C1DFFB
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783230; cv=none; b=KNBSmPC+5XXgVO3fuia0n07ZQOUEv+KsmRbsONnvb77nopI01qVfnP82yGofWpXG5xQCrb/JVVP4L/QPdjpU0iamGlpeX0mN4M7FmCOqFLWzOHmHvjzlmx56o8X1+lphL7GFqZ0VG+2OY3d6+KGqN74BYVTw/s8tXNvmPOReq4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783230; c=relaxed/simple;
	bh=AasP97wRPrm4rEIVP64XFBPR1RHcZThzl7Nw8tY4HFg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QMtYWxBDtA4uhvWb6EkJKL4TMIHIDEL8BxdJI2+ndmlcAnQDcMTqqnFgEwzdD753Xw/VPdl8eAWPAczhYdwfSZdCcFeKKQr5fsn5KtPtTj0Gzoc+eHssPlIkumqssfUsk6j99EcT8lig0NQI4sSw4bfe2a2MelsfGm9IEkFM0i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=bmaRoUbq; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bmaRoUbq"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w62v422860;
	Wed, 22 Jul 2026 22:07:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=1
	si41gNkKxXivO/Y0CpNAqo7iwuLlKFJRLP8+voEcco=; b=bmaRoUbqLR3koB+as
	0F/BjcP0/ohDkTBHlsO518ZFpi6NKpEKKDPlKDkJHnkPl+RRY12rvpnZxyXOkB7x
	HTUgAMVrcnKjWUAANmGSa5uVdAC2ry/ZlqX2lUe+5VhaMgcdjcT22eY0ZJaOccJh
	bs4w1IVggFKm9BssedPGaCFb1TPt/BK2X70y2PiLr8v5OFd5wpq7cnoH742EeIwC
	pO5MjopmD1CzVNazqIB1Yt5/8TJO6I6XXOKK7gufa4Sy3Nton0w5dCn44p/O7jkd
	FAqJedYx/u9wFKOyWL0/GsD6PL+KbBe2q/FNbELlC/FmPWJVE8MD8L0oQX1g7RAL
	AhR8g==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8j0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:07:04 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:07:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:07:03 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 240785C68E6;
	Wed, 22 Jul 2026 22:06:59 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 53/56] scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
Date: Thu, 23 Jul 2026 10:34:10 +0530
Message-ID: <20260723050413.3897522-54-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: f-AwgeNHWmlXGcPb1ZNCCdMq_DtFQa6o
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX3bCIDkmQMTGz
 rP/cI8NJslyo/JlIc1DknAJQzZkXcTnDDzGwD57FbE7fP5W8MdCQxHTbs0bNQeAg0EMEHzVqUFP
 iIYjkaumG7TaWsh0OMgv0jtTjohOV2E=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX8STVU/Py9H6q
 EXm+SjnBuVubuiASZZ31ZvTNL7BbOPheSHWV9QpAomkWhEXdz2OZWfD3Upuff/iym9Ot37O16oz
 Ct377QA+Bds6HrBoG10Hm40x8TbiP8dynKVh10osdhtuN2Dr4ea5zz2fM+T0ZiSKPwU5RoyPfLa
 CxOUN9GujsfzLLK+tZAFqo/kDQP+P7IYkPzf6HZCg70QklqauDv+1zhIe/fZUp1EUlCU60C9JYw
 fTaFA7C05gTrZvsvwBcQTXkObUWEYmzevEnGAMJOgnGk42xUm6M7TRRm/z5Gy0cZkJMc2vKtNRb
 iQ6kdUlG5AjHQItbenbQEmE5qBaPdDZV5YE9WzBTBuPTdWDUYMXcuKdniFAi3HpuSYipRfcdK2k
 GYJyoov+LacTEt979bRvjPAFSzGtPnT/zfBh77aWBlbgg1T9icUgjDKLNxhtIX0xIprlihA/9mI
 Tdz8EmxzOacyeq9649Q==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a178 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=cZcaXCM-GTnW6IyOXjwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: f-AwgeNHWmlXGcPb1ZNCCdMq_DtFQa6o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

qla2x00_do_dport_diagnostics() allocates the qla_dport_diag response
buffer with kmalloc_obj() (non-zeroing) and, on success, copies the
full sizeof(*dd) back to user space via sg_copy_from_buffer(). The
inbound sg_copy_to_buffer() only fills as many bytes as the user
request payload provides, and qla26xx_dport_diagnostics() zeroes only
dd->buf. The options and unused[] fields are therefore copied out
uninitialized, leaking kernel heap contents to user space.

Allocate with kzalloc_obj(), matching qla2x00_do_dport_diagnostics_v2().

Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnostics.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index f9f9687316b5..4a9cf8da67a6 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2806,7 +2806,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return -EPERM;
 
-	dd = kmalloc_obj(*dd);
+	dd = kzalloc_obj(*dd);
 	if (!dd) {
 		ql_log(ql_log_warn, vha, 0x70db,
 		    "Failed to allocate memory for dport.\n");
-- 
2.47.3

