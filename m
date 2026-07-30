Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65B7445ADB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427204; cv=none; b=Vw1phha/Dnu2p/jX/KZsokQccq8CH3GDQm8qjct7n7BOOqKRRE/Z3zK6IrpEENnsEbsfknSZQIvibO2lICY1/OBFZWoVnLM0kbGt2L0oNTimMh0ElHlM32nY+QwehDxqyYc23ocWfQNo64fDoEwr85T4s1S6i2MqQGH1h+kSCUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427204; c=relaxed/simple;
	bh=takgPyVMEgoK4M/b3rdYZgHB91mKZ8LHxBE7IY9asMM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyqG2kmSItXSI/rRSQs+l87yDRaUCJkIriCBIlwq2sVD1FdvoVsAujhQ+5k+8HOHPPcv/ij/R7Hnov1dN1NvPCCsX/i51QQGeE9r1WaIDXPB8EIT43bYrDkeCCiDO3G3RSVOxyJYSB6h8uXxjMzaVFpxvaCbH1oy3QnTCCU85qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RXbok/EK; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RXbok/EK"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWBLO3113569;
	Thu, 30 Jul 2026 08:59:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=3
	UemVjYFH4vjZUZ2QPtL/V++VMo7BO4Ibx/XA9rSv/g=; b=RXbok/EKglZHZitMW
	TBushioi1ngjr9k/LJkZ59p/nyAALRYLaXuwNB3fYeidZ6zDO3tJw2CX/1GMoDwY
	JkVoFvAH5v9O/MUZwW4gHaouBlvNtj4EmM0A/wquMgAeXlXop8OOUSd9Afb1o3hG
	MKzIX5riu7vNlWQGI93RheaV4xZz5hhzFNrpr/hFW7I76Em10UJTMqPUHnHYGuS0
	WzFYBrmsb9jANe3R3gsMnr+0+/oicK6KQjMwJShF4NlG6/tWHwGjC5MTObIgS9JR
	pL0lnHFWJMN9YRZs/ef88wqZxLchkv/ebiDm79YMk+2hJvVBtihtup0FX5KJi4ar
	LE2Kw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7c2s1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:59 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:58 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 4487A3F704A;
	Thu, 30 Jul 2026 08:59:56 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 20/33] scsi: qla2xxx: Avoid double completion in async IOCB timeout
Date: Thu, 30 Jul 2026 21:28:25 +0530
Message-ID: <20260730155838.2119230-21-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX2u/5GecQflrB
 zNf1nZiQFerhIwDYUx4wKTfYO1Aw7hy+jOjEW5G5EmeR06j+lsXmjbmAU2KH1u/dM3Bvb3CWxnQ
 tMCCeNrtv6IUxGmO5nGcdJ8GQAw8YPk=
X-Proofpoint-GUID: b-Wd4g28fm8E3iBvN_DYaqcB5A_wp77A
X-Proofpoint-ORIG-GUID: b-Wd4g28fm8E3iBvN_DYaqcB5A_wp77A
X-Authority-Analysis: v=2.4 cv=HtRG3UTS c=1 sm=1 tr=0 ts=6a6b74ff cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=5BlEZgpcnxVXIiox3MQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX8bmWoQ/EJWxe
 2rlujpgpPWDThx9Q7tFxhGMLLq/+Ded3kfU+eMwoqU1ML4XNmkqD8XMBo1gq4UteupPJ5NRhO0P
 Xy794Z+X2buRRZ6+QvP+qL5pS9gqDBYtoiL2mmPtUEOKaWkR5qrma0+VScfyE50gX5lG4o9OxiT
 Xip7ds1gfAyPIDNvk22cw7CQL7R/nknK64c2F0aNR5pNzK2y6OqoOB+eaNl58mCmSz90pVrYMyj
 1Ny/qOrTiwF/UBAzY276Ws/iV+2Sfo8Px2J7jIfJdBtavwOf8dplmJEG64+l8fT4gGj3JG7V7wi
 0K62aLjQi3uSjJrCPaRMkNgFQaYSiqeueltLonivlQoZMp2rONfZe5Jb8Qoi+GsreOBBYzceSu+
 2gMvHzd0iVh5oUWFlJEDKxoFe7G9mcpUvGNhUvJwsEDXKFdvvWemT8Co0L9lblAPhRGwNzDCe2C
 SGllVZ+U5q9XK27fb9w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla2x00_async_iocb_timeout() tries to abort a timed-out async IOCB. When
