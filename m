Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B874E27466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403934; cv=none; b=hiE6p2lFSBx8Ko9rEcQeRpMeL8EToNTbzQPStZ8aMs4OaRfCp3NLBFej0C0lEm3iN1pamYmJ3r8hBBLOkXAKxzZOexMMjpAZnwCbwPGv+Ho+EEoRIORu3lHLQGJohtdQcrDMaYvRMWSntGFLJ5ufHJbrPxVtMIUOv0K4nScfaX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403934; c=relaxed/simple;
	bh=T50MA6hX7H5R48uu/PB4ddRBRcRyHU4ay6ocZ57dceQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M02RHEn9bm3soQg9cF8lINlvbS6D0Szz1O6DhkFTonb1zqSPg7bRahDM+vgicweox1sO6BVKEGZnhepxPS9H1HdJsueCs9DTIW7Ofi5mS0vR1+BBLyygQwV2dk8YuZfO0H+QnnH4GKCvrZknnKFQmyKaf5bx9/We6k7/VHqHrIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=UvvSiJQB; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UvvSiJQB"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748ba21656071;
	Mon, 6 Jul 2026 22:58:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=E
	NeKE0VTP2FzhDQGz+WmnWi96Mdp5c3tjgT1C18MqzI=; b=UvvSiJQBsYgM8tHJH
	4YkN3vNTe0xwKc3WsnYb5bzuFN5yswRnvmuXU1tG5QqIb6oiQY0P73c5a9bZZXTK
	RzdGuGgsEJ7ak40Sf2qkLid5P5p6XF4iM07PZUQ9uH4ICK5VCWU9Lh+pYUjqf4x4
	ltzuq1zxh8MbaFtYgo31Huy7PMUxG0pvo4y8KegfFOhkfxJSRH10hPaIlpRoWLdF
	Q69hSyaIPbgbzTYcRgo7BNUSW2Fgiax24IY+1TBwQfIH5TbsKp/KIAHRq6Hm0NuP
	v5Iw4FcETXUJXWk24nRW1OkhX/Leo8YF2ys37Mqho1oEcLdag1IMIY5+GDMnWgrh
	gkRyw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:50 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:49 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 134CE3F7066;
	Mon,  6 Jul 2026 22:58:46 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 79/88] scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort
Date: Tue, 7 Jul 2026 11:24:26 +0530
Message-ID: <20260707055435.2680300-80-njavali@marvell.com>
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
X-Proofpoint-GUID: SxJr1tp8PLPF2w1NT-zjjZQ_CD6vuach
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c959a cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=ibbln2T6tsCcZXZxj_MA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: SxJr1tp8PLPF2w1NT-zjjZQ_CD6vuach
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXynLWJ226yT50
 dQfWSpdaMkijRwB7cMDHLBzAyTBlhGME2URvQAHm4CVkP8O68aAii15A8kDyLV3QBY3vGGS2mg7
 IJn+eOSwsqN/tuZ/ojLGddv8vACYhWY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX5KbzfhZAl8Ed
 ZkqPOuaqd2TNL/euAKyOiT7S1hEP6AxXY2dDFow/leiNwMGG2hcTn0h3LGTP+vK2fWDWdaUOZU7
 nJDSIk386KkZC9/+7m3jqAJnFhLI/zV2rQvEHcYNyhxgbBvW4D+5lM6fDzMNMEYSWTZj/gMrP6Z
 4wc5VZn2M8L4PPhfO0RngkSUauV8dzj5xMR3gdzIhQ6Zxgv3jweOUoUr5wvnCVcQ9awPYD3lK/x
 MSZBHa3PstKVreeC8K78SF/SyRYIGYXo+FeFmrv5Bj0gJugeBbS6jzEvdW/Z3umz3l0abqzAIlG
 UMGb+5td6URFndJzw3FpWb8sGAjX1wLH95tYloIGrdRr4WVE2LD1RbtuALz87rnnT7dTvtHAaGD
 AR8i1HHEOA+l1Jbax+yhy9dmX200gxSwbz6CG3CExA2f6jOt+3hal3e+NIB4iyZP3ugWie/0lLF
 FRNg2kdf6/RxQF2yiVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla_nvme_ls_abort() and qla_nvme_fcp_abort() take a command reference with
kref_get_unless_zero() and then call schedule_work() on priv->abort_work,
ignoring its return value. qla_nvme_abort_work() runs once and drops
exactly one reference via kref_put(&sp->cmd_kref, sp->put_fn).

Since the per-abort INIT_WORK() was moved to submission time,
schedule_work() now returns false when the work is already pending, for
example on a concurrent transport teardown and timeout-driven abort of
the same command. In that case the reference taken for the second abort
is never released because the work still executes only once, leaking a
reference. The command is then never returned to the NVMe-FC transport,
which can hang the port.

Drop the reference when schedule_work() returns false, so each
kref_get_unless_zero() is balanced regardless of whether the work was
newly queued. The held reference keeps priv->sp valid for the put.

Fixes: 70cbb6fdd31b ("scsi: qla2xxx: Initialize NVMe abort_work once at submission")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 8dc6df6c2e1c..fc8a344ec7d8 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -466,7 +466,8 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
@@ -548,7 +549,8 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static inline int qla2x00_start_nvme_mq(srb_t *sp)
-- 
2.47.3

