Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05912345CCD;
	Thu, 23 Jul 2026 00:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764943; cv=none; b=cm9czoJTN6iszx1lkzN7UUEafsLonp5mKDpc2ws/LIcMUSTg7HHYZIi/ovJInEpZTFSkt1WVC+ZqjndIuTk0wqLdyP3kH+iRW+gOBu7J9ZJ0yDLGSRKkdg2xRL3tJxEXHBlZsVPpIzNGEHHdYD++kaEwBwF9mXAkGVERx7RfsTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764943; c=relaxed/simple;
	bh=WL8UtzZJOquC24h2gENxNAvtjVtt3xfjNx0cQPYT9dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQO/CiEDMuyQXIAxnQxRyv6E1SNxx37bI3Kzi7LK7fmdoweMaSc4xpAYan2fiHB1XVwBR9CDRI+Kwi5CfRmmpCPzYqgZxl/B+zcJ9Q+QljRpgZenBsqdpJpX43e0REDAydKcwmM514DAHZsEXITiPOr0MIQL09ZR5R+dQU/OJsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PN6fbfy3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PN6fbfy3"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBns73019780;
	Thu, 23 Jul 2026 00:02:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=prEuV7/AAc0CjuGGx
	kQjee3pUkxluMCOrWRD5NpLvvA=; b=PN6fbfy3DBg2GCvMf2tzg82rJom/cV7Ir
	O6K3u3IfLhclGzPJXq4kG7n/dyvGUUdqP8qOLZteYHhJbx6LkWwzUCdsXtfILcPN
	e5FTeKyMShGJP10Z7cjeU9E/xu2lSRfG5anMtHtqkittMeSm+0ODnURpM0gJ8qAH
	zqkSFq7gaqzuUKLlRkwQ46zLU+D7PhZIKxdo6uvayGBexusAr9AsyIij3HOdZoPs
	kkpZiTZH4U9OvouO5wa7mfSuhF7nVchPIPUl1vfS8bupc2DtaHXjrfvz6HPfUnd3
	emV1t+EyQf51WuRCERFfKmQ/mWEMROb+fj2nBnyd45Q56Q3gXb++Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg77amx6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnaIL028159;
	Thu, 23 Jul 2026 00:02:13 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgnah9q3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:13 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N02C2D7734206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:12 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48ED258061;
	Thu, 23 Jul 2026 00:02:12 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A48495803F;
	Thu, 23 Jul 2026 00:02:11 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:11 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 25/33] ibmvfc: process NVMe/FC rports in work thread
Date: Wed, 22 Jul 2026 17:01:41 -0700
Message-ID: <20260723000149.969416-26-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723000149.969416-1-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9hwfmNY976NPE6pKKMAuov4NsjuG-uON
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX2Xlq+pwi3Ef/
 P+bowW88g6w7lDmMUGbzaHpLC00XVYvVSNTvr04svoUz/P3DAwRa+O4Jdk/GBXxL+P88pq0J5nc
 3a5OfbSunnUtLat7V+oYeT91CAiDEJ4=
X-Proofpoint-GUID: 9hwfmNY976NPE6pKKMAuov4NsjuG-uON
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX0nHCComSBsHB
 ZOqis5D0KJEislV2UmD7IDI7HOuHRdIIVV32g8zXyCEtNLKiO/sJ6KTDdSfqGV8Fv1DPpmaF87W
 cwk8WD/gHf26mvU53YBUzeGEYVCyznLTLsWt7fE7GmutJNweDKfvJL1JYVLgHhihpEZQpxE6+8l
 PvHdjqdWYyQSJy7LFSL/fOxAbUaLGxlthBHLjZ6V5+UboXRSyOH8Ok8Id1Lz2lTWf5Ky6trEb+i
 ZjXTADv3cLPa9x5TGPIAyuGbfglEsEBG/uSm/FUPwdxhjTjqO860GNAm5epPwTjGuLHTFYZCt4S
 XnPtx1xEJNhkE08PaJK+yZG6Nz64MGF2CEm6YPAEGQDT+j7GUmScTqR8xwgqxLMCnulVh1PgppZ
 5upBmjr8tYt1f1uAp5Dsy1gsczQ4hA5ONMnEpkG2rDSwAIUr5Jd//nZVigvgFLvKxJg7OkMEKgO
 00Cvr/Whi2L3zJHobyQ==
X-Authority-Analysis: v=2.4 cv=K7AS2SWI c=1 sm=1 tr=0 ts=6a615a07 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=YKckqcwGcxMuMPRTqGAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607220234

