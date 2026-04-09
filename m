Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCA339023C;
	Thu,  9 Apr 2026 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775747562; cv=none; b=RYNHV3JkdQLwhXtaGaYxbm/4+KKD1UeO9rXtCUBEOcI+NxGHXsMrNZ44TAsg+RaYCPNCXSMkyN4fWoDADBzJEh6xEcD+2ojdNl4MNzYZL2bLF2trXTHZCGDqUtQM9NBxrXaWUpFGVY3Ox/zMKlYtIcKALb7zeoEaBjM/5GypOWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775747562; c=relaxed/simple;
	bh=rGbzVDzF1yt8J5Sp6HUHxfIRq18J2KwZYDj1oplSebM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=Y/VhCnAkMdTA3QT6wySJZ0ziLhiXyRi4zmg1GcxSlCXS3nj7nMdptPnFH+FGI/cPtrcJ/YBjiyYpaknOJlL9n0IMG2kTpiTeUjFCRDIfuOtz/9gfcUu9wWXGEd/n/nxml3ez9Cjkznj8Oy1Ne1kBwYBG7FsrjWiXApmomAiuvps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KiNvSfOX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KiNvSfOX"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639BxmOU2302913;
	Thu, 9 Apr 2026 15:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=uv3SxdrQvJ/R0R2bE+Pz5mKeq5X0
	1XmrcYpltusqVMU=; b=KiNvSfOXhCWVqWHOK2rmQjc6TeJVv4S9E3ea3S+O8YC0
	VxSEM+xC+0KGIbY3wfNQN8+84VboinJPPU0mdBWqju1hiypWgH7ieDfLr0TDxQKy
	WUfql18wSbV135qEVlvzcDpyuTwlpq1mNIdXPNQaufzF85mIVrxpKsMPkzcKUVpN
	UuvLk4liIZ9HIrB170VV0NemyAnskEID/75Q3ar00ID4brD/b+1lxJMOj1Qvf5H6
	ntPMa2sbblTS7GNdK7pQCJOcnRX7LnzEXHF8bSE6dDyXLOTOKVv4VadiBetRVUyF
	7DEWCdTbp2OBZuSZv9oMYHoHf3ZW39Wvu3e4Kduhnw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2fnmam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 15:12:37 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 639Cu2a0007924;
	Thu, 9 Apr 2026 15:12:36 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmg2m3ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 15:12:36 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 639FCag321693036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 15:12:36 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 611E858053;
	Thu,  9 Apr 2026 15:12:36 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D241F58043;
	Thu,  9 Apr 2026 15:12:35 +0000 (GMT)
Received: from [9.61.156.97] (unknown [9.61.156.97])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 15:12:35 +0000 (GMT)
Message-ID: <e16406ec-d4d6-4783-b79c-5c00263c133c@linux.ibm.com>
Date: Thu, 9 Apr 2026 10:12:35 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Subject: [PATCH 3/3] scsi: fc_transport: vport and rport cleanup
 synchronization
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.ely@broadcom.com
Cc: thinhtr@linux.ibm.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDEzNSBTYWx0ZWRfX0jsssrJth1Uz
 H7xRGniwZJyLC0CAsQJTaa3fMJlr1piUOec+2qhTIan0nBeI1dcM78Q6fdYXjuzvKvLIsCKTvWs
 tAisn6z/ISkShmlzTMbMzrTVBTHoyZhUWIuo3jaljU1KH4/vCGqEUtEjC7beCEa+hW7V9aRbPul
 hhHobUmZMFoo4upLJMfKnsn/o4rK67dqltNcAv7LvHwBskh5QsvjGDORskxFCAf5DP0VanEh3Lo
 rUS1ah7PpNUuXylE6GbDipN3ZccxyRMwE/c+z2kI7sBaWLh8QohWDZkIHPrgV2z3SkZ5IUaO9ZJ
 6rxsBt3+FNmMlCFGr15VBVR4HlZHgaoNwiAjq0LGwFOlsUmukrHGYRZpYH73vv1O2ElkmAYkGXM
 hD9T6XhY3ApJHsb1+5LAh/XdfsEqnzn4XGHEgnPnyWhBfnASK154lDWzpveBB+BoPYJFBr1BO7g
 a0f+ktqWWG/l4NCHgrQ==
X-Authority-Analysis: v=2.4 cv=FsY1OWrq c=1 sm=1 tr=0 ts=69d7c1e5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=22Kss3EB1pa1Nrv1dqcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: aDd_-Ky-p2Z9yF49ukj68WwYtmVMfNCB
X-Proofpoint-GUID: aDd_-Ky-p2Z9yF49ukj68WwYtmVMfNCB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1011 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090135

Imporve synchronization and cleanup logic in the fc_remove_host() and
fc_rport_final_delete() to prevent use-after-free conditions during
host removal

Vport cleanup:
   - Mark all vports with FC_VPORT_DELETING under lock
   - Cancel all vport work synchronously before removing from the list
   - Synchronous deletion with fc_vport_terminate()

Rport cleanup, applied to rports and rport_binding
   - Mark all rport with FC_PORTSTATE_DELETED under lock
   - Cancel all timers and work synchronously before removing from the list
   - Call fc_rport_final_delete() synchronously instead of queuing

fc_rport_final_delete():
   - Calling cancel_delayed_work_sync() for any outstanding delayed work
   - Clear FC_RPORT_DEVLOSS_PENDING under lock
   - Flushing all pending work completes before destruction

