Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A0B385D8B
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403848; cv=none; b=HG+fLfZZYlRvAqUUvWPX1zwquIVsjuG5c1mll/3t9PYywAhksnXEAGq6byU83M6KUb3G1OlK93nxvdUYciBBXC77EOK46Zj4026Dwom86QzNb4qSk/LOQl4nN97JreSYvhAp0vl9Nwwyu8ifyvTFmRONeGq68OQjMF4UWXqZm/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403848; c=relaxed/simple;
	bh=1JGkPanv0nZvGUzSBZRdho4T5+VnfDpluLGpPvjdPI4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JqbtA24Rf9rgQD+t81t+c2Gk7GcgPrp8Ng9v8B/lXNf/IVSJaZW0kampbIxeP18d5shKiIyxDFFXMniqjwZS2oMzIkgvtPS9sAAtXIE6WElyCxMYwpas7OHLqzK1OsjuSj52J9yAy4/qYgak/Hu5lZH7XrBMvo1JWuTN53Jsml0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SKvBMc4T; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SKvBMc4T"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748bZe1656071;
	Mon, 6 Jul 2026 22:57:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=c
	1+/DMWvJSBGxBqfj98Deil5FGXFLRJNlV+ymLVo8po=; b=SKvBMc4T9yghssofm
	NK8CG7v4ipGBFYR7LLQv1ecEHLGl/WmI5IL7otO6Zw1+y801OMyYnwdn9I2c4JPO
	61BOJDE/ewdG6X8A+hAETJ2ks3NHI6/gb+HOv9VMyWcBUtxX3Phzik+lmVfcsS/y
	r39KuQGlKuU+kJfD5Eipblj+0JHm7vRTCspvUZ7FImG8yATMti8FKI+toLkXgpcJ
	i5d1x9Ak6iBNRQHqdfaIrAaaRlS6xFTo9wMxsqg8zJ+rsKcuaklz3zcCe5RP8E41
	YKhjxC3GhWygql/Gxmw901+Lyy2Efs5eJGLk+Dimr8nDG82+H9kd1mK9aHntLFhT
	cK2XQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqdyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:23 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:22 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9DB083F7066;
	Mon,  6 Jul 2026 22:57:20 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 49/88] scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()
Date: Tue, 7 Jul 2026 11:23:56 +0530
Message-ID: <20260707055435.2680300-50-njavali@marvell.com>
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
X-Proofpoint-GUID: Y7zb-Agsqd--x55fivoZyRsyf7uE15Do
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c9543 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=45oI07BRoqxegsLmdCIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Y7zb-Agsqd--x55fivoZyRsyf7uE15Do
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX1d0JwFmrDXkH
 /wI9Na3NXDw1ecWZ/mR4DuWwO0zFQMyOKcH4OshgjRvAUyxn2JtsdrhYp/W8jpYiqBPPahI8QZX
 oJvaXPJLGr8O6eIzrp3A6B0GmdG65gU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX3PSmejplSL26
 fQzRta1AWmf/dR6u3jXYPJoLQYW51V6EPxv4eGcRTxUVOJW0pDJZOOBqodiH3azgpU0ZYWH7eJS
 jAph+fBj4Tw5ONFenBxQ09L8yfHHESNHwBSt88eSYKEoeJXsI9NTupxCDnG7ZV/ZKEmwdBaa2Ee
 ZRWyg0EiNJ6DkVPLzsXNitXli94Wnyr+aPREU41TZMYd0CiqiegeFuInVkSmfTLuFOi4hSo5w1t
 Rqku3s+5WmalKqHFAMNmg4l45qQTUC4OOeqCPnQcwLYkrTXbha/GFOL/suszqUmVV2fYhTUrlM8
 gZq6mYTXUatYv41a6FapIYmOpAurITSNFfP9u2OfpVQjA/dVBlBab/jt/zh+bpnZT9Uo4RQbf5F
 uCQS14pDF+GgiCPGG/EIc9weAxf+ZOhBYQE2pfQrOo2gNwTLi7nCFyZtcCdpk6theR5xfvsN5PS
 ayhbAg9x2BwAw8hpqEg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The Modify VP Config completion handler labelled its first error branch
"error status" but tested vpmod->comp_status instead of
vpmod->entry_status. Because CS_COMPLETE is 0, the following
"comp_status != CS_COMPLETE" branch duplicated that test and was dead
code, and entry_status was never examined at all.

When firmware rejects the IOCB early it sets entry_status while leaving
comp_status zero. As the IOCB is allocated with dma_pool_zalloc(), both
comp_status branches evaluate false and the handler falls through to the
success path, calling fc_vport_set_state(FC_VPORT_INITIALIZING) for a
configuration the firmware never accepted. This can leave the virtual
port enabled on top of an invalid config and surface later as login
timeouts or follow-on firmware errors.

Test entry_status in the first branch, matching qla_ctrlvp_completed()
and the login/logout/abort/reset IOCB handlers; the comp_status branch
then becomes the live completion-status check.

Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b32ca8ed274d..59023492c5a9 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4401,10 +4401,10 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10bd,
 		    "Failed to issue VP config IOCB (%x).\n", rval);
-	} else if (vpmod->comp_status != 0) {
+	} else if (vpmod->entry_status != 0) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10be,
 		    "Failed to complete IOCB -- error status (%x).\n",
-		    vpmod->comp_status);
+		    vpmod->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (vpmod->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10bf,
-- 
2.47.3

