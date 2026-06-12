Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775AB303A04
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258229; cv=none; b=FpSXAMG7Bk9ZMHxQYUh3syroTTVkE9umKB1zTqRUpnDe2oCCfCZfhKZexA/HTctJ2BIsjLcwhBHXb9ZqIlFtLk0UZ8KzV+F8nHjzJAR0S0nMm/tsFZ8BSh6OU0NTP+z4jhfuB7xwxr4parSou4HX0hwvQkikZG/LiKbombXOVh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258229; c=relaxed/simple;
	bh=WMKQQ5ijGzwYiM5y0GA6MOm6G9aiCBnrREmkH3R3l34=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qfGclTRytNgUc6Msw0/2yuc1NsAbcao/Qn1g5a3MYo3IB8rqBDlmWf+x9BxG8ZWdY3L+eTUpGjg3l1MoE4TJivnd1PoFqbjncAAtPwOip/9uZmC24ao6RdqL/Jqw9Kc1AlCNldZyM3/KAnG+IOgvTIuG7GlR2HyE8fuGxU1QIZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=BF85CyDK; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BF85CyDK"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3Atna071606;
	Fri, 12 Jun 2026 02:57:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=U
	T99P8ceNBbLzWOynN0lrBrLW3sc6tyo9WwRKHhgX5A=; b=BF85CyDKFzNaIhXtg
	KekIYmkELq7FLpuuESrse1aDdILxGFfyTA0bIDxbLfOmLJK+DFO6liTx5jwqjw3j
	UNxIzUGQRD97SAonDF7bF0q9YBkysJV85mSUzin7hpzFe1HNyzLuzU3GjGq5/wbA
	WQfuLTMd+ooJy+KslNktTooYGJ4rSoGoDgkoDtWy0ZJ2Cv+Dhh1PWbaCoGcDUkVw
	ctSrQ0gqOT4uY/zM2R7k+E1QJTMnhTTTimUoMiZUAemX3EaOFCS2WMZZ+CnSGjTF
	RTB9ce9B9GYOwoJddkfAKbNRRY/QukAB+ffQZpaL6TSzVyu2plK4llrvrlSNxAAX
	uGkeA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxru0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:57:05 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:57:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:57:04 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 188A83F7040;
	Fri, 12 Jun 2026 02:57:01 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 60/60] scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
Date: Fri, 12 Jun 2026 15:23:33 +0530
Message-ID: <20260612095333.1666592-61-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX2i7tjVRMh7Qf
 g3g6q695/lbigabmJBy92SrI9dNsd7HIn3FrfrvhJkp5LzFAqNPvQdh9w1FbX7mgufYp4nxhqX1
 XLYBau89TyScpss3hIgppJez+TUMMBQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX0c8tiatd3QHI
 unzRKYAuQyGeR28drWs9MjPOvthYbExSUZb0H9m1qIn8aCpWiUConAKN5PzFV0J+E14B7pegw1B
 tNvIO6DYpCC6HomVcKneLpr4xKM5Q1KR4AnuwkacNs5kcNETT3ypBRQFOrRo37Is1F4oZcloEPR
 WxFiwrY3oXgqJmkz/RiU7W+hCKAPDww/1oUbV2aotrl3N8BA1eDrmN8psI0w7urn8RFQyKhYJob
 Fe77ckZ5lIW8o0P/VLTHjdV4xftlDnEivSKUlEQcTE9rapXH+fenCZ7D9rMEosZ3HSH1sasxfD1
 Tvgy9CZbkMXtiSrVq0yTqay608p4YKDjDiPEwEPUzDTOiJHsagnT+b1vQZZMPMyx5zoADjPRQ6+
 0gOyBiDL+b7dcBsXpLOC54+j7d6VlV7mUdkPgkbQqDZQAedvi19D/lltVfgmSLO1qbjI8/CSvhf
 Hnk98fNyVO20ndPTaSQ==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd7f1 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=494MX3Unkl1U6TuN3o0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: L18Ah0r-5hlYPE0EOGoG7I_rxXKknQgL
X-Proofpoint-GUID: L18Ah0r-5hlYPE0EOGoG7I_rxXKknQgL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

qla2x00_update_fru_versions() copies the user-supplied BSG request into
a fixed 256-byte stack buffer (bsg[DMA_POOL_SIZE]) and then iterates
list->count times over the qla_image_version array embedded in that
buffer, advancing the image pointer each iteration. count is taken
directly from user input with no upper bound, while only
(DMA_POOL_SIZE - sizeof(list->count)) / sizeof(struct qla_image_version)
= 6 entries actually fit. A larger count walks the image pointer off the
end of the stack buffer, reading adjacent kernel stack memory and
sending it to the device via qla2x00_write_sfp().

Reject requests whose declared count does not fit in the buffer.

Fixes: 697a4bc69159 ("[SCSI] qla2xxx: Provide method for updating I2C attached VPD.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 22be6c822dda..bcca4ef3c23e 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1929,6 +1929,13 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 
 	image = list->version;
 	count = list->count;
+
+	if (struct_size(list, version, count) > sizeof(bsg)) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+		    EXT_STATUS_INVALID_PARAM;
+		goto dealloc;
+	}
+
 	while (count--) {
 		memcpy(sfp, &image->field_info, sizeof(image->field_info));
 		rval = qla2x00_write_sfp(vha, sfp_dma, sfp,
-- 
2.47.3