Signed-off-by: Thinh Tran <thinhtr@linux.ibm.com>
Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
---
  drivers/scsi/scsi_transport_fc.c | 85 ++++++++++++++++++++++++--------
  1 file changed, 64 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c 
b/drivers/scsi/scsi_transport_fc.c
index 123b22b52640..0adb9330befc 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -39,6 +39,7 @@ static void fc_li_stats_update(u16 event_type,
  static void fc_delivery_stats_update(u32 reason_code,
  				     struct fc_fpin_stats *stats);
  static void fc_cn_stats_update(u16 event_type, struct fc_fpin_stats 
*stats);
+static void fc_rport_final_delete(struct work_struct *work);

  /*
   * Module Parameters
@@ -2883,31 +2884,71 @@ fc_remove_host(struct Scsi_Host *shost)
  	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
  	unsigned long flags;

-	spin_lock_irqsave(shost->host_lock, flags);
-
  	/* Remove any vports */
+	/* Mark FC_VPORT_DELETING for now */
+	spin_lock_irqsave(shost->host_lock, flags);
  	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers) {
  		vport->flags |= FC_VPORT_DELETING;
-		fc_queue_work(shost, &vport->vport_delete_work);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	/*
+	 * remove all vport works synchronously BEFORE removing from list.
+	 * This prevents use-after-free when timers fire.
+	 */
+	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers) {
+		/* Cancel any pending work/timers */
+		cancel_work_sync(&vport->vport_delete_work);
+		/* Now safe to do synchronous deletion */
+		fc_vport_terminate(vport);
  	}

  	/* Remove any remote ports */
+	/* Mark rports and rport_bindings with FC_PORTSTATE_DELETED for now */
+	spin_lock_irqsave(shost->host_lock, flags);
  	list_for_each_entry_safe(rport, next_rport,
  			&fc_host->rports, peers) {
-		list_del(&rport->peers);
  		rport->port_state = FC_PORTSTATE_DELETED;
-		fc_queue_work(shost, &rport->rport_delete_work);
  	}

  	list_for_each_entry_safe(rport, next_rport,
  			&fc_host->rport_bindings, peers) {
-		list_del(&rport->peers);
  		rport->port_state = FC_PORTSTATE_DELETED;
-		fc_queue_work(shost, &rport->rport_delete_work);
  	}
-
  	spin_unlock_irqrestore(shost->host_lock, flags);

+	list_for_each_entry_safe(rport, next_rport,
+			&fc_host->rports, peers) {
+		/* Cancel ALL timers and work before removing from list */
+		cancel_delayed_work_sync(&rport->fail_io_work);
+		cancel_delayed_work_sync(&rport->dev_loss_work);
+		cancel_work_sync(&rport->scan_work);
+		cancel_work_sync(&rport->stgt_delete_work);
+
+		spin_lock_irqsave(shost->host_lock, flags);
+		list_del(&rport->peers);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
+		/* Now safe to do final deletion synchronously */
+		fc_rport_final_delete(&rport->rport_delete_work);
+	}
+
+	list_for_each_entry_safe(rport, next_rport,
+			&fc_host->rport_bindings, peers) {
+		/* Cancel ALL timers and work before removing from list */
+		cancel_delayed_work_sync(&rport->fail_io_work);
+		cancel_delayed_work_sync(&rport->dev_loss_work);
+		cancel_work_sync(&rport->scan_work);
+		cancel_work_sync(&rport->stgt_delete_work);
+
+		spin_lock_irqsave(shost->host_lock, flags);
+		list_del(&rport->peers);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
+		/* Now safe to do final deletion synchronously */
+		fc_rport_final_delete(&rport->rport_delete_work);
+	}
+
  	/* flush all scan work items */
  	scsi_flush_work(shost);

@@ -2983,21 +3024,22 @@ fc_rport_final_delete(struct work_struct *work)
  		scsi_flush_work(shost);

  	/*
-	 * Cancel any outstanding timers. These should really exist
-	 * only when rmmod'ing the LLDD and we're asking for
-	 * immediate termination of the rports
+	 * Cancel any outstanding delayed work synchronously.
+	 * This must be done BEFORE taking spinlock and BEFORE
+	 * any state changes, as cancel_delayed_work_sync() can sleep.
+	 *
+	 * These timers should only exist when rmmod'ing the LLDD
+	 * and we're asking for immediate termination of rports.
+	 */
+	cancel_delayed_work_sync(&rport->fail_io_work);
+	cancel_delayed_work_sync(&rport->dev_loss_work);
+	cancel_work_sync(&rport->scan_work);
+	/*
+	 * Now safe to clear the flag under spinlock since all
+	 * async work has been cancelled.
  	 */
  	spin_lock_irqsave(shost->host_lock, flags);
-	if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		if (!cancel_delayed_work(&rport->fail_io_work))
-			fc_flush_devloss(shost, rport);
-		if (!cancel_delayed_work(&rport->dev_loss_work))
-			fc_flush_devloss(shost, rport);
-		cancel_work_sync(&rport->scan_work);
-		spin_lock_irqsave(shost->host_lock, flags);
-		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
-	}
+	rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
  	spin_unlock_irqrestore(shost->host_lock, flags);

  	/* Delete SCSI target and sdevs */
@@ -3027,6 +3069,7 @@ fc_rport_final_delete(struct work_struct *work)
  	if (rport->devloss_work_q) {
  		work_q = rport->devloss_work_q;
  		rport->devloss_work_q = NULL;
+		flush_workqueue(work_q);
  		destroy_workqueue(work_q);
  	}

-- 
2.52.0