Add an NVMe-specific remote-port add helper and update the rport worker
thread to walk the NVMe target list, register new NVMe remote ports, and
rescan existing ones through the NVMe-FC midlayer. Also handle delete
and delete-with-logout transitions for NVMe remote ports in the same
worker context used for SCSI rports.

This keeps remote-port registration serialized in the existing worker
model while allowing NVMe targets to participate in the common target
state machine.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 94 ++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 81d9229bf388..ffb579816e84 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -5856,6 +5856,51 @@ static void ibmvfc_log_ae(struct ibmvfc_host *vhost, int events)
 		fc_host_post_event(vhost->host, fc_get_event_number(), FCH_EVT_LINKUP, 0);
 }
 
+/**
+ * ibmvfc_tgt_add_nvme_rport - Tell the FC transport about a new remote port
+ * @tgt:		ibmvfc target struct
+ *
+ **/
+static void ibmvfc_tgt_add_nvme_rport(struct ibmvfc_target *tgt)
+{
+	struct ibmvfc_host *vhost = tgt->vhost;
+	struct nvme_fc_remote_port *rport;
+	unsigned long flags;
+
+	tgt_dbg(tgt, "Adding NVMe rport\n");
+	ibmvfc_nvme_register_remoteport(tgt);
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	rport = tgt->nvme_remote_port;
+
+	if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
+		tgt_dbg(tgt, "Deleting NVMe rport\n");
+		list_del(&tgt->queue);
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		ibmvfc_nvme_unregister_remoteport(tgt);
+		timer_delete_sync(&tgt->timer);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		return;
+	} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
+		tgt_dbg(tgt, "Deleting NVMe rport with outstanding I/O\n");
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
+		tgt->init_retries = 0;
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		ibmvfc_nvme_unregister_remoteport(tgt);
+		return;
+	} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DELETED_RPORT) {
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		return;
+	}
+
+	if (rport) {
+		tgt_dbg(tgt, "NVMe rport add succeeded\n");
+		tgt->target_id = tgt->nvme_remote_port->port_id;
+	} else
+		tgt_dbg(tgt, "NVMe rport add failed\n");
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+}
+
 /**
  * ibmvfc_tgt_add_rport - Tell the FC transport about a new remote port
  * @tgt:		ibmvfc target struct
@@ -5920,6 +5965,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 	struct ibmvfc_target *tgt;
 	unsigned long flags;
 	struct fc_rport *rport;
+	struct nvme_fc_remote_port *nvme_rport;
 	LIST_HEAD(purge);
 	int rc;
 
@@ -6073,6 +6119,30 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 			}
 		}
 
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
+			if (tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
+				tgt_dbg(tgt, "Deleteing NVMe rport\n");
+				nvme_rport = tgt->nvme_remote_port;
+				list_del(&tgt->queue);
+				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
+				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				if (nvme_rport)
+					ibmvfc_nvme_unregister_remoteport(tgt);
+				timer_delete_sync(&tgt->timer);
+				kref_put(&tgt->kref, ibmvfc_release_tgt);
+				return;
+			} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
+				tgt_dbg(tgt, "Deleting NVMe rport with outstanding I/O\n");
+				nvme_rport = tgt->nvme_remote_port;
+				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
+				tgt->init_retries = 0;
+				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				if (nvme_rport)
+					ibmvfc_nvme_unregister_remoteport(tgt);
+				return;
+			}
+		}
+
 		if (vhost->state == IBMVFC_INITIALIZING) {
 			if (vhost->action == IBMVFC_HOST_ACTION_TGT_DEL_FAILED) {
 				if (vhost->reinit) {
@@ -6658,6 +6728,7 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 						 rport_add_work_q);
 	struct ibmvfc_target *tgt;
 	struct fc_rport *rport;
+	struct nvme_fc_remote_port *nvme_rport;
 	unsigned long flags;
 	int did_work;
 
@@ -6691,7 +6762,28 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 				break;
 			}
 		}
-	} while(did_work);
+
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
+			if (tgt->add_rport) {
+				did_work = 1;
+				tgt->add_rport = 0;
+				kref_get(&tgt->kref);
+				nvme_rport = tgt->nvme_remote_port;
+				if (!nvme_rport) {
+					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					ibmvfc_tgt_add_nvme_rport(tgt);
+				} else {
+					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					if (IS_ENABLED(CONFIG_NVME_FC))
+						nvme_fc_rescan_remoteport(nvme_rport);
+				}
+
+				kref_put(&tgt->kref, ibmvfc_release_tgt);
+				spin_lock_irqsave(vhost->host->host_lock, flags);
+				break;
+			}
+		}
+	} while (did_work);
 
 	if (vhost->state == IBMVFC_ACTIVE)
 		vhost->scan_complete = 1;
-- 
2.55.0

