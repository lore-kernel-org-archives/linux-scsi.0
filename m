Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F374A27466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403957; cv=none; b=StK+BXqVnDV/dKdKiIq86ZXbxsMahis4Nf54BjvAQBzix6+/n4EUzmKRIaZIEBESqcFjc/mYfgAZOxE0nMHJcnV7dDcZDYZV/VE8TmiF6ZIfawwTx4EvZUE+gxypR6s8TdV+Isg/inQafT7JKpuXxBeaogGV0TlSvqzXJePXrmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403957; c=relaxed/simple;
	bh=rAFGHv7ZVzvY4N0rY8rLu2DS7By8hnKsbDqN8viDRZg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WzrAsBkcAqqIKEwSLhiKlxyTA33ym1tIVdf6dKcsLzVCVdSZIukPG3wRoMLRdjaL26EB+UeH4/1KSGYa696y5SvOWv2+PEw7SeWq/C1izAbj+vbmplDaROEz6hJ10F0inR6Zx0kB5s/O+zKw+qDmP8xrsOD2TQAVSu3dwT7hWEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=emx2uI+9; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="emx2uI+9"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748rfP874066;
	Mon, 6 Jul 2026 22:59:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=0
	VmvzFD+2zYgvgV2ZohBIBDxAy4WeRd/LtWao0Xp9lQ=; b=emx2uI+9nZcOtfdc+
	Abdypp/+wWxo/7D/NzefJH4MNm2eJfx50IVqIjV2p9llYyHwQENV6Wfj521uOcjl
	cDte4v+gUB8E7HK2R1BrOBLESIWIxa43ZQMpu2UcvgTBCyhVIPghZQq1akAT34jy
	AiWxTMdnfY5Aft+OTKL55+g2Jx0CVLfn3UG4amxFQ3+VCdCcoa4Hw6Bjj62EV160
	udPRRKVppjty95LBYLYPM6p/xqAL2sdzNsBaXa50+KkZ3cCn/cn811/crBfX9boN
	0OiFzKRh4BHqfANi22e4yp0oWK4JJ4u4CpDizYa4/E2S1j/2tVvIbpSOaNVWzwfW
	hG4ow==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waact-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:59:13 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:59:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:59:13 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 526AB3F7066;
	Mon,  6 Jul 2026 22:59:10 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 87/88] scsi: qla2xxx: Bound i2c->length in I2C bsg handlers
Date: Tue, 7 Jul 2026 11:24:34 +0530
Message-ID: <20260707055435.2680300-88-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: r_Nds-br2CDnAD_8znawiCmXwYtAc_UE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXyHafdh+85jgg
 GmrtRHpnqJ7tnRszzyaDMz/ZnVfHhvymbKGBjXH6r8DIYjm9lqadIKZ3PoFGfa70x1ZsXrrHJlk
 0B7FSzHHrOhBI7lENRfuon7chcZfZvM1m8Pqq85VgocJzCYUdJlix4um+DWMs5FdOvC0U2ej01w
 sBoelPtj60mmLj4eD1Cyk4xdGTlUlwbTYotIpYCrkEZCrtCbf26djxi58FdXEBxhDVfI/eMkcKO
 n86cLEEPj1iO0mTFTM5PINFLQWph69rI4oyzG2xtdmunYfRf+/8213JxFxNGAR+slGGHM0bGKGr
 AA0I29J0JT29hsWNt8NShF8Nu6v8p94qPM7CvRET1J75KlLDbG9ZZf7Dn6DMWTaDFzhqctuWNdc
 Lgs/9U2VNUBmbZjftSt+o98neVF0vMSulMSji3UKKjbiI6PPBFM0nEeqBLj0CnW7aAxZKuPNWK3
 NbAaQPdihprMpFR7L3A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX0lQpCWeJxNQv
 oEZb16EZ4p/rTwEv1Kc1YLj1bnBIZ1A0APJoBHUnRhYqUiDr55tkHNAFwwG68puxGLDtzqBcM38
 BdAkQzXPMRuNmkBXCIhUkkHl+ah5ybY=
X-Proofpoint-GUID: r_Nds-br2CDnAD_8znawiCmXwYtAc_UE
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c95b1 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=FIsYe-w1_y0ff0Q7JPwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

struct qla_i2c_access carries a 16-bit length field alongside a fixed
64-byte buffer:

	struct qla_i2c_access {
		uint16_t device, offset, option, length;
		uint8_t  buffer[0x40];
	} __packed;

qla2x00_write_i2c() and qla2x00_read_i2c() use the user-supplied
i2c->length without any bounds check. i2c is overlaid on a 256-byte
on-stack buffer and sfp is a 256-byte DMA-pool buffer, so a length up to
65535 overruns both:

  - write: memcpy(sfp, i2c->buffer, i2c->length) over-reads the stack and
    over-writes the sfp heap buffer, and qla2x00_write_sfp() then DMAs
    i2c->length bytes out of the 256-byte buffer.
  - read: qla2x00_read_sfp() DMAs i2c->length bytes into the 256-byte sfp,
    then memcpy(i2c->buffer, sfp, i2c->length) overflows the 64-byte
    buffer inside the on-stack array.

A caller holding CAP_SYS_RAWIO can use this to corrupt the heap and the
kernel stack. Reject requests whose length exceeds the buffer before any
copy or DMA transfer in both handlers.

Fixes: 9ebb5d9c69f1 ("[SCSI] qla2xxx: Add I2C BSG interface.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 51ab638b4fc0..6e7bd2bb634b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2161,6 +2161,12 @@ qla2x00_write_i2c(struct bsg_job *bsg_job)
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, i2c, sizeof(*i2c));
 
+	if (i2c->length > sizeof(i2c->buffer)) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+		    EXT_STATUS_INVALID_PARAM;
+		goto dealloc;
+	}
+
 	memcpy(sfp, i2c->buffer, i2c->length);
 	rval = qla2x00_write_sfp(vha, sfp_dma, sfp,
 	    i2c->device, i2c->offset, i2c->length, i2c->option);
@@ -2207,6 +2213,12 @@ qla2x00_read_i2c(struct bsg_job *bsg_job)
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, i2c, sizeof(*i2c));
 
+	if (i2c->length > sizeof(i2c->buffer)) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+		    EXT_STATUS_INVALID_PARAM;
+		goto dealloc;
+	}
+
 	rval = qla2x00_read_sfp(vha, sfp_dma, sfp,
 		i2c->device, i2c->offset, i2c->length, i2c->option);
 
-- 
2.47.3

