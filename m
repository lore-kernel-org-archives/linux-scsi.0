Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A281743CEE7
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022982; cv=none; b=rN5CknNWl7Vy/VuK45dgkZxPybY2i+aWl92s2JugHM3nQRRh+iIeZiHbNmyLxSXJQF79ioHK4Pb8zoClgE9WntwX8XnvhBQLkSJ/zoZNzOn5q2pp5RXBfI8e3sgpekbBiY7YarhnlOe05C0FjCsPKnhSlvk5PfyRFyiUEIt1gho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022982; c=relaxed/simple;
	bh=KW8CvhQhJ1zrrKmUR5pywi3tJFWGDrn/LdERECmFyPY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pQ1HkP0mN8KH/JhHEbhHMbQST5VZrGtjiBf+lPilvk+FpjQz4OOJmTGPdujsRsEsTZvSC/zXoR8sNwA3KHpZGImAajpcFs0vFyDIthb6wVu+rU2tkhvgUt18JXflvIc+K4xyPhNvRyKTEAsVC0DZ5jjq45p30eiqzdvCsh0buRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=BeJeOnuu; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BeJeOnuu"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UE8d2407837;
	Tue, 14 Jul 2026 02:56:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	8RBmwOK6utyZcPJ1llZgyOfxNdqEsC4BSbQTkY/kRo=; b=BeJeOnuuGF16/O0lC
	OkvO22bfrj6jmlq4nUz+JDyngxeA+E6Uyiqcp5+SpQkYHhuQOAxf09bOlXC5mR87
	iQlJQFwFPfIryvAzOKuwjxwHuPCqLBjo+ZISz7qZv6KvrMj5K1M26nHb+IiY9p07
	VSh+n21gaaeHgS4STswsLWEV6QA37q9uLhwMoxVSp5elCQlmeR8juMZk2ItGXsLG
	5XSt/9x6qwJzy96coAYL2WD1MUuHavyNyFCSSEA3Wtp8xgq3eH/FHedrnzMW7lPm
	hFQ1y/lZfU01K7n+usLSYC7gh7NJo0Twypp7rE4PaiLkR/cye6byLGyu8sbEtsqQ
	1VB1w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9nq7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:17 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:16 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 4F2255E6867;
	Tue, 14 Jul 2026 02:56:14 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 43/56] scsi: qla2xxx: Use 64-bit FPM word counters for 29xx host stats
Date: Tue, 14 Jul 2026 15:23:40 +0530
Message-ID: <20260714095353.289460-44-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: A2rli0Pc26spNzxH8Esqj9IBRjUfIcpL
X-Proofpoint-GUID: A2rli0Pc26spNzxH8Esqj9IBRjUfIcpL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX2qZ3fB4d/MML
 6fgnyRRTG/wmCm0DGaxglry/VIwCEan3akaSsjuaRZBDLokyQiGGftHN2AOyobmJowpZfd767zH
 5qbVVNCpHeK6hVFDvRi3CUUAVZd7TSo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXyp3kQ7OYdT2H
 a73gDOqVq41smMG9A+kK2NKR+CB6a375HnZBZPLAFeIaXjO1/vby0OyaaJ/7JDTt05bbhwuyb6q
 pQz+pwiziv/J0RIOwJ8GF0PY0717WVk00YA8OY1gh7SWJox+2Go0OZpnz6L+5LMRPm+fkTbMcM+
 xto7huBK5p0K35LSWPSFnxUWMJOXKDxVrLpSR9wLTXSDzloBJuGKdK4wL0V2LRbzEXDEI7afwc0
 j4u7LXT9KRWd7COUgzARnaLkisO99LBsu/Q4l5X+isPSV93lhsGMI6wTu67MGKXl7gRB2e4+q3t
 qvmiWFYIgNEzD4ffjy5kd86LIprDe2EM5DJLq1ZStD68XpFKmDwA6gGb499HaLuB4tgZvRjhCwl
 rCq7FLQknexnx3+4OCMDpHYYzIujkJYsjJauf0uYYr6SoWC0YQh6J2YfiPyxrQkW/TN3S4kMxdG
 hw6u0Vu8woJkp0wRCCg==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a5607c2 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=iV06YDqDG_NXW1ljYX4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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

