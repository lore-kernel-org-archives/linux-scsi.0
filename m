Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6031DF748
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258198; cv=none; b=AvUxJIGbgA1w0DAvmWTKJBNLisvDq5v59HPh6/2kBwraFzM3tRwzsaGbXMoKpscs3c6GmsOhYcbu3kWh2cxFQg3o1VfC52C7vU++rqO/IsZ4KqtqEAp4w092ybraY/fE9aXzLLST++qxOlY97mVrCta5Dfc5qtgQ0Nf65LU72FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258198; c=relaxed/simple;
	bh=ZN3BkPG0KCe77iBlNuM/1KZdZU4MwITritVZojnJBDA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o5CAdhkdard8A+CxLbMvxjvoi0dTomuN1rneHAW2cglZSrKMX15wRsH7/s7fOsPyowObhzP1KXZ+AkcpQBhBm4w/+jHuQYFf8IYCafSZYi6+ByKR4p3mxxsRUV67vw2mBoj4bI3lLW7ayHbuwtAvxKZCWmHguLYbz9++bLUXog8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=JTUqiqjz; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JTUqiqjz"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39qZI038076;
	Fri, 12 Jun 2026 02:56:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=0
	KhMUpDtPnBiFZmOMzmNflDzwZGmrbvJ8zIFEWHX6dA=; b=JTUqiqjz83X12PicK
	6DMSHAGM4IuWZ+/xlB3GOVPvCyDhsbI2zWN/CyeMXzTFM8xAzvIyGAags9CJeGfX
	jfYW9iBLwsSCXBFTsjKUW8I4Lq9sudNVuB+TC8i7yK81OO2EsOS6QzADelMXAZQg
	MC6i6f/Rj0OS6rQXRSEYwIyyKS7x3HniyYlvD52KItnLqFPe4L7g+VhwLppgtKM7
	f17TZJWWsTuQ+IEMVBT16MCaG2M8cAM5WTfTx1afnacvCAMcbeminNcK55DbrOic
	koFfowtwQpWW9N/fsLlL0/kmZeIJSwLXJ3wb6PsILGmbgeWH0gFBYVfTuLNmujxo
	KGQtQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5r6rxa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:34 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:33 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0C4E63F7040;
	Fri, 12 Jun 2026 02:56:30 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 50/60] scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate
Date: Fri, 12 Jun 2026 15:23:23 +0530
Message-ID: <20260612095333.1666592-51-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXxF6G9NSEoNDG
 AgoNSBqIl1GkJD7YUBkrzgtyIhNYsjl9Q+KoM6uFb9IhPjIWE49naFP6FayoQXdFl0rjEu3xvti
 D8mA8wX+P6qaMTcZ9d8SYWdNBGi3U48=
X-Authority-Analysis: v=2.4 cv=O6gJeh9W c=1 sm=1 tr=0 ts=6a2bd7d2 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=utjVkuT23_eo-L5YqD0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: _9zO33VJSJMWVjTkuWQy-qnyGWHPqZXC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX3ox5g/Gk5CKG
 MBG4IDUwyRGD9ItkvuwBl+MITQC2RJrluwyE8s/wrH0tVTuboyFyIrngtxLyDPlwDf/FjiweJf1
 0NKpmuRwooBf3C5sjyUdQ0PJF9GMdPeFX/McmhPZ2aneEV7XMcHtigS5rF7psvq9BrJSqVVZfi4
 6Vvd8cs2+KWpJYlgY9GejLzAF/s6rp2lRom7ExxQY9Ob6yPRufDJoXmBI8dj4PvXoQF5hbE5zsh
 o2oAN+tpB3Bhm3NtP+Omo2bvPYYGj2OAo9gx8UGeLY311r3l3TDy2XlAJ95UK+ZZxQwtM6VECaX
 9JbGNkTf0RhE25KhigYxGuNv/sIFv3dAVMUieSnAjcy9yaZFKFaxxGwthr+YmRqe35qcyFKNz6m
 sIrhN1bEFUrV3MAtTthWBMZ12FnLZcf7qBcpluZGALDe+suTvz1TRk2bOJI8W2JiBtbaT0hJ3vX
 TvTrXuVbFtEV1ol0N2A==
X-Proofpoint-ORIG-GUID: _9zO33VJSJMWVjTkuWQy-qnyGWHPqZXC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

qla2x00_get_data_rate() skips updating ha->link_data_rate when the
firmware returns mcp->mb[1] == 0x7.  That value was a legacy sentinel
from before 64G hardware existed, but PORT_SPEED_64GB is now defined as
0x07 and ha->link_data_rate is decoded with the PORT_SPEED_* encoding.
On a 64G-capable adapter a genuine 64G link is therefore dropped, and
the port speed is misreported (port_speed sysfs, fc_host speed, FDMI).

Only 28xx and 29xx support 64G, so accept 0x07 on those adapters while
keeping the legacy filter for older ones.  Also drop the duplicate
copy of the check at the end of the success branch; it repeated the
first assignment with no intervening change.

Fixes: ecc89f25e225 ("scsi: qla2xxx: Add Device ID for ISP28XX")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 5a5d33e8ee7f..d661662aed26 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5793,10 +5793,11 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_mbx, vha, 0x1107,
 		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		if (mcp->mb[1] != 0x7)
+		if (mcp->mb[1] != 0x7 || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 			ha->link_data_rate = mcp->mb[1];
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			if (mcp->mb[4] & BIT_0)
 				ql_log(ql_log_info, vha, 0x11a2,
 				    "FEC=enabled (data rate).\n");
@@ -5804,8 +5805,6 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1108,
 		    "Done %s.\n", __func__);
-		if (mcp->mb[1] != 0x7)
-			ha->link_data_rate = mcp->mb[1];
 	}
 
 	return rval;
-- 
2.47.3

