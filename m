Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8A63F1AC0
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022902; cv=none; b=c/aXKshFl15zsbetADncLM2D1o/1goc7LxgJ78xHoeQExMePzEGEKeNnM2axeC+zWyJ2tmvyIAslWPVGk3xeoFWNUxrEvCxf3wJQWuRTkQggY5ZdFQCH0AltZMQXN2b4a+Ky6/g/gw5rNzTv9HdF6pixaqr6XSIFwKfNzPfsX6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022902; c=relaxed/simple;
	bh=O5knRtT+d97oCfAoqril+LE95roCfgFhwer7GA3+d2k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dErR5ZmFwwLGAp+mV0y3fsLIrTds41vXXLJCfdwVvtQrXjCPongEjEmVxNEHKu3LQ//tHW5+NB6KVjm+fOYRDS3CVTGBzqXKNThyipYVafZYrbWbm3rGPIR3I0qyWU+80wX5C9PghDC6ttga14ugCKhTF1YUre2NHWFuLgC17sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=aNGXhAI5; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="aNGXhAI5"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UZSg2408260;
	Tue, 14 Jul 2026 02:54:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	2A8NhhoajjTOzRyvwUE8lXT41UBpCY22R46x4J7zlI=; b=aNGXhAI5EerzxjY8z
	ksHJOKXfkaEs5OIvBFcuFG65vRd2QABG8BPCMOgpAzd8zFwMDfMjoTjmUAXriTRT
	fg9IInTPl4LNdlXQFRuAgxDd0UyDPaeA53ytsLcs0B7T+Jniihz1VF9jVRHCggir
	LlaYMSNN5sak9kuOvK4S8p0+HEEs426hx+bU+ta30E3COPbS2pZlZ4kkVBw71+If
	f/FMMMpY3rlL+dP2NjoHjnP4qcFTFUKdrbMpDbcWb7QfqK8gcO0QLLQF+nEjmSAI
	X7J8RrJbq7/CQyHcLkRf3JUQ2iUAfxMwhdtKQvbTk+V22TPr+IjPkVueKXnfHKHs
	00Nzg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9npw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:54:58 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:54:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:54:57 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 5CA475E6867;
	Tue, 14 Jul 2026 02:54:55 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 17/56] scsi: qla2xxx: Enable init_firmware mailbox for 29xx
Date: Tue, 14 Jul 2026 15:23:14 +0530
Message-ID: <20260714095353.289460-18-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: Eyut5y4p2pdfRk8Yczm8bB0Vmwgz29n_
X-Proofpoint-GUID: Eyut5y4p2pdfRk8Yczm8bB0Vmwgz29n_
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX4NvcdhCjyAZn
 FPaLih5DCngUVhNFx8gASYmpyR8BC/PLxLwJQoXb+w99ujZaaG0uC6gOxHA8HIdn18AM4n8laSn
 HP3GwqQSWNiJ2yI4rXwEjeySIQlWPiQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX/DljZAgZJUjo
 sY0C2VnvX0mlZ26Ma+SyizGXSwlM85A8mZYFu11Nvt4pMqD9nN1O65uz8Y3kN4HQAUMO/dZY4I0
 1ALZaXR0i24p0xgeKRQaqiJToHJwcTMIDM4UhB4vztZix4v1xBj5zTMjqX4cvyGm1Vo3IsOTCYn
 6c2+easfhIi0VnKXQT8zM0PfHe7TTrlYURyIPlsOsUij9PzrJiat8iuwVtna/3be0kqJRkoUway
 puvcTEadSNh9FvA+h3oAXKN5NSxdwaCgxu4dQsrbMcMxepGtvRqsPwJY7xBkqPu7nNUT5XUDYgx
 Q5zaI78jYejo2Tb83MzS4fhW8qFyTsmy2lYkUIlVDjvvlnK3f2rZIMrxAqRi66v454Q1B4we2wA
 f1WJi3VleGLQNzSZjZYJPf/+YYokYSmboUw8wrASx3dtQCc+F9d08ngYqmPVtOdPVTdOdftfGUY
 d1Us9cWI8uj8Zz5Zbow==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a560772 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=D95N2Pj2omZygidu6DcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

The init_firmware mailbox command needs 29xx adapter support for reading
back SFP information via mb3 and for validating SFP status on successful
firmware initialization. Add IS_QLA29XX() checks alongside the existing
27xx/28xx checks.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3fc08120fdf1..9c78aa66e12b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1968,7 +1968,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 
 	/* 1 and 2 should normally be captured. */
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		/* mb3 is additional info about the installed SFP. */
 		mcp->in_mb  |= MBX_3;
 	mcp->buf_size = size;
@@ -1992,7 +1992,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 			    0x0104d, ha->ex_init_cb, sizeof(*ha->ex_init_cb));
 		}
 	} else {
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[2] == 6 || mcp->mb[3] == 2)
 				ql_dbg(ql_dbg_mbx, vha, 0x119d,
 				    "Invalid SFP/Validation Failed\n");
-- 
2.47.3

