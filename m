Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0282630FC21
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783212; cv=none; b=oxVzMPzhc0qqYN+2mebMIAJXknm7I2+P7BckfxH1ewu/w9zdeHIPz5E20G13LQO0/qd149ia1R376o6KAbapIRj09j0ROQoeC/nVKqw35W21IRhRBIY9kZi5xc3K9i6RA/ZK2rD3rgpdPA3Brh/U5YHyxgbJuFj2XFENClByr+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783212; c=relaxed/simple;
	bh=oA9qojIXPBb6ZIjKMCGUFrMHQDv5TGB63ZwklOZfOJI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rjiz1ZnNcuoCH1s1pcEDcEiVVWjRDDRMDMcqtCbuoD7sZppaqA/vwQvplZ0YJc5KXB1pZ0kRtRbQzmPj8mZMCFq+7yOW8HvvzkqJY2IL25pp8gtwQfSZmxzJ3u21q8lu5gOh0lNNGBL89BJHmK/pXXO/EGfNaARSXFG7frvY8nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=JvOOVq59; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JvOOVq59"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w62s422860;
	Wed, 22 Jul 2026 22:06:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=x
	5xqfcSay3Wt7bGO65WBJAK5Rtfg0FHph9h6ATSSbSE=; b=JvOOVq59XDLaEvG3K
	PCA/9FImC4tKLvOgwRs+WwCdp5EFDA00j8B54Y9p5GLH+eAs99C35YNyKR6slc7Q
	cyeF0hJdeMYMQgAqBxix1K/XUlD4uPZmgukXQfT+Ls9AzqXSlWoTkB9Qha/DmzOe
	yplux9GPOxpOFglVhONlfGK4v73MV6pQ1XFPEjKS+gpOnfjp3NY7T6YenRamwPYE
	YMVth4kPf9cDKggdQSa4nxbwc6cktkGRgR+zAy4vVo6tMX6sFMLE/qAVJyRPM0Tw
	lNo7HBUFjcS6tv/P5udj/FadYVhy6BpSIPNuDC3lHGonuEE8crWGQAl/wJ95VTHD
	nL62w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8gh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:46 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:45 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id F2C105C68E6;
	Wed, 22 Jul 2026 22:06:42 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 47/56] scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters
Date: Thu, 23 Jul 2026 10:34:04 +0530
Message-ID: <20260723050413.3897522-48-njavali@marvell.com>
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
X-Proofpoint-GUID: xrvxXVhNGwNVK8qoOxTleXrJBUfc1Zps
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXzdSXOxKxDWBt
 XescmVU1D1sMLIC3j9kCsYSFzGSJAHe8OPVb7viR8v8eB4zRXj1cNWSW8AEhF8ymNx8v09QsDTM
 bmKAiRxSasEt1a/6MDh8h+Tn7Q2Rx6k=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX2/n1fZ0Bd5qX
 zDKFm7U+g4fEpN5KYe+OoYKd3N6zZBlT7vsd5wOrA4Azw0ylf+m+A+Of5lDdlKLEjp9spaY8wP0
 GcO0IuFEFczayDiyRzGV+ldPjhprDL4JnJvCzPk1jA1SvsaUZTs6pNwz3S3XE7D6DyVVeWTJDB7
 bbIMU5Ex8T8Hf7JCTf6d/G44g+xsutIujgt1Yj620uiO6LYHp+XcWMt+k7nYgLKiyhrtWf+C/WS
 QKSk+W9pB10r5YFuxg3LpsTnp+tJVq5ghMgg0m2CMIKzu7Aq8K5gEHefW00uATewM6sCq8ebzEL
 JvzT4lGMpO129IW7VbRzHRWvKnV4myjdGI94hpKJqFeFdJkb3RAxFPGOxT4/1/aifEaT5wmuy5J
 TKqCmL3Uqr7TREaeoFix6vP6Z2XrU87SMj+vVZi9+7WVvsGdWBjAKXJ/bytGf2OF++G+jDK715n
 DwoF4Sti/kEPBb9O1sg==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a166 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=emg_xM9YeQN3qHWuWUkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: xrvxXVhNGwNVK8qoOxTleXrJBUfc1Zps
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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

