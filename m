Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735EB72627;
	Thu, 23 Jul 2026 00:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764935; cv=none; b=CgjlsRdxQpWaxWdzr292SwkgTifJDzSSANhCDHBmr0OCc5PnYSvKTaEmqmrjcmOJUUur3n2cUqHeWrAn/F8xYpMh/Zzqxee9uIuQYDSsNrsbps9NBk24MVVV+/Av+OezxSe9gdzEdM3rYX8AaY1MJ4VJsZPRNQp3kmI6kQOxOZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764935; c=relaxed/simple;
	bh=hcaP+UUhsl9paq/noixz2uMopCQ3/VRP+BPfb2yrbAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pujC1HFjmAuHKU1D3uL8irS0m1CZB8WMQwnxh7KYG0e64rnOkVPm4yLTBei9pfXDTNXTO8KBTNsmHJhBkp2c6hbAyO/AWOPOG/XEocQEVVs05fkwbapWd9BBm11AQn/uS1wcn9Qc/g+KiJUJ5pbnTjN5KTcYd5PukPPqjsv4efs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k1GlJGjS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k1GlJGjS"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIC3q8606747;
	Thu, 23 Jul 2026 00:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=caN6QTCi3vodLwzr/
	GXf+fo/2yOLoAia6bLAva7bBsE=; b=k1GlJGjSy5pJXEmRiST50gCT+gHo21Fhz
	D7P4buoPhQV1afEtkEpYGpxIF94GIM8UyUgcALh6Ju5rTV4YoWy6h2p3e+fCpAWj
	EiVQpYbj8A0oikM8cTU062fu8HZLlITCSyEEXuCJB6QGPGX8SV+GAj03nAyheN9j
	Umh5wWtqoh1V0xVSwkY3qezBL+eHWBTXk84dUHkizxK40oVJMnvvpPMloqWmc/Hv
	Oayv4C23jjdkijsRujLiyqs587dKC2IaJVws6vvk2R4dAOzFNXOrIilvPSnWdY84
	dv8dthaQzjPgR2HVnxWdgbagbL6xEta2B6gOa+gVbUBnz4xKH+2Dw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg78gcc0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNneRT032303;
	Thu, 23 Jul 2026 00:02:10 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgmtk1rsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:10 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N028IG24969790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:08 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7DE735805A;
	Thu, 23 Jul 2026 00:02:08 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D61505803F;
	Thu, 23 Jul 2026 00:02:07 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:07 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 20/33] ibmvfc: allocate targets based on protocol
Date: Wed, 22 Jul 2026 17:01:36 -0700
Message-ID: <20260723000149.969416-21-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfXyxioiXmttTlr
 v0xuXD87UmofymsIlP3LCN7GgwqpG2ejRy5wQSr1i7gzjp4FgcIOJjTUJBb83SsbhpLD4P3ChXV
 2tPAZgrvPH8mRYkVITr164Yd14N84SyHSvh5ju1aesMso/krL2E2rTVa2BjV5hH6sMLTNsYeXB1
 ubct/zxpT87eDHLPGhQ7aSBmdf2f21kWOaZ8ZAofwufLpF8k3uG3HIb7KN0wwTY9RtVHfXOh7iK
 5ZxU5bI9WWe1XWC4fzs7n+Djg2qdXPGjSNz3LQtA849dJbRwlpO/p1mkPvSovgEutsm2wNBgLOT
 /gdk4ooUPEM0UwSTdiBtEP0AdvcBqxkWl8Vum7wm4p83ss9ejn7VeZpA8CcGULgHAhfPJeyoDpL
 tHHL1yLCQbJjZAT0KRQM0rnsZh1RGmwhFFdgbiB/NxPutpG/lZDpZJ2gjiLrY7qteHtULBYYveV
 P00m1mB8viJjjL7Zdxg==
