Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D2A3D6CD7;
	Sat, 19 Sep 2026 01:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781611; cv=none; b=heIyey0k/6UpRp9wEulD4ALP26gWgRReXtVdafv1OwdczuRbOXSyca+lDYlcIC+DshSiKuocmIdxd2znlmFGGDbyyZFrXQQPnR5R9MChmNm11K3G65tVYA90dfh3O9zRzGcRzmSWjQ+j1AXngtPNLpcwz7LarUzWKvLkMe8LRqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781611; c=relaxed/simple;
	bh=3N0BBBAIWWwzinPxlFGHJkd00N24takfsezsphafKWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lk+iBlXvr2ursaebQFse2XCDoXHjq6M4OWbf4YF8czofiPT8suNeJ7RGd6n1qimUdVL3Kec2q5S8YdornGZOfdBgPK/0DkZQtIb/z1tVHE6PGN9pOFrvOAW+sdBIMPQP10YCuRpSt/oA+Va0KL89kShtaUON+yFfn+KeWQlijVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dRY8rmGo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dRY8rmGo"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J01hQZ2706787;
	Sat, 19 Sep 2026 01:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=llwZb5OCLq0KkdUtj
	amKkQk9o94eDlYi1wOUetAKnc4=; b=dRY8rmGoag93DyBXrltROeZ9WxFTW7EiZ
	iK0xSlcePl9N4lCn+nKwo3Onw61JLRhCHIKjJklTUQcpSfAvbGcPRYzHDxISJ/ez
	wKZdxWZ3PVtmivIJXYTNNdGxmF358K9gL9mIbPbzLYvcbOnAwMt0M99oZU6lawJg
	ZcdSer4MVcxxB2/GZwsj8Daabq4JCSANbQNIqq2G49Qd+NPhvhbIYs5nNo1Cbmoz
	TZ/ca5Rba+6z1oWvghwYXo+1CH9Qw7Ht2oMDud9swilByWPsrQV1YnFOBzYcDGco
	5iqATcyixYBu4H/ZAH1nYZwnRjj/H4eMPmTvG5R6k6cZUMAqOU/nQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcvj9mk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1TIsR1629848;
	Sat, 19 Sep 2026 01:33:22 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gsgsar08k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:22 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XKjA48169230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:20 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D024D5805E;
	Sat, 19 Sep 2026 01:33:20 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F7495805A;
	Sat, 19 Sep 2026 01:33:20 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:20 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 13/20] scsi: ibmvfc: make NVMe FCP abort callback asynchronous
Date: Fri, 18 Sep 2026 18:32:59 -0700
Message-ID: <20260919013306.2948028-14-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX8DDUcCCEOpOO
 Vr6ZuIvr+9668zP4GcF/PW+Ok2uR8loARiQdjdduGsp1omIvz/SWVUzZCzjqkIulo860clV6pZK
 gPcbxkCz7uEmAZnB7K9DzALd4aAeCN4=
X-Proofpoint-ORIG-GUID: zLVPODVZ0ZNYkMTxzlathI0oPpVuqlWY
X-Proofpoint-GUID: zLVPODVZ0ZNYkMTxzlathI0oPpVuqlWY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX3+lTZBbKi7k9
 azOELxsba0aka58qd/av7+5fUUe+lWNjhP2Ug/Vt5i2Zu8K+Qndb0VHZY/J8EfDRs12jXb6x0b6
 AGjQPInFCHWtz10fEO+sVDvKtOx0P07F5RRa/FZ7JjTiZgH6RxoGaiWf85bG0+vXliuud1xCFIc
 BTnkqY5bmqwvfalXb72E/i5HMzr8y4LnQEBxYwx/W4KFKFoTFE9weLM0sSdeap9PlZUYSiYT9mk
 D7bnv6ccCuWJVY1RCjnnsboEm+ZktOKk8irL6OxlMt0VapNu77liK4cC56wU/DFLZGeF1R5TzEj
 K4gfl5lMHlRZPxig+epUvSccVcWiC2DnUGJN4fjdauqzpC6y9UQFjdZU6O/GBfQQmPdPgjKnT/l
 YvO2EY/ec/9uDZ9Jue3I0ACInHiDnvgkh2eN8USVo508KMccf/OI1L/sWbn8fKOFGGvvF9isGR5
 EQSNL077indkMqOksRA==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aade662 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=bHZ0--RjxAHeecJfWq4A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

