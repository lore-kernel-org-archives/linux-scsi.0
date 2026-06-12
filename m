Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09AA3624B7
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258212; cv=none; b=FsXMw58vM9j82sYjUEnV4PxnJ8pWbbOYUueCdd5BkRpUczVmzDMkyWXleaVfDWH7GjWaQVpeWlf5EdiaI429rLgL+7Tbn2Rnzh4y0JAu7DE3PxLziyBmflZ1hFXUIMg5OzaBpPmoS2QQaGvWEtBOnY44kxsoUT6Hm6ES89EZuOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258212; c=relaxed/simple;
	bh=0fMVZChatSiMjoOEeEGOciT2xN5dXwAKaQmsNp9TAEU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CcFkr1ksFhIeyacJy93EdwbUD0U0MA+EK9o3EPgn9L1Hmn+oa7ODN0GXfNxLQFZ1bzfaK1ao7JaNc9c49wfxE2kl1E6+w4RtTZY+7dy4/FznYImWo1xqrtuqOLgyd4hBpy+Z47/eAYeNaORtyr3PCLta7nFwaCYGiv/LUvaJuqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=eZhZEBA9; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="eZhZEBA9"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3AtnP071606;
	Fri, 12 Jun 2026 02:56:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	j8kDL+ktkIZdvhCE4SXXiBvPJJscsF8/4hA+JpfL8Q=; b=eZhZEBA9g+skL/pt5
	NzIhfac+BdYOy8mCynPZ2s4UFsn8b8D4UEYkNaExzAAn+GHL41t19S9OwOoYxZ40
	sSwTG9FCxdA1p8Mz7A7kV6dY4I8mpBQxjELOemjYmaZ254GpGTOD7/SehPYARm6D
	e0Imo0jUlHZm6xGpf9nlOjTDwEvU6QPjZFOybqDRWH+RfSqte/vvx1+BglJxWOHB
	MCl7P/73MQmAOtUrLOBtCs4AmRR1/zu4XVeQnARCldZzYNmlPs9aLDtPlqPLwkya
	9aWP31AD/pFMGi6zJFPzrN8jTgDRrlbOvYP9mTL40AHJHzBzDdLs+23oJla9tsl7
	FNRAA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:47 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:46 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 085B93F704D;
	Fri, 12 Jun 2026 02:56:43 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 54/60] scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()
Date: Fri, 12 Jun 2026 15:23:27 +0530
Message-ID: <20260612095333.1666592-55-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXxZbNSsGSjPm4
 0j1z7vevT5GfMGKv4HP48anoDPDMwH8RcfLfU/ep/Mj6JuCE9sxdJe/+1k6k9NCSWwrhjl5lFmW
 7pG7VTmUnADtJL0HeaFAIvrZWN6gHzg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX8yC8vxrC3w0W
 XC8trC5x5bpr6HCO1jiH8Xzj9T+2r3RfhyDd2gN6+y6x5NhaysN1279cRRldXNxSD0LZSypkFYd
 4uUVCXF98jsEDKtJ0KWj9lWzeaFYxft77TpW3O32ty6KilBn0G36SK58LNp53NefH7tokPCq5pg
 tyVO3vghXTKkxgGcwlb25ZQ585/0V65Pvr5/4s3jzVNG1x/N9H4ZefVbMTcLYs4WNqHxYmpZ9XR
 zbyw4SOkY8WCMcsiWMsOR8r8Dz9B2ol2HJfipAN/Wy1RKQ6R/v0Cp8vzBR82KDgbSIpUS9eh73G
 FbJsR4pLj1ow1l/HNynzE1PzfzclH9u5dxH5iesHP+OV6Kw6WiqUsPFPn6mW/5imF2ootb2jsMr
 9W6tEi0KgI3i6r5GABb4DXf+qe3G8xUiIH2ZvHgOG+KLY4v56EdRH7kJF9qH+wQdYUcczomFoxT
 20v4emh/jfNZCcagitA==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd7df cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=45oI07BRoqxegsLmdCIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: y3bdsno5QYMYf7rL38DAJBvNrG6o9dzq
X-Proofpoint-GUID: y3bdsno5QYMYf7rL38DAJBvNrG6o9dzq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d661662aed26..8a001b489fc0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4409,10 +4409,10 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
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

