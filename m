Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E0D3FF1B9
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022998; cv=none; b=hqOnP0ULG1ey0X3N9KCaQWLTkXml8ZTVksEa8WDWd81lmiJ+0LwsTSxP0fmeGi5MrGOFKDdwikBHcR2jRNT7Chj2vtVHtQlPNrg5S/ilEg1eHgVvwU+ze2SUtaa5zPkq/EBqAIXqIAdd5b77ZW/04ZkWvH374lMdjuc8vxI9LC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022998; c=relaxed/simple;
	bh=1JGkPanv0nZvGUzSBZRdho4T5+VnfDpluLGpPvjdPI4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJPxLjv1BPHf/2qVi7pH1jJPsLWc0iivhQbgoLb47UTCgFmNCPOelIrkimpNXX6tPEw3lCKwXOvcImkrp588LcxwcKDINHwoftYlUq7GoTWSDke4MJ8rqG11KvnzAIl2gOQsBPgODvjdFJKPYdJX9q968/Ungix30gFQUdljzwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=BfOK2g5A; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BfOK2g5A"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UDUh2407822;
	Tue, 14 Jul 2026 02:56:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=c
	1+/DMWvJSBGxBqfj98Deil5FGXFLRJNlV+ymLVo8po=; b=BfOK2g5AyGP+lFewK
	B5LVccuGvCRLP+/iw7AnAPMAwCeAbme2mdGMaO55flP3YuxXA1u4IEDGmlS8KRDx
	uDXlw5CjXdH8LxYs+e57+LsoB8t+0d3bqOyaLrcLrTuEU/zzYR7k6jve9BXNd+Vg
	shYtsmjYpHV9LEyF+a/U+4izQHPRrvzIX+AxNKA53FddTQ5bCHREnsoUtikOoJD2
	AlLW3i0Rw4f5Anm8NegV/DLPljXIlXNB+N97xnPlBYqAJt97HHxSaxTJyqTDn6yH
	XcasuoMjHRJU0Vo0k1ALM7sJkWMiEtwCcXeiAUHXO91qJtmMkHal+JFzJPPdMZTk
	azhow==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9nq93-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:34 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:34 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A4A3D5E6868;
	Tue, 14 Jul 2026 02:56:31 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 49/56] scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()
Date: Tue, 14 Jul 2026 15:23:46 +0530
Message-ID: <20260714095353.289460-50-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: GobwWsTOm2PmmgonJAsppmHF-P84xXwD
X-Proofpoint-GUID: GobwWsTOm2PmmgonJAsppmHF-P84xXwD
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX9eTNZ4I9bni0
 FUAXt/WeeT/lMWrD3ZFVzOIYnMQI5ElCr7DSOkJrRDXafxcGf/DtvygxqQ0BWGr/NbQ2qEZlMJa
 KNMoXH/3No8vUd4RjJ/q5lz/zoo4YDA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX1LlIYBBQo/oO
 Oe1tUz6d6VEV0D/J5o7LdIB1IzMqEb1/O4U6UBb6Tzyi8QZKHj+x28+OlXKPBmj7dWMk/bzJeKQ
 jkSJi/hBNLae9HNJugmVkTHhxZcWLUl/5GpkqLN2pHu12tI5l32eZ5WZ/HOMEBUNItno2zW/ETY
 KE6J0JUFCZ1fpafnjpn3iNFwBZHUDu5RpExO3QBmimZslCQylzrLRTcUoZ+t4nUAWOIWhHHPJGe
 ANRBw9ua1BCXez4s78tBVRfChGDi/e833dxwnpfya8y0nPOTOJOrXHl59GPHjx/7ck5lr4I5Ypq
 PwqAo/0Kzb7D3qpojKnSHbiYicS82eFtNpjtGBsWqj5P36Hf9SmzkwC0s2VrdG995zF1DdguSJg
 PaFE4KbrKY5H6F5qWepY8+cXm4Mcyxsuijl4umGDcb9LRpodwUl8S9uNs52Q/gy5wrnB3t1o7AV
 /Ve3UvEzZi20RVMKz9A==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a5607d2 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=45oI07BRoqxegsLmdCIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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

