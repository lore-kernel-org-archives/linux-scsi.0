Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED77443A92
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427172; cv=none; b=n5Af6KUJT/ZggagZMvL4WnqNB7Zuv5ilfGpefIwfE2noEbwfkdk2vwcekbHZFK4KpojxCDbLtczHhrRdl3gDfVbt+nEBOjdls/4LdcPt73ZaGxfL3QrjKEBbcb8i2YWLnDLEYQRAW94L6Cqbr7Y0YxTbwK0vCXVg7laNwyinpHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427172; c=relaxed/simple;
	bh=oADJPVjfu1U4nYBtnSdiKxm/3Z8+IZrmIvgn8AymXRs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jR2fiKXLSY00q3nclg6rGqlJIfoIQLStzePUL9k+eWktFopolkAVcW95DfGjZIAPEAQvDFGwiwaVb7lBjjGgOxOFiVCP+6Ko2znXHDZGmO8WlrMUSgXsHHIE91lELbfzmlPZ4VLKPxoRJw/FY5+/qAtqmekAfQrRlZYYOymxU1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Q/TUIfsY; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Q/TUIfsY"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFX0Dm1322686;
	Thu, 30 Jul 2026 08:59:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=O
	H1/xec1fR0ntUL9amReb3cS3jQDgBUebTcGn1RImew=; b=Q/TUIfsYCHvp7jjBF
	0XVF6OSvhr4emitb/LtH/EeGwZQi4fhck6qXkydeRcQMDrIgjr32GLinRSUB0/hM
	EKW8RuxBBPNOQCQZVmsf18rlDkpv3F44vNq+I39qIWqZkMDJZh9h52bRKIq/Y4GC
	fmjS59roQCFAANqQbLaWk6jdFOlcPsSQh/OewSUO3jikNgSZhkyfaNWgYxQwRBb7
	30pW6PwM63Y1HlPr336EdBQlOc18EOs5AgobmoT48I0Rewsk8DUNelns/adaQloz
	ASgD9uZIQuJCzwjfbzz/Sq46vnazZM8yNGRtVTLSZFIDiHn0VpM4ERRWHGjGsctc
	3ktjQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:26 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:26 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 48DEC3F704A;
	Thu, 30 Jul 2026 08:59:24 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 08/33] scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
Date: Thu, 30 Jul 2026 21:28:13 +0530
Message-ID: <20260730155838.2119230-9-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: zTLjq43ZzJ791NCP2B4cYa5yGwFphGEK
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXwMx4vNSADO2/
 koGiBrRv+RepFkI1/Gn0NDs2fjoUFHRy76HbZbEG4vX6K4Hj6cosKgs87hHGTDNDNj/ILJBk9Ap
 1VRjOcHnPXm8ifv9M7xJegaAkYM5b9Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX8qMPP/rPtpZK
 MDLGn2e8R/cr4HBQiel5TiucxJZ7cmt4xLK5qz4Zi6J91hiICW8QrwnUy+g+0thEXQg5Rko761m
 d8WS272SmNcpKVAShLaDnqsvF5/jY+Ks9rssK5NWmoJvEsrFDMZkBHGwZ3P2ckTmfdcZI+8GdOB
 g0TgI7Xo/XlR1PQ8HbETmMQgY3Cqtv51dDluCWXwsVhMk/f2Ea9SSLyqTzF5Y8EAg/t40irN6VO
 QmhhcLOT1O8lJ+Cn34YfZaHCaf1Dc0iW93Dbf6WU+Vs5/sitYUt4V70OR8fuw2O/I5O4oCMAlyg
 Dntu/adtKhwL9+4VMdyrUrynK7YvQx3HlpYCLLbxmXMyzTGpCdNVmXVF6FR6AWfNK4EaoKMQ4d8
 kkjMDLCr7W6fL7KLkcT09dJivwdVZ3hHsheRlxyLUqgHajI/LVIBdu9VhopPLQgEvC3mDT+w/wa
 n7Q8qAO4myiFiq3bFEg==
X-Proofpoint-ORIG-GUID: zTLjq43ZzJ791NCP2B4cYa5yGwFphGEK
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b74df cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=4VLQQ0I0xb82km90f00A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

The mbx_cmd_t is allocated on the stack but left uninitialized.
qla2x00_mailbox_command() has several early-return paths (PCI permanent
failure, device failed, EEH busy, ISP abort pending, mailbox access
timeout, purge mbox) that return without writing the input mailbox
registers back into mcp->mb[]. qla2x00_get_firmware_state() then
unconditionally copies mcp->mb[1..6] (and mb[12]) into the caller's
states[] array regardless of the return value.

On such a failure the copied values are uninitialized kernel stack
memory, which is then exposed to userspace via the fw_state and
mpi_fw_state sysfs handlers. Zero the mailbox struct so a failed query
yields deterministic zeroed state instead of leaking stack contents.

Fixes: 4d4df1932b6b ("[SCSI] qla2xxx: Add ISP84XX support.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ba4a4764de1f..ab5648eb5f20 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2276,6 +2276,8 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 	if (!ha->flags.fw_started)
 		return QLA_FUNCTION_FAILED;
 
+	memset(&mc, 0, sizeof(mc));
+
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(vha->hw))
-- 
2.47.3

