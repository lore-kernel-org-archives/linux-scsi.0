Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8621BFE00
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 13:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731675821; cv=none; b=KMI+sXxLxlFDM1nogrAhUYnm8JWy1dcZDmby3ppBvh3gzkLapLG+1QJ417NsxlSMMhGYblfkZ7yFgeuMf3KPjKi7TxXB+QHr+g1N0/tY610rrIqiuvJnpFyWQlZqgJEmUj2It8Jq8xuILomZCxbVy9+Sa3LcSbWLa+OG3EW7R2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731675821; c=relaxed/simple;
	bh=uxyEqNxsD1mx41Tn+w8u+tddM+4FyiuFhHxdi9jbtoE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXc4vFYr01YuulGynl40vr8BenqH0BQ4WiCWJ/E4fpYTqdomG3P3ufd/8f5ES1i73P6Mlz8MMCL++BHAxhgEx8QEcE8R5GVImCzAirbox69GsDzFyLcIfsvINAYDFQ0nIM+Kn6Cpz3qPznjVbCuu2OvBaR2GVHCNQ8yK/2YC94c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ImeFjN8o; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ImeFjN8o"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF7GL6F031001;
	Fri, 15 Nov 2024 05:03:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=7
	Zy/OMVv4MUBrF8lPTsSnZUc46bsYEnFtrg00KjtZ4A=; b=ImeFjN8oIvlPA7s0f
	ApvzlE9Y05HbH2zFHy+3rnMh0jEfhi7SO5JfeWqCLxBs/EE1P9n6STQ88Q1fsJtG
	FNFZNHVGjq7Q5LCi7WCqQk/UUIk5SXi6hj0qFJi51mNQQD/iyQv/BAuTuEbi41B0
	eWWcun+3h8WaOjdWWzt6tw9M1QngRX/OKBcKmm0LWPGhekxBnjz+Ia4RzQt4r3P5
	l6pHWWWcRoI3puJJxCiSIL6ElE84YLarhno8zMKhd97Gxa6jl6kw4fCHWmzDiW63
	DLFB68urfAJ9f82HYufseGp74cu/oxvtPzOUneAOE7/hG09AYfM6MoL4lK3TOLCq
	CayFw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 42weeau161-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 05:03:36 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 15 Nov 2024 05:03:35 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 05:03:35 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 05E1F3F7075;
	Fri, 15 Nov 2024 05:03:32 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 2/7] qla2xxx: Fix use after free on unload
Date: Fri, 15 Nov 2024 18:33:08 +0530
Message-ID: <20241115130313.46826-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20241115130313.46826-1-njavali@marvell.com>
References: <20241115130313.46826-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 6wKMezz2dZFqxESE42rZ7Xc-VcbrSPbx
X-Proofpoint-ORIG-GUID: 6wKMezz2dZFqxESE42rZ7Xc-VcbrSPbx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

From: Quinn Tran <qutran@marvell.com>

System crash is observed with stack trace
warning of use after free. There are 2 signals
to tell dpc_thread to terminate (UNLOADING flag
and kthread_stop).

On setting the UNLOADING flag when dpc_thread happens to
run at the time and sees the flag, this cause dpc_thread
to exit and cleanup itself. When kthread_stop is called
for final cleanup, it cause use after free.

Remove UNLOADING signal to terminate dpc_thread.
Use the kthread_stop as the main signal to exit dpc_thread.

[596663.812935] kernel BUG at mm/slub.c:294!
[596663.812950] invalid opcode: 0000 [#1] SMP PTI
[596663.812957] CPU: 13 PID: 1475935 Comm: rmmod Kdump: loaded Tainted: G          IOE    --------- -  - 4.18.0-240.el8.x86_64 #1
[596663.812960] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/20/2012
[596663.812974] RIP: 0010:__slab_free+0x17d/0x360

...
[596663.813008] Call Trace:
[596663.813022]  ? __dentry_kill+0x121/0x170
[596663.813030]  ? _cond_resched+0x15/0x30
[596663.813034]  ? _cond_resched+0x15/0x30
[596663.813039]  ? wait_for_completion+0x35/0x190
[596663.813048]  ? try_to_wake_up+0x63/0x540
[596663.813055]  free_task+0x5a/0x60
[596663.813061]  kthread_stop+0xf3/0x100
[596663.813103]  qla2x00_remove_one+0x284/0x440 [qla2xxx]

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7f980e6141c2..7ab717ed7232 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6902,12 +6902,15 @@ qla2x00_do_dpc(void *data)
 	set_user_nice(current, MIN_NICE);
 
 	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
+	while (1) {
 		ql_dbg(ql_dbg_dpc, base_vha, 0x4000,
 		    "DPC handler sleeping.\n");
 
 		schedule();
 
+		if (kthread_should_stop())
+			break;
+
 		if (test_and_clear_bit(DO_EEH_RECOVERY, &base_vha->dpc_flags))
 			qla_pci_set_eeh_busy(base_vha);
 
@@ -6920,15 +6923,16 @@ qla2x00_do_dpc(void *data)
 			goto end_loop;
 		}
 
+		if (test_bit(UNLOADING, &base_vha->dpc_flags))
+			/* don't do any work. Wait to be terminated by kthread_stop */
+			goto end_loop;
+
 		ha->dpc_active = 1;
 
 		ql_dbg(ql_dbg_dpc + ql_dbg_verbose, base_vha, 0x4001,
 		    "DPC handler waking up, dpc_flags=0x%lx.\n",
 		    base_vha->dpc_flags);
 
-		if (test_bit(UNLOADING, &base_vha->dpc_flags))
-			break;
-
 		if (IS_P3P_TYPE(ha)) {
 			if (IS_QLA8044(ha)) {
 				if (test_and_clear_bit(ISP_UNRECOVERABLE,
@@ -7241,9 +7245,6 @@ qla2x00_do_dpc(void *data)
 	 */
 	ha->dpc_active = 0;
 
-	/* Cleanup any residual CTX SRBs. */
-	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
-
 	return 0;
 }
 
-- 
2.23.1

