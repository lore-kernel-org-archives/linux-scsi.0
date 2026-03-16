Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E0C3A1A48;
	Mon, 16 Mar 2026 15:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675240; cv=none; b=Q9DfILiqBeNkSqfK4q8zg2peg/aG+jLM1nMYUt0Is0KACM4gQ+Tmuwlj7ThCXam3cFAMQ9pq5k9AzsuXdi5Jom2jhf3h1d12rGBKUF7kWm0Ef6tlajOGs6Fb0H0LEQvOiaD6SqsHBU1wfvMQGOzXkhfQYTX/VZntkQiELOLZOI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675240; c=relaxed/simple;
	bh=wsI/lAbInzKemMINd8sp2hdbpa7iJ0AjRHMIuHIBZy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwHYw6sz8vIEzZ6M4mlHEFw4oozI/OkgzFG0t7+xZmTA98HUkyp2nI/2IPWIJXzcXnmw2Y2SjmLp9ZTHBEbM8c7X7v8mNdqtylvoLWelW6RPL2NYA6r5WTDYo0I1QvLCisPRRys718yj8TypGX2YxTXKmzTU7e9vtARHfcL4SL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ni9iqodh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ni9iqodh"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GEsEYv1106118;
	Mon, 16 Mar 2026 15:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=loamRpzwOR7CpZ1Qb
	KcxzvWTLgiAxBJrtR3Ay8n4uHE=; b=Ni9iqodhRPnLTC8OKqhviadAVt2uwOUQg
	XgURPxl+Zcj5LxqZEOSE1XbvjYt49+2rYI1+QqSoTPJEGFtyB1ETKfzz6bzOtGRD
	OB6BpQKHzFIASlK8Z/rvJp4YxWzTrKEJc4FF1KWPPRYDU8mOSI8SAAy+948GcUFU
	MjfDlVpQcc8r7olVl7Yb0qGyBB9A5V/Q45CNWV77wW1ovX0SNoyLcn6I5GtjuYwZ
	X70ie3kx++Lje0eo6t7vTi9Y+9AKykwZ/Z8efcZrdeQxH/mp41oGdYdXlX4uzWxX
	VJy+PqPiaT9vRrZDpp1EjJ9ja52uiL/V5DgOc+nd7SnHsKzn9Fp6A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvy64gm0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 15:33:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62GBIJdh028459;
	Mon, 16 Mar 2026 15:33:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cwmq154a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 15:33:46 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62GFXg3A47382924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 15:33:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45E652004E;
	Mon, 16 Mar 2026 15:33:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B48A2004B;
	Mon, 16 Mar 2026 15:33:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 16 Mar 2026 15:33:42 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id 05168E03D5; Mon, 16 Mar 2026 16:33:42 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v3 3/3] scsi: virtio_scsi: remove unnecessary fn declaration
Date: Mon, 16 Mar 2026 16:33:41 +0100
Message-ID: <20260316153341.2062278-4-jdaley@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260316153341.2062278-1-jdaley@linux.ibm.com>
References: <20260316153341.2062278-1-jdaley@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DcsjZgl0eYmGCwXJ1ikRdX4bxe7nlL4w
X-Proofpoint-GUID: DcsjZgl0eYmGCwXJ1ikRdX4bxe7nlL4w
X-Authority-Analysis: v=2.4 cv=KYnfcAYD c=1 sm=1 tr=0 ts=69b822db cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=23WZjCL68Duz3tq5-14A:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDExNCBTYWx0ZWRfX0TgtOtMPOzns
 2M/Abw39OoniWTCFzwllcxPLHMnUvxEO00F2NGZc26P5/q0qYfmPDYD13S6RAPgs/vCF14GORGc
 bqdrLednme0GSYnjx0YuHf12LAGIoPnUb855Rx/0Gr3DQZl/qbQTN+aX7q1TvYrhmhoxBz6j5ad
 vA0DEIGLIADuIx4lCRWbBjlMawgLbKdzU4P+4PqXDWkSjqF0zDiHOtrr0H7AOuRRd0yDNs0sitt
 InZ3KkC9y8OLHhrhhXTPh+U/x/etp6g+WM9x6Tn+PMtZbCNDUihk3zJTh6dsjQQq0LRulr3gkdu
 K9G0JRh16PFgMF/l1xnZezMkw6s+uCDAyWjaiSgKiAhZnmyG+4E8+FHudmEfgQS58Hvi2SVzM7r
 ct5292/LUdA/L8IA1wCEAhqWHcgvnLNJwKTrVdgPc/KpTrWW5rhND6aIKJ59XJn0efLyg65vEWr
 ufi0JMkKbSutqv5gPaA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 spamscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603160114

virtscsi_handle_event() is not used before its definition, so remove
a prior declaration.

Suggested-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
---
 drivers/scsi/virtio_scsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 15ca2a2d7aa4..fe1bf37f1317 100644
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

