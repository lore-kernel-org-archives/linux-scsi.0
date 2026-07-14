Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146B33F1AC0
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022998; cv=none; b=OlfUkUBsIVJQb5/2ZmS+KmZ8ojsqv+NC4W1w8ptxL3PfuZ0HfzihU7k2+W9rEa3FJkTAcXXfql9DrXCoijyeXLIvOPxlYfZ4X/WlmlR7Pb0kVxQuu4rrMDi82KeTGKddigGqVUEZr9RJFZvj8cTM+26wjKb+BOW2AhEQaw76m4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022998; c=relaxed/simple;
	bh=oA9qojIXPBb6ZIjKMCGUFrMHQDv5TGB63ZwklOZfOJI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RBiD4v2u/idJZQH+0rDOkFnBiyt+8mh+4nXdpPej09T5RidNgXESOPY+ErtDEDes+fGYmDtEYv0Ec4d463wlHEJDxDprGEq2jB6URjgIfLIEUj5uEt+oFfvWY2GviuGfig1uq999KlcBvnjVnAjqiF39uCFbXjI+lEUNVB5GyEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fkIQpiaE; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fkIQpiaE"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UDUg2407822;
	Tue, 14 Jul 2026 02:56:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=x
	5xqfcSay3Wt7bGO65WBJAK5Rtfg0FHph9h6ATSSbSE=; b=fkIQpiaEZc43+7Qes
	AffgUUL9SpDZP7eo243mwyjbx5Ey1oM0lm/rRQ56thmAFbwuB0wt14TqD+AJMRFz
	aDXY7Kda1ZjCgCiTs+jFHtfFuPUvRNOCBgRKS19Z9FDsdmBwte/32VkJ5vOiye+J
	IPvbhr2TizFZpfV/4+zEy07sZPHzIUjRCKQuSAZPH1vE1ovbiSnYvb0QcKXdIr2T
	pQYKYmMmYugT+dLwKJsGY0YoEH6kCT837T7s4kmfFr29z1pVYJk1JD8xw04Xk/RH
	CT4RAOOt+NhXPOcLM4LLkyVSD10Rc0/tGLXFELgDBcXIFB1GdPJ6LsjpOG1Uog39
	Sat0A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9nq93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:34 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:33 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id DCE125E6867;
	Tue, 14 Jul 2026 02:56:25 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 47/56] scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters
Date: Tue, 14 Jul 2026 15:23:44 +0530
Message-ID: <20260714095353.289460-48-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: 0pq3i_ARboIDgIcbayK6FTzuOEkt8U9H
X-Proofpoint-GUID: 0pq3i_ARboIDgIcbayK6FTzuOEkt8U9H
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX6JlXaMcLwiBr
 PbUNugl4Q87WU6XHP7oQ2zbwlDECy3KzLWkwHrMb6lhp7CtLvYc4MP5mn+3emT3k3DoW2RSuGUX
 f4O+18Q6vIzGJFpHxaM+QgqgABr9BbE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX1zEUYyQpyaZN
 SSYRr1OWFNWS1BipHUVlc/cNHp37lp13Ggz9uGMgCy38Oq2UM8GSgLGH8GCbfaZNMZMiSV324od
 9938Lf6slOvXMaKcqa5w+RxCJBpHL2A9pZozn5Qr+3FLnhNdpCYmrBAFBdxdACeej1c5OI76TEV
 i0ue4m4RgbTk6nbI+hZQPseRJWj1yY4+50fiqIXWEsdet9Yyxy9D/DD0unA/nFfDDEflTRF+icy
 joXm8j2mHeIeHB5IgMV21m83919EDGdsHvD/eek7KcAEb6oDx4Tu/vbftc2fjLSE6oHeYMC4GqQ
 kyXLPpTNjwZ85fUhmt/p8w6bTEwoAPHAtLuxzNIpeJdXEEYbVgof4pYKYUu42LWCTgk75EqROFC
 TkOQzDyUpiOaqhxRNpmJZXewe7ULO2FxhY+Qu1AJMiCl8pdR0edkul1YMSqHGaZdsJq+6u726ok
 qbGqfmJtV08f7KPd/ZA==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a5607d2 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=emg_xM9YeQN3qHWuWUkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

In the CS_PORT_LOGGED_OUT case of qla2x00_chk_ms_status(), the
FWI2-capable branch compared ms_pkt->loop_id.extended against NPH_SNS
to decide whether the Name Server had logged out. On FWI2 and later
adapters the response is a ct_entry_24xx / ct_entry_24xx_ext, where
loop_id.extended (via the legacy ms_iocb_entry_t view) aliases offset 8,
which is comp_status, not nport_handle (offset 10). As this code runs
under CS_PORT_LOGGED_OUT, the field read back 0x29 (CS_PORT_LOGGED_OUT)
and the comparison against NPH_SNS (0x7fc) was always false.

As a result the driver never recognized a Name Server logout on FWI2/
29xx adapters: it returned the generic QLA_FUNCTION_FAILED instead of
QLA_NOT_LOGGED_IN and skipped setting LOOP_RESYNC_NEEDED /
LOCAL_LOOP_UPDATE, so the fabric rediscovery triggered by an SNS logout
did not happen.

Read nport_handle from the ct_entry_24xx layout (offset 10) instead.
nport_handle is at the same offset in ct_entry_24xx and
ct_entry_24xx_ext, so a single cast covers 24xx-class and 29xx. The
non-FWI2 branch keeps using loop_id.extended, which is correct for the
ms_iocb_entry_t response on those adapters.

Fixes: b98ae0d748db ("scsi: qla2xxx: Fix name server relogin")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 7a4d2fdc095f..20b1aef455c4 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -192,8 +192,8 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 			break;
 		case CS_PORT_LOGGED_OUT:
 			if (IS_FWI2_CAPABLE(ha)) {
-				if (le16_to_cpu(ms_pkt->loop_id.extended) ==
-				    NPH_SNS)
+				if (le16_to_cpu(((struct ct_entry_24xx *)
+				    ms_pkt)->nport_handle) == NPH_SNS)
 					lid_is_sns = true;
 			} else {
 				if (le16_to_cpu(ms_pkt->loop_id.extended) ==
-- 
2.47.3

