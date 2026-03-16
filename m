Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296583A1A35;
	Mon, 16 Mar 2026 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675236; cv=none; b=ogj6t527w2L89R8jesdmYbsRvlQxZBZ1XZAGqmEDrVBqLKgFPu3enU4QupdeH1fIXYG2kd7Ag5ALbFO8DSWrGU7aGVvkljJyFQWnioMIE3cf+Fhmts+aQmWyoNbDTzjDlhojRRYol+sGIxXbgXtwtgRHXxByccF6foC3/E1Oonc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675236; c=relaxed/simple;
	bh=hE5rYVjiRfPJCIf9eXzZQUhfWKiMeU8KcbO5MPNuZzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlQYzadQ8J6NGmgluIL0nU3cZr6yA4eLU2ZVmV4d4WfnVxJTj/J8hhFELGQwJgXUJiuY1O8WNE3QkOe0kWgx4nVeJ0R4Fmv2Ze3rifVqvSAxjIYqcZh09LTbrEx1n6n/HFdhmRRP/iywMsOVM0baP2aG7IWUYtaarLxqv0YNduw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QMqg48G6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QMqg48G6"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GFPlsf717620;
	Mon, 16 Mar 2026 15:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=g+qcf0dnOOiVBF8qp
	pxKPaTTpNVkuDcREhm8Gt9XanM=; b=QMqg48G6SOtRxkjdaX4Bf1ciFNFoLXszY
	HR4HqaiAc8RUTeWKOjDxX3EPwK8gLdlKWohnbRZdzPn+AcDQ/32zWEtN1+YTJhAm
	enPZthZ2gbO1QdkyXSie9nil2oR9egLINVLGA3GYdpts9Bhh8lvaUu8Kndw9EIwj
	IKV78FoNZcO04e8XwiymJKL7tkIW3swzh+0dHHH/uqRQpcJejt6z8HinxnzrgUXb
	Q+EiuqibHY5/5ECqLS0xuWKxcdDOJyKWvwNtuh5MieB5rUJgUHamRgAp7Pj19Fnl
	mKZ1OvFBOhiPwJMaWmn6Pyj+HgzeUaVuB4KSX6qIlgJvgNf/8m1HQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvx3cr8ba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 15:33:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62GEP3C1005380;
	Mon, 16 Mar 2026 15:33:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cwj0s5f9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 15:33:46 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62GFXgqJ35717500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 15:33:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 427D62004D;
	Mon, 16 Mar 2026 15:33:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 17EC020049;
	Mon, 16 Mar 2026 15:33:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 16 Mar 2026 15:33:42 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56370)
	id F365FE0198; Mon, 16 Mar 2026 16:33:41 +0100 (CET)
From: Joshua Daley <jdaley@linux.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        jdaley@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v3 1/3] scsi: virtio_scsi: kick event_list unconditionally
Date: Mon, 16 Mar 2026 16:33:39 +0100
Message-ID: <20260316153341.2062278-2-jdaley@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=arO/yCZV c=1 sm=1 tr=0 ts=69b822db cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=fOgkfDuy17jzwl4HYOQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDExNCBTYWx0ZWRfX7cL9mfKl2YwR
 oqTPHsFUkSq9kyMdxpuw/V9+3fco/eR48T7sIjHgiJFDSyRfntzWLFDn2MLl0mFRWq2FZ5rCxW+
 nQlHLIFCG84eqImRkypGc1P0D4Hk1+f5Yx586xiqVIzOeZ1WsV3MM1GNIS29oPBwqPnHFtM1Asn
 lTANeueNvGQGYWp+C1mB/GD1vqU9JrDEFxbXJEJUsp2UcMTUV73Q2D58Ajuhua5o0WNmyVdIuxN
 BnXAIa5Iat/z8bPNuilrSEIaKX/JXswcvOU0L9ZMNS046dCQSUEuD2rDhiB106JFHuJRzwMLgaE
 gTEVO2dtkX/M0keL2gJSL+AOupI/zmdqTxqZThGgj6rdNv3JDFNSMcXqzhyaJppHJmw7bqcik3s
 nVz2LVKVfELkBzPJZawhhMTg3A5hGnPD54KUFA4m3mY6kLiSBAFOlFyvp5MgNOHR2A609UahB3Y
 7HCVxqcaIihAfxaOS8Q==
X-Proofpoint-GUID: 1ohHNN3-C4YkdJ6CiNOzHQ-9AxSD1eNy
X-Proofpoint-ORIG-GUID: 1ohHNN3-C4YkdJ6CiNOzHQ-9AxSD1eNy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603160114

The event_list processes non-hotplug events (such as LUN capacity
changes), so remove the conditions that guard the initial kicks in
_probe() and _restore(), as well as the work cancellation in _remove().

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
---
 drivers/scsi/virtio_scsi.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0ed8558dad72..982f49bc6c69 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -983,9 +983,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 		goto scsi_add_host_failed;
=20
 	virtio_device_ready(vdev);
-
-	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
-		virtscsi_kick_event_all(vscsi);
+	virtscsi_kick_event_all(vscsi);
=20
 	scsi_scan_host(shost);
 	return 0;
@@ -1002,8 +1000,7 @@ static void virtscsi_remove(struct virtio_device *v=
dev)
 	struct Scsi_Host *shost =3D virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi =3D shost_priv(shost);
=20
-	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
-		virtscsi_cancel_event_work(vscsi);
+	virtscsi_cancel_event_work(vscsi);
=20
 	scsi_remove_host(shost);
 	virtscsi_remove_vqs(vdev);
@@ -1028,9 +1025,7 @@ static int virtscsi_restore(struct virtio_device *v=
dev)
 		return err;
=20
 	virtio_device_ready(vdev);
-
-	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
-		virtscsi_kick_event_all(vscsi);
+	virtscsi_kick_event_all(vscsi);
=20
 	return err;
 }
--=20
2.34.1

