Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838CE15278E
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302286; cv=none; b=dazw+ikpULHTwfjT3kz1sCYa5dTjYJqlC7uz9TuCJ0aC/1m9Cu8iMhy2YNGFX65gyMLxOT4Ay6V6RpW5HMqESkxPJEpMx2OvjqYyggoY52UhPGge38MG4WNDSws03FO1bIwEuncyu47hclfAs/9apR3TSs22LaMGrAhhpBMc5nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302286; c=relaxed/simple;
	bh=oA9qojIXPBb6ZIjKMCGUFrMHQDv5TGB63ZwklOZfOJI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YSEliif6dMT3Im2Vx9OFriXnVDBG1dkCbwY35hvVkpI1KJvWKqY/MHQZ379v1gAfr7aRjSD5i+DIw4lfr74rACAYaDvW9mdGGfOUF2VhfwezyrM3zOyb33Uiq/oDeEfwEEDrvd+1vT6Nh6eCgMN907/+4neifaM5LpEIpa/8SrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fe1ik2IA; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fe1ik2IA"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5tAQ113139;
	Fri, 17 Jul 2026 08:31:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=x
	5xqfcSay3Wt7bGO65WBJAK5Rtfg0FHph9h6ATSSbSE=; b=fe1ik2IAlXVuaCflz
	ByywEniB8OhebxsItmeOl4NkaS646uJxyMFI2oDPbY/DdVA6MX9hkuTU6HyottZs
	TOggLdiLPlhYuPyj4Ixau2ztKC20yADTwr5i/3hdIad2KXI6RZ5gzGcr1KLdpHk8
	UTrllYEbXfBJf3Z1cAGi94oFlWVbcnZCNU9Ir8LzfrKpa0Ul6BPSoWO7a5BozUXj
	/Bf4p6QaiD0ja4FGop/q+4E5SJw1kLB5XwjwIFndRUtw1FWXTNaDGtsRpUiZh1wc
	Mz8jhXUKxgVhdrXL/SN261JCy6CWfC5RICaulZVMgJUoiWPRy9+E4siXszrv15Zo
	1bXaA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fetcbn1b3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:22 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:22 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id AEE615B693B;
	Fri, 17 Jul 2026 08:31:19 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 47/56] scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters
Date: Fri, 17 Jul 2026 20:58:55 +0530
Message-ID: <20260717152904.3155730-48-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tJ4POsxt5ScC0pldwpRuZ5d6o01T818Z
X-Authority-Analysis: v=2.4 cv=Y7jIdBeN c=1 sm=1 tr=0 ts=6a5a4aca cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=emg_xM9YeQN3qHWuWUkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX76jz17ILfnSr
 R9PPGAVsnsxpyK7DFyh/ztWjQtgQTvOX1meGzeLstQCZ5CkAjLcMYenoRpbLqPSMqU3FOr6fri/
 JYT5v3iybD/VYymbHgQfzSK8Xhhzdk4=
X-Proofpoint-GUID: tJ4POsxt5ScC0pldwpRuZ5d6o01T818Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX4+vyFJUy9pHL
 mGgHQQYCxr3Kd7MFezSEi2XulhoZjPQ8QCotvGeDP1zl3XpwqugJA4jwAjE59orlme0UXBv6o1S
 SLktaoltQA7V8dAdtxVnaRGYXZbZFXe5/KPPRjQMtF4YJZyDQDgmzh3n93wH7sTCVvDyUGhipGL
 yrfLL3EM0PpFMN0IfWXYCi3kCMr7qQbjgO7pH7JTrtWtCoGYVG+CXpAAPosq4nf3xUvuzqOJNJ/
 yTi2p+HIRX5NT91FIaj8opLQIUoCOyhypOYU+4An320ZFrY9MyfmMothU6LXCdfXIIz2+AOyusf
 ADQQ2rojEZAkqGILo5Mgl/NmppOrhYRN491nMhngaV7fqe+a9BzOQ87Z/cTyCyA/pjP03w28SOg
 SkxZjqccfPlgFOC3psT+5Uux9R9esk/KFgnYJxcyKayqO579OTZcZv1ptUiMbKHbbY8aDSpTyYc
 TTMiiVLAsvIjiNHrv+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

