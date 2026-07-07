Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912C61CAA78
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403842; cv=none; b=QARuWaKMfDoGkH9CmVhkqD4zct0NCRupNi9Rosb07tRJPdOmNWZMgMiNgo/l6TsMFSLog56NkauhcQotvgoEL4auFLlyx8MtS3f8//oNtCHYLw0TKyrwJRw6yfojBTZtAQASw4FXG7kbIP3BZCcebDz1oCzNVHpLfGENK1ki39o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403842; c=relaxed/simple;
	bh=oA9qojIXPBb6ZIjKMCGUFrMHQDv5TGB63ZwklOZfOJI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sHXaboetG1sN/i/gSs1V4LMC3DAgeiiPOxhOuTGggYfLM0yEJc3tzF2kCN+7ijA7kmvNru5zNA2HHVomvRej0+GIZQxaInL1tSzvYgPoVh7IwJCZsVxnwkG+aYIS8fhPWgs+wofIGY0oZ1+SvNSNEB2JLGGaRumeABCA8bQo4Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=A3Jgaoum; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="A3Jgaoum"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748kW61656479;
	Mon, 6 Jul 2026 22:57:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=x
	5xqfcSay3Wt7bGO65WBJAK5Rtfg0FHph9h6ATSSbSE=; b=A3JgaoumKOSB1ih7M
	CHUwO2mq8ilEG7XXHBJ1C0Ps1wSjk1ZuTiTZVRfbOz+Ww7jUqQBC+aO7H8UzOgTv
	LuBcZSFBkea31dj3oy419A3l+0jzrvmgAfiQqASxScD+B0jtdCGBBLGBqjxJdNlq
	jzfJk12jE76CGBfv7fF0FrZFDePe/rTyO4uCHRUgdV1JQk6vKKma6V6jiOyUCFuJ
	bEGI3xZKYMwGJKoHJigdITTJsWRfdWjYb2QxMe+g+yXbqFiMRcfISGlNeWNQpiT5
	K8ufpxcVkZCGQtwRNkptuEbWNz7KT8+FfbhGqgPStwPJ9SpNuXyPlm0sY5qnUwE+
	5aGfw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqdy7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:18 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:17 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id E8CF93F7067;
	Mon,  6 Jul 2026 22:57:14 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 47/88] scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters
Date: Tue, 7 Jul 2026 11:23:54 +0530
Message-ID: <20260707055435.2680300-48-njavali@marvell.com>
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
X-Proofpoint-GUID: Ta2Wc2MX6U-7skvIR-rjvGzu2ndmXvmQ
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c953e cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=emg_xM9YeQN3qHWuWUkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Ta2Wc2MX6U-7skvIR-rjvGzu2ndmXvmQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX6DHYntCK4BDa
 wgUziSuuNSw4XhD69DlkKaN9LijKO5DaK4vzegj/Bg/4rXFha8VZE9YlHrcCjmRYwqM9d9YNu2K
 b6lKQoiJ3i28gfPQFrFEP66CjAeFnpU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX9NxdC06cWe2f
 jTE6GNUfYs9+HcT5mwIH+5Esu2FE2W5cx24s9C4sy7t9FDH96ZN7dGkA4sDYsVJWuHyINoPyQYM
 vXcgtDnqYBSdtQQKoIQNSQa0LZdNuwd+GORi27X3/qzGDLkvvSVNwdw2e8JXRjmeQN7wZNTCvyh
 4rufaYNLzGeQKDScmUO/pSkVfDMQVHgP0HxEKwLgAJv/vovY+jtQcHY0gJqFk5DJDyQkQjcoQeL
 aheFpCIizooiKWnEDie6eJfmImtQWWcQrav2yjkusG48cjU2AhpBn/QWEszthaRDYRChunY0WGF
 MZjcp9HB4BLyr1/hW7gGhO3tTWd9qQVRsHVyvTKH6P4c5AaWqFRDJYbUyPBM4iI/phZCXFixQGU
 MofWCO4xuRSmghbE628JaWFAYGC02m0c2lhue1qbuKnFCUG1fRKH3hScZYatGXdRVMcYuuT40px
 wgBOx+HW85CjMRR0Znw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

