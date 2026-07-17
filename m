Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB69415278E
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302282; cv=none; b=SgX0MJsWVF48chPWT+A7wME06pG+JgEKmauBN0XxVBLKHszPck/A2itz5lV2CrWbavqaJAUUEV5qgh2BWGwU4G5Gu/eB3AE1biBABm3wIsxn6GO9egHam8W5XS2gWPIIU4Hm0BIZtrbbHiljT2L6pqZyi3uJKQoLd5hrlxe6rac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302282; c=relaxed/simple;
	bh=O4sQGQU4b6fdPzFyaZTPQlMCOUzyLU24c2nhRqRW8Wo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vBXS50Y1NfsFW27PMzuKy8SqNbEQnPaA4kLBcG2MiwAejltvHC17sjGNdokB1zePug6ybSkPklP29zDc7Gnfi/BIBT/D5TdS8Ob97+aVkZPohRdUbg34vO+y5HAEzMPz6xWeaoVdydTbzNoJlNC1vj3D8QUXpDCrTHRw4l1oY8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=hDN6GJNd; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hDN6GJNd"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5qmd113130;
	Fri, 17 Jul 2026 08:31:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=/
	6Cb0dgXoIC1ZIaQTn5yCtTjRGgeiWdgD+BYAFNDpYA=; b=hDN6GJNd+xMXtdyKy
	m3qcNe89j7/yQ/Do71UJEDbjiL0LJ5CLqIxbScqOYM7v8YPJsJ8qnHRouoggY6aC
	zhq9TP0j6DXRA72cQNsO5In+bobUAn10Tp+e9elarhQxDYajF2bKGp6hKZUDc4CU
	yGgYNgGOqLvzUFvzPoR+ea3nXTFpZ/72FjDpajVO5NjWNprl68SZTAct3dhinrsr
	53b1VjsljsIYY/kSUBCOSiHKGfWze9Pu4v7PhH3ZuvO1XdqGJi2dzsUK4liQKe5Z
	Kl8wgJ4UbEkOsnGV2zQW42tMhdkln7pHHu9Yvno2pSXkWdhcyjjVEW/cSaCICB5V
	+zgEA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fetcbn1af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:17 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:16 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 665C85B693D;
	Fri, 17 Jul 2026 08:31:14 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 45/56] scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate
Date: Fri, 17 Jul 2026 20:58:53 +0530
Message-ID: <20260717152904.3155730-46-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: IGKEArGudfQi2ubXz5t_0AyaYgTMjBVj
X-Authority-Analysis: v=2.4 cv=Y7jIdBeN c=1 sm=1 tr=0 ts=6a5a4ac5 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=utjVkuT23_eo-L5YqD0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXzJfNgx9OCNtK
 3yciVbDAgErcbMCzgz8LWwMcsp/n6rhhAZcVMsK/h3+ut4EazVpwJS4RVWgh7wdGvXKMlJEqHOK
 pPdQlc0tMLysEhFqSt/4cMgSAZpl6TY=
X-Proofpoint-GUID: IGKEArGudfQi2ubXz5t_0AyaYgTMjBVj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX4CJgsGADsFWK
 ciKibEz+dnZQsujF1j9BPBD3d83zg7IVWvi1n0Sd2Bt99uh/ZsN+e6oaqk+qi8K46qzOoEfC6e7
 QtBHUYCtQGDPh3w4WdVN+g4ETWnquGDF6J706oOlF6fIJjWfeZiHQeLQzBSXX2gGY4yWqVdxZHG
 Jq1J0HCgw9OVvNf2KsxPNftEokNj1CGBJhHSYhKmBfHZPuNoYU1E+0dziED+W1jL5EVFnZSIP8Z
 X3wkQaWSpReBwbjMd9fsAFmjMSeQMszbos8yuubyTCwogbX7JIhmuPO1bC5f+ZXa8PfXLf5T6PQ
 bslG6sMTuVNSWTdE9TDqat2hX3AOp1yOgjNzIJZQOn8KvYO6p3W3Tl4/BUjlOKdG5w5elyytivx
 tZSx9sN66Blb7CGnTsKVngm3xj/1Y2X+RGEG1dOrPYZjnGd94c5r2jHFBHYNOAClrjaqLh0oGn3
 9nVIyJMtxL3gG8krByw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ba822c196894..b32ca8ed274d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5785,10 +5785,11 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
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
@@ -5796,8 +5797,6 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1108,
 		    "Done %s.\n", __func__);
-		if (mcp->mb[1] != 0x7)
-			ha->link_data_rate = mcp->mb[1];
 	}
 
 	return rval;
-- 
2.47.3

