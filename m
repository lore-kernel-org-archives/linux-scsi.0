Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B45339844
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258110; cv=none; b=XxZA3UDuCAFlaiJadDfCl5ZOHRClKR5MT/jINu1bIem4VVh+SVgri8qgcSjYNt0w+DMH1jow0lCB/5vL0pac6I+oIqlkc3nFbpNy1Pt20z0f/nzsPrlU/0PsIywuB8Y8Z/R9EhohguBpQj0ythGNkj7FpmUoUwYAbzdgFqzRlmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258110; c=relaxed/simple;
	bh=GVhAUGVgoBRAonsGHfMEqa1xzpMmPjhHaw8Sdwa02SU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdSdMeShmAkAAs1pEFw0Wezv4XcZiO8Shftwil/B11goDtGUdbcNK1T7oD15CeY/rzgcY8X/ALg9pGQ2MWVOK+YmdcQ5iqMsgDnmsLl3TIRRZpAI90eBSbOgWdxiwGZ4svw5dqbV3WsvzdkQAheTK2vITdVwnS9jt3D6CSQO8IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=CRi8iOgX; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CRi8iOgX"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39qBs3679423;
	Fri, 12 Jun 2026 02:55:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=a
	hgKumHWOggwXUNGSp+ekoUbLuLLL7Gl52bQc3s4UvA=; b=CRi8iOgX3WIKGRo0i
	TaXDktr0OxMEFvamvGWk4HhDv7SEy5XCFOaAAL/fr0YERvC3ffx/7AktdzsTfNzR
	eSwr2obfOkEyKltGoEH+ua4N1rEfEXgnG/0LDPLOs0iIt5j9HNrpi2gozFStEexi
	/PJQ3qMKflEgodbdDcrCd/mh0ZeE03ALbW8DXII4SHA+SxwUueWlBSQ1rG+idm/l
	/rPJQV6Dv1wriNx9FylHbyNc0oCAqoarWgGb2SBUA7lHUtmh3Q8kXiz/SyFW6Jdw
	ciHTR71pgyq5bHaTfRmREoU+Cb5EU7/qipSt75LFljM0sIwAh36mF0b1sGH/cFsh
	Zevhg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:05 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:03 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B41A23F704D;
	Fri, 12 Jun 2026 02:55:01 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 22/60] scsi: qla2xxx: Enable set_els_cmds and echo_test for 29xx
Date: Fri, 12 Jun 2026 15:22:55 +0530
Message-ID: <20260612095333.1666592-23-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: TbNpdMoW2XJ8-nfH3ojjzhilqJeNHObG
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd779 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=UohhYlrJZoq7yYDAghQA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX7W75C2hk6DdO
 maETAv44ghZsXSqq28Bwgm5uwfCvf5JpXPZJsn7Kvol75Wy0jvxaGziyIt2HL9JqKyLRCFfV0ot
 Ehp9GR4aisIDHqVNl5tv6dUtNukWBpw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX1UDBG6tRixiz
 MiIlgh7XLnbJIeWaoO6/HcaL+2e3GApaIBmif8vmZ5m6+v6BrYPU6rX1BeM7WwfRWijiBYbOMwb
 h9JrxmPvK+PYoZyDdNMMKNf7G4sXC+agH2QNeOTMs/j63dE90u0r58tvtkLLB5pC+38BCPosd7d
 Y7JwIX1rAdbyGjR+hwb03stx79JN/UhNK8EByRoibErfJxAhFTKeU96ikZlht9GM/eDrgY26Ybk
 V5+f3mK8EDrG6e10iTgdSorfsoaWWHIRQFl2AXN4560raQWfsTQm7r8BBSCBaUXstJ98hR5KGxb
 AgafutLzYs+i26Jw16JjITbO2gGZoWE5btsK76PLfiFK0OBjY/UonwQ6oA3fAFQd0iCiw+A54Xz
 mRfXiHkvf62bHC/Ikq1I08ksxbXepB8W0hQJwloppgXuJAoaUfMBq7jouSscUpVn0zb0GLPM20s
 iX1hEwXdAFg1hmNMQ9g==
X-Proofpoint-GUID: TbNpdMoW2XJ8-nfH3ojjzhilqJeNHObG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Add IS_QLA29XX() checks to qla25xx_set_els_cmds_supported() and
qla2x00_echo_test() so that ELS command support and echo test
diagnostics are available on 29xx series adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d195723fc06b..a8dd01cb9a9a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5087,7 +5087,8 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA25XX(ha) && !IS_QLA2031(ha) &&
-	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) &&
+	    !IS_QLA29XX(ha))
 		return QLA_SUCCESS;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1197,
@@ -5492,10 +5493,10 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 
 	mcp->in_mb = MBX_0;
 	if (IS_CNA_CAPABLE(ha) || IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
-	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_1;
 	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha))
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_3;
 
 	mcp->tov = MBX_TOV_SECONDS;
-- 
2.47.3

