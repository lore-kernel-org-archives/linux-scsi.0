Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F110E1F4631;
	Thu, 23 Jul 2026 00:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764928; cv=none; b=hKbG8CcBwiRtH1JZkDKTQW9hUVr5s1vLhwNaLjvJCbzzpZ9dLmGd8DTh1oOMlGSVLGQDFIANm0QwIAZq7Owt0ACju1u38914jKPGIy55CRervtytL4Bob+Ga6IPHYBLFvuic4Ye+jav5YWCo8TL61uxD54rxpEFehpyxbx3qb/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764928; c=relaxed/simple;
	bh=4vf3RRREXqzKtN4RWv4dL/+lZvU8ttDaMKRwI4K+JXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbVqlJ5xEfYyi7iKdBAI2/gTgbb0wkG5wLtE3Z8HS2BpCsoghOu7zI6Rv7+DPqk+ytKEzWFTNSAOw1so2wf5hu3ZlWyddFkwBo/1d+Clpd/g9PohH1PBZOK2DoWWYiOvNg9GzTlCPsD3zuUkn5ZRDlqVFqCHkdLDDOV6MPWcn1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PQNrBeCX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PQNrBeCX"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBopq704742;
	Thu, 23 Jul 2026 00:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/0ALfZUO8FIrmuzVJ
	zhsUTrsPYLDqHKPAEdKzBn6xE8=; b=PQNrBeCXj/J6cvvVU3/KVpJP01uJyMHhC
	okM+1NDSz3whCeqnznHJQRVz47/mix5U/7dlifuGWEhK65HD/D4PyZWytRtb/XVo
	g0LnJwp30MoUWCe1N18/FFp9VEIHXCtU2hO2E3ZjwGdx+rsRccUhRl6NyUaJvL8K
	ImM2JR1XJuDfajZlxQRhpmkndetluqQ5zOf5GDdVZiunVyXJYUqBr9pA+jZsCcvy
	M7JhSmbbLipLKJRBmVprf3tzEHPdZsmBsBdaCXACfq/8VryWFlm1vUEF0x5X5HUA
	xYBq1ov+RFljRT4FjK+dXqt5w1w9HeyXeVel/A3W8O8/tSVDvEe6Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abmymt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:01:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnfg7032317;
	Thu, 23 Jul 2026 00:01:57 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgmtk1rrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:01:57 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N01tEk44368196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:01:56 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6AC858061;
	Thu, 23 Jul 2026 00:01:55 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1216D5806A;
	Thu, 23 Jul 2026 00:01:55 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:01:54 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 03/33] ibmvfc: check for NULL evt in implicit LOGO and target delete path
Date: Wed, 22 Jul 2026 17:01:19 -0700
Message-ID: <20260723000149.969416-4-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfXxdFPVYwve6Ur
 Xj1yYyI1vfaMb9/WalGd+X7Lw2ZoLkOn6T/m4EJOazOqArSYXuo3KEJf4EzZJwT5JHoa1QxIVu3
 wX/rOg+7Isc+jStjIqH/cxyZJTrQ2ZlEWCJ5ZIEq7MApAnv9b0M/W0wK1en0jclAWG0Wg3jfcKr
 rL3oI+DadXJeyS1H7cxPHkIP78xeEFr8TNzv99Vf5i2KHyTopZccO911sYZIiXPqQ7T+pGcnQei
 91RtOUXywf32AZVx0t4bb8bHcDEqNEoK9MUzj+KZJjbrAgefLQTmtY0KAc0VdlR9oUkFxsDQGRw
 bt0ThYUiNmvlRIOwV+JpyqGsZZJL0l7oZR/62EMGeE+a2efkyBDpMGNpBSCeAcG9XdJ6B7bSCaP
 NTlTWUhp9XSlIZRjrad8GOxURTSWuJqK0OwzlcZxujGdMVZ9CfcgBDFdEN0vHTVWMA9tVLf5SI3
 Xmb8Pc/eU1g/cE/1BQA==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a6159f6 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=0xhV0qCuJtyj5y_2DJ0A:9
X-Proofpoint-ORIG-GUID: rtMMAuddeTgQsNBS-ACVZIMGPSU53l5d
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX3aXHbBQ5b6m6
 DeBUNPTwc6Z/ygmFT8l3vc3QlbNYEnf9YswqI4qnnqtxCVIJKuA/CCu+EGSnaiC8yKDJ8K5i8tI
 CqQCa8/NX+mCd15Az8vPrNuRcUvC+qc=
X-Proofpoint-GUID: rtMMAuddeTgQsNBS-ACVZIMGPSU53l5d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

Unlike ibmvfc_tgt_implicit_logout the ibmvfc_tgt_implicit_logout_and_del
path fails to check for a NULL evt returned from
ibmvfc_get_reserved_event and passes that directly to ibmvfc_send_event
which will unconditionally derefence the evt.

Check for a NULL evt and perform same escalation as
ibmvfc_implicit_logout.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 72317d7840a5..59102dd1c787 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4406,6 +4406,14 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
 	evt = __ibmvfc_tgt_get_implicit_logout_evt(tgt,
 						   ibmvfc_tgt_implicit_logout_and_del_done);
 
+	if (!evt) {
+		vhost->discovery_threads--;
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
+
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT);
 	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
 		vhost->discovery_threads--;
-- 
2.55.0

