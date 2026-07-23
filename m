Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F9330DECC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783221; cv=none; b=aLgWuFEoqPSXmCEiDwv6jRZkfXBChWIplP2+X86h+ErhKnXv64Sa1aE9pGJqHhRmaYGBK9aXUzRlaEdD6vYXJFqpQhOBgH8DPgpQAJmV2oLbsFuqfIVxbgwlRh4mNBBw6CIG2J5tfTN5qu3rsMuxdof1/IKJXcQLUtO2se5s0sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783221; c=relaxed/simple;
	bh=1JGkPanv0nZvGUzSBZRdho4T5+VnfDpluLGpPvjdPI4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=acFEQfvsVVFqqtObaAZJ2OHppJNUv0ccrz9I2CE7g1FiwhhawpENPqIysg3Z2cxo/mEuyLhv38oYeuEmfjHVa4RfLXGm2BfsTtqlDhkxLwry0OePIOrXh9xoFtsl/q2uWYBhRet1hEml6gHtj+Wa52i0IlgOAgvlLwrRNauzAW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=VPmPs5gV; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VPmPs5gV"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w0eT422573;
	Wed, 22 Jul 2026 22:06:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=c
	1+/DMWvJSBGxBqfj98Deil5FGXFLRJNlV+ymLVo8po=; b=VPmPs5gVASd8+WfC1
	l/zNA2XtUtRMLFUfMvoVrRo/N5DSNSFtccfBot3yI/V+mCbzuRsjQh5UoVfidII5
	UyHUwEV90bN4j38aObRPBcfb8ie3W+fFTsT5rpLbYyLD3de3OXGsGFIIKc85Ej4W
	KbbjS9upK/rYhOK0rfoID3TZil33ncng5JIRQuYjtRUviDP+OWKZH1I/soEScHfX
	LXaTKEcJE9kb9E7YHmE3H2NhyEIg05fzVLksx8tzb71f2qdVIg0ygjEIX94UiOeC
	r8x7ZAA1hAdBLCDN9Jkxh/4/5istZcp8tJZ8eUdV3qBXsfEwrK8bafHSH+adB/64
	H6laA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:52 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:51 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A782D5C68E6;
	Wed, 22 Jul 2026 22:06:48 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 49/56] scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()
Date: Thu, 23 Jul 2026 10:34:06 +0530
Message-ID: <20260723050413.3897522-50-njavali@marvell.com>
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
X-Proofpoint-GUID: x6ytPXP5NSpXIqfzYTwGw5DVpo26v3ML
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXwLpkX1goVLs4
 /v+J48vS8pe1sN5YXkmS6px5U8kHPWNj2620IpGBLtEWjkWQJopwEsPR2tyexB3v0ZnGSOBnz+u
 NY20UTLiBjqiPxAYQthm7/9Inwz86Mc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX52gVGl/laLYe
 UObWoPQaXRcnJm8ONur6d5ijKXEmteLbvYXSRx5mNlP7zEe8fbZHMuqVGMtt6SBPe1y90ejR9tm
 mHg40fLfGivMg0nvKwgSASyiD6Xmria8idTTuYD1RK0qsqJO9+4vzTBp3/CBtG2d/N7jQ0FsxHJ
 +cAb+cIsN25x3XG/Wka8x7vwKJ1mmj/CLrBneVcfrrUrhmu+rzzdT59rWoPIbzrt4kAgaeCtzpy
 k2xu8aaCWUfE3Sq3cXjZR90MLd9LZZ1Lulwy3GeYByKOmjzxcFVwiXysLNBnr/fioTiz6+fFmSf
 k3jqZMLxnYATVdOxxIEwHQxzsuajECurIZY985p+eY0GHJ4hpA4j4HB5pZZF4aJ4vSAGPuBzbLU
 LgaFh0pAbEe5AX5XClzuZf9swHpLqWWvvYWaBDRtHhHw+roWmBsDghPhR+rd7HGTRWpQYbgy90z
 2mT0+ddjNbb4pV6KL5g==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a16c cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=45oI07BRoqxegsLmdCIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: x6ytPXP5NSpXIqfzYTwGw5DVpo26v3ML
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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

