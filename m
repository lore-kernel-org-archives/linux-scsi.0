Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B35385D75
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403865; cv=none; b=qn9vWRJ8xjH1X1ooUMow8s4MTKp111faIAUbvLBwu6qmLbq9muOeOAXiI0YlpRX7nqA6+u+eOvEqOkSC/5vsGa8xozNrZna8cbb+KaVp5D8RIOjNgcN+QvIvYb1UkIXZQHM/x5/m587OGs2iotx4l3FQEPC2Dn4HA0Ub6NnPhdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403865; c=relaxed/simple;
	bh=0KLnE1IpJheRu3OSwm8buFbKODGYqEZBU2GnYwwOumY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nMiXSuFbfIxwqe63GbERgMaBUq2iCt0kCr0IJ0ggCNq40un3SekZ4lU9WKYPPNuCU1KjErswT9/prYOEbPX8JgOCo9hnb/o0fvFAwIbNt65MH4agVyVUidXsHEt6Kb23jxXR+DGj32c+SEDWcKkdq1h7oB4f6FBKJJMhwEn+1iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fqP/+HB8; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fqP/+HB8"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6674834T872825;
	Mon, 6 Jul 2026 22:57:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=K
	Cadgf3jaxL7+UfqWWkfCuhHqHhZD/b0v0Vex1jXNHc=; b=fqP/+HB8re44n6Dd/
	AoOl+Rd6YLM36FWba9Yxx8S/5TZx6oLAOTQLnot14xLNfj9mqZbGoKbbx4a+DDXd
	4LSJ/QuJPlIfGGvDWQf1bs9AMdOmKbfdkqY6ns9ZUfZDawAe/ZAv9Y4lXWh0wMF2
	djkyAh0bhneNfdq1wbGkKJ+r4gDIWNJ3M+5j5snonbpt3qqOup5ephMOIpOG1H+D
	n7U9t6wWwDcPBa8j81y5zadPoh44Lvoew6IEt9zT+bZYblOqD00TWhXN96D076ar
	gDTY+r/ltfKQPWINX30vSb/m7yw0rZe2hUYKXgjtfNLy+I/NTjb8bTBcm3J9zHw5
	MSWDQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:41 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:40 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BE5193F7066;
	Mon,  6 Jul 2026 22:57:37 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 55/88] scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
Date: Tue, 7 Jul 2026 11:24:02 +0530
Message-ID: <20260707055435.2680300-56-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: k1Fytt1nGUpkde0IApdk6BD_C-8-UvFa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXyaElh2SFvjxn
 9TDYeshmcFhrYHv6hqoGoZEpWDaIV5pye49YmMRyTo81vTSS9zMctbH65UorWoSpg7FgDOz+Byt
 mvfpe1nfAxwNDKrumSKVnDq/qFLgkmKo/EXgrnGuy/h3K+x2gFCZbk0sgkuZyAuuZytuW/IHGC0
 MxkzwOtZdemS9uWUIMdl+DV9No2j6wqQNygDQqLFTI68M18XZFPQbLMIKXSCwjI13NMTfK2+mET
 IjnxVup+5d5w2dkjsE/0tN1E82WvIGQ/uwJ8v1ZKHP8Ir+rRkMqxPYzeL3KLALSsmSY3mGvKsUZ
 SEj6b9g3ul6jj993vgVzOkCQbKBfLtyXdUmWA6TVZtMnOIHVubXRXZZ/FoRg4P1QqxYSfxYxJBY
 n8Ngzw3vvV+oAllF2yx+JUecYGlT74MORccy/tdy0Pwz3NyNSpPRDeI3tMWabgTOfn4JAWYDSqN
 N9vlB2OKybUamAWlVcg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXzQNjMh2fC5j/
 G2TltcUS5emP9odGhkKeLrzHST44+fR8RqMWf0mVckI30O7b/ajqP2Ui94sLzoRxW52zhbJCMnX
 3zHHhAgqc1N0ioJ5CcxbGKD5LjR3ZNU=
X-Proofpoint-GUID: k1Fytt1nGUpkde0IApdk6BD_C-8-UvFa
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c9555 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=494MX3Unkl1U6TuN3o0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 0c9174d6c887..55142df30bda 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1977,6 +1977,13 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 
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