The nvme_fc_port_template fcp_abort callback is called by the NVMe-FC
transport from the block layer timeout workqueue. The current
implementation submits a cancel MAD and then blocks on
wait_for_completion() until the VIOS response arrives. This stalls the
timeout workqueue for the full MAD round-trip, preventing any other I/O
timeout from being processed in the meantime.

The nvme-fc-driver.h API contract is explicit: the LLDD must initiate
the abort and return immediately; the ABTS does not need to be complete
on return. The transport waits for the original exchange to complete
independently via fcp_req->done().

Replace the synchronous ibmvfc_sync_nvme_completion callback with a
dedicated ibmvfc_nvme_fcp_abort_done() that runs asynchronously when
the cancel MAD response arrives. The new callback logs any non-zero MAD
status, drops the target kref, and frees the event. ibmvfc_send_event()
guarantees the done callback is invoked on both success and failure
paths, so event ownership is fully transferred and ibmvfc_nvme_fcp_abort()
returns immediately after ibmvfc_send_event().

Drop the now-unnecessary init_completion() from ibmvfc_init_fcp_abort()
and the sync_iu / wait_for_completion / second lock-cycle from the abort
function itself.

Fixes: 4e70b8795ee3 ("scsi: ibmvfc: implement nvme-fc FCP abort callback")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 34 ++++++++++++-----------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index a6fc9e8a35f6..d23e5f31f8b5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -400,8 +400,18 @@ static void ibmvfc_init_fcp_abort(struct ibmvfc_event *evt,
 	tmf->target_wwpn = cpu_to_be64(tgt->wwpn);
 	tmf->assoc_id = cpu_to_be64(tgt->assoc_id);
 	tmf->task_tag = cpu_to_be64((u64)abt_evt);
+}
 
-	init_completion(&evt->comp);
+static void ibmvfc_nvme_fcp_abort_done(struct ibmvfc_event *evt)
+{
+	u16 status = be16_to_cpu(evt->xfer_iu->mad_common.status);
+
+	if (status)
+		ibmvfc_dbg(evt->vhost, "fcp_abort: cancel MAD failed with rc=%x\n",
+			   status);
+
+	kref_put(&evt->tgt->kref, ibmvfc_release_tgt);
+	ibmvfc_free_event(evt);
 }
 
 static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
@@ -413,9 +423,7 @@ static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	struct ibmvfc_target *tgt = rport->private;
 	struct ibmvfc_event *evt, *abt_evt = abort_req->private;
 	struct ibmvfc_queue *queue;
-	union ibmvfc_iu rsp;
 	unsigned long flags;
-	u16 status = 0;
 
 	if (!abt_evt)
 		return;
@@ -430,27 +438,13 @@ static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 
 	spin_lock_irqsave(queue->q_lock, flags);
 	kref_get(&tgt->kref);
-	ibmvfc_init_event(evt, ibmvfc_sync_nvme_completion, IBMVFC_MAD_FORMAT);
+	ibmvfc_init_event(evt, ibmvfc_nvme_fcp_abort_done, IBMVFC_MAD_FORMAT);
 	ibmvfc_init_fcp_abort(evt, abort_req);
-	evt->sync_iu = &rsp;
+	evt->tgt = tgt;
 
 	if (ibmvfc_send_event(evt, vhost, default_timeout))
-		goto out;
-
-	spin_unlock_irqrestore(queue->q_lock, flags);
-
-	wait_for_completion(&evt->comp);
-	status = be16_to_cpu(rsp.mad_common.status);
-
-	spin_lock_irqsave(queue->q_lock, flags);
-	ibmvfc_free_event(evt);
-out:
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
 	spin_unlock_irqrestore(queue->q_lock, flags);
-
-	if (status)
-		ibmvfc_dbg(vhost, "fcp_abort: cancel failed with rc=%x\n", status);
-
-	kref_put(&tgt->kref, ibmvfc_release_tgt);
 }
 
 static struct nvme_fc_port_template ibmvfc_nvme_fc_transport = {
-- 
2.55.0

