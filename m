Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6A412F585
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302277; cv=none; b=NtrM25BpQMWBM2JvbBiqt7jkhit/bKywBy/nSmYI92JXpGsoThz33FyeIlqt6RxfjFEA9hEF3YPhgYz79po2XaQLOAeo6nIWp00Dw9vLD0T0C9vclpmOgNE4z54vkwLbUwVO/4hwFq0zRFobu+vkqHHZqFsz6ntC7okvv2BgU1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302277; c=relaxed/simple;
	bh=KW8CvhQhJ1zrrKmUR5pywi3tJFWGDrn/LdERECmFyPY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gBkpQbcuHQNWCknzXOoDojeVEzCBDerOj9VWS2HF+aZ6XbB3ehCgKgKG/tv9xKRWww4C5Y/KpFhxexk67HZPEnY/THRCoIRwMquO0lVVDULxfYbbIP/79iabcyvRKPgZyoJSdmEsYyQIN511yfglSI50yMIK0IxVNgS7RCzQxzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=O7ynLEYh; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="O7ynLEYh"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5L3P2729425;
	Fri, 17 Jul 2026 08:31:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	8RBmwOK6utyZcPJ1llZgyOfxNdqEsC4BSbQTkY/kRo=; b=O7ynLEYh0GAw2+k+u
	FdKTJiUpphGJDNgDU+xlm78qBZTEAqpiW4xzRQB1Ty6EMTGEtHindqFfawjLHhnx
	CAfWHmBrS3VWoIQZxwalW8VK+fgkiG8CaAduP2jEuhey1GiwmHzFqku/DJrZug4L
	+/P41ADIBdfAVpf1z2zsYwQzIt2p5R/d2Rg9N7Xxz/OwOQtaZAzlv/+Mbra6adDz
	R3wrY5tNMIYZsacpVQe1VFrTYbldMH2ipFDb1UVav0hOUieu1GlVZEZbIf164tt8
	F5riE7UwO0SyROD5uLcf0J65VolfCffJ6UgLivXYD3bfi45+qIwItPEP4I5RCSbr
	QEsOQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fewjwmj5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:12 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:11 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 1913F5B693E;
	Fri, 17 Jul 2026 08:31:08 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 43/56] scsi: qla2xxx: Use 64-bit FPM word counters for 29xx host stats
Date: Fri, 17 Jul 2026 20:58:51 +0530
Message-ID: <20260717152904.3155730-44-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 5MS7K17EwWNyXs8_fAaSz0zjcq_jnVVA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX+T3BbDfOMJF8
 H1P/BwoAB8YDMwU2gx/gs2E+3FCrXsIWoVCYN9VODYt9OTupExuTb7Oqzs9aWo+oIZIe+BkZzIs
 s68Oxi7EQuTILzksakfcGVadGe/wIy+ddd8yTqxHPfkfgweTyJR5gTby5m9Gdkne3y8/teegeUd
 G0t8A2T5owLpwsIZ26UD1/YVT+AOG1FeXA0GFsXfrqjac7zmfsz9o9uCS3wEZT/VeBd/dpMtvCF
 h+xOrCN2z+ydZdgGC0Zta2sRngNsZUk56L0RAqJ1dryUxIZ2iIwEggVoszqJ1gQk6Q/VsP531vW
 basIukkRJa/cKrVcVuDaRguCiXCFMGlONfJndAwTmEaQmS88PFxTVzIZ0VgyeAIVH8VhOfIMoJl
 WKPbjAek+T8g54w55azat/lltsAvta3Fw9gyY60R8iU/HYXVq6Dvv9t1zPllkpf4vnRYDBur8+0
 RAaOHoSbHWfXLO626eA==
X-Authority-Analysis: v=2.4 cv=Pa3PQChd c=1 sm=1 tr=0 ts=6a5a4ac0 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=iV06YDqDG_NXW1ljYX4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 5MS7K17EwWNyXs8_fAaSz0zjcq_jnVVA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX86vtg413ZoW3
 CnxqOUN3hALHZ//ugOOeUtV5bteHrelXcwQYLwylRG//49DRsyApmxtW58Ceph3o8uM/q1cGJm0
 VT6xKSNOk6BBg+Akn8izlkZYmUGYxN8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

29xx provides the 64-bit FPM transmit/receive word counters in the link
statistics block, like 83xx/27xx/28xx.  qla2x00_get_fc_host_stats()
only consumed those counters for the older families and fell back to the
software approximation (input/output bytes >> 2) on 29xx, reporting less
accurate rx_words/tx_words.

Add IS_QLA29XX() to the high-speed branch so 29xx reports the hardware
word counters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 19aa66b8ca52..6cf74f8c9628 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2990,7 +2990,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 		p->error_frames =
 		    le32_to_cpu(stats->dropped_frames) +
 		    le32_to_cpu(stats->discarded_frames);
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			p->rx_words = le64_to_cpu(stats->fpm_recv_word_cnt);
 			p->tx_words = le64_to_cpu(stats->fpm_xmit_word_cnt);
 		} else {
-- 
2.47.3

