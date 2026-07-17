Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D8313AA2D
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302220; cv=none; b=D6q2NkgRe9FCtq6xtKj+0GbpIjVKr64PRZQFUeSHZf04ab0nvCh3H14g7rsUu4ywPLdIMFsO0+fDac6/tK+8hgzo1jcurHSa+cJ4hpf9HYR6z0+18yWjLxN+NO0jx5WH62nfO4spizkUQZGYp6pbb0GyGvaOuVCgtdfQs0bHlrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302220; c=relaxed/simple;
	bh=XBweKRoe2iV+j+QDP57gNIPWkFSpzqNvh5kItWbGoY8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BgzEnh7bZY1rXSJAYqQ+DvPTIaLJS2MX9XRd2/Jcc/oQXMb2O2KJRn0KDJtBURB8O1sf7GJU9KVbYh9aUuyAZEt5iLHwDo6wZR0hJFdHZejoUPZFrZ22D7jW2zf1YWeH+7uVweJlm1dpdYX4J4enyPJ1x4KYJcoOYmZzTSp6CyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jfEU9Ij4; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jfEU9Ij4"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE6ItB113875;
	Fri, 17 Jul 2026 08:30:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=T
	G9Rjbv/gWTuYO3pC+FOHAYqPLzfSVkpZiKVpas+3tk=; b=jfEU9Ij4M3Dx3F3er
	pprkmzKdsLT+F107UTA1SVHQhxscsJyLE9FzdjdFY+1c++t7/Riv/RLvzs2ddYn6
	uttcD+cf6HX0Pw5lmPr8UVqYrSg+FbQHtXonRMC6OVAjlyt3Zk11OoSp64sW/ivp
	/lV3Pl5fkrnb8QYSweXi0A0WS5O1zgJfQ68/XkHT/vwt6M+4PaeIQXqgnSR/nQPB
	TSCZw3dX3vbryK6ALTON1uXg4HErzRT7eziL+tZ60KBNlsYlnm3S1rSFtiHi8Dj+
	60jMz7JHyyK1VRha4EgMD7P7XYeUa/mTF6hQeZ9RlQxtRXxwPLYUsGRrknMQOIaO
	mEp9w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fetcbn15y-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:14 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:13 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 5FD995B6940;
	Fri, 17 Jul 2026 08:30:11 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 22/56] scsi: qla2xxx: Enable qla2x00_shutdown for 29xx
Date: Fri, 17 Jul 2026 20:58:30 +0530
Message-ID: <20260717152904.3155730-23-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: stn658QKgeNRDH51s5Tb_IY0xk1DCQdV
X-Authority-Analysis: v=2.4 cv=Y7jIdBeN c=1 sm=1 tr=0 ts=6a5a4a86 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=C3ITPKR1BmyQqgtea3sA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX3gE4KodmL5Lb
 uC9eqUFluNja93XKMH/brijIf8ZzRGBqRzxZMn7uggppVZxJyUv1+Ds3Q7tbwHZuBkKjftnk+9y
 IzX4dR0LDPZq8hCV17Ohg9yDG6IzIMk=
X-Proofpoint-GUID: stn658QKgeNRDH51s5Tb_IY0xk1DCQdV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX4p0BLHhM1Y40
 W8UIryZIf593gi/ZEDObHovNoXzDpluQTlbNCZHH5ZqzSk8nU1kJHjvzfPtpp3RFm2rqa2NUZ8V
 jUZ34bjOWpchIb/w+zkIZVM0ZrCFLRA8fRGDOJRv60IQoeeLCOTXuJaj1EzN978NflS9miCnoBh
 Ve4q9+eZF0gvX9aAr0GwK18VUYoYPqm+hBzrn5OjyfB9qz9LEbB7JWFxM7T++2TK5nWmeIROLsO
 wclm83fi6znzBTJLpV3QipP3mkXr5W750BjXIxyHeolHmnfkiKoY3nAdooFIjgiACVXJTpQpTlj
 l/ZB10lp3U7rbibDrxlkNG44b/dAebt7MmAyy0keGpNVKIBTkrbBM19yXafW+gUvomZ2S4H0GpH
 PLOhalZRlpve5yQMHoXAxPSeZd6P4ypIZeRlGaGxKgRDOfZWa7hicgvjORErg0Xxv4w8uGjKCSt
 LN9uw57LQJtmPp40PJw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

Enable qla2x00_shutdown for 29xx adapter by adding IS_QLA29XX check
to the shutdown path that performs firmware abort cleanup.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 146701445485..5450c40259bf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3840,7 +3840,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
 		qla2x00_disable_eft_trace(vha);
 
 	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		if (ha->flags.fw_started)
 			qla2x00_abort_isp_cleanup(vha);
 	} else {
-- 
2.47.3

