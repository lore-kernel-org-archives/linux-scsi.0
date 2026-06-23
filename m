Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE56389DF3;
	Tue, 23 Jun 2026 01:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178265; cv=none; b=o/N1LJ5dge80o4WeBpe3dmBrclrAZJYnyEcvW4lt+McaRIV9Y0DUth4voB5WF/xNKSxv1R5wJuDk9kzWhnu3g0gVTkbrfPxA/Y23vd13TOKWTKaSH4OmXFXA+xis1iPzDcgxNJZNpPc8aQ8EdtEsuuGr7cBbgd71fHN0GyCEH4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178265; c=relaxed/simple;
	bh=ztrT3cakJSPpI+apeeh50NIcTp0GnCafim4XAUmaPts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLUpXIgbpAaZlweyNTondiQLlgZJR+LTgbApYxTAYkl0E3ms4GkYQv6B7thxquwy9b2LKvhMN2cBtdpIS1EJd9Ok7HAg6IcKkzQBk4nJWmzLbAY30ByeWvspxtOarC79BpASbnEwj7VN0jnCa0LxLH1LPepyXQHlk7fjYMZgWsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fl6DwObA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fl6DwObA"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0ntaX348171;
	Tue, 23 Jun 2026 01:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xC7QZzMElpuJCX56O
	0jsNZLGyKcogZ+K9c/7NQjNcgY=; b=fl6DwObA78YaJHK4Xexuuk4Hyqp8Qv6QO
	W43465GmFJuJhtTqRBYsAY3wuThDnKz9pTgOYS5hScxXm2XDs9qs9e4lTXBJYH51
	Ncl8jXTYdX0s2ed1La5/radwyw+Yvmf/dYtTZ5EANeY15UZ3ddTjkEReUDeLAd+z
	Ti6GVBC2zQSLR93z/4xKPf77gBHQOfCs4jYNex9kis2UITQ5fIVbho6pEM6R3x3R
	j5Toy4boycw2NsmFnG5DkSdf7A48BMJLFaGs73UT+G15YlTUcIrwmJlG9k56BInh
	g/UvUJFXojt8YSCoNH69yPiSd+voss2UtU56WScSF9OQtbOL+pfmQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewh9gc43a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JhBX027950;
	Tue, 23 Jun 2026 01:30:51 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex66k0xyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:50 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UnVA33227338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:49 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C077858052;
	Tue, 23 Jun 2026 01:30:49 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C8975805A;
	Tue, 23 Jun 2026 01:30:49 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:49 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 16/29] ibmvfc: allocate targets based on protocol
Date: Mon, 22 Jun 2026 18:30:22 -0700
Message-ID: <20260623013035.3436640-17-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dIenK6If9aaW7x5OBoNjT2y2heGJh3Ei
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfXxZzRkH1yKJjG
 5SDT9a8gGOcsCWByNy5wVePuvfNKAt93O4DQXPT/5nyca61ur5h82TxfxS74wM1LfOpNcmIMaG7
 l07PNdSho+yZbUI2pV4oGlkfWxD8RkE=
X-Authority-Analysis: v=2.4 cv=c62bhx9l c=1 sm=1 tr=0 ts=6a39e1cb cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=ns_GeCvhB5WbLELA1zwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX8vVwPONTi6Mv
 QorhIjNY07RZILWxNoaiA03ucrIJvq5Nr5Ct6LpEozUakewfp3tLXAoDVN0c/S2TmCTXeB7J1hy
 JCymzg29IYNGjmB2GbbkGEUi6Hqhwlwp2IWVI47p5TtSbGG16Uag1WorrBiCEvp/Yom3KlZ2mOO
 jwWimKAWe8A3AYikjEpbOLsmn1sOOj9rI7ZZF7cVyhS4DGbssKli5bvN7ppnx9wXTbBFD7szil5
 kQdx+W2rewwTRJPhe9wA0L9lp4lEqupU6gXDAKwoWm59Pku2ArJi1Ygnt/Gdf3egIrCS39MnXpv
 9fdPwURGqbEqtU0tvvEFb0f4ct0tW6D+vQ4sPtzjRERf3DFDuM1+sD2/hPWwuhKWOBfuFm2x5nq
 1HRl+alw392A0+NZ3GX5Tl2fPndVfvBc30uMdabmme+DNkFmsELPM4WzZYMesqK0WlvTx3wXzO0
 pMLP1U/pMCRyl5q0vzg==
X-Proofpoint-ORIG-GUID: dIenK6If9aaW7x5OBoNjT2y2heGJh3Ei
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

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
index 363bf75d6244..4b95e4344947 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4938,25 +4938,32 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_target *tgt)
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
@@ -5004,6 +5011,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 
 	tgt = mempool_alloc(vhost->tgt_pool, GFP_NOIO);
 	memset(tgt, 0, sizeof(*tgt));
+	tgt->protocol = protocol;
 	tgt->scsi_id = scsi_id;
 	tgt->wwpn = wwpn;
 	tgt->vhost = vhost;
@@ -5013,7 +5021,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 	ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	tgt->cancel_key = vhost->task_set++;
-	list_add_tail(&tgt->queue, &vhost->scsi_scrqs.targets);
+	list_add_tail(&tgt->queue, &channels->targets);
 
 unlock_out:
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
@@ -5032,7 +5040,11 @@ static int ibmvfc_alloc_targets(struct ibmvfc_host *vhost)
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
2.54.0