X-Proofpoint-GUID: u-_bKvDAHzfNUjaj9tgowUoBS9cTsJ-K
X-Authority-Analysis: v=2.4 cv=MelcfZ/f c=1 sm=1 tr=0 ts=6a615a02 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=ns_GeCvhB5WbLELA1zwA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfXzRvFP3L55BUg
 3z2Am4gl0NbPgoZzHhnpl66U9aw9cma5lWtr8XELtpNjrbu4GtAW7EwcNlNaER38j0HdQQfSUos
 jMEMJmPk4vLygXPIhfv6EZvFNzm4O3g=
X-Proofpoint-ORIG-GUID: u-_bKvDAHzfNUjaj9tgowUoBS9cTsJ-K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

Allocate discovered targets onto the channel-group list that matches
their protocol.

When a target is created, use the discovered protocol type to decide
which list it belongs on. This keeps protocol-specific discovery
results isolated and allows later state-machine and remote-port code to
walk the correct target set.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index b479537e9e78..92c286cfc69c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4948,25 +4948,32 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_target *tgt)
  *	0 on success / other on failure
  **/
 static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
-			       struct ibmvfc_discover_targets_entry *target)
+			       struct ibmvfc_discover_targets_entry *target,
+			       enum ibmvfc_protocol protocol)
 {
 	struct ibmvfc_target *stgt = NULL;
 	struct ibmvfc_target *wtgt = NULL;
 	struct ibmvfc_target *tgt;
+	struct ibmvfc_channels *channels;
 	unsigned long flags;
 	u64 scsi_id = be32_to_cpu(target->scsi_id) & IBMVFC_DISC_TGT_SCSI_ID_MASK;
 	u64 wwpn = be64_to_cpu(target->wwpn);
 
+	if (protocol == IBMVFC_PROTO_SCSI)
+		channels = &vhost->scsi_scrqs;
+	else
+		channels = &vhost->nvme_scrqs;
+
 	/* Look to see if we already have a target allocated for this SCSI ID or WWPN */
 	spin_lock_irqsave(vhost->host->host_lock, flags);
-	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
+	list_for_each_entry(tgt, &channels->targets, queue) {
 		if (tgt->wwpn == wwpn) {
 			wtgt = tgt;
 			break;
 		}
 	}
 
-	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
+	list_for_each_entry(tgt, &channels->targets, queue) {
 		if (tgt->scsi_id == scsi_id) {
 			stgt = tgt;
 			break;
@@ -5014,6 +5021,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 
 	tgt = mempool_alloc(vhost->tgt_pool, GFP_NOIO);
 	memset(tgt, 0, sizeof(*tgt));
+	tgt->protocol = protocol;
 	tgt->scsi_id = scsi_id;
 	tgt->wwpn = wwpn;
 	tgt->vhost = vhost;
@@ -5023,7 +5031,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 	ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	tgt->cancel_key = vhost->task_set++;
-	list_add_tail(&tgt->queue, &vhost->scsi_scrqs.targets);
+	list_add_tail(&tgt->queue, &channels->targets);
 
 unlock_out:
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
@@ -5042,7 +5050,11 @@ static int ibmvfc_alloc_targets(struct ibmvfc_host *vhost)
 	int i, rc;
 
 	for (i = 0, rc = 0; !rc && i < vhost->scsi_scrqs.num_targets; i++)
-		rc = ibmvfc_alloc_target(vhost, &vhost->scsi_scrqs.disc_buf[i]);
+		rc = ibmvfc_alloc_target(vhost, &vhost->scsi_scrqs.disc_buf[i],
+					 vhost->scsi_scrqs.protocol);
+	for (i = 0; !rc && i < vhost->nvme_scrqs.num_targets; i++)
+		rc = ibmvfc_alloc_target(vhost, &vhost->nvme_scrqs.disc_buf[i],
+					 vhost->nvme_scrqs.protocol);
 
 	return rc;
 }
-- 
2.55.0

