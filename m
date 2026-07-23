Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B02014F70
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783200; cv=none; b=KzUutkVFqawfdHFZBCAO02gPyxKD42eLwOqG9xkMrbluIbJ9mvZS89epajjd+wKeodlQTsGdo59FNb3wGkvvTh8T7xhUCOzY+UgjTNRUGsMCJx/7NPQrTYTILv+JzNhCb2i0mtTstgqlbLGjVll01nXlmIiNm8haUeN4FoaIUK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783200; c=relaxed/simple;
	bh=KW8CvhQhJ1zrrKmUR5pywi3tJFWGDrn/LdERECmFyPY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I5uqlPwo5VumSfirvXQ87G8oSEbOP3klvfSADijthfJx8ETQk053BmWPBQ6nBF42G5f3nrC6zTTspM+Dx+BJkL0sq0nutL3whEOL86S5OhyDXsdqtnEar1S6W13fJX54tKGEK0nBGlZgl+U84fKnH8VyZcmoKLCbOrbDVzSFit4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=lEyA8WNU; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="lEyA8WNU"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vx2i422563;
	Wed, 22 Jul 2026 22:06:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	8RBmwOK6utyZcPJ1llZgyOfxNdqEsC4BSbQTkY/kRo=; b=lEyA8WNUT/D+cySYt
	tY27a6P8Ee920jIeUWaacfmj2jJWTyQvGbqFg4mcLwW7i/Cb9FOWT8mv9FRyY9/m
	vKnuj+oR8a5ls/4YUT5noU3QgcphLhW7ByMiwjO+CL/vfpib2bwiOjUD5rBwsrEm
	dLEQBhBychhxx7zKXnMDjKzu0EVBpEHFnmTbQYToHjHCLllNq6aKonBv01E1QFgh
	3p5r+SDtfT6+I1lLlW5ZlNqi1RYmy2Tym70wqFK3gwE0Ikhob5+hbj6PQq3L5u4S
	Zvq8OcGZPZvIzOONsTQWgiwkJ9Gl6OS6FxD158pLWHbJvReSuc+kkGX6oN8T/RrD
	txgJQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8g4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:35 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:34 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 19A265C68E6;
	Wed, 22 Jul 2026 22:06:30 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 43/56] scsi: qla2xxx: Use 64-bit FPM word counters for 29xx host stats
Date: Thu, 23 Jul 2026 10:34:00 +0530
Message-ID: <20260723050413.3897522-44-njavali@marvell.com>
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
X-Proofpoint-GUID: yAkI0AiemIhYTvcJNlTmd03GLB5VnoyF
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX7BwEoaJlu3Hl
 odCjLyqdtPot78VANH0fpUSujyt2hDq1dMMRsCw4ZaysnbPIeZfq++FxzF2+NE5Xu6x7bR84hC9
 Rpx5ox+QDvudgxwrJOgZuvxqw4eDMpg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXyYeTnVDVM3/C
 ACEroyyVBTkgCkClYcwc0dDrK16WT+BrqtGUol3w+2/qfzLxTueIEuEtuzFuHQOXU3oaQXCbrSt
 io45wkUzXxJKr3+5Ky04cj7xhBVZnOZQjujUDXw9v4vbPm9lx99be0IAdpNdM2rHpLKGEq46zHU
 pSkxJneUa+dHcIxUgZyaPHsorQQeQPU5rnQ29tAqyZI0jeSyJCZiGQaMY+oQzUXftEEmGQ8aD/W
 VBsLCWGrBxmQN2X17iuaIpDE9wx+2p7ZCMLI4EEzMQwzy96I2r7lW9GWjhNTag5pYQh71G3trvj
 VuDycf7HX1HOcVsNAsgKHKSqT2bFNObQwfpjTOHdEe+/YL6cZnIJCXue7KdFfRjCZ1JTSJxsshy
 gBDnldxSCJGpd0jnMkfS2G5w6q9z9zUK7c4p231Xq99YD8jheQOz4emDDXuOpnnca08vw+nk/2M
 eqTf3CCZwdZmzLwvffg==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a15b cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=iV06YDqDG_NXW1ljYX4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: yAkI0AiemIhYTvcJNlTmd03GLB5VnoyF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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