qla24xx_async_abort_cmd() fails, both the SRB_LOGIN_CMD path and the
SRB_CTRL_VP/default path scan outstanding_cmds[] for the SRB and then
call sp->done(sp, QLA_FUNCTION_TIMEOUT) unconditionally, without checking
whether the SRB was actually found and removed.

If the response ISR completes the same handle first, it removes the SRB
under qp_lock_ptr and runs sp->done() -> complete(sp->comp). The
submitter qla24xx_control_vp() wakes from wait_for_completion(), clears
sp->comp, drops its reference and returns, reclaiming the on-stack
completion. The timer reference keeps the SRB alive across the timeout
handler, but not the submitter's stack. The timeout then issues a second
sp->done() -> qla_ctrlvp_sp_done(), which evaluates "if (sp->comp)
complete(sp->comp)"; with the pointer loaded before the submitter's NULL
store, complete() writes into the freed stack frame, a use-after-free.

Track whether this path removed the SRB from outstanding_cmds and only
call sp->done() when it did, so the command is completed exactly once by
whichever path owns it. This mirrors the sp_found guard already used in
qla24xx_abort_iocb_timeout().

Fixes: f6145e86d21f ("scsi: qla2xxx: Fix race between switch cmd completion and timeout")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5788c7e53d8f..36de0a0bbcc1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -228,7 +228,7 @@ qla2x00_async_iocb_timeout(void *data)
 	srb_t *sp = data;
 	fc_port_t *fcport = sp->fcport;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
-	int rc, h;
+	int rc, h, found;
 	unsigned long flags;
 
 	if (fcport) {
@@ -251,6 +251,7 @@ qla2x00_async_iocb_timeout(void *data)
 			lio->u.logio.data[1] =
 				lio->u.logio.flags & SRB_LOGIN_RETRIED ?
 				QLA_LOGIO_LOGIN_RETRIED : 0;
+			found = 0;
 			spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
 			for (h = 1; h < sp->qpair->req->num_outstanding_cmds;
 			    h++) {
@@ -258,11 +259,19 @@ qla2x00_async_iocb_timeout(void *data)
 				    sp) {
 					sp->qpair->req->outstanding_cmds[h] =
 					    NULL;
+					found = 1;
 					break;
 				}
 			}
 			spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
-			sp->done(sp, QLA_FUNCTION_TIMEOUT);
+			/*
+			 * Only complete the command if this path removed it
+			 * from outstanding_cmds.  Otherwise the ISR already
+			 * completed it and a second sp->done() would race the
+			 * submitter's freeing of the on-stack completion.
+			 */
+			if (found)
+				sp->done(sp, QLA_FUNCTION_TIMEOUT);
 		}
 		break;
 	case SRB_LOGOUT_CMD:
@@ -275,6 +284,7 @@ qla2x00_async_iocb_timeout(void *data)
 	default:
 		rc = qla24xx_async_abort_cmd(sp, false);
 		if (rc) {
+			found = 0;
 			spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
 			for (h = 1; h < sp->qpair->req->num_outstanding_cmds;
 			    h++) {
@@ -282,11 +292,19 @@ qla2x00_async_iocb_timeout(void *data)
 				    sp) {
 					sp->qpair->req->outstanding_cmds[h] =
 					    NULL;
+					found = 1;
 					break;
 				}
 			}
 			spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
-			sp->done(sp, QLA_FUNCTION_TIMEOUT);
+			/*
+			 * Only complete the command if this path removed it
+			 * from outstanding_cmds.  Otherwise the ISR already
+			 * completed it and a second sp->done() would race the
+			 * submitter's freeing of the on-stack completion.
+			 */
+			if (found)
+				sp->done(sp, QLA_FUNCTION_TIMEOUT);
 		}
 		break;
 	}
-- 
2.47.3

