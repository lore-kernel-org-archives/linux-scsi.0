Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B740386576
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403888; cv=none; b=EreQXqXNasf14ihx/nexgH9I5Fk/cEPRmkGqFoZi3Skw6VYeYdSX1WfoCyGGCI9xWwxWac0hd/Itx/YIUPc5qDJly3cF5eVfU2S28qduDtKo3oI5aS7dM4r2SRO79dO3LJbuTQTweak4B4Z0Vlkv/67IY0LFfwV4ZY2yV1kj7Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403888; c=relaxed/simple;
	bh=yPz1u2Ckm7QsugoHLXfKjQNd4A+oa34HRyDhcWhhi6c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=STknC9gTsgnDe+xJ5lvKoB5y46edVzkgspuDxEwhZYADY0QYw1qeRCJGswAmxD3Q9G3wmKW0UzRR6rDSTTYmuDuYRAafxR6aNxNpb1SyRUdbdxUVZEnYabAybxosp4c/OwTmss2zfhDGrTSWbpzs7g/V0zcI6U9LCdcy75pg5Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=eaAXS+Vo; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="eaAXS+Vo"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747g57854303;
	Mon, 6 Jul 2026 22:58:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	andrEYvVLxUMP5oH5n/EfJQUb2P93E5D/3DpzRxadk=; b=eaAXS+VoByxng86vg
	faLK16rIYyUenO8nVLW5mMZK0oAzA4f7Gj6OVTSNPi4xsyUCE45/CS6aGndvIGq0
	sVetMpJlr5+ArtdBPNNEuHj2hQQGwTRh/cOuPI75TOwVftUUocDsi84SGKrClnRr
	ftW3wCzNstT7NLGMr7qeGL4Tbjk9JaX2w41T7t8x2d18dVbsXvjYxw1XTLDFem0w
	p8PKK8TxxG7ypxmCMHwyL3aF1cROAYqloulFmYjzbL8UaicN2xyEEVdYOkGzPQH1
	kAX1cLUiOxnI6ygA7WBAf50Yghz7YrML+k3CF6AjXvQkZOPLLtZ7EuGyvbI6Sae+
	u2SgA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:03 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:03 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D165B3F7066;
	Mon,  6 Jul 2026 22:58:00 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 63/88] scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
Date: Tue, 7 Jul 2026 11:24:10 +0530
Message-ID: <20260707055435.2680300-64-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX1nQoeQ5st87A
 WPlsQFscg/20Rt89mF5VS6OJiGtX2QjDA+TdnwNxNqha2Um7QYY0cNjOD3FH/cwxpQ6az8lEuow
 2TP+C91y229AVVOELUNAE2eXrgwiiZhd4moY+lf/4mrb8RAb3vJFhhvmQRmW6siZI6EerKpo7Zn
 sKEEzbXUVuOxz7VLrNUE5WrLAnyzRORFKBuGoQyxhdJxpXPCsmaG1jObZnY4RmSExW1TT6xYKXq
 ulfqIhqlhafobILOM3AnKAgvxJVslfsFabZ9M1XBUswDtBAh0Hw2g48bcZ0DJs0lLb7xklKMzqV
 2I8YGXsLcfk7l0/0wPA4uCbVpv+xclLTqaYHEj0zbECViK4HUU6iGcjQILtf7SnUnF1yO7vz6gc
 85wyPqC0JZBDPI7hDPAtB2JuD1jwEsDMDNqCkSntfnu5By18UdnXRQgJlA5UMhi7n/ROk/KBOBI
 sgK3i9NOgzybmSXSCNA==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c956b cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=4VLQQ0I0xb82km90f00A:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXx7Z2G8x0YvOp
 BNeXkmhh+FeHbAGOhYx3bnJNadVQkglvGruuJFdZK8U06J3xYoUx7cF5ekpmLc2u4MM12fmWxFu
 gsgt2VP7elVcQzzjaqi/UoAGfxwwg6w=
X-Proofpoint-ORIG-GUID: 1oKwEimevrZOyO-Dz8LiJb2sTLKexMyT
X-Proofpoint-GUID: 1oKwEimevrZOyO-Dz8LiJb2sTLKexMyT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

