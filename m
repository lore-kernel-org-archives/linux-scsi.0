Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05D33F87E4;
	Thu, 12 Mar 2026 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337390; cv=none; b=QnAS3FdalmcHrZGppwbuBwEeoaV5ACCELQ0lUB0EYiUaLSwDNIxxxXq6L9Ev0fCVQ8BhdFNK90wQaddCsBeomMHz8O7h4YyMIYu2zA6X4p0f64tQ0228TgMS+ijTTK3+auaHQCsFshSvLe+ddHqp51o/qUawIiEty5rjz177LNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337390; c=relaxed/simple;
	bh=rV7hYDYh0vh7ByzQDh7/paYzBSUOZ8W/0rqSdJJbkV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEaUQABtNje3NCh4HrLYCgL5D1Nso0b3qXqRDvwBP+maydr1sSD4C8S0xFX4QhMzdLPxXnda0GmWtIERhK9Ck96Fw0WME/S9DyGIz1Q50J9qfgmtlcXhRN7YaHQQXapwew4MmagLn1nuECnqOc6hvWKGE8TsdjrIfe8PW4ZwJMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N+j2+Rhy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N+j2+Rhy"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62CEJJsp2581579;
	Thu, 12 Mar 2026 17:43:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xHiV9w+d5jY9RB+bX
	U1SSOhAnxXqY0dSDPV0DmaES+4=; b=N+j2+Rhyu79cL0rRxkr3qV+eCUvGGfT2s
	hSwleJDRp3bwtdJeNuMnLDugpEz7XT/avy9iM7Jl8N/7sj5L0uQnIIvPmKixH0HL
	7+8Ryv1cQ34lgKMM1PNfolOEcsP0m21+7ZnLQ1lOm7lLbAej98iXNxtiHK0iPQnH
	u+SQc+j5MxLTMeVL9UYAj1DRz7RizSu+mbny5QmmGHPCnfZL0iFN9nWnmPXez9Ly
	B2XSe7F1hWHxGSpStsRsWQjzzFVEC/6hjathmHZLoKqtKGg0h/wizaxABxhuWndr
	vRpHv/rjwYNeti8iq5qp3KHoo04tV/Pmsay6t9+ETSU8HLFAADQgQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh94v3y9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 17:43:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62CEPjmp025765;
	Thu, 12 Mar 2026 17:43:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha8bd6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 17:43:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CHgvsV60359074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 17:42:57 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 17BF22006C;
	Thu, 12 Mar 2026 17:42:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0D9D20065;
	Thu, 12 Mar 2026 17:42:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 12 Mar 2026 17:42:56 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id CA8D0E0900; Thu, 12 Mar 2026 18:42:56 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v2 2/3] scsi: virtio_scsi: remove unnecessary fn declaration
Date: Thu, 12 Mar 2026 18:42:55 +0100
Message-ID: <20260312174256.1557045-3-jdaley@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260312174256.1557045-1-jdaley@linux.ibm.com>
References: <20260312174256.1557045-1-jdaley@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=QKtlhwLL c=1 sm=1 tr=0 ts=69b2fb25 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=23WZjCL68Duz3tq5-14A:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDE0MSBTYWx0ZWRfX/gQBadpSTGSr
 aY8xXJWDp9Wz2vKPm4c9FZKwTSjhS7iZJ3nZp/KN1SDUW2IF+dAzyf6N11W6a42PYRVjtUH7eo3
 AqYDiALQ17xks0qefBNx/pInPOSeJOUme+e3rR+sJUNsVlEWenIHgnSf6ynGnfHcC/5u6B/ZI6g
 jUrKqqfnEp4NNY1xRQh8CKG14LrwQ0YNBkiFregvv4CIr5G4Tg+shxi2YCK0/+frghVMgixSiIl
 k2cV7RG42PgAEr3G+K3gOE7OTjiLnG7rfeEht6Fet4ot4w0iyWsWQ9k927VZx4MN6rC8AL+JcMp
 y26nrsyQ7ob7I0lPuBJdHEdTVAF3cwooeIEXQQAmROSdmtCtsrE9dtOUjcenk/Y6Lj3oCHEOmtt
 x4UClCm0qWT6hpRTfH17/tbX1TrSAA6JwQ/XbZr0zraOMxaJraqkwiHLZvAcWRTcHs7Uu1pzX+s
 CQtTgTZ2Q1xb8u/GsUg==
X-Proofpoint-ORIG-GUID: v-7gOpwj65IM8HUc-PWF8zYrl8wPAF99
X-Proofpoint-GUID: v-7gOpwj65IM8HUc-PWF8zYrl8wPAF99
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_02,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603120141

virtscsi_handle_event() is not used before its definition, so remove
a prior declaration.

Suggested-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
---
 drivers/scsi/virtio_scsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 982f49bc6c69..6efbeaa30f65 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -233,8 +233,6 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
 };
=20
-static void virtscsi_handle_event(struct work_struct *work);
-
 static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 			       struct virtio_scsi_event_node *event_node)
 {
--=20
2.34.1

